#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Compact Banner (Fits Mobile & Desktop)
echo -e "${CYAN}========================================${RESET}"
echo -e "${WHITE}   ⚡ SINGLESHOT.SH - RECON AUDITOR ⚡   ${RESET}"
echo -e "${YELLOW}  Fast HTTP Security & Server Scanner   ${RESET}"
echo -e "${YELLOW}  Checks Headers, IP & Response Speed   ${RESET}"
echo -e "${CYAN}========================================${RESET}"

if [ -z "$1" ]; then
    echo -e "\n${RED}[!] Usage:${RESET} ./singleshot.sh <website.com>\n"
    exit 1
fi

TARGET="$1"
if [[ ! "$TARGET" =~ ^https?:// ]]; then
    TARGET="https://$TARGET"
fi

echo -e "\n${WHITE}[*] Target:${RESET} $TARGET"
echo -e "${WHITE}[*] Scanning in single-shot mode...${RESET}\n"

RAW_DATA=$(curl -ILs --connect-timeout 3 -m 5 -A "Mozilla/5.0 (Singleshot-Scanner)" \
    -w "\n__META__|%{remote_ip}|%{http_code}|%{time_total}" "$TARGET")

if [ $? -ne 0 ]; then
    echo -e "${RED}[✘] Connection Failed: Server down.${RESET}"
    echo -e "${CYAN}========================================${RESET}"
    echo -e "${WHITE}       singleshot by sudo-faiz          ${RESET}"
    echo -e "${CYAN}========================================${RESET}"
    exit 1
fi

META_LINE=$(echo "$RAW_DATA" | grep "^__META__")
HEADERS=$(echo "$RAW_DATA" | grep -v "^__META__")

REMOTE_IP=$(echo "$META_LINE" | cut -d'|' -f2)
HTTP_CODE=$(echo "$META_LINE" | cut -d'|' -f3)
TIME_TOTAL=$(echo "$META_LINE" | cut -d'|' -f4)
SERVER_NAME=$(echo "$HEADERS" | grep -i "^server:" | tail -n 1 | cut -d':' -f2- | tr -d '\r')

echo -e "${CYAN}--- [ SERVER DETAILS ] ---${RESET}"
echo -e "${WHITE}IP Address  :${RESET} ${GREEN}${REMOTE_IP}${RESET}"
echo -e "${WHITE}HTTP Status :${RESET} ${GREEN}${HTTP_CODE}${RESET}"
echo -e "${WHITE}Server      :${RESET} ${YELLOW}${SERVER_NAME:-Hidden (Secure)}${RESET}"
echo -e "\n${CYAN}--- [ SECURITY HEADERS AUDIT ] ---${RESET}"

check_header() {
    local h_name="$1"
    local h_desc="$2"
    if echo "$HEADERS" | grep -iq "^${h_name}:"; then
        echo -e "${GREEN}[✔] ${h_name}${RESET} (${h_desc})"
    else
        echo -e "${RED}[✘] ${h_name}${RESET} -> MISSING"
    fi
}

check_header "strict-transport-security" "HSTS"
check_header "content-security-policy"   "CSP/XSS"
check_header "x-frame-options"           "Clickjack"
check_header "x-content-type-options"    "MIME-Sniff"
check_header "referrer-policy"           "Privacy"
check_header "permissions-policy"        "Permissions"

if echo "$HEADERS" | grep -iq "^set-cookie:"; then
    if echo "$HEADERS" | grep -i "^set-cookie:" | grep -iq "httponly"; then
        echo -e "${GREEN}[✔] Set-Cookie (HttpOnly)${RESET} (Secure)"
    else
        echo -e "${YELLOW}[!] Set-Cookie${RESET} -> HttpOnly Missing"
    fi
fi

echo -e "\n${CYAN}========================================${RESET}"
echo -e "${WHITE}⚡ ${GREEN}${TIME_TOTAL}s${WHITE} | ${CYAN}singleshot by sudo-faiz${RESET}"
echo -e "${CYAN}========================================${RESET}\n"
