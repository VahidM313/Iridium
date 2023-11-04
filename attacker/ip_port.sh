#!/bin/bash

# IP range
ip_range="172.85.69.0/24"

# Output file
output_file="open_ports.csv"

# Write the header to the CSV file
echo "IP,Server Name,Port 22 Status" > $output_file

# Scan the IP range
for ip in $(nmap -sn -PR -n $ip_range | grep report | awk '{print $5}'); do
    # Check if port 22 is open
    port_status=$(nmap -p 22 -n $ip | grep 22/tcp | awk '{print $2}')
    
    # Get the server name
    server_name=$(nslookup $ip | grep 'name = ' | cut -d '=' -f2 | cut -d '.' -f1)
    
    # If server name is empty, use the IP address
    if [ -z "$server_name" ]; then
        server_name=$ip
    fi
    
    # Write the result to the CSV file
    echo "$ip,$server_name,$port_status" >> $output_file
done