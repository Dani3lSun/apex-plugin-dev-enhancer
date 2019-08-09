'use strict';

const chalk = require('chalk');
const publisher = require('apex-publish-static-files');
const fshelper = require(appRootFolder + '/lib/util/fshelper.js');
const utils = require(appRootFolder + '/lib/util/utils.js');

module.exports = function(args) {

  // check if apdeconfig.json is already present in project root
  if (!(fshelper.pathExists(process.cwd() + '/apdeconfig.json'))) {
    process.stdout.write('\n' + chalk.blue.bold('apdeconfig.json not present in project root!') + '\n');
    process.stdout.write('\nRun: ' + chalk.blue.bold('apde config') + ' to create it!\n\n');
    process.exit();
  }
  const apdeConfig = require(process.cwd() + '/apdeconfig.json');

  // cleanup src files folder
  var badFileList1 = fshelper.getFileList(process.cwd() + '/' + apdeConfig.folders.srcFilesFolder, '^.*.DS_Store$');
  for (var i = 0; i < badFileList1.length; i++) {
    fshelper.deleteFileFolder(badFileList1[i]);
  }

  // publish files
  publisher.publish({
    connectString: utils.getConnectionString(apdeConfig),
    directory: apdeConfig.folders.srcFilesFolder,
    appID: apdeConfig.plugin.appId,
    destination: 'plugin',
    pluginName: apdeConfig.plugin.name
  });

  process.stdout.write('\n' + chalk.blue.bold('Static Plug-in files successfully published!') + '\n\n');
};
