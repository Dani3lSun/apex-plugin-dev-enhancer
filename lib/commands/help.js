'use strict';

const chalk = require('chalk');

const helpText = {
  // Each command is an array of strings
  // To print the command, the array is joined into one string, and a line break is added
  // between each item. Basically, each comma becomes a line break.
  default: [
    'Available commands:',
    chalk.blue.bold('  init') + '\tInitialize an new APEX Plug-in project',
    chalk.blue.bold('  config') + '\tConfigure an existing APEX Plug-in project',
    chalk.blue.bold('  files') + '\tUpload Plug-in static files like JS, CSS or images',
    chalk.blue.bold('  build') + '\tBuild a new version of your Plug-in with all static files and PL/SQL Objects',
    chalk.blue.bold('  help  ') + '\tShow this screen',
    '',
    'To learn more about a specific command, type ' + chalk.blue.bold('apde help <command>'),
    '',
    'Need more help? Ask on GitHub: https://github.com/Dani3lSun/apex-plugin-dev-enhancer/issues'
  ],
  init: [
    'Usage:',
    chalk.blue.bold('  apde init'),
    '',
    'Initialize an new APEX Plug-in project.',
    'It will create a basic folder structure + all necessary files for APEX Plug-in development.'
  ],
  config: [
    'Usage:',
    chalk.blue.bold('  apde config'),
    '',
    'Configure an existing APEX Plug-in project.',
    'It will ask you for all needed configuration parameters and creates a config JSON (' + chalk.blue.bold('apdeconfig.json') + ') in the current directory (Plug-in root).'
  ],
  files: [
    'Usage:',
    chalk.blue.bold('  apde files'),
    '',
    'Upload Plug-in static files like JS, CSS or images.',
    'Uploads and overwrites all Plug-in static files from your local machine directly to the specified APEX Plug-in.'
  ],
  build: [
    'Usage:',
    chalk.blue.bold('  apde build'),
    '',
    'Build a new version of your Plug-in with all static files and PL/SQL Objects',
    'Builds a new version of your APEX Plug-in and outputs to specified dist directory. All necessary files (static files, Plug-in export, PL/SQL objects) will be bundled into a single SQL file.'
  ],
  help: [
    'Usage:',
    chalk.blue.bold('  apde help'),
    chalk.blue.bold('  apde help <command>'),
    '',
    'Type ' + chalk.blue.bold('apde help') + ' to see a list of every command,',
    'or ' + chalk.blue.bold('apde help <command>') + ' to learn how a specific command works.'
  ]
};

module.exports = function(args) {
  let command;

  if (typeof args === 'undefined' || args.length === 0 || !helpText[args[1]]) {
    command = 'default';
  } else {
    command = args[1];
  }

  // A line break is added before and after the help text for good measure
  process.stdout.write('\n' + helpText[command].join('\n') + '\n\n');
};
