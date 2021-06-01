import sys
import re

print_stats = sys.argv[2] == 'p'

fname = sys.argv[1]

with open(f'code/{fname}.s') as f:
    code = f.read()

with open('temp.s', 'w') as f:
    f.write(code)

lines = code.split('\n')

if print_stats:
    start = 1
    end = len(lines)
else:
    start, end = map(int, sys.argv[3:])

relevantLines = lines[start-1:end]

changedLines = 0
unchangedLines = 0

comps = lines[:start-1]
for line in relevantLines:
    x = re.search(r'((.*?) +(; \$[0-9a-f]+)).*', line)
    if x is None:
        comps.append(line)
        continue

    nl = x.group(2)
    addr = x.group(3)
    len_gap = max(1, 60-len(nl))

    newLine = nl + ' '*len_gap + addr
    if line == newLine:
        unchangedLines += 1
    else:
        changedLines += 1
    comps.append(newLine)
comps.extend(lines[end:])

if print_stats:
    print(unchangedLines, changedLines)

else:
    with open(f'code/{fname}.s', 'w') as f:
        f.write('\n'.join(comps))
