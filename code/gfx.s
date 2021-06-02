UnusedStoreBCDByteInHLInDestDE:
	ld   a, [hl]                                                    ; $2665
	and  $f0                                                        ; $2666
	swap a                                                          ; $2668
	ld   [de], a                                                    ; $266a
	ld   a, [hl]                                                    ; $266b
	and  $0f                                                        ; $266c
	inc  e                                                          ; $266e
	ld   [de], a                                                    ; $266f
	ret                                                             ; $2670


Copy2SpriteSpecsToShadowOam:
	ld   a, $02                                                     ; $2671

CopyASpriteSpecsToShadowOam:
	ldh  [hNumSpriteSpecs], a                                       ; $2673

	; LOW(wOam)
	xor  a                                                          ; $2675
	ldh  [hCurr_wOam_SpriteAddr+1], a                               ; $2676
	ld   a, HIGH(wOam)                                              ; $2678
	ldh  [hCurr_wOam_SpriteAddr], a                                 ; $267a

	ld   hl, wSpriteSpecs                                           ; $267c
	call CopyToShadowOamBasedOnSpriteSpec                           ; $267f
	ret                                                             ; $2682


Copy1stSpriteSpecToSprite4:
	ld   a, $01                                                     ; $2683
	ldh  [hNumSpriteSpecs], a                                       ; $2685
	ld   a, LOW(wOam+OAM_SIZEOF*4)                                  ; $2687
	ldh  [hCurr_wOam_SpriteAddr+1], a                               ; $2689
	ld   a, HIGH(wOam+OAM_SIZEOF*4)                                 ; $268b
	ldh  [hCurr_wOam_SpriteAddr], a                                 ; $268d
	ld   hl, wSpriteSpecs                                           ; $268f
	call CopyToShadowOamBasedOnSpriteSpec                           ; $2692
	ret                                                             ; $2695


Copy2ndSpriteSpecToSprite8:
	ld   a, $01                                                     ; $2696
	ldh  [hNumSpriteSpecs], a                                       ; $2698
	ld   a, LOW(wOam+OAM_SIZEOF*8)                                  ; $269a
	ldh  [hCurr_wOam_SpriteAddr+1], a                               ; $269c
	ld   a, HIGH(wOam+OAM_SIZEOF*8)                                 ; $269e
	ldh  [hCurr_wOam_SpriteAddr], a                                 ; $26a0
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                           ; $26a2
	call CopyToShadowOamBasedOnSpriteSpec                           ; $26a5
	ret                                                             ; $26a8


DisplayBlackColumnFromHLdown:
	ld   b, GB_TILE_HEIGHT                                          ; $26a9
	ld   a, TILE_BLACK                                              ; $26ab
	ld   de, GB_TILE_WIDTH                                          ; $26ad

.loop:
	ld   [hl], a                                                    ; $26b0
	add  hl, de                                                     ; $26b1
	dec  b                                                          ; $26b2
	jr   nz, .loop                                                  ; $26b3

	ret                                                             ; $26b5


CopyDEintoHLwhileFFhNotFound:
.loop:
	ld   a, [de]                                                    ; $26b6
	cp   $ff                                                        ; $26b7
	ret  z                                                          ; $26b9

	ld   [hl+], a                                                   ; $26ba
	inc  de                                                         ; $26bb
	jr   .loop                                                      ; $26bc


StubInterruptHandler:
	reti                                                            ; $26be


SpriteSpecStruct_LPieceActive:
	db $00, $18, $3f, SPRITE_SPEC_L_PIECE, $80, $00, $00, $ff


SpriteSpecStruct_LPieceNext:
	db $00, $80, $8f, SPRITE_SPEC_L_PIECE, $80, $00, $00, $ff


SpriteSpecStruct_GameMusicAType:
	db $00, $70, $37, SPRITE_SPEC_A_TYPE, $00, $00
	db $00, $38, $37, SPRITE_SPEC_A_TYPE, $00, $00
	

SpriteSpecStruct_ATypeFlashing0:
	db $00, $40, $34, SPRITE_SPEC_IDX_0, $00, $00


SpriteSpecStruct_BTypeLevelAndHigh:
	db $00, $40, $1c, SPRITE_SPEC_IDX_0, $00, $00
	db $00, $40, $74, SPRITE_SPEC_IDX_0, $00, $00


