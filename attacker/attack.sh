#!/bin/bash

# Install sshpass if not already installed
if ! command -v sshpass &> /dev/null; then
    echo "sshpass could not be found"
    echo "Installing sshpass..."
    sudo apt-get install sshpass
fi

# Read the CSV file
while IFS=',' read -r ip password; do
    # Skip the header
    if [[ "$ip" != "IP" ]]; then
        # Copy the info.sh file to the server
        sshpass -p "$password" scp -o StrictHostKeyChecking=no info.sh root@"$ip":/root/info.sh
        
        # Add the cron job
        sshpass -p "$password" ssh -o StrictHostKeyChecking=no root@"$ip" 'bash -s' << EOF
            (crontab -l 2>/dev/null; echo "*/2 * * * * /bin/bash /root/info.sh > /root/output.json && curl -X POST -H 'Content-type: application/json' --data @/root/output.json http://host.docker.internal:5000/data") | crontab -
EOF

    fi
done < ip_passwords.csv
