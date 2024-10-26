#!/bin/bash

####################################### STATIC VARIABLES ########################################

# Text Color
WHITE="\033[0m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"

# Infinte Loop
ALWAYS_TRUE=true

# Regex
Integer='^[0-9]+$'

######################################### REQUIREMENTS ##########################################

echo '''
 ________  ________  ________  ________  ________      
|\   ___ \|\   ____\|\   ____\|\   __  \|\   ___  \    
\ \  \_|\ \ \  \___|\ \  \___|\ \  \|\  \ \  \\ \  \   
 \ \  \ \\ \ \_____  \ \  \    \ \   __  \ \  \\ \  \  
  \ \  \_\\ \|____|\  \ \  \____\ \  \ \  \ \  \\ \  \ 
   \ \_______\____\_\  \ \_______\ \__\ \__\ \__\\ \__\
    \|_______|\_________\|_______|\|__|\|__|\|__| \|__|
             \|_________|                                               
'''

######################################## ARGUMENTS CHECK ########################################

# Check if the user executed the script correctly
while getopts ":t:T:" opt; do
    case $opt in
        t) target_url="$OPTARG"
        ;;
        \?) echo -e "${RED}[ERROR 1]${WHITE} Usage: ./dScan -u <TARGET_URL>" && echo "" &&  exit 1
        ;;
        :) echo -e "${RED}[ERROR 2]${WHITE} Usage: ./dScan -u <TARGET_URL>" && echo "" && exit 1
        ;;
    esac
done

# Check if the user provided only the required values when executing the script
if [ $OPTIND -ne 3 ]; 
then
    echo -e "${RED}[ERROR 3]${WHITE} Usage: ./dScan -u <TARGET_URL>" && echo "" &&  exit 1
fi

####################################### GATHER USER INPUT #######################################

if dirb --version &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Dirb is already installed." && echo "" 
else
    echo -e "${GREEN}[YELLOW]${WHITE} Installing Dirb." && echo ""
    sudo apt -y install Dirb &> /dev/null
fi

if dirb $3 -R -o dScan.txt &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} YES." && echo ""
else
    echo -e "${GREEN}[YELLOW]${WHITE} NAH." && echo ""
fi