SpriteSpecStruct_2PlayerHighsFlashing1:
	db $00, $40, $68, SPRITE_SPEC_IDX_1, $00, $00
	db $00, $78, $68, SPRITE_SPEC_IDX_1, $00, $00


SpriteSpecStruct_StandingMarioCryingBabyMario:
	db $00, $60, $60, SPRITE_SPEC_STANDING_MARIO, $80, $00
	db $00, $60, $72, SPRITE_SPEC_STANDING_MARIO, $80, $20
	db $00, $68, $38, SPRITE_SPEC_CRYING_MARIO_1, $80, $00


SpriteSpecStruct_StandingLuigiCryingBabyLuigi:
	db $00, $60, $60, SPRITE_SPEC_STANDING_LUIGI, $80, $00
	db $00, $60, $72, SPRITE_SPEC_STANDING_LUIGI, $80, $20
	db $00, $68, $38, SPRITE_SPEC_CRYING_LUIGI_1, $80, $00


SpriteSpecStruct_MariosFacingAway:
	db $00, $60, $60, SPRITE_SPEC_MARIO_FACING_AWAY, $80, $00
	db $00, $68, $38, SPRITE_SPEC_BABY_MARIO_FACING_AWAY, $80, $00


SpriteSpecStruct_LuigisFacingAway:
	db $00, $60, $60, SPRITE_SPEC_LUIGI_FACING_AWAY, $80, $00
	db $00, $68, $38, SPRITE_SPEC_BABY_LUIGI_FACING_AWAY, $80, $00


SpriteSpecStruct_Dancers:
	db $80, $3f, $40, SPRITE_SPEC_VIOLINIST_2, $00, $00
	db $80, $3f, $20, SPRITE_SPEC_GUITARIST_1, $00, $00
	db $80, $3f, $30, SPRITE_SPEC_DOUBLE_BASS_1, $00, $00
	db $80, $77, $20, SPRITE_SPEC_BELLY_DRUM_1, $00, $00
	db $80, $87, $48, SPRITE_SPEC_COUPLE_1, $00, $00
	db $80, $87, $58, SPRITE_SPEC_CLAPPER_1, $00, $00
	db $80, $67, $4d, SPRITE_SPEC_JUMPER_1, $00, $00
	db $80, $67, $5d, SPRITE_SPEC_KICKER_1, $00, $00
	db $80, $8f, $88, SPRITE_SPEC_SWORDSMAN_1, $00, $00
	db $80, $8f, $98, SPRITE_SPEC_SWORDSMAN_2, $00, $00


SpriteSpecStruct_ShuttleAndGas:
	db $00, $5f, $57, SPRITE_SPEC_SHUTTLE, $00, $00
	db $80, $80, $50, SPRITE_SPEC_SMALL_LIFTOFF_GAS, $00, $00
	db $80, $80, $60, SPRITE_SPEC_SMALL_LIFTOFF_GAS, $00, $20
	
	
SpriteSpecStruct_RocketAndGas:
	db $00, $6f, $57, SPRITE_SPEC_BIG_ROCKET, $00, $00
	db $80, $80, $55, SPRITE_SPEC_SMALL_LIFTOFF_GAS, $00, $00
	db $80, $80, $5b, SPRITE_SPEC_SMALL_LIFTOFF_GAS, $00, $20
	
	
FillScreen0FromHLdownWithEmptyTile:
	ld   hl, _SCRN0+$3ff                                            ; $2795

FillScreenFromHLdownWithEmptyTile:
	ld   bc, $0400                                                  ; $2798

.loop:
	ld   a, TILE_EMPTY                                              ; $279b
	ld   [hl-], a                                                   ; $279d
	dec  bc                                                         ; $279e
	ld   a, b                                                       ; $279f
	or   c                                                          ; $27a0
	jr   nz, .loop                                                  ; $27a1

	ret                                                             ; $27a3


CopyHLtoDE_BCbytes:
.loop:
	ld   a, [hl+]                                                   ; $27a4
	ld   [de], a                                                    ; $27a5
	inc  de                                                         ; $27a6
	dec  bc                                                         ; $27a7
	ld   a, b                                                       ; $27a8
	or   c                                                          ; $27a9
	jr   nz, .loop                                                  ; $27aa

	ret                                                             ; $27ac


