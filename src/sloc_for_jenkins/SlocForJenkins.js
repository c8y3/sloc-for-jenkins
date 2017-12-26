var Stargs = require('stargs');

sloc_for_jenkins.SlocForJenkins = function(commander, sloc, fs, readdirp, path, version) {

    function count(directoryPath, outputFileName) {
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
                var namespace = directoryName.replace(new RegExp('/', 'g'), '.');
                var fileResult = lineCount + '\t' + extension + '\t' + namespace + '\t' + filePath + '\n';
                fs.writeSync(outputFile, fileResult);
            });
        });
    }

    var self = {};

    self.start = function() {
        var parser = Stargs({
            args: 'directory',
            options: {
                version: {
                    short: 'V',
                    description: 'output the version number'
                },
                output: {
                    short: 'o',
                    type: 'string',
                    description: 'path to output file, default value is sloccount.sc'
                }
            }
        });
        try {
            const result = parser.parse(process.argv);
            // TODO implement a version option in Stargs (see how to output several things on a module)
            if (result.version) {
                console.log(version);
                return;
            }
            // TODO implement a default value in Stargs
            var outputFileName = result.output;
            if (outputFileName === undefined) {
                outputFileName = 'sloccount.sc';
            }
            // TODO add boolean multiple by default to false in Stargs (breaks API)
            if (result.args.length !== 1) {
                console.log('Missing directory name');
                // TODO should output the help here...
                return;
            }
            count(result.args[0], outputFileName);
        } catch (e) {
            console.log(e.message);
        }
    };

    return self;
};


