'use strict';

// global basedir
global.appRootFolder = __dirname.replace('/apex-plugin-dev-enhancer/lib', '/apex-plugin-dev-enhancer');

module.exports = {
  init: require(appRootFolder + '/lib/commands/init.js'),
  config: require(appRootFolder + '/lib/commands/config'),
  files: require(appRootFolder + '/lib/commands/files'),
  build: require(appRootFolder + '/lib/commands/build'),
  help: require(appRootFolder + '/lib/commands/help.js')
};