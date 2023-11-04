#!/bin/bash

# Run ip_port.sh
./ip_port.sh
if [ $? -ne 0 ]; then
    echo "ip_port.sh failed"
    exit 1
fi

# Run ip_password.sh
./ip_password.sh
if [ $? -ne 0 ]; then
    echo "ip_password.sh failed"
    exit 1
fi

# Run attack.sh
./attack.sh
if [ $? -ne 0 ]; then
    echo "attack.sh failed"
    exit 1
fi

echo "All scripts ran successfully"