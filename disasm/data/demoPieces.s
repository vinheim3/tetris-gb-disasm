SECTION "Demo Steps", ROMX[$62b0], BANK[$1]

; pair of bytes, input, then frames until next
Demo2Inputs:
	db $00, $2a, $20, $01, $00, $1d, $01, $09
	db $00, $07, $01, $0b, $00, $03, $20, $04
	db $00, $20, $20, $06, $00, $0a, $80, $17
	db $00, $06, $01, $06, $00, $04, $01, $05
	db $00, $1e, $80, $0b, $00, $06, $80, $1c
	db $00, $0a, $10, $08, $11, $04, $01, $02
	db $00, $04, $01, $06, $00, $00, $10, $06
	db $00, $04, $10, $05, $00, $1a, $80, $24
	db $00, $15, $01, $07, $00, $20, $10, $04
	db $00, $05, $10, $03, $00, $0d, $10, $06
	db $00, $03, $10, $05, $00, $25, $80, $15
	db $00, $1b, $10, $04, $00, $13, $80, $03
	db $00, $1c, $80, $19, $00, $1a, $01, $06
	db $00, $0a, $20, $01, $00, $09, $20, $02
	db $00, $14, $10, $03, $00, $0e, $80, $16
	db $00, $0a, $10, $0a, $11, $06, $10, $16
	db $00, $13, $80, $25, $00, $1c, $01, $06
	db $00, $03, $20, $02, $00, $0e, $20, $03
	db $00, $04, $20, $02, $00, $03, $20, $05
	db $00, $0d, $80, $21, $00, $13, $01, $07
	db $00, $05, $01, $06, $00, $04, $01, $05
	db $00, $06, $20, $03, $00, $05, $20, $02
	db $00, $1c, $20, $03, $00, $0e, $80, $12
	db $00, $0c, $10, $04, $00, $02, $01, $08
	db $00, $10, $01, $08, $00, $1e, $80, $19
	db $00, $10, $10, $03, $00, $04, $10, $05
	db $00, $24, $80, $1c, $00, $05, $01, $05
	db $00, $11, $20, $03, $00, $12, $80, $20
	db $00, $0a, $10, $01, $11, $06, $01, $00
	db $00, $04, $10, $04, $00, $04, $10, $03
	db $00, $02, $10, $19, $00, $04, $10, $07
	db $00, $0a, $00, $00, $00, $00, $00, $00


Demo1Inputs:
	db $00, $4d, $20, $08, $21, $06, $20, $0b
	db $00, $07, $20, $06, $00, $64, $10, $00
	db $11, $06, $10, $05, $00, $2f, $80, $16
	db $00, $17, $20, $05, $00, $06, $20, $06
	db $00, $10, $80, $18, $00, $34, $01, $05
	db $00, $01, $10, $0e, $11, $06, $10, $20
	db $00, $0a, $80, $0a, $00, $2b, $20, $06
	db $00, $06, $20, $05, $00, $05, $20, $06
	db $00, $0a, $80, $0c, $00, $0a, $01, $07
	db $00, $02, $10, $0b, $00, $05, $10, $04
	db $00, $0d, $80, $1c, $00, $75, $01, $06
	db $00, $0e, $80, $1f, $00, $1a, $01, $06
	db $00, $00, $10, $07, $00, $05, $10, $06
	db $00, $04, $10, $08, $00, $03, $10, $08
	db $00, $0c, $80, $0f, $00, $0a, $01, $07
	db $00, $00, $10, $3d, $00, $05, $80, $1f
	


SECTION "Demo Pieces", ROMX[$6450], BANK[$1]

DemoPieces::
; demo 2
	db $10
	db SPRITE_SPEC_POINTY_PIECE,    SPRITE_SPEC_L_PIECE
	db SPRITE_SPEC_REVERSE_L_PIECE, SPRITE_SPEC_STRAIGHT_PIECE
	db SPRITE_SPEC_L_PIECE,         SPRITE_SPEC_REVERSE_L_PIECE
	db SPRITE_SPEC_STRAIGHT_PIECE,  SPRITE_SPEC_STRAIGHT_PIECE
	db SPRITE_SPEC_L_PIECE,         SPRITE_SPEC_REVERSE_L_PIECE
	db SPRITE_SPEC_REVERSE_Z_PIECE, SPRITE_SPEC_Z_PIECE
	db SPRITE_SPEC_STRAIGHT_PIECE,  SPRITE_SPEC_Z_PIECE
	db SPRITE_SPEC_Z_PIECE,         SPRITE_SPEC_REVERSE_Z_PIECE
	
; demo 1
	db $18
	db SPRITE_SPEC_REVERSE_Z_PIECE, SPRITE_SPEC_L_PIECE
	db SPRITE_SPEC_SQUARE_PIECE,    SPRITE_SPEC_REVERSE_L_PIECE
	db SPRITE_SPEC_POINTY_PIECE,    SPRITE_SPEC_L_PIECE
	db SPRITE_SPEC_REVERSE_Z_PIECE, SPRITE_SPEC_REVERSE_Z_PIECE
	db SPRITE_SPEC_STRAIGHT_PIECE,  SPRITE_SPEC_REVERSE_L_PIECE
	db SPRITE_SPEC_REVERSE_L_PIECE, SPRITE_SPEC_SQUARE_PIECE
	db SPRITE_SPEC_L_PIECE,         SPRITE_SPEC_POINTY_PIECE
	db SPRITE_SPEC_REVERSE_L_PIECE, SPRITE_SPEC_L_PIECE
	db SPRITE_SPEC_STRAIGHT_PIECE,  SPRITE_SPEC_SQUARE_PIECE
	db SPRITE_SPEC_SQUARE_PIECE,    SPRITE_SPEC_POINTY_PIECE
	db SPRITE_SPEC_L_PIECE,         SPRITE_SPEC_SQUARE_PIECE
	db SPRITE_SPEC_STRAIGHT_PIECE,  SPRITE_SPEC_L_PIECE
	db SPRITE_SPEC_POINTY_PIECE,    SPRITE_SPEC_Z_PIECE
	db SPRITE_SPEC_REVERSE_Z_PIECE, SPRITE_SPEC_REVERSE_Z_PIECE
	db SPRITE_SPEC_POINTY_PIECE,    SPRITE_SPEC_STRAIGHT_PIECE
