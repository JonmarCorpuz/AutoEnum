# Check if FTP port is listening
cat ./Outputs/grep*.txt | grep -q "Host" > ScannedHosts.txt

if [ -s ScannedHosts.txt ]; then
        # The file is not-empty.
      
else
        # The file is empty.
fi

# Check if anonymous login is allowed on FTP
if grep -q "Anonymous FTP login allowed";
then 
   echo "OK"
#   wget -m --no-passive ftp://anonymous:anonymous@<TARGET_IP>
else
   echo "NOT OK"
fi
