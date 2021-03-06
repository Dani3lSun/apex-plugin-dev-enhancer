# APEX Plug-in Dev Enhancer

[![APEX Community](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/78c5adbe/badges/apex-community-badge.svg)](https://github.com/Dani3lSun/apex-github-badges) [![APEX Tool](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/b7e95341/badges/apex-tool-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)
[![APEX Built with Love](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/7919f913/badges/apex-love-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)

Local command line tool to enhance Oracle APEX Plug-in development...

*Note: At the moment still Beta! Ideas and testing are very welcome...*

![demo](/docs/demo.gif)


## Requirements
* [Node.js](https://nodejs.org/en/)
* [SQLcl](http://www.oracle.com/technetwork/developer-tools/sqlcl/overview/index.html)


## Install
```
npm install apex-plugin-dev-enhancer -g
```


## Usage

#### Help
Show available commands and information about that
```
apde help
```

#### Init Plug-in project
Creates initial folder structure for future Plug-in development
```
mkdir path/to/project
cd path/to/project
apde init
```

#### Config Plug-in project
Creates a JSON file in the root directory of your project with necessary settings & paramters, like Plug-in name, type, database connection ...
```
cd path/to/project
apde config
```

#### Upload static files to APEX instance
Uploads all files contained in your src/files folder to your APEX instance/application which hosts the Plug-in
```
cd path/to/project
apde files
```

#### Minify/Compress static Plug-in files
Compresses & minifies all JS/CSS Plug-in static files located in src/files and outputs a *.min.js* or *.min.css* file in the same directory
```
cd path/to/project
apde minify
```

#### Build Plug-in file for distribution
Executes all steps to create a final Plug-in build ready for distribution. Uploads all static files, exports the Plug-in SQL and concats your PL/SQL package to the file. So all necessary objects are contained in one single file. Default location: dist/
```
cd path/to/project
apde build
```


## Credits

- [Vincent Morneau´s apex-publish-static-files](https://github.com/vincentmorneau/apex-publish-static-files)


## License
MIT © [Daniel Hochleitner](https://danielhochleitner.de)
