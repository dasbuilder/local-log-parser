#!/bin/bash
# Automated installer script for Local Log Parser
# https://github.com/dasbuilder/local-log-parser

# Check if required applications are present on the system script is running on
printf "Welcome to the Local Log Parser install script.\n \
This only works for Linux, WSL (Linux on Windows), Mac and CygWin.\n"

if [[ $OSTYPE =~ "darwin"* ]]; then
	macos="true";
elif [[ $OSTYPE =~ "linux"* ]]; then 
	linux="true";
elif [[ $OSTYPE =~ "cygwin" ]]; then
	# POSIX compatibility layer and Linux environment emulation for Windows
	# Coming in a future release
	windows="true";
fi


printf "Checking if jq is installed.\n"
jqpath="$(which jq)";

# Detecting if jq is installed, if it's not we need to install it either using brew on Mac. 
if [[ ! -f $jqpath ]]; then 
	if [[ $macos ]]; then
		printf "Checking if brew is installed...\n"
		if [[ ! -f /usr/local/bin/brew ]]; then
			printf "You don't have brew installed. If you want to install it, enter y for Yes and n for No.\n";
			read -r answer;
			if [[ $answer == [Yy] ]]; then
				printf "Installing brew...\n"; 
				/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && 
				printf "Installing jq now with 'brew install jq'\n" && 
				/usr/local/bin/brew install jq;
			else
				printf "You opted to skip installing brew.\nInstalling jq manually...\n"
			fi
			# Installing jq manually
			printf "Downloading jq executable...\n";
			curl -sLO --output-dir ~/Downloads/ https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64 && 
			printf "Installing\n" && 
			/bin/bash ~/Downloads/jq-osx-amd64
		fi
	fi
fi

# With that installed, we need to download application files
printf "Downloading application files...\n"
curl -sL -O --output-dir ~/Downloads/ "https://raw.githubusercontent.com/dasbuilder/local-log-parser/master/local-log-parser.sh"; 

printf "Installing the parser\n";
chmod +x ~/Downloads/local-log-parser.sh && sudo mv -v ~/Downloads/local-log-parser.sh /usr/local/bin/local-log-parser.sh

printf "Now you need to set up an alias. Run either of the following to add an alias to your shell profile, or add one manually.\nIf running zsh, run %s\n\
Otherwise, run %s\n" \
\""echo alias lp='/usr/local/bin/local-log-parser.sh' >> ~/.zshrc\";" \""echo alias lp='/usr/local/bin/local-log-parser.sh' >> ~/.bash_profile\";"

printf "\nTo use the program, run %s or use your preferred alias.\nE.g. 'lp local-lightning.log'\n" "'./usr/local/bin/local-log-parser.sh local-lightning.log'"
printf "\nIf you experience issues, please fill out an issue on my github page here: %s\n\nThanks and enjoy!" "https://github.com/dasbuilder/local-log-parser/issues"
