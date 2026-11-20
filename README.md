# ⚡ Singleshot.sh - Recon Auditor

A lightning-fast, single-shot HTTP security header and server recon tool written in Bash by **sudo-faiz**.

## 🚀 Features
- **Fast Execution:** Fetches IP, HTTP Status, and Server Banner in one request.
- **OWASP Header Audit:** Checks HSTS, CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, and Permissions-Policy.
- **Cross-Platform:** Works on Linux (Ubuntu/Kali/WSL) and Android (Termux).

## 🛠️ How to Install & Use

Open your terminal and run the following commands:

```bash
# 1. Download the tool
git clone https://github.com/sudo-faiz/singleshot.git
cd singleshot

# 2. Give execution permission
chmod +x singleshot.sh

# 3. Run the scan (Example)
./singleshot.sh google.com OR
bash singleshot.sh google.com
