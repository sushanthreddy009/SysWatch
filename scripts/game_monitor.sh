#!/bin/bash

# Define log file path
GAME_LOG="/home/ec2-user/SysWatch/logs/lucky_number.log"

# Ensure log file exists
touch "$GAME_LOG"

# Count total games played
total_games=$(grep -cE "WIN|LOSE" "$GAME_LOG")

# Count wins and losses
total_wins=$(grep -c "WIN" "$GAME_LOG")
total_losses=$(grep -c "LOSE" "$GAME_LOG")

# Calculate win percentage
win_percentage=0
if [ "$total_games" -gt 0 ]; then
    win_percentage=$((total_wins * 100 / total_games))
fi

# Get CPU & RAM usage of the last game
cpu_usage=$(grep "CPU:" "$GAME_LOG" | tail -n 1 | awk -F'CPU: ' '{print $2}' | awk '{print $1}')
mem_usage=$(grep "RAM:" "$GAME_LOG" | tail -n 1 | awk -F'RAM: ' '{print $2}' | awk '{print $1}')

# Get log file size
log_size=$(du -h "$GAME_LOG" | awk '{print $1}')

# Get last game execution time
last_game_time=$(grep "Execution Time:" "$GAME_LOG" | tail -n 1 | awk -F'Execution Time: ' '{print $2}' | xargs)

# Display game monitoring report
echo "🎮 Game Monitoring Report:"
echo "----------------------------"
echo "📊 Total Games Played: $total_games"
echo "🏆 Total Wins: $total_wins"
echo "💀 Total Losses: $total_losses"
echo "📈 Win Percentage: $win_percentage%"
echo "----------------------------"
echo "🖥️ CPU Usage (Last Game): ${cpu_usage:-'N/A'}"
echo "🧠 RAM Usage (Last Game): ${mem_usage:-'N/A'}"
echo "📂 Log File Size: $log_size"
echo "⏳ Last Game Execution Time: ${last_game_time:-'N/A'}"
echo "----------------------------"
echo "📝 Last 10 Game Results:"
tail -n 10 "$GAME_LOG"

# 🔥 Fix: Instead of exiting, return to dashboard properly
read -p "Press Enter to return to the dashboard..."

exec ./dashboard.sh  # 🚀 This makes sure it actually goes back!
