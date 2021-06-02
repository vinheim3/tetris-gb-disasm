OBJS = $(shell find code/ -name '*.s' | sed "s/code/build/" | sed "s/\.s/\.o/")

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

build/%.o: code/%.s $(GFX_1BPP_OBJS) $(GFX_2BPP_OBJS) include/constants.s
	rgbasm -h -L -o $@ $<

tetris.gb: $(GFX_1BPP_OBJS) $(GFX_2BPP_OBJS) $(OBJS) build/wram.o build/hram.o
	rgblink $(OUTFILES) -w -o $@ $(OBJS) build/wram.o build/hram.o
	rgbfix -v -p 255 $@

	md5 $@

clean:
	rm -f tetris.o tetris.gb tetris.sym tetris.map
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +