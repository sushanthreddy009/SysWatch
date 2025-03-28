#!/bin/bash

# Ensure user is logged in
if [ ! -f auth/session.txt ]; then
    echo "Error: You must be logged in to access the dashboard!"
    exit 1
fi

# Create necessary directories if not present
mkdir -p logs game_logs

echo "Welcome to the SysWatch Dashboard!"
echo "1. CPU Monitoring"
echo "2. Network Monitoring"
echo "3. Disk Monitoring"
echo "4. Memory Monitoring"
echo "5. Process Monitoring"
echo "6. User Monitoring"
echo "7. Lucky_number_game"
echo "8. Monitor the Game"
echo "9. Logout"
echo "10. Exit"

read -p "Choose an option: " choice

case $choice in
    1) bash scripts/cpu_monitor.sh | tee -a logs/cpu_monitor.log ;;
    2) bash scripts/network_monitor.sh | tee -a logs/network_monitor.log ;;
    3) bash scripts/disk_monitor.sh | tee -a logs/disk_monitor.log ;;
    4) bash scripts/memory_monitor.sh | tee -a logs/memory_monitor.log ;;
    5) bash scripts/process_monitor.sh | tee -a logs/process_monitor.log ;;
    6) cat  auth/user_data.txt ;;
    7) bash game/lucky_number_3chances.sh ;;  # Starts the game
    8) bash scripts/game_monitor.sh ;; # Monitors the game
    9) bash auth/logout.sh ;;
    10) echo "Exiting..."; exit 0 ;;
    *) echo "Invalid option!" ;;
esac
