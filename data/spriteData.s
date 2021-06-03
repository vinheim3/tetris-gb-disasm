; last data table word - points to a table of y/x offsets per sprite
; last data table byte == $fd - x flip
; last data table byte == $fe - initial pointer in last data table += 2
; last data table byte == $ff - next sprite spec
; last data table byte == others - specifies the tile index


SpriteData:
	dw $2c20
	dw $2c24
	dw $2c28
	dw $2c2c
	dw $2c30
	dw $2c34
	dw $2c38
	dw $2c3c
	dw $2c40
	dw $2c44
	dw $2c48
	dw $2c4c
	dw $2c50
	dw $2c54
	dw $2c58
	dw $2c5c
	dw $2c60
	dw $2c64
	dw $2c68
	dw $2c6c
	dw $2c70
	dw $2c74
	dw $2c78
	dw $2c7c
	dw $2c80
	dw $2c84
	dw $2c88
	dw $2c8c
	dw Data_2c90
	dw $2c94
	dw $2c98
	dw $2c9c
	dw $2ca0
	dw $2ca4
	dw $2ca8
	dw $2cac
	dw $2cb0
	dw $2cb4
	dw $2cb8
	dw $2cbc
	dw $2cc0
	dw $2cc4
	dw $2cc8
	dw $2ccc
	dw $30c7
	dw $2ccc
	dw $2cd0
	dw $2cd4
	dw $2cd8
	dw $2cdc
	dw $2ce0
	dw $2ce4
	dw $30ea
	dw $30ee
	dw $2ce8
	dw $2cec
	dw $30f2
	dw $30f6
	dw $2cf0
	dw $2cf4
	dw $2cf8
	dw $2cfc
	dw $2d00
	dw $2d04
	dw $30fa
	dw $30fe
	dw $2d04
	dw $2d08
	dw $2d08
	dw $2d0c
	dw $2d10
	dw $2d14
	dw $2d18
	dw $2d1c
	dw $2d20
	dw $2d24
	dw $2d28
	dw $2d2c
	dw $2d30
	dw $2d34
	dw $2d38
	dw $2d3c
	dw $2d40
	dw $2d44
	dw $2d48
	dw $2d4c
	dw $2d50
	dw $2d54
	dw $310a
	dw $310e
	dw $3112
	dw $3112
	dw $3102
	dw $3106



	ld   e, b                                        ; $2c20: $58
	dec  l                                           ; $2c21: $2d
	RST_JumpTable                                         ; $2c22: $ef

jr_000_2c23:
	ldh  a, [rBCPS]                                  ; $2c23: $f0 $68
	dec  l                                           ; $2c25: $2d
	RST_JumpTable                                         ; $2c26: $ef

jr_000_2c27:
	ldh  a, [$7a]                                    ; $2c27: $f0 $7a
	dec  l                                           ; $2c29: $2d
	RST_JumpTable                                         ; $2c2a: $ef

jr_000_2c2b:
	ldh  a, [hCurrSpriteTileIndex]                                    ; $2c2b: $f0 $89
	dec  l                                           ; $2c2d: $2d
	RST_JumpTable                                         ; $2c2e: $ef

jr_000_2c2f:
	ldh  a, [hNumFramesUntilPiecesMoveDown]                                    ; $2c2f: $f0 $9a
	dec  l                                           ; $2c31: $2d
	RST_JumpTable                                         ; $2c32: $ef

jr_000_2c33:
	ldh  a, [$ac]                                    ; $2c33: $f0 $ac
	dec  l                                           ; $2c35: $2d
	RST_JumpTable                                         ; $2c36: $ef
	ldh  a, [$bd]                                    ; $2c37: $f0 $bd
	dec  l                                           ; $2c39: $2d
	RST_JumpTable                                         ; $2c3a: $ef
	ldh  a, [hMultiplayerPlayerRole]                                    ; $2c3b: $f0 $cb
	dec  l                                           ; $2c3d: $2d
	RST_JumpTable                                         ; $2c3e: $ef
	ldh  a, [h2toThePowerOf_LinesClearedMinus1]                                    ; $2c3f: $f0 $dc
	dec  l                                           ; $2c41: $2d
	RST_JumpTable                                         ; $2c42: $ef
	ldh  a, [hAddressOfDemoInput]                                    ; $2c43: $f0 $eb
	dec  l                                           ; $2c45: $2d
	RST_JumpTable                                         ; $2c46: $ef
	ldh  a, [h1stHighScoreHighestByteForLevel+1]                                    ; $2c47: $f0 $fc
	dec  l                                           ; $2c49: $2d
	RST_JumpTable                                         ; $2c4a: $ef
	ldh  a, [$0b]                                    ; $2c4b: $f0 $0b
	ld   l, $ef                                      ; $2c4d: $2e $ef
	ldh  a, [rAUD3LEVEL]                                  ; $2c4f: $f0 $1c
	ld   l, $ef                                      ; $2c51: $2e $ef
	ldh  a, [$2e]                                    ; $2c53: $f0 $2e
	ld   l, $ef                                      ; $2c55: $2e $ef
	ldh  a, [rLCDC]                                  ; $2c57: $f0 $40
	ld   l, $ef                                      ; $2c59: $2e $ef
	ldh  a, [rHDMA2]                                 ; $2c5b: $f0 $52
	ld   l, $ef                                      ; $2c5d: $2e $ef
	ldh  a, [$64]                                    ; $2c5f: $f0 $64
	ld   l, $ef                                      ; $2c61: $2e $ef
	ldh  a, [rPCM12]                                 ; $2c63: $f0 $76
	ld   l, $ef                                      ; $2c65: $2e $ef
	ldh  a, [$86]                                    ; $2c67: $f0 $86
	ld   l, $ef                                      ; $2c69: $2e $ef
	ldh  a, [hPieceFallingState]                                    ; $2c6b: $f0 $98
	ld   l, $ef                                      ; $2c6d: $2e $ef
	ldh  a, [$a8]                                    ; $2c6f: $f0 $a8
	ld   l, $ef                                      ; $2c71: $2e $ef
	ldh  a, [$b9]                                    ; $2c73: $f0 $b9
	ld   l, $ef                                      ; $2c75: $2e $ef
	ldh  a, [hTypedTextCharLoc+1]                                    ; $2c77: $f0 $ca
	ld   l, $ef                                      ; $2c79: $2e $ef
	ldh  a, [hIsDeuce]                                    ; $2c7b: $f0 $db
	ld   l, $ef                                      ; $2c7d: $2e $ef
	ldh  a, [$0b]                                    ; $2c7f: $f0 $0b
	cpl                                              ; $2c81: $2f
	RST_JumpTable                                         ; $2c82: $ef
	ldh  a, [rAUD3LEVEL]                                  ; $2c83: $f0 $1c
	cpl                                              ; $2c85: $2f
	RST_JumpTable                                         ; $2c86: $ef
	ldh  a, [hAddressOfDemoInput+1]                                    ; $2c87: $f0 $ec
	ld   l, $ef                                      ; $2c89: $2e $ef
	ldh  a, [$fa]                                    ; $2c8b: $f0 $fa
	ld   l, $ef                                      ; $2c8d: $2e $ef
	db $f0 
	
	
