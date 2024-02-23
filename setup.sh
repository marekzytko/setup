#!/bin/bash

# Variables and directories:
SSH_KEY=~/.ssh/marekzytko_key

# List of packages:
packages=("git" "gimp" "keepass" "tmux" "zsh" "ripgrep" "rofi" "tldr" "falkon" "fcron" "openvpn")


if [ "$EUID" -eq 0 ]
then echo "Please run as a normal user and input passwords manually each time (because I can't script properely :))))" 
  exit
fi



#.SH SCRIPTS
source dotfiles.sh
source mega.sh
source zsh.sh




# Install packages list:
for package in ${packages[@]};
do
	echo -n "Installing ${package}..."
	sudo pacman -Syy ${package} > /dev/null
	if [ $? -eq 0 ];
	then
		echo -e "\e[42mSUCCESS\e[0m"
	else
		echo -e "\e[41mFAILED\e[0m"
		${package}
		
	fi
done


# SSH SETUP
# Setup ssh-agent and generate ssh key
echo -n "starting SSH agent..." 
eval $(ssh-agent) > /dev/null

if [ $? -eq 0 ];
then
	echo -e "\e[42mSUCCESS\e[0m"
fi

echo -n "generating SSH key..."
# https://stackoverflow.com/questions/43235179/how-to-execute-ssh-keygen-without-prompt
ssh-keygen -q -t rsa -N '' -f $SSH_KEY<<<y >/dev/null
echo -e "\e[42mSUCCESS\e[0m"


echo -n "adding SSH key to agent..."
ssh-add $SSH_KEY > /dev/null
echo -e "\e[42mSUCCESS\e[0m"





# Additional configuration commands:

git config --global core.editor vim



