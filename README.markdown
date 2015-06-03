# sloc-for-jenkins

Counts lines of JavaScript code and outputs the result into the format expected by the sloccount Jenkins plugin.

## Install

```
npm install sloc-for-jenkins
```

## Usage

```
sloc-for-jenkins [options] directory
```

Options:

```
-h, --help               output usage information
-V, --version            output the version number
-o, --output [filepath]  path to output file, default value is sloccount.sc
```

e.g.:

```
$ sloc-for-jenkins src/
```

## License

sloc-for-jenkins is licensed under the GPL-3.0 license
