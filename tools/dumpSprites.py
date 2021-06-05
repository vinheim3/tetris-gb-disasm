from util import getRom, wordIn, stringB
import clipboard

mapping = {}
for i in range(10):
    mapping[i] = str(i)
for i in range(26):
    mapping[i+10] = chr(ord('A')+i)
mapping[0x25] = '-'
mapping[0x2f] = ' '

def ascii(_bs):
    return "".join([mapping[i] for i in _bs])

data = getRom()

spriteSpecAddresses = []
comps = []

start = 0x2b64
idx = 0
while start + idx * 2 < 0x2c20:
    address = wordIn(data, start + idx*2)
    spriteSpecAddresses.append(address)
    comps.append(f"\tdw SpriteSpec_{idx:02x}")
    idx += 1

comps.append('')

addressType = {}
addressLabels = {}
addressSpecIdx = {}
for i, spriteSpecAddress in enumerate(spriteSpecAddresses):
    addressType[spriteSpecAddress] = 'spec'
    addressLabels.setdefault(spriteSpecAddress, []).append(f"SpriteSpec_{i:02x}:")
    addressSpecIdx[spriteSpecAddress] = i

    spriteTileAddress = wordIn(data, spriteSpecAddress)
    addressType[spriteTileAddress] = 'tiles'
    addressLabels.setdefault(spriteTileAddress, []).append(f"SpriteTiles_{i:02x}:")
    addressSpecIdx[spriteTileAddress] = i

    spriteCoordAddress = wordIn(data, spriteTileAddress)
    addressType[spriteCoordAddress] = 'coords'
    addressLabels.setdefault(spriteCoordAddress, []).append(f"SpriteCoords_{i:02x}:")
    addressSpecIdx[spriteCoordAddress] = i

addresses = sorted(addressType.keys())
for i, address in enumerate(addresses):
    if i == len(addresses)-1:
        bs = data[address:0x323f]
    else:
        bs = data[address:addresses[i+1]]
    comps.extend([label for label in sorted(addressLabels[address])])
    dtype = addressType[address]
    if dtype == 'spec':
        assert len(bs) == 4, f"{idx:02x} is spec, but not 4 bytes"
        comps.append(f"\tdw SpriteTiles_{addressSpecIdx[address]:02x}")
        comps.append(stringB(bs[2:4]))
    elif dtype == 'tiles':
        assert bs[-1] == 0xff
        comps.append(f"\tdw SpriteCoords_{addressSpecIdx[address]:02x}")
        if 0x1c <= addressSpecIdx[address] <= 0x29:
            comps.append(f"\tdb \"{ascii(bs[2:-1])}\", $ff")
        else:
            comps.append(stringB(bs[2:]))
    elif dtype == 'coords':
        comps.append(stringB(bs))
    else:
        raise Exception(dtype)
    comps.append('')


final_str = '\n'.join(comps)
clipboard.copy(final_str)
