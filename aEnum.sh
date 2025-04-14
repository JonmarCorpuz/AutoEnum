#!/bin/bash

# Text color
WHITE="\033[0m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"

# Define required option
while getopts ":t:" opt; do
    case $opt in
        t) OutputFilename=$(echo "$OPTARG" | sed 's/\///g')
        ;;
        \?) echo -e "${RED}[ERROR]${WHITE} Usage: ./aEnum.sh -t {TARGET_IP|TARGET_FQDN}" && echo "" &&  exit 1
        ;;
        :) echo -e "${RED}[ERROR]${WHITE} Usage: ./aEnum.sh -t {TARGET_IP|TARGET_FQDN}" && echo "" && exit 1
        ;;
    esac
done

# Check if script was executed properly
if [ $OPTIND -ne 3 ]; 
then
    echo "" && echo -e "${RED}[ERROR]${WHITE} Usage: ./aEnum -t {TARGET_IP|TARGET_FQDN}" && echo "" 
    exit 1
fi

# Check if target is reachable
target=$2
if ! ping $target -c 4 &> /dev/null;
then
  echo "" && echo -e "${RED}[ERROR]${WHITE} Couldn't reach ${target}"
  echo "Now exiting ..." && echo ""
  exit 1
fi

# ==== INSTALL REQUIRED DEPENDENCIES ========================

echo -e "${YELLOW}[REQUIRED]${WHITE} Downloading any missing tools needed to run this script." && echo ""

# Network Mapper
if nmap --version &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Nmap is already installed."
else
    echo "" && echo -e "${YELLOW}[WARNING]${WHITE} Installing Nmap." && echo ""
    sudo apt -y install nmap &> /dev/null
    echo -e "${GREEN}[SUCCESS]${WHITE} Nmap installed successfully."
fi

# Directory Buster
if gobuster --help &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Gobuster is already installed."
else
    echo "" && echo -e "${YELLOW}[WARNING]${WHITE} Installing Gobuster." && echo ""
    sudo apt -y install gobuster &> /dev/null
    echo -e "${GREEN}[SUCCESS]${WHITE} Gobuster installed successfully." 
fi

# Metasploit
if msfconsole --version &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Metasploit is already installed."
else
    echo "" && echo -e "${YELLOW}[WARNING]${WHITE} Installing Metasploit." && echo ""
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
    echo "yes" | msfconsole -q -x "exit"
    echo -e "${GREEN}[SUCCESS]${WHITE} Metasploit installed successfully." 
fi

# ==== TARGET INFORMATION ===================================
echo "target=$target" > target.env

# ==== PORT SCAN ============================================
echo "" && echo -e "${YELLOW}[NOTICE]${WHITE} Scanning for open ports."
./Scripts/1-portScan.sh

# ==== DIRECTORY SCAN =======================================
if wget --spider $target &> /dev/null; 
then
  echo -e "${YELLOW}[NOTICE]${WHITE} Scanning for hidden directories."
  ./Scripts/2-directoryScan.sh
else
  echo -e "${RED}[ERROR]${WHITE} No web server was found running on ${target}" && echo ""
fi

# ==== FTP ENUMERATION ======================================

#if 
#then
#  ./Scripts/3-ftpEnumeration.sh
#fi

# ==== FTP ENUMERATION ======================================
# ==== FTP ENUMERATION ======================================


echo -e "${YELLOW}[INFO]${WHITE} The results for the port scan is stored in ./Outputs/${target}-portScan.txt"
echo -e "${YELLOW}[INFO]${WHITE} The results for the directory scan is stored in ./Outputs/${target}-directoryScan.txt."