#!/bin/sh

# Get the server name
server_name=$CONTAINER_NAME

# Get the IP address
ip_address=$(hostname -i)

# Get the CPU model and remove the "model name :" part
cpu_model=$(cat /proc/cpuinfo | grep 'model name' | uniq | cut -d ':' -f 2 | sed 's/^ *//g')

# Get the architecture
architecture=$(uname -m)

# Get the memory size
memory_size=$(free -h | grep Mem | awk '{print $2}')

# Get the hard disk space
hard_disk_space=$(df -h | grep '^/dev' | awk '{print $1 " " $2 " " $3 " " $4}')

# Get the date and time
date_time=$(date)

# Get the Linux distribution information
linux_distro=$(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f 2 | sed 's/^ *//g' | sed 's/"//g')

# Create a JSON object
json="{\"Server Name\":\"$server_name\",\"IP Address\":\"$ip_address\",\"CPU Model\":\"$cpu_model\",\"Architecture\":\"$architecture\",\"Memory Size\":\"$memory_size\",\"Hard Disk Space\":\"$hard_disk_space\",\"Date and Time\":\"$date_time\",\"Linux Distribution\":\"$linux_distro\"}"

# Write the JSON object to a file
echo $json > output.json