LoadAsciiAndMenuScreenGfx:
	call CopyAsciiTileData                                          ; $27ad

; further graphics (menu screen bits) after ascii from title screen
	ld   bc, $00a0                                                  ; $27b0
	call CopyHLtoDE_BCbytes                                         ; $27b3

	ld   hl, Gfx_MenuScreens                                        ; $27b6
	ld   de, _VRAM+$300                                             ; $27b9
	ld   bc, Gfx_MenuScreens.end-Gfx_MenuScreens+$b0                ; $27bc
	call CopyHLtoDE_BCbytes                                         ; $27bf
	ret                                                             ; $27c2


CopyAsciiTileData:
	ld   hl, Gfx_Ascii                                              ; $27c3
	ld   bc, Gfx_Ascii.end-Gfx_Ascii                                ; $27c6
	ld   de, _VRAM                                                  ; $27c9

.loop:
	ld   a, [hl+]                                                   ; $27cc
	ld   [de], a                                                    ; $27cd
	inc  de                                                         ; $27ce
	ld   [de], a                                                    ; $27cf
	inc  de                                                         ; $27d0
	dec  bc                                                         ; $27d1
	ld   a, b                                                       ; $27d2
	or   c                                                          ; $27d3
	jr   nz, .loop                                                  ; $27d4

	ret                                                             ; $27d6


CopyAsciiAndTitleScreenTileData:
	call CopyAsciiTileData                                          ; $27d7

; overruns into tile layout, actually $770 bytes
	ld   bc, Gfx_TitleScreen.end-Gfx_TitleScreen+$0630              ; $27da
	call CopyHLtoDE_BCbytes                                         ; $27dd
	ret                                                             ; $27e0


UnusedCopyHLtoVram1000hBytes:
	ld   bc, $1000                                                  ; $27e1

CopyHLtoVramBCbytes:
	ld   de, _VRAM                                                  ; $27e4
	call CopyHLtoDE_BCbytes                                         ; $27e7

Stub_27ea:
	ret                                                             ; $27ea


; in: DE - source addr
CopyLayoutToScreen0:
	ld   hl, _SCRN0                                                 ; $27eb

; in: DE - source addr
; in: HL - vram dest addr
CopyLayoutToHL:
	ld   b, SCREEN_TILE_HEIGHT                                      ; $27ee

; in: B - number of rows to copy to
; in: DE - source addr
; in: HL - vram dest addr
CopyLayoutBrowsToHL:
.loopRow:
; push current start vram addr
	push hl                                                         ; $27f0
	ld   c, SCREEN_TILE_WIDTH                                       ; $27f1

.loopCol:
	ld   a, [de]                                                    ; $27f3
	ld   [hl+], a                                                   ; $27f4
	inc  de                                                         ; $27f5
	dec  c                                                          ; $27f6
	jr   nz, .loopCol                                               ; $27f7

; next row below start of current
	pop  hl                                                         ; $27f9
	push de                                                         ; $27fa
	ld   de, GB_TILE_WIDTH                                          ; $27fb
	add  hl, de                                                     ; $27fe
	pop  de                                                         ; $27ff
	dec  b                                                          ; $2800
	jr   nz, .loopRow                                               ; $2801

	ret                                                             ; $2803


CopyToGameScreenUntilByteReadEquFFhThenSetVramTransfer:
.nextRow:
	ld   b, GAME_SQUARE_WIDTH                                       ; $2804
	push hl                                                         ; $2806

.loop:
; done when byte read == $ff
	ld   a, [de]                                                    ; $2807
	cp   $ff                                                        ; $2808
	jr   z, .done                                                   ; $280a

; copy to dest
	ld   [hl+], a                                                   ; $280c
	inc  de                                                         ; $280d
	dec  b                                                          ; $280e
	jr   nz, .loop                                                  ; $280f

; to next row
	pop  hl                                                         ; $2811
	push de                                                         ; $2812
	ld   de, GB_TILE_WIDTH                                          ; $2813
	add  hl, de                                                     ; $2816
	pop  de                                                         ; $2817
	jr   .nextRow                                                   ; $2818

