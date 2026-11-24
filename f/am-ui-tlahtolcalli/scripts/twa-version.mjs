// scripts/twa-version.mjs
// Copia la versión de package.json al proyecto Android (twa/twa-manifest.json) antes de empaquetar:
//   appVersionName = "4.5.0"   (la que ve el usuario en Android → Info de la app)
//   appVersionCode = 40500     (número que Android exige que siempre suba: mayor·10000 + menor·100 + parche)
// Uso: npm run twa:version   (después: cd twa && bubblewrap update && bubblewrap build)
import { readFileSync, writeFileSync } from 'node:fs'

const pkg = JSON.parse(readFileSync(new URL('../package.json', import.meta.url), 'utf-8'))
const file = new URL('../twa/twa-manifest.json', import.meta.url)
const twa = JSON.parse(readFileSync(file, 'utf-8'))

const [major, minor, patch] = pkg.version.split('-')[0].split('.').map(n => parseInt(n, 10) || 0)
if (minor > 99 || patch > 99) throw new Error(`Versión ${pkg.version}: menor y parche deben ser ≤ 99 para el versionCode`)
const code = major * 10000 + minor * 100 + patch

if (twa.appVersionCode && code < twa.appVersionCode) {
    throw new Error(`versionCode ${code} es menor que el actual (${twa.appVersionCode}): Android no permitiría actualizar`)
}

twa.appVersionName = pkg.version
twa.appVersion = pkg.version
twa.appVersionCode = code
writeFileSync(file, JSON.stringify(twa, null, 2) + '\n')
console.log(`[twa] versión ${pkg.version} (code ${code}) → twa/twa-manifest.json`)
