#!/data/data/com.termux/files/usr/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

clear

echo -e "${PURPLE}=========================================${NC}"
echo -e "${PURPLE}        ${CYAN}DeltaSpoof Installer${NC}        ${PURPLE}${NC}"
echo -e "${PURPLE}=========================================${NC}"
echo ""

echo -e "${BLUE}[1/7]${NC} ${WHITE}Downloading...${NC}"
curl -L --retry 5 --retry-delay 5 --connect-timeout 60 -o deltaspoof-termux-aarch64.tar.gz https://github.com/Delta-Kronecker/DeltaSpoof/releases/download/v0.1.13/deltaspoof-termux-aarch64.tar.gz 2>/dev/null
echo -e "${GREEN}[OK]${NC} Done!"
echo ""

echo -e "${BLUE}[2/7]${NC} ${WHITE}Extracting...${NC}"
tar -xzvf deltaspoof-termux-aarch64.tar.gz 2>/dev/null
echo -e "${GREEN}[OK]${NC} Done!"
echo ""

echo -e "${BLUE}[3/7]${NC} ${WHITE}Moving files...${NC}"
mkdir -p DeltaSpoof
mv deltaspoof config.toml ip_list.txt sni_list.txt DeltaSpoof/ 2>/dev/null
echo -e "${GREEN}[OK]${NC} Done!"
echo ""

echo -e "${BLUE}[4/7]${NC} ${WHITE}Cleaning up...${NC}"
rm deltaspoof-termux-aarch64.tar.gz 2>/dev/null
echo -e "${GREEN}[OK]${NC} Done!"
echo ""

echo -e "${BLUE}[5/7]${NC} ${WHITE}Setting permissions...${NC}"
chmod +x DeltaSpoof/deltaspoof
echo -e "${GREEN}[OK]${NC} Done!"
echo ""

echo -e "${BLUE}[6/7]${NC} ${WHITE}Creating alias 's'...${NC}"
echo 'alias s="~/DeltaSpoof/deltaspoof"' >> ~/.bashrc
echo -e "${GREEN}[OK]${NC} Done!"
echo ""

echo -e "${BLUE}[7/7]${NC} ${WHITE}Deleting setup.sh...${NC}"
rm -- "$0" 2>/dev/null
echo -e "${GREEN}[OK]${NC} Done!"
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}        Installation Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${CYAN}Just type:${NC} ${WHITE}s${NC}"
echo ""

exec bash
