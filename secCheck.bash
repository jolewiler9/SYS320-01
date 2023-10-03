#!/bin/bash

# Perform various security checks on configuration files within the system
# If they don't comply with standard, outline how to remedy

function checks() {

	if [[ $2 != $3 ]]
	then

		echo -e  "\e[1;31mThe $1 is not compliant. The current policy should be: $2, the current policy is: $3.\e[0m"

	else

		echo -e  "\e[1;32mThe $1 is compliant. Current value is: $3.\e[0m"

	fi

}

# Check IP Forwarding policy
ipfwd=$(grep "net\.ipv4\.ip_forward" /etc/sysctl.conf | awk ' { print $1 } ')
checks "Ip Forwarding" "net.ipv4.ip_forward=0" "${ipfwd}""\nRemediation\nEdit /etc/sysctl.conf and set:\n net.ipv4.ip_forward=1\nto\n net.ipv4.ip_foward=0.\nThen run: \n sysctl -w"

#Check ICMP Redirects policy
icmp=$(grep "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf | awk '{print $3}''{print $5}''{print $9}')
checks "Recive ICMP Redirects" "0" "${icmp}"

# Check Crontab file directory permissions
crontab=$(stat /etc/crontab | grep '(' | awk '{print $2}')
crontab2=$(stat /etc/crontab | grep '(' | awk '{print $5}')
crontab3=$(stat /etc/crontab | grep '(' | awk '{print $9}')
checks "Crontab File Permissions" "(0600/-rw------)" "${crontab}""\nRemediation\nRun: \n chown root:root /etc/crontab\nThen: \n chmod og-rwx /etc/crontab"
checks "Crontab File Uid" "0/" "${crontab2}"
checks "Crontab File Gid" "0/" "${crontab3}"

# Check Cron.hourly file permissions
cronhourly=$(stat /etc/cron.hourly | grep '(' | awk '{print $2}')
cronhourly2=$(stat /etc/cron.hourly | grep '(' | awk '{print $5}')
cronhourly3=$(stat /etc/cron.hourly | grep '(' | awk '{print $9}')
checks "Cron.hourly File Permissions" "(0700/drwx-----)" "${cronhourly}""\nRemediation\nRun: \n chown root:root /etc/cron.hourly\nThen: \n chmod og-rwx /etc/cron.hourly"
checks "Cron.hourly File Uid" "0/" "${cronhourly2}"
checks "Cron.hourly File Gid" "0/" "${cronhourly3}"

# Checks cron.daily permission config
crondaily=$(stat /etc/cron.daily | grep '(' | awk '{print $2}')
crondaily2=$(stat /etc/cron.daily | grep '(' | awk '{print $5}')
crondaily3=$(stat /etc/cron.daily | grep '(' | awk '{print $9}')
checks "Cron.daily File Permissions" "(0700/drwx-----)" "${crondaily}""\nRemediation\nRun: \n chown root:root /etc/cron.daily\nThen: \n chmod og-rwx /etc/cron.daily"
checks "Cron.daily File Uid" "0/" "${crondaily2}"
checks "Cron.daily File Gid" "0/" "${crondaily3}"

# Checks cron.weekly file permissions
cronweekly=$(stat /etc/cron.weekly | grep '(' | awk '{print $2}')
cronweekly2=$(stat /etc/cron.weekly | grep '(' | awk '{print $5}')
cronweekly3=$(stat /etc/cron.weekly | grep '(' | awk '{print $9}')
checks "Cron.weekly File Permissions" "(0700/drwx-----)" "${cronweekly}""\nRemediation\nRun: \n chown root:root /etc/cron.weekly\nThen: \n chmod og-rwx /etc/cron.weekly"
checks "Cron.weekly File Uid" "0/" "${cronweekly2}"
checks "Cron.weekly File Gid" "0/" "${cronweekly3}"

# Checks cron.monthly file permissions
cronmonthly=$(stat /etc/cron.monthly | grep '(' | awk '{print $2}')
cronmonthly2=$(stat /etc/cron.monthly | grep '(' | awk '{print $5}')
cronmonthly3=$(stat /etc/cron.monthly | grep '(' | awk '{print $9}')
checks "Cron.monthly File Permissions" "(0700/drwx-----)" "${cronmonthly}""\nRemediation\nRun: \n chown root:root /etc/cron.monthly\nThen: \n chmod og-rwx /etc/cron.monthly"
checks "Cron.monthly File Uid" "0/" "${cronmonthly2}"
checks "Cron.monthly File Gid" "0/" "${cronmonthly3}"

# Checks passwd file permissions
passwd=$(stat /etc/passwd | grep '(' | awk '{print $2}')
passwd2=$(stat /etc/passwd | grep '(' | awk '{print $5}')
passwd3=$(stat /etc/passwd | grep '(' | awk '{print $9}')
checks "Passwd File Permissions" "(0644/-rw-r--r--)" "${passwd}"
checks "Passwd File Uid" "0/" "${passwd2}"
checks "Passwd File Gid" "0/" "${passwd3}"

# Checks shadow dile permissions
shadow=$(stat /etc/shadow | grep '(' | awk '{print $2}')
shadow2=$(stat /etc/shadow | grep '(' | awk '{print $5}')
shadow3=$(stat /etc/shadow | grep '(' | awk '{print $9}')
checks "Shadow File Permissions" "(0640/-rw-r-----)" "${shadow}"
checks "Shadow File Uid" "0/" "${shadow2}"
checks "Shadow File Gid" "42/" "${shadow3}"

# Checks group file permissions
group=$(stat /etc/group | grep '(' | awk '{print $2}')
group2=$(stat /etc/group | grep '(' | awk '{print $5}')
group3=$(stat /etc/group | grep '(' | awk '{print $9}')
checks "Group File Permissions" "(0644/-rw-r--r--)" "${group}"
checks "Group File Uid" "0/" "${group2}"
checks "Group File Gid" "0/" "${group3}"

# Checks gshadow file permission
gshadow=$(stat /etc/gshadow | grep '(' | awk '{print $2}')
gshadow2=$(stat /etc/gshadow | grep '(' | awk '{print $5}')
gshadow3=$(stat /etc/gshadow | grep '(' | awk '{print $9}')
checks "Gshadow File Permissions" "(0640/-rw-r-----)" "${gshadow}"
checks "Gshadow File Uid" "0/" "${gshadow2}"
checks "Gshadow File Gid" "42/" "${gshadow3}"

# Checks passwd- file permissions
passwddash=$(stat /etc/passwd- | grep '(' | awk '{print $2}')
passwddash2=$(stat /etc/passwd- | grep '(' | awk '{print $5}')
passwddash3=$(stat /etc/passwd- | grep '(' | awk '{print $9}')
checks "Passwd- File Permissions" "(0644/-rw-r--r--)" "${passwddash}"
checks "Passwd- File Uid" "0/" "${passwddash2}"
checks "Passwd- File Gid" "0/" "${passwddash3}"

# Checks group- file pemissions
groupdash=$(stat /etc/group- | grep '(' | awk '{print $2}')
groupdash2=$(stat /etc/group- | grep '(' | awk '{print $5}')
groupdash3=$(stat /etc/group- | grep '(' | awk '{print $9}')
checks "Group- File Permissions" "(0644/-rw-r--r--)" "${groupdash}"
checks "Group- File Uid" "0/" "${groupdash2}"
checks "Group- File Gid" "0/" "${groupdash3}"

# Checks shadow- file permissions
shadowdash=$(stat /etc/shadow- | grep '(' | awk '{print $2}')
shadowdash2=$(stat /etc/shadow- | grep '(' | awk '{print $5}')
shadowdash3=$(stat /etc/shadow- | grep '(' | awk '{print $9}')
checks "Shadow- File Permissions" "(0640/-rw-r-----)" "${shadowdash}"
checks "Shadow- File Uid" "0/" "${shadowdash2}"
checks "Shadow- File Gid" "42/" "${shadowdash3}"

# Checks gshadow- file permissions
gshadowdash=$(stat /etc/gshadow- | grep '(' | awk '{print $2}')
gshadowdash2=$(stat /etc/gshadow- | grep '(' | awk '{print $5}')
gshadowdash3=$(stat /etc/gshadow- | grep '(' | awk '{print $9}')
checks "Gshadow- File Permissions" "(0640/-rw-r-----)" "${gshadowdash}"
checks "Gshadow- File Uid" "0/" "${gshadowdash2}"
checks "Gshadow- File Gid" "42/" "${gshadowdash3}"

# Checks for legacy entries in the passwd, shadow, and group files
legacyPasswd=$(grep '^\+:' /etc/passwd)
checks "Legacy Entries in Passwd" "" ""

legacyShadow=$(sudo grep '^\+:' /etc/shadow)
checks "Legacy Entries in Shadow" "" ""

legacyGroup=$(grep '^\+:' /etc/group)
checks "Legacy Entries in Group" "" ""

# Checks if any other users have a UID of 0

uid0=$(cat /etc/passwd | awk -F: '($3 == 0) {print $1}')
checks "Users with UID of 0" "root" "${uid0}"
