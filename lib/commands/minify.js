'use strict';

const chalk = require('chalk');
const compressor = require('node-minify');
const path = require('path');
const fshelper = require(appRootFolder + '/lib/util/fshelper.js');

module.exports = function(args) {

  // check if apdeconfig.json is already present in project root
  if (!(fshelper.pathExists(process.cwd() + '/apdeconfig.json'))) {
    process.stdout.write('\n' + chalk.blue.bold('apdeconfig.json not present in project root!') + '\n');
    process.stdout.write('\nRun: ' + chalk.blue.bold('apde config') + ' to create it!\n\n');
    process.exit();
  }
  const apdeConfig = require(process.cwd() + '/apdeconfig.json');

  // minify files
  var filesSrcPath = path.resolve(process.cwd() + '/' + apdeConfig.folders.srcFilesFolder);

  // js files
  var jsFileList = fshelper.getFileList(filesSrcPath, '^.*.js$');
  for (var i = 0; i < jsFileList.length; i++) {
    // only process not minified files
    if (!(jsFileList[i].substring(jsFileList[i].length - 7) == '.min.js')) {
      console.log('Process: ' + jsFileList[i]);
      // compress using UglifyJS
      compressor.minify({
        compressor: 'uglifyjs',
        input: jsFileList[i],
        output: jsFileList[i].substring(0, jsFileList[i].length - 3) + '.min.js',
        callback: function(err) {
          if (err) {
            process.stdout.write('\n' + chalk.blue.bold('JavaScript compression error!') + '\n');
            process.stdout.write('\nFile: ' + chalk.blue.bold(jsFileList[i]) + '\n');
            process.stdout.write('\n' + err + '\n\n');
            process.exit();
          }
        }
      });
    }
  }
  // css files
  var cssFileList = fshelper.getFileList(filesSrcPath, '^.*.css$');
  for (var j = 0; j < cssFileList.length; j++) {
    // only process not minified files
    if (!(cssFileList[j].substring(cssFileList[j].length - 8) == '.min.css')) {
      console.log('Process: ' + cssFileList[j]);
      // compress using CSSO
      compressor.minify({
        compressor: 'csso',
        input: cssFileList[j],
        output: cssFileList[j].substring(0, cssFileList[j].length - 4) + '.min.css',
        callback: function(err) {
          if (err) {
            process.stdout.write('\n' + chalk.blue.bold('CSS compression error!') + '\n');
            process.stdout.write('\nFile: ' + chalk.blue.bold(cssFileList[j]) + '\n');
            process.stdout.write('\n' + err + '\n\n');
            process.exit();
          }
        }
      });
    }
  }

  process.stdout.write('\n' + chalk.blue.bold('Files in ' + filesSrcPath + ' successfully minified!') + '\n\n');
};
