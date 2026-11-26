# Enyxma Hyprland

> **Language / Dil:** **English** | [Türkçe](./README.tr.md)

A standalone, modular, and NixOS Flake-compatible window manager ecosystem written in pure Lua for Hyprland 0.56+.

---

## Architectural Features

- **Pure Lua Standard:** All configuration runs directly on Hyprland's C++ Lua bindings without legacy config files.
- **Live Enyxma Shell Integration:**
  - Dynamically reads default terminal, file manager, and `kbLayout` from `~/.config/enyxma/settings.json` with `ENYXMA_KB_LAYOUT` and `"us"` fallbacks.
  - Automatically detects `~/.config/enyxma/hypridle.conf` at login for lock and DPMS management synchronized with Enyxma Settings.
  - Applies Enyxma Settings 2.0 changes live via `hyprctl eval` without restarts.
- **Nix Flake & `mkDefault` Modules:** Provides both NixOS (`nixosModules.default`) and Home Manager (`homeManagerModules.default`) modules with `mkDefault` options and live local `sourcePath` mode.
- **Isolated Namespace:** Uses the `enyxma.desktop.hyprland` namespace to prevent collisions with external Flake modules.
- **Automatic Conflict Checking:** A local keybind scanner catches duplicate bindings before commit.
- **Hardware Agnostic:** No hardcoded GPU paths or monitor output names. Adapts to software cursors in VMs and high refresh rates on bare metal.
- **Smart Tiling & Universal App Chain:** Dwindle layout with smart spiral splits and automatic fallback detection for terminals, file managers, and launchers.

---

## Directory Structure

```text
.
├── default.nix            # Standalone Nix package derivation
├── flake.nix              # Nix Flake entry point and module outputs
├── home-module.nix        # Home Manager user-level module
├── Justfile               # Management and verification tasks
├── LICENSE                # GPL-3.0-or-later license text
├── nixos-module.nix       # NixOS system-level desktop module
├── README.md              # Documentation (English)
├── README.tr.md           # Documentation (Turkish)
├── hyprland.lua           # Main entry point and safe module loader
├── lua
│   ├── core
│   │   ├── autostart.lua  # Background services, hypridle, and env vars
│   │   └── hardware.lua   # Hardware, monitors, dynamic kb_layout, and cursor
│   ├── ui
│   │   └── theme.lua      # Colors, bezier curves, animations, and dwindle
│   └── wm
│       ├── binds.lua      # Keybinds, dynamic settings.json reader, and clipboard
│       └── rules.lua      # Window rules and layer rules
└── scripts
    └── check-binds.py     # Automatic keybind conflict checker
```

---

## Keybind Reference

### Applications & System

| Key | Action |
| :--- | :--- |
| SUPER + Return | Launch default terminal |
| SUPER + Q | Close active window |
| SUPER + SHIFT + Q | Force-kill active window |
| SUPER + E | Open default file manager |
| SUPER + Y | Open Yazi file manager in terminal |
| SUPER + R | Open application launcher |
| SUPER + W | Open web browser |
| SUPER + L | Lock screen |
| SUPER + I | Toggle Enyxma Settings 2.0 |
| SUPER + T | Cycle between Gotham and Dynamic themes |
| SUPER + SHIFT + T | Open wallpaper gallery |
| SUPER + S | Toggle local AI sidebar |
| SUPER + SHIFT + V | Open clipboard history menu |
| SUPER + SHIFT + R | Reload Hyprland configuration |
| SUPER + SHIFT + E | Exit session |
| SUPER + N | Toggle Enyxma Notification Center |
| SUPER + D | Toggle Enyxma Control Center |
| SUPER + B | Toggle Enyxma Top Bar |
| SUPER + Space | Open Enyxma Omni Launcher |

### Screenshots

| Key | Action |
| :--- | :--- |
| Print | Capture full screen to clipboard |
| SHIFT + Print | Capture region and open Enyxma Shot editor |
| SUPER + SHIFT + S | Open Enyxma Shot & Mockup studio |
| SUPER + ALT + S | Save full-screen capture directly to file |
| SUPER + Print | Capture region and open Enyxma Shot editor |

### Window Management

| Key | Action |
| :--- | :--- |
| SUPER + F | Toggle fullscreen |
| SUPER + SHIFT + F | Maximize window |
| SUPER + V | Toggle floating |
| SUPER + P | Toggle pseudotiling |
| SUPER + J | Toggle split direction |
| SUPER + G | Gaming Mode — toggle blur and animations off |
| SUPER + SHIFT + G | Toggle tab group |
| SUPER + Tab | Focus next window |
| SUPER + C | Center floating window |

### Directional Focus & Sizing

| Key | Action |
| :--- | :--- |
| SUPER + Arrow Keys | Move focus |
| SUPER + SHIFT + Arrow Keys | Move window |
| SUPER + CTRL + Arrow Keys | Swap windows |
| SUPER + SHIFT + CTRL + Arrow Keys | Resize window |

### Multi-Monitor

| Key | Action |
| :--- | :--- |
| SUPER + Comma | Focus previous monitor |
| SUPER + Period | Focus next monitor |
| SUPER + SHIFT + Comma | Move window to previous monitor |
| SUPER + SHIFT + Period | Move window to next monitor |

### Workspaces

| Key | Action |
| :--- | :--- |
| SUPER + 1..9, 0 | Switch to workspace |
| SUPER + SHIFT + 1..9, 0 | Move window to workspace |
| SUPER + SHIFT + M | Send window to special workspace |
| SUPER + Mouse Wheel | Cycle workspaces |

### Mouse Actions

| Key | Action |
| :--- | :--- |
| SUPER + Left Click | Drag window |
| SUPER + Right Click | Resize window |

---

## Installation & Integration

### 1. Traditional Installation

Clone directly into your home configuration on any Linux distribution:

```bash
git clone https://codeberg.org/enyxma/hyprland ~/.config/hypr
```

### 2. NixOS & Flake Integration

Add as an input to your `flake.nix`:

```nix
inputs = {
  enyxma-hyprland.url = "git+https://codeberg.org/enyxma/hyprland";
};
```

#### As a NixOS System Module

```nix
imports = [
  inputs.enyxma-hyprland.nixosModules.default
];

enyxma.desktop.hyprland.enable = true;
```

#### As a Home Manager Module

```nix
imports = [
  inputs.enyxma-hyprland.homeManagerModules.default
];

enyxma.desktop.hyprland = {
  enable = true;
  # Optional local path for live development:
  # sourcePath = "/home/username/Projects/enyxma/hyprland";
};
```

---

## Management Commands

```bash
just check     # Test Lua syntax, Nix checks, and keybind conflicts
just reload    # Reload local Hyprland session
just sync      # Run checks and push
```

---

## License

GPL-3.0-or-later — See [LICENSE](./LICENSE) for details. Copyright © 2026 Enyxma OS Contributors.
