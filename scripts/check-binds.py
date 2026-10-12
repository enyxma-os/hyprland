#!/usr/bin/env python3
import re
import sys
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_DIR = os.path.dirname(SCRIPT_DIR)
BINDS_FILE = os.path.join(REPO_DIR, "lua", "wm", "binds.lua")

def check_duplicate_binds():
    with open(BINDS_FILE, "r", encoding="utf-8") as f:
        lines = f.readlines()

    binds = {}
    errors = []

    for i, line in enumerate(lines, 1):
        m = re.search(r"hl\.bind\(\s*([^,]+),", line)
        if m:
            key_expr = m.group(1).strip()
            norm_key = re.sub(r"\s+", "", key_expr)
            if norm_key in binds:
                prev_line = binds[norm_key]
                errors.append(f"Kısayol çakışması tespit edildi: {key_expr} Satır {prev_line} ve {i}")
            else:
                binds[norm_key] = i

    if errors:
        for err in errors:
            print(f"HATA: {err}")
        return False

    print(f"BAŞARILI: {len(binds)} adet benzersiz kısayol tarandı, sıfır çakışma.")
    return True

if __name__ == "__main__":
    if not check_duplicate_binds():
        sys.exit(1)
    sys.exit(0)
