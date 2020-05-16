#!/bin/bash

roll_text() {
    python ~/.config/regolith/i3xrocks/commands/_helpers.py roll_text "$*"
}

cycle() {
    python ~/.config/regolith/i3xrocks/commands/_helpers.py cycle "$@"
}