Data_2c90:
	dw Data_2f2d
	db $00, $e8
	


	db $36                                     ; $2c94: $36
	cpl                                              ; $2c95: $2f
	nop                                              ; $2c96: $00
	add  sp, $3f                                     ; $2c97: $e8 $3f
	cpl                                              ; $2c99: $2f
	nop                                              ; $2c9a: $00
	add  sp, $48                                     ; $2c9b: $e8 $48
	cpl                                              ; $2c9d: $2f
	nop                                              ; $2c9e: $00
	add  sp, $51                                     ; $2c9f: $e8 $51
	cpl                                              ; $2ca1: $2f
	nop                                              ; $2ca2: $00
	nop                                              ; $2ca3: $00
	ld   d, l                                        ; $2ca4: $55
	cpl                                              ; $2ca5: $2f
	nop                                              ; $2ca6: $00
	nop                                              ; $2ca7: $00
	ld   e, c                                        ; $2ca8: $59
	cpl                                              ; $2ca9: $2f
	nop                                              ; $2caa: $00
	nop                                              ; $2cab: $00
	ld   e, l                                        ; $2cac: $5d
	cpl                                              ; $2cad: $2f
	nop                                              ; $2cae: $00
	nop                                              ; $2caf: $00
	ld   h, c                                        ; $2cb0: $61
	cpl                                              ; $2cb1: $2f
	nop                                              ; $2cb2: $00
	nop                                              ; $2cb3: $00
	ld   h, l                                        ; $2cb4: $65
	cpl                                              ; $2cb5: $2f
	nop                                              ; $2cb6: $00
	nop                                              ; $2cb7: $00
	ld   l, c                                        ; $2cb8: $69
	cpl                                              ; $2cb9: $2f
	nop                                              ; $2cba: $00
	nop                                              ; $2cbb: $00
	ld   l, l                                        ; $2cbc: $6d
	cpl                                              ; $2cbd: $2f
	nop                                              ; $2cbe: $00
	nop                                              ; $2cbf: $00
	ld   [hl], c                                     ; $2cc0: $71
	cpl                                              ; $2cc1: $2f
	nop                                              ; $2cc2: $00
	nop                                              ; $2cc3: $00
	ld   [hl], l                                     ; $2cc4: $75
	cpl                                              ; $2cc5: $2f
	nop                                              ; $2cc6: $00
	nop                                              ; $2cc7: $00
	ld   a, c                                        ; $2cc8: $79
	cpl                                              ; $2cc9: $2f
	ldh  a, [$f8]                                    ; $2cca: $f0 $f8
	add  h                                           ; $2ccc: $84
	cpl                                              ; $2ccd: $2f
	ldh  a, [$f8]                                    ; $2cce: $f0 $f8
	adc  a                                           ; $2cd0: $8f
	cpl                                              ; $2cd1: $2f
	ldh  a, [$f0]                                    ; $2cd2: $f0 $f0
	and  e                                           ; $2cd4: $a3
	cpl                                              ; $2cd5: $2f
	ldh  a, [$f0]                                    ; $2cd6: $f0 $f0
	cp   b                                           ; $2cd8: $b8
	cpl                                              ; $2cd9: $2f
	ld   hl, sp-$08                                  ; $2cda: $f8 $f8
	pop  bc                                          ; $2cdc: $c1
	cpl                                              ; $2cdd: $2f
	ld   hl, sp-$08                                  ; $2cde: $f8 $f8
	jp   z, $f82f                                    ; $2ce0: $ca $2f $f8

	ld   hl, sp-$2f                                  ; $2ce3: $f8 $d1
	cpl                                              ; $2ce5: $2f
	ld   hl, sp-$08                                  ; $2ce6: $f8 $f8
	ret  c                                           ; $2ce8: $d8

	cpl                                              ; $2ce9: $2f
	ldh  a, [$f8]                                    ; $2cea: $f0 $f8
	db   $e3                                         ; $2cec: $e3
	cpl                                              ; $2ced: $2f
	ldh  a, [$f8]                                    ; $2cee: $f0 $f8
	xor  $2f                                         ; $2cf0: $ee $2f
	ldh  a, [$f0]                                    ; $2cf2: $f0 $f0
	inc  bc                                          ; $2cf4: $03
	jr   nc, @-$0e                                   ; $2cf5: $30 $f0

jr_000_2cf7:
	ldh  a, [rAUD2HIGH]                                  ; $2cf7: $f0 $19
	jr   nc, @-$06                                   ; $2cf9: $30 $f8

jr_000_2cfb:
	ld   hl, sp+$22                                  ; $2cfb: $f8 $22
	jr   nc, jr_000_2cf7                             ; $2cfd: $30 $f8

jr_000_2cff:
	ld   hl, sp+$2b                                  ; $2cff: $f8 $2b
	jr   nc, jr_000_2cfb                             ; $2d01: $30 $f8

jr_000_2d03:
	ld   hl, sp+$32                                  ; $2d03: $f8 $32
	jr   nc, jr_000_2cff                             ; $2d05: $30 $f8

jr_000_2d07:
	ld   hl, sp+$39                                  ; $2d07: $f8 $39
	jr   nc, jr_000_2d03                             ; $2d09: $30 $f8

jr_000_2d0b:
	ld   hl, sp+$40                                  ; $2d0b: $f8 $40
	jr   nc, jr_000_2d07                             ; $2d0d: $30 $f8

jr_000_2d0f:
	ld   hl, sp+$47                                  ; $2d0f: $f8 $47
	jr   nc, jr_000_2d0b                             ; $2d11: $30 $f8

jr_000_2d13:
	ld   hl, sp+$4e                                  ; $2d13: $f8 $4e
	jr   nc, jr_000_2d0f                             ; $2d15: $30 $f8

jr_000_2d17:
	ld   hl, sp+$55                                  ; $2d17: $f8 $55
	jr   nc, jr_000_2d13                             ; $2d19: $30 $f8

jr_000_2d1b:
	ld   hl, sp+$5c                                  ; $2d1b: $f8 $5c
	jr   nc, jr_000_2d17                             ; $2d1d: $30 $f8

jr_000_2d1f:
	ld   hl, sp+$67                                  ; $2d1f: $f8 $67
	jr   nc, jr_000_2d1b                             ; $2d21: $30 $f8

jr_000_2d23:
	ld   hl, sp+$6e                                  ; $2d23: $f8 $6e
	jr   nc, jr_000_2d1f                             ; $2d25: $30 $f8

jr_000_2d27:
	ld   hl, sp+$75                                  ; $2d27: $f8 $75
	jr   nc, jr_000_2d23                             ; $2d29: $30 $f8

jr_000_2d2b:
	ld   hl, sp+$7c                                  ; $2d2b: $f8 $7c
	jr   nc, jr_000_2d27                             ; $2d2d: $30 $f8

jr_000_2d2f:
	ld   hl, sp-$7d                                  ; $2d2f: $f8 $83
	jr   nc, jr_000_2d2b                             ; $2d31: $30 $f8

jr_000_2d33:
	ld   hl, sp-$74                                  ; $2d33: $f8 $8c
	jr   nc, jr_000_2d2f                             ; $2d35: $30 $f8

jr_000_2d37:
	ld   hl, sp-$6b                                  ; $2d37: $f8 $95
	jr   nc, jr_000_2d33                             ; $2d39: $30 $f8

jr_000_2d3b:
	ld   hl, sp-$62                                  ; $2d3b: $f8 $9e
	jr   nc, jr_000_2d37                             ; $2d3d: $30 $f8

jr_000_2d3f:
	ld   hl, sp-$59                                  ; $2d3f: $f8 $a7
	jr   nc, jr_000_2d3b                             ; $2d41: $30 $f8

jr_000_2d43:
	ld   hl, sp-$50                                  ; $2d43: $f8 $b0
	jr   nc, jr_000_2d3f                             ; $2d45: $30 $f8

