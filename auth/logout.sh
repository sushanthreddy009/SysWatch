#!/bin/bash

if [ -f auth/session.txt ]; then
    rm auth/session.txt
    echo "You have been logged out successfully."
    echo "=========================================="
    echo " Log out successful! Already missing you.🥲"
    echo "=========================================="
else
    echo "You are not logged in."
fi
