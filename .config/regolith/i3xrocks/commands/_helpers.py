#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import sys

CHAR_LIMIT = 20


def roll_text(text, charLimit=CHAR_LIMIT):
    print(_roll_text(text, charLimit)),


def _roll_text(text, charLimit=CHAR_LIMIT):
    text = (text + '   -   ') * 3
    idx = int(time.time() * 2) % charLimit
    return text[idx:idx+charLimit]


def cycle(*text):
    selected = text[int((time.time() / 10) % len(text))]
    if len(selected) > CHAR_LIMIT:
        selected = _roll_text(selected)
    print(selected)


def main():
    action = sys.argv[1]
    args = sys.argv[2:]
    globals()[action](*args)


if __name__ == "__main__":
    main()