jr_000_2d47:
	ld   hl, sp-$47                                  ; $2d47: $f8 $b9
	jr   nc, jr_000_2d43                             ; $2d49: $30 $f8

	ld   hl, sp-$40                                  ; $2d4b: $f8 $c0
	jr   nc, jr_000_2d47                             ; $2d4d: $30 $f8

	ld   hl, sp+$46                                  ; $2d4f: $f8 $46
	ld   sp, $f0f0                                   ; $2d51: $31 $f0 $f0
	ld   e, l                                        ; $2d54: $5d
	ld   sp, $f8f8                                   ; $2d55: $31 $f8 $f8
	xor  c                                           ; $2d58: $a9
	ld   sp, $fefe                                   ; $2d59: $31 $fe $fe
	cp   $fe                                         ; $2d5c: $fe $fe
	cp   $fe                                         ; $2d5e: $fe $fe
	cp   $fe                                         ; $2d60: $fe $fe
	add  h                                           ; $2d62: $84
	add  h                                           ; $2d63: $84
	add  h                                           ; $2d64: $84
	cp   $84                                         ; $2d65: $fe $84
	rst  $38                                         ; $2d67: $ff
	xor  c                                           ; $2d68: $a9
	ld   sp, $fefe                                   ; $2d69: $31 $fe $fe
	cp   $fe                                         ; $2d6c: $fe $fe
	cp   $84                                         ; $2d6e: $fe $84
	cp   $fe                                         ; $2d70: $fe $fe
	cp   $84                                         ; $2d72: $fe $84
	cp   $fe                                         ; $2d74: $fe $fe
	cp   $84                                         ; $2d76: $fe $84
	add  h                                           ; $2d78: $84
	rst  $38                                         ; $2d79: $ff
	xor  c                                           ; $2d7a: $a9
	ld   sp, $fefe                                   ; $2d7b: $31 $fe $fe
	cp   $fe                                         ; $2d7e: $fe $fe
	cp   $fe                                         ; $2d80: $fe $fe
	add  h                                           ; $2d82: $84
	cp   $84                                         ; $2d83: $fe $84
	add  h                                           ; $2d85: $84
	add  h                                           ; $2d86: $84
	cp   $ff                                         ; $2d87: $fe $ff
	xor  c                                           ; $2d89: $a9
	ld   sp, $fefe                                   ; $2d8a: $31 $fe $fe
	cp   $fe                                         ; $2d8d: $fe $fe
	add  h                                           ; $2d8f: $84
	add  h                                           ; $2d90: $84
	cp   $fe                                         ; $2d91: $fe $fe
	cp   $84                                         ; $2d93: $fe $84
	cp   $fe                                         ; $2d95: $fe $fe
	cp   $84                                         ; $2d97: $fe $84
	rst  $38                                         ; $2d99: $ff
	xor  c                                           ; $2d9a: $a9
	ld   sp, $fefe                                   ; $2d9b: $31 $fe $fe
	cp   $fe                                         ; $2d9e: $fe $fe
	cp   $fe                                         ; $2da0: $fe $fe
	cp   $fe                                         ; $2da2: $fe $fe
	add  c                                           ; $2da4: $81
	add  c                                           ; $2da5: $81
	add  c                                           ; $2da6: $81
	cp   $fe                                         ; $2da7: $fe $fe
	cp   $81                                         ; $2da9: $fe $81
	rst  $38                                         ; $2dab: $ff
	xor  c                                           ; $2dac: $a9
	ld   sp, $fefe                                   ; $2dad: $31 $fe $fe
	cp   $fe                                         ; $2db0: $fe $fe
	cp   $81                                         ; $2db2: $fe $81
	add  c                                           ; $2db4: $81
	cp   $fe                                         ; $2db5: $fe $fe
	add  c                                           ; $2db7: $81
	cp   $fe                                         ; $2db8: $fe $fe
	cp   $81                                         ; $2dba: $fe $81
	rst  $38                                         ; $2dbc: $ff
	xor  c                                           ; $2dbd: $a9
	ld   sp, $fefe                                   ; $2dbe: $31 $fe $fe
	cp   $fe                                         ; $2dc1: $fe $fe
	add  c                                           ; $2dc3: $81
	cp   $fe                                         ; $2dc4: $fe $fe
	cp   $81                                         ; $2dc6: $fe $81
	add  c                                           ; $2dc8: $81
	add  c                                           ; $2dc9: $81
	rst  $38                                         ; $2dca: $ff
	xor  c                                           ; $2dcb: $a9
	ld   sp, $fefe                                   ; $2dcc: $31 $fe $fe
	cp   $fe                                         ; $2dcf: $fe $fe
	cp   $81                                         ; $2dd1: $fe $81
	cp   $fe                                         ; $2dd3: $fe $fe
	cp   $81                                         ; $2dd5: $fe $81
	cp   $fe                                         ; $2dd7: $fe $fe
	add  c                                           ; $2dd9: $81
	add  c                                           ; $2dda: $81
	rst  $38                                         ; $2ddb: $ff
	xor  c                                           ; $2ddc: $a9
	ld   sp, $fefe                                   ; $2ddd: $31 $fe $fe
	cp   $fe                                         ; $2de0: $fe $fe
	cp   $fe                                         ; $2de2: $fe $fe
	cp   $fe                                         ; $2de4: $fe $fe
	adc  d                                           ; $2de6: $8a
	adc  e                                           ; $2de7: $8b
	adc  e                                           ; $2de8: $8b
	adc  a                                           ; $2de9: $8f
	rst  $38                                         ; $2dea: $ff
	xor  c                                           ; $2deb: $a9
	ld   sp, $80fe                                   ; $2dec: $31 $fe $80
	cp   $fe                                         ; $2def: $fe $fe
	cp   $88                                         ; $2df1: $fe $88
	cp   $fe                                         ; $2df3: $fe $fe
	cp   $88                                         ; $2df5: $fe $88
	cp   $fe                                         ; $2df7: $fe $fe
	cp   $89                                         ; $2df9: $fe $89
	rst  $38                                         ; $2dfb: $ff
	xor  c                                           ; $2dfc: $a9
	ld   sp, $fefe                                   ; $2dfd: $31 $fe $fe
	cp   $fe                                         ; $2e00: $fe $fe
	cp   $fe                                         ; $2e02: $fe $fe
	cp   $fe                                         ; $2e04: $fe $fe
	adc  d                                           ; $2e06: $8a
	adc  e                                           ; $2e07: $8b
	adc  e                                           ; $2e08: $8b
	adc  a                                           ; $2e09: $8f
	rst  $38                                         ; $2e0a: $ff
	xor  c                                           ; $2e0b: $a9
	ld   sp, $80fe                                   ; $2e0c: $31 $fe $80
	cp   $fe                                         ; $2e0f: $fe $fe
	cp   $88                                         ; $2e11: $fe $88
	cp   $fe                                         ; $2e13: $fe $fe
	cp   $88                                         ; $2e15: $fe $88
	cp   $fe                                         ; $2e17: $fe $fe
	cp   $89                                         ; $2e19: $fe $89
	rst  $38                                         ; $2e1b: $ff
	xor  c                                           ; $2e1c: $a9
	ld   sp, $fefe                                   ; $2e1d: $31 $fe $fe
	cp   $fe                                         ; $2e20: $fe $fe
	cp   $fe                                         ; $2e22: $fe $fe
	cp   $fe                                         ; $2e24: $fe $fe
	cp   $83                                         ; $2e26: $fe $83
	add  e                                           ; $2e28: $83
	cp   $fe                                         ; $2e29: $fe $fe
	add  e                                           ; $2e2b: $83
	add  e                                           ; $2e2c: $83
	rst  $38                                         ; $2e2d: $ff
	xor  c                                           ; $2e2e: $a9
	ld   sp, $fefe                                   ; $2e2f: $31 $fe $fe
	cp   $fe                                         ; $2e32: $fe $fe
	cp   $fe                                         ; $2e34: $fe $fe
	cp   $fe                                         ; $2e36: $fe $fe
	cp   $83                                         ; $2e38: $fe $83
	add  e                                           ; $2e3a: $83
	cp   $fe                                         ; $2e3b: $fe $fe
	add  e                                           ; $2e3d: $83
	add  e                                           ; $2e3e: $83
	rst  $38                                         ; $2e3f: $ff
	xor  c                                           ; $2e40: $a9
	ld   sp, $fefe                                   ; $2e41: $31 $fe $fe
	cp   $fe                                         ; $2e44: $fe $fe
	cp   $fe                                         ; $2e46: $fe $fe
	cp   $fe                                         ; $2e48: $fe $fe
	cp   $83                                         ; $2e4a: $fe $83
	add  e                                           ; $2e4c: $83
	cp   $fe                                         ; $2e4d: $fe $fe
	add  e                                           ; $2e4f: $83
	add  e                                           ; $2e50: $83
	rst  $38                                         ; $2e51: $ff
	xor  c                                           ; $2e52: $a9
	ld   sp, $fefe                                   ; $2e53: $31 $fe $fe
	cp   $fe                                         ; $2e56: $fe $fe
	cp   $fe                                         ; $2e58: $fe $fe
	cp   $fe                                         ; $2e5a: $fe $fe
	cp   $83                                         ; $2e5c: $fe $83
	add  e                                           ; $2e5e: $83
	cp   $fe                                         ; $2e5f: $fe $fe
	add  e                                           ; $2e61: $83
	add  e                                           ; $2e62: $83
	rst  $38                                         ; $2e63: $ff
	xor  c                                           ; $2e64: $a9
	ld   sp, $fefe                                   ; $2e65: $31 $fe $fe
	cp   $fe                                         ; $2e68: $fe $fe
	cp   $fe                                         ; $2e6a: $fe $fe
	cp   $fe                                         ; $2e6c: $fe $fe
	add  d                                           ; $2e6e: $82
	add  d                                           ; $2e6f: $82
	cp   $fe                                         ; $2e70: $fe $fe
	cp   $82                                         ; $2e72: $fe $82
	add  d                                           ; $2e74: $82
	rst  $38                                         ; $2e75: $ff
	xor  c                                           ; $2e76: $a9
	ld   sp, $fefe                                   ; $2e77: $31 $fe $fe
	cp   $fe                                         ; $2e7a: $fe $fe
	cp   $82                                         ; $2e7c: $fe $82
	cp   $fe                                         ; $2e7e: $fe $fe
	add  d                                           ; $2e80: $82
	add  d                                           ; $2e81: $82
	cp   $fe                                         ; $2e82: $fe $fe
	add  d                                           ; $2e84: $82
	rst  $38                                         ; $2e85: $ff
	xor  c                                           ; $2e86: $a9
	ld   sp, $fefe                                   ; $2e87: $31 $fe $fe
	cp   $fe                                         ; $2e8a: $fe $fe
	cp   $fe                                         ; $2e8c: $fe $fe
	cp   $fe                                         ; $2e8e: $fe $fe
	add  d                                           ; $2e90: $82
	add  d                                           ; $2e91: $82
	cp   $fe                                         ; $2e92: $fe $fe
	cp   $82                                         ; $2e94: $fe $82
	add  d                                           ; $2e96: $82
	rst  $38                                         ; $2e97: $ff
	xor  c                                           ; $2e98: $a9
	ld   sp, $fefe                                   ; $2e99: $31 $fe $fe
	cp   $fe                                         ; $2e9c: $fe $fe
	cp   $82                                         ; $2e9e: $fe $82
	cp   $fe                                         ; $2ea0: $fe $fe
	add  d                                           ; $2ea2: $82
	add  d                                           ; $2ea3: $82
	cp   $fe                                         ; $2ea4: $fe $fe
	add  d                                           ; $2ea6: $82
	rst  $38                                         ; $2ea7: $ff
	xor  c                                           ; $2ea8: $a9
	ld   sp, $fefe                                   ; $2ea9: $31 $fe $fe
	cp   $fe                                         ; $2eac: $fe $fe
	cp   $fe                                         ; $2eae: $fe $fe
	cp   $fe                                         ; $2eb0: $fe $fe
	cp   $86                                         ; $2eb2: $fe $86
	add  [hl]                                        ; $2eb4: $86
	cp   $86                                         ; $2eb5: $fe $86
	add  [hl]                                        ; $2eb7: $86
	rst  $38                                         ; $2eb8: $ff
	xor  c                                           ; $2eb9: $a9
	ld   sp, $fefe                                   ; $2eba: $31 $fe $fe
	cp   $fe                                         ; $2ebd: $fe $fe
	add  [hl]                                        ; $2ebf: $86
	cp   $fe                                         ; $2ec0: $fe $fe
	cp   $86                                         ; $2ec2: $fe $86
	add  [hl]                                        ; $2ec4: $86
	cp   $fe                                         ; $2ec5: $fe $fe
	cp   $86                                         ; $2ec7: $fe $86
	rst  $38                                         ; $2ec9: $ff
	xor  c                                           ; $2eca: $a9
	ld   sp, $fefe                                   ; $2ecb: $31 $fe $fe
	cp   $fe                                         ; $2ece: $fe $fe
	cp   $fe                                         ; $2ed0: $fe $fe
	cp   $fe                                         ; $2ed2: $fe $fe
	cp   $86                                         ; $2ed4: $fe $86
	add  [hl]                                        ; $2ed6: $86
	cp   $86                                         ; $2ed7: $fe $86
	add  [hl]                                        ; $2ed9: $86
	rst  $38                                         ; $2eda: $ff
	xor  c                                           ; $2edb: $a9
	ld   sp, $fefe                                   ; $2edc: $31 $fe $fe
	cp   $fe                                         ; $2edf: $fe $fe
	add  [hl]                                        ; $2ee1: $86
	cp   $fe                                         ; $2ee2: $fe $fe
	cp   $86                                         ; $2ee4: $fe $86
	add  [hl]                                        ; $2ee6: $86
	cp   $fe                                         ; $2ee7: $fe $fe
	cp   $86                                         ; $2ee9: $fe $86
	rst  $38                                         ; $2eeb: $ff
	xor  c                                           ; $2eec: $a9
	ld   sp, $fefe                                   ; $2eed: $31 $fe $fe
	cp   $fe                                         ; $2ef0: $fe $fe
	cp   $85                                         ; $2ef2: $fe $85
	cp   $fe                                         ; $2ef4: $fe $fe
	add  l                                           ; $2ef6: $85
	add  l                                           ; $2ef7: $85
	add  l                                           ; $2ef8: $85
	rst  $38                                         ; $2ef9: $ff
	xor  c                                           ; $2efa: $a9
	ld   sp, $fefe                                   ; $2efb: $31 $fe $fe
	cp   $fe                                         ; $2efe: $fe $fe
	cp   $85                                         ; $2f00: $fe $85
	cp   $fe                                         ; $2f02: $fe $fe
	add  l                                           ; $2f04: $85
	add  l                                           ; $2f05: $85
	cp   $fe                                         ; $2f06: $fe $fe
	cp   $85                                         ; $2f08: $fe $85
	rst  $38                                         ; $2f0a: $ff
	xor  c                                           ; $2f0b: $a9
	ld   sp, $fefe                                   ; $2f0c: $31 $fe $fe
	cp   $fe                                         ; $2f0f: $fe $fe
	cp   $fe                                         ; $2f11: $fe $fe
	cp   $fe                                         ; $2f13: $fe $fe
	add  l                                           ; $2f15: $85
	add  l                                           ; $2f16: $85
	add  l                                           ; $2f17: $85
	cp   $fe                                         ; $2f18: $fe $fe
	add  l                                           ; $2f1a: $85
	rst  $38                                         ; $2f1b: $ff
	xor  c                                           ; $2f1c: $a9
	ld   sp, $fefe                                   ; $2f1d: $31 $fe $fe
	cp   $fe                                         ; $2f20: $fe $fe
	cp   $85                                         ; $2f22: $fe $85
	cp   $fe                                         ; $2f24: $fe $fe
	cp   $85                                         ; $2f26: $fe $85
	add  l                                           ; $2f28: $85
	cp   $fe                                         ; $2f29: $fe $fe
	add  l                                           ; $2f2b: $85
	rst  $38                                         ; $2f2c: $ff
	

