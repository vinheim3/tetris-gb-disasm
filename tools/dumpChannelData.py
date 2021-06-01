import sys

import clipboard

from util import stringB, conv

with open('original/tetris.gb', 'rb') as f:
    data = f.read()

start = conv(sys.argv[1])

notes = [
    'Cnote', 'Csharp', 'Dnote', 'Dsharp', 'Enote', 'Fnote', 'Fsharp', 
    'Gnote', 'Gsharp', 'Anote', 'Asharp', 'Bnote']

comps = []
offset = start
while data[offset] != 0:
    byte = data[offset]
    # todo: set params is now dw,db not db,db,db
    if byte == 0x9d:
        bytes = [f"${b:02x}" for b in data[offset+1:offset+4]]
        comps.append(f"\tSetParams {', '.join(bytes)}")
        offset += 4
        continue
    if byte & 0xf0 == 0xa0:
        comps.append(f"\tUseTempo {byte & 0x0f:01x}")
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