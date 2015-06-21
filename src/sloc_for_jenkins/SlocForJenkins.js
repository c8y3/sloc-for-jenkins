sloc_for_jenkins.SlocForJenkins = function(commander, sloc, fs, readdirp, path, version) {
    var self = {};
    self.start = function() {
        commander
            .version(version)
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
    };

    return self;
};


