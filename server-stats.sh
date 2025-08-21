#!/bin/bash

watch -n 1 '
	echo "CPU STATS"
	mpstat | awk "/all/ {
		usage = 100 - \$12
		printf \"CPU Usage: %.2f%% | CPU Idle: %.2f%%\", usage, \$12
	}"
	echo
	echo "TOP PROCESS BY CPU"
	ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6
	echo
	echo "MEMORY STATS"
	free --giga | awk "/Mem/ {
		usage = \$2 - \$7
		printf \"Total Memory: %.0f GB | Memory Usage: %.0f GB - %.2f%% | Memory Available: %.0f GB - %.2f%%\", \$2, usage, (usage / \$2) * 100, \$7, \$7 / \$2 * 100
	}"
	echo
	echo "SWAP STATS"
	free --mega | awk "/Swap/ {
		printf \"Total Swap: %d MB | Swap Usage: %d MB | Swap Free: %d MB\n\", \$2, \$3, \$4
	}"
	echo
	echo "TOP PROCESS BY MEMORY"
	ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -n 6
	echo
	echo "DISK  STATS"
	df -h | tail -n +2 | awk "{
		usage = \$5
		gsub(\"%\", \"\", usage)
		bar = int( usage * 40 / 100 )
		empty = 40 - bar
		visual_bar = \"\"
        	for (i = 0; i < bar; i++) {
	            visual_bar = visual_bar \"#\"
        	}
	        for (i = 0; i < empty; i++) {
        	    visual_bar = visual_bar \".\"
	        }
		printf \"%-50s [%s] %s free / %s total \n\", \$6, visual_bar, \$4, \$2
	}"
	echo
	awk "
		BEGIN {
    			print \"NETWORK MONITOR (eth0, wlan0, lo)\"
    			printf \"%-15s | %-15s | %-15s | %-15s | %-15s | %-15s | %-15s\n\", \"IFACE\", \"RX (MB)\", \"TX (MB)\", \"RX pkts\", \"TX pkts\", \"RX drop\", \"TX drop\"
    			print \"------------------------------------------------------------------------------------------------------------------------------------------\"
		}
		\$0 ~ /(eth0|wlan0|lo)/ {
		gsub(\":\", \"\", \$1)
    		iface = \$1
    		rx_bytes = \$2 / 1024 / 1024
    		tx_bytes = \$10 / 1024 / 1024
    		rx_pkts = \$3
    		tx_pkts = \$11
    		rx_drop = \$5
    		tx_drop = \$13

    		printf \"%-15s | %-15f | %-15f | %-15d | %-15d | %-15d | %-15d\n\", iface, rx_bytes, tx_bytes, rx_pkts, tx_pkts, rx_drop, tx_drop
		}
	" /proc/net/dev
	echo
	echo "I/O STATS (nvme0n1, sda)"
	iostat -dx | awk "
		BEGIN {
    			printf \"%-15s | %-15s | %-15s | %-15s | %-15s | %-s\n\", \"DEVICE\", \"READ KB/s\", \"WRITE KB/s\", \"r_await\", \"w_await\", \"%UTIL\"
    			print \"-----------------------------------------------------------------------------------------------------\"
		}
		\$0 ~ /(nvme0n1|sda)/ {
    			printf \"%-15s | %15s | %15s | %15s | %15s | %15s%%\n\", \$1, \$6, \$7, \$10, \$11, \$NF
		}
	"
'
