#!/bin/bash

source target.env

# Text color
WHITE="\033[0m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"

# ==== PORT SCAN ============================================

#
nmap $target -sV -sC -T4 -p- --min-rate=1000 -oN $target-portScan.txt -oG grep.$target-portScan.txt

#
mv $target-portScan.txt ./Outputs 
mv grep.$target-portScan.txt ./Outputs

#
echo -e "${GREEN}[SUCCESS]${WHITE} Port scan complete." && echo ""

# Exit successfully
exit 0