.done:
	pop  hl                                                         ; $281a

; transfer to vram a row at a time
	ld   a, ROWS_SHIFTING_DOWN_ROW_START                            ; $281b
	ldh  [hRowsShiftingDownState], a                                ; $281d
	ret                                                             ; $281f


TurnOffLCD:
; preserve IE
	ldh  a, [rIE]                                                   ; $2820

; disable vblank interrupt
	ldh  [hTempIE], a                                               ; $2822
	res  0, a                                                       ; $2824
	ldh  [rIE], a                                                   ; $2826

.waitUntilInVBlank:
	ldh  a, [rLY]                                                   ; $2828
	cp   $91                                                        ; $282a
	jr   nz, .waitUntilInVBlank                                     ; $282c

; turn off LCD
	ldh  a, [rLCDC]                                                 ; $282e
	and  $ff-LCDCF_ON                                               ; $2830
	ldh  [rLCDC], a                                                 ; $2832

; restore IE
	ldh  a, [hTempIE]                                               ; $2834
	ldh  [rIE], a                                                   ; $2836
	ret                                                             ; $2838


GameInnerScreenLayout_Pause:
	db "  HIT   "
	db "  ...   "
	db " START  "
	db " .....  "
	db "   TO   "
	db "   ..   "
	db "CONTINUE"
	db "........"
	db "  GAME  "
	db "  ....  "


GameScreenLayout_ScoreTotals:
	INCBIN "data/gameScreenLayout_scoreTotals.bin"


GameInnerScreenLayout_GameOver:
	db "'//======\\'"
	db "'||      ||'"
	db "'|| GAME ||'"
	db "'|| ____ ||'"
	db "'|| OVER ||'"
	db "'|| ____ ||'"
	db ",\\~~~~~~,//"


GameInnerScreen_TryAgain:
	db "PLEASE  "
	db "......  "
	db " TRY    "
	db " ...    "
	db "  AGAIN<3"
	db "  ..... "


PollInput:
	ld   a, $20                                                     ; $29a6
	ldh  [rP1], a                                                   ; $29a8
	ldh  a, [rP1]                                                   ; $29aa
	ldh  a, [rP1]                                                   ; $29ac
	ldh  a, [rP1]                                                   ; $29ae
	ldh  a, [rP1]                                                   ; $29b0
	cpl                                                             ; $29b2
	and  $0f                                                        ; $29b3
	swap a                                                          ; $29b5
	ld   b, a                                                       ; $29b7
	ld   a, $10                                                     ; $29b8
	ldh  [rP1], a                                                   ; $29ba
	ldh  a, [rP1]                                                   ; $29bc
	ldh  a, [rP1]                                                   ; $29be
	ldh  a, [rP1]                                                   ; $29c0
	ldh  a, [rP1]                                                   ; $29c2
	ldh  a, [rP1]                                                   ; $29c4
	ldh  a, [rP1]                                                   ; $29c6
	ldh  a, [rP1]                                                   ; $29c8
	ldh  a, [rP1]                                                   ; $29ca
	ldh  a, [rP1]                                                   ; $29cc
	ldh  a, [rP1]                                                   ; $29ce
	cpl                                                             ; $29d0
	and  $0f                                                        ; $29d1
	or   b                                                          ; $29d3
	ld   c, a                                                       ; $29d4
	ldh  a, [hButtonsHeld]                                          ; $29d5
	xor  c                                                          ; $29d7
	and  c                                                          ; $29d8
	ldh  [hButtonsPressed], a                                       ; $29d9
	ld   a, c                                                       ; $29db
	ldh  [hButtonsHeld], a                                          ; $29dc
	ld   a, $30                                                     ; $29de
	ldh  [rP1], a                                                   ; $29e0
	ret                                                             ; $29e2


GetScreen0AddressOfPieceSquare:
; get square tile Y
	ldh  a, [hCurrPieceSquarePixelY]                                ; $29e3
	sub  PIECE_START_Y                                              ; $29e5
	srl  a                                                          ; $29e7
	srl  a                                                          ; $29e9
	srl  a                                                          ; $29eb
	ld   de, $0000                                                  ; $29ed
	ld   e, a                                                       ; $29f0

