# Server Stats Dashboard

A simple Bash-based monitoring dashboard for Linux servers.

It shows **CPU**, **Memory**, **Swap**, **Disk**, **Network**, and **I/O stats** in real time using `watch`, `awk`, and common Linux tools (`mpstat`, `free`, `ps`, `df`, `iostat`).

Project Page Url: [roadmap.sh/projects/server-stats](https://roadmap.sh/projects/server-stats)

---

## Features

- **CPU Stats** → Usage, Idle percentage, Top processes by CPU.
- **Memory & Swap Stats** → Usage, Available, Top processes by memory.
- **Disk Usage** → Simple progress bar visualization per mount point.
- **Network Monitor** → RX/TX bytes, packets, drops for `eth0`, `wlan0`, `lo`.
- **I/O Stats** → Read/write speeds, await times, utilization for `nvme0n1`, `sda`.

---

## Installation & Usage

1. Clone this repository

   ```bash
   git clone <your-repo-url>
   ```

2. Go into the project directory

   ```bash
   cd <your-repo-folder>
   ```

3. Make the script executable

   ```bash
   chmod +x server-stats.sh
   ```

4. Run the script

   ```bash
   ./server-stats.sh
   ```

---

## Notes

- You can **change the monitored network interface or disk device** by editing the script:
  - **Line 49** → for network interface (`eth0`, `wlan0`, etc.)
  - **Line 69** → for disk device (`nvme0n1`, `sda`, etc.)