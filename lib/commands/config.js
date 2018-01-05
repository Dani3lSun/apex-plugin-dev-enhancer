'use strict';

const prompt = require('prompt');
const chalk = require('chalk');
const fshelper = require(appRootFolder + '/lib/util/fshelper.js');

module.exports = function(args) {

  // check if apdeconfig.json is already present in project root
  if (fshelper.pathExists(process.cwd() + '/apdeconfig.json')) {
    process.stdout.write('\n' + chalk.blue.bold('apdeconfig.json already present in project root. Will be overwritten!!') + '\n\n');
  }

  // Start the prompt
  prompt.start();

  // definition of prompt parameters
  var schema = {
    properties: {
      plgName: {
        description: chalk.blue.bold('Enter Plug-in Internal Name'),
        type: 'string',
        required: true
      },
      plgType: {
        description: chalk.blue.bold('Enter Plug-in Type [item, region, dynamic_action, process, authentication, authorization]'),
        type: 'string',
        required: true,
        message: 'Invalid input for Plug-in Type',
        conform: function(value) {
          if (value == 'item' || value == 'region' || value == 'dynamic_action' || value == 'process' || value == 'authentication' || value == 'authorization') {
            return true;
          } else {
            return false;
          }
        }
      },
      appId: {
        description: chalk.blue.bold('Enter APP_ID of the Plug-ins application'),
        type: 'number',
        required: true
      },
      dbHost: {
        description: chalk.blue.bold('Enter DB host address'),
        type: 'string',
        required: true
      },
      dbPort: {
        description: chalk.blue.bold('Enter DB listener port'),
        type: 'number',
        required: true
      },
      dbSid: {
        description: chalk.blue.bold('Enter DB SID or service name'),
        type: 'string',
        required: true
      },
      dbUsername: {
        description: chalk.blue.bold('Enter username of your workspace DB schema'),
        type: 'string',
        required: true
      },
      dbPassword: {
        description: chalk.blue.bold('Enter password of your workspace DB schema'),
        type: 'string',
        required: true,
        hidden: true,
        replace: '*'
      },
      srcApexFolder: {
        description: chalk.blue.bold('Enter path of APEX src (Plug-in export sql) [only if path is different to standard init path]'),
        type: 'string',
        required: false
      },
      srcDbFolder: {
        description: chalk.blue.bold('Enter path of DB objects/sources [only if path is different to standard init path]'),
        type: 'string',
        required: false
      },
      srcFilesFolder: {
        description: chalk.blue.bold('Enter path of static files (JS/CSS) sources [only if path is different to standard init path]'),
        type: 'string',
        required: false
      },
      distFolder: {
        description: chalk.blue.bold('Enter path of dist folder [only if path is different to standard init path]'),
        type: 'string',
        required: false
      },
      sqlclPath: {
        description: chalk.blue.bold('Enter path of SQLcl binary [only if SQLcl isn´t already in your PATH]'),
        type: 'string',
        required: false
      }
    }
  };

  // Get all necessary parameters from user to initialize plugin folder structure
  prompt.get(schema, function(err, result) {
    if (result) {
      // create apdeconfig.json in project root based on JSON + replace some values
      var apdeConfigJson = fshelper.readJsonFile(appRootFolder + '/lib/templates/apdeconfig.json');
      apdeConfigJson.plugin.name = result.plgName;
      apdeConfigJson.plugin.type = result.plgType;
      apdeConfigJson.plugin.appId = result.appId;
      apdeConfigJson.database.host = result.dbHost;
      apdeConfigJson.database.port = result.dbPort;
      apdeConfigJson.database.sid = result.dbSid;
      apdeConfigJson.database.username = result.dbUsername;
      apdeConfigJson.database.password = result.dbPassword;
      if (result.srcApexFolder) {
        apdeConfigJson.folders.srcApexFolder = result.srcApexFolder;
      }
      if (result.srcDbFolder) {
        apdeConfigJson.folders.srcDbFolder = result.srcDbFolder;
      }
      if (result.srcFilesFolder) {
        apdeConfigJson.folders.srcFilesFolder = result.srcFilesFolder;
      }
      if (result.distFolder) {
        apdeConfigJson.folders.distFolder = result.distFolder;
      }
      if (result.sqlclPath) {
        apdeConfigJson.sqlclPath = result.sqlclPath;
      }
      fshelper.writeJsonFile(process.cwd() + '/apdeconfig.json', apdeConfigJson);

      process.stdout.write('\n' + chalk.blue.bold('APDE config (apdeconfig.json) successfully created!') + '\n\n');
    }
  });
};
