#!/bin/bash

# Static variables
source staticValues.env

# ==== SANITY CHECK =========================================

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
  echo "" && echo -e "${RED}[ERROR]${WHITE} Couldn't reach ${target}" && echo ""
  exit 1
fi

# ==== TARGET INFORMATION ===================================
echo "target=$target" >> staticValues.env

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

# ==== WHOIS ENUMERATION ====================================
./Scripts/whoisScan.sh

# ==== FTP ENUMERATION ======================================
if grep "Anonymous FTP login allowed" ./Outputs/grep.$target-portScan.txt;
then
  ./Scripts/3-ftpEnumeration.sh
else
  echo -e "${RED}[ERROR]${WHITE} Anonymous FTP login is not allowed on ${target}" && echo ""
fi

# ==== VULNERABILITY SCAN ===================================
./Scripts/5-vulnerabilityScan.sh

# ==== FTP ENUMERATION ======================================

echo -e "${YELLOW}[INFO]${WHITE} The results for the port scan is stored in ./Outputs/${target}-portScan.txt"
echo -e "${YELLOW}[INFO]${WHITE} The results for the directory scan is stored in ./Outputs/${target}-directoryScan.txt."