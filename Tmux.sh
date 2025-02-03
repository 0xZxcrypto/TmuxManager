#!/bin/bash

# ======================= WARNA UNTUK ESTETIKA =======================
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

# ======================= HEADER SCRIPT =======================
clear
echo -e "${GREEN}==========================================================="
echo -e "${YELLOW}            ▀█ ▀▄▀ █▀▀ █▀█ █▄█ █▀█ ▀█▀ █▀█            "
echo -e "${YELLOW}            █▄ █░█ █▄▄ █▀▄ ░█░ █▀▀ ░█░ █▄█            "
echo -e "${GREEN}==========================================================="
echo -e "${YELLOW}       ⚡ WELCOME TO THE AUTOMATED BOT LAUNCHER ⚡               "
echo -e "${GREEN}==========================================================="
echo -e ""

# ================== DAFTAR BOT TANPA INPUT OTOMATIS ==================
BOTS_NO_INPUT=(
    "NGARIT:/home/hg680p/NGARIT:node index.js"
    "DEPINED:/home/hg680p/Depined-BOT:node main.js"
    "MYGATE:/home/hg680p/mygateBot:node main.js"
    "MEOWTOPIA:/home/hg680p/meowBot:node main.js"
    "TEAFI:/home/hg680p/teaFiBot:node main.js"
    "DESPEED:/home/hg680p/despeedBot:npm run start"
    "LAYEREDGE:/home/hg680p/LedgeBot:node main.js"
    "OASIS-Ai:/home/hg680p/oasis-bot:node main.js"
    "CAPFIZZ:/home/hg680p/Capfizz-BOT:node main.js"
    "OpenLedger:/home/hg680p/opledBot:node main.js"
    "NAORIS:/home/hg680p/Naoris-BOT:node main.js"
    "LISK:/home/hg680p/liskPortsl:node main.js"
    "BERATRAX:/home/hg680p/beratraxBot:node main.js"
    "TAKER:/home/hg680p/takerBot:node main.js"
    "MESHCHAIN:/home/hg680p/mesh-bot:node main.js"
    "LITAS:/home/hg680p/litasBot:node main.js"
    "STREAM-Ai:/home/hg680p/streamAi:node main.js"
)

# ================== DAFTAR BOT DENGAN VIRTUAL ENVIRONMENT ==================
BOTS_WITH_VENV=(
    "DAWN:/home/hg680p/Dawn-BOT:python3 bot.py:/home/hg680p/venv/bin/activate"
    "MULTIPLE:/home/hg680p/MultipleLite-BOT:python3 bot.py:/home/hg680p/venv/bin/activate"
    "FUNCTOR:/home/hg680p/FunctorNode-BOT:python3 bot.py:/home/hg680p/venv/bin/activate"
    "STREAM-Ai:/home/hg680p/StreamAi-BOT:python3 bot.py:/home/hg680p/venv/bin/activate"
    "AiGaea:/home/hg680p/AiGaea-BOT:python3 bot.py:/home/hg680p/venv/bin/activate"
    "ASSISTER:/home/hg680p/Assisterr-BOT:python3 bot.py:/home/hg680p/venv/bin/activate"
)

# ================== DAFTAR BOT DENGAN INPUT OTOMATIS ==================
BOTS_WITH_INPUT=(
    "BLESS:/home/hg680p/bless-bot:node main.js:n"
    "TENEO:/home/hg680p/teneo-bot:node index.js:n y"
)

# ================== FUNGSI MENJALANKAN BOT ==================
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
        
        # Progress bar
        pid=$!
        echo -ne "${GREEN}Memulai $SESSION: [                    ] 0%${RESET}\r"
        while kill -0 $pid 2>/dev/null; do
            sleep 1
            echo -ne "${GREEN}Memulai $SESSION: [####                ] 40%${RESET}\r"
        done
        echo -ne "${GREEN}Memulai $SESSION: [####################] 100%${RESET}\n"
        
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
        
        # Progress bar
        pid=$!
        echo -ne "${GREEN}Memulai $SESSION: [                    ] 0%${RESET}\r"
        while kill -0 $pid 2>/dev/null; do
            sleep 1
            echo -ne "${GREEN}Memulai $SESSION: [####                ] 40%${RESET}\r"
        done
        echo -ne "${GREEN}Memulai $SESSION: [####################] 100%${RESET}\n"
        
        sleep 2
        tmux send-keys -t "$SESSION" "3" C-m
        echo -e "${GREEN}✓ Input otomatis '3' dikirim ke $SESSION.${RESET}"
    fi
}

# ================== MENJALANKAN SEMUA BOT ==================
echo -e "${GREEN}>>> Menjalankan bot tanpa input otomatis...${RESET}"
for BOT in "${BOTS_NO_INPUT[@]}"; do
    IFS=":" read -r SESSION FOLDER COMMAND <<< "$BOT"
    start_bot "$SESSION" "$FOLDER" "$COMMAND"
done

echo -e "${GREEN}>>> Menjalankan bot dengan virtual environment...${RESET}"
for BOT in "${BOTS_WITH_VENV[@]}"; do
    IFS=":" read -r SESSION FOLDER COMMAND VENV <<< "$BOT"
    start_bot_with_venv "$SESSION" "$FOLDER" "$COMMAND" "$VENV"
done

echo -e "${GREEN}>>> Menjalankan bot dengan input otomatis...${RESET}"
for BOT in "${BOTS_WITH_INPUT[@]}"; do
    IFS=":" read -r SESSION FOLDER COMMAND INPUTS <<< "$BOT"
    start_bot "$SESSION" "$FOLDER" "$COMMAND" "$INPUTS"
done

# ================== PENUTUP ==================
echo -ne "${YELLOW}⚡ Memastikan semua bot berjalan dengan baik...${RESET}"
sleep 2
echo -ne "\r${GREEN}✅ Semua bot telah berjalan!${RESET}\n"
echo -e "${GREEN}==========================================================="
echo -e "${YELLOW}  [>>>] SEMUA BOT TELAH DIJALANKAN DI TMUX! [<<<]"
echo -e "${GREEN}==========================================================="
