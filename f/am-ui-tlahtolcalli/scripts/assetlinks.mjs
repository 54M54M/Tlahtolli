// scripts/assetlinks.mjs
// Publica /.well-known/assetlinks.json: le dice a Android que la app empaquetada (TWA) es de este sitio.
// Sin él, la app abre igual pero con la barra de dirección del navegador arriba.
//
// Variables (Netlify → Site configuration → Environment variables), solo en el sitio de prod:
//   TWA_SHA256_FINGERPRINTS  huella(s) SHA-256 de la llave con que se firma el APK, separadas por coma
//                            (bubblewrap fingerprint list · si se sube a Google Play, agregar también
//                            la de "Firma de apps de Google Play")
//   TWA_PACKAGE_ID           opcional; por defecto el de twa/twa-manifest.json
// Si no hay huellas, no se genera nada.
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'

const fingerprints = (process.env.TWA_SHA256_FINGERPRINTS || '')
    .split(/[\s,]+/).map(f => f.trim().toUpperCase()).filter(Boolean)

if (!fingerprints.length) {
    console.log('[assetlinks] sin TWA_SHA256_FINGERPRINTS: no se genera /.well-known/assetlinks.json')
    process.exit(0)
}

const bad = fingerprints.filter(f => !/^([0-9A-F]{2}:){31}[0-9A-F]{2}$/.test(f))
if (bad.length) {
    console.error('[assetlinks] huella(s) con formato inválido (se espera AA:BB:…, 32 pares):', bad.join(', '))
    process.exit(1)
}

let packageId = process.env.TWA_PACKAGE_ID
if (!packageId) {
    packageId = JSON.parse(readFileSync(new URL('../twa/twa-manifest.json', import.meta.url), 'utf-8')).packageId
}

const links = [{
    relation: ['delegate_permission/common.handle_all_urls'],
    target: { namespace: 'android_app', package_name: packageId, sha256_cert_fingerprints: fingerprints },
}]

const dir = new URL('../dist/.well-known/', import.meta.url)
mkdirSync(dir, { recursive: true })
writeFileSync(new URL('assetlinks.json', dir), JSON.stringify(links, null, 2) + '\n')
console.log(`[assetlinks] ${packageId} con ${fingerprints.length} huella(s) → dist/.well-known/assetlinks.json`)
