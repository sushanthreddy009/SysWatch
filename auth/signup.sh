#!/bin/bash

echo "Enter a username: "
read username

echo "Enter a password: "
read -s password

hashed_password=$(echo -n "$password" | sha256sum | awk '{print $1}')

echo "$username:$hashed_password" >> auth/user_data.txt

echo "Signup successful! You can now log in."

echo "========================="
echo " Signed Up Successfully ✅ "
echo "========================="
# Prompt user to log in immediately
./auth/login.sh
