/**
 * Purpose: Helper Functions for Filesystem Calls
 * Author:  Daniel Hochleitner
 */
const fs = require('fs');
const fse = require('fs-extra');
const path = require('path');
const jsondir = require('jsondir');

module.exports = fshelper = {
  /**
   * Reads a single file
   * @param {string} pFilePath
   * @return {string}
   */
  readFile: function(pFilePath) {
    try {
      var content = fs.readFileSync(path.resolve(pFilePath), 'utf8');
      return content;
    } catch (err) {
      console.log('fshelper.readFile Error', err);
    }
  },
  /**
   * Writes a single file
   * @param {string} pFilePath
   * @param {string} pContent
   */
  writeFile: function(pFilePath, pContent) {
    try {
      fs.writeFileSync(path.resolve(pFilePath), pContent);
    } catch (err) {
      console.log('fshelper.writeFile Error', err);
    }
  },
  /**
   * Move file to new location
   * @param {string} pOldPath
   * @param {string} pNewPath
   */
  moveFile: function(pOldPath, pNewPath) {
    try {
      fs.renameSync(path.resolve(pOldPath), path.resolve(pNewPath));
    } catch (err) {
      console.log('fshelper.moveFile Error', err);
    }
  },
  /**
   * Copy file to new location
   * @param {string} pFromPath
   * @param {string} pToPath
   */
  copyFile: function(pFromPath, pToPath) {
    try {
      fse.copySync(path.resolve(pFromPath), path.resolve(pToPath));
    } catch (err) {
      console.log('fshelper.copyFile Error', err);
    }
  },
  /**
   * Delete a file
   * @param {string} pFilePath
   */
  deleteFileFolder: function(pFilePath) {
    try {
      var filePath = path.resolve(pFilePath);
      fse.removeSync(filePath);
    } catch (err) {
      console.log('fshelper.deleteFileFolder Error', err);
    }
  },
  /**
   * Create directory
   * @param {string} pPath
   */
  mkDir: function(pPath) {
    try {
      fse.ensureDirSync(path.resolve(pPath));
    } catch (err) {
      console.log('fshelper.mkFileDir Error', err);
    }
  },
  /**
   * Create folder structure based on json
   * @param {object} pJSON
   * @param {function} callback
   */
  createFolderStructure: function(pJSON, callback) {
    try {
      jsondir.json2dir(pJSON, function(err) {
        if (err) throw err;
        callback();
      });
    } catch (err) {
      console.log('fshelper.createFolderStructure Error', err);
    }
  },
  /**
   * Find file and return file path
   * @param {string} pPath
   * @param {string} pSearchString
   * @param {function} callback
   */
  findFile: function(pPath, pSearchString, callback) {
    var walk = function(dir, done) {
      var results = [];
      fs.readdir(dir, function(err, list) {
        if (err) return done(err);
        var i = 0;
        (function next() {
          var file = list[i++];
          if (!file) return done(null, results);
          file = dir + '/' + file;
          fs.stat(file, function(err, stat) {
            if (stat && stat.isDirectory()) {
              walk(file, function(err, res) {
                results = results.concat(res);
                next();
              });
            } else {
              results.push(file);
              next();
            }
          });
        })();
      });
    };

    walk(pPath, function(err, results) {
      if (err) throw err;
      for (var i = 0; i < results.length; i++) {
        if (results[i].includes(pSearchString)) {
          callback(results[i]);
        }
      }
    });
  },
  /**
   * Replace text in file
   * @param {string} pFilePath
   * @param {expression} pReplaceExp
   * @param {string} pText
   */
  replaceTextInFile: function(pFilePath, pReplaceExp, pText) {
    content = fshelper.readFile(pFilePath);
    var result = content.replace(pReplaceExp, pText);

    fshelper.writeFile(pFilePath, result);
  },
  /**
   * Reads a single file as JSON
   * @param {string} pFilePath
   * @return {object}
   */
  readJsonFile: function(pFilePath) {
    var fileContent = fshelper.readFile(pFilePath);
    var jsonContent = {};
    try {
      jsonContent = JSON.parse(fileContent);
    } catch (err) {
      console.log('fshelper.readJsonFile parse error', err);
    }
    return jsonContent;
  },
  /**
   * Writes a single file as JSON
   * @param {string} pFilePath
   * @param {string} pContent
   */
  writeJsonFile: function(pFilePath, pJsonContent) {
    var fileContent = '';
    try {
      fileContent = JSON.stringify(pJsonContent, null, 4);
    } catch (err) {
      console.log('fshelper.writeJsonFile stringify error', err);
    }
    fshelper.writeFile(pFilePath, fileContent);
  },
  /**
   * Check if a file path exists
   * @param {string} pFilePath
   * @return {boolean}
   */
  pathExists: function(pFilePath) {
    var exists = fse.pathExistsSync(pFilePath);
    return exists;
  },
  /**
   * Check if a file path exists
   * @param {string} pFilePath
   * @return {string}
   */
  removeTrailingSlahesFromFile: function(pFilePath) {
    var fileContent = fshelper.readFile(pFilePath);
    var fileContentArray = [];

    fileContentArray = fileContent.split('\n');
    // only loop through last 5
    for (var i = fileContentArray.length - 5; i < fileContentArray.length; i++) {
      var subString = fileContentArray[i];
      if (subString.length == 0 || subString == '/\r' || subString == '/') {
        fileContentArray.splice(i, 1);
      }
    }
    return fileContentArray.join('\n');
  }
};
