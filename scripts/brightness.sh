#!/usr/bin/env bash
# =====================================================
# enyxma dinamik parlaklık yöneticisi (Brightness Control)
# Hem dahili ekranları (laptop / VM / brightnessctl)
# hem de harici monitörleri (DDC/CI / ddcutil) destekler.
# Debounce mekanizması sayesinde donanımı zorlamaz.
# =====================================================

ARG1="$1"
ARG2="$2"

# 1. Öncelik: Dahili Ekran veya Laptop / VM (brightnessctl)
if command -v brightnessctl >/dev/null 2>&1 && [ -n "$(brightnessctl -m 2>/dev/null)" ]; then
    if [ "$ARG1" = "set" ]; then
        brightnessctl set "${ARG2}%" >/dev/null 2>&1
    elif [[ "$ARG1" =~ ^[+-] ]]; then
        if [[ "$ARG1" =~ \+ ]]; then
            brightnessctl set 5%+ >/dev/null 2>&1
        else
            brightnessctl set 5%- >/dev/null 2>&1
        fi
    elif [ -n "$ARG1" ]; then
        brightnessctl set "${ARG1}%" >/dev/null 2>&1
    fi
    exit 0
fi

# 2. Öncelik: Harici Monitör (DDC/CI - ddcutil)
if command -v ddcutil >/dev/null 2>&1; then
    PIDFILE="/tmp/enyxma_brightness_adjust.pid"
    if [ -f "$PIDFILE" ]; then
        kill "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null
    fi
    echo $$ > "$PIDFILE"
    sleep 0.08

    if [ "$ARG1" = "set" ]; then
        ddcutil setvcp 10 "$ARG2" 2>/dev/null
    elif [ -n "$ARG1" ]; then
        ddcutil setvcp 10 $ARG1 2>/dev/null
    fi
    rm -f "$PIDFILE"
    exit 0
fi
