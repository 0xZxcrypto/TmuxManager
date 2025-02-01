#!/bin/bash

# Format tanggal dan waktu
DATE_NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Warna untuk tampilan yang lebih estetik
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

# Log file
LOG_FILE="/var/log/Cleaner.log"

# Header
echo -e "${GREEN}====================================" | tee -a "$LOG_FILE"
echo -e "${YELLOW}  Pembersihan & Optimasi Sistem - $DATE_NOW" | tee -a "$LOG_FILE"
echo -e "${GREEN}====================================" | tee -a "$LOG_FILE"

# 1. Hapus log dan file lama
echo -e "${YELLOW}[INFO] Menghapus log dan file lama..." | tee -a "$LOG_FILE"
sudo journalctl --vacuum-time=1d
sudo find /var/log -type f \( -name "*.log" -o -name "*.gz" \) -exec rm -f {} \;

# 2. Hapus cache dan file sementara
echo -e "${YELLOW}[INFO] Menghapus cache APT dan file sementara..." | tee -a "$LOG_FILE"
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo rm -rf /tmp/* /var/tmp/*

# 3. Optimasi Swap dan Memori
echo -e "${YELLOW}[INFO] Mengoptimalkan memori dan swap..." | tee -a "$LOG_FILE"
sudo sync && sudo sysctl -w vm.drop_caches=3
sudo swapoff /dev/zram0
echo 536870912 | sudo tee /sys/block/zram0/disksize
sudo mkswap /dev/zram0
sudo swapon /dev/zram0

# 4. Hapus cache thumbnail
echo -e "${YELLOW}[INFO] Menghapus cache thumbnail..." | tee -a "$LOG_FILE"
rm -rf ~/.cache/thumbnails/*

# 5. Matikan layanan tidak penting
echo -e "${YELLOW}[INFO] Mematikan layanan yang tidak diperlukan..." | tee -a "$LOG_FILE"
sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service

# 6. Menampilkan status setelah pembersihan
echo -e "${GREEN}====================================" | tee -a "$LOG_FILE"
echo -e "${YELLOW}Pembersihan & Optimasi Selesai!" | tee -a "$LOG_FILE"
echo -e "${GREEN}====================================" | tee -a "$LOG_FILE"

# Menampilkan status sistem
df -h | tee -a "$LOG_FILE"
free -h | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Footer
echo -e "${GREEN}====================================" | tee -a "$LOG_FILE"
