#!/bin/bash

# Warna untuk estetik
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

# Fungsi untuk menjalankan bot dalam tmux dengan input otomatis
start_bot() {
    local SESSION=$1
    local FOLDER=$2
    local COMMAND=$3
    local INPUT=$4

    # Cek apakah sesi sudah berjalan
    if tmux has-session -t "$SESSION" 2>/dev/null; then
        echo -e "${BLUE}$SESSION sudah berjalan.${RESET}"
    else
        tmux new-session -d -s "$SESSION" "bash -c 'cd $FOLDER && $COMMAND'" 
        echo -e "${YELLOW}Menjalankan $SESSION...${RESET}"

        # Kirim input otomatis jika ada
        if [[ -n "$INPUT" ]]; then
            sleep 2  # Beri jeda agar proses siap menerima input
            tmux send-keys -t "$SESSION" "$INPUT" C-m
            echo -e "${GREEN}Input otomatis dikirim ke $SESSION: $INPUT${RESET}"
        fi
    fi
}

# Menampilkan header estetika
echo -e "${GREEN}========================================="
echo -e "${YELLOW}   BOT STARTUP SCRIPT - AUTOMATED RUNNING"
echo -e "${GREEN}========================================="
echo ""

# Jalankan bot yang bisa langsung dijalankan
start_bot "NGARIT" "/home/hg680p/NGARIT" "node index.js"
start_bot "DEPINED" "/home/hg680p/Depined-BOT" "node main.js"
start_bot "MYGATE" "/home/hg680p/mygateBot" "node main.js"
start_bot "MEOWTOPIA" "/home/hg680p/meowBot" "node main.js"
start_bot "LAYEREDGE" "/home/hg680p/LayerEdge-BOT" "node main.js"
start_bot "DESPEED" "/home/hg680p/despeedBot" "npm run start"
start_bot "MESHCHAIN" "/home/hg680p/mesh-bot" "node main.js"
start_bot "LITAS" "/home/hg680p/litasBot" "node main.js"

# Jalankan BLESS dengan input otomatis "n"
start_bot "BLESS" "/home/hg680p/bless-bot" "node main.js" "n"

# Jalankan TENEO dengan input otomatis "n" lalu "y"
start_bot "TENEO" "/home/hg680p/teneo-bot" "node index.js" "n"
sleep 1
tmux send-keys -t "TENEO" "y" C-m
echo -e "${GREEN}TENEO sudah dijalankan dengan input otomatis: n dan y.${RESET}"

# DAWN: Buat sesi, aktifkan venv, lalu jalankan bot, kemudian pilih opsi 3
if ! tmux has-session -t "DAWN" 2>/dev/null; then
    tmux new-session -d -s "DAWN" "bash -c 'source /home/hg680p/venv/bin/activate && cd /home/hg680p/Dawn-BOT && python3 bot.py'"
    echo -e "${YELLOW}Sesi DAWN dibuat dan venv diaktifkan.${RESET}"
    sleep 2
    tmux send-keys -t "DAWN" "3" C-m
    echo -e "${GREEN}Opsi 3 telah dipilih di DAWN.${RESET}"
fi
#DEPINED AUTO ENTRY KEY 
#if ! tmux has-session -t "DEPINED" 2>/dev/null; then
 #   tmux new-session -d -s "DEPINED" "bash -c 'source /home/hg680p/venv/bin/activate && cd /home/hg680p/depinedBot && python3 bot.py'"
 #   echo -e "${YELLOW}Sesi DEPINED dibuat dan venv diaktifkan.${RESET}"
 #   sleep 2
 #   tmux send-keys -t "DEPINED" "3" C-m
 #   echo -e "${GREEN}Opsi 3 telah dipilih di DEPINED.${RESET}"
#fi

# Menampilkan pesan penutupan
echo -e "${GREEN}========================================="
echo -e "${YELLOW}   SEMUA BOT TELAH DIJALANKAN DI TMUX!"
echo -e "${GREEN}========================================="