; get row offset in screen 0
	ld   hl, _SCRN0                                                 ; $29f1
	ld   b, $20                                                     ; $29f4

.loop:
	add  hl, de                                                     ; $29f6
	dec  b                                                          ; $29f7
	jr   nz, .loop                                                  ; $29f8

; get square tile X
	ldh  a, [hCurrPieceSquarePixelX]                                ; $29fa
	sub  $08                                                        ; $29fc
	srl  a                                                          ; $29fe
	srl  a                                                          ; $2a00
	srl  a                                                          ; $2a02
	ld   de, $0000                                                  ; $2a04
	ld   e, a                                                       ; $2a07

; add onto screen 0
	add  hl, de                                                     ; $2a08
	ld   a, h                                                       ; $2a09
	ldh  [hCurrPieceSquareScreen0Addr+1], a                         ; $2a0a
	ld   a, l                                                       ; $2a0c
	ldh  [hCurrPieceSquareScreen0Addr], a                           ; $2a0d
	ret                                                             ; $2a0f


; unused
	ldh  a, [hCurrPieceSquareScreen0Addr+1]                                    ; $2a10: $f0 $b5
	ld   d, a                                        ; $2a12: $57
	ldh  a, [hCurrPieceSquareScreen0Addr]                                    ; $2a13: $f0 $b4
	ld   e, a                                        ; $2a15: $5f
	ld   b, $04                                      ; $2a16: $06 $04

jr_000_2a18:
	rr   d                                           ; $2a18: $cb $1a
	rr   e                                           ; $2a1a: $cb $1b
	dec  b                                           ; $2a1c: $05
	jr   nz, jr_000_2a18                             ; $2a1d: $20 $f9

	ld   a, e                                        ; $2a1f: $7b
	sub  $84                                         ; $2a20: $d6 $84
	and  $fe                                         ; $2a22: $e6 $fe
	rlca                                             ; $2a24: $07
	rlca                                             ; $2a25: $07
	add  $08                                         ; $2a26: $c6 $08
	ldh  [hCurrPieceSquarePixelY], a                                    ; $2a28: $e0 $b2
	ldh  a, [hCurrPieceSquareScreen0Addr]                                    ; $2a2a: $f0 $b4
	and  $1f                                         ; $2a2c: $e6 $1f
	rla                                              ; $2a2e: $17
	rla                                              ; $2a2f: $17
	rla                                              ; $2a30: $17
	add  $08                                         ; $2a31: $c6 $08
	ldh  [hCurrPieceSquarePixelX], a                                    ; $2a33: $e0 $b3
	ret                                              ; $2a35: $c9


DisplayBCDNum6DigitsIfForced:
; this var is set to 0 at the end of this func,
; so can only exec if the var is forced non-0
	ldh  a, [hFoundDisplayableScoreDigit]                           ; $2a36
	and  a                                                          ; $2a38
	ret  z                                                          ; $2a39

DisplayBCDNum6Digits:
	ld   c, $03                                                     ; $2a3a

DisplayBCDNum2CDigits:
	xor  a                                                          ; $2a3c
	ldh  [hFoundDisplayableScoreDigit], a                           ; $2a3d

.nextByte:
; put byte in B
	ld   a, [de]                                                    ; $2a3f
	ld   b, a                                                       ; $2a40

; check tens bit of byte
	swap a                                                          ; $2a41
	and  $0f                                                        ; $2a43
	jr   nz, .tensNot0                                              ; $2a45

; tens bit of byte = 0, use empty or 0 based on if we're drawing digits
	ldh  a, [hFoundDisplayableScoreDigit]                           ; $2a47
	and  a                                                          ; $2a49
	ld   a, TILE_0                                                  ; $2a4a
	jr   nz, .displayTens                                           ; $2a4c

	ld   a, TILE_EMPTY                                              ; $2a4e

.displayTens:
	ld   [hl+], a                                                   ; $2a50

; check low digit
	ld   a, b                                                       ; $2a51
	and  $0f                                                        ; $2a52
	jr   nz, .onesNot0                                              ; $2a54

; digit = 0
	ldh  a, [hFoundDisplayableScoreDigit]                           ; $2a56
	and  a                                                          ; $2a58
	ld   a, TILE_0                                                  ; $2a59
	jr   nz, .displayOnes                                           ; $2a5b