Data_2f2d:
	dw Data_31c9
	db "A-TYPE<end>"


	ret                                              ; $2f36: $c9


	ld   sp, $250b                                   ; $2f37: $31 $0b $25
	dec  e                                           ; $2f3a: $1d
	ld   [hl+], a                                    ; $2f3b: $22
	add  hl, de                                      ; $2f3c: $19
	ld   c, $ff                                      ; $2f3d: $0e $ff
	ret                                              ; $2f3f: $c9


	ld   sp, $250c                                   ; $2f40: $31 $0c $25
	dec  e                                           ; $2f43: $1d
	ld   [hl+], a                                    ; $2f44: $22
	add  hl, de                                      ; $2f45: $19
	ld   c, $ff                                      ; $2f46: $0e $ff
	ret                                              ; $2f48: $c9


	ld   sp, $182f                                   ; $2f49: $31 $2f $18
	rrca                                             ; $2f4c: $0f
	rrca                                             ; $2f4d: $0f
	cpl                                              ; $2f4e: $2f
	cpl                                              ; $2f4f: $2f
	rst  $38                                         ; $2f50: $ff
	ret                                              ; $2f51: $c9


	ld   sp, $ff00                                   ; $2f52: $31 $00 $ff
	ret                                              ; $2f55: $c9


	ld   sp, $ff01                                   ; $2f56: $31 $01 $ff
	ret                                              ; $2f59: $c9


	ld   sp, rSC                                   ; $2f5a: $31 $02 $ff
	ret                                              ; $2f5d: $c9


	ld   sp, $ff03                                   ; $2f5e: $31 $03 $ff
	ret                                              ; $2f61: $c9


	ld   sp, $ff04                                   ; $2f62: $31 $04 $ff
	ret                                              ; $2f65: $c9


	ld   sp, $ff05                                   ; $2f66: $31 $05 $ff
	ret                                              ; $2f69: $c9


	ld   sp, $ff06                                   ; $2f6a: $31 $06 $ff
	ret                                              ; $2f6d: $c9


	ld   sp, $ff07                                   ; $2f6e: $31 $07 $ff
	ret                                              ; $2f71: $c9


	ld   sp, $ff08                                   ; $2f72: $31 $08 $ff
	ret                                              ; $2f75: $c9


	ld   sp, $ff09                                   ; $2f76: $31 $09 $ff
	reti                                             ; $2f79: $d9


	ld   sp, $012f                                   ; $2f7a: $31 $2f $01
	cpl                                              ; $2f7d: $2f
	ld   de, $2120                                   ; $2f7e: $11 $20 $21
	jr   nc, jr_000_2fb4                             ; $2f81: $30 $31

	rst  $38                                         ; $2f83: $ff
	reti                                             ; $2f84: $d9


	ld   sp, $032f                                   ; $2f85: $31 $2f $03
	ld   [de], a                                     ; $2f88: $12
	inc  de                                          ; $2f89: $13
	ld   [hl+], a                                    ; $2f8a: $22
	inc  hl                                          ; $2f8b: $23
	ld   [hl-], a                                    ; $2f8c: $32
	inc  sp                                          ; $2f8d: $33
	rst  $38                                         ; $2f8e: $ff
	xor  c                                           ; $2f8f: $a9
	ld   sp, $052f                                   ; $2f90: $31 $2f $05
	db   $fd                                         ; $2f93: $fd
	dec  b                                           ; $2f94: $05
	cpl                                              ; $2f95: $2f
	cpl                                              ; $2f96: $2f
	dec  d                                           ; $2f97: $15
	inc  b                                           ; $2f98: $04
	rla                                              ; $2f99: $17
	inc  h                                           ; $2f9a: $24
	dec  h                                           ; $2f9b: $25
	ld   h, $27                                      ; $2f9c: $26 $27
	inc  [hl]                                        ; $2f9e: $34
	dec  [hl]                                        ; $2f9f: $35
	ld   [hl], $2f                                   ; $2fa0: $36 $2f
	rst  $38                                         ; $2fa2: $ff
	xor  c                                           ; $2fa3: $a9
	ld   sp, $3708                                   ; $2fa4: $31 $08 $37
	db   $fd                                         ; $2fa7: $fd
	scf                                              ; $2fa8: $37
	db   $fd                                         ; $2fa9: $fd
	ld   [$1918], sp                                 ; $2faa: $08 $18 $19
	inc  d                                           ; $2fad: $14
	dec  de                                          ; $2fae: $1b
	jr   z, @+$2b                                    ; $2faf: $28 $29

	ld   a, [hl+]                                    ; $2fb1: $2a
	dec  hl                                          ; $2fb2: $2b
	ld   h, b                                        ; $2fb3: $60

