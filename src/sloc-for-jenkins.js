var package = require('../package.json');
var commander = require('commander');
var sloc = require('sloc');
var fs = require('fs');
var readdirp = require('readdirp');
var path = require('path');

commander
    .version(package.version)
    .usage('directory [options]')
    .option('-o, --output [filepath]', 'path to output file, default value is sloccount.sc')
    .parse(process.argv);

var outputFileName = 'sloccount.sc';
if (commander.output !== undefined) outputFileName = commander.output;
if (commander.args.length !== 1) {
    console.log('Missing directory name');
    commander.help();
}

var directoryPath = commander.args[0];

var extension = 'js';
var outputFile = fs.openSync(outputFileName, 'w');
var stream = readdirp({ root: directoryPath, fileFilter: '*.' + extension });
stream.on('data', function(entry) {
    fs.readFile(entry.fullPath, 'utf8', function(error, content) {
        if (error) {
            console.log(error);
            return;
        }
        var statistics = sloc(content, extension);
        var lineCount = statistics.source;
        var filePath = entry.path;
        var directoryName = path.dirname(filePath);
        if (directoryName === '.') directoryName = '';
        var namespace = directoryName.replace(new RegExp('/', 'g'), '.');
        var fileResult = lineCount + '\t' + extension + '\t' + namespace + '\t' + filePath + '\n';
        fs.writeSync(outputFile, fileResult);
    });
});

