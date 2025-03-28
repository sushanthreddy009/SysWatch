#!/bin/bash

# Define log file path
GAME_LOG="/home/ec2-user/SysWatch/logs/lucky_number.log"
mkdir -p "$(dirname "$GAME_LOG")"  # Ensure logs directory exists

echo "🎲 Welcome to Lucky Number Duel!"
echo "Try your luck! Pick a number between 1 and 20."
echo "You have 3 chances to guess the lucky number!"

# Generate a random lucky number between 1 and 20
lucky_number=$((RANDOM % 20 + 1))
attempts=3

# Capture start time & PID
start_time=$(date +%s)
pid=$$  # Get process ID
echo "PID: $pid" >> "$GAME_LOG"

while (( attempts > 0 )); do
    read -p "Enter your lucky number (1-20): " player_number

    # Validate input
    if ! [[ "$player_number" =~ ^[0-9]+$ ]] || (( player_number < 1 || player_number > 20 )); then
        echo "❌ Hey! Enter a number between 1 and 20!"
        continue
    fi

    # Check the guess
    if (( player_number == lucky_number )); then
        echo "🎉 WOW! You guessed it right! The lucky number was $lucky_number! YOU WIN! 🎊"
        result="WIN"
        break
    else
        (( attempts-- ))
        case $attempts in
            2) echo "😂 Oops! That's not it. Maybe your luck will improve next time!" ;;
            1) echo "🤦 Seriously? Come on! You have one last chance!" ;;
            0) echo "💀 GAME OVER! You lost! The lucky number was $lucky_number. Better luck next time!"
               result="LOSE"
               ;;
        esac
    fi
done

# Capture end time and execution duration
end_time=$(date +%s)
execution_time=$((end_time - start_time))

# Capture CPU & RAM usage **before** process exits
cpu_usage=$(ps -p "$pid" -o %cpu --no-headers 2>/dev/null | awk '{print $1"%"}')
mem_usage=$(ps -p "$pid" -o %mem --no-headers 2>/dev/null | awk '{print $1"%"}')

# Default to "N/A" if the values couldn't be captured
cpu_usage=${cpu_usage:-"N/A"}
mem_usage=${mem_usage:-"N/A"}

# Log results
echo "$(date): $result | Execution Time: ${execution_time}s | CPU: $cpu_usage | RAM: $mem_usage" >> "$GAME_LOG"

# Return to dashboard
read -p "Press Enter to return to the dashboard..."
exec ./dashboard.sh