jr_000_2fb4:
	ld   [hl], b                                     ; $2fb4: $70
	ld   [hl], $2f                                   ; $2fb5: $36 $2f
	rst  $38                                         ; $2fb7: $ff
	reti                                             ; $2fb8: $d9


	ld   sp, $fdb9                                   ; $2fb9: $31 $b9 $fd
	cp   c                                           ; $2fbc: $b9
	cp   d                                           ; $2fbd: $ba
	db   $fd                                         ; $2fbe: $fd
	cp   d                                           ; $2fbf: $ba
	rst  $38                                         ; $2fc0: $ff
	reti                                             ; $2fc1: $d9


	ld   sp, $fd82                                   ; $2fc2: $31 $82 $fd
	add  d                                           ; $2fc5: $82
	add  e                                           ; $2fc6: $83
	db   $fd                                         ; $2fc7: $fd
	add  e                                           ; $2fc8: $83
	rst  $38                                         ; $2fc9: $ff
	reti                                             ; $2fca: $d9


	ld   sp, $0a09                                   ; $2fcb: $31 $09 $0a
	ld   a, [hl-]                                    ; $2fce: $3a
	dec  sp                                          ; $2fcf: $3b
	rst  $38                                         ; $2fd0: $ff
	reti                                             ; $2fd1: $d9


	ld   sp, $400b                                   ; $2fd2: $31 $0b $40
	ld   a, h                                        ; $2fd5: $7c
	ld   l, a                                        ; $2fd6: $6f
	rst  $38                                         ; $2fd7: $ff
	reti                                             ; $2fd8: $d9


	ld   sp, $0f2f                                   ; $2fd9: $31 $2f $0f
	cpl                                              ; $2fdc: $2f
	rra                                              ; $2fdd: $1f
	ld   e, a                                        ; $2fde: $5f
	inc  l                                           ; $2fdf: $2c
	cpl                                              ; $2fe0: $2f
	ccf                                              ; $2fe1: $3f
	rst  $38                                         ; $2fe2: $ff
	reti                                             ; $2fe3: $d9


	ld   sp, $3c6c                                   ; $2fe4: $31 $6c $3c
	ld   c, e                                        ; $2fe7: $4b
	ld   c, h                                        ; $2fe8: $4c
	ld   e, e                                        ; $2fe9: $5b
	ld   e, h                                        ; $2fea: $5c
	ld   l, e                                        ; $2feb: $6b
	cpl                                              ; $2fec: $2f
	rst  $38                                         ; $2fed: $ff
	xor  c                                           ; $2fee: $a9
	ld   sp, $4d2f                                   ; $2fef: $31 $2f $4d
	db   $fd                                         ; $2ff2: $fd
	ld   c, l                                        ; $2ff3: $4d
	cpl                                              ; $2ff4: $2f
	cpl                                              ; $2ff5: $2f
	ld   e, l                                        ; $2ff6: $5d
	ld   e, [hl]                                     ; $2ff7: $5e
	ld   c, [hl]                                     ; $2ff8: $4e
	ld   e, a                                        ; $2ff9: $5f
	ld   l, l                                        ; $2ffa: $6d
	ld   l, [hl]                                     ; $2ffb: $6e
	cpl                                              ; $2ffc: $2f
	cpl                                              ; $2ffd: $2f
	ld   a, l                                        ; $2ffe: $7d
	db   $fd                                         ; $2fff: $fd
	ld   a, l                                        ; $3000: $7d
	cpl                                              ; $3001: $2f
	rst  $38                                         ; $3002: $ff
	xor  c                                           ; $3003: $a9
	ld   sp, $7708                                   ; $3004: $31 $08 $77
	db   $fd                                         ; $3007: $fd
	ld   [hl], a                                     ; $3008: $77
	db   $fd                                         ; $3009: $fd
	ld   [$7818], sp                                 ; $300a: $08 $18 $78
	ld   b, e                                        ; $300d: $43
	ld   d, e                                        ; $300e: $53
	ld   a, d                                        ; $300f: $7a
	ld   a, e                                        ; $3010: $7b
	ld   d, b                                        ; $3011: $50
	cpl                                              ; $3012: $2f
	cpl                                              ; $3013: $2f
	ld   [bc], a                                     ; $3014: $02
	db   $fd                                         ; $3015: $fd
	ld   a, l                                        ; $3016: $7d
	cpl                                              ; $3017: $2f
	rst  $38                                         ; $3018: $ff
	reti                                             ; $3019: $d9


	ld   sp, $fdb9                                   ; $301a: $31 $b9 $fd
	cp   c                                           ; $301d: $b9
	cp   d                                           ; $301e: $ba
	db   $fd                                         ; $301f: $fd
	cp   d                                           ; $3020: $ba
	rst  $38                                         ; $3021: $ff
	reti                                             ; $3022: $d9


	ld   sp, $fd82                                   ; $3023: $31 $82 $fd
	add  d                                           ; $3026: $82
	add  e                                           ; $3027: $83
	db   $fd                                         ; $3028: $fd
	add  e                                           ; $3029: $83
	rst  $38                                         ; $302a: $ff
	reti                                             ; $302b: $d9


	ld   sp, $0a09                                   ; $302c: $31 $09 $0a
	ld   a, [hl-]                                    ; $302f: $3a
	dec  sp                                          ; $3030: $3b
	rst  $38                                         ; $3031: $ff
	reti                                             ; $3032: $d9


	ld   sp, $400b                                   ; $3033: $31 $0b $40
	ld   a, h                                        ; $3036: $7c
	ld   l, a                                        ; $3037: $6f
	rst  $38                                         ; $3038: $ff
	reti                                             ; $3039: $d9


	ld   sp, $dddc                                   ; $303a: $31 $dc $dd
	ldh  [hGameState], a                                    ; $303d: $e0 $e1
	rst  $38                                         ; $303f: $ff
	reti                                             ; $3040: $d9


	ld   sp, $dfde                                   ; $3041: $31 $de $df
	ldh  [hGameState], a                                    ; $3044: $e0 $e1
	rst  $38                                         ; $3046: $ff
	reti                                             ; $3047: $d9


	ld   sp, $e2de                                   ; $3048: $31 $de $e2
	ldh  [hPrevOrCurrDemoPlayed], a                                    ; $304b: $e0 $e4
	rst  $38                                         ; $304d: $ff
	reti                                             ; $304e: $d9


	ld   sp, $eedc                                   ; $304f: $31 $dc $ee
	ldh  [hRowsShiftingDownState], a                                    ; $3052: $e0 $e3
	rst  $38                                         ; $3054: $ff
	reti                                             ; $3055: $d9


	ld   sp, $e6e5                                   ; $3056: $31 $e5 $e6
	rst  $20                                         ; $3059: $e7
	add  sp, -$01                                    ; $305a: $e8 $ff
	reti                                             ; $305c: $d9


	ld   sp, $e6fd                                   ; $305d: $31 $fd $e6
	db   $fd                                         ; $3060: $fd
	push hl                                          ; $3061: $e5
	db   $fd                                         ; $3062: $fd
	add  sp, -$03                                    ; $3063: $e8 $fd
	rst  $20                                         ; $3065: $e7
	rst  $38                                         ; $3066: $ff
	reti                                             ; $3067: $d9


	ld   sp, $eae9                                   ; $3068: $31 $e9 $ea
	db   $eb                                         ; $306b: $eb
	db   $ec                                         ; $306c: $ec
	rst  $38                                         ; $306d: $ff
	reti                                             ; $306e: $d9


	ld   sp, $eaed                                   ; $306f: $31 $ed $ea
	db   $eb                                         ; $3072: $eb
	db   $ec                                         ; $3073: $ec
	rst  $38                                         ; $3074: $ff
	reti                                             ; $3075: $d9


	ld   sp, $f4f2                                   ; $3076: $31 $f2 $f4
	di                                               ; $3079: $f3
	cp   a                                           ; $307a: $bf
	rst  $38                                         ; $307b: $ff
	reti                                             ; $307c: $d9


	ld   sp, $f2f4                                   ; $307d: $31 $f4 $f2
	cp   a                                           ; $3080: $bf
	di                                               ; $3081: $f3
	rst  $38                                         ; $3082: $ff
	reti                                             ; $3083: $d9


	ld   sp, $fdc2                                   ; $3084: $31 $c2 $fd
	jp   nz, $fdc3                                   ; $3087: $c2 $c3 $fd

	jp   $d9ff                                       ; $308a: $c3 $ff $d9


	ld   sp, $fdc4                                   ; $308d: $31 $c4 $fd
	call nz, $fdc5                                   ; $3090: $c4 $c5 $fd
	push bc                                          ; $3093: $c5
	rst  $38                                         ; $3094: $ff
	reti                                             ; $3095: $d9


	ld   sp, $fddc                                   ; $3096: $31 $dc $fd
	call c, $fdef                                    ; $3099: $dc $ef $fd
	RST_JumpTable                                         ; $309c: $ef
	rst  $38                                         ; $309d: $ff
	reti                                             ; $309e: $d9


	ld   sp, $fdf0                                   ; $309f: $31 $f0 $fd
	ldh  a, [hPausedNextSerialByteToLoad]                                    ; $30a2: $f0 $f1
	db   $fd                                         ; $30a4: $fd
	pop  af                                          ; $30a5: $f1
	rst  $38                                         ; $30a6: $ff
	reti                                             ; $30a7: $d9


	ld   sp, $fddc                                   ; $30a8: $31 $dc $fd
	ldh  a, [hPausedNextSerialByteToLoad]                                    ; $30ab: $f0 $f1
	db   $fd                                         ; $30ad: $fd
	RST_JumpTable                                         ; $30ae: $ef
	rst  $38                                         ; $30af: $ff
	reti                                             ; $30b0: $d9


	ld   sp, $fdf0                                   ; $30b1: $31 $f0 $fd
	call c, $fdef                                    ; $30b4: $dc $ef $fd
	pop  af                                          ; $30b7: $f1
	rst  $38                                         ; $30b8: $ff
	reti                                             ; $30b9: $d9


	ld   sp, $bebd                                   ; $30ba: $31 $bd $be
	cp   e                                           ; $30bd: $bb
	cp   h                                           ; $30be: $bc
	rst  $38                                         ; $30bf: $ff
	reti                                             ; $30c0: $d9


	ld   sp, $bab9                                   ; $30c1: $31 $b9 $ba
	jp   c, $ffdb                                    ; $30c4: $da $db $ff

	swap b                                           ; $30c7: $cb $30
	ldh  [$f0], a                                    ; $30c9: $e0 $f0
	push af                                          ; $30cb: $f5
	ld   sp, $c1c0                                   ; $30cc: $31 $c0 $c1
	push bc                                          ; $30cf: $c5
	add  $cc                                         ; $30d0: $c6 $cc
	call $7675                                       ; $30d2: $cd $75 $76
	and  h                                           ; $30d5: $a4
	and  l                                           ; $30d6: $a5
	and  [hl]                                        ; $30d7: $a6
	and  a                                           ; $30d8: $a7
	ld   d, h                                        ; $30d9: $54
	ld   d, l                                        ; $30da: $55
	ld   d, [hl]                                     ; $30db: $56
	ld   d, a                                        ; $30dc: $57
	ld   b, h                                        ; $30dd: $44
	ld   b, l                                        ; $30de: $45
	ld   b, [hl]                                     ; $30df: $46
	ld   b, a                                        ; $30e0: $47
	and  b                                           ; $30e1: $a0
	and  c                                           ; $30e2: $a1
	and  d                                           ; $30e3: $a2
	and  e                                           ; $30e4: $a3
	sbc  h                                           ; $30e5: $9c
	sbc  l                                           ; $30e6: $9d
	sbc  [hl]                                        ; $30e7: $9e
	sbc  a                                           ; $30e8: $9f
	rst  $38                                         ; $30e9: $ff
	ld   d, $31                                      ; $30ea: $16 $31
	ld   hl, sp-$18                                  ; $30ec: $f8 $e8
	inc  e                                           ; $30ee: $1c
	ld   sp, $e8f0                                   ; $30ef: $31 $f0 $e8
	dec  h                                           ; $30f2: $25
	ld   sp, $0000                                   ; $30f3: $31 $00 $00
	dec  hl                                          ; $30f6: $2b
	ld   sp, $0000                                   ; $30f7: $31 $00 $00
	ld   sp, $0031                                   ; $30fa: $31 $31 $00
	nop                                              ; $30fd: $00
	ld   a, [hl-]                                    ; $30fe: $3a
	ld   sp, $0000                                   ; $30ff: $31 $00 $00
	sbc  l                                           ; $3102: $9d
	ld   sp, $0000                                   ; $3103: $31 $00 $00
	and  e                                           ; $3106: $a3
	ld   sp, $0000                                   ; $3107: $31 $00 $00











	
	ld   h, h                                        ; $310a: $64
	ld   sp, $f8d8                                   ; $310b: $31 $d8 $f8
	ld   a, h                                        ; $310e: $7c
	ld   sp, $f8e8                                   ; $310f: $31 $e8 $f8
	adc  [hl]                                        ; $3112: $8e
	ld   sp, $f8f0                                   ; $3113: $31 $f0 $f8
	dec  l                                           ; $3116: $2d
	ld   [hl-], a                                    ; $3117: $32
	ld   h, e                                        ; $3118: $63
	ld   h, h                                        ; $3119: $64
	ld   h, l                                        ; $311a: $65
	rst  $38                                         ; $311b: $ff
	dec  l                                           ; $311c: $2d
	ld   [hl-], a                                    ; $311d: $32
	ld   h, e                                        ; $311e: $63
	ld   h, h                                        ; $311f: $64
	ld   h, l                                        ; $3120: $65
	ld   h, [hl]                                     ; $3121: $66
	ld   h, a                                        ; $3122: $67
	ld   l, b                                        ; $3123: $68
	rst  $38                                         ; $3124: $ff
	dec  l                                           ; $3125: $2d
	ld   [hl-], a                                    ; $3126: $32
	ld   b, c                                        ; $3127: $41
	ld   b, c                                        ; $3128: $41
	ld   b, c                                        ; $3129: $41
	rst  $38                                         ; $312a: $ff
	dec  l                                           ; $312b: $2d
	ld   [hl-], a                                    ; $312c: $32
	ld   b, d                                        ; $312d: $42
	ld   b, d                                        ; $312e: $42
	ld   b, d                                        ; $312f: $42
	rst  $38                                         ; $3130: $ff
	dec  l                                           ; $3131: $2d
	ld   [hl-], a                                    ; $3132: $32
	ld   d, d                                        ; $3133: $52
	ld   d, d                                        ; $3134: $52
	ld   d, d                                        ; $3135: $52
	ld   h, d                                        ; $3136: $62
	ld   h, d                                        ; $3137: $62
	ld   h, d                                        ; $3138: $62
	rst  $38                                         ; $3139: $ff
	dec  l                                           ; $313a: $2d
	ld   [hl-], a                                    ; $313b: $32
	ld   d, c                                        ; $313c: $51
	ld   d, c                                        ; $313d: $51
	ld   d, c                                        ; $313e: $51
	ld   h, c                                        ; $313f: $61
	ld   h, c                                        ; $3140: $61
	ld   h, c                                        ; $3141: $61
	ld   [hl], c                                     ; $3142: $71
	ld   [hl], c                                     ; $3143: $71
	ld   [hl], c                                     ; $3144: $71
	rst  $38                                         ; $3145: $ff
	xor  c                                           ; $3146: $a9
	ld   sp, $2f2f                                   ; $3147: $31 $2f $2f
	cpl                                              ; $314a: $2f
	cpl                                              ; $314b: $2f
	cpl                                              ; $314c: $2f
	cpl                                              ; $314d: $2f
	cpl                                              ; $314e: $2f
	cpl                                              ; $314f: $2f
	ld   h, e                                        ; $3150: $63
	ld   h, h                                        ; $3151: $64
	db   $fd                                         ; $3152: $fd
	ld   h, h                                        ; $3153: $64
	db   $fd                                         ; $3154: $fd
	ld   h, e                                        ; $3155: $63
	ld   h, [hl]                                     ; $3156: $66
	ld   h, a                                        ; $3157: $67
	db   $fd                                         ; $3158: $fd
	ld   h, a                                        ; $3159: $67
	db   $fd                                         ; $315a: $fd
	ld   h, [hl]                                     ; $315b: $66
	rst  $38                                         ; $315c: $ff
	reti                                             ; $315d: $d9


	ld   sp, $2f2f                                   ; $315e: $31 $2f $2f
	ld   h, e                                        ; $3161: $63
	ld   h, h                                        ; $3162: $64
	rst  $38                                         ; $3163: $ff
	reti                                             ; $3164: $d9


	ld   sp, $fd00                                   ; $3165: $31 $00 $fd
	nop                                              ; $3168: $00
	db   $10                                         ; $3169: $10
	db   $fd                                         ; $316a: $fd
	db   $10                                         ; $316b: $10
	ld   c, a                                        ; $316c: $4f
	db   $fd                                         ; $316d: $fd
	ld   c, a                                        ; $316e: $4f
	add  b                                           ; $316f: $80
	db   $fd                                         ; $3170: $fd
	add  b                                           ; $3171: $80
	add  b                                           ; $3172: $80
	db   $fd                                         ; $3173: $fd
	add  b                                           ; $3174: $80
	add  c                                           ; $3175: $81
	db   $fd                                         ; $3176: $fd
	add  c                                           ; $3177: $81
	sub  a                                           ; $3178: $97
	db   $fd                                         ; $3179: $fd
	sub  a                                           ; $317a: $97
	rst  $38                                         ; $317b: $ff
	reti                                             ; $317c: $d9


	ld   sp, $fd98                                   ; $317d: $31 $98 $fd
	sbc  b                                           ; $3180: $98
	sbc  c                                           ; $3181: $99
	db   $fd                                         ; $3182: $fd
	sbc  c                                           ; $3183: $99
	add  b                                           ; $3184: $80
	db   $fd                                         ; $3185: $fd
	add  b                                           ; $3186: $80
	sbc  d                                           ; $3187: $9a
	db   $fd                                         ; $3188: $fd
	sbc  d                                           ; $3189: $9a
	sbc  e                                           ; $318a: $9b
	db   $fd                                         ; $318b: $fd
	sbc  e                                           ; $318c: $9b
	rst  $38                                         ; $318d: $ff
	reti                                             ; $318e: $d9


	ld   sp, $fda8                                   ; $318f: $31 $a8 $fd
	xor  b                                           ; $3192: $a8
	xor  c                                           ; $3193: $a9
	db   $fd                                         ; $3194: $fd
	xor  c                                           ; $3195: $a9
	xor  d                                           ; $3196: $aa
	db   $fd                                         ; $3197: $fd
	xor  d                                           ; $3198: $aa
	xor  e                                           ; $3199: $ab
	db   $fd                                         ; $319a: $fd
	xor  e                                           ; $319b: $ab
	rst  $38                                         ; $319c: $ff
	reti                                             ; $319d: $d9


	ld   sp, $2f41                                   ; $319e: $31 $41 $2f
	cpl                                              ; $31a1: $2f
	rst  $38                                         ; $31a2: $ff
	reti                                             ; $31a3: $d9


	ld   sp, $2f52                                   ; $31a4: $31 $52 $2f
	ld   h, d                                        ; $31a7: $62
	rst  $38                                         ; $31a8: $ff
	nop                                              ; $31a9: $00
	nop                                              ; $31aa: $00
	nop                                              ; $31ab: $00
	ld   [$1000], sp                                 ; $31ac: $08 $00 $10
	nop                                              ; $31af: $00
	jr   jr_000_31ba                                 ; $31b0: $18 $08

	nop                                              ; $31b2: $00
	ld   [$0808], sp                                 ; $31b3: $08 $08 $08
	db   $10                                         ; $31b6: $10
	ld   [$1018], sp                                 ; $31b7: $08 $18 $10

