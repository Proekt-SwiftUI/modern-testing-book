#!/usr/bin/env zsh

# Nick Rossik
# @wmorgue 2025

# Сделать исполняемым для вашего пользователя: chmod u+x swift_fmt.zsh
# На intel машинах путь будет другим.
# FMT_PATH="/opt/homebrew/bin/swiftformat"

FMT_PATH=`which swiftformat`

if which $FMT_PATH > /dev/null; then
    $FMT_PATH ModernApp --config .swiftformat.conf
else
    echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
    echo "note: brew install swiftformat"
fi
