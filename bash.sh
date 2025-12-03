#!/bin/bash
set -euo pipefail

# =========================
# COLORES
# =========================
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
RESET='\e[0m'

# =========================
# LOGO NEOK GAMER
# =========================
animate_logo() {
  clear
  local logo=(
"███╗   ██╗███████╗ ██████╗ ██╗  ██╗"
"████╗  ██║██╔════╝██╔═══██╗██║ ██╔╝"
"██╔██╗ ██║█████╗  ██║   ██║█████╔╝ "
"██║╚██╗██║██╔══╝  ██║   ██║██╔═██╗ "
"██║ ╚████║███████╗╚██████╔╝██║  ██╗"
"╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝"
  )

  for line in "${logo[@]}"; do
    echo -e "${CYAN}${line}${RESET}"
    sleep 0.12
  done
  echo ""
  sleep 0.3
}

animate_logo

# =========================
# LINK RAW DE GITHUB (TUYO)
# =========================
REMOTE_SCRIPT_URL="https://raw.githubusercontent.com/bobicraftmczz/chips/main/script.sh"

# =========================
# EJECUCIÓN PARA GOOGLE IDX
# =========================
echo -e "${YELLOW}Google IDX Environment Detected${RESET}"
echo -e "${BLUE}Downloading NEOK script from GitHub...${RESET}"

curl -fL --retry 3 --connect-timeout 10 \
  "$REMOTE_SCRIPT_URL" -o neok_remote.sh

echo -e "${GREEN}Download completed.${RESET}"
echo -e "${YELLOW}Preview of the first lines:${RESET}"
head -n 15 neok_remote.sh

echo ""
echo -ne "${YELLOW}Do you want to execute this script now? (y/n): ${RESET}"
read confirm

if [[ "$confirm" =~ ^[yY]$ ]]; then
  echo -e "${GREEN}Executing NEOK script on IDX...${RESET}"
  bash neok_remote.sh
else
  echo -e "${RED}Execution cancelled by user.${RESET}"
  exit 0
fi

echo -e "${CYAN}NEOK IDX process finished.${RESET}"
