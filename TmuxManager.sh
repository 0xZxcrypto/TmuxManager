#!/bin/bash

# Kode warna ANSI
CYAN='\033[1;36m'   # Cyan tebal
YELLOW='\033[1;33m' # Kuning tebal
WHITE='\033[1;37m'  # Putih tebal
BOLD='\033[1m'      # Teks tebal
BLUE='\033[1;34m'   # Biru tebal
NC='\033[0m'        # No Color

# Fungsi untuk menampilkan header dengan gaya yang konsisten
show_header() {
  echo -e "${CYAN}========================================"
  echo -e "         TMUX MANAGER By 0xRizal        "
  echo -e "========================================${NC}"
}

# Fungsi untuk menampilkan menu utama dengan efek pemilihan
menu() {
  local options=("Lihat daftar sesi" "Buat sesi baru" "Hapus sesi" "Keluar")
  local selected=0

  while true; do
    clear
    show_header
    echo -e "${YELLOW}USE ↑/↓ TO SELECT...${NC}"

    # Menampilkan opsi menu dengan nomor, huruf besar, dan tebal
    for i in "${!options[@]}"; do
      option_upper=$(echo "${options[i]}" | tr 'a-z' 'A-Z') # Mengubah ke huruf besar
      if [[ $i -eq $selected ]]; then
        echo -e "${BOLD}${YELLOW} > $((i+1)). ${option_upper} ${NC}" # Menambahkan nomor dan efek pilihan
      else
        echo -e "${WHITE}   $((i+1)). ${option_upper} ${NC}" # Warna default untuk opsi lainnya
      fi
    done

    # Membaca input dari keyboard untuk navigasi
    read -rsn1 input
    case $input in
      $'\x1B') # Tombol escape untuk panah
        read -rsn2 -t 0.1 input
        case $input in
          '[A') # Panah atas
            ((selected--))
            if [[ $selected -lt 0 ]]; then selected=$((${#options[@]} - 1)); fi
            ;;
          '[B') # Panah bawah
            ((selected++))
            if [[ $selected -ge ${#options[@]} ]]; then selected=0; fi
            ;;
        esac
        ;;
      '') # Input Enter
        case $selected in
          0) list_sessions ;;  # Menampilkan sesi dan memungkinkan untuk masuk
          1) create_session ;;
          2) delete_session ;;  # Memilih sesi untuk dihapus
          3) exit 0 ;;  # Keluar dari aplikasi
        esac
        ;;
    esac
  done
}

# Fungsi daftar sesi tmux dengan nomor dan navigasi untuk masuk
list_sessions() {
  clear
  show_header
  echo -e "${YELLOW}========================================"
  echo -e "        DAFTAR SESI TMUX AKTIF          "
  echo -e "========================================${NC}"

  sessions=$(tmux list-sessions 2>/dev/null)
  if [[ -z "$sessions" ]]; then
    echo -e "${CYAN}Tidak ada sesi aktif.${NC}"
    read -n 1 -s -r -p "[ Enter untuk kembali ]=>"
    return
  fi

  printf "${WHITE}%-5s %-15s %-15s${NC}\n" "No" "Sesi" "Jumlah Windows"
  echo -e "${CYAN}----------------------------------------${NC}"

  session_names=()  # Array untuk menyimpan nama sesi
  index=1
  while IFS= read -r session; do
    session_name=$(echo "$session" | cut -d ':' -f 1)
    session_windows=$(echo "$session" | grep -oP '\d+(?= windows)')
    printf "${WHITE}%-5s %-15s ${CYAN}%-15s${NC}\n" "$index" "$session_name" "$session_windows windows"
    session_names+=("$session_name")  # Menambahkan nama sesi ke array
    ((index++))
  done <<< "$sessions"

  echo -e "${CYAN}----------------------------------------${NC}"

  # Prompt untuk memilih sesi
  echo -n -e "${CYAN}PILIH NOMOR SESI [ Enter untuk kembali ]=> ${NC}"
  read -r session_index

  # Jika nomor valid, masuk ke sesi
  if [[ -n "$session_index" && "$session_index" -gt 0 && "$session_index" -le "${#session_names[@]}" ]]; then
    tmux attach-session -t "${session_names[$((session_index - 1))]}"
  else
    echo -e "${CYAN}Nomor sesi tidak valid.${NC}"
    read -n 1 -s -r -p "[ Enter untuk kembali ]=>"
  fi
}

# Fungsi menghapus sesi
delete_session() {
  clear
  show_header
  echo -e "${YELLOW}========================================"
  echo -e "        PILIH SESI UNTUK DIHAPUS        "
  echo -e "========================================${NC}"

  sessions=$(tmux list-sessions 2>/dev/null)
  if [[ -z "$sessions" ]]; then
    echo -e "${CYAN}Tidak ada sesi aktif untuk dihapus.${NC}"
    read -n 1 -s -r -p "[ Enter untuk kembali ]=>"
    return
  fi

  printf "${WHITE}%-5s %-15s %-15s${NC}\n" "No" "Sesi" "Jumlah Windows"
  echo -e "${CYAN}----------------------------------------${NC}"

  session_names=()  # Array untuk menyimpan nama sesi
  index=1
  while IFS= read -r session; do
    session_name=$(echo "$session" | cut -d ':' -f 1)
    session_windows=$(echo "$session" | grep -oP '\d+(?= windows)')
    printf "${WHITE}%-5s %-15s ${CYAN}%-15s${NC}\n" "$index" "$session_name" "$session_windows windows"
    session_names+=("$session_name")  # Menambahkan nama sesi ke array
    ((index++))
  done <<< "$sessions"

  echo -e "${CYAN}----------------------------------------${NC}"

  # Prompt untuk memilih sesi yang akan dihapus
  echo -n -e "${CYAN}PILIH NOMOR SESI UNTUK DIHAPUS [ Enter untuk kembali ]=> ${NC}"
  read -r session_index

  # Jika nomor valid, hapus sesi dan langsung kembali ke menu utama tanpa menunggu input
  if [[ -n "$session_index" && "$session_index" -gt 0 && "$session_index" -le "${#session_names[@]}" ]]; then
    tmux kill-session -t "${session_names[$((session_index - 1))]}"
    # Tidak menampilkan pesan, langsung kembali ke menu utama
    menu
  else
    menu  # Jika nomor sesi tidak valid, langsung kembali ke menu utama
  fi
}

# Fungsi membuat sesi baru
create_session() {
  echo -n -e "${CYAN}Masukkan nama sesi baru: ${NC}"
  read -r session_name
  tmux new-session -d -s "$session_name" && echo -e "${CYAN}Sesi $session_name berhasil dibuat.${NC}"
  menu
}

# Mulai menu utama
menu
