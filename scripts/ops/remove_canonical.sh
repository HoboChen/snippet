#!/bin/bash
# =============================================================================
# Script: remove_canonical.sh
# Description: Removes Canonical-specific packages and services from Ubuntu
# =============================================================================

# Define colors for better output readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BOLD}${BLUE}=== Removing Canonical Components from Ubuntu ===${NC}\n"

# Install grep-dctrl for package filtering
echo -e "${YELLOW}Installing grep-dctrl utility...${NC}"
sudo apt install grep-dctrl       # tiny helper, 60 kB

# List all packages maintained by Canonical
echo -e "\n${YELLOW}Listing packages maintained by Canonical:${NC}"
grep-dctrl -n -FMaintainer -e 'Canonical' -s Package /var/lib/dpkg/status

# ===== REMOVING SNAP PACKAGES =====
echo -e "\n${BOLD}${GREEN}=== Removing all snap packages ===${NC}"
echo -e "${YELLOW}Current snap packages:${NC}"
snap list                      # note the names

echo -e "${YELLOW}Removing all snap packages...${NC}"
for s in $(snap list | awk 'NR>1 {print $1}'); do 
    echo -e "Removing snap: ${BLUE}$s${NC}"
    sudo snap remove --purge "$s"
done

# ===== DISABLING AND REMOVING SNAPD =====
echo -e "\n${BOLD}${GREEN}=== Disabling and removing snapd ===${NC}"
echo -e "${YELLOW}Stopping and disabling snapd services...${NC}"
sudo systemctl disable --now snapd.{socket,service}

echo -e "${YELLOW}Purging snapd and related packages...${NC}"
sudo apt purge snapd gnome-software-plugin-snap

echo -e "${YELLOW}Removing snap directories...${NC}"
sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd

echo -e "${YELLOW}Preventing snapd reinstallation...${NC}"
echo -e "Package: snapd\nPin: release a=*\nPin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap

# ===== REMOVING UBUNTU ADVANTAGE TOOLS =====
echo -e "\n${BOLD}${GREEN}=== Removing Ubuntu Advantage tools ===${NC}"
echo -e "${YELLOW}Purging Ubuntu Advantage packages...${NC}"
sudo apt purge ubuntu-advantage-tools ubuntu-pro-client

echo -e "${YELLOW}Disabling Ubuntu Advantage services...${NC}"
sudo systemctl disable --now ubuntu-advantage.{service,timer}

echo -e "${YELLOW}Disabling update hook...${NC}"
# Disable the update hook cleanly (survives package upgrades)
sudo dpkg-divert --rename \
  --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.disabled \
  --add    /etc/apt/apt.conf.d/20apt-esm-hook.conf

echo -e "${YELLOW}Removing MOTD ESM announcements...${NC}"
# Remove MOTD snippets that shout about "Enable ESM…"
sudo rm /etc/update-motd.d/91-contract-ua-esm-status \
        /etc/update-motd.d/88-esm-announce 2>/dev/null

# ===== REMOVING DATA COLLECTION TOOLS =====
echo -e "\n${BOLD}${GREEN}=== Removing data collection tools ===${NC}"
sudo apt purge popularity-contest ubuntu-report apport whoopsie

# ===== REMOVING CANONICAL LIVEPATCH =====
echo -e "\n${BOLD}${GREEN}=== Removing Canonical Livepatch ===${NC}"
echo -e "${YELLOW}Disabling Livepatch service...${NC}"
sudo pro disable livepatch    # or: sudo canonical-livepatch disable

echo -e "${YELLOW}Removing Livepatch snap and files...${NC}"
sudo snap remove canonical-livepatch
sudo rm -rf /etc/livepatch

# ===== DISABLING WHOOPSIE =====
echo -e "\n${BOLD}${GREEN}=== Disabling error reporting (whoopsie) ===${NC}"
sudo systemctl disable whoopsie.service
sudo systemctl mask whoopsie.service

# ===== REMOVING OTHER CANONICAL COMPONENTS =====
echo -e "\n${BOLD}${GREEN}=== Removing additional Canonical components ===${NC}"
sudo apt purge apport whoopsie ubuntu-report canonical-census popularity-contest
sudo apt purge apport whoopsie ubuntu-report popularity-contest

echo -e "${YELLOW}Removing Ubuntu Advantage MOTD messages...${NC}"
sudo rm -rf /etc/update-motd.d/*ubuntu-advantage*

# ===== CLEANUP =====
echo -e "\n${BOLD}${GREEN}=== Final cleanup ===${NC}"
echo -e "${YELLOW}Removing unused packages...${NC}"
sudo apt autoremove --purge
sudo apt clean

# ===== ADDING MOZILLA PPA =====
echo -e "\n${BOLD}${GREEN}=== Adding Mozilla PPA for Firefox/Thunderbird ===${NC}"
sudo add-apt-repository ppa:mozillateam/ppa

echo -e "${YELLOW}Setting Mozilla package priorities...${NC}"
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: thunderbird
Pin: version 2:1snap*
Pin-Priority: -1

Package: firefox
Pin: version 2:1snap*
Pin-Priority: -1
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt update
