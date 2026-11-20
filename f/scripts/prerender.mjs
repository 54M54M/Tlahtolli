// Después de `vite build`: genera el HTML de las páginas públicas y el shell vacío de la app.
//   dist/index.html            portada prerenderizada
//   dist/<ruta>/index.html     novedades, privacidad, términos prerenderizadas
//   dist/spa.html              shell sin contenido para /app/… y demás rutas (netlify.toml)
import fs from 'node:fs'
import path from 'node:path'
import { pathToFileURL } from 'node:url'

const DIST = path.resolve('dist')
const SSR_DIR = path.resolve('.prerender')
const template = fs.readFileSync(path.join(DIST, 'index.html'), 'utf8')
const entry = fs.readdirSync(SSR_DIR).find((f) => /^entry-prerender\.(m?js)$/.test(f))
const { render, PAGES, SITE_URL } = await import(pathToFileURL(path.join(SSR_DIR, entry)).href)

const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;')

function setMeta(html, attr, key, value) {
    const re = new RegExp(`(<meta\\s+${attr}="${key}"\\s+content=")[^"]*(")`, 'i')
    return re.test(html) ? html.replace(re, `$1${esc(value)}$2`) : html
}

function withHead(html, { title, description, url }) {
    html = html.replace(/<title>[\s\S]*?<\/title>/, `<title>${esc(title)}</title>`)
    html = html.replace(/(<link\s+rel="canonical"\s+href=")[^"]*(")/, `$1${url}$2`)
    for (const [attr, key, value] of [
        ['name', 'description', description],
        ['property', 'og:url', url],
        ['property', 'og:title', title],
        ['property', 'og:description', description],
        ['name', 'twitter:title', title],
        ['name', 'twitter:description', description],
    ]) html = setMeta(html, attr, key, value)
    return html
}

// Shell de la app: sin contenido, no indexable, sin canonical a la portada
let spa = template
    .replace(/<link\s+rel="canonical"[^>]*>\s*/, '')
    .replace(/<meta\s+name="robots"\s+content="[^"]*"\s*\/?>/, '<meta name="robots" content="noindex, follow" />')
fs.writeFileSync(path.join(DIST, 'spa.html'), spa)

for (const page of PAGES) {
    const appHtml = await render(page.path)
    const url = SITE_URL + (page.path === '/' ? '/' : page.path)
    let html = withHead(template, { title: page.title, description: page.description, url })
    html = html.replace('<div id="app"></div>', `<div id="app">${appHtml}</div>`)
    const file = page.path === '/' ? path.join(DIST, 'index.html') : path.join(DIST, page.path, 'index.html')
    fs.mkdirSync(path.dirname(file), { recursive: true })
    fs.writeFileSync(file, html)
    console.log(`[prerender] ${page.path.padEnd(12)} → ${path.relative(DIST, file)} (${(appHtml.length / 1024).toFixed(1)} KB)`)
}

fs.rmSync(SSR_DIR, { recursive: true, force: true })

// Sitio de desarrollo (VITE_APP_ENV=dev en Netlify): que Google no lo indexe
if (process.env.VITE_APP_ENV === 'dev') {
    fs.writeFileSync(path.join(DIST, 'robots.txt'), 'User-agent: *\nDisallow: /\n')
    fs.rmSync(path.join(DIST, 'sitemap.xml'), { force: true })
    fs.writeFileSync(path.join(DIST, '_headers'), '/*\n  X-Robots-Tag: noindex, nofollow\n')
    for (const f of fs.readdirSync(DIST, { recursive: true }).filter((f) => String(f).endsWith('.html'))) {
        const file = path.join(DIST, String(f))
        const html = fs.readFileSync(file, 'utf8')
            .replace(/<meta\s+name="robots"\s+content="[^"]*"\s*\/?>/, '<meta name="robots" content="noindex, nofollow" />')
        fs.writeFileSync(file, html)
    }
    console.log('[prerender] sitio de desarrollo: noindex, robots.txt sin acceso')
}
