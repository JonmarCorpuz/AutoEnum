#!/bin/bash

#
cat ./Outputs/grep*.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" >>

if [ -s ScannedHosts.txt ]; then
    # The file is not-empty.
    while read Host;
    do
        echo $Host
        #
        if ! cat TargetHosts.txt | grep -q $Host;
        then
            echo "LMAO"
            echo $Host >> TargetHosts.txt
        fi
    done < ScannedHosts.txt
else
    # The file is empty.
    echo "NAH"
fi

# Check if anonymous login is allowed on FTP
while read Host;
do
   wget -m --no-passive ftp://anonymous:anonymous@$Host
done < TargetHosts.txt
