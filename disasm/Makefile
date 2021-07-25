OBJS = build/bank_000.o build/soundEngine.o
BANK_0_FILES = \
	code/BType.s \
	code/gfx.s \
	code/inGameFlow.s \
	code/introScreens.s \
	code/menuScreens.s \
	code/multiplayer.s \
	code/shuttleRocket.s
RAM_OBJS = build/wram.o build/hram.o
INCS = include/constants.s include/hardware.inc include/macros.s include/structs.s

GFX_1BPP_OBJS = $(shell find gfx/1bpp/ -name '*.png' | sed "s/gfx\/1bpp/build/" | sed "s/.png/.1bpp/")
GFX_2BPP_OBJS = $(shell find gfx/2bpp/ -name '*.png' | sed "s/gfx\/2bpp/build/" | sed "s/.png/.2bpp/")
OUTFILES = -n tetris.sym -m tetris.map

all: tetris.gb

build//titleScreen.2bpp: gfx//2bpp//titleScreen.png
	rgbgfx -o $@ $< -x 9

build//menuScreens.2bpp: gfx//2bpp//menuScreens.png
	rgbgfx -o $@ $< -x 11

build/%.2bpp: gfx/2bpp/%.png
	rgbgfx -o $@ $<

build/%.1bpp: gfx/1bpp/%.png
	rgbgfx -d 1 -o $@ $<

build/wram.o: include/wram.s
	rgbasm -h -L -o $@ $<

build/hram.o: include/hram.s
	rgbasm -h -L -o $@ $<

build/bank_000.o: code/bank_000.s $(GFX_1BPP_OBJS) $(GFX_2BPP_OBJS) $(INCS) $(BANK_0_FILES)
	rgbasm -h -L -o $@ $<

build/soundEngine.o: code/soundEngine.s $(INCS)
	rgbasm -h -L -o $@ $<

tetris.gb: $(GFX_1BPP_OBJS) $(GFX_2BPP_OBJS) $(OBJS) $(RAM_OBJS)
	rgblink $(OUTFILES) -w -o $@ $(OBJS) $(RAM_OBJS)
	rgbfix -v -p 255 $@

	md5 $@

clean:
	rm -f tetris.gb tetris.sym tetris.map build/*
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +