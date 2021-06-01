# Common
* Place `tetris.gb` in `original/` directory, and `web/` directory
* Former is used for scripts, and `cmp.sh`, and latter for web visualisations

# Building
* Install rgbds v0.5.1
* Run `make`
* Run `./cmp.sh` to compare built ROM against original ROM

# Web
* Start a web server within the `web/` directory, eg `python3 -m http.server`
* Navigate to the root page to see a list of game screens and sprites

# Project Structure
* `code` - for Tetris, it's the sound engine or anything non-sound engine in `bank_000.s`
* `data` - large blocks of data, layouts are in `.bin` files
* `docs` - reference images, and flow .drawio
* `gfx` - pngs of 1bpp (not yet) and 2bpp data
* `include` - constants, hardware definitions, ram, macros and structs
* `tools` - misc tools to help with disassembly
* `web` - just the html+js in 1 file to visualise
* `includes.s` - imported definitions, excluding those that need building, eg ram
