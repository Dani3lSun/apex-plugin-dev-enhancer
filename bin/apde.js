#!/usr/bin/env node

//const update = require('update-notifier');
//const pkg = require('../package.json');
const apde = require('../index.js');

// Workaround for MacOS which doesn't allow to sigint
process.on('SIGINT', () => {
  console.log('SIGINT - exit...');
  process.exit();
});

// get command line arguments
const userArgs = process.argv.slice(2);

// Check for updates once a day
/*const notifier = update({
	packageName: pkg.name,
	packageVersion: pkg.version
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
}*/

if (typeof userArgs[0] === 'undefined') {
  apde.help();
} else if (typeof apde[userArgs[0]] === 'undefined') {
  apde.help();
} else {
  apde[userArgs[0]](userArgs);
}
