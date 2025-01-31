#!/bin/bash

# Definisikan warna untuk estetika
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

# Fungsi animasi loading spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spin='|/-\'
    while ps -p $pid > /dev/null; do
        for i in $(seq 0 3); do
            echo -ne "\r${BLUE}Memproses... ${spin:$i:1} ${RESET}"
            sleep $delay
        done
    done
    echo -ne "\r${GREEN}✓ Selesai! ${RESET}                     \n"
}

# Header dan pesan pembuka dengan gambar ASCII
clear
echo -e "${GREEN}==========================================================="
echo -e "${YELLOW}            ▀█ ▀▄▀ █▀▀ █▀█ █▄█ █▀█ ▀█▀ █▀█
echo -e "${YELLOW}            █▄ █░█ █▄▄ █▀▄ ░█░ █▀▀ ░█░ █▄█                                         
echo -e "${GREEN}==========================================================="
echo -e "${YELLOW}       ⚡ WELCOME TO THE AUTOMATED BOT LAUNCHER ⚡               "
echo -e "${GREEN}==========================================================="
echo ""

# Daftar bot tanpa input otomatis
BOTS_NO_INPUT=(
    "NGARIT:/home/hg680p/NGARIT:node index.js:"
    "DEPINED:/home/hg680p/Depined-BOT:node main.js:"
    "MYGATE:/home/hg680p/mygateBot:node main.js:"
    "MEOWTOPIA:/home/hg680p/meowBot:node main.js:"
    "TEAFI:/home/hg680p/teaFiBot:node main.js:"
    "DESPEED:/home/hg680p/despeedBot:npm run start:"
    "LAYEREDGE:/home/hg680p/LayerEdge-BOT:node main.js:"
    "OASIS-Ai:/home/hg680p/oasis-bot:node main.js:"
    "LISK:/home/hg680p/liskPortsl:node main.js:"
    "BERATRAX:/home/hg680p/beratraxBot:node main.js:"
    "TAKER:/home/hg680p/takerBot:node main.js:"
    "MESHCHAIN:/home/hg680p/mesh-bot:node main.js:"
    "LITAS:/home/hg680p/litasBot:node main.js:"
    "STREAM-Ai:/home/hg680p/streamAi:node main.js:"
)

# Daftar bot dengan input otomatis
BOTS_WITH_INPUT=(
    "BLESS:/home/hg680p/bless-bot:node main.js:n"
    "TENEO:/home/hg680p/teneo-bot:node index.js:n y"
)

# Fungsi untuk menjalankan bot dalam tmux dengan efek loading
start_bot() {
    local SESSION=$1
    local FOLDER=$2
    local COMMAND=$3
    local INPUTS=$4

    if tmux has-session -t "$SESSION" 2>/dev/null; then
        echo -e "${BLUE}$SESSION sudah berjalan.${RESET}"
    else
        echo -e "${YELLOW}▶ Menjalankan $SESSION...${RESET}"
        tmux new-session -s "$SESSION" -d
        tmux send-keys -t "$SESSION" "cd $FOLDER" C-m
        tmux send-keys -t "$SESSION" "$COMMAND" C-m &
        spinner $!
        
        # Kirim input otomatis jika ada
        if [[ -n "$INPUTS" ]]; then
            sleep 2
            for INPUT in $INPUTS; do
                tmux send-keys -t "$SESSION" "$INPUT" C-m
                sleep 1
            done
            echo -e "${GREEN}✓ Input otomatis dikirim ke $SESSION: $INPUTS${RESET}"
        fi
    fi
}

# Loop untuk menjalankan bot tanpa input otomatis
for BOT in "${BOTS_NO_INPUT[@]}"; do
    IFS=":" read -r SESSION FOLDER COMMAND INPUTS <<< "$BOT"
    start_bot "$SESSION" "$FOLDER" "$COMMAND" "$INPUTS"
done

# Fungsi untuk menjalankan bot dengan aktivasi venv + efek loading
start_bot_with_venv() {
    local SESSION=$1
    local FOLDER=$2
    local COMMAND=$3
    local VENV=$4

    if tmux has-session -t "$SESSION" 2>/dev/null; then
        echo -e "${BLUE}$SESSION sudah berjalan.${RESET}"
    else
        echo -e "${YELLOW}▶ Menjalankan $SESSION dengan virtual environment...${RESET}"
        tmux new-session -s "$SESSION" -d
        tmux send-keys -t "$SESSION" "source $VENV" C-m
        sleep 2
        tmux send-keys -t "$SESSION" "cd $FOLDER" C-m
        tmux send-keys -t "$SESSION" "$COMMAND" C-m &
        spinner $!
        
        # Kirim pilihan 3 setelah bot berjalan
        sleep 2
        tmux send-keys -t "$SESSION" "3" C-m
        echo -e "${GREEN}✓ Input otomatis '3' dikirim ke $SESSION.${RESET}"
    fi
}

# Menjalankan DAWN dengan virtual environment
start_bot_with_venv "DAWN" "/home/hg680p/Dawn-BOT" "python3 bot.py" "/home/hg680p/venv/bin/activate"

# Menjalankan DEPINED dengan virtual environment
start_bot_with_venv "DEPINED" "/home/hg680p/Depined-BOT" "python3 bot.py" "/home/hg680p/venv/bin/activate"

# Loop untuk menjalankan bot dengan input otomatis
for BOT in "${BOTS_WITH_INPUT[@]}"; do
    IFS=":" read -r SESSION FOLDER COMMAND INPUTS <<< "$BOT"
    start_bot "$SESSION" "$FOLDER" "$COMMAND" "$INPUTS"
done

# Pesan penutupan dengan animasi loading
echo -ne "${YELLOW}⚡ Memastikan semua bot berjalan dengan baik...${RESET}"
sleep 2
echo -ne "\r${GREEN}✅ Semua bot telah berjalan!${RESET}\n"

# Tampilan akhir yang rapi
echo -e "${GREEN}==========================================================="
echo -e "${YELLOW}  [>>>] SEMUA BOT TELAH DIJALANKAN DI TMUX! [<<<]"
echo -e "${GREEN}==========================================================="
