# 🚀 SysWatch - The Ultimate System Monitoring Bash Scripts

## 🧐 What is SysWatch?

**SysWatch** is a collection of lightweight, powerful, and super cool Bash scripts to monitor various aspects of your system like CPU, memory, disk usage, processes, and network activity. Whether you're a system admin, developer, or just someone who wants to keep an eye on their system stats, SysWatch has got your back! 💻🔥

## 🌟 Features

- **CPU Monitoring** 🏋️‍♂️ - Keep track of CPU usage and load averages.
- **Memory Monitoring** 🧠 - Check available and used RAM.
- **Disk Monitoring** 💾 - Get detailed storage usage insights.
- **Process Monitoring** 🧐 - Track running processes and resource consumption.
- **Network Monitoring** 🌐 - Monitor network traffic and active connections.
- **Game Monitoring** 🎮 - Because why not? Detect running games and their resource usage. 

## 📂 Project Structure

```
SysWatch/
│── auth/                  # User authentication scripts
    │── singup.sh
    │── login.sh
    │── logout.sh
    │── forgot_password.sh
│── dashboard.sh           # Main Dashboard to run all the scripts        
│── scripts/               # Main monitoring scripts
│   │── cpu_monitor.sh     # CPU monitoring
│   │── disk_monitor.sh    # Disk monitoring
│   │── game_monitor.sh    # Game monitoring for lucky_number_3chances.sh
│   │── memory_monitor.sh  # Memory monitoring
│   │── network_monitor.sh # Network monitoring
│   │── process_monitor.sh # Process monitoring
│── game/                  # Game-related scripts
    │── lucky_number_3chances.sh               
│── logs/                  # Log files
│── alerts/                # alerts will be stored here
│── reports/               # Generated reports (optional)
│── README.md              # This beautiful documentation 🎉
```

## Main Dashboard

![image](https://github.com/user-attachments/assets/37bb2fff-1acb-4975-a783-5402318f3681)


## 🛠️ Installation

1. **Clone this repository** 🏃💨
   ```bash
   git clone https://github.com/sushanthereddy009/SysWatch.git
   cd SysWatch
   ```
2. **Give execution permission** 🔑
   ```bash
   chmod +x scripts/*.sh dashboard.sh
   ```
3. **Run the script of your choice!** 🚀
   ```bash
   ./scripts/cpu_monitor.sh
   ```

## 🎯 Usage

Each script is designed to be run standalone. Here’s how they work:

### 📊 CPU Monitoring

```bash
./scripts/cpu_monitor.sh
```

**What it does:**

- Displays real-time CPU usage.
- Shows system load averages.

### 🧠 Memory Monitoring

```bash
./scripts/memory_monitor.sh
```

**What it does:**

- Shows available and used RAM.
- Helps in detecting memory-hungry applications.

### 💾 Disk Monitoring

```bash
./scripts/disk_monitor.sh
```

**What it does:**

- Lists all mounted partitions and their usage.
- Alerts when disk space is low.

### 🌐 Network Monitoring

```bash
./scripts/network_monitor.sh
```

**What it does:**

- Shows active network interfaces and their IP addresses.
- Monitors network traffic using `sar`.

### 🧐 Process Monitoring

```bash
./scripts/process_monitor.sh
```

**What it does:**

- Lists top resource-consuming processes.
- Helps in killing unwanted processes (if needed).

### 🎮 Game Monitoring

```bash
./scripts/game_monitor.sh
```

**What it does:**

- Detects running games (because FPS drops matter! 🎮💔).
- Monitors their CPU and memory usage.

## 🛡️ Running as Root?

Some scripts require root privileges for full functionality. If you see this warning:

```bash
Run as root for full details!
```

Simply execute the script with `sudo`:

```bash
sudo ./scripts/network_monitor.sh
```

## 🤓 Fun Facts & Easter Eggs 🎉

- This project was built while having **way too much coffee ☕**.
- It started as a simple CPU monitor and turned into an entire system monitoring toolkit.
- If you find a bug, it’s a **feature**. Just kidding, open an issue!

## 📜 License

**SysWatch** is open-source and available under the MIT License. Use it, modify it, break it, fix it, and share it! 😃

## ❤️ Support

If you like this project, consider **starring ⭐ the repository**. It keeps us motivated!

---

🚀 **Monitor like a Pro!** 🚀
