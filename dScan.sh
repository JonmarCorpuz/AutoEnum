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

#
Replace=""

######################################### REQUIREMENTS ##########################################

echo '''
      7MM                                          
       MM   .M"""bgd                               
       MM   MI    "Y                               
  ,M""bMM   MMb.      ,p6"bo   ,6"Yb.   7MMpMMMb.  
,AP    MM     YMMNq. 6M   OO  8)   MM    MM    MM  
8MI    MM  .      MM 8M        ,pm9MM    MM    MM  
 Mb    MM  Mb     dM YM.    , 8M   MM    MM    MM  
  Wbmd"MML.P"Ybmmd"   YMbmd'  'Moo9^Yo..JMML  JMML.                                         
'''

######################################## ARGUMENTS CHECK ########################################

# Check if the user executed the script correctly
while getopts ":T:" opt; do
    case $opt in
        T) OutputFilename=$(echo "$OPTARG" | sed 's/\///g')
        ;;
        \?) echo -e "${RED}[ERROR 1]${WHITE} Usage: ./dScan -T <TARGET_URL>" && echo "" &&  exit 1
        ;;
        :) echo -e "${RED}[ERROR 2]${WHITE} Usage: ./dScan -T <TARGET_URL>" && echo "" && exit 1
        ;;
    esac
done

# Check if the user provided only the required values when executing the script
if [ $OPTIND -ne 3 ]; 
then
    echo -e "${RED}[ERROR 3]${WHITE} Usage: ./dScan -T <TARGET_URL>" && echo "" &&  exit 1
fi

#
if ! wget --spider $2 &> /dev/null; 
then
    echo -e "${RED}[ERROR 3]${WHITE} $2 does not exist." && echo "" &&  exit 1
fi

####################################### GATHER USER INPUT #######################################

if dirb --version &> /dev/null;
then
    echo -e "${GREEN}[SUCCESS]${WHITE} Dirb is already installed." && echo "" 
else
    echo -e "${YELLOW}[REQUIRED]${WHITE} Installing Dirb." && echo ""
    sudo apt -y install dirb &> /dev/null
fi

dirb $2 -o $OutputFilename.txt;
mv $OutputFilename.txt ./Outputs

echo -e "${GREEN}[SUCCESS]${WHITE} Directory scanning complete."
echo -e "${YELLOW}[INFO]${WHITE} The results for this scan can be viewed over at ./Outputs/${OutputFilename}.txt." && echo ""
exit 0
