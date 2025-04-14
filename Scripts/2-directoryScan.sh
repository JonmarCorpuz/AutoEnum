#!/bin/bash

source target.env

# Text color
WHITE="\033[0m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"

# 
if cat ./Outputs/grep.$target-portScan.txt | grep "http" &> /dev/null;
then
  gobuster dir -u http://$target -w ./Wordlists/common.txt -t 50 > $target-directoryScanHTTP.txt
  mv $target-directoryScanHTTP.txt ./Outputs
fi

# 
if cat ./Outputs/grep.$target-portScan.txt | grep "https" &> /dev/null;
then
  gobuster dir -u https://$target -w ./Wordlists/common.txt -t 50 > $target-directoryScanHTTPS.txt
  mv $target-directoryScanHTTPS.txt ./Outputs
fi

#
echo -e "${GREEN}[SUCCESS]${WHITE} Directory scan complete." && echo ""

# Exit successfully
exit 0