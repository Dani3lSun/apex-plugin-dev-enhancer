'use strict';

// global basedir
global.appRootFolder = __dirname;
global.plgBuildMethod = 'client'; // "client" or "server"

module.exports = {
  init: require(appRootFolder + '/lib/commands/init.js'),
  config: require(appRootFolder + '/lib/commands/config.js'),
  files: require(appRootFolder + '/lib/commands/files.js'),
  minify: require(appRootFolder + '/lib/commands/minify.js'),
  build: require(appRootFolder + '/lib/commands/build.js'),
  help: require(appRootFolder + '/lib/commands/help.js')
};
