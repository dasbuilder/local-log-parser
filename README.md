# Local Log Parser

### This program parses local-lightning.log files for easier reading

- Version 1.0
    - Only works on Mac OSX or MacOS.
    - Support for Linux, and Linux on Windows (WSL or Cygwin) coming in future releases

### Requirements

- Homebrew
- jq
    - If neither are installed, users have the option to install [homebrew](https://brew.sh/).
    - Installs [jq](https://stedolan.github.io/jq/) if brew is not installed.

### Usage
- After installation, I recommend setting up an alias in either your `~/.zshrc` or `~/.bash_profile`. 
	Some examples:  
	```
	lp ~/Downloads/local-lightning.log
	```
	or 
	```
	bash /usr/local/bin/local-log-parser.sh ~/Downloads/local-lightning.log
	```

### Issues
- Please fill out an issue [here](https://github.com/dasbuilder/local-log-parser/issues). 