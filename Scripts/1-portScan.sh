#!/bin/bash

source staticValues.env

# ==== PORT SCAN ============================================

# Network Mapper
if nmap --version &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Nmap is already installed."
else
    echo "" && echo -e "${YELLOW}[WARNING]${WHITE} Installing Nmap." && echo ""
    sudo apt -y install nmap &> /dev/null
    echo -e "${GREEN}[SUCCESS]${WHITE} Nmap installed successfully."
fi

#
nmap $target -sV -sC -T4 -p- --min-rate=1000 -oN $target-portScan.txt -oG grep.$target-portScan.txt

#
mv $target-portScan.txt ./Outputs 
mv grep.$target-portScan.txt ./Outputs
 
#
echo -e "${GREEN}[SUCCESS]${WHITE} Port scan complete." && echo ""

# Exit successfully
exit 0