; not displaying tiles yet, display 0 digit if last byte
	ld   a, $01                                                     ; $2a5d
	cp   c                                                          ; $2a5f
	ld   a, TILE_0                                                  ; $2a60
	jr   z, .displayOnes                                            ; $2a62

	ld   a, TILE_EMPTY                                              ; $2a64

.displayOnes:
	ld   [hl+], a                                                   ; $2a66

; next vram dest and C
	dec  e                                                          ; $2a67
	dec  c                                                          ; $2a68
	jr   nz, .nextByte                                              ; $2a69

; reset this for next display
	xor  a                                                          ; $2a6b
	ldh  [hFoundDisplayableScoreDigit], a                           ; $2a6c
	ret                                                             ; $2a6e

; for below 2 labels, set that we can now display further digits even if 0
.tensNot0:
	push af                                                         ; $2a6f
	ld   a, $01                                                     ; $2a70
	ldh  [hFoundDisplayableScoreDigit], a                           ; $2a72
	pop  af                                                         ; $2a74
	jr   .displayTens                                               ; $2a75

.onesNot0:
	push af                                                         ; $2a77
	ld   a, $01                                                     ; $2a78
	ldh  [hFoundDisplayableScoreDigit], a                           ; $2a7a
	pop  af                                                         ; $2a7c
	jr   .displayOnes                                               ; $2a7d


OamDmaFunction:
	ld   a, HIGH(wOam)                                              ; $2a7f
	ldh  [rDMA], a                                                  ; $2a81
	ld   a, $28                                                     ; $2a83

.wait:
	dec  a                                                          ; $2a85
	jr   nz, .wait                                                  ; $2a86

	ret                                                             ; $2a88


; HL - source of sprite specs, used to generate sprite vars, $10 per spec
; [HL+0] - 0 if showing sprites, $80 if hiding the sprites
; [$8f] - num sprite specs
; difference between base y/x and the offset vars, is that base is the center of the tile
;   where y and x flipping flip around
CopyToShadowOamBasedOnSpriteSpec:
.nextStructInSpriteSpec:
; store address of sprite specs
	ld   a, h                                                       ; $2a89
	ldh  [hSpriteSpecSrcAddr], a                                    ; $2a8a
	ld   a, l                                                       ; $2a8c
	ldh  [hSpriteSpecSrcAddr+1], a                                  ; $2a8d

; only starting byte of $00 or $80 allowed
	ld   a, [hl]                                                    ; $2a8f
	and  a                                                          ; $2a90
	jr   z, .dontHideNextSpritesBeingProcessed                      ; $2a91

	cp   $80                                                        ; $2a93
	jr   z, .hideNextSpritesBeingProcessed                          ; $2a95

.checkIfMoreSpriteSpecs:
; to next struct by adding $10
	ldh  a, [hSpriteSpecSrcAddr]                                    ; $2a97
	ld   h, a                                                       ; $2a99
	ldh  a, [hSpriteSpecSrcAddr+1]                                  ; $2a9a
	ld   l, a                                                       ; $2a9c
	ld   de, SPR_SPEC_SIZEOF                                        ; $2a9d
	add  hl, de                                                     ; $2aa0
	
; check if more sprite specs to process
	ldh  a, [hNumSpriteSpecs]                                       ; $2aa1
	dec  a                                                          ; $2aa3
	ldh  [hNumSpriteSpecs], a                                       ; $2aa4
	ret  z                                                          ; $2aa6

	jr   .nextStructInSpriteSpec                                    ; $2aa7

.showNextSpritesCheckIfMoreSpriteSpecs:
; no longer hide sprites, and look to next sprite spec
	xor  a                                                          ; $2aa9
	ldh  [hShouldHideCurrSprite], a                                 ; $2aaa
	jr   .checkIfMoreSpriteSpecs                                    ; $2aac

.hideNextSpritesBeingProcessed:
	ldh  [hShouldHideCurrSprite], a                                 ; $2aae

.dontHideNextSpritesBeingProcessed:
; copy from hl to ff86-ff8c
	ld   b, SPR_SPEC_DISPLAY_ENDOF                                  ; $2ab0
	ld   de, hCurrSpriteSpecStruct                                  ; $2ab2

