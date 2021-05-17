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

# Checking which shell is used
printf "Checking which shell is being used...\n";
# zsh is default on MacOS Catalina and beyond. bash_profile should be default on any previous versions. User may have manually changed their shell. 
if [[ "$SHELL" == "/bin/zsh" ]]; then
	profilefile="~/.zshrc";
	printf "Your shell is \"%s\" and your profile is \"%s\"\n" "$SHELL" "$profilefile"
elif [[ "$SHELL" == "/bin/bash" ]]; then
	profilefile="~/.bash_profile";
	printf "Your shell is \"%s\" and your profile is \"%s\"\n" "$SHELL" "$profilefile"
else
	printf "%s is not bash or zsh, cannot add alias due to not being able to correctly determine profile file.\nYou will need to manually add an alias in your profile file.\n" "$SHELL"
	profilefile="";
fi

printf "Checking if jq is installed.\n"
jqpath="$(which jq)";
brewpath="$(which brew)";
# Detecting if jq is installed, if it's not we need to install it either using brew on Mac. 
if [[ ! -f "$jqpath" ]]; then 
	if [[ $macos ]]; then
		printf "Checking if brew is installed...\n"
		if [[ ! -f "$brewpath" ]]; then
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

printf "Installing the program...\n";
chmod +x ~/Downloads/local-log-parser.sh && sudo mv -v ~/Downloads/local-log-parser.sh /usr/local/bin/local-log-parser.sh

if [[ -z "$profilefile" ]]; then
	printf "Could not automatically determine which profile you are using. Please manually set an alias in your profile file. Your shell type is: %s\n" "$SHELL"
else
	echo "lp='/usr/local/bin/local-log-parser.sh'" >> "$profilefile";
	printf "\nAn alias has been created for you called %s in your %s\n" '"lp"' "$profilefile";
	printf "If you would like to change this, edit your %s manually.\n" "$profilefile"
  printf "Please run %s to reload your profile to use your new alias.\n" "source $profilefile"
fi; 

printf "\nTo use the program, run %s or use your preferred alias.\nE.g. 'lp local-lightning.log'\n" "'./usr/local/bin/local-log-parser.sh local-lightning.log'"
printf "\nIf you experience issues, please fill out an issue on my github page here: %s\n\nThanks and enjoy!" "https://github.com/dasbuilder/local-log-parser/issues"
