#!/bin/env sh

opentracker_bin="$HOME/Coding/spicemustflow/opentracker/opentracker"
tracker_ip=192.168.1.55
tracker_port=6969
http_port=8080

if [ -z ${1} ]
then
	printf "spicemustflow : decentralize the text/data transfers within you LAN !\n"
	printf "By https://github.com/Myu-Unix, 2016\n\n"
	printf "Usage : spicemustflow.sh [url] [filename]\n"
	exit 0
fi

if [[ $1 == *"http"* ]] # Sharing a link with nc(1)
then
	echo "<a href="$1">$1</a>" > /tmp/link
	printf "Serving page through HTTP on port $http_port\n"
 	{ echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c </tmp/link)\r\n\r\n"; cat /tmp/link; } | nc -l -p $http_port

else # Sharing a file with bittorrent 			
	if [ -f $1 ]
	then
		# Extracting filename from absolute path
		long_filename=$1
		filename=$(echo $long_filename | rev | cut -d "/" -f 1 | rev)

		printf "Starting opentracker locally on port $tracker_port\n"
		$opentracker_bin -i $tracker_ip -p $tracker_port &

		# Since transmission defaults to ~/Downloads and our data might be elsewhere...ugly but will do for now.
		ln -s $long_filename $HOME/Downloads/$filename

		# Creating .torrent
		transmission-create -o ./$filename.torrent -t http://$tracker_ip:$tracker_port/announce $long_filename

		# busybox http serving .torrent file on port 8080
		echo "<a href="./$filename.torrent">$filename</a>" > ./index.html
		busybox httpd -f -p $http_port &

		# Seeding the torrent, 
		transmission-remote --auth 'spicemustflow:spicemustflow' -a ./$filename.torrent
		printf "\n--- Press a key to exit and close services cleanly ---\n\n"

		# Cleanup
		read pause
		pkill opentracker
		pkill busybox
		rm $HOME/Downloads/$filename
		rm /tmp/link
		rm ./index.html
		rm ./$filename.torrent
	else
		echo "File $1 doesnt exist"
		exit 1
	fi
fi