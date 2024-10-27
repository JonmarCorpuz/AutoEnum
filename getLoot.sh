#
cat ./Outputs/grep*.txt | grep -q "Host" > ScannedHosts.txt

if [ -s ScannedHosts.txt ]; then
    # The file is not-empty.
    # awk "{print $2}" ScannedHosts.txt
    while read Host;
    do
        HostAddress=$(echo $Host | awk  "{print $2}")

        if ! cat ScannedHosts.txt | grep -q $HostAddress;
        then
            echo "$HostAddress" > TargetHosts.txt
        fi
    done < ScannedHosts.txt
else
    # The file is empty.
    echo "NAH"
fi

# Check if anonymous login is allowed on FTP
while read Host;
   wget -m --no-passive ftp://anonymous:anonymous@$Host
done < TargetHosts.txt