.copyLoop1:
	ld   a, [hl+]                                                   ; $2ab5
	ld   [de], a                                                    ; $2ab6
	inc  de                                                         ; $2ab7
	dec  b                                                          ; $2ab8
	jr   nz, .copyLoop1                                             ; $2ab9

; initial double index into SpriteData
	ldh  a, [hCurrSpriteSpecIdx]                                    ; $2abb

; get double index into sprite data table
	ld   hl, SpriteData                                             ; $2abd
	rlca                                                            ; $2ac0
	ld   e, a                                                       ; $2ac1
	ld   d, $00                                                     ; $2ac2
	add  hl, de                                                     ; $2ac4

; get word into de (pointer to a word and y/x base offset)
	ld   e, [hl]                                                    ; $2ac5
	inc  hl                                                         ; $2ac6
	ld   d, [hl]                                                    ; $2ac7

; get word into hl (address of tile indexes and y/x offsets per tile)
	ld   a, [de]                                                    ; $2ac8
	ld   l, a                                                       ; $2ac9
	inc  de                                                         ; $2aca
	ld   a, [de]                                                    ; $2acb
	ld   h, a                                                       ; $2acc
	inc  de                                                         ; $2acd

; store next word (base y/x offsets for sprite spec)
	ld   a, [de]                                                    ; $2ace
	ldh  [hCurrSpriteSpecBaseYOffset], a                            ; $2acf
	inc  de                                                         ; $2ad1
	ld   a, [de]                                                    ; $2ad2
	ldh  [hCurrSpriteSpecBaseXOffset], a                            ; $2ad3

; get the word from hl into de (adress of y/x offsets per tile)
; tile indexes come after
	ld   e, [hl]                                                    ; $2ad5
	inc  hl                                                         ; $2ad6
	ld   d, [hl]                                                    ; $2ad7

.bigLoop:
; init vars - just the base x flip for current sprite
	inc  hl                                                         ; $2ad8
	ldh  a, [hCurrSpecBaseXFlip]                                    ; $2ad9
	ldh  [hCurrSpriteXFlipWithinCurrSpec], a                        ; $2adb

; get byte from last table
; exit big loop if ff
	ld   a, [hl]                                                    ; $2add
	cp   $ff                                                        ; $2ade
	jr   z, .showNextSpritesCheckIfMoreSpriteSpecs                  ; $2ae0

	cp   $fd                                                        ; $2ae2
	jr   nz, .dataByteNotFFhOrFDh                                   ; $2ae4

; if fd, x flip the current sprite
	ldh  a, [hCurrSpecBaseXFlip]                                    ; $2ae6
	xor  $20                                                        ; $2ae8
	ldh  [hCurrSpriteXFlipWithinCurrSpec], a                        ; $2aea
	inc  hl                                                         ; $2aec
	ld   a, [hl]                                                    ; $2aed
	jr   .setTileIndex                                              ; $2aee

.dataByteEquFEh:
; get new y/x offset
	inc  de                                                         ; $2af0
	inc  de                                                         ; $2af1
	jr   .bigLoop                                                   ; $2af2

.dataByteNotFFhOrFDh:
	cp   $fe                                                        ; $2af4
	jr   z, .dataByteEquFEh                                         ; $2af6

.setTileIndex:
	ldh  [hCurrSpriteTileIndex], a                                  ; $2af8

; spec base y in B, y offset for tile in C
	ldh  a, [hCurrSpriteSpecBaseY]                                  ; $2afa
	ld   b, a                                                       ; $2afc
	ld   a, [de]                                                    ; $2afd
	ld   c, a                                                       ; $2afe

; calculate final y from if entire thing flipped around center
	ldh  a, [hCurrSpecEntireSpecYXFlipped]                          ; $2aff
	bit  6, a                                                       ; $2b01
	jr   nz, .spriteSpecYFlipped                                    ; $2b03

; sprite spec base y + sprite spec base y offset + y offset for tile = tile Y
	ldh  a, [hCurrSpriteSpecBaseYOffset]                            ; $2b05
	add  b                                                          ; $2b07
	adc  c                                                          ; $2b08
	jr   .setSpriteY                                                ; $2b09

