/**
 * Purpose: Utils / Helper functions
 * Author:  Daniel Hochleitner
 */

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
    var connectString = `${pConfig.database.username}/${pConfig.database.password}@${pConfig.database.host}:${pConfig.database.port}:${pConfig.database.sid}`;
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
};
