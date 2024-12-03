/*
------------------------------------------------------
---- FS25 Mod ZIP Builder ----------------------------
------------------------------------------------------
---- You'll need "glob" and "adm-zip" installed ------
---- globally.  Set the zip name below, source  ------
---- assumed to be in ./src                     ------
------------------------------------------------------
*/

const zipName = "FS25_SimpleInspector"

const glob   = require("glob")
const path   = require('path');
const AdmZip = require("adm-zip");
const fs     = require('fs')

const filesToAdd = glob.sync("../src/**", {nodir: true})
const zipPath    = path.join("../" + zipName + ".zip")
const zipPathUp  = path.join("../" + zipName + "_update.zip")

console.log("Refreshing ZIP File...")

var zip = new AdmZip();

filesToAdd.forEach((file) => {
	const relPath   = path.relative("../src/", file)
	const zipFolder = path.dirname(relPath)

	zip.addLocalFile(file, ( zipFolder == "." ? null : zipFolder ) );

	console.log("  Adding:" + path.relative("../src/", file))
})

if ( fs.existsSync(zipPath)) {
	console.log("  Removing Stale ZIP file")
	fs.rmSync(zipPath)
	fs.rmSync(zipPathUp)
}

console.log("  Writing New ZIP File (and update)")
zip.writeZip(zipPath)
fs.copyFileSync(zipPath, zipPathUp)
console.log("Done.")