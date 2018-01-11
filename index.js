'use strict';

// global basedir
global.appRootFolder = __dirname;
global.plgBuildMethod = 'client'; // "client" or "server"

module.exports = {
  init: require(appRootFolder + '/lib/commands/init.js'),
  config: require(appRootFolder + '/lib/commands/config'),
  files: require(appRootFolder + '/lib/commands/files'),
  minify: require(appRootFolder + '/lib/commands/minify'),
  build: require(appRootFolder + '/lib/commands/build'),
  help: require(appRootFolder + '/lib/commands/help.js')
};