jr_000_31ba:
	nop                                              ; $31ba: $00
	db   $10                                         ; $31bb: $10
	ld   [$1010], sp                                 ; $31bc: $08 $10 $10
	db   $10                                         ; $31bf: $10
	jr   jr_000_31da                                 ; $31c0: $18 $18

	nop                                              ; $31c2: $00
	jr   @+$0a                                       ; $31c3: $18 $08

	jr   @+$12                                       ; $31c5: $18 $10

	jr   @+$1a                                       ; $31c7: $18 $18


Data_31c9:
	nop                                              ; $31c9: $00
	nop                                              ; $31ca: $00
	nop                                              ; $31cb: $00
	ld   [$1000], sp                                 ; $31cc: $08 $00 $10
	nop                                              ; $31cf: $00
	jr   jr_000_31d2                                 ; $31d0: $18 $00

jr_000_31d2:
	jr   nz, jr_000_31d4                             ; $31d2: $20 $00

jr_000_31d4:
	jr   z, jr_000_31d6                              ; $31d4: $28 $00

jr_000_31d6:
	jr   nc, jr_000_31d8                             ; $31d6: $30 $00

jr_000_31d8:
	jr   c, jr_000_31da                              ; $31d8: $38 $00

jr_000_31da:
	nop                                              ; $31da: $00
	nop                                              ; $31db: $00
	ld   [$0008], sp                                 ; $31dc: $08 $08 $00
	ld   [$1008], sp                                 ; $31df: $08 $08 $10
	nop                                              ; $31e2: $00
	db   $10                                         ; $31e3: $10
	ld   [$0018], sp                                 ; $31e4: $08 $18 $00
	jr   jr_000_31f1                                 ; $31e7: $18 $08

	jr   nz, jr_000_31eb                             ; $31e9: $20 $00

