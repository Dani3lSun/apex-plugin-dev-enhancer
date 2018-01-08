#!/usr/bin/env node

const updateNotifier = require('update-notifier');
const pkg = require('../package.json');
const apde = require('../index.js');

// Workaround for MacOS which doesn't allow to sigint
process.on('SIGINT', () => {
  console.log('SIGINT - exit...');
  process.exit();
});

// get command line arguments
const userArgs = process.argv.slice(2);

// Check for updates on npm
const notifier = updateNotifier({
  pkg
});

if (notifier.update) {
  notifier.notify({
    defer: false,
    message: chalk.bold('APDE') + ' update available ' +
      chalk.dim(notifier.update.current) +
      chalk.reset(' → ') +
      chalk.green(notifier.update.latest) +
      ' \nRun:\n' + chalk.cyan.bold('npm install -g apex-plugin-dev-enhancer')
  });
}

// delete Oracle SQLPATH environment variable (e.g login.sql) if present --> ensure SQLcl works as expected
if (typeof process.env.SQLPATH !== 'undefined') {
  delete process.env.SQLPATH;
}

// call APDE commands
if (typeof userArgs[0] === 'undefined') {
  apde.help();
} else if (typeof apde[userArgs[0]] === 'undefined') {
  apde.help();
} else {
  apde[userArgs[0]](userArgs);
}
