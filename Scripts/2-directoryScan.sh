#!/bin/bash

source staticValues.env

# ==== DIRECTORY SCAN =======================================

if gobuster --help &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Gobuster is already installed."
else
    echo "" && echo -e "${YELLOW}[WARNING]${WHITE} Installing Gobuster." && echo ""
    sudo apt -y install gobuster &> /dev/null
    echo -e "${GREEN}[SUCCESS]${WHITE} Gobuster installed successfully." 
fi

# 
if cat ./Output/grep.$target-portScan.txt | grep "http" &> /dev/null;
then
  gobuster dir -u http://$target -w ./Wordlists/common.txt -t 50 > $target-directoryScanHTTP.txt
  mv $target-directoryScanHTTP.txt ./Output
fi

# 
if cat ./Output/grep.$target-portScan.txt | grep "https" &> /dev/null;
then
  gobuster dir -u https://$target -w ./Wordlists/common.txt -t 50 > $target-directoryScanHTTPS.txt
  mv $target-directoryScanHTTPS.txt ./Output
fi

#
echo -e "${GREEN}[SUCCESS]${WHITE} Directory scan complete." && echo ""

# Exit successfully
exit 0