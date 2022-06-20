# Local Log Parser

### This program parses local-lightning.log files for easier reading

- Version 1.0
    - Confirmed to work on Mac OSX or macOS
    - Support for Linux, and Linux on Windows (WSL or GitBash) possibly coming in the future.
- Version 1.1
	- Updated setup.sh to detect different shell types (bash and zsh)
	- Adds alias to either `~/.bash_profile` or `~/.zshrc`, depending on $SHELL type. 

### Requirements

- Homebrew
- jq
    - If neither are installed, users have the option to first install [homebrew](https://brew.sh/) and then jq is installed afterwards.
    - Installs [jq](https://stedolan.github.io/jq) directly, if user opts to skip installing homebrew

### Usage
- After installation, the script sets up an alias in either `~/.zshrc` or `~/.bash_profile`. 
	Some examples:
	
	```
	lp ~/Downloads/local-lightning.log
	```
	
	or
	
	```
	bash /usr/local/bin/local-log-parser.sh ~/Downloads/local-lightning.log
	```

### Issues

- Please fill out an issue [here] (https://github.com/dasbuilder/local-log-parser/issues) and be as detailed as possible, including screenshots and/or error output. 
