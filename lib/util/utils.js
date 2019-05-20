/**
 * Purpose: Utils / Helper functions
 * Author:  Daniel Hochleitner
 */
const fshelper = require(appRootFolder + '/lib/util/fshelper.js');

module.exports = utils = {
  /**
   * Get clean plugin name
   * @param {string} pPlgName
   * @return {string}
   */
  getCleanPluginName: function(pPlgName) {
    var cleanPlgName = '';

    cleanPlgName = pPlgName.toLowerCase();
    cleanPlgName = cleanPlgName.replace(/[^\w\s]/gi, '_');

    return cleanPlgName;
  },
  /**
   * Get short plugin name
   * @param {string} pPlgName
   * @return {string}
   */
  getShortPluginName: function(pPlgName) {
    var shortPlgName = '';

    shortPlgName = utils.getCleanPluginName(pPlgName);
    shortPlgName = shortPlgName.substring(shortPlgName.lastIndexOf('_') + 1);

    return shortPlgName;
  },
  /**
   * Get pretty looking plugin name
   * @param {string} pPlgName
   * @return {string}
   */
  getPrettyPluginName: function(pPlgName) {
    var prettyPlgName = '';

    prettyPlgName = utils.getShortPluginName(pPlgName);
    prettyPlgName = prettyPlgName.charAt(0).toUpperCase() + prettyPlgName.slice(1);

    return prettyPlgName;
  },
  /**
   * Get dist plugin Name
   * @param {string} pPlgName
   * @param {string} pPlgType
   * @return {string}
   */
  getDistPluginName: function(pPlgName, pPlgType) {
    var distPlgName = '';

    distPlgName = utils.getApexExportPluginFolderName(pPlgType) + '_plugin_';
    distPlgName = distPlgName + utils.getCleanPluginName(pPlgName);

    return distPlgName;
  },
  /**
   * Get DB connection string based on config JSON
   * @param {object} pConfig
   * @return {string}
   */
  getConnectionString: function(pConfig) {
    var connectString = '';
    if (pConfig.database.sid) {
      connectString = `${pConfig.database.username}/${pConfig.database.password}@${pConfig.database.host}:${pConfig.database.port}:${pConfig.database.sid}`;
    }
    if (pConfig.database.servicename) {
      connectString = `${pConfig.database.username}/${pConfig.database.password}@${pConfig.database.host}:${pConfig.database.port}/${pConfig.database.servicename}`;
    }
    return connectString;
  },
  /**
   * Get folder name of APEX export splitted plugin type
   * @param {string} pPlgType
   * @return {string}
   */
  getApexExportPluginFolderName: function(pPlgType) {
    if (pPlgType == 'item' || pPlgType == 'region' || pPlgType == 'process' || pPlgType == 'authentication' || pPlgType == 'authorization') {
      return pPlgType + '_type';
    } else if (pPlgType == 'dynamic_action') {
      return pPlgType;
    }
  },
  /**
   * Get quoted text from given text (used in PL/SQL)
   * @param {string} pText
   * @param {string} pSeparator
   * @return {string}
   */
  getQuotedText: function(pText, pSeparator) {
    var separator = pSeparator || '\n';
    var textArray = pText.split(separator);

    for (var i = 0; i < textArray.length; i++) {
      textArray[i] = textArray[i].replace(/\r?\n|\r/, '');
      if (i == textArray.length - 1) {
        textArray[i] = "'" + textArray[i].replace(/'/g, "''") + "'";
      } else {
        textArray[i] = "'" + textArray[i].replace(/'/g, "''") + "',";
      }
    }
    return textArray.join(separator);
  },
  /**
   * Generate PL/SQL Package code for final plugin sql file
   * @param {string} pPkgSpecPath
   * @param {string} pPkgBodyPath
   * @param {string} pPkgName
   * @return {string}
   */
  generatePluginPackageCode: function(pPkgSpecPath, pPkgBodyPath, pPkgName) {
    var pkgSpecContent = fshelper.removeTrailingSlahesFromFile(pPkgSpecPath);
    var pkgBodyContent = fshelper.removeTrailingSlahesFromFile(pPkgBodyPath);

    var pkgSpecQuotedText = utils.getQuotedText(pkgSpecContent);
    var pkgBodyQuotedText = utils.getQuotedText(pkgBodyContent);

    var finalText = '';

    finalText = finalText + 'set verify off define off\n';
    finalText = finalText + 'begin\n';
    finalText = finalText + '  EXECUTE IMMEDIATE apex_string.join_clob(apex_t_varchar2(\n';
    finalText = finalText + pkgSpecQuotedText + '));\n';
    finalText = finalText + 'end;\n';
    finalText = finalText + '/\n\n';

    finalText = finalText + 'begin\n';
    finalText = finalText + '  EXECUTE IMMEDIATE apex_string.join_clob(apex_t_varchar2(\n';
    finalText = finalText + pkgBodyQuotedText + '));\n';
    finalText = finalText + 'end;\n';
    finalText = finalText + '/\n\n';

    finalText = finalText + 'begin\n';
    finalText = finalText + "  EXECUTE IMMEDIATE 'ALTER SESSION SET plsql_compiler_flags = ''NATIVE''';\n";
    finalText = finalText + "  EXECUTE IMMEDIATE 'ALTER SESSION SET plsql_code_type = ''NATIVE''';\n";
    finalText = finalText + "  EXECUTE IMMEDIATE 'ALTER PACKAGE " + pPkgName + " COMPILE';\n";
    finalText = finalText + 'end;\n';
    finalText = finalText + '/\n';

    return finalText;
  }
};
