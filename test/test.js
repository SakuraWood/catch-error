const SourceMapConsumer = require('source-map').SourceMapConsumer

const fs = require('fs')

fs.readFile('./notification.js.map', 'utf-8', function (err, data) {
    if (err) {
        console.log('error')
    } else {
        // console.log(data)
        let rawsource = JSON.parse(data)
        let smc = new SourceMapConsumer(rawsource)
        console.log(smc.sources)
        console.log(smc.originalPositionFor({
            line:55,
            column:26
        }))
    }
})


