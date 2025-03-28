#!/bin/bash

# Ask for username and password
read -p "Enter username: " username
read -s -p "Enter password: " password
echo

# Check if user exists
if grep -q "^$username:" auth/user_data.txt; then
    stored_hash=$(grep "^$username:" auth/user_data.txt | cut -d':' -f2)
    entered_hash=$(echo -n "$password" | sha256sum | awk '{print $1}')

    if [ "$entered_hash" == "$stored_hash" ]; then
        echo "Login successful!"
        echo "=================================================================="
        echo " Ah, there you are! Logged in and ready to make today legendary. ✨"
        echo "=================================================================="
        echo "$username" > auth/session.txt

        # 🚀 RUN DASHBOARD AND EXIT LOGIN MENU COMPLETELY
        ./dashboard.sh
        exit  # 🚀 Completely exit login script

    else
        echo "Invalid username or password!"
    fi
else
    echo "Invalid username or password!"
fi
