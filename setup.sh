#!/bin/bash
# Automated installer script for Local Log Parser
# https://github.com/dasbuilder/local-log-parser

# Check if required applications are present on the system script is running on
printf "\n\tWelcome to the Local Log Parser install script.\n"
printf "This only works for Linux, WSL (Linux on Windows), Mac and CygWin.\n\n"
echo; 
echo;

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
printf "Checking the default shell...\n";
# zsh is default on MacOS Catalina and beyond. bash_profile should be default on any previous versions. User may have manually changed their shell. 
if [[ "$SHELL" == "/bin/zsh" ]]; then	
	profilefile="${HOME}/.zshrc";
	printf "Your shell is \"%s\" and your profile is \"%s\"\n" "$SHELL" "$profilefile"
elif [[ "$SHELL" == "/bin/bash" ]]; then
	profilefile="${HOME}/.bash_profile";
	printf "Your shell is \"%s\" and your profile is \"%s\"\n" "$SHELL" "$profilefile"
else
	printf "%s is not bash or zsh, cannot add alias due to not being able to correctly determine profile file.\nYou will need to manually add an alias in your profile file.\n" "$SHELL"
	profilefile="";
fi
# jq check
printf "Checking if jq is installed.\n"
jqpath="$(which jq)";
brewpath="$(which brew)";
# Detecting if jq is installed, if it's not we need to install it either using brew on Mac. 
if [[ ! -f "$jqpath" ]]; then
	printf "\njq isn't installed. Let's install it...\n" 
	sleep 2;
	if [[ $macos ]]; then
		printf "\nMacOSX or MacOS detected...let's see if brew is available\n"
		sleep 1;
		# Checking if brew is installed or not
		if [[ ! -f "$brewpath" ]]; then
			printf "\nYou don't have brew installed. If you want to install it, enter y for Yes and n for No.\n";
			read -r answer;
			sleep 2;
				if [[ $answer == [Yy] ]]; then
					printf "Installing brew...\n"; 
					/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && 
					printf "Installing jq now with 'brew install jq'\n" && 
					/usr/local/bin/brew install jq;
				else
					printf "\nYou opted to skip installing brew.\nInstalling jq manually...\n"
				fi
				# Installing jq manually
				sleep 2;
				printf "Downloading jq executable...\n";
				curl -sLO --output-dir ~/Downloads/ https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64 && 
				printf "Installing\n" && 
				/bin/bash ~/Downloads/jq-osx-amd64
		else 
			# Installing jq using brew, since we already have brew 
			printf "\nInstalling jq now with 'brew install jq'\n" && 
			/usr/local/bin/brew install jq;
			sleep 2;
		fi	# End of brew check if block
	fi # End of OS check if block
else # Else for jqpath if block
	printf "\njq and brew are already installed. We should have everything we need.\n"
fi

# With jq installed, we need to download the application files
echo;
printf "Downloading application files...\n"
curl -sL -O --output-dir ~/Downloads/ "https://raw.githubusercontent.com/dasbuilder/local-log-parser/master/local-log-parser.sh"; 
sleep 2;

printf "\nInstalling the program...\nYou might be asked for your administrator or root password. Enter it when prompted.\n";
chmod +x ~/Downloads/local-log-parser.sh && sudo mv -v ~/Downloads/local-log-parser.sh /usr/local/bin/local-log-parser.sh
sleep 2;

if [[ -z "$profilefile" ]]; then
	printf "\nCould not automatically determine which profile you are using. Please manually set an alias in your profile file. Your shell type is: %s\n" "$SHELL"
else
	echo "alias lp='/usr/local/bin/local-log-parser.sh'" >> "$profilefile";
	printf "\nAn alias has been created for you called %s in your %s\n" '"lp"' "$profilefile";
	printf "If you would like to change this, edit your %s manually.\n" "$profilefile"
	sleep 2;
  printf "Please run %s to reload your profile to use your new alias.\n" "source $profilefile"
fi; 

printf "\nTo use the program, run %s or use your preferred alias.\nE.g. 'lp local-lightning.log'\n" "'$SHELL /usr/local/bin/local-log-parser.sh local-lightning.log'"
printf "\nIf you experience issues, please fill out an issue on my github page here: %s\n\nThanks and enjoy!" "https://github.com/dasbuilder/local-log-parser/issues"


