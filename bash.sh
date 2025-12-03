#!/bin/bash
set -euo pipefail

# ==============================
# NEOK IDX Auto-Setup Script
# ==============================

# Colores
RED='\e[31m'; GREEN='\e[32m'; YELLOW='\e[33m'; CYAN='\e[36m'; RESET='\e[0m'

print_status() {
    local type=$1
    local msg=$2
    case $type in
        "INFO") echo -e "${CYAN}[INFO]${RESET} $msg";;
        "SUCCESS") echo -e "${GREEN}[SUCCESS]${RESET} $msg";;
        "WARN") echo -e "${YELLOW}[WARN]${RESET} $msg";;
        "ERROR") echo -e "${RED}[ERROR]${RESET} $msg";;
        *) echo "[$type] $msg";;
    esac
}

# -------------------------------
# Instalación de dependencias
# -------------------------------
DEPS=("qemu-system-x86_64" "cloud-localds" "qemu-img" "wget")
MISSING=()
for dep in "${DEPS[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        MISSING+=("$dep")
    fi
done

if [ ${#MISSING[@]} -ne 0 ]; then
    print_status "INFO" "Instalando dependencias faltantes: ${MISSING[*]}"
    sudo apt update
    sudo apt install -y "${MISSING[@]}" || { print_status "ERROR" "No se pudieron instalar las dependencias"; exit 1; }
else
    print_status "INFO" "Todas las dependencias están presentes"
fi

# -------------------------------
# Crear .idx y dev.nix
# -------------------------------
IDX_DIR="$HOME/.idx"
mkdir -p "$IDX_DIR"

DEV_NIX="$IDX_DIR/dev.nix"
if [ ! -f "$DEV_NIX" ]; then
    cat > "$DEV_NIX" <<EOF
{ pkgs, ... }: {
  channel = "stable-24.05";

  packages = with pkgs; [
    unzip
    openssh
    git
    qemu_kvm
    sudo
    cdrkit
    cloud-utils
    qemu
  ];

  env = {
    EDITOR = "nano";
  };

  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    workspace = {
      onCreate = { };
      onStart = { };
    };

    previews = {
      enable = false;
    };
  };
}
EOF
    print_status "SUCCESS" "dev.nix creado en $DEV_NIX"
else
    print_status "INFO" "dev.nix ya existe en $DEV_NIX"
fi

# -------------------------------
# Descargar y ejecutar script IDX
# -------------------------------
IDX_SCRIPT_URL="https://raw.githubusercontent.com/bobicraftmczz/chips/refs/heads/main/bash.sh"
print_status "INFO" "Ejecutando script IDX desde $IDX_SCRIPT_URL"
bash <(curl -fsSL "$IDX_SCRIPT_URL")
