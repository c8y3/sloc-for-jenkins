var package = require('../package.json');
var commander = require('commander');
var sloc = require('sloc');
var fs = require('fs');
var readdirp = require('readdirp');
var path = require('path');

var program = sloc_for_jenkins.SlocForJenkins(commander, sloc, fs, readdirp, path, package.version);
program.start();

