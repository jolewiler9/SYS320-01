#!/bin/bash

# Display usage info
usage() {

    echo "Usage: $0 -f <firewall_type> [-c]"
    echo "Options:"
    echo "   -f <firewall_type>: Specify the firewall type (iptables, cisco, windows, mac)"
    echo "   -c: Create a Cisco URL filter ruleset from a CSV file"
    exit 1

}

# Default values
firewall_type=""
cisco_ruleset=false

# Parse command line options
while getopts "f:c" opt; do
    case "$opt" in
        f)
            firewall_type="$OPTARG"
            ;;
        c)
            cisco_ruleset=true
            if [ "$cisco_ruleset" = true ]; then
                wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -o targetedthreats.csv
                echo 'class-map match-any BAD_URLS' > cisco-rules.txt
                grep '"domain"' targetedthreats.csv.1 | awk -F ',' '{print $3}' | sort -u | sed 's/^"\(.*\)"$/match protocol http host "\1"/' >> cisco-rules.txt
                echo "Cisco URL filter rulset created..."
                rm targetedthreats.csv.1
             fi
            ;;
        *)
            usage
            ;;
    esac
done

# Check if firewall_type is empty
if [ -z "$firewall_type" ]; then
    usage
fi

# Generate appropriate inbound drop rule for selected firewall
case "$firewall_type" in
    iptables)
        echo "Creating an inbound drop rule for iptables."
        read -p "Enter the IP address/network you wish to block: " ip_address

        if [[ ! "$ip_address" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2} ]]; then
            echo "Invalid IP address format. Enter valid IP address."
            exit 1
        fi

        sudo iptables -A INPUT -s "$ip_address" -j DROP

        echo "Rule to block $ip_address added to iptables."
        ;;
    cisco)
        echo "Creating an inbound drop rule for cisco."
        read -p "Enter the IP address/network you wish to block: " ip_address
        read -p "Enter the interface you wish to apply the rule to: " interface

        if [[ ! "$ip_address" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2} ]]; then
            echo "Invalid IP address format. Enter valid IP address."
            exit 1
        fi

        enable

        config t

        access-list deny_ip_traffic extended deny ip host ${ip_address} any

        access-group deny_ip_traffic in interface ${interface}

        end

        write memory
        echo "Configurating firewall rules..."
        ;;
    windows)
        echo "Creating an inbound drop rule for windows."
        read -p "Enter the IP address/network you wish to block: " ip_address

        if [[ ! "$ip_address" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2} ]]; then
            echo "Invalid IP address format. Enter valid IP address."
            exit 1
        fi

        netsh advfirewall firewall add rule name="Block Network" dir=in action=block enable=yes remoteip=${ip_address}
        echo "Configurating firewall rules..."
        ;;
    mac)
        echo "Creating an inbound drop rule for mac."
        read -p "Enter the IP address/network you wish to block: " ip_address

        if [[ ! "$ip_address" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2} ]]; then
            echo "Invalid IP address format. Enter valid IP address."
            exit 1
        fi

        echo "block in from ${ip_address} to any" | tee -a pf.conf
        ;;
    *)
        echo "Unsupported firewall type: $firewall_type"
        usage
        ;;
esac
