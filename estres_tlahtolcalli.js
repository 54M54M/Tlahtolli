// Prueba de estrés — Tlahtolcalli (k6)
// Simula el uso real: cada usuario virtual inicia sesión UNA vez (como en la app, que guarda
// la sesión) y después navega en bucle: idiomas → niveles → unidades → ejercicios →
// vocabulario → glosario → logros. SOLO LECTURA: no completa lecciones ni gasta energía,
// así que no altera el progreso del usuario de prueba.
//
// Uso:
//   cd /D D:\dev\source\tlahtolli
//   ren estres_tlahtolcalli.js estres_tlahtolcalli.js
//   k6 run -e USER=**** -e PASS=**** -e PERFIL=suave estres_tlahtolcalli.js
//   (opcional) -e BASE=https://... -e PERFIL=suave|medio|fuerte
//
// Antes de correrlo: abre /api/health para despertar el servicio (Render free duerme a los 15 min).

import http from 'k6/http';
import { check, group, sleep, fail } from 'k6';
import { Trend, Rate } from 'k6/metrics';

const BASE = __ENV.BASE || 'https://ar-cs-tlahtolcalli.onrender.com/api';
const USER = __ENV.USER;
const PASS = __ENV.PASS;
if (!USER || !PASS) throw new Error('Faltan credenciales: usa -e USER=... -e PASS=...');

// Perfiles de carga (usuarios virtuales simultáneos)
const PERFILES = {
    suave:  [{ duration: '30s', target: 5 },  { duration: '1m', target: 5 },  { duration: '20s', target: 0 }],
    medio:  [{ duration: '30s', target: 10 }, { duration: '1m', target: 25 }, { duration: '1m', target: 25 }, { duration: '30s', target: 0 }],
    fuerte: [{ duration: '30s', target: 25 }, { duration: '1m', target: 50 }, { duration: '1m', target: 100 }, { duration: '1m', target: 100 }, { duration: '30s', target: 0 }],
};

export const options = {
    stages: PERFILES[__ENV.PERFIL || 'medio'],
    thresholds: {
        http_req_failed: ['rate<0.02'],               // menos de 2 % de errores
        http_req_duration: ['p(95)<1500'],            // 95 % de las respuestas en menos de 1.5 s
        'tiempo_login': ['p(95)<2000'],
        'tiempo_ejercicios': ['p(95)<1500'],
    },
    summaryTrendStats: ['avg', 'min', 'med', 'p(90)', 'p(95)', 'max'],
};

const tLogin = new Trend('tiempo_login', true);
const tEjercicios = new Trend('tiempo_ejercicios', true);
const errores = new Rate('errores_funcionales');
const JSON_H = { headers: { 'Content-Type': 'application/json' } };

function get(path, tag) {
    const r = http.get(`${BASE}${path}`, { tags: { endpoint: tag } });
    errores.add(!check(r, { [`${tag} 200`]: (x) => x.status === 200 }));
    return r;
}
const body = (r) => { try { return r.json(); } catch { return null; } };
const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];

// Se ejecuta una vez: comprueba que el servicio esté despierto
export function setup() {
    const h = http.get(`${BASE}/health`, { timeout: '90s' });
    if (h.status !== 200) fail(`El backend no responde (/health → ${h.status}). Despiértalo e intenta de nuevo.`);
    return {};
}

// Sesión por usuario virtual: cada VU conserva sus variables entre iteraciones
let user = null;

function login() {
    group('login', () => {
        const r = http.post(`${BASE}/auth/login`, JSON.stringify({ username: USER, password: PASS }), { ...JSON_H, tags: { endpoint: 'login' } });
        tLogin.add(r.timings.duration);
        errores.add(!check(r, { 'login 200': (x) => x.status === 200 }));
        const u = body(r);
        user = u && u.id ? u : null;
    });
}

export default function () {
    let languages, levels, units;

    if (!user) {                      // solo la primera vez (o si el login falló)
        login();
        if (!user) { sleep(2); return; }
        sleep(1);
    }

    group('idiomas', () => { languages = body(get('/languages', 'languages')) || []; });
    if (!languages.length) return;
    const lang = pick(languages);
    sleep(1);

    group('niveles y unidades', () => {
        levels = body(get(`/learning/levels?languageId=${lang.id}&userId=${user.id}`, 'levels')) || [];
        if (levels.length) units = body(get(`/learning/levels/${levels[0].id}/units?userId=${user.id}`, 'units')) || [];
        get(`/energy/user/${user.id}`, 'energy');
        get(`/user-stats?userId=${user.id}&languageId=${lang.id}`, 'stats');
    });
    sleep(2);

    if (units && units.length) {
        const unit = pick(units);
        group('lección (solo lectura)', () => {
            const r = get(`/learning/units/${unit.id}/exercises`, 'exercises');
            tEjercicios.add(r.timings.duration);
            get(`/learning/units/${unit.id}/vocabulary`, 'vocabulary');
        });
        sleep(3);
    }

    group('glosario y perfil', () => {
        get(`/writing-systems?languageId=${lang.id}`, 'writing-systems');
        get(`/user-achievements?userId=${user.id}&languageTag=${lang.code}`, 'achievements');
        get(`/lesson-history?userId=${user.id}`, 'history');
    });
    sleep(2);
}
