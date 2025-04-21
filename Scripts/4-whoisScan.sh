#!/bin/bash

source staticValues.env

# ==== REQUIREMENTS =========================================

if ! whois --version &> /dev/null;
then
  echo "" && echo -e "${RED}[ERROR]${WHITE} whois is not installed."
  echo -e "${YELLOW}[NOTICE]${WHITE} Installing whois."
  sudo apt -y update
  sudo apt -y install whois
  echo -e "${GREEN}[NOTICE]${WHITE} whois was successfully installed." && echo ""
fi

whois $target > $target-whoisScan.txt 
mv $target-whoisScan.txt  ./Output
