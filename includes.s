INCLUDE "include/hardware.inc"
INCLUDE "include/constants.s"
INCLUDE "include/macros.s"
INCLUDE "include/structs.s"

newcharmap new
charmap "0", 0
charmap "1", 1
charmap "2", 2
charmap "3", 3
charmap "4", 4
charmap "5", 5
charmap "6", 6
charmap "7", 7
charmap "8", 8
charmap "9", 9
charmap "A", $0a
charmap "B", $0b
charmap "C", $0c
charmap "D", $0d
charmap "E", $0e
charmap "F", $0f
charmap "G", $10
charmap "H", $11
charmap "I", $12
charmap "J", $13
charmap "K", $14
charmap "L", $15
charmap "M", $16
charmap "N", $17
charmap "O", $18
charmap "P", $19
charmap "Q", $1a
charmap "R", $1b
charmap "S", $1c
charmap "T", $1d
charmap "U", $1e
charmap "V", $1f
charmap "W", $20
charmap "X", $21
charmap "Y", $22
charmap "Z", $23
charmap "-", $25
charmap "*", $26
charmap "<3", $27
charmap ".", $29
charmap " ", $2f

; pipe box
charmap "'//", $61
charmap "=", $62
charmap "\\'", $63
charmap "'||", $64
charmap "||'", $65
charmap ",\\", $66
charmap "~", $69
charmap ",//", $6a
charmap "_", $ad

charmap "<...>", $60
charmap "<end>", $ff

newcharmap congrats
charmap "P", $0d
charmap "S", $0e
charmap "H", $1c
charmap "T", $1d
charmap "W", $2d
charmap "I", $2e
charmap " ", $2f
charmap "!", $3e
charmap "N", $3d
charmap "V", $41
charmap "D", $b0
charmap "E", $b1
charmap "U", $b2
charmap "C", $b3
charmap "M", $b4
charmap "A", $b5
charmap "_", $b6
charmap "R", $bb
charmap "O", $bc
charmap "L", $bd
charmap "G", $be