jr_000_31eb:
	jr   nz, jr_000_31f5                             ; $31eb: $20 $08

	jr   z, jr_000_31ef                              ; $31ed: $28 $00

jr_000_31ef:
	jr   z, jr_000_31f9                              ; $31ef: $28 $08

jr_000_31f1:
	jr   nc, jr_000_31f3                             ; $31f1: $30 $00

jr_000_31f3:
	jr   nc, jr_000_31fd                             ; $31f3: $30 $08

jr_000_31f5:
	nop                                              ; $31f5: $00
	ld   [$1000], sp                                 ; $31f6: $08 $00 $10

jr_000_31f9:
	ld   [$0808], sp                                 ; $31f9: $08 $08 $08
	db   $10                                         ; $31fc: $10

jr_000_31fd:
	stop                                             ; $31fd: $10 $00
	db   $10                                         ; $31ff: $10
	ld   [$1010], sp                                 ; $3200: $08 $10 $10
	db   $10                                         ; $3203: $10
	jr   @+$1a                                       ; $3204: $18 $18

	nop                                              ; $3206: $00
	jr   jr_000_3211                                 ; $3207: $18 $08

	jr   jr_000_321b                                 ; $3209: $18 $10

	jr   jr_000_3225                                 ; $320b: $18 $18

	jr   nz, jr_000_320f                             ; $320d: $20 $00

