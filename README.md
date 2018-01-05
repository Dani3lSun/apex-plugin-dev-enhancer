# APEX Plug-in Dev Enhancer

Local command line tool to enhance Oracle APEX Plug-in development...


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
apde init
```

#### Config Plug-in project
Creates a JSON file in the root directory of your project with necessary settings & paramters, like Plug-in name, type, database connection ...
```
apde config
```

#### Upload static files to APEX instance
Uploads all files contained in your src/files folder to your APEX instance/application which hosts the Plug-in
```
apde files
```

#### Build Plug-in file for distribution
Executes all steps to create a final Plug-in build ready for distribution. Uploads all static files, exports the Plug-in SQL and concats your PL/SQL package to the file. So all necessary objects are contained in one single file. Default location: dist/
```
apde build
```


## License
MIT © [Daniel Hochleitner](https://danielhochleitner.de)
