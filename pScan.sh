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

Replace="/"
ReplaceWith="range"

########################################### OVERVIEW ############################################

echo '''
 ________  ________  ________  ________  ________      
|\   __  \|\   ____\|\   ____\|\   __  \|\   ___  \    
\ \  \|\  \ \  \___|\ \  \___|\ \  \|\  \ \  \\ \  \   
 \ \   ____\ \_____  \ \  \    \ \   __  \ \  \\ \  \  
  \ \  \___|\|____|\  \ \  \____\ \  \ \  \ \  \\ \  \ 
   \ \__\     ____\_\  \ \_______\ \__\ \__\ \__\\ \__\
    \|__|    |\_________\|_______|\|__|\|__|\|__| \|__|
             \|_________|                              
'''

######################################## ARGUMENTS CHECK ########################################

# Check if the user executed the script correctly
while getopts ":t:T:" opt; do
    case $opt in
        t) OutputFilename="${OPTARG/${Replace}/range}"
        ;;
        T) OutputFilename="pScan"$2".txt"
        ;;
        \?) echo -e "${RED}[ERROR 1]${WHITE} Usage: ./PortScan {-t <TARGET_RANGE>|-T <TARGET_ADDRESS>}" && echo "" &&  exit 1
        ;;
        :) echo -e "${RED}[ERROR 2]${WHITE} Usage: ./PortScan {-t <TARGET_RANGE>|-T <TARGET_ADDRESS>}" && echo "" && exit 1
        ;;
    esac
done

# Check if the user provided only the required values when executing the script
if [ $OPTIND -ne 3 ]; 
then
    echo -e "${RED}[ERROR 3]${WHITE} Usage: ./PortScan {-t <TARGET_RANGE>|-T <TARGET_ADDRESS>}" && echo "" &&  exit 1
fi

# Check if the provided address or address range is valied
if [[ "$2" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]] || [[ "$2" =~ ^(((25[0-5]|2[0-4][0-9]|1?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9][0-9]?))(\/([8-9]|[1-2][0-9]|3[0-2]))([^0-9.]|$) ]]; then
  echo "success"
else
  echo "fail"
fi

####################################### PREQUESITES CHECK #######################################

if nmap --version &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Nmap is already installed." && echo "" 
else
    echo -e "${GREEN}[YELLOW]${WHITE} Installing Nmap." && echo ""
    sudo apt -y install nmap &> /dev/null
fi

########################################### PORT SCAN ###########################################

#
if nmap $2 -sV -sC -oN $OutputFilename.txt &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} YES." && echo "" 
else
    echo -e "${GREEN}[YELLOW]${WHITE} NAH." && echo ""
fi

mv $OutputFilename.txt ./Outputs
