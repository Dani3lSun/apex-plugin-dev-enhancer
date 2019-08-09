'use strict';

const chalk = require('chalk');
const execSync = require('child_process').execSync;
const path = require('path');
const publisher = require('apex-publish-static-files');
const fshelper = require(appRootFolder + '/lib/util/fshelper.js');
const utils = require(appRootFolder + '/lib/util/utils.js');
const pkg = require(appRootFolder + '/package.json');

module.exports = function(args) {

  // check if apdeconfig.json is already present in project root
  if (!(fshelper.pathExists(process.cwd() + '/apdeconfig.json'))) {
    process.stdout.write('\n' + chalk.blue.bold('apdeconfig.json not present in project root!') + '\n');
    process.stdout.write('\nRun: ' + chalk.blue.bold('apde config') + ' to create it!\n\n');
    process.exit();
  }
  const apdeConfig = require(process.cwd() + '/apdeconfig.json');
  var sqlclPath = apdeConfig.sqlclPath || 'sql';

  // plugin names
  var cleanPlgName = utils.getCleanPluginName(apdeConfig.plugin.name);
  var shortPlgName = utils.getShortPluginName(apdeConfig.plugin.name);
  var distPlgName = utils.getDistPluginName(apdeConfig.plugin.name, apdeConfig.plugin.type);

  // create temp working dir
  fshelper.mkDir(process.cwd() + '/tmp');

  // start output
  process.stdout.write('\n' + chalk.blue.bold('Now building Plug-in with APDE...') + '\n');

  // conditional compile - check if APDE_PKG exists, if not: compile package
  if (plgBuildMethod == 'server') {
    const childProcessCompPkg = execSync(
      '"' + sqlclPath + '"' + // SQLcl path
      ' ' + utils.getConnectionString(apdeConfig) + // Connect string (user/pass@server:port/sid)
      ' @"' + path.resolve(appRootFolder + '/lib/util/sqlcl/cond_comp_apde_pkg') + '"' + // SQL to execute
      ' "' + path.resolve(appRootFolder + '/lib/util/sqlcl') + '"' + // Param &1 (execute path)
      ' "' + pkg.version + '"' // Param &2 (package version)
      , {
        encoding: 'utf8'
      });
    console.log(childProcessCompPkg);
    // check for ORA message
    if (childProcessCompPkg.includes('ORA-')) {
      process.stdout.write('\n' + chalk.blue.bold('Database error occured...') + '\n\n');
      process.exit();
    }
    process.stdout.write('\n' + chalk.blue.bold('APDE package and necessary DB objects compiled or already in place.') + '\n');
    process.stdout.write('\n' + chalk.blue.bold('Now uploading static Plug-in files...') + '\n\n');
  }

  // publish static plugin files
  // cleanup src files folder
  var badFileList1 = fshelper.getFileList(process.cwd() + '/' + apdeConfig.folders.srcFilesFolder, '^.*.DS_Store$');
  for (var i = 0; i < badFileList1.length; i++) {
    fshelper.deleteFileFolder(badFileList1[i]);
  }
  publisher.publish({
    connectString: utils.getConnectionString(apdeConfig),
    directory: apdeConfig.folders.srcFilesFolder,
    appID: apdeConfig.plugin.appId,
    destination: 'plugin',
    pluginName: apdeConfig.plugin.name
  });
  process.stdout.write('\n' + chalk.blue.bold('Static Plug-in files successfully uploaded.') + '\n');
  process.stdout.write('\n' + chalk.blue.bold('Now exporting Plug-in SQL file...') + '\n\n');

  // APEX Export
  const childProcessApexExport = execSync(
    '"' + sqlclPath + '"' + // SQLcl path
    ' ' + utils.getConnectionString(apdeConfig) + // Connect string (user/pass@server:port/sid)
    ' @"' + path.resolve(appRootFolder + '/lib/util/sqlcl/apex_export') + '"' + // SQL to execute
    ' "' + path.resolve(process.cwd() + '/tmp') + '"' + // Param &1 (export path)
    ' "' + apdeConfig.plugin.appId + '"' // Param &2 (APP_ID)
    , {
      encoding: 'utf8'
    });
  console.log(childProcessApexExport);
  // check for ORA message
  if (childProcessApexExport.includes('ORA-')) {
    process.stdout.write('\n' + chalk.blue.bold('Database error occured...') + '\n\n');
    process.exit();
  }

  // move plugin export to APEX source folder
  var plgFilePath = process.cwd() + '/tmp/f' + apdeConfig.plugin.appId + '/application/shared_components/plugins/' + utils.getApexExportPluginFolderName(apdeConfig.plugin.type) + '/' + cleanPlgName + '.sql';
  var initFilePath = process.cwd() + '/tmp/f' + apdeConfig.plugin.appId + '/application/init.sql';
  var endFilePath = process.cwd() + '/tmp/f' + apdeConfig.plugin.appId + '/application/end_environment.sql';
  var plgFileSrcPath = process.cwd() + '/' + apdeConfig.folders.srcApexFolder + '/' + cleanPlgName + '.sql';

  var plgFileContent = fshelper.readFile(plgFilePath);
  var initFileContent = fshelper.readFile(initFilePath);
  var endFileContent = fshelper.readFile(endFilePath);
  // enable import end component export
  endFileContent = endFileContent.replace('wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));', 'wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);');

  fshelper.writeFile(plgFileSrcPath, initFileContent + plgFileContent + endFileContent);

  process.stdout.write('\n' + chalk.blue.bold('Plug-in SQL file exported successfully.') + '\n');
  process.stdout.write('\n' + chalk.blue.bold('Now building final Plug-in file for dist...') + '\n\n');

  // build final plugin export file for dist folder
  var distFilePath = process.cwd() + '/' + apdeConfig.folders.distFolder + '/' + distPlgName + '.sql';

  fshelper.deleteFileFolder(distFilePath);

  // just use exported plugin file also as dist file
  if (apdeConfig.plugin.addPackageCodeToDist === 'N') {
    fshelper.writeFile(distFilePath, initFileContent + plgFileContent + endFileContent);
    // concatenate PL/SQL package to dist plugin file
  } else if (apdeConfig.plugin.addPackageCodeToDist === 'Y') {
    // server side build
    if (plgBuildMethod == 'server') {
      var pkgSpecContent = fshelper.removeTrailingSlahesFromFile(process.cwd() + '/' + apdeConfig.folders.srcDbFolder + '/' + shortPlgName + '_plg_pkg.pks');
      var pkgBodyContent = fshelper.removeTrailingSlahesFromFile(process.cwd() + '/' + apdeConfig.folders.srcDbFolder + '/' + shortPlgName + '_plg_pkg.pkb');

      fshelper.writeFile(process.cwd() + '/tmp/' + shortPlgName + '_plg_pkg.pks', pkgSpecContent);
      fshelper.writeFile(process.cwd() + '/tmp/' + shortPlgName + '_plg_pkg.pkb', pkgBodyContent);

      const childProcessBuildDist = execSync(
        '"' + sqlclPath + '"' + // SQLcl path
        ' ' + utils.getConnectionString(apdeConfig) + // Connect string (user/pass@server:port/sid)
        ' @"' + path.resolve(appRootFolder + '/lib/util/sqlcl/build_plg_dist_file') + '"' + // SQL to execute
        ' "' + path.resolve(appRootFolder + '/lib/util/sqlcl') + '"' + // Param &1 (execute path)
        ' "' + path.resolve(process.cwd() + '/' + apdeConfig.folders.srcApexFolder + '/' + cleanPlgName + '.sql') + '"' + // Param &2 (plg file path)
        ' "' + path.resolve(process.cwd() + '/tmp/' + shortPlgName + '_plg_pkg.pks') + '"' + // Param &3 (pkg spec path)
        ' "' + path.resolve(process.cwd() + '/tmp/' + shortPlgName + '_plg_pkg.pkb') + '"' + // Param &4 (pkg body path)
        ' "' + path.resolve(distFilePath) + '"' + // Param &5 (dist path)
        ' "' + shortPlgName + '_plg_pkg"' // Param &6 (plg package name)
        , {
          encoding: 'utf8'
        });
      console.log(childProcessBuildDist);
      // check for ORA message
      if (childProcessBuildDist.includes('ORA-')) {
        process.stdout.write('\n' + chalk.blue.bold('Database error occured...') + '\n\n');
        process.exit();
      }
      // client side build
    } else if (plgBuildMethod == 'client') {
      var pkgSpecPath = process.cwd() + '/' + apdeConfig.folders.srcDbFolder + '/' + shortPlgName + '_plg_pkg.pks';
      var pkgBodyPath = process.cwd() + '/' + apdeConfig.folders.srcDbFolder + '/' + shortPlgName + '_plg_pkg.pkb';

      var plgPkgCode = utils.generatePluginPackageCode(pkgSpecPath, pkgBodyPath, shortPlgName + '_plg_pkg');
      var plgSrcFileContent = fshelper.readFile(plgFileSrcPath);

      fshelper.writeFile(distFilePath, plgSrcFileContent + plgPkgCode);
    }
  }

  // cleanup
  fshelper.deleteFileFolder(process.cwd() + '/tmp');

  process.stdout.write('\n' + chalk.blue.bold('APDE built final Plug-in file for distribution!') + '\n');
  process.stdout.write('\nLocation: ' + chalk.blue.bold(process.cwd() + '/' + apdeConfig.folders.distFolder + '/' + distPlgName + '.sql') + '\n\n');
};
