#!/bin/bash

echo -n "Enter your username: "
read username

# Check if username exists
if ! grep -q "^$username:" auth/users.db; then
    echo "Error: Username not found!"
    exit 1
fi

echo -n "Enter new password: "
read -s new_password
echo

# Hash the new password
hashed_password=$(echo "$new_password" | sha256sum | awk '{print $1}')

# Update the password in users.db
sed -i "s/^$username:.*/$username:$hashed_password/" auth/users.db

echo "Password reset successful! You can now log in with your new password."
