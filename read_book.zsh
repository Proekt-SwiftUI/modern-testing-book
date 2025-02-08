#!/usr/bin/env zsh

# Nick Rossik
# @wmorgue 2025

try_open_url() {
    local URL="http://[::1]:3000"
    
    if open $URL; then
        echo "🟢 Opened $URL successfully\n"
    else
        echo "❌ Failed to open $URL"
        exit 1
    fi
}

serve_mdbook() {
    if command -v mdbook > /dev/null; then
        exec mdbook serve
    else
        echo "❌ mdbook is not installed or not in PATH"
        exit 2
    fi
}

try_open_url; serve_mdbook
