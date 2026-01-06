const { ZipFile } = require('yazl')
const fs = require('fs')
const esbuild = require('esbuild')

const artefactPath = 'dist'

const buildArtefact = async (entryPoint, outputPath) => {
    await esbuild.build({
        entryPoints: [entryPoint],
        tsconfig: './tsconfig.json',
        bundle: true,
        minify: true,
        sourcemap: true,
        outfile: `${outputPath}/lambda.js`,
        platform: 'node',
        target: 'node16',
        external: ['aws-sdk']
    })

    const zipfile = new ZipFile()
    zipfile.addFile(`${outputPath}/lambda.js.map`, 'main.lambda.map')
    zipfile.addFile(`${outputPath}/lambda.js`, 'lambda.js')
    zipfile.outputStream
        .pipe(fs.createWriteStream(`${outputPath}/lambda.zip`))
        .on('close', () => {
            console.log('Lambda artefact zipped successfully')
        })
    zipfile.end()
}

Promise.all([
    buildArtefact('./src/lambdas/create-chat/lambda.ts', artefactPath)
]).catch((error) => {
    console.error(error)
    process.exit(1)
})
