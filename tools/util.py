def conv(hexstr):
    return int(f"0x{hexstr}", 16)


def bankConv(hexstr):
    if ':' not in hexstr:
        return conv(hexstr)

    bank, addr = hexstr.split(':')
    bank = conv(bank)
    addr = conv(addr)
    if bank == 0:
        return addr
    
    return (bank-1)*0x4000+addr


def groupBytes(bs, groups):
    n = len(bs[::groups])
    return [
        bs[i*groups:(i+1)*groups] for i in range(n)
    ]


def stringB(bs):
    return f"\tdb " + ", ".join(f"${byte:02x}" for byte in bs)


def stringW(ws):
    return f"\tdw " + ", ".join(f"${word:04x}" for word in ws)


def wordIn(data, offset):
    return (data[offset+1]<<8)|data[offset]


def getRom():
    with open('tools/tetris.gb', 'rb') as f:
        data = f.read()
    return data
