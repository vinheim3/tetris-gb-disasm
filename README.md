# Common
* Place `tetris.gb` in the `tools/` directory, and `web/` directory
* Former is used for scripts, and `tools/cmp.sh`, and the latter for web visualisations

# Building
* Install RGBDS v0.6.1
* Run `make` within the `disasm` directory
* Run `tools/cmp.sh` to compare built ROM against original ROM

# Web
* Start a web server within the `web/` directory, eg `python3 -m http.server`
* Navigate to the root page to see a list of game screens and sprites

# Project Structure
* `disasm`
  * `code` - dissected and commented asm that runs the game
  * `data` - large blocks of data, layouts are in `.bin` files
  * `gfx` - pngs of 1bpp and 2bpp data
  * `include` - constants, hardware definitions, ram, macros and structs
  * `includes.s` - imported definitions, excluding those that need building, eg ram
* `tools` - misc tools to help with disassembly
* `web` - the html+js in 1 file to visualise
  * `docs` - reference images, and flow .drawio

# Note on improvements
The project serves to describe everything that makes the game function as it does. Some things are not completely clear from the outset. If you need a full guide on a particular concept, eg sound engine, or some part of the disassembly needs further clarification, please feel free to raise an issue
