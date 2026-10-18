#!/usr/bin/env bash
# =====================================================
# Enyxma Safe Codium / VSCode Launcher
# Removes stale database lock files preventing launch crashes or corrupted state
# =====================================================

if ! pgrep -x codium >/dev/null 2>&1 && ! pgrep -x code >/dev/null 2>&1; then
    rm -f "$HOME/.config/VSCodium/Service Worker/Database/LOCK" 2>/dev/null
    rm -f "$HOME/.config/VSCodium/code.lock" 2>/dev/null
    rm -f "$HOME/.config/VSCodium/Local Storage/leveldb/LOCK" 2>/dev/null
    rm -f "$HOME/.config/VSCodium/Session Storage/LOCK" 2>/dev/null
    rm -f "$HOME/.config/Code/Service Worker/Database/LOCK" 2>/dev/null
    rm -f "$HOME/.config/Code/code.lock" 2>/dev/null
    rm -f "$HOME/.config/Code/Local Storage/leveldb/LOCK" 2>/dev/null
    rm -f "$HOME/.config/Code/Session Storage/LOCK" 2>/dev/null
fi

if command -v codium >/dev/null 2>&1; then
    exec codium "$@"
elif command -v code >/dev/null 2>&1; then
    exec code "$@"
else
    echo "Hata: VSCodium veya VS Code sistemde bulunamadı." >&2
    exit 1
fi