.spriteSpecYFlipped:
; sprite spec base Y - sprite spec base y offset - y offset for tile - 8 = tile Y
	ld   a, b                                                       ; $2b0b
	push af                                                         ; $2b0c
	ldh  a, [hCurrSpriteSpecBaseYOffset]                            ; $2b0d
	ld   b, a                                                       ; $2b0f
	pop  af                                                         ; $2b10
	sub  b                                                          ; $2b11
	sbc  c                                                          ; $2b12
	sbc  $08                                                        ; $2b13

.setSpriteY:
	ldh  [hCurrSpriteY], a                                          ; $2b15

; by default, skip to next y/x offsets, for next sprite
	ldh  a, [hCurrSpriteSpecBaseX]                                  ; $2b17
	ld   b, a                                                       ; $2b19
	inc  de                                                         ; $2b1a
	ld   a, [de]                                                    ; $2b1b
	inc  de                                                         ; $2b1c
	ld   c, a                                                       ; $2b1d

; calculate final x from if entire thing flipped around center
	ldh  a, [hCurrSpecEntireSpecYXFlipped]                          ; $2b1e
	bit  5, a                                                       ; $2b20
	jr   nz, .spriteSpecXFlipped                                    ; $2b22

; sprite spec base x + sprite spec base x offset + x offset for tile = tile X
	ldh  a, [hCurrSpriteSpecBaseXOffset]                            ; $2b24
	add  b                                                          ; $2b26
	adc  c                                                          ; $2b27
	jr   .setSpriteX                                                ; $2b28

.spriteSpecXFlipped:
; sprite spec base X - sprite spec base x offset - x offset for tile - 8 = tile X
	ld   a, b                                                       ; $2b2a
	push af                                                         ; $2b2b
	ldh  a, [hCurrSpriteSpecBaseXOffset]                            ; $2b2c
	ld   b, a                                                       ; $2b2e
	pop  af                                                         ; $2b2f
	sub  b                                                          ; $2b30
	sbc  c                                                          ; $2b31
	sbc  $08                                                        ; $2b32

.setSpriteX:
	ldh  [hCurrSpriteX], a                                          ; $2b34

; get hl from curr wOam address for sprite
	push hl                                                         ; $2b36
	ldh  a, [hCurr_wOam_SpriteAddr]                                 ; $2b37
	ld   h, a                                                       ; $2b39
	ldh  a, [hCurr_wOam_SpriteAddr+1]                               ; $2b3a
	ld   l, a                                                       ; $2b3c

; if this var set, hide sprite
	ldh  a, [hShouldHideCurrSprite]                                 ; $2b3d
	and  a                                                          ; $2b3f
	jr   z, .dontHideSprite                                         ; $2b40

; store tile Y out of screen
	ld   a, $ff                                                     ; $2b42
	jr   .setSpriteVars                                             ; $2b44

.dontHideSprite:
; store tile Y
	ldh  a, [hCurrSpriteY]                                          ; $2b46

.setSpriteVars:
	ld   [hl+], a                                                   ; $2b48

; store tile X
	ldh  a, [hCurrSpriteX]                                          ; $2b49
	ld   [hl+], a                                                   ; $2b4b

; store tile Index
	ldh  a, [hCurrSpriteTileIndex]                                  ; $2b4c
	ld   [hl+], a                                                   ; $2b4e

; todo: attr made from $94|$8b|$8a
	ldh  a, [hCurrSpriteXFlipWithinCurrSpec]                        ; $2b4f
	ld   b, a                                                       ; $2b51
	ldh  a, [hCurrSpecEntireSpecYXFlipped]                          ; $2b52
	or   b                                                          ; $2b54
	ld   b, a                                                       ; $2b55
	ldh  a, [$8a]                                                   ; $2b56
	or   b                                                          ; $2b58
	ld   [hl+], a                                                   ; $2b59

; set addr for next sprite
	ld   a, h                                                       ; $2b5a
	ldh  [hCurr_wOam_SpriteAddr], a                                 ; $2b5b
	ld   a, l                                                       ; $2b5d
	ldh  [hCurr_wOam_SpriteAddr+1], a                               ; $2b5e

	pop  hl                                                         ; $2b60
	jp   .bigLoop                                                   ; $2b61
	