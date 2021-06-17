#!/usr/bin/env python3

import sys

import clipboard

from util import stringB, conv

with open('original/tetris.gb', 'rb') as f:
    data = f.read()

start = conv(sys.argv[1])
channel = 'sq'
if len(sys.argv) > 2:
    channel = sys.argv[2]

notes = [
    'Cnote', 'Csharp', 'Dnote', 'Dsharp', 'Enote', 'Fnote', 'Fsharp', 
    'Gnote', 'Gsharp', 'Anote', 'Asharp', 'Bnote']

comps = []
offset = start
while data[offset] != 0:
    byte = data[offset]
    # todo: set params is now dw,db not db,db,db
    if byte == 0x9d:
        bytes = data[offset+1:offset+4]

        if channel == 'sq':
            comps.append(f"\tSetParams ${bytes[0]:02x}, ${bytes[2]:02x}")
        else:
            assert channel == 'w'
            word = (bytes[1]<<8)|bytes[0]
            comps.append(f"\tSetParams ${word:04x}, ${bytes[2]:02x}")
        offset += 4
        continue
    if byte & 0xf0 == 0xa0:
        comps.append(f"\tUseTempo {byte & 0x0f}")
        offset += 1
        continue
    if channel == 'n':
        if byte not in (1, 6, 11, 16):
            break
        comps.append(f"\tPlayNoise {(byte-1)//5}")
        offset += 1
        continue
    if byte == 1:
        comps.append(f"\tDisableEnvelope")
        offset += 1
        continue
    byte //= 2
    byte -= 1
    note = byte % 12
    octave = (byte // 12) + 2

    comps.append(f"\tPlayNote {notes[note]}, {octave}")
    offset += 1

comps.append(f"\tNextSection")
print(hex(offset))
final_str = '\n'.join(comps)
print(final_str)
clipboard.copy(final_str)