jr_000_320f:
	jr   nz, jr_000_3219                             ; $320f: $20 $08

jr_000_3211:
	jr   nz, jr_000_3223                             ; $3211: $20 $10

	jr   nz, jr_000_322d                             ; $3213: $20 $18

	jr   z, jr_000_3217                              ; $3215: $28 $00

jr_000_3217:
	jr   z, jr_000_3221                              ; $3217: $28 $08

jr_000_3219:
	jr   z, jr_000_322b                              ; $3219: $28 $10

jr_000_321b:
	jr   z, @+$1a                                    ; $321b: $28 $18

	jr   nc, jr_000_321f                             ; $321d: $30 $00

jr_000_321f:
	jr   nc, jr_000_3229                             ; $321f: $30 $08

jr_000_3221:
	jr   nc, jr_000_3233                             ; $3221: $30 $10

jr_000_3223:
	jr   nc, @+$1a                                   ; $3223: $30 $18

jr_000_3225:
	jr   c, jr_000_3227                              ; $3225: $38 $00

jr_000_3227:
	jr   c, @+$0a                                    ; $3227: $38 $08

jr_000_3229:
	jr   c, jr_000_323b                              ; $3229: $38 $10

jr_000_322b:
	db $38, $18

jr_000_322d:
	nop                                              ; $322d: $00
	nop                                              ; $322e: $00
	nop                                              ; $322f: $00
	ld   [$1000], sp                                 ; $3230: $08 $00 $10

jr_000_3233:
	ld   [$0800], sp                                 ; $3233: $08 $00 $08
	ld   [$1008], sp                                 ; $3236: $08 $08 $10
	stop                                             ; $3239: $10 $00

jr_000_323b:
	db   $10                                         ; $323b: $10
	ld   [$1010], sp                                 ; $323c: $08 $10 $10