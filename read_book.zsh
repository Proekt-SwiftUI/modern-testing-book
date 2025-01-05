#!/usr/bin/env zsh

# Nick Rossik
# @wmorgue 2025

log_error() {
    echo "[ERROR] $1" >$2
}

try_open_url() {
    local URL="http://[::1]:3000"
    
    if open $URL; then
        echo "🟢 Opened $URL successfully\n"
    else
        log_error "❌ Failed to open $URL"
        exit 1
    fi
}

serve_mdbook() {
    if command -v mdbook > /dev/null; then
        exec mdbook serve
    else
        log_error "mdbook is not installed or not in PATH"
        exit 2
    fi
}

try_open_url; serve_mdbook
