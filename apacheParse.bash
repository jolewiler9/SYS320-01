#!/bin/bash

#Parse Apache log
# 116.58.239.126 - - [30/Sep/2018:08:17:33 -0500] "GET / HTTP/1.1" 200 225 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
#Read in file

#Arguments using the position
APACHE_LOG="$1"

#Check if file exists
if [[ ! -f ${APACHE_LOG} ]]
then
	echo "Please specify the path to a log file"
	exit 1
fi

# Web Scanners in log
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-6s %-6s %-1s %s\n"
		printf format, "IP", "Date", "Method", "Status", "Size", "URI"
		printf format, "--", "----", "------", "------", "----", "---" }
{ printf format, $1, $4, $6, $9, $10, $7 }'

# Creates iptables ruleset for logged badIPs
awk '{print $1}' access.log > temp_ips.txt

access_log="access.log"
iptables_file="BlockedIPs.iptables"
temp_file="temp_ips.txt"

if [ -s "$temp_file" ] && [ -f "$access_log" ]; then

	while read -r ip; do
		echo "-A INPUT -s $ip -j DROP" >> "$iptables_file"
	done < "$temp_file"

	sort -u -o "$iptables_file" "$iptables_file"

	echo "Iptables rules added to $iptables_file."
fi

