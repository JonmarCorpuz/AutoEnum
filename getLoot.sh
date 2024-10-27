# Check if a post scan was done with pScan.sh

# Check if anonymous login is allowed on FTP

if grep -q $TargetAddress 
then 
   echo "OK"
#   wget -m --no-passive ftp://anonymous:anonymous@<TARGET_IP>
else
   echo "NOT OK"
fi
