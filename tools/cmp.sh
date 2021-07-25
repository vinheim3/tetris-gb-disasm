#!/bin/sh

cmp -l tools/tetris.gb disasm/tetris.gb | gawk '{printf "%08X %02X %02X\n", $1, strtonum(0$2), strtonum(0$3)}'