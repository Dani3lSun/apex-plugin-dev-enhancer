'use strict';

const prompt = require('prompt');
const chalk = require('chalk');
const fshelper = require(appRootFolder + '/lib/util/fshelper.js');
const utils = require(appRootFolder + '/lib/util/utils.js');

module.exports = function(args) {

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
      }
    }
  };

  // Get all necessary parameters from user to initialize plugin folder structure
  prompt.get(schema, function(err, result) {
    if (result) {
      // get vars
      var shortPlgName = utils.getShortPluginName(result.plgName);
      var prettyPlgName = utils.getPrettyPluginName(result.plgName);

      // create init folder structure based on JSON + replace some values
      var folderStructureJson = {};
      var folderStructureContent = fshelper.readFile(appRootFolder + '/lib/templates/folderStructure.json');
      folderStructureContent = folderStructureContent.replace(/#plg_short_name#/g, shortPlgName);
      folderStructureContent = folderStructureContent.replace(/#working_dir#/g, process.cwd());
      try {
        folderStructureJson = JSON.parse(folderStructureContent);
      } catch (err) {
        console.log('init: parse folder structure error');
        return;
      }
      fshelper.createFolderStructure(folderStructureJson, function() {

        // write apexplugin.json + set some values inside
        fshelper.findFile(process.cwd(), 'apexplugin.json', function(apexpluginjsonPath) {
          var apexpluginjsonContent = fshelper.readJsonFile(appRootFolder + '/lib/templates/apexplugin.json');
          apexpluginjsonContent.name = prettyPlgName;
          apexpluginjsonContent.oracle.apex.plugin.internalName = result.plgName;
          apexpluginjsonContent.oracle.apex.plugin.type = result.plgType.replace('_', ' ');
          apexpluginjsonContent.keywords.push(result.plgType);
          fshelper.writeJsonFile(apexpluginjsonPath, apexpluginjsonContent);

          // write pl/sql package spec & body for different plugin types
          switch (result.plgType) {
            case 'item':
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pks', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/item_plg.pks', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pkb', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/item_plg.pkb', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              break;
            case 'region':
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pks', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/region_plg.pks', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pkb', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/region_plg.pkb', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              break;
            case 'dynamic_action':
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pks', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/dynamic_action_plg.pks', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pkb', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/dynamic_action_plg.pkb', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              break;
            case 'process':
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pks', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/process_plg.pks', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pkb', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/process_plg.pkb', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              break;
            case 'authentication':
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pks', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/authentication_plg.pks', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pkb', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/authentication_plg.pkb', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              break;
            case 'authorization':
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pks', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/authorization_plg.pks', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              fshelper.findFile(process.cwd(), shortPlgName + '_plg_pkg.pkb', function(filePath) {
                fshelper.copyFile(appRootFolder + '/lib/templates/db/authorization_plg.pkb', filePath);
                fshelper.replaceTextInFile(filePath, /#plg_short_name#/g, shortPlgName);
              });
              break;
          }

          process.stdout.write('\n' + chalk.blue.bold('Plug-in project initialized!') + '\n\n');
        });
      });
    }
  });
};
