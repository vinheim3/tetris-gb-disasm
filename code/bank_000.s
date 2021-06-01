; Disassembly of "OR"
; This file was created with:
; mgbdis v1.4 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

INCLUDE "includes.s"

SECTION "ROM Bank $000", ROM0[$0]

RST_00::
	jp   Begin2                                                ; $0000

ds $08-@, $00

RST_08::
	jp   Begin2                                                ; $0008

ds $28-@, $ff

SECTION "RST $28", ROM0[$28]

JumpTable::
	add  a                                                     ; $0028
	pop  hl                                                    ; $0029
	ld   e, a                                                  ; $002a
	ld   d, $00                                                ; $002b
	add  hl, de                                                ; $002d
	ld   e, [hl]                                               ; $002e
	inc  hl                                                    ; $002f
	ld   d, [hl]                                               ; $0030
	push de                                                    ; $0031
	pop  hl                                                    ; $0032
	jp   hl                                                    ; $0033

ds $40-@, $ff

VBlankInterrupt::
	jp   VBlankInterruptHandler                                ; $0040

ds $48-@, $ff

LCDCInterrupt::
	jp   StubInterruptHandler                                  ; $0048

ds $50-@, $ff

TimerOverflowInterrupt::
	jp   StubInterruptHandler                                  ; $0050

ds $58-@, $ff

SerialTransferCompleteInterrupt::
	jp   SerialInterruptHandler                                ; $0058


SerialInterruptHandler:
; preserve regs, call relevant serial func, flag that interrupt is done, then restore regs
	push af                                                    ; $005b
	push hl                                                    ; $005c
	push de                                                    ; $005d
	push bc                                                    ; $005e
	call SerialInterruptInner                                  ; $005f
	ld   a, $01                                                ; $0062
	ldh  [hSerialInterruptHandled], a                          ; $0064
	pop  bc                                                    ; $0066
	pop  de                                                    ; $0067
	pop  hl                                                    ; $0068
	pop  af                                                    ; $0069
	reti                                                       ; $006a


SerialInterruptInner:
	ldh  a, [hSerialInterruptFunc]                             ; $006b
	RST_JumpTable                                              ; $006d
	dw SerialFunc0_titleScreen
	dw SerialFunc1_InGame
	dw SerialFunc2
	dw SerialFunc3_PassiveStreamingBytes
	dw Stub_27ea

; Setting up 2 player
SerialFunc0_titleScreen:
	ldh  a, [hGameState]                                       ; $0078
	cp   GS_TITLE_SCREEN_MAIN                                  ; $007a
	jr   z, .titleScreenMain                                   ; $007c

	cp   GS_TITLE_SCREEN_INIT                                  ; $007e
	ret  z                                                     ; $0080

	ld   a, GS_TITLE_SCREEN_INIT                               ; $0081
	ldh  [hGameState], a                                       ; $0083
	ret                                                        ; $0085

.titleScreenMain:
; in title screen, passive gameboy pings this SB to let a master gb know
	ldh  a, [rSB]                                              ; $0086
	cp   SB_PASSIVES_PING_IN_TITLE_SCREEN                      ; $0088
	jr   nz, .checkIfPassive                                   ; $008a

	ld   a, MP_ROLE_MASTER                                     ; $008c
	ldh  [hMultiplayerPlayerRole], a                           ; $008e
	ld   a, SC_MASTER                                          ; $0090
	jr   .setSC                                                ; $0092

.checkIfPassive:
; this SB is sent by the master gb when pressing Start on 2 player option
; receiving GB is assigned the passive role
	cp   SB_MASTER_PRESSING_START                              ; $0094
	ret  nz                                                    ; $0096

	ld   a, MP_ROLE_PASSIVE                                    ; $0097
	ldh  [hMultiplayerPlayerRole], a                           ; $0099
	lda SC_PASSIVE                                             ; $009b

.setSC:
	ldh  [rSC], a                                              ; $009c
	ret                                                        ; $009e


SerialFunc1_InGame:
; simply get the byte the other player sent
	ldh  a, [rSB]                                              ; $009f
	ldh  [hSerialByteRead], a                                  ; $00a1
	ret                                                        ; $00a3


SerialFunc2:
; load serial byte for respective player
	ldh  a, [rSB]                                    ; $00a4: $f0 $01
	ldh  [hSerialByteRead], a                                    ; $00a6: $e0 $d0
	ldh  a, [hMultiplayerPlayerRole]                                    ; $00a8: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $00aa: $fe $29
	ret  z                                           ; $00ac: $c8

; if passive, auto-load next byte, and default the one after to $ff
	ldh  a, [hNextSerialByteToLoad]                                    ; $00ad: $f0 $cf
	ldh  [rSB], a                                    ; $00af: $e0 $01
	ld   a, $ff                                      ; $00b1: $3e $ff
	ldh  [hNextSerialByteToLoad], a                                    ; $00b3: $e0 $cf
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                                      ; $00b5: $3e $80
	ldh  [rSC], a                                    ; $00b7: $e0 $02
	ret                                              ; $00b9: $c9


SerialFunc3_PassiveStreamingBytes:
; load serial byte for respective player
	ldh  a, [rSB]                                              ; $00ba
	ldh  [hSerialByteRead], a                                  ; $00bc
	ldh  a, [hMultiplayerPlayerRole]                           ; $00be
	cp   MP_ROLE_MASTER                                        ; $00c0
	ret  z                                                     ; $00c2

; if passive, load a new byte in, wait??, then set SC bit 7
	ldh  a, [hNextSerialByteToLoad]                            ; $00c3
	ldh  [rSB], a                                              ; $00c5
	ei                                                         ; $00c7
	call SerialTransferWaitFunc                                ; $00c8
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                     ; $00cb
	ldh  [rSC], a                                              ; $00cd
	ret                                                        ; $00cf


UnusedSerialFunc_clearIntFlagsIfSerialFunc2:
	ldh  a, [hSerialInterruptFunc]                                    ; $00d0: $f0 $cd
	cp   SF_02                                         ; $00d2: $fe $02
	ret  nz                                          ; $00d4: $c0

	xor  a                                           ; $00d5: $af
	ldh  [rIF], a                                    ; $00d6: $e0 $0f
	ei                                               ; $00d8: $fb
	ret                                              ; $00d9: $c9

ds $100-@, $ff

Boot::
	nop                                                        ; $0100
	jp   Begin                                                 ; $0101

	
SECTION "Header", ROM0[$134]

	setcharmap main

HeaderTitle::
	db   "TETRIS", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	setcharmap new

HeaderNewLicenseeCode::
	db   $00, $00

HeaderSGBFlag::
	db   $00

HeaderCartridgeType::
	db   $00

HeaderROMSize::
	db   $00

HeaderRAMSize::
	db   $00

HeaderDestinationCode::
	db   $00

HeaderOldLicenseeCode::
	db   $01

HeaderMaskROMVersion::
	db   $01


SECTION "Begin", ROM0[$150]

Begin:
	jp   Begin2                                                ; $0150


UnusedGetScreenTileInHLWhileOamFree:
	call GetScreen0AddressOfPieceSquare                        ; $0153

.waitUntilVramAndOamFree:
	ldh  a, [rSTAT]                                            ; $0156
	and  STATF_LCD                                             ; $0158
	jr   nz, .waitUntilVramAndOamFree                          ; $015a

; get screen 0 tile in B
	ld   b, [hl]                                               ; $015c

.waitUntilVramAndOamFree2:
	ldh  a, [rSTAT]                                            ; $015d
	and  STATF_LCD                                             ; $015f
	jr   nz, .waitUntilVramAndOamFree2                         ; $0161

; get the same tile in A, and check if still same as B
	ld   a, [hl]                                               ; $0163
	and  b                                                     ; $0164
	ret                                                        ; $0165


; in: DE - a score value (category * count)
; in: HL - 3 score bytes
AddScoreValueDEontoBaseScoreHL:
; add base score with additional score
	ld   a, e                                                  ; $0166
	add  [hl]                                                  ; $0167
	daa                                                        ; $0168
	ld   [hl+], a                                              ; $0169

	ld   a, d                                                  ; $016a
	adc  [hl]                                                  ; $016b
	daa                                                        ; $016c
	ld   [hl+], a                                              ; $016d

	ld   a, $00                                                ; $016e
	adc  [hl]                                                  ; $0170
	daa                                                        ; $0171
	ld   [hl], a                                               ; $0172

; always set, so we display a score
	ld   a, $01                                                ; $0173
	ldh  [hFoundDisplayableScoreDigit], a                      ; $0175
	ret  nc                                                    ; $0177

; if carry found in last byte, max score is 999,999
	ld   a, $99                                                ; $0178
	ld   [hl-], a                                              ; $017a
	ld   [hl-], a                                              ; $017b
	ld   [hl], a                                               ; $017c
	ret                                                        ; $017d


VBlankInterruptHandler:
; preserve regs
	push af                                                    ; $017e
	push bc                                                    ; $017f
	push de                                                    ; $0180
	push hl                                                    ; $0181

; if master should transfer
	ldh  a, [hMasterShouldSerialTransferInVBlank]              ; $0182
	and  a                                                     ; $0184
	jr   z, .afterMasterTransfer                               ; $0185

	ldh  a, [hMultiplayerPlayerRole]                           ; $0187
	cp   MP_ROLE_MASTER                                        ; $0189
	jr   nz, .afterMasterTransfer                              ; $018b

; load the pending byte and initiate transfer
	xor  a                                                     ; $018d
	ldh  [hMasterShouldSerialTransferInVBlank], a              ; $018e
	ldh  a, [hNextSerialByteToLoad]                            ; $0190
	ldh  [rSB], a                                              ; $0192
	ld   hl, rSC                                               ; $0194
	ld   [hl], SC_REQUEST_TRANSFER|SC_MASTER                   ; $0197

.afterMasterTransfer:
	call FlashCompletedTetrisRows                              ; $0199
	call CopyRamBufferRow0ToVram                               ; $019c
	call CopyRamBufferRow1ToVram                               ; $019f
	call CopyRamBufferRow2ToVram                               ; $01a2
	call CopyRamBufferRow3ToVram                               ; $01a5
	call CopyRamBufferRow4ToVram                               ; $01a8
	call CopyRamBufferRow5ToVram                               ; $01ab
	call CopyRamBufferRow6ToVram                               ; $01ae
	call CopyRamBufferRow7ToVram                               ; $01b1
	call CopyRamBufferRow8ToVram                               ; $01b4
	call CopyRamBufferRow9ToVram                               ; $01b7
	call CopyRamBufferRow10ToVram                              ; $01ba
	call CopyRamBufferRow11ToVram                              ; $01bd
	call CopyRamBufferRow12ToVram                              ; $01c0
	call CopyRamBufferRow13ToVram                              ; $01c3
	call CopyRamBufferRow14ToVram                              ; $01c6
	call CopyRamBufferRow15ToVram                              ; $01c9
	call CopyRamBufferRow16ToVram                              ; $01cc
	call CopyRamBufferRow17ToVram                              ; $01cf
	call ProcessScoreUpdatesAfterBTypeLevelDone                ; $01d2
	call hOamDmaFunction                                       ; $01d5
	call DisplayHighScoresAndNamesForLevel                     ; $01d8

; if just added drops to score..
	ld   a, [wATypeJustAddedDropsToScore]                      ; $01db
	and  a                                                     ; $01de
	jr   z, .end                                               ; $01df

; and all rows are processed
	ldh  a, [hPieceFallingState]                               ; $01e1
	cp   FALLING_PIECE_ALL_ROWS_PROCESSED_AFTER_DROP           ; $01e3
	jr   nz, .end                                              ; $01e5

; show score on screen 0 (if somehow forced), and screen 1
	ld   hl, _SCRN0+$6d                                        ; $01e7
	call DisplayGameATypeScoreIfInGameAndForced                ; $01ea

	ld   a, $01                                                ; $01ed
	ldh  [hFoundDisplayableScoreDigit], a                      ; $01ef
	ld   hl, _SCRN1+$6d                                        ; $01f1
	call DisplayGameATypeScoreIfInGameAndForced                ; $01f4

; clear that we've just added drops to score
	xor  a                                                     ; $01f7
	ld   [wATypeJustAddedDropsToScore], a                      ; $01f8

.end:
; inc an unused counter
	ld   hl, hVBlankInterruptCounter                           ; $01fb
	inc  [hl]                                                  ; $01fe

; clear scroll regs, and set interrupt as handled
	xor  a                                                     ; $01ff
	ldh  [rSCX], a                                             ; $0200
	ldh  [rSCY], a                                             ; $0202

	inc  a                                                     ; $0204
	ldh  [hVBlankInterruptFinished], a                         ; $0205

; restore regs
	pop  hl                                                    ; $0207
	pop  de                                                    ; $0208
	pop  bc                                                    ; $0209
	pop  af                                                    ; $020a
	reti                                                       ; $020b


Begin2:
	xor  a                                                     ; $020c
	ld   hl, $dfff                                             ; $020d

; clear $d000-$dfff
	ld   c, $10                                                ; $0210
	ld   b, $00                                                ; $0212

.clear2ndWram:
	ld   [hl-], a                                              ; $0214
	dec  b                                                     ; $0215
	jr   nz, .clear2ndWram                                     ; $0216

	dec  c                                                     ; $0218
	jr   nz, .clear2ndWram                                     ; $0219

Reset:
; allow vblank and not serial
	ld   a, IEF_VBLANK                                         ; $021b
	di                                                         ; $021d
	ldh  [rIF], a                                              ; $021e
	ldh  [rIE], a                                              ; $0220

; clear hw regs
	xor  a                                                     ; $0222
	ldh  [rSCY], a                                             ; $0223
	ldh  [rSCX], a                                             ; $0225
	ldh  [hUnusedFFA4], a                                      ; $0227
	ldh  [rSTAT], a                                            ; $0229
	ldh  [rSB], a                                              ; $022b
	ldh  [rSC], a                                              ; $022d

; turn on LCD, and wait until in vblank area (specifically line $94)
	ld   a, LCDCF_ON                                           ; $022f
	ldh  [rLCDC], a                                            ; $0231

.waitUntilVBlank:
	ldh  a, [rLY]                                              ; $0233
	cp   $94                                                   ; $0235
	jr   nz, .waitUntilVBlank                                  ; $0237

; turn off lcd again
	ld   a, LCDCF_OFF|LCDCF_OBJON|LCDCF_BGON                   ; $0239
	ldh  [rLCDC], a                                            ; $023b

; standard palettes
	ld   a, %11100100                                          ; $023d
	ldh  [rBGP], a                                             ; $023f
	ldh  [rOBP0], a                                            ; $0241

; palette with white as non-transparent, eg for jumping dancers
	ld   a, %11000100                                          ; $0243
	ldh  [rOBP1], a                                            ; $0245

; all sound on
	ld   hl, rAUDENA                                           ; $0247
	ld   a, $80                                                ; $024a
	ld   [hl-], a                                              ; $024c

; channels outputted to all sound S01 and S02
	ld   a, $ff                                                ; $024d
	ld   [hl-], a                                              ; $024f

; vol max without setting vin
	ld   [hl], $77                                             ; $0250

; set rom bank for some reason, and set SP
	ld   a, $01                                                ; $0252
	ld   [rROMB0], a                                           ; $0254
	ld   sp, wStackTop                                         ; $0257

; clear last page of wram
	xor  a                                                     ; $025a
	ld   hl, $dfff                                             ; $025b
	ld   b, $00                                                ; $025e

.clearLastPage:
	ld   [hl-], a                                              ; $0260
	dec  b                                                     ; $0261
	jr   nz, .clearLastPage                                    ; $0262

; clear 1st bank of wram
	ld   hl, $cfff                                             ; $0264
	ld   c, $10                                                ; $0267
	ld   b, $00                                                ; $0269

.clear1stWram:
	ld   [hl-], a                                              ; $026b
	dec  b                                                     ; $026c
	jr   nz, .clear1stWram                                     ; $026d

	dec  c                                                     ; $026f
	jr   nz, .clear1stWram                                     ; $0270

; clear all vram
	ld   hl, $9fff                                             ; $0272
	ld   c, $20                                                ; $0275
	xor  a                                                     ; $0277
	ld   b, $00                                                ; $0278

.clearVram:
	ld   [hl-], a                                              ; $027a
	dec  b                                                     ; $027b
	jr   nz, .clearVram                                        ; $027c

	dec  c                                                     ; $027e
	jr   nz, .clearVram                                        ; $027f

; clear oam, and some unusable space
	ld   hl, $feff                                             ; $0281
	ld   b, $00                                                ; $0284

.clearOam:
	ld   [hl-], a                                              ; $0286
	dec  b                                                     ; $0287
	jr   nz, .clearOam                                         ; $0288

; clear all hram, but also $ff7f
	ld   hl, $fffe                                             ; $028a
	ld   b, $80                                                ; $028d

.clearHram:
	ld   [hl-], a                                              ; $028f
	dec  b                                                     ; $0290
	jr   nz, .clearHram                                        ; $0291

; copy OAM DMA function, plus 2 extra bytes
	ld   c, LOW(hOamDmaFunction)                               ; $0293
	ld   b, hOamDmaFunction.end-hOamDmaFunction+2              ; $0295
	ld   hl, OamDmaFunction                                    ; $0297

.copyOamDmaFunc:
	ld   a, [hl+]                                              ; $029a
	ldh  [c], a                                                ; $029b
	inc  c                                                     ; $029c
	dec  b                                                     ; $029d
	jr   nz, .copyOamDmaFunc                                   ; $029e

; clear tilemap and sound
	call FillScreen0FromHLdownWithEmptyTile                    ; $02a0
	call ThunkInitSound                                        ; $02a3

; enable both interrupts now
	ld   a, IEF_SERIAL|IEF_VBLANK                              ; $02a6
	ldh  [rIE], a                                              ; $02a8

; set defaults for game and music type
	ld   a, GAME_TYPE_A_TYPE                                   ; $02aa
	ldh  [hGameType], a                                        ; $02ac
	ld   a, MUSIC_TYPE_A_TYPE                                  ; $02ae
	ldh  [hMusicType], a                                       ; $02b0

; set starting game state
	ld   a, GS_COPYRIGHT_DISPLAY                               ; $02b2
	ldh  [hGameState], a                                       ; $02b4

; turn on LCD
	ld   a, LCDCF_ON                                           ; $02b6
	ldh  [rLCDC], a                                            ; $02b8

; clear some hw regs
	ei                                                         ; $02ba
	xor  a                                                     ; $02bb
	ldh  [rIF], a                                              ; $02bc
	ldh  [rWY], a                                              ; $02be
	ldh  [rWX], a                                              ; $02c0
	ldh  [rTMA], a                                             ; $02c2

MainLoop:
; main game loop updates
	call PollInput                                             ; $02c4
	call ProcessGameState                                      ; $02c7
	call ThunkUpdateSound                                      ; $02ca

; standard soft reset
	ldh  a, [hButtonsHeld]                                     ; $02cd
	and  PADF_START|PADF_SELECT|PADF_B|PADF_A                  ; $02cf
	cp   PADF_START|PADF_SELECT|PADF_B|PADF_A                  ; $02d1
	jp   z, Reset                                              ; $02d3

; decrease 2 timers
	ld   hl, hTimers                                           ; $02d6
	ld   b, hTimerEnd-hTimers                                  ; $02d9

.nextTimer:
	ld   a, [hl]                                               ; $02db
	and  a                                                     ; $02dc
	jr   z, .toNextTimer                                       ; $02dd

	dec  [hl]                                                  ; $02df

.toNextTimer:
	inc  l                                                     ; $02e0
	dec  b                                                     ; $02e1
	jr   nz, .nextTimer                                        ; $02e2

; always make sure serial interrupt is enabled when 2 players set
	ldh  a, [hIs2Player]                                       ; $02e4
	and  a                                                     ; $02e6
	jr   z, .waitUntilVBlankIntDone                            ; $02e7

; enable standard interrupts
	ld   a, IEF_SERIAL|IEF_VBLANK                              ; $02e9
	ldh  [rIE], a                                              ; $02eb

.waitUntilVBlankIntDone:
	ldh  a, [hVBlankInterruptFinished]                         ; $02ed
	and  a                                                     ; $02ef
	jr   z, .waitUntilVBlankIntDone                            ; $02f0

; do main loop, then wait for vblank int done, before looping again
	xor  a                                                     ; $02f2
	ldh  [hVBlankInterruptFinished], a                         ; $02f3
	jp   MainLoop                                              ; $02f5


ProcessGameState:
	ldh  a, [hGameState]                                       ; $02f8
	RST_JumpTable                                              ; $02fa
	dw GameState00_InGameMain
	dw GameState01_GameOverInit
	dw GameState02_ShuttleSceneLiftoff
	dw GameState03_ShuttleSceneShootFire
	dw GameState04_LevelEndedMain
	dw GameState05_BTypeLevelFinished
	dw GameState06_TitleScreenInit
	dw GameState07_TitleScreenMain
	dw GameState08_GameMusicTypeInit
	dw Stub_148c
	dw GameState0a_InGameInit
	dw GameState0b_ScoreUpdateAfterBTypeLevelDone
	dw GameState0c_UnusedPreShuttleLiftOff
	dw GameState0d_GameOverScreenClearing
	dw GameState0e_GameTypeMain
	dw GameState0f_MusicTypeMain
	dw GameState10_ATypeSelectionInit
	dw GameState11_ATypeSelectionMain
	dw GameState12_BTypeSelectionInit
	dw GameState13_BTypeSelectionMain
	dw GameState14_BTypeHighMain
	dw GameState15_EnteringHighScore
	dw GameState16_MarioLuigiScreenInit
	dw GameState17_MarioLuigiScreenMain
	dw GameState18_2PlayerInGameInit
	dw GameState19
	dw GameState1a_2PlayerInGameMain
	dw GameState1b
	dw GameState1c
	dw GameState1d_2PlayerWinnerInit
	dw GameState1e_2PlayerLoserInit
	dw GameState1f_Post2PlayerResults
	dw GameState20_2PlayerWinnerMain
	dw GameState21_2PlayerLoserMain
	dw GameState22_DancersInit
	dw GameState23_DancersMain
	dw GameState24_CopyrightDisplay
	dw GameState25_CopyrightWaiting
	dw GameState26_ShuttleSceneInit
	dw GameState27_ShuttleSceneShowClouds
	dw GameState28_ShuttleSceneFlashCloudsGetBigger
	dw GameState29_ShuttleSceneFlashBigCloudsRemovePlatforms
	dw GameState2a_2PlayerGameMusicTypeInit
	dw GameState2b_2PlayerGameMusicTypeMain
	dw GameState2c_ShuttleSceneShowCongratulations
	dw GameState2d_CongratsWaitingBeforeBTypeScore
	dw GameState2e_RocketSceneInit
	dw GameState2f_RocketSceneShowClouds
	dw GameState30_PoweringUp
	dw GameState31_RocketSceneLiftOff
	dw GameState32_RocketSceneShootFire
	dw GameState33_RocketSceneEnd
	dw GameState34_PreRocketSceneWait
	dw GameState35_CopyrightCanContinue
	dw Stub_27ea
	

GameState24_CopyrightDisplay:
	call TurnOffLCD                                            ; $0369

	call CopyAsciiAndTitleScreenTileData                       ; $036c
	ld   de, Layout_Copyright                                  ; $036f
	call CopyLayoutToScreen0                                   ; $0372
	call Clear_wOam                                            ; $0375

; set demo pieces
	ld   hl, wDemoPieces                                       ; $0378
	ld   de, DemoPieces                                        ; $037b

.copyLoop:
	ld   a, [de]                                               ; $037e
	ld   [hl+], a                                              ; $037f
	inc  de                                                    ; $0380
	ld   a, h                                                  ; $0381
	cp   HIGH(wDemoPieces.end)                                 ; $0382
	jr   nz, .copyLoop                                         ; $0384

; show all, with bg data at $8000, displayed at $9800
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $0386
	ldh  [rLCDC], a                                            ; $0388

; timer until title screen
	ld   a, $fa                                                ; $038a
	ldh  [hTimer1], a                                          ; $038c

; set next game state
	ld   a, GS_COPYRIGHT_WAITING                               ; $038e
	ldh  [hGameState], a                                       ; $0390
	ret                                                        ; $0392


GameState25_CopyrightWaiting:
; wait for timer, set a new one, then go to next state
	ldh  a, [hTimer1]                                          ; $0393
	and  a                                                     ; $0395
	ret  nz                                                    ; $0396

	ld   a, $fa                                                ; $0397
	ldh  [hTimer1], a                                          ; $0399
	ld   a, GS_COPYRIGHT_CAN_CONTINUE                          ; $039b
	ldh  [hGameState], a                                       ; $039d
	ret                                                        ; $039f


GameState35_CopyrightCanContinue:
; go to next game state, when timer is done, or a button is pressed
	ldh  a, [hButtonsPressed]                                  ; $03a0
	and  a                                                     ; $03a2
	jr   nz, .setNewState                                      ; $03a3

	ldh  a, [hTimer1]                                          ; $03a5
	and  a                                                     ; $03a7
	ret  nz                                                    ; $03a8

.setNewState:
	ld   a, GS_TITLE_SCREEN_INIT                               ; $03a9
	ldh  [hGameState], a                                       ; $03ab
	ret                                                        ; $03ad


GameState06_TitleScreenInit:
	call TurnOffLCD                               ; $03ae: $cd $20 $28
	xor  a                                           ; $03b1: $af
	ldh  [$e9], a                                    ; $03b2: $e0 $e9
	ldh  [hPieceFallingState], a                               ; $03b4
	ldh  [hTetrisFlashCount], a                                ; $03b6
	ldh  [hPieceCollisionDetected], a                          ; $03b8
	ldh  [h1stHighScoreHighestByteForLevel], a                 ; $03ba
	ldh  [hNumLinesCompletedBCD+1], a                          ; $03bc
	ldh  [hRowsShiftingDownState], a                           ; $03be
	ldh  [hMustEnterHighScore], a                              ; $03c0

; clear some in-game vars and load gfx
	call ClearPointersToCompletedTetrisRows                    ; $03c2
	call ClearScoreCategoryVarsAndTotalScore                   ; $03c5
	call CopyAsciiAndTitleScreenTileData                       ; $03c8

; clear screen buffer
	ld   hl, wGameScreenBuffer                                 ; $03cb

.clearScreenBuffer:
	ld   a, TILE_EMPTY                                         ; $03ce
	ld   [hl+], a                                              ; $03d0
	ld   a, h                                                  ; $03d1
	cp   HIGH(wGameScreenBuffer.end)                           ; $03d2
	jr   nz, .clearScreenBuffer                                ; $03d4

; black lines where game bricks would be
	ld   hl, wGameScreenBuffer+1                               ; $03d6
	call DisplayBlackColumnFromHLdown                          ; $03d9
	ld   hl, wGameScreenBuffer+$c                              ; $03dc
	call DisplayBlackColumnFromHLdown                          ; $03df

; black row under screen
	ld   hl, wGameScreenBuffer+$241                            ; $03e2
	ld   b, $0c                                                ; $03e5
	ld   a, TILE_BLACK                                         ; $03e7

.displayBlackRow:
	ld   [hl+], a                                              ; $03e9
	dec  b                                                     ; $03ea
	jr   nz, .displayBlackRow                                  ; $03eb

; set display and oam
	ld   de, Layout_TitleScreen                                ; $03ed
	call CopyLayoutToScreen0                                   ; $03f0
	call Clear_wOam                                            ; $03f3

; cursor OAM
	ld   hl, wOam                                              ; $03f6
	ld   [hl], $80                                             ; $03f9
	inc  l                                                     ; $03fb
	ld   [hl], $10                                             ; $03fc
	inc  l                                                     ; $03fe
	ld   [hl], TILE_CURSOR                                     ; $03ff

; start playing sound
	ld   a, MUS_TITLE_SCREEN                                   ; $0401
	ld   [wSongToStart], a                                     ; $0403

; set LCD state, game state and timer
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $0406
	ldh  [rLCDC], a                                            ; $0408
	ld   a, GS_TITLE_SCREEN_MAIN                               ; $040a
	ldh  [hGameState], a                                       ; $040c
	ld   a, $7d                                                ; $040e
	ldh  [hTimer1], a                                          ; $0410

; if demo had played, shorter timer before next demo
	ld   a, $04                                                ; $0412
	ldh  [hTimerMultiplier], a                                 ; $0414

	ldh  a, [hPrevOrCurrDemoPlayed]                            ; $0416
	and  a                                                     ; $0418
	ret  nz                                                    ; $0419

; else set a longer time
	ld   a, $13                                                ; $041a
	ldh  [hTimerMultiplier], a                                 ; $041c
	ret                                                        ; $041e


PlayDemo:
	ld   a, GAME_TYPE_A_TYPE                                      ; $041f: $3e $37
	ldh  [hGameType], a                                    ; $0421: $e0 $c0

	ld   a, $09                                      ; $0423: $3e $09
	ldh  [hATypeLevel], a                                    ; $0425: $e0 $c2
	xor  a                                           ; $0427: $af
	ldh  [hIs2Player], a                                    ; $0428: $e0 $c5
	ldh  [hLowByteOfCurrDemoStepAddress], a                                    ; $042a: $e0 $b0
	ldh  [$ed], a                                    ; $042c: $e0 $ed
	ldh  [$ea], a                                    ; $042e: $e0 $ea
	ld   a, $62                                      ; $0430: $3e $62
	ldh  [$eb], a                                    ; $0432: $e0 $eb
	ld   a, $b0                                      ; $0434: $3e $b0
	ldh  [$ec], a                                    ; $0436: $e0 $ec

; flip between demo 1 and 2
	ldh  a, [hPrevOrCurrDemoPlayed]                                    ; $0438: $f0 $e4
	cp   $02                                         ; $043a: $fe $02
	ld   a, $02                                      ; $043c: $3e $02
	jr   nz, .setDemoPlayed                             ; $043e: $20 $1a

	ld   a, GAME_TYPE_B_TYPE                                      ; $0440: $3e $77
	ldh  [hGameType], a                                    ; $0442: $e0 $c0
	ld   a, $09                                      ; $0444: $3e $09
	ldh  [hBTypeLevel], a                                    ; $0446: $e0 $c3
	ld   a, $02                                      ; $0448: $3e $02
	ldh  [hBTypeHigh], a                                    ; $044a: $e0 $c4
	ld   a, $63                                      ; $044c: $3e $63
	ldh  [$eb], a                                    ; $044e: $e0 $eb
	ld   a, $b0                                      ; $0450: $3e $b0
	ldh  [$ec], a                                    ; $0452: $e0 $ec
	ld   a, $11                                      ; $0454: $3e $11
	ldh  [hLowByteOfCurrDemoStepAddress], a                                    ; $0456: $e0 $b0
	ld   a, $01                                      ; $0458: $3e $01

.setDemoPlayed:
	ldh  [hPrevOrCurrDemoPlayed], a                            ; $045a

; set game state
	ld   a, GS_IN_GAME_INIT                                    ; $045c
	ldh  [hGameState], a                                       ; $045e

; load screen while lcd off
	call TurnOffLCD                                            ; $0460
	call LoadAsciiAndMenuScreenGfx                             ; $0463
	ld   de, Layout_GameMusicTypeScreen                        ; $0466
	call CopyLayoutToScreen0                                   ; $0469
	call Clear_wOam                                            ; $046c

; turn on LCD
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $046f
	ldh  [rLCDC], a                                            ; $0471
	ret                                                        ; $0473


; unused
	ld   a, $ff                                      ; $0474: $3e $ff
	ldh  [$e9], a                                    ; $0476: $e0 $e9
	ret                                              ; $0478: $c9


GameState07_TitleScreenMain:
; timer multiplier * $7d until a demo plays
	ldh  a, [hTimer1]                                          ; $0479
	and  a                                                     ; $047b
	jr   nz, .afterTimerCheck                                  ; $047c

	ld   hl, hTimerMultiplier                                  ; $047e
	dec  [hl]                                                  ; $0481
	jr   z, PlayDemo                                           ; $0482

	ld   a, $7d                                                ; $0484
	ldh  [hTimer1], a                                          ; $0486

.afterTimerCheck:
; send $55 to indicate to a master GB that we're active
	call SerialTransferWaitFunc                                ; $0488
	ld   a, SB_PASSIVES_PING_IN_TITLE_SCREEN                   ; $048b
	ldh  [rSB], a                                              ; $048d
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                     ; $048f
	ldh  [rSC], a                                              ; $0491

; if a byte was processed..
	ldh  a, [hSerialInterruptHandled]                          ; $0493
	and  a                                                     ; $0495
	jr   z, .checkButtonsPressed                               ; $0496

; and we've been assigned a role, go to multiplayer state
; ie auto-start for passive GB
	ldh  a, [hMultiplayerPlayerRole]                           ; $0498
	and  a                                                     ; $049a
	jr   nz, .setGameStateTo2ah                                ; $049b

; otherwise state is invalid
	xor  a                                                     ; $049d
	ldh  [hSerialInterruptHandled], a                          ; $049e
	jr   .multiplayerInvalid                                   ; $04a0

.checkButtonsPressed:
; buttons pressed in B, is 2 player in A
	ldh  a, [hButtonsPressed]                                  ; $04a2
	ld   b, a                                                  ; $04a4
	ldh  a, [hIs2Player]                                       ; $04a5

; select flips between 2 options, left/right does as intended
	bit  PADB_SELECT, b                                        ; $04a7
	jr   nz, .flipNumPlayersOption                             ; $04a9

	bit  PADB_RIGHT, b                                         ; $04ab
	jr   nz, .pressedRight                                     ; $04ad

	bit  PADB_LEFT, b                                          ; $04af
	jr   nz, .pressedLeft                                      ; $04b1

; start to select an option, other buttons are invalid
	bit  PADB_START, b                                         ; $04b3
	ret  z                                                     ; $04b5

; if 1 player, set 1player state in A
	and  a                                                     ; $04b6
	ld   a, GS_GAME_MUSIC_TYPE_INIT                            ; $04b7
	jr   z, .is1Player                                         ; $04b9

; 2-player start
	ld   a, b                                                  ; $04bb
	cp   PADF_START                                            ; $04bc
	ret  nz                                                    ; $04be

; if we're still master, continue
	ldh  a, [hMultiplayerPlayerRole]                           ; $04bf
	cp   MP_ROLE_MASTER                                        ; $04c1
	jr   z, .setGameStateTo2ah                                 ; $04c3

; if 1st gb to press start, send a start request and wait for a reponse
	ld   a, SB_MASTER_PRESSING_START                           ; $04c5
	ldh  [rSB], a                                              ; $04c7
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                      ; $04c9
	ldh  [rSC], a                                              ; $04cb

.waitUntilSerialIntHandled:
	ldh  a, [hSerialInterruptHandled]                          ; $04cd
	and  a                                                     ; $04cf
	jr   z, .waitUntilSerialIntHandled                         ; $04d0

; if not assigned a role, no listening gb
	ldh  a, [hMultiplayerPlayerRole]                           ; $04d2
	and  a                                                     ; $04d4
	jr   z, .multiplayerInvalid                                ; $04d5

.setGameStateTo2ah:
	ld   a, GS_2PLAYER_GAME_MUSIC_TYPE_INIT                    ; $04d7

.setGameState:
	ldh  [hGameState], a                                       ; $04d9

; clear main timer, level and b type high, and demo played
	xor  a                                                     ; $04db
	ldh  [hTimer1], a                                          ; $04dc
	ldh  [hATypeLevel], a                                      ; $04de
	ldh  [hBTypeLevel], a                                      ; $04e0
	ldh  [hBTypeHigh], a                                       ; $04e2
	ldh  [hPrevOrCurrDemoPlayed], a                            ; $04e4
	ret                                                        ; $04e6

.is1Player:
	push af                                                    ; $04e7
; if down held while on title screen, set hard mode
	ldh  a, [hButtonsHeld]                                     ; $04e8
	bit  PADB_DOWN, a                                          ; $04ea
	jr   z, .afterDownCheck                                    ; $04ec

	ldh  [hIsHardMode], a                                      ; $04ee

.afterDownCheck:
	pop  af                                                    ; $04f0
	jr   .setGameState                                         ; $04f1

.flipNumPlayersOption:
	xor  $01                                                   ; $04f3

.setNumPlayersOpt:
	ldh  [hIs2Player], a                                       ; $04f5

; set cursor X based on if 1 player or 2 players
	and  a                                                     ; $04f7
	ld   a, $10                                                ; $04f8
	jr   z, .setCursorX                                        ; $04fa

	ld   a, $60                                                ; $04fc

.setCursorX:
	ld   [wOam+OAM_X], a                                       ; $04fe
	ret                                                        ; $0501

.pressedRight:
; ret if already 2 player
	and  a                                                     ; $0502
	ret  nz                                                    ; $0503

	xor  a                                                     ; $0504
	jr   .flipNumPlayersOption                                 ; $0505

.pressedLeft:
; ret if already 1 player
	and  a                                                     ; $0507
	ret  z                                                     ; $0508

.multiplayerInvalid:
; set to 1 player
	xor  a                                                     ; $0509
	jr   .setNumPlayersOpt                                     ; $050a


todo_demoRelated_050c:
	ldh  a, [hPrevOrCurrDemoPlayed]                                    ; $050c: $f0 $e4
	and  a                                           ; $050e: $a7
	ret  z                                           ; $050f: $c8

; demo is being played
	call SerialTransferWaitFunc                               ; $0510: $cd $98 $0a
	xor  a                                           ; $0513: $af
	ldh  [rSB], a                                    ; $0514: $e0 $01
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                                      ; $0516: $3e $80
	ldh  [rSC], a                                    ; $0518: $e0 $02

;
	ldh  a, [hButtonsPressed]                                    ; $051a: $f0 $81
	bit  PADB_START, a                                        ; $051c: $cb $5f
	jr   z, .startNotPressed                              ; $051e: $28 $0d

; start pressed
	ld   a, SB_ENDED_GAME_DEMO                                      ; $0520: $3e $33
	ldh  [rSB], a                                    ; $0522: $e0 $01
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                                      ; $0524: $3e $81
	ldh  [rSC], a                                    ; $0526: $e0 $02
	ld   a, GS_TITLE_SCREEN_INIT                                      ; $0528: $3e $06
	ldh  [hGameState], a                                    ; $052a: $e0 $e1
	ret                                              ; $052c: $c9

.startNotPressed:
	ld   hl, hLowByteOfCurrDemoStepAddress                                   ; $052d: $21 $b0 $ff
	ldh  a, [hPrevOrCurrDemoPlayed]                                    ; $0530: $f0 $e4
	cp   $02                                         ; $0532: $fe $02
	ld   b, $10                                      ; $0534: $06 $10
	jr   z, jr_000_053a                              ; $0536: $28 $02

	ld   b, $1d                                      ; $0538: $06 $1d

jr_000_053a:
	ld   a, [hl]                                     ; $053a: $7e
	cp   b                                           ; $053b: $b8
	ret  nz                                          ; $053c: $c0

	ld   a, GS_TITLE_SCREEN_INIT                                      ; $053d: $3e $06
	ldh  [hGameState], a                                    ; $053f: $e0 $e1
	ret                                              ; $0541: $c9


todo_demoRelated_0542:
	ldh  a, [hPrevOrCurrDemoPlayed]                                    ; $0542: $f0 $e4
	and  a                                           ; $0544: $a7
	ret  z                                           ; $0545: $c8

; demo played
	ldh  a, [$e9]                                    ; $0546: $f0 $e9
	cp   $ff                                         ; $0548: $fe $ff
	ret  z                                           ; $054a: $c8

	ldh  a, [$ea]                                    ; $054b: $f0 $ea
	and  a                                           ; $054d: $a7
	jr   z, jr_000_0555                              ; $054e: $28 $05

	dec  a                                           ; $0550: $3d
	ldh  [$ea], a                                    ; $0551: $e0 $ea
	jr   jr_000_0571                                 ; $0553: $18 $1c

jr_000_0555:
	ldh  a, [$eb]                                    ; $0555: $f0 $eb
	ld   h, a                                        ; $0557: $67
	ldh  a, [$ec]                                    ; $0558: $f0 $ec
	ld   l, a                                        ; $055a: $6f
	ld   a, [hl+]                                    ; $055b: $2a
	ld   b, a                                        ; $055c: $47
	ldh  a, [$ed]                                    ; $055d: $f0 $ed
	xor  b                                           ; $055f: $a8
	and  b                                           ; $0560: $a0
	ldh  [hButtonsPressed], a                                    ; $0561: $e0 $81
	ld   a, b                                        ; $0563: $78
	ldh  [$ed], a                                    ; $0564: $e0 $ed
	ld   a, [hl+]                                    ; $0566: $2a
	ldh  [$ea], a                                    ; $0567: $e0 $ea
	ld   a, h                                        ; $0569: $7c
	ldh  [$eb], a                                    ; $056a: $e0 $eb
	ld   a, l                                        ; $056c: $7d
	ldh  [$ec], a                                    ; $056d: $e0 $ec
	jr   jr_000_0574                                 ; $056f: $18 $03

jr_000_0571:
	xor  a                                           ; $0571: $af
	ldh  [hButtonsPressed], a                                    ; $0572: $e0 $81

jr_000_0574:
	ldh  a, [hButtonsHeld]                                    ; $0574: $f0 $80
	ldh  [$ee], a                                    ; $0576: $e0 $ee
	ldh  a, [$ed]                                    ; $0578: $f0 $ed
	ldh  [hButtonsHeld], a                                    ; $057a: $e0 $80
	ret                                              ; $057c: $c9


	xor  a                                           ; $057d: $af
	ldh  [$ed], a                                    ; $057e: $e0 $ed
	jr   jr_000_0571                                 ; $0580: $18 $ef

	ret                                              ; $0582: $c9


todo_demoRelated_0583:
	ldh  a, [hPrevOrCurrDemoPlayed]                                    ; $0583: $f0 $e4
	and  a                                           ; $0585: $a7
	ret  z                                           ; $0586: $c8

; demo played
	ldh  a, [$e9]                                    ; $0587: $f0 $e9
	cp   $ff                                         ; $0589: $fe $ff
	ret  nz                                          ; $058b: $c0

	ldh  a, [hButtonsHeld]                                    ; $058c: $f0 $80
	ld   b, a                                        ; $058e: $47
	ldh  a, [$ed]                                    ; $058f: $f0 $ed
	cp   b                                           ; $0591: $b8
	jr   z, jr_000_05ad                              ; $0592: $28 $19

	ldh  a, [$eb]                                    ; $0594: $f0 $eb
	ld   h, a                                        ; $0596: $67
	ldh  a, [$ec]                                    ; $0597: $f0 $ec
	ld   l, a                                        ; $0599: $6f
	ldh  a, [$ed]                                    ; $059a: $f0 $ed
	ld   [hl+], a                                    ; $059c: $22
	ldh  a, [$ea]                                    ; $059d: $f0 $ea
	ld   [hl+], a                                    ; $059f: $22
	ld   a, h                                        ; $05a0: $7c
	ldh  [$eb], a                                    ; $05a1: $e0 $eb
	ld   a, l                                        ; $05a3: $7d
	ldh  [$ec], a                                    ; $05a4: $e0 $ec
	ld   a, b                                        ; $05a6: $78
	ldh  [$ed], a                                    ; $05a7: $e0 $ed
	xor  a                                           ; $05a9: $af
	ldh  [$ea], a                                    ; $05aa: $e0 $ea
	ret                                              ; $05ac: $c9


jr_000_05ad:
	ldh  a, [$ea]                                    ; $05ad: $f0 $ea
	inc  a                                           ; $05af: $3c
	ldh  [$ea], a                                    ; $05b0: $e0 $ea
	ret                                              ; $05b2: $c9


todo_demoRelated_05b3:
	ldh  a, [hPrevOrCurrDemoPlayed]                                    ; $05b3: $f0 $e4
	and  a                                           ; $05b5: $a7
	ret  z                                           ; $05b6: $c8

; demo played
	ldh  a, [$e9]                                    ; $05b7: $f0 $e9
	and  a                                           ; $05b9: $a7
	ret  nz                                          ; $05ba: $c0

	ldh  a, [$ee]                                    ; $05bb: $f0 $ee
	ldh  [hButtonsHeld], a                                    ; $05bd: $e0 $80
	ret                                              ; $05bf: $c9


GameState2a_passive:
; bit cleared on transfer finished
	ld   hl, rSC                                               ; $05c0
	set  7, [hl]                                               ; $05c3
	jr   GameState2a_2PlayerGameMusicTypeInit.cont             ; $05c5


GameState2a_2PlayerGameMusicTypeInit:
; have passive stream pings, and master controls
	ld   a, SF_PASSIVE_STREAMING_BYTES                         ; $05c7
	ldh  [hSerialInterruptFunc], a                             ; $05c9

; set SC bit 7 above if passive
	ldh  a, [hMultiplayerPlayerRole]                           ; $05cb
	cp   MP_ROLE_MASTER                                        ; $05cd
	jr   nz, GameState2a_passive                               ; $05cf

.cont:
; init screen, but hide the A type/ B type choice as not relevant for 1 player
	call GameMusicTypeInitWithoutDisablingSerialRegs           ; $05d1
	ld   a, SPRITE_SPEC_HIDDEN                                 ; $05d4
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $05d6
	call Copy2SpriteSpecsToShadowOam                           ; $05d9

;
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $05dc: $e0 $ce
	xor  a                                           ; $05de: $af
	ldh  [rSB], a                                    ; $05df: $e0 $01
	ldh  [hNextSerialByteToLoad], a                                    ; $05e1: $e0 $cf
	ldh  [$dc], a                                    ; $05e3: $e0 $dc
	ldh  [$d2], a                                    ; $05e5: $e0 $d2
	ldh  [$d3], a                                    ; $05e7: $e0 $d3
	ldh  [$d4], a                                    ; $05e9: $e0 $d4
	ldh  [$d5], a                                    ; $05eb: $e0 $d5
	ldh  [hRowsShiftingDownState], a                           ; $05ed
	call ThunkInitSound                                        ; $05ef

; set next state
	ld   a, GS_2PLAYER_GAME_MUSIC_TYPE_MAIN                    ; $05f2
	ldh  [hGameState], a                                       ; $05f4
	ret                                                        ; $05f6


GameState2b_2PlayerGameMusicTypeMain:
	ldh  a, [hMultiplayerPlayerRole]                           ; $05f7
	cp   MP_ROLE_MASTER                                        ; $05f9
	jr   z, .isMaster                                          ; $05fb

; is passive, and this var set..
	ldh  a, [hPassiveShouldUpdateMusicOamAndPlaySong]          ; $05fd
	and  a                                                     ; $05ff
	jr   z, .cont                                              ; $0600

; once change music selection oam, and play relevant song
	xor  a                                                     ; $0602
	ldh  [hPassiveShouldUpdateMusicOamAndPlaySong], a          ; $0603
	ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $0605
	call SetSpriteSpecCoordsForMusicType                       ; $0608
	call PlaySongBasedOnMusicTypeChosen                        ; $060b
	call Copy2SpriteSpecsToShadowOam                           ; $060e
	jr   .cont                                                 ; $0611

.isMaster:
; if master, process A and Start here instead of 1 player code
	ldh  a, [hButtonsPressed]                                  ; $0613
	bit  PADB_A, a                                             ; $0615
	jr   nz, .cont                                             ; $0617

	bit  PADB_START, a                                         ; $0619
	jr   nz, .cont                                             ; $061b

; called if master and neither A or Start pressed
	call GameState0f_MusicTypeMain                             ; $061d

.cont:
	ldh  a, [hMultiplayerPlayerRole]                           ; $0620
	cp   MP_ROLE_MASTER                                        ; $0622
	jr   z, .isMaster2                                         ; $0624

; is passive - wait until master processes transfer
	ldh  a, [hSerialInterruptHandled]                          ; $0626
	and  a                                                     ; $0628
	ret  z                                                     ; $0629

	xor  a                                                     ; $062a
	ldh  [hSerialInterruptHandled], a                          ; $062b

; continuously ping master
	ld   a, SB_PASSIVES_PING_IN_MUSIC_SCREEN                   ; $062d
	ldh  [hNextSerialByteToLoad], a                            ; $062f

; once master indicates going to the next screen, do so as well
	ldh  a, [hSerialByteRead]                                  ; $0631
	cp   SB_GAME_MUSIC_SCREEN_TO_NEXT                          ; $0633
	jr   z, .toNextGameState                                   ; $0635

; otherwise, the byte sent is a music type..
	ld   b, a                                                  ; $0637
	ldh  a, [hMusicType]                                       ; $0638
	cp   b                                                     ; $063a
	ret  z                                                     ; $063b

; set the type if chosen, and next frame, update oam and play song
	ld   a, b                                                  ; $063c
	ldh  [hMusicType], a                                       ; $063d
	ld   a, $01                                                ; $063f
	ldh  [hPassiveShouldUpdateMusicOamAndPlaySong], a          ; $0641
	ret                                                        ; $0643

.isMaster2:
; check if processing special A/Start case
	ldh  a, [hButtonsPressed]                                  ; $0644
	bit  PADB_START, a                                         ; $0646
	jr   nz, .load50hIntoSerialByte                            ; $0648

	bit  PADB_A, a                                             ; $064a
	jr   nz, .load50hIntoSerialByte                            ; $064c

; neither A or Start pressed, ie did game state $0f
	ldh  a, [hSerialInterruptHandled]                          ; $064e
	and  a                                                     ; $0650
	ret  z                                                     ; $0651

; if did serial transfer, and passive ping not sent (went to next state)
; go to next state as well
	xor  a                                                     ; $0652
	ldh  [hSerialInterruptHandled], a                          ; $0653
	ldh  a, [hNextSerialByteToLoad]                            ; $0655
	cp   SB_GAME_MUSIC_SCREEN_TO_NEXT                          ; $0657
	jr   z, .toNextGameState                                   ; $0659

; else send music byte 
	ldh  a, [hMusicType]                                       ; $065b

.loadNextSerialByte:
	ldh  [hNextSerialByteToLoad], a                            ; $065d
	ld   a, $01                                                ; $065f
	ldh  [hMasterShouldSerialTransferInVBlank], a              ; $0661
	ret                                                        ; $0663

.toNextGameState:
	call Clear_wOam                                            ; $0664
	ld   a, GS_MARIO_LUIGI_SCREEN_INIT                         ; $0667
	ldh  [hGameState], a                                       ; $0669
	ret                                                        ; $066b

.load50hIntoSerialByte:
	ld   a, SB_GAME_MUSIC_SCREEN_TO_NEXT                       ; $066c
	jr   .loadNextSerialByte                                   ; $066e


GameState16_passive:
; keep bit 7 set, in case checking when it's cleared
	ld   hl, rSC                                               ; $0670
	set  7, [hl]                                               ; $0673
	jr   GameState16_MarioLuigiScreenInit.cont                 ; $0675


GameState16_MarioLuigiScreenInit:
; passive just streams pings, master controls
	ld   a, SF_PASSIVE_STREAMING_BYTES                         ; $0677
	ldh  [hSerialInterruptFunc], a                             ; $0679

	ldh  a, [hMultiplayerPlayerRole]                           ; $067b
	cp   MP_ROLE_MASTER                                        ; $067d
	jr   nz, GameState16_passive                               ; $067f

; is master
	call Call_000_0aa1                               ; $0681: $cd $a1 $0a
	call Call_000_0aa1                               ; $0684: $cd $a1 $0a
	call Call_000_0aa1                               ; $0687: $cd $a1 $0a
	ld   b, $00                                      ; $068a: $06 $00
	ld   hl, wDemoPieces                                   ; $068c: $21 $00 $c3

; $100 times, shuffle pieces
.loop:
	call Call_000_0aa1                               ; $068f: $cd $a1 $0a
	ld   [hl+], a                                    ; $0692: $22
	dec  b                                           ; $0693: $05
	jr   nz, .loop                             ; $0694: $20 $f9

.cont:
; load screen while lcd off
	call TurnOffLCD                                            ; $0696
	call LoadAsciiAndMenuScreenGfx                             ; $0699
	ld   de, Layout_MarioLuigiScreen                           ; $069c
	call CopyLayoutToScreen0                                   ; $069f

; clear oam and fill game screen with empty tiles
	call Clear_wOam                                            ; $06a2
	ld   a, TILE_EMPTY                                         ; $06a5
	call FillGameScreenBufferWithTileA                         ; $06a7

;
	ld   a, $03                                      ; $06aa: $3e $03
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $06ac: $e0 $ce
	xor  a                                           ; $06ae: $af
	ldh  [rSB], a                                    ; $06af: $e0 $01
	ldh  [hNextSerialByteToLoad], a                                    ; $06b1: $e0 $cf
	ldh  [$dc], a                                    ; $06b3: $e0 $dc
	ldh  [$d2], a                                    ; $06b5: $e0 $d2
	ldh  [$d3], a                                    ; $06b7: $e0 $d3
	ldh  [$d4], a                                    ; $06b9: $e0 $d4
	ldh  [$d5], a                                    ; $06bb: $e0 $d5
	ldh  [hRowsShiftingDownState], a                                    ; $06bd: $e0 $e3
	ldh  [hSerialInterruptHandled], a                                    ; $06bf: $e0 $cc

;
	ld   hl, wDemoPieces.end                                   ; $06c1: $21 $00 $c4
	ld   b, $0a                                      ; $06c4: $06 $0a
	ld   a, $28                                      ; $06c6: $3e $28

jr_000_06c8:
	ld   [hl+], a                                    ; $06c8: $22
	dec  b                                           ; $06c9: $05
	jr   nz, jr_000_06c8                             ; $06ca: $20 $fc

; if a game already finished, skip to in game init
	ldh  a, [h2PlayerGameFinished]                             ; $06cc
	and  a                                                     ; $06ce
	jp   nz, GameState17_MarioLuigiScreenMain.goTo2PlayerInGame                                 ; $06cf

; play relevant song here, and turn on lcd
	call PlaySongBasedOnMusicTypeChosen                        ; $06d2
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $06d5
	ldh  [rLCDC], a                                            ; $06d7

; load OAM for mario/luigi heads
	ld   hl, wOam+OAM_SIZEOF*$20                               ; $06d9
	ld   de, .marioLuigiHeads                                  ; $06dc
	ld   b, $20                                                ; $06df
	call CopyDEtoHL_Bbytes                                     ; $06e1

; load oam from specs for high chosen
	ld   hl, wSpriteSpecs                                      ; $06e4
	ld   de, SpriteSpecStruct_2PlayerHighsFlashing1            ; $06e7
	ld   c, $02                                                ; $06ea
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $06ec

; set spec coords and send to OAM
	call Set2PlayerHighCoords                                  ; $06ef
	call Copy2SpriteSpecsToShadowOam                           ; $06f2

;
	xor  a                                           ; $06f5: $af
	ldh  [$d7], a                                    ; $06f6: $e0 $d7
	ldh  [$d8], a                                    ; $06f8: $e0 $d8
	ldh  [$d9], a                                    ; $06fa: $e0 $d9
	ldh  [$da], a                                    ; $06fc: $e0 $da
	ldh  [$db], a                                    ; $06fe: $e0 $db

; go to main state
	ld   a, GS_MARIO_LUIGI_SCREEN_MAIN                         ; $0700
	ldh  [hGameState], a                                       ; $0702
	ret                                                        ; $0704

.marioLuigiHeads:
	db $40, $28, $ae, $00
	db $40, $30, $ae, $20
	db $48, $28, $af, $00
	db $48, $30, $af, $20
	db $78, $28, $c0, $00
	db $78, $30, $c0, $20
	db $80, $28, $c1, $00
	db $80, $30, $c1, $20
	
	
CopyDEtoHL_Bbytes:
.loop:
	ld   a, [de]                                               ; $0725
	ld   [hl+], a                                              ; $0726
	inc  de                                                    ; $0727
	dec  b                                                     ; $0728
	jr   nz, .loop                                             ; $0729

	ret                                                        ; $072b


GameState17_MarioLuigiScreenMain:
	ldh  a, [hMultiplayerPlayerRole]                           ; $072c
	cp   MP_ROLE_MASTER                                        ; $072e
	jr   z, .isMaster                                          ; $0730

; is passive, jump if no bytes read
	ldh  a, [hSerialInterruptHandled]                          ; $0732
	and  a                                                     ; $0734
	jr   z, .afterPassiveSerialByteHandled                     ; $0735

; if read $60, go to next state (master Start pressed)
	ldh  a, [hSerialByteRead]                                  ; $0737
	cp   SB_MARIO_LUIGI_SCREEN_TO_NEXT                         ; $0739
	jr   z, .passiveReadByteToTransitionState                  ; $073b

; if byte is < 6, it's the high of player 1
	cp   $06                                                   ; $073d
	jr   nc, .checkOwnHigh                                     ; $073f

	ldh  [w2PlayerHighSelected_1], a                           ; $0741

.checkOwnHigh:
; send master our current high chosen
	ldh  a, [w2PlayerHighSelected_2]                           ; $0743
	ldh  [hNextSerialByteToLoad], a                            ; $0745
	xor  a                                                     ; $0747
	ldh  [hSerialInterruptHandled], a                          ; $0748

.afterPassiveSerialByteHandled:
; now process buttons
	ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF                      ; $074a
	call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $074d
	ld   hl, w2PlayerHighSelected_2                            ; $0750
	jr   .checkPlayersButtons                                  ; $0753

.isMaster:
	ldh  a, [hButtonsPressed]                                  ; $0755
	bit  PADB_START, a                                         ; $0757
	jr   z, .notPressedStart                                   ; $0759

; pressed start
	ld   a, SB_MARIO_LUIGI_SCREEN_TO_NEXT                      ; $075b
	jr   .masterSendSerialByte                                 ; $075d

.notPressedStart:
; check if going next state after interrupt handled
	ldh  a, [hSerialInterruptHandled]                          ; $075f
	and  a                                                     ; $0761
	jr   z, .masterNoInterruptHandled                          ; $0762

	ldh  a, [hNextSerialByteToLoad]                            ; $0764
	cp   SB_MARIO_LUIGI_SCREEN_TO_NEXT                         ; $0766
	jr   nz, .masterNotTransitioningState                      ; $0768

.passiveReadByteToTransitionState:
	call Clear_wOam                                            ; $076a

.goTo2PlayerInGame:
	ldh  a, [h2PlayerGameFinished]                             ; $076d
	and  a                                                     ; $076f
	jr   nz, .aGameFinished                                    ; $0770

; go to in-game, ret if passive
	ld   a, GS_2PLAYER_IN_GAME_INIT                            ; $0772
	ldh  [hGameState], a                                       ; $0774
	ldh  a, [hMultiplayerPlayerRole]                           ; $0776
	cp   MP_ROLE_MASTER                                        ; $0778
	ret  nz                                                    ; $077a

; if master, set completed rows to 0, and fill screen with random blocks
	xor  a                                                     ; $077b
	ldh  [hNumCompletedTetrisRows], a                          ; $077c
	ld   a, $06                                                ; $077e
	ld   de, -$20                                              ; $0780
	ld   hl, wGameScreenBuffer+$1a2                            ; $0783
	call PopulateGameScreenWithRandomBlocks                    ; $0786
	ret                                                        ; $0789

.aGameFinished:
; if passive, go in-game init from here
	ldh  a, [hMultiplayerPlayerRole]                           ; $078a
	cp   MP_ROLE_MASTER                                        ; $078c
	jp   nz, GameState18_2PlayerInGameInit.initWithoutTurningOffLCD ; $078e

; if master, set completed rows to 0, and fill screen with random blocks
	xor  a                                                     ; $0791
	ldh  [hNumCompletedTetrisRows], a                          ; $0792
	ld   a, $06                                                ; $0794
	ld   de, -$20                                              ; $0796
	ld   hl, wGameScreenBuffer+$1a2                            ; $0799
	call PopulateGameScreenWithRandomBlocks                    ; $079c

; then go in-game init from here
	jp   GameState18_2PlayerInGameInit.initWithoutTurningOffLCD ; $079f

.masterNotTransitioningState:
; if byte read is < 6, it's player 2's chosen high
	ldh  a, [hSerialByteRead]                                  ; $07a2
	cp   $06                                                   ; $07a4
	jr   nc, .afterCheckingPlayer2High                         ; $07a6

	ldh  [w2PlayerHighSelected_2], a                           ; $07a8

.afterCheckingPlayer2High:
; send own high to player 2
	ldh  a, [w2PlayerHighSelected_1]                           ; $07aa

.masterSendSerialByte:
	ldh  [hNextSerialByteToLoad], a                            ; $07ac
	xor  a                                                     ; $07ae
	ldh  [hSerialInterruptHandled], a                          ; $07af
	inc  a                                                     ; $07b1
	ldh  [hMasterShouldSerialTransferInVBlank], a              ; $07b2

.masterNoInterruptHandled:
; check buttons pressed
	ld   de, wSpriteSpecs                                      ; $07b4
	call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $07b7
	ld   hl, w2PlayerHighSelected_1                            ; $07ba

.checkPlayersButtons:
; A = player's high
	ld   a, [hl]                                               ; $07bd
	bit  PADB_RIGHT, b                                         ; $07be
	jr   nz, .pressedRight                                     ; $07c0

	bit  PADB_LEFT, b                                          ; $07c2
	jr   nz, .pressedLeft                                      ; $07c4

	bit  PADB_UP, b                                            ; $07c6
	jr   nz, .pressedUp                                        ; $07c8

	bit  PADB_DOWN, b                                          ; $07ca
	jr   z, .afterDirectionalsSendToOam                        ; $07cc

; pressed down, +3 if not on bottom row
	cp   $03                                                   ; $07ce
	jr   nc, .afterDirectionalsSendToOam                       ; $07d0

	add  $03                                                   ; $07d2
	jr   .setNewHighAndPlaySound                               ; $07d4

.pressedRight:
; +1 if not at last option
	cp   $05                                                   ; $07d6
	jr   z, .afterDirectionalsSendToOam                        ; $07d8

	inc  a                                                     ; $07da

.setNewHighAndPlaySound:
	ld   [hl], a                                               ; $07db
	ld   a, SND_MOVING_SELECTION                               ; $07dc
	ld   [wSquareSoundToPlay], a                               ; $07de

.afterDirectionalsSendToOam:
	call Set2PlayerHighCoords                                  ; $07e1
	call Copy2SpriteSpecsToShadowOam                           ; $07e4
	ret                                                        ; $07e7

.pressedLeft:
; -1 if not at first option
	and  a                                                     ; $07e8
	jr   z, .afterDirectionalsSendToOam                        ; $07e9

	dec  a                                                     ; $07eb
	jr   .setNewHighAndPlaySound                               ; $07ec

.pressedUp:
; -3 if not on top row
	cp   $03                                                   ; $07ee
	jr   c, .afterDirectionalsSendToOam                        ; $07f0

	sub  $03                                                   ; $07f2
	jr   .setNewHighAndPlaySound                               ; $07f4


Player1HighCoords:
	db $40, $60
	db $40, $70
	db $40, $80
	db $50, $60
	db $50, $70
	db $50, $80


Player2HighCoords:
	db $78, $60
	db $78, $70
	db $78, $80
	db $88, $60
	db $88, $70
	db $88, $80


Set2PlayerHighCoords:
	ldh  a, [w2PlayerHighSelected_1]                           ; $080e
	ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $0810
	ld   hl, Player1HighCoords                                 ; $0813
	call SetNumberSpecStructsCoordsAndSpecIdxFromHLtable       ; $0816

	ldh  a, [w2PlayerHighSelected_2]                           ; $0819
	ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset ; $081b
	ld   hl, Player2HighCoords                                 ; $081e
	call SetNumberSpecStructsCoordsAndSpecIdxFromHLtable       ; $0821
	ret                                                        ; $0824


GameState18_2PlayerInGameInit:
	call TurnOffLCD                                            ; $0825

.initWithoutTurningOffLCD:
; clear some vars
	xor  a                                                     ; $0828
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $0829
	ldh  [hPieceFallingState], a                               ; $082c
	ldh  [hTetrisFlashCount], a                                ; $082e
	ldh  [hPieceCollisionDetected], a                          ; $0830
	ldh  [h1stHighScoreHighestByteForLevel], a                 ; $0832
	ldh  [hNumLinesCompletedBCD+1], a                          ; $0834
	ldh  [hSerialInterruptHandled], a                          ; $0836
	ldh  [rSB], a                                              ; $0838
	ldh  [hMasterShouldSerialTransferInVBlank], a              ; $083a
	ldh  [hSerialByteRead], a                                  ; $083c
	ldh  [hNextSerialByteToLoad], a                            ; $083e
	ldh  [$d1], a                                    ; $0840: $e0 $d1

; clear score vars, completed rows pointer, and fill bottom of tile map with empty tils
	call ClearScoreCategoryVarsAndTotalScore                   ; $0842
	call ClearPointersToCompletedTetrisRows                    ; $0845
	call FillBottom2RowsOfTileMapWithEmptyTile                 ; $0848

; clear rows shifting down state and OAM
	xor  a                                                     ; $084b
	ldh  [hRowsShiftingDownState], a                           ; $084c
	call Clear_wOam                                            ; $084e

; load layout to screen 0
	ld   de, Layout_2PlayerInGame                              ; $0851
	push de                                                    ; $0854

; must do 20 lines to increase level
	ld   a, $01                                                ; $0855
	ldh  [hATypeLinesThresholdToPassForNextLevel], a           ; $0857
	ldh  [hIs2Player], a                                       ; $0859
	call CopyLayoutToScreen0                                   ; $085b

; also copy layout to screen 1
	pop  de                                                    ; $085e
	ld   hl, _SCRN1                                            ; $085f
	call CopyLayoutToHL                                        ; $0862

; copy pause screen layout to screen 1
	ld   de, GameInnerScreenLayout_Pause                       ; $0865
	ld   hl, _SCRN1+$63                                        ; $0868
	ld   c, $0a                                                ; $086b
	call CopyGameScreenInnerText                               ; $086d

; default sprite specs for active and passive piece
	ld   hl, wSpriteSpecs                                      ; $0870
	ld   de, SpriteSpecStruct_LPieceActive                     ; $0873
	call CopyDEintoHLwhileFFhNotFound                          ; $0876

	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                      ; $0879
	ld   de, SpriteSpecStruct_LPieceNext                       ; $087c
	call CopyDEintoHLwhileFFhNotFound                          ; $087f

; set 30 lines to beat
	ld   hl, _SCRN0+$151                                       ; $0882
	ld   a, $30                                                ; $0885
	ldh  [hNumLinesCompletedBCD], a                            ; $0887

; and display 30
	ld   [hl], $00                                             ; $0889
	dec  l                                                     ; $088b
	ld   [hl], $03                                             ; $088c

; set pieces speed, and clear num completed rows
	call SetNumFramesUntilPiecesMoveDown                       ; $088e
	xor  a                                                     ; $0891
	ldh  [hNumCompletedTetrisRows], a                          ; $0892

; set face sprite based on player
	ldh  a, [hMultiplayerPlayerRole]                           ; $0894
	cp   MP_ROLE_MASTER                                        ; $0896

; master vals
	ld   de, .marioFace                                        ; $0898
	ldh  a, [w2PlayerHighSelected_1]                           ; $089b
	jr   z, .afterGettingFaceOam                               ; $089d

; passive vals
	ld   de, .luigiFace                                        ; $089f
	ldh  a, [w2PlayerHighSelected_2]                           ; $08a2

.afterGettingFaceOam:
; store high in screen 0 and 1
	ld   hl, _SCRN0+$b0                                        ; $08a4
	ld   [hl], a                                               ; $08a7
	ld   h, HIGH(_SCRN1)                                       ; $08a8
	ld   [hl], a                                               ; $08aa

; copy face sprites oam
	ld   hl, wOam+OAM_SIZEOF*$20                               ; $08ab
	ld   b, $10                                                ; $08ae
	call CopyDEtoHL_Bbytes                                     ; $08b0

; 2 player is always clear num lines
	ld   a, GAME_TYPE_B_TYPE                                   ; $08b3
	ldh  [hGameType], a                                        ; $08b5

; turn on LCD, set game state and set in-game serial func
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $08b7
	ldh  [rLCDC], a                                            ; $08b9

	ld   a, GS_19                                      ; $08bb: $3e $19
	ldh  [hGameState], a                                    ; $08bd: $e0 $e1

	ld   a, SF_IN_GAME                                         ; $08bf
	ldh  [hSerialInterruptFunc], a                             ; $08c1
	ret                                                        ; $08c3

.luigiFace:
	db $18, $84, $c0, $00
	db $18, $8c, $c0, $20
	db $20, $84, $c1, $00
	db $20, $8c, $c1, $20

.marioFace:
	db $18, $84, $ae, $00
	db $18, $8c, $ae, $20
	db $20, $84, $af, $00
	db $20, $8c, $af, $20
	
	
GameState19:
; no vblank interrupt for now
	ld   a, IEF_SERIAL                                         ; $08e4

	ldh  [rIE], a                                              ; $08e5
	xor  a                                                     ; $08e8
	ldh  [rIF], a                                              ; $08e9

; branch based on role
	ldh  a, [hMultiplayerPlayerRole]                           ; $08eb
	cp   MP_ROLE_MASTER                                        ; $08ed
	jp   nz, GameState19_passive                               ; $08ef

; is master
.waitUntilPassiveSends55h:
	call SerialTransferWaitFunc                                ; $08f2
	call SerialTransferWaitFunc                                ; $08f5
	xor  a                                                     ; $08f8
	ldh  [hSerialInterruptHandled], a                          ; $08f9

; send passive $29
	ld   a, $29                                      ; $08fb: $3e $29
	ldh  [rSB], a                                    ; $08fd: $e0 $01
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                                      ; $08ff: $3e $81
	ldh  [rSC], a                                    ; $0901: $e0 $02

.waitUntilSerialInterruptHandled:
	ldh  a, [hSerialInterruptHandled]                                    ; $0903: $f0 $cc
	and  a                                           ; $0905: $a7
	jr   z, .waitUntilSerialInterruptHandled                              ; $0906: $28 $fb

; only proceed when passive sends $55
	ldh  a, [rSB]                                    ; $0908: $f0 $01
	cp   $55                                         ; $090a: $fe $55
	jr   nz, .waitUntilPassiveSends55h                             ; $090c: $20 $e4

; once done, for 10 rows, send bytes about starting blocks to player 2
	ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                   ; $090e
	ld   c, $0a                                                ; $0911
	ld   hl, wGameScreenBuffer+$102                            ; $0913

.nextRow:
	ld   b, GAME_SQUARE_WIDTH                                  ; $0916

.nextCol:
	xor  a                                                     ; $0918
	ldh  [hSerialInterruptHandled], a                          ; $0919
	call SerialTransferWaitFunc                                ; $091b

; send tile idx
	ld   a, [hl+]                                              ; $091e
	ldh  [rSB], a                                              ; $091f
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                      ; $0921
	ldh  [rSC], a                                              ; $0923

.waitUntilSerialInterruptHandled2:
	ldh  a, [hSerialInterruptHandled]                          ; $0925
	and  a                                                     ; $0927
	jr   z, .waitUntilSerialInterruptHandled2                  ; $0928

	dec  b                                                     ; $092a
	jr   nz, .nextCol                                          ; $092b

	add  hl, de                                                ; $092d
	dec  c                                                     ; $092e
	jr   nz, .nextRow                                          ; $092f

; skip massive block of code below if high is maxed
	ldh  a, [w2PlayerHighSelected_1]                                    ; $0931: $f0 $ac
	cp   $05                                         ; $0933: $fe $05
	jr   z, jr_000_0974                              ; $0935: $28 $3d

; get $ca22 + $40 * (5-high)
	ld   hl, $ca22                                   ; $0937: $21 $22 $ca
	ld   de, $0040                                   ; $093a: $11 $40 $00

jr_000_093d:
	add  hl, de                                      ; $093d: $19
	inc  a                                           ; $093e: $3c
	cp   $05                                         ; $093f: $fe $05
	jr   nz, jr_000_093d                             ; $0941: $20 $fa

;
	ld   de, $ca22                                   ; $0943: $11 $22 $ca
	ld   c, $0a                                      ; $0946: $0e $0a

jr_000_0948:
	ld   b, $0a                                      ; $0948: $06 $0a

jr_000_094a:
	ld   a, [de]                                     ; $094a: $1a
	ld   [hl+], a                                    ; $094b: $22
	inc  e                                           ; $094c: $1c
	dec  b                                           ; $094d: $05
	jr   nz, jr_000_094a                             ; $094e: $20 $fa

	push de                                          ; $0950: $d5
	ld   de, -$2a                                   ; $0951: $11 $d6 $ff
	add  hl, de                                      ; $0954: $19
	pop  de                                          ; $0955: $d1
	push hl                                          ; $0956: $e5
	ld   hl, -$2a                                   ; $0957: $21 $d6 $ff
	add  hl, de                                      ; $095a: $19
	push hl                                          ; $095b: $e5
	pop  de                                          ; $095c: $d1
	pop  hl                                          ; $095d: $e1
	dec  c                                           ; $095e: $0d
	jr   nz, jr_000_0948                             ; $095f: $20 $e7

;
	ld   de, -$2a                                   ; $0961: $11 $d6 $ff

jr_000_0964:
	ld   b, $0a                                      ; $0964: $06 $0a
	ld   a, h                                        ; $0966: $7c
	cp   $c8                                         ; $0967: $fe $c8
	jr   z, jr_000_0974                              ; $0969: $28 $09

	ld   a, $2f                                      ; $096b: $3e $2f

jr_000_096d:
	ld   [hl+], a                                    ; $096d: $22
	dec  b                                           ; $096e: $05
	jr   nz, jr_000_096d                             ; $096f: $20 $fc

	add  hl, de                                      ; $0971: $19
	jr   jr_000_0964                                 ; $0972: $18 $f0

; after ...
jr_000_0974:
	call SerialTransferWaitFunc                               ; $0974: $cd $98 $0a
	call SerialTransferWaitFunc                               ; $0977: $cd $98 $0a
	xor  a                                           ; $097a: $af
	ldh  [hSerialInterruptHandled], a                                    ; $097b: $e0 $cc
	ld   a, $29                                      ; $097d: $3e $29
	ldh  [rSB], a                                    ; $097f: $e0 $01
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                                      ; $0981: $3e $81
	ldh  [rSC], a                                    ; $0983: $e0 $02

jr_000_0985:
	ldh  a, [hSerialInterruptHandled]                                    ; $0985: $f0 $cc
	and  a                                           ; $0987: $a7
	jr   z, jr_000_0985                              ; $0988: $28 $fb

	ldh  a, [rSB]                                    ; $098a: $f0 $01
	cp   $55                                         ; $098c: $fe $55
	jr   nz, jr_000_0974                             ; $098e: $20 $e4

	ld   hl, wDemoPieces                                   ; $0990: $21 $00 $c3
	ld   b, $00                                      ; $0993: $06 $00

jr_000_0995:
	xor  a                                           ; $0995: $af
	ldh  [hSerialInterruptHandled], a                                    ; $0996: $e0 $cc
	ld   a, [hl+]                                    ; $0998: $2a
	call SerialTransferWaitFunc                               ; $0999: $cd $98 $0a
	ldh  [rSB], a                                    ; $099c: $e0 $01
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                                      ; $099e: $3e $81
	ldh  [rSC], a                                    ; $09a0: $e0 $02

jr_000_09a2:
	ldh  a, [hSerialInterruptHandled]                                    ; $09a2: $f0 $cc
	and  a                                           ; $09a4: $a7
	jr   z, jr_000_09a2                              ; $09a5: $28 $fb

	inc  b                                           ; $09a7: $04
	jr   nz, jr_000_0995                             ; $09a8: $20 $eb

jr_000_09aa:
	call SerialTransferWaitFunc                               ; $09aa: $cd $98 $0a
	call SerialTransferWaitFunc                               ; $09ad: $cd $98 $0a
	xor  a                                           ; $09b0: $af
	ldh  [hSerialInterruptHandled], a                                    ; $09b1: $e0 $cc
	ld   a, $30                                      ; $09b3: $3e $30
	ldh  [rSB], a                                    ; $09b5: $e0 $01
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                                      ; $09b7: $3e $81
	ldh  [rSC], a                                    ; $09b9: $e0 $02

jr_000_09bb:
	ldh  a, [hSerialInterruptHandled]                                    ; $09bb: $f0 $cc
	and  a                                           ; $09bd: $a7
	jr   z, jr_000_09bb                              ; $09be: $28 $fb

	ldh  a, [rSB]                                    ; $09c0: $f0 $01
	cp   $56                                         ; $09c2: $fe $56
	jr   nz, jr_000_09aa                             ; $09c4: $20 $e4

Jump_000_09c6:
	call Call_000_0a8c                               ; $09c6: $cd $8c $0a
	ld   a, $09                                      ; $09c9: $3e $09
	ldh  [rIE], a                                    ; $09cb: $e0 $ff
	ld   a, GS_1c                                      ; $09cd: $3e $1c
	ldh  [hGameState], a                                    ; $09cf: $e0 $e1
	ld   a, ROWS_SHIFTING_DOWN_ROW_START                                      ; $09d1: $3e $02
	ldh  [hRowsShiftingDownState], a                                    ; $09d3: $e0 $e3
	ld   a, SF_PASSIVE_STREAMING_BYTES                                      ; $09d5: $3e $03
	ldh  [hSerialInterruptFunc], a                                    ; $09d7: $e0 $cd
	ldh  a, [hMultiplayerPlayerRole]                                    ; $09d9: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $09db: $fe $29
	jr   z, jr_000_09e4                              ; $09dd: $28 $05

	ld   hl, rSC                                   ; $09df: $21 $02 $ff
	set  7, [hl]                                     ; $09e2: $cb $fe

jr_000_09e4:
	ld   hl, wDemoPieces                                   ; $09e4: $21 $00 $c3
	ld   a, [hl+]                                    ; $09e7: $2a
	ld   [wSpriteSpecs+SPR_SPEC_SpecIdx], a                                  ; $09e8: $ea $03 $c2
	ld   a, [hl+]                                    ; $09eb: $2a
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx], a                                  ; $09ec: $ea $13 $c2
	ld   a, h                                        ; $09ef: $7c
	ldh  [$af], a                                    ; $09f0: $e0 $af
	ld   a, l                                        ; $09f2: $7d
	ldh  [hLowByteOfCurrDemoStepAddress], a                                    ; $09f3: $e0 $b0
	ret                                              ; $09f5: $c9

GameState19_passive:
; B = 1 to 6
	ldh  a, [w2PlayerHighSelected_2]                                    ; $09f6: $f0 $ad
	inc  a                                           ; $09f8: $3c
	ld   b, a                                        ; $09f9: $47

;
	ld   hl, $ca42                                   ; $09fa: $21 $42 $ca
	ld   de, -$40                                   ; $09fd: $11 $c0 $ff

jr_000_0a00:
	dec  b                                           ; $0a00: $05
	jr   z, jr_000_0a06                              ; $0a01: $28 $03

	add  hl, de                                      ; $0a03: $19
	jr   jr_000_0a00                                 ; $0a04: $18 $fa

jr_000_0a06:
	call SerialTransferWaitFunc                               ; $0a06: $cd $98 $0a
	xor  a                                           ; $0a09: $af
	ldh  [hSerialInterruptHandled], a                                    ; $0a0a: $e0 $cc
	ld   a, $55                                      ; $0a0c: $3e $55
	ldh  [rSB], a                                    ; $0a0e: $e0 $01
	ld   a, $80                                      ; $0a10: $3e $80
	ldh  [rSC], a                                    ; $0a12: $e0 $02

jr_000_0a14:
	ldh  a, [hSerialInterruptHandled]                                    ; $0a14: $f0 $cc
	and  a                                           ; $0a16: $a7
	jr   z, jr_000_0a14                              ; $0a17: $28 $fb

	ldh  a, [rSB]                                    ; $0a19: $f0 $01
	cp   $29                                         ; $0a1b: $fe $29
	jr   nz, jr_000_0a06                             ; $0a1d: $20 $e7

	ld   de, $0016                                   ; $0a1f: $11 $16 $00
	ld   c, $0a                                      ; $0a22: $0e $0a

jr_000_0a24:
	ld   b, $0a                                      ; $0a24: $06 $0a

jr_000_0a26:
	xor  a                                           ; $0a26: $af
	ldh  [hSerialInterruptHandled], a                                    ; $0a27: $e0 $cc
	ldh  [rSB], a                                    ; $0a29: $e0 $01
	ld   a, $80                                      ; $0a2b: $3e $80
	ldh  [rSC], a                                    ; $0a2d: $e0 $02

jr_000_0a2f:
	ldh  a, [hSerialInterruptHandled]                                    ; $0a2f: $f0 $cc
	and  a                                           ; $0a31: $a7
	jr   z, jr_000_0a2f                              ; $0a32: $28 $fb

	ldh  a, [rSB]                                    ; $0a34: $f0 $01
	ld   [hl+], a                                    ; $0a36: $22
	dec  b                                           ; $0a37: $05
	jr   nz, jr_000_0a26                             ; $0a38: $20 $ec

	add  hl, de                                      ; $0a3a: $19
	dec  c                                           ; $0a3b: $0d
	jr   nz, jr_000_0a24                             ; $0a3c: $20 $e6

jr_000_0a3e:
	call SerialTransferWaitFunc                               ; $0a3e: $cd $98 $0a
	xor  a                                           ; $0a41: $af
	ldh  [hSerialInterruptHandled], a                                    ; $0a42: $e0 $cc
	ld   a, $55                                      ; $0a44: $3e $55
	ldh  [rSB], a                                    ; $0a46: $e0 $01
	ld   a, $80                                      ; $0a48: $3e $80
	ldh  [rSC], a                                    ; $0a4a: $e0 $02

jr_000_0a4c:
	ldh  a, [hSerialInterruptHandled]                                    ; $0a4c: $f0 $cc
	and  a                                           ; $0a4e: $a7
	jr   z, jr_000_0a4c                              ; $0a4f: $28 $fb

	ldh  a, [rSB]                                    ; $0a51: $f0 $01
	cp   $29                                         ; $0a53: $fe $29
	jr   nz, jr_000_0a3e                             ; $0a55: $20 $e7

	ld   b, $00                                      ; $0a57: $06 $00
	ld   hl, wDemoPieces                                   ; $0a59: $21 $00 $c3

jr_000_0a5c:
	xor  a                                           ; $0a5c: $af
	ldh  [hSerialInterruptHandled], a                                    ; $0a5d: $e0 $cc
	ldh  [rSB], a                                    ; $0a5f: $e0 $01
	ld   a, $80                                      ; $0a61: $3e $80
	ldh  [rSC], a                                    ; $0a63: $e0 $02

jr_000_0a65:
	ldh  a, [hSerialInterruptHandled]                                    ; $0a65: $f0 $cc
	and  a                                           ; $0a67: $a7
	jr   z, jr_000_0a65                              ; $0a68: $28 $fb

	ldh  a, [rSB]                                    ; $0a6a: $f0 $01
	ld   [hl+], a                                    ; $0a6c: $22
	inc  b                                           ; $0a6d: $04
	jr   nz, jr_000_0a5c                             ; $0a6e: $20 $ec

jr_000_0a70:
	call SerialTransferWaitFunc                               ; $0a70: $cd $98 $0a
	xor  a                                           ; $0a73: $af
	ldh  [hSerialInterruptHandled], a                                    ; $0a74: $e0 $cc
	ld   a, $56                                      ; $0a76: $3e $56
	ldh  [rSB], a                                    ; $0a78: $e0 $01
	ld   a, $80                                      ; $0a7a: $3e $80
	ldh  [rSC], a                                    ; $0a7c: $e0 $02

jr_000_0a7e:
	ldh  a, [hSerialInterruptHandled]                                    ; $0a7e: $f0 $cc
	and  a                                           ; $0a80: $a7
	jr   z, jr_000_0a7e                              ; $0a81: $28 $fb

	ldh  a, [rSB]                                    ; $0a83: $f0 $01
	cp   $30                                         ; $0a85: $fe $30
	jr   nz, jr_000_0a70                             ; $0a87: $20 $e7

	jp   Jump_000_09c6                               ; $0a89: $c3 $c6 $09


Call_000_0a8c:
	ld   hl, $ca42                                   ; $0a8c: $21 $42 $ca
	ld   a, $80                                      ; $0a8f: $3e $80
	ld   b, $0a                                      ; $0a91: $06 $0a

jr_000_0a93:
	ld   [hl+], a                                    ; $0a93: $22
	dec  b                                           ; $0a94: $05
	jr   nz, jr_000_0a93                             ; $0a95: $20 $fc

	ret                                              ; $0a97: $c9


SerialTransferWaitFunc:
	push bc                                                    ; $0a98
	ld   b, $fa                                                ; $0a99

.loop:
	ld   b, b                                                  ; $0a9b
	dec  b                                                     ; $0a9c
	jr   nz, .loop                                             ; $0a9d

	pop  bc                                                    ; $0a9f
	ret                                                        ; $0aa0


Call_000_0aa1:
	push hl                                          ; $0aa1: $e5
	push bc                                          ; $0aa2: $c5

; piece base spec idx in C
	ldh  a, [$fc]                                    ; $0aa3: $f0 $fc
	and  $fc                                         ; $0aa5: $e6 $fc
	ld   c, a                                        ; $0aa7: $4f

; 3 times try to get a new piece
	ld   h, $03                                      ; $0aa8: $26 $03

.nextRandomVal:
; random val in B
	ldh  a, [rDIV]                                   ; $0aaa: $f0 $04
	ld   b, a                                        ; $0aac: $47

.loop1chTo0:
	xor  a                                           ; $0aad: $af

.toDecB:
	dec  b                                           ; $0aae: $05
	jr   z, .afterBEqu0                              ; $0aaf: $28 $0a

; loop A through piece indexes
	inc  a                                           ; $0ab1: $3c
	inc  a                                           ; $0ab2: $3c
	inc  a                                           ; $0ab3: $3c
	inc  a                                           ; $0ab4: $3c
	cp   $1c                                         ; $0ab5: $fe $1c
	jr   z, .loop1chTo0                              ; $0ab7: $28 $f4

	jr   .toDecB                                 ; $0ab9: $18 $f3

.afterBEqu0:
; get random piece idx in D, hidden piece in E..
	ld   d, a                                        ; $0abb: $57
	ldh  a, [hHiddenLoadedPiece]                                    ; $0abc: $f0 $ae
	ld   e, a                                        ; $0abe: $5f
	dec  h                                           ; $0abf: $25
	jr   z, .fromTriesExhausted                              ; $0ac0: $28 $07

; if hidden piece | random piece idx | ???
	or   d                                           ; $0ac2: $b2
	or   c                                           ; $0ac3: $b1
	and  $fc                                         ; $0ac4: $e6 $fc
	cp   c                                           ; $0ac6: $b9
	jr   z, .nextRandomVal                              ; $0ac7: $28 $e1

.fromTriesExhausted:
	ld   a, d                                        ; $0ac9: $7a
	ldh  [hHiddenLoadedPiece], a                                    ; $0aca: $e0 $ae
	ld   a, e                                        ; $0acc: $7b
	ldh  [$fc], a                                    ; $0acd: $e0 $fc
	pop  bc                                          ; $0acf: $c1
	pop  hl                                          ; $0ad0: $e1
	ret                                              ; $0ad1: $c9


GameState1c:
	ld   a, $01                                      ; $0ad2: $3e $01
	ldh  [rIE], a                                    ; $0ad4: $e0 $ff
	ldh  a, [hRowsShiftingDownState]                                    ; $0ad6: $f0 $e3
	and  a                                           ; $0ad8: $a7
	jr   nz, jr_000_0b02                             ; $0ad9: $20 $27

	ld   b, $44                                      ; $0adb: $06 $44
	ld   c, $20                                      ; $0add: $0e $20
	call Call_000_113f                               ; $0adf: $cd $3f $11
	ld   a, SF_02                                      ; $0ae2: $3e $02
	ldh  [hSerialInterruptFunc], a                                    ; $0ae4: $e0 $cd
	ld   a, [wNextPieceHidden]                                  ; $0ae6: $fa $de $c0
	and  a                                           ; $0ae9: $a7
	jr   z, jr_000_0af1                              ; $0aea: $28 $05

	ld   a, $80                                      ; $0aec: $3e $80
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                                  ; $0aee: $ea $10 $c2

jr_000_0af1:
	call Copy1stSpriteSpecToSprite4                               ; $0af1: $cd $83 $26
	call Copy2ndSpriteSpecToSprite8                               ; $0af4: $cd $96 $26
	call PlaySongBasedOnMusicTypeChosen                               ; $0af7: $cd $17 $15
	xor  a                                           ; $0afa: $af
	ldh  [h2PlayerGameFinished], a                                    ; $0afb: $e0 $d6
	ld   a, GS_2PLAYER_IN_GAME_MAIN                                      ; $0afd: $3e $1a
	ldh  [hGameState], a                                    ; $0aff: $e0 $e1
	ret                                              ; $0b01: $c9

jr_000_0b02:
	cp   $05                                         ; $0b02: $fe $05
	ret  nz                                          ; $0b04: $c0

	ld   hl, $c030                                   ; $0b05: $21 $30 $c0
	ld   b, $12                                      ; $0b08: $06 $12

jr_000_0b0a:
	ld   [hl], $f0                                   ; $0b0a: $36 $f0
	inc  hl                                          ; $0b0c: $23
	ld   [hl], $10                                   ; $0b0d: $36 $10
	inc  hl                                          ; $0b0f: $23
	ld   [hl], $b6                                   ; $0b10: $36 $b6
	inc  hl                                          ; $0b12: $23
	ld   [hl], $80                                   ; $0b13: $36 $80
	inc  hl                                          ; $0b15: $23
	dec  b                                           ; $0b16: $05
	jr   nz, jr_000_0b0a                             ; $0b17: $20 $f1

	ld   a, [$c3ff]                                  ; $0b19: $fa $ff $c3

jr_000_0b1c:
	ld   b, $0a                                      ; $0b1c: $06 $0a
	ld   hl, wDemoPieces.end                                   ; $0b1e: $21 $00 $c4

jr_000_0b21:
	dec  a                                           ; $0b21: $3d
	jr   z, jr_000_0b2a                              ; $0b22: $28 $06

	inc  l                                           ; $0b24: $2c
	dec  b                                           ; $0b25: $05
	jr   nz, jr_000_0b21                             ; $0b26: $20 $f9

	jr   jr_000_0b1c                                 ; $0b28: $18 $f2

jr_000_0b2a:
	ld   [hl], $2f                                   ; $0b2a: $36 $2f
	ld   a, $03                                      ; $0b2c: $3e $03
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $0b2e: $e0 $ce
	ret                                              ; $0b30: $c9


GameState1a_2PlayerInGameMain:
	ld   a, $01                                      ; $0b31: $3e $01
	ldh  [rIE], a                                    ; $0b33: $e0 $ff
	ld   hl, $c09c                                   ; $0b35: $21 $9c $c0
	xor  a                                           ; $0b38: $af
	ld   [hl+], a                                    ; $0b39: $22
	ld   [hl], $50                                   ; $0b3a: $36 $50
	inc  l                                           ; $0b3c: $2c
	ld   [hl], $27                                   ; $0b3d: $36 $27
	inc  l                                           ; $0b3f: $2c
	ld   [hl], $00                                   ; $0b40: $36 $00
	call InGameCheckResetAndPause.start                               ; $0b42: $cd $0d $1c
	call Call_000_1c88                               ; $0b45: $cd $88 $1c
	call InGameCheckButtonsPressed                               ; $0b48: $cd $bb $24
	call InGameHandlePieceFalling.start                               ; $0b4b: $cd $9c $20
	call InGameCheckIfAnyTetrisRowsComplete                               ; $0b4e: $cd $3e $21
	call InGameAddPieceToVram                               ; $0b51: $cd $a1 $25
	call ShiftEntireGameRamBufferDownARow                               ; $0b54: $cd $4d $22
	call Call_000_0b9b                               ; $0b57: $cd $9b $0b
	ldh  a, [$d5]                                    ; $0b5a: $f0 $d5
	and  a                                           ; $0b5c: $a7
	jr   z, jr_000_0b73                              ; $0b5d: $28 $14

	ld   a, $77                                      ; $0b5f: $3e $77
	ldh  [hNextSerialByteToLoad], a                                    ; $0b61: $e0 $cf
	ldh  [$b1], a                                    ; $0b63: $e0 $b1
	ld   a, $aa                                      ; $0b65: $3e $aa
	ldh  [$d1], a                                    ; $0b67: $e0 $d1
	ld   a, GS_1b                                      ; $0b69: $3e $1b
	ldh  [hGameState], a                                    ; $0b6b: $e0 $e1
	ld   a, $05                                      ; $0b6d: $3e $05
	ldh  [hTimer2], a                                    ; $0b6f: $e0 $a7
	jr   jr_000_0b83                                 ; $0b71: $18 $10

jr_000_0b73:
	ldh  a, [hGameState]                                    ; $0b73: $f0 $e1
	cp   GS_GAME_OVER_INIT                                         ; $0b75: $fe $01
	jr   nz, jr_000_0b94                             ; $0b77: $20 $1b

	ld   a, $aa                                      ; $0b79: $3e $aa
	ldh  [hNextSerialByteToLoad], a                                    ; $0b7b: $e0 $cf
	ldh  [$b1], a                                    ; $0b7d: $e0 $b1
	ld   a, $77                                      ; $0b7f: $3e $77
	ldh  [$d1], a                                    ; $0b81: $e0 $d1

jr_000_0b83:
	xor  a                                           ; $0b83: $af
	ldh  [$dc], a                                    ; $0b84: $e0 $dc
	ldh  [$d2], a                                    ; $0b86: $e0 $d2
	ldh  [$d3], a                                    ; $0b88: $e0 $d3
	ldh  [$d4], a                                    ; $0b8a: $e0 $d4
	ldh  a, [hMultiplayerPlayerRole]                                    ; $0b8c: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0b8e: $fe $29
	jr   nz, jr_000_0b94                             ; $0b90: $20 $02

	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $0b92: $e0 $ce

jr_000_0b94:
	call Call_000_0bf0                               ; $0b94: $cd $f0 $0b
	call Call_000_0c8c                               ; $0b97: $cd $8c $0c
	ret                                              ; $0b9a: $c9


Call_000_0b9b:
	ld   de, $0020                                   ; $0b9b: $11 $20 $00
	ld   hl, $c802                                   ; $0b9e: $21 $02 $c8
	ld   a, $2f                                      ; $0ba1: $3e $2f
	ld   c, $12                                      ; $0ba3: $0e $12

jr_000_0ba5:
	ld   b, $0a                                      ; $0ba5: $06 $0a
	push hl                                          ; $0ba7: $e5

jr_000_0ba8:
	cp   [hl]                                        ; $0ba8: $be
	jr   nz, jr_000_0bb5                             ; $0ba9: $20 $0a

	inc  hl                                          ; $0bab: $23
	dec  b                                           ; $0bac: $05
	jr   nz, jr_000_0ba8                             ; $0bad: $20 $f9

	pop  hl                                          ; $0baf: $e1
	add  hl, de                                      ; $0bb0: $19
	dec  c                                           ; $0bb1: $0d
	jr   nz, jr_000_0ba5                             ; $0bb2: $20 $f1

	push hl                                          ; $0bb4: $e5

jr_000_0bb5:
	pop  hl                                          ; $0bb5: $e1
	ld   a, c                                        ; $0bb6: $79
	ldh  [$b1], a                                    ; $0bb7: $e0 $b1
	cp   $0c                                         ; $0bb9: $fe $0c
	ld   a, [wSongBeingPlayed]                                  ; $0bbb: $fa $e9 $df
	jr   nc, jr_000_0bc7                             ; $0bbe: $30 $07

	cp   $08                                         ; $0bc0: $fe $08
	ret  nz                                          ; $0bc2: $c0

	call PlaySongBasedOnMusicTypeChosen                               ; $0bc3: $cd $17 $15
	ret                                              ; $0bc6: $c9

jr_000_0bc7:
	cp   $08                                         ; $0bc7: $fe $08
	ret  z                                           ; $0bc9: $c8

	ld   a, [wWavSoundToPlay]                                  ; $0bca: $fa $f0 $df
	cp   WAV_GAME_OVER                                         ; $0bcd: $fe $02
	ret  z                                           ; $0bcf: $c8

	ld   a, MUS_08                                      ; $0bd0: $3e $08
	ld   [wSongToStart], a                                  ; $0bd2: $ea $e8 $df
	ret                                              ; $0bd5: $c9

jr_000_0bd6:
	ldh  a, [hMultiplayerPlayerRole]                                    ; $0bd6: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0bd8: $fe $29
	jr   z, jr_000_0c2e                              ; $0bda: $28 $52

	ld   a, $01                                      ; $0bdc: $3e $01
	ld   [wGamePausedActivity], a                                  ; $0bde: $ea $7f $df
	ldh  [hGamePaused], a                                    ; $0be1: $e0 $ab
	ldh  a, [hNextSerialByteToLoad]                                    ; $0be3: $f0 $cf
	ldh  [$f1], a                                    ; $0be5: $e0 $f1
	xor  a                                           ; $0be7: $af
	ldh  [$f2], a                                    ; $0be8: $e0 $f2
	ldh  [hNextSerialByteToLoad], a                                    ; $0bea: $e0 $cf
	call Call_000_1ccb                               ; $0bec: $cd $cb $1c
	ret                                              ; $0bef: $c9


Call_000_0bf0:
	ldh  a, [hSerialInterruptHandled]                                    ; $0bf0: $f0 $cc
	and  a                                           ; $0bf2: $a7
	ret  z                                           ; $0bf3: $c8

	ld   hl, $c030                                   ; $0bf4: $21 $30 $c0
	ld   de, $0004                                   ; $0bf7: $11 $04 $00
	xor  a                                           ; $0bfa: $af
	ldh  [hSerialInterruptHandled], a                                    ; $0bfb: $e0 $cc
	ldh  a, [hSerialByteRead]                                    ; $0bfd: $f0 $d0
	cp   $aa                                         ; $0bff: $fe $aa
	jr   z, jr_000_0c64                              ; $0c01: $28 $61

	cp   $77                                         ; $0c03: $fe $77
	jr   z, jr_000_0c50                              ; $0c05: $28 $49

	cp   $94                                         ; $0c07: $fe $94
	jr   z, jr_000_0bd6                              ; $0c09: $28 $cb

	ld   b, a                                        ; $0c0b: $47
	and  a                                           ; $0c0c: $a7
	jr   z, jr_000_0c60                              ; $0c0d: $28 $51

	bit  7, a                                        ; $0c0f: $cb $7f
	jr   nz, jr_000_0c82                             ; $0c11: $20 $6f

	cp   $13                                         ; $0c13: $fe $13
	jr   nc, jr_000_0c2e                             ; $0c15: $30 $17

	ld   a, $12                                      ; $0c17: $3e $12
	sub  b                                           ; $0c19: $90
	ld   c, a                                        ; $0c1a: $4f
	inc  c                                           ; $0c1b: $0c

jr_000_0c1c:
	ld   a, $98                                      ; $0c1c: $3e $98

jr_000_0c1e:
	ld   [hl], a                                     ; $0c1e: $77
	add  hl, de                                      ; $0c1f: $19
	sub  $08                                         ; $0c20: $d6 $08
	dec  b                                           ; $0c22: $05
	jr   nz, jr_000_0c1e                             ; $0c23: $20 $f9

jr_000_0c25:
	ld   a, $f0                                      ; $0c25: $3e $f0

jr_000_0c27:
	dec  c                                           ; $0c27: $0d
	jr   z, jr_000_0c2e                              ; $0c28: $28 $04

	ld   [hl], a                                     ; $0c2a: $77
	add  hl, de                                      ; $0c2b: $19
	jr   jr_000_0c27                                 ; $0c2c: $18 $f9

jr_000_0c2e:
	ldh  a, [$dc]                                    ; $0c2e: $f0 $dc
	and  a                                           ; $0c30: $a7
	jr   z, jr_000_0c3a                              ; $0c31: $28 $07

	or   $80                                         ; $0c33: $f6 $80
	ldh  [$b1], a                                    ; $0c35: $e0 $b1
	xor  a                                           ; $0c37: $af
	ldh  [$dc], a                                    ; $0c38: $e0 $dc

jr_000_0c3a:
	ld   a, $ff                                      ; $0c3a: $3e $ff
	ldh  [hSerialByteRead], a                                    ; $0c3c: $e0 $d0
	ldh  a, [hMultiplayerPlayerRole]                                    ; $0c3e: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0c40: $fe $29
	ldh  a, [$b1]                                    ; $0c42: $f0 $b1
	jr   nz, jr_000_0c4d                             ; $0c44: $20 $07

	ldh  [hNextSerialByteToLoad], a                                    ; $0c46: $e0 $cf
	ld   a, $01                                      ; $0c48: $3e $01
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $0c4a: $e0 $ce
	ret                                              ; $0c4c: $c9


jr_000_0c4d:
	ldh  [hNextSerialByteToLoad], a                                    ; $0c4d: $e0 $cf
	ret                                              ; $0c4f: $c9


jr_000_0c50:
	ldh  a, [$d1]                                    ; $0c50: $f0 $d1
	cp   $aa                                         ; $0c52: $fe $aa
	jr   z, jr_000_0c7c                              ; $0c54: $28 $26

	ld   a, $77                                      ; $0c56: $3e $77
	ldh  [$d1], a                                    ; $0c58: $e0 $d1
	ld   a, GS_GAME_OVER_INIT                                      ; $0c5a: $3e $01
	ldh  [hGameState], a                                    ; $0c5c: $e0 $e1
	jr   jr_000_0c2e                                 ; $0c5e: $18 $ce

jr_000_0c60:
	ld   c, $13                                      ; $0c60: $0e $13
	jr   jr_000_0c25                                 ; $0c62: $18 $c1

jr_000_0c64:
	ldh  a, [$d1]                                    ; $0c64: $f0 $d1
	cp   $77                                         ; $0c66: $fe $77
	jr   z, jr_000_0c7c                              ; $0c68: $28 $12

	ld   a, $aa                                      ; $0c6a: $3e $aa
	ldh  [$d1], a                                    ; $0c6c: $e0 $d1
	ld   a, GS_1b                                      ; $0c6e: $3e $1b
	ldh  [hGameState], a                                    ; $0c70: $e0 $e1
	ld   a, $05                                      ; $0c72: $3e $05
	ldh  [hTimer2], a                                    ; $0c74: $e0 $a7
	ld   c, $01                                      ; $0c76: $0e $01
	ld   b, $12                                      ; $0c78: $06 $12
	jr   jr_000_0c1c                                 ; $0c7a: $18 $a0

jr_000_0c7c:
	ld   a, $01                                      ; $0c7c: $3e $01
	ldh  [$ef], a                                    ; $0c7e: $e0 $ef
	jr   jr_000_0c2e                                 ; $0c80: $18 $ac

jr_000_0c82:
	and  $7f                                         ; $0c82: $e6 $7f
	cp   $05                                         ; $0c84: $fe $05
	jr   nc, jr_000_0c2e                             ; $0c86: $30 $a6

	ldh  [$d2], a                                    ; $0c88: $e0 $d2
	jr   jr_000_0c3a                                 ; $0c8a: $18 $ae

Call_000_0c8c:
	ldh  a, [$d3]                                    ; $0c8c: $f0 $d3
	and  a                                           ; $0c8e: $a7
	jr   z, jr_000_0c98                              ; $0c8f: $28 $07

	bit  7, a                                        ; $0c91: $cb $7f
	ret  z                                           ; $0c93: $c8

	and  $07                                         ; $0c94: $e6 $07
	jr   jr_000_0ca2                                 ; $0c96: $18 $0a

jr_000_0c98:
	ldh  a, [$d2]                                    ; $0c98: $f0 $d2
	and  a                                           ; $0c9a: $a7
	ret  z                                           ; $0c9b: $c8

	ldh  [$d3], a                                    ; $0c9c: $e0 $d3
	xor  a                                           ; $0c9e: $af
	ldh  [$d2], a                                    ; $0c9f: $e0 $d2
	ret                                              ; $0ca1: $c9


jr_000_0ca2:
	ld   c, a                                        ; $0ca2: $4f
	push bc                                          ; $0ca3: $c5
	ld   hl, $c822                                   ; $0ca4: $21 $22 $c8
	ld   de, $ffe0                                   ; $0ca7: $11 $e0 $ff

jr_000_0caa:
	add  hl, de                                      ; $0caa: $19
	dec  c                                           ; $0cab: $0d
	jr   nz, jr_000_0caa                             ; $0cac: $20 $fc

	ld   de, $c822                                   ; $0cae: $11 $22 $c8
	ld   c, $11                                      ; $0cb1: $0e $11

jr_000_0cb3:
	ld   b, $0a                                      ; $0cb3: $06 $0a

jr_000_0cb5:
	ld   a, [de]                                     ; $0cb5: $1a
	ld   [hl+], a                                    ; $0cb6: $22
	inc  e                                           ; $0cb7: $1c
	dec  b                                           ; $0cb8: $05
	jr   nz, jr_000_0cb5                             ; $0cb9: $20 $fa

	push de                                          ; $0cbb: $d5
	ld   de, $0016                                   ; $0cbc: $11 $16 $00
	add  hl, de                                      ; $0cbf: $19
	pop  de                                          ; $0cc0: $d1
	push hl                                          ; $0cc1: $e5
	ld   hl, $0016                                   ; $0cc2: $21 $16 $00
	add  hl, de                                      ; $0cc5: $19
	push hl                                          ; $0cc6: $e5
	pop  de                                          ; $0cc7: $d1
	pop  hl                                          ; $0cc8: $e1
	dec  c                                           ; $0cc9: $0d
	jr   nz, jr_000_0cb3                             ; $0cca: $20 $e7

	pop  bc                                          ; $0ccc: $c1

jr_000_0ccd:
	ld   de, wDemoPieces.end                                   ; $0ccd: $11 $00 $c4
	ld   b, $0a                                      ; $0cd0: $06 $0a

jr_000_0cd2:
	ld   a, [de]                                     ; $0cd2: $1a
	ld   [hl+], a                                    ; $0cd3: $22
	inc  de                                          ; $0cd4: $13
	dec  b                                           ; $0cd5: $05
	jr   nz, jr_000_0cd2                             ; $0cd6: $20 $fa

	push de                                          ; $0cd8: $d5
	ld   de, $0016                                   ; $0cd9: $11 $16 $00
	add  hl, de                                      ; $0cdc: $19
	pop  de                                          ; $0cdd: $d1
	dec  c                                           ; $0cde: $0d
	jr   nz, jr_000_0ccd                             ; $0cdf: $20 $ec

	ld   a, ROWS_SHIFTING_DOWN_ROW_START                                      ; $0ce1: $3e $02
	ldh  [hRowsShiftingDownState], a                                    ; $0ce3: $e0 $e3
	ldh  [$d4], a                                    ; $0ce5: $e0 $d4
	xor  a                                           ; $0ce7: $af
	ldh  [$d3], a                                    ; $0ce8: $e0 $d3
	ret                                              ; $0cea: $c9


GameState1b:
	ldh  a, [hTimer1]                                    ; $0ceb: $f0 $a6
	and  a                                           ; $0ced: $a7
	ret  nz                                          ; $0cee: $c0

	ld   a, $01                                      ; $0cef: $3e $01
	ldh  [rIE], a                                    ; $0cf1: $e0 $ff
	ld   a, SF_PASSIVE_STREAMING_BYTES                                      ; $0cf3: $3e $03
	ldh  [hSerialInterruptFunc], a                                    ; $0cf5: $e0 $cd
	ldh  a, [$d1]                                    ; $0cf7: $f0 $d1
	cp   $77                                         ; $0cf9: $fe $77
	jr   nz, jr_000_0d09                             ; $0cfb: $20 $0c

	ldh  a, [hSerialByteRead]                                    ; $0cfd: $f0 $d0
	cp   $aa                                         ; $0cff: $fe $aa
	jr   nz, jr_000_0d13                             ; $0d01: $20 $10

jr_000_0d03:
	ld   a, $01                                      ; $0d03: $3e $01
	ldh  [$ef], a                                    ; $0d05: $e0 $ef
	jr   jr_000_0d13                                 ; $0d07: $18 $0a

jr_000_0d09:
	cp   $aa                                         ; $0d09: $fe $aa
	jr   nz, jr_000_0d13                             ; $0d0b: $20 $06

	ldh  a, [hSerialByteRead]                                    ; $0d0d: $f0 $d0
	cp   $77                                         ; $0d0f: $fe $77
	jr   z, jr_000_0d03                              ; $0d11: $28 $f0

jr_000_0d13:
	ld   b, $34                                      ; $0d13: $06 $34
	ld   c, $43                                      ; $0d15: $0e $43
	call Call_000_113f                               ; $0d17: $cd $3f $11
	lda ROWS_SHIFTING_DOWN_NONE                                           ; $0d1a: $af
	ldh  [hRowsShiftingDownState], a                                    ; $0d1b: $e0 $e3
	ldh  a, [$d1]                                    ; $0d1d: $f0 $d1
	cp   $aa                                         ; $0d1f: $fe $aa
	ld   a, GS_2_PLAYER_LOSER_INIT                                      ; $0d21: $3e $1e
	jr   nz, jr_000_0d27                             ; $0d23: $20 $02

	ld   a, GS_2_PLAYER_WINNER_INIT                                      ; $0d25: $3e $1d

jr_000_0d27:
	ldh  [hGameState], a                                    ; $0d27: $e0 $e1
	ld   a, $28                                      ; $0d29: $3e $28
	ldh  [hTimer1], a                                    ; $0d2b: $e0 $a6
	ld   a, $1d                                      ; $0d2d: $3e $1d
	ldh  [$c6], a                                    ; $0d2f: $e0 $c6
	ret                                              ; $0d31: $c9


GameState1d_2PlayerWinnerInit:
	ldh  a, [hTimer1]                                    ; $0d32: $f0 $a6
	and  a                                           ; $0d34: $a7
	ret  nz                                          ; $0d35: $c0

	ldh  a, [$ef]                                    ; $0d36: $f0 $ef
	and  a                                           ; $0d38: $a7
	jr   nz, jr_000_0d40                             ; $0d39: $20 $05

	ldh  a, [$d7]                                    ; $0d3b: $f0 $d7
	inc  a                                           ; $0d3d: $3c
	ldh  [$d7], a                                    ; $0d3e: $e0 $d7

jr_000_0d40:
	call Call_000_0f6f                               ; $0d40: $cd $6f $0f

; load happy sprites for player
	ld   de, SpriteSpecStruct_StandingMarioCryingBabyMario     ; $0d43
	ldh  a, [hMultiplayerPlayerRole]                           ; $0d46
	cp   MP_ROLE_MASTER                                        ; $0d48
	jr   z, .loadHappySprites                                 ; $0d4a

	ld   de, SpriteSpecStruct_StandingLuigiCryingBabyLuigi     ; $0d4c

.loadHappySprites:
	ld   hl, wSpriteSpecs                                      ; $0d4f
	ld   c, $03                                                ; $0d52
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $0d54

;
	ld   a, $19                                      ; $0d57: $3e $19
	ldh  [hTimer1], a                                    ; $0d59: $e0 $a6

;
	ldh  a, [$ef]                                    ; $0d5b: $f0 $ef
	and  a                                           ; $0d5d: $a7
	jr   z, jr_000_0d65                              ; $0d5e: $28 $05

	ld   hl, $c220                                   ; $0d60: $21 $20 $c2
	ld   [hl], $80                                   ; $0d63: $36 $80

jr_000_0d65:
	ld   a, $03                                      ; $0d65: $3e $03
	call CopyASpriteSpecsToShadowOam                               ; $0d67: $cd $73 $26

;
	ld   a, GS_2_PLAYER_WINNER_MAIN                                      ; $0d6a: $3e $20
	ldh  [hGameState], a                                    ; $0d6c: $e0 $e1

;
	ld   a, MUS_09                                      ; $0d6e: $3e $09
	ld   [wSongToStart], a                                  ; $0d70: $ea $e8 $df

;
	ldh  a, [$d7]                                    ; $0d73: $f0 $d7
	cp   $05                                         ; $0d75: $fe $05
	ret  nz                                          ; $0d77: $c0

	ld   a, MUS_11                                      ; $0d78: $3e $11
	ld   [wSongToStart], a                                  ; $0d7a: $ea $e8 $df
	ret                                              ; $0d7d: $c9


jr_000_0d7e:
	ldh  a, [$d7]                                    ; $0d7e: $f0 $d7
	cp   $05                                         ; $0d80: $fe $05
	jr   nz, jr_000_0d8b                             ; $0d82: $20 $07

	ldh  a, [$c6]                                    ; $0d84: $f0 $c6
	and  a                                           ; $0d86: $a7
	jr   z, jr_000_0d91                              ; $0d87: $28 $08

	jr   jr_000_0dad                                 ; $0d89: $18 $22

jr_000_0d8b:
	ldh  a, [hButtonsPressed]                                    ; $0d8b: $f0 $81
	bit  3, a                                        ; $0d8d: $cb $5f
	jr   z, jr_000_0dad                              ; $0d8f: $28 $1c

jr_000_0d91:
	ld   a, $60                                      ; $0d91: $3e $60
	ldh  [hNextSerialByteToLoad], a                                    ; $0d93: $e0 $cf
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $0d95: $e0 $ce
	jr   jr_000_0db6                                 ; $0d97: $18 $1d


GameState20_2PlayerWinnerMain:
	ld   a, $01                                      ; $0d99: $3e $01
	ldh  [rIE], a                                    ; $0d9b: $e0 $ff
	ldh  a, [hSerialInterruptHandled]                                    ; $0d9d: $f0 $cc
	jr   z, jr_000_0dad                              ; $0d9f: $28 $0c

	ldh  a, [hMultiplayerPlayerRole]                                    ; $0da1: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0da3: $fe $29
	jr   z, jr_000_0d7e                              ; $0da5: $28 $d7

	ldh  a, [hSerialByteRead]                                    ; $0da7: $f0 $d0
	cp   $60                                         ; $0da9: $fe $60
	jr   z, jr_000_0db6                              ; $0dab: $28 $09

jr_000_0dad:
	call Call_000_0dbd                               ; $0dad: $cd $bd $0d
	ld   a, $03                                      ; $0db0: $3e $03
	call CopyASpriteSpecsToShadowOam                               ; $0db2: $cd $73 $26
	ret                                              ; $0db5: $c9


jr_000_0db6:
	ld   a, GS_POST_2_PLAYER_RESULTS                                      ; $0db6: $3e $1f
	ldh  [hGameState], a                                    ; $0db8: $e0 $e1
	ldh  [hSerialInterruptHandled], a                                    ; $0dba: $e0 $cc
	ret                                              ; $0dbc: $c9


Call_000_0dbd:
	ldh  a, [hTimer1]                                    ; $0dbd: $f0 $a6
	and  a                                           ; $0dbf: $a7
	jr   nz, jr_000_0de5                             ; $0dc0: $20 $23

	ld   hl, $ffc6                                   ; $0dc2: $21 $c6 $ff
	dec  [hl]                                        ; $0dc5: $35
	ld   a, $19                                      ; $0dc6: $3e $19
	ldh  [hTimer1], a                                    ; $0dc8: $e0 $a6
	call Call_000_0f60                               ; $0dca: $cd $60 $0f
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                                   ; $0dcd: $21 $01 $c2
	ld   a, [hl]                                     ; $0dd0: $7e
	xor  $30                                         ; $0dd1: $ee $30
	ld   [hl+], a                                    ; $0dd3: $22
	cp   $60                                         ; $0dd4: $fe $60
	call z, Call_000_0f17                            ; $0dd6: $cc $17 $0f
	inc  l                                           ; $0dd9: $2c
	push af                                          ; $0dda: $f5
	ld   a, [hl]                                     ; $0ddb: $7e
	xor  $01                                         ; $0ddc: $ee $01
	ld   [hl], a                                     ; $0dde: $77
	ld   l, $13                                      ; $0ddf: $2e $13
	ld   [hl-], a                                    ; $0de1: $32
	pop  af                                          ; $0de2: $f1
	dec  l                                           ; $0de3: $2d
	ld   [hl], a                                     ; $0de4: $77

jr_000_0de5:
	ldh  a, [$d7]                                    ; $0de5: $f0 $d7
	cp   $05                                         ; $0de7: $fe $05
	jr   nz, jr_000_0e13                             ; $0de9: $20 $28

	ldh  a, [$c6]                                    ; $0deb: $f0 $c6
	ld   hl, $c221                                   ; $0ded: $21 $21 $c2
	cp   $06                                         ; $0df0: $fe $06
	jr   z, jr_000_0e0f                              ; $0df2: $28 $1b

	cp   $08                                         ; $0df4: $fe $08
	jr   nc, jr_000_0e13                             ; $0df6: $30 $1b

	ld   a, [hl]                                     ; $0df8: $7e
	cp   $72                                         ; $0df9: $fe $72
	jr   nc, jr_000_0e03                             ; $0dfb: $30 $06

	cp   $69                                         ; $0dfd: $fe $69
	ret  z                                           ; $0dff: $c8

	inc  [hl]                                        ; $0e00: $34
	inc  [hl]                                        ; $0e01: $34
	ret                                              ; $0e02: $c9

jr_000_0e03:
	ld   [hl], $69                                   ; $0e03: $36 $69
	inc  l                                           ; $0e05: $2c
	inc  l                                           ; $0e06: $2c
	ld   [hl], $57                                   ; $0e07: $36 $57
	ld   a, SND_NON_4_LINES_CLEARED                                      ; $0e09: $3e $06
	ld   [wSquareSoundToPlay], a                                  ; $0e0b: $ea $e0 $df
	ret                                              ; $0e0e: $c9


jr_000_0e0f:
	dec  l                                           ; $0e0f: $2d
	ld   [hl], $80                                   ; $0e10: $36 $80
	ret                                              ; $0e12: $c9


jr_000_0e13:
	ldh  a, [hTimer2]                                    ; $0e13: $f0 $a7
	and  a                                           ; $0e15: $a7
	ret  nz                                          ; $0e16: $c0

	ld   a, $0f                                      ; $0e17: $3e $0f
	ldh  [hTimer2], a                                    ; $0e19: $e0 $a7
	ld   hl, $c223                                   ; $0e1b: $21 $23 $c2
	ld   a, [hl]                                     ; $0e1e: $7e
	xor  $01                                         ; $0e1f: $ee $01
	ld   [hl], a                                     ; $0e21: $77
	ret                                              ; $0e22: $c9


GameState1e_2PlayerLoserInit:
	ldh  a, [hTimer1]                                    ; $0e23: $f0 $a6
	and  a                                           ; $0e25: $a7
	ret  nz                                          ; $0e26: $c0

	ldh  a, [$ef]                                    ; $0e27: $f0 $ef
	and  a                                           ; $0e29: $a7
	jr   nz, jr_000_0e31                             ; $0e2a: $20 $05

	ldh  a, [$d8]                                    ; $0e2c: $f0 $d8
	inc  a                                           ; $0e2e: $3c
	ldh  [$d8], a                                    ; $0e2f: $e0 $d8

jr_000_0e31:
	call Call_000_0f6f                               ; $0e31: $cd $6f $0f
	ld   de, SpriteSpecStruct_MariosFacingAway                                   ; $0e34: $11 $1d $27
	ldh  a, [hMultiplayerPlayerRole]                                    ; $0e37: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0e39: $fe $29
	jr   z, jr_000_0e40                              ; $0e3b: $28 $03

	ld   de, SpriteSpecStruct_LuigisFacingAway                                   ; $0e3d: $11 $29 $27

jr_000_0e40:
	ld   hl, wSpriteSpecs                                   ; $0e40: $21 $00 $c2
	ld   c, $02                                      ; $0e43: $0e $02
	call CopyCSpriteSpecStructsFromDEtoHL                               ; $0e45: $cd $76 $17
	ld   a, $19                                      ; $0e48: $3e $19
	ldh  [hTimer1], a                                    ; $0e4a: $e0 $a6
	ldh  a, [$ef]                                    ; $0e4c: $f0 $ef
	and  a                                           ; $0e4e: $a7
	jr   z, jr_000_0e56                              ; $0e4f: $28 $05

	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                                   ; $0e51: $21 $10 $c2
	ld   [hl], $80                                   ; $0e54: $36 $80

jr_000_0e56:
	ld   a, $02                                      ; $0e56: $3e $02
	call CopyASpriteSpecsToShadowOam                               ; $0e58: $cd $73 $26
	ld   a, GS_2_PLAYER_LOSER_MAIN                                      ; $0e5b: $3e $21
	ldh  [hGameState], a                                    ; $0e5d: $e0 $e1
	ld   a, MUS_09                                      ; $0e5f: $3e $09
	ld   [wSongToStart], a                                  ; $0e61: $ea $e8 $df
	ldh  a, [$d8]                                    ; $0e64: $f0 $d8
	cp   $05                                         ; $0e66: $fe $05
	ret  nz                                          ; $0e68: $c0

	ld   a, MUS_11                                      ; $0e69: $3e $11
	ld   [wSongToStart], a                                  ; $0e6b: $ea $e8 $df
	ret                                              ; $0e6e: $c9


jr_000_0e6f:
	ldh  a, [$d8]                                    ; $0e6f: $f0 $d8
	cp   $05                                         ; $0e71: $fe $05
	jr   nz, jr_000_0e7c                             ; $0e73: $20 $07

	ldh  a, [$c6]                                    ; $0e75: $f0 $c6
	and  a                                           ; $0e77: $a7
	jr   z, jr_000_0e82                              ; $0e78: $28 $08

	jr   jr_000_0e9e                                 ; $0e7a: $18 $22

jr_000_0e7c:
	ldh  a, [hButtonsPressed]                                    ; $0e7c: $f0 $81
	bit  3, a                                        ; $0e7e: $cb $5f
	jr   z, jr_000_0e9e                              ; $0e80: $28 $1c

jr_000_0e82:
	ld   a, $60                                      ; $0e82: $3e $60
	ldh  [hNextSerialByteToLoad], a                                    ; $0e84: $e0 $cf
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $0e86: $e0 $ce
	jr   jr_000_0ea7                                 ; $0e88: $18 $1d


GameState21_2PlayerLoserMain:
	ld   a, $01                                      ; $0e8a: $3e $01
	ldh  [rIE], a                                    ; $0e8c: $e0 $ff
	ldh  a, [hSerialInterruptHandled]                                    ; $0e8e: $f0 $cc
	jr   z, jr_000_0e9e                              ; $0e90: $28 $0c

	ldh  a, [hMultiplayerPlayerRole]                                    ; $0e92: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0e94: $fe $29
	jr   z, jr_000_0e6f                              ; $0e96: $28 $d7

	ldh  a, [hSerialByteRead]                                    ; $0e98: $f0 $d0
	cp   $60                                         ; $0e9a: $fe $60
	jr   z, jr_000_0ea7                              ; $0e9c: $28 $09

jr_000_0e9e:
	call Call_000_0eae                               ; $0e9e: $cd $ae $0e
	ld   a, $02                                      ; $0ea1: $3e $02
	call CopyASpriteSpecsToShadowOam                               ; $0ea3: $cd $73 $26
	ret                                              ; $0ea6: $c9


jr_000_0ea7:
	ld   a, GS_POST_2_PLAYER_RESULTS                                      ; $0ea7: $3e $1f
	ldh  [hGameState], a                                    ; $0ea9: $e0 $e1
	ldh  [hSerialInterruptHandled], a                                    ; $0eab: $e0 $cc
	ret                                              ; $0ead: $c9


Call_000_0eae:
	ldh  a, [hTimer1]                                    ; $0eae: $f0 $a6
	and  a                                           ; $0eb0: $a7
	jr   nz, jr_000_0ecf                             ; $0eb1: $20 $1c

	ld   hl, $ffc6                                   ; $0eb3: $21 $c6 $ff
	dec  [hl]                                        ; $0eb6: $35
	ld   a, $19                                      ; $0eb7: $3e $19
	ldh  [hTimer1], a                                    ; $0eb9: $e0 $a6
	call Call_000_0f60                               ; $0ebb: $cd $60 $0f
	ld   hl, $c211                                   ; $0ebe: $21 $11 $c2
	ld   a, [hl]                                     ; $0ec1: $7e
	xor  $08                                         ; $0ec2: $ee $08
	ld   [hl+], a                                    ; $0ec4: $22
	cp   $68                                         ; $0ec5: $fe $68
	call z, Call_000_0f17                            ; $0ec7: $cc $17 $0f
	inc  l                                           ; $0eca: $2c
	ld   a, [hl]                                     ; $0ecb: $7e
	xor  $01                                         ; $0ecc: $ee $01
	ld   [hl], a                                     ; $0ece: $77

jr_000_0ecf:
	ldh  a, [$d8]                                    ; $0ecf: $f0 $d8
	cp   $05                                         ; $0ed1: $fe $05
	jr   nz, jr_000_0f07                             ; $0ed3: $20 $32

	ldh  a, [$c6]                                    ; $0ed5: $f0 $c6
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                                   ; $0ed7: $21 $01 $c2
	cp   $05                                         ; $0eda: $fe $05
	jr   z, jr_000_0f03                              ; $0edc: $28 $25

	cp   $06                                         ; $0ede: $fe $06
	jr   z, jr_000_0ef3                              ; $0ee0: $28 $11

	cp   $08                                         ; $0ee2: $fe $08
	jr   nc, jr_000_0f07                             ; $0ee4: $30 $21

	ld   a, [hl]                                     ; $0ee6: $7e
	cp   $72                                         ; $0ee7: $fe $72
	jr   nc, jr_000_0f03                             ; $0ee9: $30 $18

	cp   $61                                         ; $0eeb: $fe $61
	ret  z                                           ; $0eed: $c8

	inc  [hl]                                        ; $0eee: $34
	inc  [hl]                                        ; $0eef: $34
	inc  [hl]                                        ; $0ef0: $34
	inc  [hl]                                        ; $0ef1: $34
	ret                                              ; $0ef2: $c9

jr_000_0ef3:
	dec  l                                           ; $0ef3: $2d
	ld   [hl], $00                                   ; $0ef4: $36 $00
	inc  l                                           ; $0ef6: $2c
	ld   [hl], $61                                   ; $0ef7: $36 $61
	inc  l                                           ; $0ef9: $2c
	inc  l                                           ; $0efa: $2c
	ld   [hl], $56                                   ; $0efb: $36 $56
	ld   a, SND_NON_4_LINES_CLEARED                                      ; $0efd: $3e $06
	ld   [wSquareSoundToPlay], a                                  ; $0eff: $ea $e0 $df
	ret                                              ; $0f02: $c9


jr_000_0f03:
	dec  l                                           ; $0f03: $2d
	ld   [hl], $80                                   ; $0f04: $36 $80
	ret                                              ; $0f06: $c9


jr_000_0f07:
	ldh  a, [hTimer2]                                    ; $0f07: $f0 $a7
	and  a                                           ; $0f09: $a7
	ret  nz                                          ; $0f0a: $c0

	ld   a, $0f                                      ; $0f0b: $3e $0f
	ldh  [hTimer2], a                                    ; $0f0d: $e0 $a7
	ld   hl, wSpriteSpecs+SPR_SPEC_SpecIdx                                   ; $0f0f: $21 $03 $c2
	ld   a, [hl]                                     ; $0f12: $7e
	xor  $01                                         ; $0f13: $ee $01
	ld   [hl], a                                     ; $0f15: $77
	ret                                              ; $0f16: $c9


Call_000_0f17:
	push af                                          ; $0f17: $f5
	push hl                                          ; $0f18: $e5
	ldh  a, [$d7]                                    ; $0f19: $f0 $d7
	cp   $05                                         ; $0f1b: $fe $05
	jr   z, jr_000_0f39                              ; $0f1d: $28 $1a

	ldh  a, [$d8]                                    ; $0f1f: $f0 $d8
	cp   $05                                         ; $0f21: $fe $05
	jr   z, jr_000_0f39                              ; $0f23: $28 $14

	ldh  a, [hMultiplayerPlayerRole]                                    ; $0f25: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0f27: $fe $29
	jr   nz, jr_000_0f39                             ; $0f29: $20 $0e

	ld   hl, $c060                                   ; $0f2b: $21 $60 $c0
	ld   b, $24                                      ; $0f2e: $06 $24
	ld   de, $0f3c                                   ; $0f30: $11 $3c $0f

jr_000_0f33:
	ld   a, [de]                                     ; $0f33: $1a
	ld   [hl+], a                                    ; $0f34: $22
	inc  de                                          ; $0f35: $13
	dec  b                                           ; $0f36: $05
	jr   nz, jr_000_0f33                             ; $0f37: $20 $fa

jr_000_0f39:
	pop  hl                                          ; $0f39: $e1
	pop  af                                          ; $0f3a: $f1
	ret                                              ; $0f3b: $c9


	ld   b, d                                        ; $0f3c: $42
	jr   nc, jr_000_0f4c                             ; $0f3d: $30 $0d

	nop                                              ; $0f3f: $00
	ld   b, d                                        ; $0f40: $42
	jr   c, @-$4c                                    ; $0f41: $38 $b2

	nop                                              ; $0f43: $00
	ld   b, d                                        ; $0f44: $42
	ld   b, b                                        ; $0f45: $40
	ld   c, $00                                      ; $0f46: $0e $00
	ld   b, d                                        ; $0f48: $42
	ld   c, b                                        ; $0f49: $48
	inc  e                                           ; $0f4a: $1c
	nop                                              ; $0f4b: $00

jr_000_0f4c:
	ld   b, d                                        ; $0f4c: $42
	ld   e, b                                        ; $0f4d: $58
	ld   c, $00                                      ; $0f4e: $0e $00
	ld   b, d                                        ; $0f50: $42
	ld   h, b                                        ; $0f51: $60
	dec  e                                           ; $0f52: $1d
	nop                                              ; $0f53: $00
	ld   b, d                                        ; $0f54: $42
	ld   l, b                                        ; $0f55: $68
	or   l                                           ; $0f56: $b5
	nop                                              ; $0f57: $00
	ld   b, d                                        ; $0f58: $42
	ld   [hl], b                                     ; $0f59: $70
	cp   e                                           ; $0f5a: $bb
	nop                                              ; $0f5b: $00
	ld   b, d                                        ; $0f5c: $42
	ld   a, b                                        ; $0f5d: $78
	dec  e                                           ; $0f5e: $1d
	nop                                              ; $0f5f: $00


Call_000_0f60:
	ld   hl, $c060                                   ; $0f60: $21 $60 $c0
	ld   de, $0004                                   ; $0f63: $11 $04 $00
	ld   b, $09                                      ; $0f66: $06 $09
	xor  a                                           ; $0f68: $af

jr_000_0f69:
	ld   [hl], a                                     ; $0f69: $77
	add  hl, de                                      ; $0f6a: $19
	dec  b                                           ; $0f6b: $05
	jr   nz, jr_000_0f69                             ; $0f6c: $20 $fb

	ret                                              ; $0f6e: $c9


Call_000_0f6f:
; load gfx with LCD off
	call TurnOffLCD                                            ; $0f6f
	ld   hl, Gfx_RocketScene                                   ; $0f72
	ld   bc, Gfx_RocketScene.end-Gfx_RocketScene+$160          ; $0f75
	call CopyHLtoVramBCbytes                                   ; $0f78
	call FillScreen0FromHLdownWithEmptyTile                    ; $0f7b

; display mario and luigi score screen
	ld   hl, _SCRN0                                            ; $0f7e
	ld   de, Layout_MarioScore                                 ; $0f81
	ld   b, $04                                                ; $0f84
	call CopyLayoutBrowsToHL                                   ; $0f86

; Layout_BricksAndLuigiScore
	ld   hl, _SCRN0+$180                                       ; $0f89
	ld   b, $06                                                ; $0f8c
	call CopyLayoutBrowsToHL                                   ; $0f8e

; for master, layout is fine now
	ldh  a, [hMultiplayerPlayerRole]                           ; $0f91
	cp   MP_ROLE_MASTER                                        ; $0f93
	jr   nz, .afterBGdisplay                                   ; $0f95

	setcharmap congrats

; is passive - swap mario/luigi text display
	ld   hl, _SCRN0+$41                                        ; $0f97
	ld   [hl], "L"                                             ; $0f9a
	inc  l                                                     ; $0f9c
	ld   [hl], "U"                                             ; $0f9d
	inc  l                                                     ; $0f9f
	ld   [hl], "I"                                             ; $0fa0
	inc  l                                                     ; $0fa2
	ld   [hl], "G"                                             ; $0fa3
	inc  l                                                     ; $0fa5
	ld   [hl], "I"                                             ; $0fa6

	ld   hl, _SCRN0+$201                                       ; $0fa8
	ld   [hl], "M"                                             ; $0fab
	inc  l                                                     ; $0fad
	ld   [hl], "A"                                             ; $0fae
	inc  l                                                     ; $0fb0
	ld   [hl], "R"                                             ; $0fb1
	inc  l                                                     ; $0fb3
	ld   [hl], "I"                                             ; $0fb4
	inc  l                                                     ; $0fb6
	ld   [hl], "O"                                             ; $0fb7

	setcharmap new

.afterBGdisplay:
	ldh  a, [$ef]                                    ; $0fb9: $f0 $ef
	and  a                                           ; $0fbb: $a7
	jr   nz, jr_000_0fc1                             ; $0fbc: $20 $03

	call Call_000_1085                               ; $0fbe: $cd $85 $10

jr_000_0fc1:
	ldh  a, [$d7]                                    ; $0fc1: $f0 $d7
	and  a                                           ; $0fc3: $a7
	jr   z, jr_000_100f                              ; $0fc4: $28 $49

	cp   $05                                         ; $0fc6: $fe $05
	jr   nz, jr_000_0fe0                             ; $0fc8: $20 $16

	ld   hl, $98a5                                   ; $0fca: $21 $a5 $98
	ld   b, $0b                                      ; $0fcd: $06 $0b
	ldh  a, [hMultiplayerPlayerRole]                                    ; $0fcf: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0fd1: $fe $29
	ld   de, $10f3                                   ; $0fd3: $11 $f3 $10
	jr   z, jr_000_0fdb                              ; $0fd6: $28 $03

	ld   de, $10fe                                   ; $0fd8: $11 $fe $10

jr_000_0fdb:
	call Call_000_10d8                               ; $0fdb: $cd $d8 $10
	ld   a, $04                                      ; $0fde: $3e $04

jr_000_0fe0:
	ld   c, a                                        ; $0fe0: $4f
	ldh  a, [hMultiplayerPlayerRole]                                    ; $0fe1: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $0fe3: $fe $29
	ld   a, $93                                      ; $0fe5: $3e $93
	jr   nz, jr_000_0feb                             ; $0fe7: $20 $02

	ld   a, $8f                                      ; $0fe9: $3e $8f

jr_000_0feb:
	ldh  [hNumCompletedTetrisRows], a                                    ; $0feb: $e0 $a0
	ld   hl, $99e7                                   ; $0fed: $21 $e7 $99
	call Call_000_106a                               ; $0ff0: $cd $6a $10
	ldh  a, [$d9]                                    ; $0ff3: $f0 $d9
	and  a                                           ; $0ff5: $a7
	jr   z, jr_000_100f                              ; $0ff6: $28 $17

	ld   a, $ac                                      ; $0ff8: $3e $ac
	ldh  [hNumCompletedTetrisRows], a                                    ; $0ffa: $e0 $a0
	ld   hl, $99f0                                   ; $0ffc: $21 $f0 $99
	ld   c, $01                                      ; $0fff: $0e $01
	call Call_000_106a                               ; $1001: $cd $6a $10
	ld   hl, $98a6                                   ; $1004: $21 $a6 $98
	ld   de, $1109                                   ; $1007: $11 $09 $11
	ld   b, $09                                      ; $100a: $06 $09
	call Call_000_10d8                               ; $100c: $cd $d8 $10

jr_000_100f:
	ldh  a, [$d8]                                    ; $100f: $f0 $d8
	and  a                                           ; $1011: $a7
	jr   z, jr_000_1052                              ; $1012: $28 $3e

	cp   $05                                         ; $1014: $fe $05
	jr   nz, jr_000_102e                             ; $1016: $20 $16

	ld   hl, $98a5                                   ; $1018: $21 $a5 $98
	ld   b, $0b                                      ; $101b: $06 $0b
	ldh  a, [hMultiplayerPlayerRole]                                    ; $101d: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $101f: $fe $29
	ld   de, $10fe                                   ; $1021: $11 $fe $10
	jr   z, jr_000_1029                              ; $1024: $28 $03

	ld   de, $10f3                                   ; $1026: $11 $f3 $10

jr_000_1029:
	call Call_000_10d8                               ; $1029: $cd $d8 $10
	ld   a, $04                                      ; $102c: $3e $04

jr_000_102e:
	ld   c, a                                        ; $102e: $4f
	ldh  a, [hMultiplayerPlayerRole]                                    ; $102f: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $1031: $fe $29
	ld   a, $8f                                      ; $1033: $3e $8f
	jr   nz, jr_000_1039                             ; $1035: $20 $02

	ld   a, $93                                      ; $1037: $3e $93

jr_000_1039:
	ldh  [hNumCompletedTetrisRows], a                                    ; $1039: $e0 $a0
	ld   hl, $9827                                   ; $103b: $21 $27 $98
	call Call_000_106a                               ; $103e: $cd $6a $10
	ldh  a, [$da]                                    ; $1041: $f0 $da
	and  a                                           ; $1043: $a7
	jr   z, jr_000_1052                              ; $1044: $28 $0c

	ld   a, $ac                                      ; $1046: $3e $ac
	ldh  [hNumCompletedTetrisRows], a                                    ; $1048: $e0 $a0
	ld   hl, $9830                                   ; $104a: $21 $30 $98
	ld   c, $01                                      ; $104d: $0e $01
	call Call_000_106a                               ; $104f: $cd $6a $10

jr_000_1052:
	ldh  a, [$db]                                    ; $1052: $f0 $db
	and  a                                           ; $1054: $a7
	jr   z, .turnOnLCDandClearOam                              ; $1055: $28 $0b

	ld   hl, $98a7                                   ; $1057: $21 $a7 $98
	ld   de, $10ed                                   ; $105a: $11 $ed $10
	ld   b, $06                                      ; $105d: $06 $06
	call Call_000_10d8                               ; $105f: $cd $d8 $10

.turnOnLCDandClearOam:
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON                                      ; $1062: $3e $d3
	ldh  [rLCDC], a                                  ; $1064: $e0 $40
	call Clear_wOam                               ; $1066: $cd $8a $17
	ret                                              ; $1069: $c9


Call_000_106a:
jr_000_106a:
	ldh  a, [hNumCompletedTetrisRows]                                    ; $106a: $f0 $a0
	push hl                                          ; $106c: $e5
	ld   de, $0020                                   ; $106d: $11 $20 $00
	ld   b, $02                                      ; $1070: $06 $02

jr_000_1072:
	push hl                                          ; $1072: $e5
	ld   [hl+], a                                    ; $1073: $22
	inc  a                                           ; $1074: $3c
	ld   [hl], a                                     ; $1075: $77
	inc  a                                           ; $1076: $3c
	pop  hl                                          ; $1077: $e1
	add  hl, de                                      ; $1078: $19
	dec  b                                           ; $1079: $05
	jr   nz, jr_000_1072                             ; $107a: $20 $f6

	pop  hl                                          ; $107c: $e1
	ld   de, $0003                                   ; $107d: $11 $03 $00
	add  hl, de                                      ; $1080: $19
	dec  c                                           ; $1081: $0d
	jr   nz, jr_000_106a                             ; $1082: $20 $e6

	ret                                              ; $1084: $c9


Call_000_1085:
	ld   hl, $ffd7                                   ; $1085: $21 $d7 $ff
	ld   de, $ffd8                                   ; $1088: $11 $d8 $ff
	ldh  a, [$d9]                                    ; $108b: $f0 $d9
	and  a                                           ; $108d: $a7
	jr   nz, jr_000_10ca                             ; $108e: $20 $3a

	ldh  a, [$da]                                    ; $1090: $f0 $da
	and  a                                           ; $1092: $a7
	jr   nz, jr_000_10d1                             ; $1093: $20 $3c

	ldh  a, [$db]                                    ; $1095: $f0 $db
	and  a                                           ; $1097: $a7
	jr   nz, jr_000_10bb                             ; $1098: $20 $21

	ld   a, [hl]                                     ; $109a: $7e
	cp   $04                                         ; $109b: $fe $04
	jr   z, jr_000_10b0                              ; $109d: $28 $11

	ld   a, [de]                                     ; $109f: $1a
	cp   $04                                         ; $10a0: $fe $04
	ret  nz                                          ; $10a2: $c0

jr_000_10a3:
	ld   a, $05                                      ; $10a3: $3e $05
	ld   [de], a                                     ; $10a5: $12
	jr   jr_000_10b2                                 ; $10a6: $18 $0a

	ld   a, [de]                                     ; $10a8: $1a
	cp   $03                                         ; $10a9: $fe $03
	ret  nz                                          ; $10ab: $c0

jr_000_10ac:
	ld   a, $03                                      ; $10ac: $3e $03
	jr   jr_000_10b5                                 ; $10ae: $18 $05

jr_000_10b0:
	ld   [hl], $05                                   ; $10b0: $36 $05

jr_000_10b2:
	xor  a                                           ; $10b2: $af
	ldh  [$db], a                                    ; $10b3: $e0 $db

jr_000_10b5:
	xor  a                                           ; $10b5: $af
	ldh  [$d9], a                                    ; $10b6: $e0 $d9
	ldh  [$da], a                                    ; $10b8: $e0 $da
	ret                                              ; $10ba: $c9


jr_000_10bb:
	ld   a, [hl]                                     ; $10bb: $7e
	cp   $04                                         ; $10bc: $fe $04
	jr   nz, jr_000_10c6                             ; $10be: $20 $06

	ldh  [$d9], a                                    ; $10c0: $e0 $d9

jr_000_10c2:
	xor  a                                           ; $10c2: $af
	ldh  [$db], a                                    ; $10c3: $e0 $db
	ret                                              ; $10c5: $c9


jr_000_10c6:
	ldh  [$da], a                                    ; $10c6: $e0 $da
	jr   jr_000_10c2                                 ; $10c8: $18 $f8

jr_000_10ca:
	ld   a, [hl]                                     ; $10ca: $7e
	cp   $05                                         ; $10cb: $fe $05
	jr   z, jr_000_10b0                              ; $10cd: $28 $e1

	jr   jr_000_10ac                                 ; $10cf: $18 $db

jr_000_10d1:
	ld   a, [de]                                     ; $10d1: $1a
	cp   $05                                         ; $10d2: $fe $05
	jr   z, jr_000_10a3                              ; $10d4: $28 $cd

	jr   jr_000_10ac                                 ; $10d6: $18 $d4


Call_000_10d8:
	push bc                                          ; $10d8: $c5
	push hl                                          ; $10d9: $e5

jr_000_10da:
	ld   a, [de]                                     ; $10da: $1a
	ld   [hl+], a                                    ; $10db: $22
	inc  de                                          ; $10dc: $13
	dec  b                                           ; $10dd: $05
	jr   nz, jr_000_10da                             ; $10de: $20 $fa

	pop  hl                                          ; $10e0: $e1
	ld   de, $0020                                   ; $10e1: $11 $20 $00
	add  hl, de                                      ; $10e4: $19
	pop  bc                                          ; $10e5: $c1
	ld   a, $b6                                      ; $10e6: $3e $b6

jr_000_10e8:
	ld   [hl+], a                                    ; $10e8: $22
	dec  b                                           ; $10e9: $05
	jr   nz, jr_000_10e8                             ; $10ea: $20 $fc

	ret                                              ; $10ec: $c9


	or   b                                           ; $10ed: $b0
	or   c                                           ; $10ee: $b1
	or   d                                           ; $10ef: $b2
	or   e                                           ; $10f0: $b3
	or   c                                           ; $10f1: $b1
	ld   a, $b4                                      ; $10f2: $3e $b4
	or   l                                           ; $10f4: $b5
	cp   e                                           ; $10f5: $bb
	ld   l, $bc                                      ; $10f6: $2e $bc
	cpl                                              ; $10f8: $2f
	dec  l                                           ; $10f9: $2d
	ld   l, $3d                                      ; $10fa: $2e $3d
	ld   c, $3e                                      ; $10fc: $0e $3e
	cp   l                                           ; $10fe: $bd
	or   d                                           ; $10ff: $b2
	ld   l, $be                                      ; $1100: $2e $be
	ld   l, $2f                                      ; $1102: $2e $2f
	dec  l                                           ; $1104: $2d
	ld   l, $3d                                      ; $1105: $2e $3d
	ld   c, $3e                                      ; $1107: $0e $3e
	or   l                                           ; $1109: $b5
	or   b                                           ; $110a: $b0
	ld   b, c                                        ; $110b: $41
	or   l                                           ; $110c: $b5
	dec  a                                           ; $110d: $3d
	dec  e                                           ; $110e: $1d
	or   l                                           ; $110f: $b5
	cp   [hl]                                        ; $1110: $be
	or   c                                           ; $1111: $b1


GameState1f_Post2PlayerResults:
; no serial
	ld   a, IEF_VBLANK                                      ; $1112: $3e $01
	ldh  [rIE], a                                    ; $1114: $e0 $ff

; proceed when timer is 0
	ldh  a, [hTimer1]                                    ; $1116: $f0 $a6
	and  a                                           ; $1118: $a7
	ret  nz                                          ; $1119: $c0

;
	call Clear_wOam                               ; $111a: $cd $8a $17
	xor  a                                           ; $111d: $af
	ldh  [$ef], a                                    ; $111e: $e0 $ef
	ld   b, $27                                      ; $1120: $06 $27
	ld   c, $79                                      ; $1122: $0e $79
	call Call_000_113f                               ; $1124: $cd $3f $11
	call ThunkInitSound                                       ; $1127: $cd $f3 $7f
	ldh  a, [$d7]                                    ; $112a: $f0 $d7
	cp   $05                                         ; $112c: $fe $05
	jr   z, jr_000_113a                              ; $112e: $28 $0a

	ldh  a, [$d8]                                    ; $1130: $f0 $d8
	cp   $05                                         ; $1132: $fe $05
	jr   z, jr_000_113a                              ; $1134: $28 $04

; set game finished so we can jump back into it soon
	ld   a, $01                                      ; $1136: $3e $01
	ldh  [h2PlayerGameFinished], a                                    ; $1138: $e0 $d6

jr_000_113a:
	ld   a, GS_MARIO_LUIGI_SCREEN_INIT                                      ; $113a: $3e $16
	ldh  [hGameState], a                                    ; $113c: $e0 $e1
	ret                                              ; $113e: $c9


Call_000_113f:
	ldh  a, [hSerialInterruptHandled]                                    ; $113f: $f0 $cc
	and  a                                           ; $1141: $a7
	jr   z, jr_000_1158                              ; $1142: $28 $14

	xor  a                                           ; $1144: $af
	ldh  [hSerialInterruptHandled], a                                    ; $1145: $e0 $cc
	ldh  a, [hMultiplayerPlayerRole]                                    ; $1147: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $1149: $fe $29
	ldh  a, [hSerialByteRead]                                    ; $114b: $f0 $d0
	jr   nz, jr_000_1160                             ; $114d: $20 $11

	cp   b                                           ; $114f: $b8
	jr   z, jr_000_115a                              ; $1150: $28 $08

	ld   a, $02                                      ; $1152: $3e $02
	ldh  [hNextSerialByteToLoad], a                                    ; $1154: $e0 $cf
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $1156: $e0 $ce

jr_000_1158:
	pop  hl                                          ; $1158: $e1
	ret                                              ; $1159: $c9

jr_000_115a:
	ld   a, c                                        ; $115a: $79
	ldh  [hNextSerialByteToLoad], a                                    ; $115b: $e0 $cf
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $115d: $e0 $ce
	ret                                              ; $115f: $c9

jr_000_1160:
	cp   c                                           ; $1160: $b9
	ret  z                                           ; $1161: $c8

	ld   a, b                                        ; $1162: $78
	ldh  [hNextSerialByteToLoad], a                                    ; $1163: $e0 $cf
	pop  hl                                          ; $1165: $e1
	ret                                              ; $1166: $c9


GameState26_ShuttleSceneInit:
; display rocket scene (and its right metal structure) and left metal structure
	call DisplayRocketScene                                    ; $1167
	ld   hl, _SCRN1+$e6                                        ; $116a
	ld   de, ShuttleMetalStructureLeft                         ; $116d
	ld   b, $07                                                ; $1170
	call CopyDEintoHLsColumn_Bbytes                            ; $1172

	ld   hl, _SCRN1+$e7                                        ; $1175
	ld   de, ShuttleMetalStructureRight                        ; $1178
	ld   b, $07                                                ; $117b
	call CopyDEintoHLsColumn_Bbytes                            ; $117d

; platform extensions to rocket
	ld   hl, _SCRN1+$108                                       ; $1180
	ld   [hl], $72                                             ; $1183
	inc  l                                                     ; $1185
	ld   [hl], $c4                                             ; $1186
	ld   hl, _SCRN1+$128                                       ; $1188
	ld   [hl], $b7                                             ; $118b
	inc  l                                                     ; $118d
	ld   [hl], $b8                                             ; $118e

; load spec struct and send to shadow oam
	ld   de, SpriteSpecStruct_ShuttleAndGas                    ; $1190
	ld   hl, wSpriteSpecs                                      ; $1193
	ld   c, $03                                                ; $1196
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $1198

	ld   a, $03                                                ; $119b
	call CopyASpriteSpecsToShadowOam                           ; $119d

; turn on lcd with shared window/bg
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_BG9C00|LCDCF_OBJON|LCDCF_BGON ; $11a0
	ldh  [rLCDC], a                                            ; $11a2

; set timer, next state and music
	ld   a, $bb                                                ; $11a4
	ldh  [hTimer1], a                                          ; $11a6
	ld   a, GS_SHUTTLE_SCENE_SHOW_CLOUDS                       ; $11a8
	ldh  [hGameState], a                                       ; $11aa
	ld   a, MUS_LIFTOFF                                        ; $11ac
	ld   [wSongToStart], a                                     ; $11ae
	ret                                                        ; $11b1


DisplayRocketScene:
; display gfx with lcd off
	call TurnOffLCD                                            ; $11b2
	ld   hl, Gfx_RocketScene                                   ; $11b5
	ld   bc, Gfx_RocketScene.end-Gfx_RocketScene+$160          ; $11b8
	call CopyHLtoVramBCbytes                                   ; $11bb

; displayed on _SCRN1
	ld   hl, _SCRN1+$3ff                                       ; $11be
	call FillScreenFromHLdownWithEmptyTile                     ; $11c1

	ld   hl, _SCRN1+$1c0                                       ; $11c4
	ld   de, Layout_RocketScene                                ; $11c7
	ld   b, $04                                                ; $11ca
	call CopyLayoutBrowsToHL                                   ; $11cc

; tall structure next to rocket
	ld   hl, _SCRN1+$ec                                        ; $11cf
	ld   de, RocketMetalStructureLeft                          ; $11d2
	ld   b, $07                                                ; $11d5
	call CopyDEintoHLsColumn_Bbytes                            ; $11d7

	ld   hl, _SCRN1+$ed                                        ; $11da
	ld   de, RocketMetalStructureRight                         ; $11dd
	ld   b, $07                                                ; $11e0
	call CopyDEintoHLsColumn_Bbytes                            ; $11e2
	ret                                                        ; $11e5


GameState27_ShuttleSceneShowClouds:
; proceed when timer when reaches 0
	ldh  a, [hTimer1]                                          ; $11e6
	and  a                                                     ; $11e8
	ret  nz                                                    ; $11e9

; set visibility of gas clouds
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden      ; $11ea
	ld   [hl], $00                                             ; $11ed
	ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                  ; $11ef
	ld   [hl], $00                                             ; $11f1

; set timer and next state
	ld   a, $ff                                                ; $11f3
	ldh  [hTimer1], a                                          ; $11f5
	ld   a, GS_SHUTTLE_SCENE_FLASH_CLOUDS_GET_BIGGER           ; $11f7
	ldh  [hGameState], a                                       ; $11f9
	ret                                                        ; $11fb


GameState28_ShuttleSceneFlashCloudsGetBigger:
; while timer not 0, flash small clouds
	ldh  a, [hTimer1]                                          ; $11fc
	and  a                                                     ; $11fe
	jr   z, .showBiggerClouds                                  ; $11ff

	call ToggleNonRocketSpritesVisibilityEvery10Frames         ; $1201
	ret                                                        ; $1204

.showBiggerClouds:
; set state, and replace clouds with bigger ones
	ld   a, GS_SHUTTLE_SCENE_FLASH_BIG_CLOUDS_REMOVE_PLATFORM  ; $1205
	ldh  [hGameState], a                                       ; $1207
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx     ; $1209
	ld   [hl], SPRITE_SPEC_BIG_LIFTOFF_GAS                     ; $120c
	ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_SpecIdx                 ; $120e
	ld   [hl], SPRITE_SPEC_BIG_LIFTOFF_GAS                     ; $1210

; set timer and clear game screen
	ld   a, $ff                                                ; $1212
	ldh  [hTimer1], a                                          ; $1214
	ld   a, TILE_EMPTY                                         ; $1216
	call FillGameScreenBufferWithTileAandSetToVramTransfer     ; $1218
	ret                                                        ; $121b


GameState29_ShuttleSceneFlashBigCloudsRemovePlatforms:
; while timer not 0, flash bigger clouds
	ldh  a, [hTimer1]                                          ; $121c
	and  a                                                     ; $121e
	jr   z, .removePlatforms                                   ; $121f

	call ToggleNonRocketSpritesVisibilityEvery10Frames         ; $1221
	ret                                                        ; $1224

.removePlatforms:
; set state
	ld   a, GS_SHUTTLE_SCENE_LIFTOFF                           ; $1225
	ldh  [hGameState], a                                       ; $1227

; clear platforms
	ld   hl, _SCRN1+$108                                       ; $1229
	ld   b, TILE_EMPTY                                         ; $122c
	call StoreBinHLwhenLCDFree                                 ; $122e
	ld   hl, _SCRN1+$109                                       ; $1231
	call StoreBinHLwhenLCDFree                                 ; $1234
	ld   hl, _SCRN1+$128                                       ; $1237
	call StoreBinHLwhenLCDFree                                 ; $123a
	ld   hl, _SCRN1+$129                                       ; $123d
	call StoreBinHLwhenLCDFree                                 ; $1240
	ret                                                        ; $1243


GameState02_ShuttleSceneLiftoff:
; while timer not 0, flash gas
	ldh  a, [hTimer1]                                          ; $1244
	and  a                                                     ; $1246
	jr   nz, .flashNonRocketBits                               ; $1247

; dec Y of rocket every 10 frames
	ld   a, $0a                                                ; $1249
	ldh  [hTimer1], a                                          ; $124b

; dec Y until $58 reached
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $124d
	dec  [hl]                                                  ; $1250
	ld   a, [hl]                                               ; $1251
	cp   $58                                                   ; $1252
	jr   nz, .flashNonRocketBits                               ; $1254

; once $58 reached, make thrusters visible $20 pixels down, X of $4c
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden      ; $1256
	ld   [hl], $00                                             ; $1259
	inc  l                                                     ; $125b
	add  $20                                                   ; $125c
	ld   [hl+], a                                              ; $125e
	ld   [hl], $4c                                             ; $125f
	inc  l                                                     ; $1261
	ld   [hl], SPRITE_SPEC_SMALL_TRIPLE_THRUSTER_FIRE          ; $1262

; make 3rd item invisible, and send all 3 to oam
	ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                  ; $1264
	ld   [hl], $80                                             ; $1266
	ld   a, $03                                                ; $1268
	call CopyASpriteSpecsToShadowOam                           ; $126a

; set state and play sound
	ld   a, GS_SHUTTLE_SCENE_SHOOT_FIRE                        ; $126d
	ldh  [hGameState], a                                       ; $126f
	ld   a, NOISE_ROCKET_FIRE                                  ; $1271
	ld   [wNoiseSoundToPlay], a                                ; $1273
	ret                                                        ; $1276

.flashNonRocketBits:
	call ToggleNonRocketSpritesVisibilityEvery10Frames         ; $1277
	ret                                                        ; $127a


GameState03_ShuttleSceneShootFire:
; change fire while timer not 0
	ldh  a, [hTimer1]                                          ; $127b
	and  a                                                     ; $127d
	jr   nz, .checkTimer2                                      ; $127e

; every 10 frames, move rocket up
	ld   a, $0a                                                ; $1280
	ldh  [hTimer1], a                                          ; $1282
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset ; $1284
	dec  [hl]                                                  ; $1287
	ld   l, SPR_SPEC_BaseYOffset                               ; $1288
	dec  [hl]                                                  ; $128a

; change fire while Y not $d0
	ld   a, [hl]                                               ; $128b
	cp   $d0                                                   ; $128c
	jr   nz, .checkTimer2                                      ; $128e

; set coords of congrats text
	ld   a, HIGH(_SCRN1+$82)                                   ; $1290
	ldh  [hTypedTextCharLoc], a                                ; $1292
	ld   a, LOW(_SCRN1+$82)                                    ; $1294
	ldh  [hTypedTextCharLoc+1], a                              ; $1296

; set state
	ld   a, GS_SHUTTLE_SCENE_SHOW_CONGRATULATIONS              ; $1298
	ldh  [hGameState], a                                       ; $129a
	ret                                                        ; $129c

.checkTimer2:
	ldh  a, [hTimer2]                                          ; $129d
	and  a                                                     ; $129f
	jr   nz, .sendSpritesToOam                                 ; $12a0

; every 6 frames, change thruster fire size
	ld   a, $06                                                ; $12a2
	ldh  [hTimer2], a                                          ; $12a4
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx     ; $12a6
	ld   a, [hl]                                               ; $12a9
	xor  $01                                                   ; $12aa
	ld   [hl], a                                               ; $12ac

.sendSpritesToOam:
	ld   a, $03                                                ; $12ad
	call CopyASpriteSpecsToShadowOam                           ; $12af
	ret                                                        ; $12b2


	setcharmap congrats

GameState2c_ShuttleSceneShowCongratulations:
; proceed when timer 0
	ldh  a, [hTimer1]                                          ; $12b3
	and  a                                                     ; $12b5
	ret  nz                                                    ; $12b6

; perform below every 6 frames
	ld   a, $06                                                ; $12b7
	ldh  [hTimer1], a                                          ; $12b9

; get index of curr char
	ldh  a, [hTypedTextCharLoc+1]                              ; $12bb
	sub  LOW(_SCRN1+$82)                                       ; $12bd
	ld   e, a                                                  ; $12bf
	ld   d, $00                                                ; $12c0
	ld   hl, .congratsText                                     ; $12c2

; de = addr of char
	add  hl, de                                                ; $12c5
	push hl                                                    ; $12c6
	pop  de                                                    ; $12c7

; get vram dest in hl
	ldh  a, [hTypedTextCharLoc]                                ; $12c8
	ld   h, a                                                  ; $12ca
	ldh  a, [hTypedTextCharLoc+1]                              ; $12cb
	ld   l, a                                                  ; $12cd

; store char in dest
	ld   a, [de]                                               ; $12ce
	call StoreAinHLwhenLCDFree                                 ; $12cf

; get address below tile and store underline there
	push hl                                                    ; $12d2
	ld   de, GB_TILE_WIDTH                                     ; $12d3
	add  hl, de                                                ; $12d6
	ld   b, "_"                                                ; $12d7
	call StoreBinHLwhenLCDFree                                 ; $12d9
	pop  hl                                                    ; $12dc

; play sound for every letter shown
	inc  hl                                                    ; $12dd
	ld   a, SND_CONFIRM_OR_LETTER_TYPED                        ; $12de
	ld   [wSquareSoundToPlay], a                               ; $12e0

; store next char vram dest
	ld   a, h                                                  ; $12e3
	ldh  [hTypedTextCharLoc], a                                ; $12e4
	ld   a, l                                                  ; $12e6
	ldh  [hTypedTextCharLoc+1], a                              ; $12e7

; set timer and state once at the end
	cp   $82+.end-.congratsText                                ; $12e9
	ret  nz                                                    ; $12eb

	ld   a, $ff                                                ; $12ec
	ldh  [hTimer1], a                                          ; $12ee
	ld   a, GS_CONGRATS_WAITING_BEFORE_B_TYPE_SCORE            ; $12f0
	ldh  [hGameState], a                                       ; $12f2
	ret                                                        ; $12f4

.congratsText:
	db "CONGRATULATIONS!"
.end:

	setcharmap new


GameState2d_CongratsWaitingBeforeBTypeScore:
; proceed when timer 0
	ldh  a, [hTimer1]                                          ; $1305
	and  a                                                     ; $1307
	ret  nz                                                    ; $1308

; load gfx with lcd off, and clear tetris rows
	call TurnOffLCD                                            ; $1309
	call LoadAsciiAndMenuScreenGfx                             ; $130c
	call ClearPointersToCompletedTetrisRows                    ; $130f

; turn on lcd and set state
	ld   a, LCDCF_ON|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON       ; $1312
	ldh  [rLCDC], a                                            ; $1314
	ld   a, GS_B_TYPE_LEVEL_FINISHED                           ; $1316
	ldh  [hGameState], a                                       ; $1318
	ret                                                        ; $131a


GameState34_PreRocketSceneWait:
	ldh  a, [hTimer1]                                          ; $131b
	and  a                                                     ; $131d
	ret  nz                                                    ; $131e

	ld   a, GS_ROCKET_SCENE_INIT                               ; $131f
	ldh  [hGameState], a                                       ; $1321
	ret                                                        ; $1323


GameState2e_RocketSceneInit:
; load gfx and sprite specs (hidden gas for now)
	call DisplayRocketScene                                    ; $1324
	ld   de, SpriteSpecStruct_RocketAndGas                     ; $1327
	ld   hl, wSpriteSpecs                                      ; $132a
	ld   c, $03                                                ; $132d
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $132f

; override rocket if score < 200,000, then send to shadow oam
	ldh  a, [hATypeRocketSpecIdx]                              ; $1332
	ld   [wSpriteSpecs+SPR_SPEC_SpecIdx], a                    ; $1334
	ld   a, $03                                                ; $1337
	call CopyASpriteSpecsToShadowOam                           ; $1339

; clear rocket spec idx
	xor  a                                                     ; $133c
	ldh  [hATypeRocketSpecIdx], a                              ; $133d

; bg and window share screen 1
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_BG9C00|LCDCF_OBJON|LCDCF_BGON ; $133f
	ldh  [rLCDC], a                                            ; $1341

; set timer, next state and music
	ld   a, $bb                                                ; $1343
	ldh  [hTimer1], a                                          ; $1345
	ld   a, GS_ROCKET_SCENE_SHOW_CLOUDS                        ; $1347
	ldh  [hGameState], a                                       ; $1349
	ld   a, MUS_LIFTOFF                                        ; $134b
	ld   [wSongToStart], a                                     ; $134d
	ret                                                        ; $1350


GameState2f_RocketSceneShowClouds:
; proceed when timer done
	ldh  a, [hTimer1]                                          ; $1351
	and  a                                                     ; $1353
	ret  nz                                                    ; $1354

; make both rocket clouds visible
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden      ; $1355
	ld   [hl], $00                                             ; $1358
	ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                  ; $135a
	ld   [hl], $00                                             ; $135c

; set timer then next game state
	ld   a, $a0                                                ; $135e
	ldh  [hTimer1], a                                          ; $1360
	ld   a, GS_ROCKET_SCENE_POWERING_UP                        ; $1362
	ldh  [hGameState], a                                       ; $1364
	ret                                                        ; $1366


GameState30_PoweringUp:
; toggle gas visibility until timer done and lifting off
	ldh  a, [hTimer1]                                          ; $1367
	and  a                                                     ; $1369
	jr   z, .liftingOff                                        ; $136a

	call ToggleNonRocketSpritesVisibilityEvery10Frames         ; $136c
	ret                                                        ; $136f

.liftingOff:
; set state, timer, and clear game screen buffer
	ld   a, GS_ROCKET_SCENE_LIFTOFF                            ; $1370
	ldh  [hGameState], a                                       ; $1372
	ld   a, $80                                                ; $1374
	ldh  [hTimer1], a                                          ; $1376
	ld   a, TILE_EMPTY                                         ; $1378
	call FillGameScreenBufferWithTileAandSetToVramTransfer     ; $137a
	ret                                                        ; $137d


GameState31_RocketSceneLiftOff:
; while timer not 0, toggle visibility of gas clouds, or thrusters+fire
	ldh  a, [hTimer1]                                          ; $137e
	and  a                                                     ; $1380
	jr   nz, .toggleVisibility                                 ; $1381

; timer back at 10
	ld   a, $0a                                                ; $1383
	ldh  [hTimer1], a                                          ; $1385

; move rocket up until it hits $6a
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $1387
	dec  [hl]                                                  ; $138a
	ld   a, [hl]                                               ; $138b
	cp   $6a                                                   ; $138c
	jr   nz, .toggleVisibility                                 ; $138e

; once Y at $6a
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden      ; $1390
	ld   [hl], $00                                             ; $1393

; display new sprites at rocket + $10
	inc  l                                                     ; $1395
	add  $10                                                   ; $1396
	ld   [hl+], a                                              ; $1398

; new sprite X and spec idx
	ld   [hl], $54                                             ; $1399
	inc  l                                                     ; $139b
	ld   [hl], SPRITE_SPEC_THRUSTER                            ; $139c

; initially hide fire
	ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                  ; $139e
	ld   [hl], SPRITE_SPEC_HIDDEN                              ; $13a0
	ld   a, $03                                                ; $13a2
	call CopyASpriteSpecsToShadowOam                           ; $13a4

; set new game state and play sound
	ld   a, GS_ROCKET_SCENE_SHOOT_FIRE                         ; $13a7
	ldh  [hGameState], a                                       ; $13a9

	ld   a, NOISE_ROCKET_FIRE                                  ; $13ab
	ld   [wNoiseSoundToPlay], a                                ; $13ad
	ret                                                        ; $13b0

.toggleVisibility:
	call ToggleNonRocketSpritesVisibilityEvery10Frames         ; $13b1
	ret                                                        ; $13b4


GameState32_RocketSceneShootFire:
	ldh  a, [hTimer1]                                          ; $13b5
	and  a                                                     ; $13b7
	jr   nz, .checkTimer2                                      ; $13b8

; every 10 frames, decrease thruster and rocket Y
	ld   a, $0a                                                ; $13ba
	ldh  [hTimer1], a                                          ; $13bc
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset ; $13be
	dec  [hl]                                                  ; $13c1
	ld   l, SPR_SPEC_BaseYOffset                               ; $13c2
	dec  [hl]                                                  ; $13c4

; next state when Y at $e0
	ld   a, [hl]                                               ; $13c5
	cp   $e0                                                   ; $13c6
	jr   nz, .checkTimer2                                      ; $13c8

	ld   a, GS_ROCKET_SCENE_END                                ; $13ca
	ldh  [hGameState], a                                       ; $13cc
	ret                                                        ; $13ce

.checkTimer2:
; every 6 frames..
	ldh  a, [hTimer2]                                          ; $13cf
	and  a                                                     ; $13d1
	jr   nz, .copySpecsToOam                                   ; $13d2

	ld   a, $06                                                ; $13d4
	ldh  [hTimer2], a                                          ; $13d6

; toggle the spec idx between SPRITE_SPEC_THRUSTER and SPRITE_SPEC_THRUSTER_FIRE
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx     ; $13d8
	ld   a, [hl]                                               ; $13db
	xor  $01                                                   ; $13dc
	ld   [hl], a                                               ; $13de

.copySpecsToOam:
	ld   a, $03                                                ; $13df
	call CopyASpriteSpecsToShadowOam                           ; $13e1
	ret                                                        ; $13e4


GameState33_RocketSceneEnd:
; load gfx, clear sounds, and completed rows data
	call TurnOffLCD                                            ; $13e5
	call LoadAsciiAndMenuScreenGfx                             ; $13e8
	call ThunkInitSound                                        ; $13eb
	call ClearPointersToCompletedTetrisRows                    ; $13ee

; turn on lcd and go back to A type selection
	ld   a, LCDCF_ON|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON       ; $13f1
	ldh  [rLCDC], a                                            ; $13f3
	ld   a, GS_A_TYPE_SELECTION_INIT                           ; $13f5
	ldh  [hGameState], a                                       ; $13f7
	ret                                                        ; $13f9


ToggleNonRocketSpritesVisibilityEvery10Frames:
; proceed when 2nd timer (used here) is 0
	ldh  a, [hTimer2]                                          ; $13fa
	and  a                                                     ; $13fc
	ret  nz                                                    ; $13fd

; alternate functionality here every 10 frames
	ld   a, $0a                                                ; $13fe
	ldh  [hTimer2], a                                          ; $1400

; play gas expulsion noise
	ld   a, NOISE_ROCKET_GAS                                   ; $1402
	ld   [wNoiseSoundToPlay], a                                ; $1404

; for both non-rocket sprites, toggle visibility
	ld   b, $02                                                ; $1407
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden      ; $1409

.nextGas:
	ld   a, [hl]                                               ; $140c
	xor  SPRITE_SPEC_HIDDEN                                    ; $140d
	ld   [hl], a                                               ; $140f
	ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                  ; $1410
	dec  b                                                     ; $1412
	jr   nz, .nextGas                                          ; $1413

; copy rocket and non-rocket sprites to shadow oam
	ld   a, $03                                                ; $1415
	call CopyASpriteSpecsToShadowOam                           ; $1417
	ret                                                        ; $141a


ShuttleMetalStructureLeft:
	db $c2, $ca, $ca, $ca, $ca, $ca, $ca

ShuttleMetalStructureRight:
	db $c3, $cb, $58, $48, $48, $48, $48


RocketMetalStructureLeft:
	db $c8, $73, $73, $73, $73, $73, $73

RocketMetalStructureRight:
	db $c9, $74, $74, $74, $74, $74, $74


CopyDEintoHLsColumn_Bbytes:
.loop:
	ld   a, [de]                                               ; $1437
	ld   [hl], a                                               ; $1438
	inc  de                                                    ; $1439
	push de                                                    ; $143a
	ld   de, GB_TILE_WIDTH                                     ; $143b
	add  hl, de                                                ; $143e
	pop  de                                                    ; $143f
	dec  b                                                     ; $1440
	jr   nz, .loop                                             ; $1441

	ret                                                        ; $1443


GameState08_GameMusicTypeInit:
; no serial interrupts from this point
	ld   a, IEF_VBLANK                                         ; $1444
	ldh  [rIE], a                                              ; $1446
	xor  a                                                     ; $1448
	ldh  [rSB], a                                              ; $1449
	ldh  [rSC], a                                              ; $144b
	ldh  [rIF], a                                              ; $144d

GameMusicTypeInitWithoutDisablingSerialRegs:
; turn off LCD, load screen, then clear oam
	call TurnOffLCD                                            ; $144f
	call LoadAsciiAndMenuScreenGfx                             ; $1452
	ld   de, Layout_GameMusicTypeScreen                        ; $1455
	call CopyLayoutToScreen0                                   ; $1458
	call Clear_wOam                                            ; $145b

; initial sprites for selected game/music option
	ld   hl, wSpriteSpecs                                      ; $145e
	ld   de, SpriteSpecStruct_GameMusicAType                   ; $1461
	ld   c, $02                                                ; $1464
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $1466

; 1st sprite spec is for music
	ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $1469
	call PlayMovingSelectionSnd_SetSpriteSpecCoordsForMusicType ; $146c

; set game type (spec 2) sprite spec X
	ldh  a, [hGameType]                                        ; $146f
	ld   e, SPR_SPEC_SIZEOF+SPR_SPEC_BaseXOffset               ; $1471
	ld   [de], a                                               ; $1473

; set sprite spec idx
	inc  de                                                    ; $1474
	cp   GAME_TYPE_A_TYPE                                      ; $1475
	ld   a, SPRITE_SPEC_A_TYPE                                 ; $1477
	jr   z, .setGameTypeSpriteSpec                             ; $1479

	ld   a, SPRITE_SPEC_B_TYPE                                 ; $147b

.setGameTypeSpriteSpec:
	ld   [de], a                                               ; $147d

; copy to oam, play relevant music, turn on LCD, go to main state
	call Copy2SpriteSpecsToShadowOam                           ; $147e
	call PlaySongBasedOnMusicTypeChosen                        ; $1481
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $1484
	ldh  [rLCDC], a                                            ; $1486
	ld   a, GS_GAME_TYPE_MAIN                                  ; $1488
	ldh  [hGameState], a                                       ; $148a

Stub_148c:
	ret                                                        ; $148c


PlayMovingSelectionSnd_SetSpriteSpecCoordsForMusicType:
	ld   a, SND_MOVING_SELECTION                               ; $148d
	ld   [wSquareSoundToPlay], a                               ; $148f

SetSpriteSpecCoordsForMusicType:
; music type from 0-3
	ldh  a, [hMusicType]                                       ; $1492
	push af                                                    ; $1494
	sub  MUSIC_TYPES_START                                     ; $1495

; bc = double index, hl is offset in below table
	add  a                                                     ; $1497
	ld   c, a                                                  ; $1498
	ld   b, $00                                                ; $1499
	ld   hl, .coords                                           ; $149b
	add  hl, bc                                                ; $149e

; set sprite spec Y, then Z
	ld   a, [hl+]                                              ; $149f
	ld   [de], a                                               ; $14a0
	inc  de                                                    ; $14a1
	ld   a, [hl]                                               ; $14a2
	ld   [de], a                                               ; $14a3
	inc  de                                                    ; $14a4

; orig music type = spec idx
	pop  af                                                    ; $14a5
	ld   [de], a                                               ; $14a6
	ret                                                        ; $14a7

.coords:
	db $70, $37
	db $70, $77
	db $80, $37
	db $80, $77


GameState0f_MusicTypeMain:
; get buttons and flash music text
	ld   de, wSpriteSpecs                                      ; $14b0
	call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $14b3

	ld   hl, hMusicType                                        ; $14b6
	ld   a, [hl]                                               ; $14b9

; pressing Start in here or game type has the same effect, go to a/b type screen
	bit  PADB_START, b                                         ; $14ba
	jp   nz, GameState0e_GameTypeMain.pressedStart             ; $14bc

; pressing A here has the effect above, as this is the last selection
	bit  PADB_A, b                                             ; $14bf
	jp   nz, GameState0e_GameTypeMain.pressedStart             ; $14c1

	bit  PADB_B, b                                             ; $14c4
	jr   nz, .pressedB                                         ; $14c6

.checkDirectionalButtons:
; inc to sprite spec's Y
	inc  e                                                     ; $14c8
	bit  PADB_RIGHT, b                                         ; $14c9
	jr   nz, .pressedRight                                     ; $14cb

	bit  PADB_LEFT, b                                          ; $14cd
	jr   nz, .pressedLeft                                      ; $14cf

	bit  PADB_UP, b                                            ; $14d1
	jr   nz, .pressedUp                                        ; $14d3

	bit  PADB_DOWN, b                                          ; $14d5
	jp   z, GameState0e_GameTypeMain.copyToShadowOamOnly       ; $14d7

; jump straight to copy if at bottom row already
	cp   MUSIC_TYPES_START+2                                   ; $14da
	jr   nc, .copyToShadowOam                                  ; $14dc

	add  $02                                                   ; $14de

.setMusicType:
	ld   [hl], a                                               ; $14e0
	call PlayMovingSelectionSnd_SetSpriteSpecCoordsForMusicType ; $14e1
	call PlaySongBasedOnMusicTypeChosen                        ; $14e4

.copyToShadowOam:
	call Copy2SpriteSpecsToShadowOam                           ; $14e7
	ret                                                        ; $14ea

.pressedUp:
; sub 2 if on bottom row
	cp   MUSIC_TYPES_START+2                                   ; $14eb
	jr   c, .copyToShadowOam                                   ; $14ed

	sub  $02                                                   ; $14ef
	jr   .setMusicType                                         ; $14f1

.pressedRight:
; skip if on right column
	cp   MUSIC_TYPES_START+1                                   ; $14f3
	jr   z, .copyToShadowOam                                   ; $14f5

	cp   MUSIC_TYPES_START+3                                   ; $14f7
	jr   z, .copyToShadowOam                                   ; $14f9

; else inc music type
	inc  a                                                     ; $14fb
	jr   .setMusicType                                         ; $14fc

.pressedLeft:
; skip if on left column
	cp   MUSIC_TYPES_START+0                                   ; $14fe
	jr   z, .copyToShadowOam                                   ; $1500

	cp   MUSIC_TYPES_START+2                                   ; $1502
	jr   z, .copyToShadowOam                                   ; $1504

; else dec music type
	dec  a                                                     ; $1506
	jr   .setMusicType                                         ; $1507

.pressedB:
	push af                                                    ; $1509
	ldh  a, [hIs2Player]                                       ; $150a
	and  a                                                     ; $150c
	jr   z, .not2player                                        ; $150d

; is 2 player - dont allow going back
	pop  af                                                    ; $150f
	jr   .checkDirectionalButtons                              ; $1510

.not2player:
	pop  af                                                    ; $1512
	ld   a, GS_GAME_TYPE_MAIN                                  ; $1513
	jr   GameState0e_GameTypeMain.setGameStateClearSpecIdx     ; $1515


PlaySongBasedOnMusicTypeChosen:
	ldh  a, [hMusicType]                                       ; $1517
	sub  MUSIC_TYPE_A_TYPE-MUS_A_TYPE                          ; $1519
	cp   MUSIC_TYPE_OFF-(MUSIC_TYPE_A_TYPE-MUS_A_TYPE)         ; $151b
	jr   nz, .playSong                                         ; $151d

	ld   a, $ff                                                ; $151f

.playSong:
	ld   [wSongToStart], a                                     ; $1521
	ret                                                        ; $1524


GameState0e_GameTypeMain:
; spr spec #1 - music type, #2 here is game type
	ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF                      ; $1525
	call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $1528

	ld   hl, hGameType                                         ; $152b
	ld   a, [hl]                                               ; $152e
	bit  PADB_START, b                                         ; $152f
	jr   nz, .pressedStart                                     ; $1531

	bit  PADB_A, b                                             ; $1533
	jr   nz, .pressedA                                         ; $1535

; inc into spot in sprite spec struct where spec X is
	inc  e                                                     ; $1537
	inc  e                                                     ; $1538
	bit  PADB_RIGHT, b                                         ; $1539
	jr   nz, .pressedRight                                     ; $153b

	bit  PADB_LEFT, b                                          ; $153d
	jr   z, .copyToShadowOamOnly                               ; $153f

; pressed left, if not on A type already, use new game type and sprite spec idx
	cp   GAME_TYPE_A_TYPE                                      ; $1541
	jr   z, .copyToShadowOamOnly                               ; $1543

	ld   a, GAME_TYPE_A_TYPE                                   ; $1545
	ld   b, SPRITE_SPEC_A_TYPE                                 ; $1547
	jr   .setGameTypeAndSpriteSpecIdx                          ; $1549

.pressedRight:
; if not on B type already, use new game type and sprite spec idx
	cp   GAME_TYPE_B_TYPE                                      ; $154b
	jr   z, .copyToShadowOamOnly                               ; $154d

	ld   a, GAME_TYPE_B_TYPE                                   ; $154f
	ld   b, SPRITE_SPEC_B_TYPE                                 ; $1551

.setGameTypeAndSpriteSpecIdx:
; set game type
	ld   [hl], a                                               ; $1553

; play moving selection sound
	push af                                                    ; $1554
	ld   a, SND_MOVING_SELECTION                               ; $1555
	ld   [wSquareSoundToPlay], a                               ; $1557
	pop  af                                                    ; $155a

; the game type var is also the X
	ld   [de], a                                               ; $155b
	inc  de                                                    ; $155c

; then set spec idx
	ld   a, b                                                  ; $155d

.setSpecIdx:
	ld   [de], a                                               ; $155e

.copyToShadowOamOnly:
	call Copy2SpriteSpecsToShadowOam                           ; $155f
	ret                                                        ; $1562

.pressedStart:
; play confirm sound
	ld   a, SND_CONFIRM_OR_LETTER_TYPED                        ; $1563
	ld   [wSquareSoundToPlay], a                               ; $1565

; skip music selection and go to the selected game type's screen
	ldh  a, [hGameType]                                        ; $1568
	cp   GAME_TYPE_A_TYPE                                      ; $156a
	ld   a, GS_A_TYPE_SELECTION_INIT                           ; $156c
	jr   z, .setGameStateClearSpecIdx                          ; $156e

	ld   a, GS_B_TYPE_SELECTION_INIT                           ; $1570

.setGameStateClearSpecIdx:
	ldh  [hGameState], a                                       ; $1572
	xor  a                                                     ; $1574
	jr   .setSpecIdx                                           ; $1575

.pressedA:
	ld   a, GS_MUSIC_TYPE_MAIN                                 ; $1577
	jr   .setGameStateClearSpecIdx                             ; $1579


GameState10_ATypeSelectionInit:
; load gfx and data with lcd off, and clear oam
	call TurnOffLCD                                            ; $157b
	ld   de, Layout_ATypeSelectionScreen                       ; $157e
	call CopyLayoutToScreen0                                   ; $1581
	call DisplayDottedLinesForHighScore                        ; $1584
	call Clear_wOam                                            ; $1587

; default option is level 0
	ld   hl, wSpriteSpecs                                      ; $158a
	ld   de, SpriteSpecStruct_ATypeFlashing0                   ; $158d
	ld   c, $01                                                ; $1590
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $1592

; send sprite spec level to oam
	ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $1595
	ldh  a, [hATypeLevel]                                      ; $1598
	ld   hl, ATypeLevelsCoords                                 ; $159a
	call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $159d
	call Copy2SpriteSpecsToShadowOam                           ; $15a0

; display high scores' names and score
	call DisplayATypeHighScoresForLevel                        ; $15a3
	call DisplayHighScoresAndNamesForLevel                     ; $15a6

; turn on LCD and set main state
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $15a9
	ldh  [rLCDC], a                                            ; $15ab
	ld   a, GS_A_TYPE_SELECTION_MAIN                           ; $15ad
	ldh  [hGameState], a                                       ; $15af

; if must enter high score, set state, otherwise set A type music
	ldh  a, [hMustEnterHighScore]                              ; $15b1
	and  a                                                     ; $15b3
	jr   nz, .setGameStateToEnterHighScore                     ; $15b4

	call PlaySongBasedOnMusicTypeChosen                        ; $15b6
	ret                                                        ; $15b9

.setGameStateToEnterHighScore:
	ld   a, GS_ENTERING_HIGH_SCORE                             ; $15ba

.setGameState:
	ldh  [hGameState], a                                       ; $15bc
	ret                                                        ; $15be


GameState11_ATypeSelectionMain:
	ld   de, wSpriteSpecs                                      ; $15bf
	call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $15c2

	ld   hl, hATypeLevel                                       ; $15c5

; pressing start or A goes to in game
	ld   a, GS_IN_GAME_INIT                                    ; $15c8
	bit  PADB_START, b                                         ; $15ca
	jr   nz, GameState10_ATypeSelectionInit.setGameState       ; $15cc

	bit  PADB_A, b                                             ; $15ce
	jr   nz, GameState10_ATypeSelectionInit.setGameState       ; $15d0

; pressing B goes back to prev screen
	ld   a, GS_GAME_MUSIC_TYPE_INIT                            ; $15d2
	bit  PADB_B, b                                             ; $15d4
	jr   nz, GameState10_ATypeSelectionInit.setGameState       ; $15d6

; get level in A
	ld   a, [hl]                                               ; $15d8
	bit  PADB_RIGHT, b                                         ; $15d9
	jr   nz, .pressedRight                                     ; $15db

	bit  PADB_LEFT, b                                          ; $15dd
	jr   nz, .pressedLeft                                      ; $15df

	bit  PADB_UP, b                                            ; $15e1
	jr   nz, .pressedUp                                        ; $15e3

	bit  PADB_DOWN, b                                          ; $15e5
	jr   z, .sendSpritesToOam                                  ; $15e7

; pressed down, ignore if on bottom row
	cp   $05                                                   ; $15e9
	jr   nc, .sendSpritesToOam                                 ; $15eb

; else add 5 to be on bottom row
	add  $05                                                   ; $15ed
	jr   .setNewLevel                                          ; $15ef

.pressedRight:
; can wrap from 4 to 5, stop when at 9 already
	cp   $09                                                   ; $15f1
	jr   z, .sendSpritesToOam                                  ; $15f3

	inc  a                                                     ; $15f5

.setNewLevel:
	ld   [hl], a                                               ; $15f6

; play sound, change spec based on new level
	ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $15f7
	ld   hl, ATypeLevelsCoords                                 ; $15fa
	call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $15fd

; display level-relevant high scores
	call DisplayATypeHighScoresForLevel                        ; $1600

.sendSpritesToOam:
	call Copy2SpriteSpecsToShadowOam                           ; $1603
	ret                                                        ; $1606

.pressedLeft:
; can wrap from 5 to 4, stop when at 0 already
	and  a                                                     ; $1607
	jr   z, .sendSpritesToOam                                  ; $1608

	dec  a                                                     ; $160a
	jr   .setNewLevel                                          ; $160b

.pressedUp:
; ignore if 0-4 (top row), else -5 to go to prev row
	cp   $05                                                   ; $160d
	jr   c, .sendSpritesToOam                                  ; $160f

	sub  $05                                                   ; $1611
	jr   .setNewLevel                                          ; $1613


ATypeLevelsCoords:
	db $40, $30
	db $40, $40
	db $40, $50
	db $40, $60
	db $40, $70
	db $50, $30
	db $50, $40
	db $50, $50
	db $50, $60
	db $50, $70


GameState12_BTypeSelectionInit:
; load gfx, layout and clear oam while lcd off
	call TurnOffLCD                                            ; $1629
	ld   de, Layout_BTypeSelectionScreen                       ; $162c
	call CopyLayoutToScreen0                                   ; $162f
	call Clear_wOam                                            ; $1632

; get sprite specs for both level and high options
	ld   hl, wSpriteSpecs                                      ; $1635
	ld   de, SpriteSpecStruct_BTypeLevelAndHigh                ; $1638
	ld   c, $02                                                ; $163b
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $163d

; level spec idx coords
	ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $1640
	ldh  a, [hBTypeLevel]                                      ; $1643
	ld   hl, BTypeLevelsCoords                                 ; $1645
	call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $1648

; high spec idx coords, then send both to oam
	ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset ; $164b
	ldh  a, [hBTypeHigh]                                       ; $164e
	ld   hl, BTypeHighsCoords                                  ; $1650
	call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $1653
	call Copy2SpriteSpecsToShadowOam                           ; $1656

; display high's name and score
	call DisplayBTypeHighScoresForLevel                        ; $1659
	call DisplayHighScoresAndNamesForLevel                     ; $165c

; turn on LCD and set default main state
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $165f
	ldh  [rLCDC], a                                            ; $1661
	ld   a, GS_B_TYPE_SELECTION_MAIN                           ; $1663
	ldh  [hGameState], a                                       ; $1665

; set enter high score state if relevant, otherwise start music
	ldh  a, [hMustEnterHighScore]                              ; $1667
	and  a                                                     ; $1669
	jr   nz, .setEnterHiScore                                  ; $166a

	call PlaySongBasedOnMusicTypeChosen                        ; $166c
	ret                                                        ; $166f

.setEnterHiScore:
	ld   a, GS_ENTERING_HIGH_SCORE                             ; $1670
	ldh  [hGameState], a                                       ; $1672
	ret                                                        ; $1674


GameState13_setGameStateMakeSpriteVisible:
	ldh  [hGameState], a                                       ; $1675
	xor  a                                                     ; $1677
	ld   [de], a                                               ; $1678
	ret                                                        ; $1679


GameState13_BTypeSelectionMain:
	ld   de, wSpriteSpecs                                      ; $167a
	call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $167d

	ld   hl, hBTypeLevel                                       ; $1680

; pressing start, A, or B goes to the relevant game state
	ld   a, GS_IN_GAME_INIT                                    ; $1683
	bit  PADB_START, b                                         ; $1685
	jr   nz, GameState13_setGameStateMakeSpriteVisible         ; $1687

	ld   a, GS_B_TYPE_HIGH_MAIN                                ; $1689
	bit  PADB_A, b                                             ; $168b
	jr   nz, GameState13_setGameStateMakeSpriteVisible         ; $168d

	ld   a, GS_GAME_MUSIC_TYPE_INIT                            ; $168f
	bit  PADB_B, b                                             ; $1691
	jr   nz, GameState13_setGameStateMakeSpriteVisible         ; $1693

; check directions
	ld   a, [hl]                                               ; $1695
	bit  PADB_RIGHT, b                                         ; $1696
	jr   nz, .pressedRight                                     ; $1698

	bit  PADB_LEFT, b                                          ; $169a
	jr   nz, .pressedLeft                                      ; $169c

	bit  PADB_UP, b                                            ; $169e
	jr   nz, .pressedUp                                        ; $16a0

	bit  PADB_DOWN, b                                          ; $16a2
	jr   z, .sendToOam                                         ; $16a4

; pressed down, +5 if not on bottom row
	cp   $05                                                   ; $16a6
	jr   nc, .sendToOam                                        ; $16a8

	add  $05                                                   ; $16aa
	jr   .setNewSpriteCoords                                   ; $16ac

.pressedRight:
; wrap around from 4 to 5, dont go past 9
	cp   $09                                                   ; $16ae
	jr   z, .sendToOam                                         ; $16b0

	inc  a                                                     ; $16b2

.setNewSpriteCoords:
; set level, and display sprite appropriately
	ld   [hl], a                                               ; $16b3
	ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $16b4
	ld   hl, BTypeLevelsCoords                                 ; $16b7
	call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $16ba

; display scores for new level
	call DisplayBTypeHighScoresForLevel                        ; $16bd

.sendToOam:
	call Copy2SpriteSpecsToShadowOam                           ; $16c0
	ret                                                        ; $16c3

.pressedLeft:
; allow if not at 0, ie wrap from 5 to 4
	and  a                                                     ; $16c4
	jr   z, .sendToOam                                         ; $16c5

	dec  a                                                     ; $16c7
	jr   .setNewSpriteCoords                                   ; $16c8

.pressedUp:
; allow, -5, if not on top row already
	cp   $05                                                   ; $16ca
	jr   c, .sendToOam                                         ; $16cc

	sub  $05                                                   ; $16ce
	jr   .setNewSpriteCoords                                   ; $16d0


BTypeLevelsCoords:
	db $40, $18
	db $40, $28
	db $40, $38
	db $40, $48
	db $40, $58
	db $50, $18
	db $50, $28
	db $50, $38
	db $50, $48
	db $50, $58



GameState14_setGameStateMakeSpriteVisible:
	ldh  [hGameState], a                                       ; $16e6
	xor  a                                                     ; $16e8
	ld   [de], a                                               ; $16e9
	ret                                                        ; $16ea


GameState14_BTypeHighMain:
	ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF                      ; $16eb
	call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $16ee
	ld   hl, hBTypeHigh                                        ; $16f1

; go to in-game init state when start or A pressed
	ld   a, GS_IN_GAME_INIT                                    ; $16f4
	bit  PADB_START, b                                         ; $16f6
	jr   nz, GameState14_setGameStateMakeSpriteVisible         ; $16f8

	bit  PADB_A, b                                             ; $16fa
	jr   nz, GameState14_setGameStateMakeSpriteVisible         ; $16fc

; go back to level state if pressing B
	ld   a, GS_B_TYPE_SELECTION_MAIN                           ; $16fe
	bit  PADB_B, b                                             ; $1700
	jr   nz, GameState14_setGameStateMakeSpriteVisible         ; $1702

; check directionals
	ld   a, [hl]                                               ; $1704
	bit  PADB_RIGHT, b                                         ; $1705
	jr   nz, .pressedRight                                     ; $1707

	bit  PADB_LEFT, b                                          ; $1709
	jr   nz, .pressedLeft                                      ; $170b

	bit  PADB_UP, b                                            ; $170d
	jr   nz, .pressedUp                                        ; $170f

	bit  PADB_DOWN, b                                          ; $1711
	jr   z, .sendToOam                                         ; $1713

; pressed down, +3 if not on bottom row
	cp   $03                                                   ; $1715
	jr   nc, .sendToOam                                        ; $1717

	add  $03                                                   ; $1719
	jr   .setNewHighSpriteCoords                               ; $171b

.pressedRight:
; +1 if not at 5 already, ie wrap from 2 to 3
	cp   $05                                                   ; $171d
	jr   z, .sendToOam                                         ; $171f

	inc  a                                                     ; $1721

.setNewHighSpriteCoords:
; set new high's coords
	ld   [hl], a                                               ; $1722
	ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset ; $1723
	ld   hl, BTypeHighsCoords                                  ; $1726
	call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $1729

; display relevant scores for level+high
	call DisplayBTypeHighScoresForLevel                        ; $172c

.sendToOam:
	call Copy2SpriteSpecsToShadowOam                           ; $172f
	ret                                                        ; $1732

.pressedLeft:
; -1 when not on 0, ie wrap from 3 to 2
	and  a                                                     ; $1733
	jr   z, .sendToOam                                         ; $1734

	dec  a                                                     ; $1736
	jr   .setNewHighSpriteCoords                               ; $1737

.pressedUp:
; -3 if not on top row
	cp   $03                                                   ; $1739
	jr   c, .sendToOam                                         ; $173b

	sub  $03                                                   ; $173d
	jr   .setNewHighSpriteCoords                               ; $173f


BTypeHighsCoords:
	db $40, $70
	db $40, $80
	db $40, $90
	db $50, $70
	db $50, $80
	db $50, $90


UnusedNop_174d:
	nop                                                        ; $174d


PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable:
	push af                                                    ; $174e
	ld   a, SND_MOVING_SELECTION                               ; $174f
	ld   [wSquareSoundToPlay], a                               ; $1751
	pop  af                                                    ; $1754

SetNumberSpecStructsCoordsAndSpecIdxFromHLtable:
	push af                                                    ; $1755
; hl += 2a
	add  a                                                     ; $1756
	ld   c, a                                                  ; $1757
	ld   b, $00                                                ; $1758
	add  hl, bc                                                ; $175a

; copy y/x from hl table to de
	ld   a, [hl+]                                              ; $175b
	ld   [de], a                                               ; $175c
	inc  de                                                    ; $175d
	ld   a, [hl]                                               ; $175e
	ld   [de], a                                               ; $175f
	inc  de                                                    ; $1760
	pop  af                                                    ; $1761

; then spec idx
	add  SPRITE_SPEC_IDX_0                                     ; $1762
	ld   [de], a                                               ; $1764
	ret                                                        ; $1765


; in: DE - sprite spec address
; out: B - buttons pressed
GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden:
; alternate every $10 frames
	ldh  a, [hButtonsPressed]                                  ; $1766
	ld   b, a                                                  ; $1768
	ldh  a, [hTimer1]                                          ; $1769
	and  a                                                     ; $176b
	ret  nz                                                    ; $176c

	ld   a, $10                                                ; $176d
	ldh  [hTimer1], a                                          ; $176f

; flip visibility
	ld   a, [de]                                               ; $1771
	xor  SPRITE_SPEC_HIDDEN                                    ; $1772
	ld   [de], a                                               ; $1774
	ret                                                        ; $1775


CopyCSpriteSpecStructsFromDEtoHL:
.nextSpriteSpec:
; 6 sprite spec values copied from de to hl
	push hl                                                    ; $1776
	ld   b, $06                                                ; $1777

.loop:
	ld   a, [de]                                               ; $1779
	ld   [hl+], a                                              ; $177a
	inc  de                                                    ; $177b
	dec  b                                                     ; $177c
	jr   nz, .loop                                             ; $177d

; add $10 for next sprite spec
	pop  hl                                                    ; $177f
	ld   a, $10                                                ; $1780
	add  l                                                     ; $1782
	ld   l, a                                                  ; $1783
	dec  c                                                     ; $1784
	jr   nz, .nextSpriteSpec                                   ; $1785

; end with $80
	ld   [hl], $80                                             ; $1787
	ret                                                        ; $1789


Clear_wOam:
	xor  a                                                     ; $178a
	ld   hl, wOam                                              ; $178b
	ld   b, wOam.end-wOam                                      ; $178e

.loop:
	ld   [hl+], a                                              ; $1790
	dec  b                                                     ; $1791
	jr   nz, .loop                                             ; $1792

	ret                                                        ; $1794


DisplayATypeHighScoresForLevel:
	call DisplayDottedLinesForHighScore                        ; $1795

; loop until we get the high score address for the current level
	ldh  a, [hATypeLevel]                                      ; $1798
	ld   hl, wATypeHighScores                                  ; $179a
	ld   de, HISCORE_SIZEOF                                    ; $179d

.decA:
	and  a                                                     ; $17a0
	jr   z, .afterHiScoreAddrForLevel                          ; $17a1

	dec  a                                                     ; $17a3
	add  hl, de                                                ; $17a4
	jr   .decA                                                 ; $17a5

.afterHiScoreAddrForLevel:
; go to highest byte of score 1, and put in DE
	inc  hl                                                    ; $17a7
	inc  hl                                                    ; $17a8
	push hl                                                    ; $17a9
	pop  de                                                    ; $17aa
	call SetNewHighScoreIfAchieved_SendNameAndScoreToRamBuffer ; $17ab
	ret                                                        ; $17ae


DisplayBTypeHighScoresForLevel:
	call DisplayDottedLinesForHighScore                        ; $17af
	ldh  a, [hBTypeLevel]                                      ; $17b2
	ld   hl, wBTypeHighScores                                  ; $17b4
	ld   de, HISCORE_SIZEOF * 6                                ; $17b7

; loop until we get the high score address for the current level
.decA1:
	and  a                                                     ; $17ba
	jr   z, .afterHiScoreAddrForLevel                          ; $17bb

	dec  a                                                     ; $17bd
	add  hl, de                                                ; $17be
	jr   .decA1                                                ; $17bf

.afterHiScoreAddrForLevel:
	ldh  a, [hBTypeHigh]                                       ; $17c1
	ld   de, HISCORE_SIZEOF                                    ; $17c3

; loop until we get the high score address for the current high in level
.decA2:
	and  a                                                     ; $17c6
	jr   z, .afterHiScoreAddrForLevelAndHigh                   ; $17c7

	dec  a                                                     ; $17c9
	add  hl, de                                                ; $17ca
	jr   .decA2                                                ; $17cb

.afterHiScoreAddrForLevelAndHigh:
; go to highest byte of score 1, and put in DE
	inc  hl                                                    ; $17cd
	inc  hl                                                    ; $17ce
	push hl                                                    ; $17cf
	pop  de                                                    ; $17d0
	call SetNewHighScoreIfAchieved_SendNameAndScoreToRamBuffer ; $17d1
	ret                                                        ; $17d4


; in: HL - ram location of high score
; in: DE - game screen buffer for high score
CopyHighScoreValueToRamBuffer:
	ld   b, $03                                                ; $17d5

.nextByteToCheckIfEmpty:
; stay in upper loop, while highest digit not found
	ld   a, [hl]                                               ; $17d7
	and  $f0                                                   ; $17d8
	jr   nz, .hasTens                                          ; $17da

; check digits
	inc  e                                                     ; $17dc
	ld   a, [hl-]                                              ; $17dd
	and  $0f                                                   ; $17de
	jr   nz, .storeDigits                                      ; $17e0

	inc  e                                                     ; $17e2
	dec  b                                                     ; $17e3
	jr   nz, .nextByteToCheckIfEmpty                           ; $17e4

	ret                                                        ; $17e6

.hasTens:
; store 10s in dest
	ld   a, [hl]                                               ; $17e7
	and  $f0                                                   ; $17e8
	swap a                                                     ; $17ea
	ld   [de], a                                               ; $17ec

; get digits
	inc  e                                                     ; $17ed
	ld   a, [hl-]                                              ; $17ee
	and  $0f                                                   ; $17ef

.storeDigits:
	ld   [de], a                                               ; $17f1
	inc  e                                                     ; $17f2

; check next byte
	dec  b                                                     ; $17f3
	jr   nz, .hasTens                                          ; $17f4

	ret                                                        ; $17f6


CopyHLtoDEbackwards_3bytes:
	ld   b, $03                                                ; $17f7

CopyHLtoDEbackwards_Bbytes:
.loop:
	ld   a, [hl-]                                              ; $17f9
	ld   [de], a                                               ; $17fa
	dec  de                                                    ; $17fb
	dec  b                                                     ; $17fc
	jr   nz, .loop                                             ; $17fd

	ret                                                        ; $17ff


SetNewHighScoreIfAchieved_SendNameAndScoreToRamBuffer:
; store address of 3-byte BCD
	ld   a, d                                                  ; $1800
	ldh  [h1stHighScoreHighestByteForLevel], a                 ; $1801
	ld   a, e                                                  ; $1803
	ldh  [h1stHighScoreHighestByteForLevel+1], a               ; $1804

; check 3 high scores
	ld   c, $03                                                ; $1806

.nextHiScore:
; push current high score's highest byte
	ld   hl, wScoreBCD+2                                       ; $1808
	push de                                                    ; $180b
	ld   b, $03                                                ; $180c

.nextScoreByteToCompare:
; once current high score - current score yields a carry, jump
	ld   a, [de]                                               ; $180e
	sub  [hl]                                                  ; $180f
	jr   c, .currScoreHigherThanAHighScore                     ; $1810

	jr   nz, .toNextHiScore                                    ; $1812

	dec  l                                                     ; $1814
	dec  de                                                    ; $1815
	dec  b                                                     ; $1816
	jr   nz, .nextScoreByteToCompare                           ; $1817

.toNextHiScore:
; de += 3 to next
	pop  de                                                    ; $1819
	inc  de                                                    ; $181a
	inc  de                                                    ; $181b
	inc  de                                                    ; $181c
	dec  c                                                     ; $181d
	jr   nz, .nextHiScore                                      ; $181e

	jr   .afterNoHighScore                                     ; $1820

.currScoreHigherThanAHighScore:
; popped de is current high score's highest byte
	pop  de                                                    ; $1822

; get highest byte of 1st high score
	ldh  a, [h1stHighScoreHighestByteForLevel]                 ; $1823
	ld   d, a                                                  ; $1825
	ldh  a, [h1stHighScoreHighestByteForLevel+1]               ; $1826
	ld   e, a                                                  ; $1828

	push de                                                    ; $1829
	push bc                                                    ; $182a

; de = highest byte of 3rd high score
	ld   hl, $0006                                             ; $182b
	add  hl, de                                                ; $182e
	push hl                                                    ; $182f
	pop  de                                                    ; $1830

; hl = highest byte of 2nd high score
	dec  hl                                                    ; $1831
	dec  hl                                                    ; $1832
	dec  hl                                                    ; $1833

; c = 3 if curr score > 1st high score
; c = 2 if curr score > 2nd high score
; c = 1 if curr score > 3rd high score
.shiftLowerScoresDown:
; eg if score > 1st high score, then 2 times we want to shift a score down (2nd + 3rd)
	dec  c                                                     ; $1834
	jr   z, .setCurrHighScore                                  ; $1835

	call CopyHLtoDEbackwards_3bytes                            ; $1837
	jr   .shiftLowerScoresDown                                 ; $183a

.setCurrHighScore:
; copy curr score into its high score
	ld   hl, wScoreBCD+2                                       ; $183c
	ld   b, $03                                                ; $183f

.setCurrLoop:
	ld   a, [hl-]                                              ; $1841
	ld   [de], a                                               ; $1842
	dec  e                                                     ; $1843
	dec  b                                                     ; $1844
	jr   nz, .setCurrLoop                                      ; $1845

; pop above C=3 to 1, and above highest byte of 1st high score
	pop  bc                                                    ; $1847
	pop  de                                                    ; $1848

; store C
	ld   a, c                                                  ; $1849
	ldh  [hReversedHighScoreRanking], a                        ; $184a

; later hl = highest byte of 2nd high score name
	ld   hl, $0012                                             ; $184c
	add  hl, de                                                ; $184f
	push hl                                                    ; $1850

; later de = highest byte of 3rd high score name
	ld   de, $0006                                             ; $1851
	add  hl, de                                                ; $1854
	push hl                                                    ; $1855
	pop  de                                                    ; $1856
	pop  hl                                                    ; $1857

; similar to above, but with names
.shiftLowerNamesDown:
	dec  c                                                     ; $1858
	jr   z, .setCurrName                                       ; $1859

	ld   b, $06                                                ; $185b
	call CopyHLtoDEbackwards_Bbytes                            ; $185d
	jr   .shiftLowerNamesDown                                  ; $1860

; name starts dotted, with A in 1st spot
.setCurrName:
	ld   a, "<...>"                                            ; $1862
	ld   b, $05                                                ; $1864

.copyDottedName:
	ld   [de], a                                               ; $1866
	dec  de                                                    ; $1867
	dec  b                                                     ; $1868
	jr   nz, .copyDottedName                                   ; $1869

	ld   a, "A"                                                ; $186b
	ld   [de], a                                               ; $186d

; store A ram location
	ld   a, d                                                  ; $186e
	ldh  [hTypedTextCharLoc], a                                ; $186f
	ld   a, e                                                  ; $1871
	ldh  [hTypedTextCharLoc+1], a                              ; $1872

; flash counter and letter counter
	xor  a                                                     ; $1874
	ldh  [hTetrisFlashCount], a                                ; $1875
	ldh  [hTypedLetterCounter], a                              ; $1877

; play relevant song and set must enter high score, to go to correct state
	ld   a, MUS_ENTER_HIGH_SCORE                               ; $1879
	ld   [wSongToStart], a                                     ; $187b
	ldh  [hMustEnterHighScore], a                              ; $187e

.afterNoHighScore:
; de is ram address for 1st place high score value
	ld   de, wGameScreenBuffer+$1ac                            ; $1880
	ldh  a, [h1stHighScoreHighestByteForLevel]                 ; $1883
	ld   h, a                                                  ; $1885
	ldh  a, [h1stHighScoreHighestByteForLevel+1]               ; $1886
	ld   l, a                                                  ; $1888

; send to ram buffer, the 3 relevant high scores
	ld   b, $03                                                ; $1889

.displayNextScore:
; preserve high score ram src, ram buffer, and B
	push hl                                                    ; $188b
	push de                                                    ; $188c
	push bc                                                    ; $188d

	call CopyHighScoreValueToRamBuffer                         ; $188e

; restore ram buffer dest and B, adding a row onto ram buffer dest for next score
	pop  bc                                                    ; $1891
	pop  de                                                    ; $1892
	ld   hl, GB_TILE_WIDTH                                     ; $1893
	add  hl, de                                                ; $1896
	push hl                                                    ; $1897
	pop  de                                                    ; $1898

; restore hl
	pop  hl                                                    ; $1899

; add 3 onto hl for next score
	push de                                                    ; $189a
	ld   de, $0003                                             ; $189b
	add  hl, de                                                ; $189e
	pop  de                                                    ; $189f
	dec  b                                                     ; $18a0
	jr   nz, .displayNextScore                                 ; $18a1

; hl = lowest byte of 1st name
	dec  hl                                                    ; $18a3
	dec  hl                                                    ; $18a4

; show relevant names for high scores
	ld   b, $03                                                ; $18a5
	ld   de, wGameScreenBuffer+$1a4                            ; $18a7

.displayNextName:
	push de                                                    ; $18aa
	ld   c, $06                                                ; $18ab

.nextNameChar:
; if before 6 chars are drawn, a blank spot is found, go to next name
	ld   a, [hl+]                                              ; $18ad
	and  a                                                     ; $18ae
	jr   z, .toNextName                                        ; $18af

; store and do next char
	ld   [de], a                                               ; $18b1
	inc  de                                                    ; $18b2
	dec  c                                                     ; $18b3
	jr   nz, .nextNameChar                                     ; $18b4

.toNextName:
; de ram buffer dest is next row
	pop  de                                                    ; $18b6
	push hl                                                    ; $18b7
	ld   hl, GB_TILE_WIDTH                                     ; $18b8
	add  hl, de                                                ; $18bb
	push hl                                                    ; $18bc
	pop  de                                                    ; $18bd

; next name
	pop  hl                                                    ; $18be
	dec  b                                                     ; $18bf
	jr   nz, .displayNextName                                  ; $18c0

; clear score vars
	call ClearScoreCategoryVarsAndTotalScore                   ; $18c2

	ld   a, $01                                                ; $18c5
	ldh  [hJustSetHighScoreAndCopiedToRamBuffer], a            ; $18c7
	ret                                                        ; $18c9


DisplayHighScoresAndNamesForLevel:
	ldh  a, [hJustSetHighScoreAndCopiedToRamBuffer]            ; $18ca
	and  a                                                     ; $18cc
	ret  z                                                     ; $18cd

; dest and src for names
	ld   hl, _SCRN0+$1a4                                       ; $18ce
	ld   de, wGameScreenBuffer+$1a4                            ; $18d1

; 3 names and 3 scores
	ld   c, $06                                                ; $18d4

.nextHighScore:
	push hl                                                    ; $18d6

.next6chars:
; copy whole name from buffer to vram
	ld   b, $06                                                ; $18d7

.copyName:
	ld   a, [de]                                               ; $18d9
	ld   [hl+], a                                              ; $18da
	inc  e                                                     ; $18db
	dec  b                                                     ; $18dc
	jr   nz, .copyName                                         ; $18dd

; hl/de = score
	inc  e                                                     ; $18df
	inc  l                                                     ; $18e0
	inc  e                                                     ; $18e1
	inc  l                                                     ; $18e2
	dec  c                                                     ; $18e3
	jr   z, .end                                               ; $18e4

; loop to next if next is score
	bit  0, c                                                  ; $18e6
	jr   nz, .next6chars                                       ; $18e8

; after score, go to next row
	pop  hl                                                    ; $18ea
	ld   de, GB_TILE_WIDTH                                     ; $18eb
	add  hl, de                                                ; $18ee
	push hl                                                    ; $18ef
	pop  de                                                    ; $18f0

; de is screen buffer again
	ld   a, HIGH(wGameScreenBuffer-_SCRN0)                     ; $18f1
	add  d                                                     ; $18f3
	ld   d, a                                                  ; $18f4
	jr   .nextHighScore                                        ; $18f5

.end:
	pop  hl                                                    ; $18f7
	xor  a                                                     ; $18f8
	ldh  [hJustSetHighScoreAndCopiedToRamBuffer], a            ; $18f9
	ret                                                        ; $18fb


DisplayDottedLinesForHighScore:
	ld   hl, wGameScreenBuffer+$1a4                            ; $18fc
	ld   de, GB_TILE_WIDTH                                     ; $18ff
	ld   a, "<...>"                                            ; $1902

; 3 rows of high screo
	ld   c, $03                                                ; $1904

.nextRow:
; this many cols
	ld   b, $0e                                                ; $1906
	push hl                                                    ; $1908

.nextCol:
	ld   [hl+], a                                              ; $1909
	dec  b                                                     ; $190a
	jr   nz, .nextCol                                          ; $190b

; inc to next vram row
	pop  hl                                                    ; $190d
	add  hl, de                                                ; $190e
	dec  c                                                     ; $190f
	jr   nz, .nextRow                                          ; $1910

	ret                                                        ; $1912


GameState15_EnteringHighScore:
	ldh  a, [hReversedHighScoreRanking]                        ; $1913

; hl = 3rd high score name 1st char
	ld   hl, _SCRN0+$1e4                                       ; $1915
	ld   de, -$20                                              ; $1918

; loop getting right vram dest based on ranking
.decA:
	dec  a                                                     ; $191b
	jr   z, .afterRamDestAddrForScore                          ; $191c

	add  hl, de                                                ; $191e
	jr   .decA                                                 ; $191f

.afterRamDestAddrForScore:
; go to dest based on which letter we're typing
	ldh  a, [hTypedLetterCounter]                              ; $1921
	ld   e, a                                                  ; $1923
	ld   d, $00                                                ; $1924
	add  hl, de                                                ; $1926

; get ram src of typed chars
	ldh  a, [hTypedTextCharLoc]                                ; $1927
	ld   d, a                                                  ; $1929
	ldh  a, [hTypedTextCharLoc+1]                              ; $192a
	ld   e, a                                                  ; $192c

; every 7 frames..
	ldh  a, [hTimer1]                                          ; $192d
	and  a                                                     ; $192f
	jr   nz, .afterTimerCheck                                  ; $1930

	ld   a, $07                                                ; $1932
	ldh  [hTimer1], a                                          ; $1934

; flash current letter
	ldh  a, [hTetrisFlashCount]                                ; $1936
	xor  $01                                                   ; $1938
	ldh  [hTetrisFlashCount], a                                ; $193a

; if curr char is 0, display empty, otherwise curr char
	ld   a, [de]                                               ; $193c
	jr   z, .setTile                                           ; $193d

	ld   a, TILE_EMPTY                                         ; $193f

.setTile:
	call StoreAinHLwhenLCDFree                                 ; $1941

.afterTimerCheck:
	ldh  a, [hButtonsPressed]                                  ; $1944
	ld   b, a                                                  ; $1946
	ldh  a, [hButtonsHeld]                                     ; $1947
	ld   c, a                                                  ; $1949

; initial sticky counter
	ld   a, $17                                                ; $194a
	bit  PADB_UP, b                                            ; $194c
	jr   nz, .upPressed                                        ; $194e

	bit  PADB_UP, c                                            ; $1950
	jr   nz, .upHeld                                           ; $1952

	bit  PADB_DOWN, b                                          ; $1954
	jr   nz, .downPressed                                      ; $1956

	bit  PADB_DOWN, c                                          ; $1958
	jr   nz, .downHeld                                         ; $195a

	bit  PADB_A, b                                             ; $195c
	jr   nz, .aPressed                                         ; $195e

	bit  PADB_B, b                                             ; $1960
	jp   nz, .bPressed                                         ; $1962

	bit  PADB_START, b                                         ; $1965
	ret  z                                                     ; $1967

.done:
	ld   a, [de]                                               ; $1968
	call StoreAinHLwhenLCDFree                                 ; $1969
	call PlaySongBasedOnMusicTypeChosen                        ; $196c
	xor  a                                                     ; $196f
	ldh  [hMustEnterHighScore], a                              ; $1970

; set relevant state based on game type
	ldh  a, [hGameType]                                        ; $1972
	cp   GAME_TYPE_A_TYPE                                      ; $1974
	ld   a, GS_A_TYPE_SELECTION_MAIN                           ; $1976
	jr   z, .setGameState                                      ; $1978

	ld   a, GS_B_TYPE_SELECTION_MAIN                           ; $197a

.setGameState:
	ldh  [hGameState], a                                       ; $197c
	ret                                                        ; $197e

.upHeld:
; process up every 9 frames
	ldh  a, [hStickyButtonCounter]                             ; $197f
	dec  a                                                     ; $1981
	ldh  [hStickyButtonCounter], a                             ; $1982
	ret  nz                                                    ; $1984

	ld   a, $09                                                ; $1985

.upPressed:
	ldh  [hStickyButtonCounter], a                             ; $1987

; allow heart in hard mode
	ld   b, "*"                                                ; $1989
	ldh  a, [hIsHardMode]                                      ; $198b
	and  a                                                     ; $198d
	jr   z, .afterUpHardModeCheck                              ; $198e

	ld   b, "<3"                                               ; $1990

.afterUpHardModeCheck:
	ld   a, [de]                                               ; $1992
	cp   b                                                     ; $1993
	jr   nz, .notUpLastChar                                    ; $1994

	ld   a, TILE_EMPTY-1                                       ; $1996

.incChar:
	inc  a                                                     ; $1998

.setChar:
	ld   [de], a                                               ; $1999
	ld   a, SND_MOVING_SELECTION                               ; $199a
	ld   [wSquareSoundToPlay], a                               ; $199c
	ret                                                        ; $199f

.notUpLastChar:
; if not last char or blank, inc to next char
	cp   TILE_EMPTY                                            ; $19a0
	jr   nz, .incChar                                          ; $19a2

; if blank, go to A
	ld   a, "A"                                                ; $19a4
	jr   .setChar                                              ; $19a6

.downHeld:
; process down every 9 frames
	ldh  a, [hStickyButtonCounter]                             ; $19a8
	dec  a                                                     ; $19aa
	ldh  [hStickyButtonCounter], a                             ; $19ab
	ret  nz                                                    ; $19ad

	ld   a, $09                                                ; $19ae

.downPressed:
	ldh  [hStickyButtonCounter], a                             ; $19b0

; allow heart in hard mode
	ld   b, "*"                                                ; $19b2
	ldh  a, [hIsHardMode]                                      ; $19b4
	and  a                                                     ; $19b6
	jr   z, .afterDownHardModeCheck                            ; $19b7

	ld   b, "<3"                                               ; $19b9

.afterDownHardModeCheck:
; check if at A already
	ld   a, [de]                                               ; $19bb
	cp   "A"                                                   ; $19bc
	jr   nz, .notDownLastChar                                  ; $19be

	ld   a, TILE_EMPTY+1                                       ; $19c0

.decChar:
	dec  a                                                     ; $19c2
	jr   .setChar                                              ; $19c3

.notDownLastChar:
; check if blank tile (next is the x or <3)
	cp   TILE_EMPTY                                            ; $19c5
	jr   nz, .decChar                                          ; $19c7

	ld   a, b                                                  ; $19c9
	jr   .setChar                                              ; $19ca

.aPressed:
; store selection in LCD
	ld   a, [de]                                               ; $19cc
	call StoreAinHLwhenLCDFree                                 ; $19cd
	ld   a, SND_CONFIRM_OR_LETTER_TYPED                        ; $19d0
	ld   [wSquareSoundToPlay], a                               ; $19d2

; inc letter counter, finishing when 6 letters done
	ldh  a, [hTypedLetterCounter]                              ; $19d5
	inc  a                                                     ; $19d7
	cp   $06                                                   ; $19d8
	jr   z, .done                                              ; $19da

	ldh  [hTypedLetterCounter], a                              ; $19dc

; go to next ram src, setting it as A by default
	inc  de                                                    ; $19de
	ld   a, [de]                                               ; $19df
	cp   "<...>"                                               ; $19e0
	jr   nz, .setNextCharLoc                                   ; $19e2

	ld   a, "A"                                                ; $19e4
	ld   [de], a                                               ; $19e6

.setNextCharLoc:
	ld   a, d                                                  ; $19e7
	ldh  [hTypedTextCharLoc], a                                ; $19e8
	ld   a, e                                                  ; $19ea
	ldh  [hTypedTextCharLoc+1], a                              ; $19eb
	ret                                                        ; $19ed

.bPressed:
; if at 1st letter, return
	ldh  a, [hTypedLetterCounter]                              ; $19ee
	and  a                                                     ; $19f0
	ret  z                                                     ; $19f1

; store current letter in LCD
	ld   a, [de]                                               ; $19f2
	call StoreAinHLwhenLCDFree                                 ; $19f3

; dec counter and position in vram, then set char loc
	ldh  a, [hTypedLetterCounter]                              ; $19f6
	dec  a                                                     ; $19f8
	ldh  [hTypedLetterCounter], a                              ; $19f9
	dec  de                                                    ; $19fb
	jr   .setNextCharLoc                                       ; $19fc

	
StoreAinHLwhenLCDFree:
	ld   b, a                                                  ; $19fe

StoreBinHLwhenLCDFree:
.waitUntilVramAndOamFree:
	ldh  a, [rSTAT]                                            ; $19ff
	and  STATF_LCD                                             ; $1a01
	jr   nz, .waitUntilVramAndOamFree                          ; $1a03

	ld   [hl], b                                               ; $1a05
	ret                                                        ; $1a06


GameState0a_InGameInit:
; turn off lcd and clear some in-game vars
	call TurnOffLCD                                            ; $1a07
	xor  a                                                     ; $1a0a
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $1a0b
	ldh  [hPieceFallingState], a                               ; $1a0e
	ldh  [hTetrisFlashCount], a                                ; $1a10
	ldh  [hPieceCollisionDetected], a                          ; $1a12
	ldh  [h1stHighScoreHighestByteForLevel], a                 ; $1a14
	ldh  [hNumLinesCompletedBCD+1], a                          ; $1a16

; clear ram buffer
	ld   a, TILE_EMPTY                                         ; $1a18
	call FillGameScreenBufferWithTileAandSetToVramTransfer     ; $1a1a
	call FillBottom2RowsOfTileMapWithEmptyTile                 ; $1a1d

; clear scores, row shifting var and oam
	call ClearScoreCategoryVarsAndTotalScore                   ; $1a20
	lda ROWS_SHIFTING_DOWN_NONE                                ; $1a23
	ldh  [hRowsShiftingDownState], a                           ; $1a24
	call Clear_wOam                                            ; $1a26

; based on game type, get layout address in DE, level to check in HL
; and vram dest low byte of level number in A
	ldh  a, [hGameType]                                        ; $1a29

	ld   de, Layout_BTypeInGame                                ; $1a2b
	ld   hl, hBTypeLevel                                       ; $1a2e
	cp   GAME_TYPE_B_TYPE                                      ; $1a31
	ld   a, LOW($9850)                                         ; $1a33
	jr   z, .afterGameTypeCheck                                ; $1a35

; is A-type
	ld   a, LOW($98f1)                                         ; $1a37
	ld   hl, hATypeLevel                                       ; $1a39
	ld   de, Layout_ATypeInGame                                ; $1a3c

.afterGameTypeCheck:
; cache vram dest for level
	push de                                                    ; $1a3f
	ldh  [hLowByteOfVramDestForLevelNum], a                    ; $1a40

; level is also lines threshold to pass, eg for 0, pass 10, for 1, pass 20
	ld   a, [hl]                                               ; $1a42
	ldh  [hATypeLinesThresholdToPassForNextLevel], a           ; $1a43

; copy layout, pop layout address and draw to screen 1 as well
	call CopyLayoutToScreen0                                   ; $1a45
	pop  de                                                    ; $1a48
	ld   hl, _SCRN1                                            ; $1a49
	call CopyLayoutToHL                                        ; $1a4c

; screen 1 is for pause text
	ld   de, GameInnerScreenLayout_Pause                       ; $1a4f
	ld   hl, _SCRN1+$63                                        ; $1a52
	ld   c, $0a                                                ; $1a55
	call CopyGameScreenInnerText                               ; $1a57

; get vram dest address for level num
	ld   h, HIGH(_SCRN0)                                       ; $1a5a
	ldh  a, [hLowByteOfVramDestForLevelNum]                    ; $1a5c
	ld   l, a                                                  ; $1a5e

; store level in vram dest and screen 1
	ldh  a, [hATypeLinesThresholdToPassForNextLevel]           ; $1a5f
	ld   [hl], a                                               ; $1a61
	ld   h, HIGH(_SCRN1)                                       ; $1a62
	ld   [hl], a                                               ; $1a64

; if hard mode..
	ldh  a, [hIsHardMode]                                      ; $1a65
	and  a                                                     ; $1a67
	jr   z, .afterHardModeCheck                                ; $1a68

; draw hearts as well
	inc  hl                                                    ; $1a6a
	ld   [hl], "<3"                                            ; $1a6b
	ld   h, HIGH(_SCRN0)                                       ; $1a6d
	ld   [hl], "<3"                                            ; $1a6f

.afterHardModeCheck:
; copy sprite specs over for active and next piece
	ld   hl, wSpriteSpecs                                      ; $1a71
	ld   de, SpriteSpecStruct_LPieceActive                     ; $1a74
	call CopyDEintoHLwhileFFhNotFound                          ; $1a77

	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                      ; $1a7a
	ld   de, SpriteSpecStruct_LPieceNext                       ; $1a7d
	call CopyDEintoHLwhileFFhNotFound                          ; $1a80

; address of num lines
	ld   hl, _SCRN0+$151                                       ; $1a83

; num lines completed starts at 25 for B Type (counting down to 0)
	ldh  a, [hGameType]                                        ; $1a86
	cp   GAME_TYPE_B_TYPE                                      ; $1a88
	ld   a, $25                                                ; $1a8a
	jr   z, .setNumLinesCompleted                              ; $1a8c

	xor  a                                                     ; $1a8e

.setNumLinesCompleted:
	ldh  [hNumLinesCompletedBCD], a                            ; $1a8f

; store low byte of num lines
	and  $0f                                                   ; $1a91
	ld   [hl-], a                                              ; $1a93
	jr   z, .setFramesUntilPieceMovesDown                      ; $1a94

; for B Type, also store the 2 from 25
	ld   [hl], $02                                             ; $1a96

.setFramesUntilPieceMovesDown:
	call SetNumFramesUntilPiecesMoveDown                       ; $1a98

; if next piece hidden var set, make sure its written to spec
	ld   a, [wNextPieceHidden]                                 ; $1a9b
	and  a                                                     ; $1a9e
	jr   z, .afterPieceHiddenCheck                             ; $1a9f

	ld   a, SPRITE_SPEC_HIDDEN                                 ; $1aa1
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $1aa3

.afterPieceHiddenCheck:

; load hidden piece
	call PlayNextPieceLoadNextAndHiddenPiece                   ; $1aa6
; load next piece and hidden piece
	call PlayNextPieceLoadNextAndHiddenPiece                   ; $1aa9
; load played piece, next piece and hidden piece
	call PlayNextPieceLoadNextAndHiddenPiece                   ; $1aac

; copy active sprite over
	call Copy1stSpriteSpecToSprite4                            ; $1aaf

; reset completed rows count
	xor  a                                                     ; $1ab2
	ldh  [hNumCompletedTetrisRows], a                          ; $1ab3

; end now if A Type
	ldh  a, [hGameType]                                        ; $1ab5
	cp   GAME_TYPE_B_TYPE                                      ; $1ab7
	jr   nz, .end                                              ; $1ab9

; B type, speed is slowest
	ld   a, $34                                                ; $1abb
	ldh  [hNumFramesUntilCurrPieceMovesDown], a                ; $1abd

; display high number in both screens
	ldh  a, [hBTypeHigh]                                       ; $1abf
	ld   hl, _SCRN0+$b0                                        ; $1ac1
	ld   [hl], a                                               ; $1ac4
	ld   h, HIGH(_SCRN1)                                       ; $1ac5
	ld   [hl], a                                               ; $1ac7
	and  a                                                     ; $1ac8
	jr   z, .end                                               ; $1ac9

; if high != 0, put in B
	ld   b, a                                                  ; $1acb

; set up game field for B type demo
	ldh  a, [hPrevOrCurrDemoPlayed]                            ; $1acc
	and  a                                                     ; $1ace
	jr   z, .notDemo                                           ; $1acf

	call PopulateDemoBTypeScreenWithBlocks                     ; $1ad1
	jr   .end                                                  ; $1ad4

.notDemo:
; B is non-0 high value, add a number of random blocks
	ld   a, b                                                  ; $1ad6
	ld   de, -$40                                              ; $1ad7
	ld   hl, _SCRN0+$202                                       ; $1ada
	call PopulateGameScreenWithRandomBlocks                    ; $1add

.end:
; turn on LCD and go to in-game
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $1ae0
	ldh  [rLCDC], a                                            ; $1ae2
	lda GS_IN_GAME_MAIN                                        ; $1ae4
	ldh  [hGameState], a                                       ; $1ae5
	ret                                                        ; $1ae7


SetNumFramesUntilPiecesMoveDown:
; speed is determined by num lines completed
	ldh  a, [hATypeLinesThresholdToPassForNextLevel]           ; $1ae8
	ld   e, a                                                  ; $1aea

; hard mode, +10
	ldh  a, [hIsHardMode]                                      ; $1aeb
	and  a                                                     ; $1aed
	jr   z, .setTopSpeedForPieces                              ; $1aee

	ld   a, $0a                                                ; $1af0
	add  e                                                     ; $1af2

; dont go higher than $14
	cp   $15                                                   ; $1af3
	jr   c, .getIndexInDE                                      ; $1af5

	ld   a, $14                                                ; $1af7

.getIndexInDE:
	ld   e, a                                                  ; $1af9

.setTopSpeedForPieces:
; get num frames needed for a piece to move down from table idxed DE
	ld   hl, .framesData                                       ; $1afa
	ld   d, $00                                                ; $1afd
	add  hl, de                                                ; $1aff
	ld   a, [hl]                                               ; $1b00
	ldh  [hNumFramesUntilCurrPieceMovesDown], a                ; $1b01
	ldh  [hNumFramesUntilPiecesMoveDown], a                    ; $1b03
	ret                                                        ; $1b05

.framesData:
	db $34, $30, $2c, $28, $24, $20, $1b, $15
	db $10, $0a, $09, $08, $07, $06, $05, $05
	db $04, $04, $03, $03, $02


PopulateDemoBTypeScreenWithBlocks:
	ld   hl, _SCRN0+$1c2                                       ; $1b1b
	ld   de, .layout                                           ; $1b1e
	ld   c, $04                                                ; $1b21

.nextRow:
	ld   b, GAME_SQUARE_WIDTH                                  ; $1b23
	push hl                                                    ; $1b25

.nextCol:
	ld   a, [de]                                               ; $1b26
	ld   [hl], a                                               ; $1b27
	push hl                                                    ; $1b28
	ld   a, h                                                  ; $1b29
	add  HIGH(wGameScreenBuffer-_SCRN0)                        ; $1b2a
	ld   h, a                                                  ; $1b2c
	ld   a, [de]                                               ; $1b2d
	ld   [hl], a                                               ; $1b2e
	pop  hl                                                    ; $1b2f
	inc  l                                                     ; $1b30
	inc  de                                                    ; $1b31
	dec  b                                                     ; $1b32
	jr   nz, .nextCol                                          ; $1b33

	pop  hl                                                    ; $1b35
	push de                                                    ; $1b36
	ld   de, GB_TILE_WIDTH                                     ; $1b37
	add  hl, de                                                ; $1b3a
	pop  de                                                    ; $1b3b
	dec  c                                                     ; $1b3c
	jr   nz, .nextRow                                          ; $1b3d

	ret                                                        ; $1b3f

.layout:
	db $85, $2f, $82, $86, $83, $2f, $2f, $80, $82, $85
	db $2f, $82, $84, $82, $83, $2f, $83, $2f, $87, $2f
	db $2f, $85, $2f, $83, $2f, $86, $82, $80, $81, $2f
	db $83, $2f, $86, $83, $2f, $85, $2f, $85, $2f, $2f


; in: A - num to multiply to DE
; in: DE - num rows of random blocks * -GB_TILE_WIDTH
; in: HL - vram dest start
PopulateGameScreenWithRandomBlocks:
	ld   b, a                                                  ; $1b68

.decB:
	dec  b                                                     ; $1b69
	jr   z, .mainLoop                                          ; $1b6a

	add  hl, de                                                ; $1b6c
	jr   .decB                                                 ; $1b6d

.mainLoop:
; random val in B
	ldh  a, [rDIV]                                             ; $1b6f
	ld   b, a                                                  ; $1b71

.fromWasTileEmpty:
	ld   a, TILE_PIECE_SQUARES_START                           ; $1b72

.toDecRandom:
	dec  b                                                     ; $1b74
	jr   z, .afterChoosingEmptyOrPieceSquare                   ; $1b75

; random val not 0 yet, jump every other loop
	cp   TILE_PIECE_SQUARES_START                              ; $1b77
	jr   nz, .fromWasTileEmpty                                 ; $1b79

; 1st, 3rd run etc - start with empty tile
	ld   a, TILE_EMPTY                                         ; $1b7b
	jr   .toDecRandom                                          ; $1b7d

.afterChoosingEmptyOrPieceSquare:
	cp   TILE_EMPTY                                            ; $1b7f
	jr   z, .pickedEmpty                                       ; $1b81

; if not empty, actually choose one of the 8 tiles from it
	ldh  a, [rDIV]                                             ; $1b83
	and  $07                                                   ; $1b85
	or   TILE_PIECE_SQUARES_START                              ; $1b87
	jr   .emptyOrActualPieceSquareChosen                       ; $1b89

.pickedEmpty:
	ldh  [hRandomSquareObstacleTileChosen], a                  ; $1b8b

.emptyOrActualPieceSquareChosen:
; push square chosen
	push af                                                    ; $1b8d

; if column equals $0b..
	ld   a, l                                                  ; $1b8e
	and  $0f                                                   ; $1b8f
	cp   $0b                                                   ; $1b91
	jr   nz, .popAFstoreChosenSquare                           ; $1b93

; at column $0b, use chosen square if previous chosen was empty
	ldh  a, [hRandomSquareObstacleTileChosen]                  ; $1b95
	cp   TILE_EMPTY                                            ; $1b97
	jr   z, .popAFstoreChosenSquare                            ; $1b99

; override square chosen with empty otherwise, so there is 1+ empty tiles per row
	pop  af                                                    ; $1b9b
	ld   a, TILE_EMPTY                                         ; $1b9c
	jr   .storeChosenSquare                                    ; $1b9e

.popAFstoreChosenSquare:
	pop  af                                                    ; $1ba0

.storeChosenSquare:
	ld   [hl], a                                               ; $1ba1

; push vram address of current square, and the chosen tile idx
	push hl                                                    ; $1ba2
	push af                                                    ; $1ba3

; skip storing in screen buffer if 2 player
	ldh  a, [hIs2Player]                                       ; $1ba4
	and  a                                                     ; $1ba6
	jr   nz, .from2player                                      ; $1ba7

; if single-player, store in screen buffer too
	ld   de, wGameScreenBuffer-_SCRN0                          ; $1ba9
	add  hl, de                                                ; $1bac

.from2player:
	pop  af                                                    ; $1bad
	ld   [hl], a                                               ; $1bae

; get vram dest of current tile, +1, and if it reaches the end (col $0c)...
; otherwise do next
	pop  hl                                                    ; $1baf
	inc  hl                                                    ; $1bb0
	ld   a, l                                                  ; $1bb1
	and  $0f                                                   ; $1bb2
	cp   $0c                                                   ; $1bb4
	jr   nz, .mainLoop                                         ; $1bb6

; allow non-empty tiles again
	xor  a                                                     ; $1bb8
	ldh  [hRandomSquareObstacleTileChosen], a                  ; $1bb9

; once we reach $9axx..
	ld   a, h                                                  ; $1bbb
	and  $0f                                                   ; $1bbc
	cp   $0a                                                   ; $1bbe
	jr   z, .vramDestHighEqu9ah                                ; $1bc0

.toNextRow:
	ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                   ; $1bc2
	add  hl, de                                                ; $1bc5
	jr   .mainLoop                                             ; $1bc6

; stop at $9a2c
.vramDestHighEqu9ah:
	ld   a, l                                                  ; $1bc8
	cp   LOW($9a2c)                                            ; $1bc9
	jr   nz, .toNextRow                                        ; $1bcb

	ret                                                        ; $1bcd


GameState00_InGameMain:
; ret if paused
	call InGameCheckResetAndPause.start                        ; $1bce
	ldh  a, [hGamePaused]                                      ; $1bd1
	and  a                                                     ; $1bd3
	ret  nz                                                    ; $1bd4

;
	call todo_demoRelated_050c                               ; $1bd5: $cd $0c $05
	call todo_demoRelated_0542                               ; $1bd8: $cd $42 $05
	call todo_demoRelated_0583                               ; $1bdb: $cd $83 $05

; regular main loop
	call InGameCheckButtonsPressed                             ; $1bde
	call InGameHandlePieceFalling.start                        ; $1be1
	call InGameCheckIfAnyTetrisRowsComplete                    ; $1be4
	call InGameAddPieceToVram                                  ; $1be7
	call ShiftEntireGameRamBufferDownARow                      ; $1bea
	call AddOnCompletedLinesScore                              ; $1bed

;
	call todo_demoRelated_05b3                               ; $1bf0: $cd $b3 $05
	ret                                              ; $1bf3: $c9


InGameCheckResetAndPause:
.startNotPressed:
	bit  PADB_SELECT, a                                        ; $1bf4
	ret  z                                                     ; $1bf6

; select pressed - hides next piece
	ld   a, [wNextPieceHidden]                                 ; $1bf7
	xor  $01                                                   ; $1bfa
	ld   [wNextPieceHidden], a                                 ; $1bfc

	jr   z, .pieceNotHidden                                    ; $1bff

	ld   a, SPRITE_SPEC_HIDDEN                                 ; $1c01

.setPieceVisibility:
; and send to oam
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $1c03
	call Copy2ndSpriteSpecToSprite8                            ; $1c06
	ret                                                        ; $1c09

.pieceNotHidden:
	xor  a                                                     ; $1c0a
	jr   .setPieceVisibility                                   ; $1c0b

.start:
; check if soft-resetting
	ldh  a, [hButtonsHeld]                                     ; $1c0d
	and  PADF_START|PADF_SELECT|PADF_B|PADF_A                  ; $1c0f
	cp   PADF_START|PADF_SELECT|PADF_B|PADF_A                  ; $1c11
	jp   z, Reset                                              ; $1c13

; return if demo
	ldh  a, [hPrevOrCurrDemoPlayed]                            ; $1c16
	and  a                                                     ; $1c18
	ret  nz                                                    ; $1c19

	ldh  a, [hButtonsPressed]                                  ; $1c1a
	bit  PADB_START, a                                         ; $1c1c
	jr   z, .startNotPressed                                   ; $1c1e

; pressed start
	ldh  a, [hIs2Player]                                       ; $1c20
	and  a                                                     ; $1c22
	jr   nz, .is2Player                                        ; $1c23

	ld   hl, rLCDC                                             ; $1c25

; flip game paused
	ldh  a, [hGamePaused]                                      ; $1c28
	xor  $01                                                   ; $1c2a
	ldh  [hGamePaused], a                                      ; $1c2c

	jr   z, .gameUnPaused                                      ; $1c2e

; game paused, get bg from $9c00 (containing pause text)
	set  3, [hl]                                               ; $1c30

; set activity, for playing relevant sound
	ld   a, $01                                                ; $1c32
	ld   [wGamePausedActivity], a                              ; $1c34

; copy num lines
	ld   hl, $994e                                             ; $1c37
	ld   de, $9d4e                                             ; $1c3a
	ld   b, $04                                                ; $1c3d

.waitUntilVramAndOamFree:
	ldh  a, [rSTAT]                                            ; $1c3f
	and  STATF_LCD                                             ; $1c41
	jr   nz, .waitUntilVramAndOamFree                          ; $1c43

	ld   a, [hl+]                                              ; $1c45
	ld   [de], a                                               ; $1c46
	inc  de                                                    ; $1c47
	dec  b                                                     ; $1c48
	jr   nz, .waitUntilVramAndOamFree                          ; $1c49

; set pieces to invisible
	ld   a, SPRITE_SPEC_HIDDEN                                 ; $1c4b

.setNextPieceVisibility:
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $1c4d

.setCurrPieceVisibilityAndSend2PiecesToOam:
	ld   [wSpriteSpecs], a                                     ; $1c50
	call Copy1stSpriteSpecToSprite4                            ; $1c53
	call Copy2ndSpriteSpecToSprite8                            ; $1c56
	ret                                                        ; $1c59

.gameUnPaused:
; get old bg back
	res  3, [hl]                                               ; $1c5a

; set activity, for playing relevant sound
	ld   a, $02                                                ; $1c5c
	ld   [wGamePausedActivity], a                              ; $1c5e

; if next piece visible, display both pieces
	ld   a, [wNextPieceHidden]                                 ; $1c61
	and  a                                                     ; $1c64
	jr   z, .setNextPieceVisibility                            ; $1c65

	xor  a                                                     ; $1c67
	jr   .setCurrPieceVisibilityAndSend2PiecesToOam            ; $1c68

.is2Player:
; if passive, can't pause game
	ldh  a, [hMultiplayerPlayerRole]                           ; $1c6a
	cp   MP_ROLE_MASTER                                        ; $1c6c
	ret  nz                                                    ; $1c6e

; otherwise flip game paused, jump if game unpaused
	ldh  a, [hGamePaused]                                      ; $1c6f
	xor  $01                                                   ; $1c71
	ldh  [hGamePaused], a                                      ; $1c73
	jr   z, jr_000_1caa                              ; $1c75: $28 $33

; game paused
	ld   a, $01                                      ; $1c77: $3e $01
	ld   [wGamePausedActivity], a                                  ; $1c79: $ea $7f $df
	ldh  a, [hSerialByteRead]                                    ; $1c7c: $f0 $d0
	ldh  [$f2], a                                    ; $1c7e: $e0 $f2
	ldh  a, [hNextSerialByteToLoad]                                    ; $1c80: $f0 $cf
	ldh  [$f1], a                                    ; $1c82: $e0 $f1
	call Call_000_1ccb                               ; $1c84: $cd $cb $1c
	ret                                              ; $1c87: $c9


Call_000_1c88:
	ldh  a, [hGamePaused]                                    ; $1c88: $f0 $ab
	and  a                                           ; $1c8a: $a7
	ret  z                                           ; $1c8b: $c8

	ldh  a, [hSerialInterruptHandled]                                    ; $1c8c: $f0 $cc
	jr   z, jr_000_1cc9                              ; $1c8e: $28 $39

	xor  a                                           ; $1c90: $af
	ldh  [hSerialInterruptHandled], a                                    ; $1c91: $e0 $cc
	ldh  a, [hMultiplayerPlayerRole]                                    ; $1c93: $f0 $cb
	cp   MP_ROLE_MASTER                                         ; $1c95: $fe $29
	jr   nz, jr_000_1ca1                             ; $1c97: $20 $08

	ld   a, $94                                      ; $1c99: $3e $94
	ldh  [hNextSerialByteToLoad], a                                    ; $1c9b: $e0 $cf
	ldh  [hMasterShouldSerialTransferInVBlank], a                                    ; $1c9d: $e0 $ce
	pop  hl                                          ; $1c9f: $e1
	ret                                              ; $1ca0: $c9

jr_000_1ca1:
	xor  a                                           ; $1ca1: $af
	ldh  [hNextSerialByteToLoad], a                                    ; $1ca2: $e0 $cf
	ldh  a, [hSerialByteRead]                                    ; $1ca4: $f0 $d0
	cp   $94                                         ; $1ca6: $fe $94
	jr   z, jr_000_1cc9                              ; $1ca8: $28 $1f

jr_000_1caa:
	ldh  a, [$f2]                                    ; $1caa: $f0 $f2
	ldh  [hSerialByteRead], a                                    ; $1cac: $e0 $d0
	ldh  a, [$f1]                                    ; $1cae: $f0 $f1
	ldh  [hNextSerialByteToLoad], a                                    ; $1cb0: $e0 $cf
	ld   a, $02                                      ; $1cb2: $3e $02
	ld   [wGamePausedActivity], a                                  ; $1cb4: $ea $7f $df
	xor  a                                           ; $1cb7: $af
	ldh  [hGamePaused], a                                    ; $1cb8: $e0 $ab
	ld   hl, $98ee                                   ; $1cba: $21 $ee $98
	ld   b, $8e                                      ; $1cbd: $06 $8e
	ld   c, $05                                      ; $1cbf: $0e $05

jr_000_1cc1:
	call StoreBinHLwhenLCDFree                               ; $1cc1: $cd $ff $19
	inc  l                                           ; $1cc4: $2c
	dec  c                                           ; $1cc5: $0d
	jr   nz, jr_000_1cc1                             ; $1cc6: $20 $f9

	ret                                              ; $1cc8: $c9


jr_000_1cc9:
	pop  hl                                          ; $1cc9: $e1
	ret                                              ; $1cca: $c9


Call_000_1ccb:
	ld   hl, $98ee                                   ; $1ccb: $21 $ee $98
	ld   c, $05                                      ; $1cce: $0e $05
	ld   de, $1cdd                                   ; $1cd0: $11 $dd $1c

jr_000_1cd3:
	ld   a, [de]                                     ; $1cd3: $1a
	call StoreAinHLwhenLCDFree                               ; $1cd4: $cd $fe $19
	inc  de                                          ; $1cd7: $13
	inc  l                                           ; $1cd8: $2c
	dec  c                                           ; $1cd9: $0d
	jr   nz, jr_000_1cd3                             ; $1cda: $20 $f7

	ret                                              ; $1cdc: $c9


	add  hl, de                                      ; $1cdd: $19
	ld   a, [bc]                                     ; $1cde: $0a
	ld   e, $1c                                      ; $1cdf: $1e $1c
	db $0e 
	
	
GameState01_GameOverInit:
; hide played and next piece, and send to oam
	ld   a, SPRITE_SPEC_HIDDEN                                 ; $1ce2
	ld   [wSpriteSpecs], a                                     ; $1ce4
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $1ce7
	call Copy1stSpriteSpecToSprite4                            ; $1cea
	call Copy2ndSpriteSpecToSprite8                            ; $1ced

; clear fall vars
	xor  a                                                     ; $1cf0
	ldh  [hPieceFallingState], a                               ; $1cf1
	ldh  [hTetrisFlashCount], a                                ; $1cf3
	call ClearPointersToCompletedTetrisRows                    ; $1cf5

; start to clear screen with a solid block, set timer, then next state
	ld   a, TILE_SOLID_BLOCK                                   ; $1cf8
	call FillGameScreenBufferWithTileAandSetToVramTransfer     ; $1cfa

	ld   a, $46                                                ; $1cfd
	ldh  [hTimer1], a                                          ; $1cff

	ld   a, GS_GAME_OVER_SCREEN_CLEARING                       ; $1d01
	ldh  [hGameState], a                                       ; $1d03
	ret                                                        ; $1d05


GameState04_LevelEndedMain:
	ldh  a, [hButtonsPressed]                                  ; $1d06
	bit  PADB_A, a                                             ; $1d08
	jr   nz, .aOrStartPressed                                  ; $1d0a

	bit  PADB_START, a                                         ; $1d0c
	ret  z                                                     ; $1d0e

.aOrStartPressed:
	lda ROWS_SHIFTING_DOWN_NONE                                ; $1d0f
	ldh  [hRowsShiftingDownState], a                           ; $1d10

; if 2 player, next game state is always mario v luigi
	ldh  a, [hIs2Player]                                       ; $1d12
	and  a                                                     ; $1d14
	ld   a, GS_MARIO_LUIGI_SCREEN_INIT                         ; $1d15
	jr   nz, .setGameState                                     ; $1d17

; set relevant state based on game type for 1 player
	ldh  a, [hGameType]                                        ; $1d19
	cp   GAME_TYPE_A_TYPE                                      ; $1d1b
	ld   a, GS_A_TYPE_SELECTION_INIT                           ; $1d1d
	jr   z, .setGameState                                      ; $1d1f

	ld   a, GS_B_TYPE_SELECTION_INIT                           ; $1d21

.setGameState:
	ldh  [hGameState], a                                       ; $1d23
	ret                                                        ; $1d25


GameState05_BTypeLevelFinished:
; proceed when timer 0
	ldh  a, [hTimer1]                                          ; $1d26
	and  a                                                     ; $1d28
	ret  nz                                                    ; $1d29

; display layout
	ld   hl, wGameScreenBuffer+2                               ; $1d2a
	ld   de, GameScreenLayout_ScoreTotals                      ; $1d2d
	call CopyToGameScreenUntilByteReadEquFFhThenSetVramTransfer ; $1d30

; jump if level 0
	ldh  a, [hBTypeLevel]                                      ; $1d33
	and  a                                                     ; $1d35
	jr   z, .fromLevel0                                        ; $1d36

; level 1+, override score mults, eg level 7 = $40 * 7 for the 1st one
	ld   de, SCORE_1_LINE                                      ; $1d38
	ld   hl, wGameScreenBuffer+$27                             ; $1d3b
	call DisplayBTypeScoreMultipliersBasedOnLevel              ; $1d3e

	ld   de, SCORE_2_LINES                                     ; $1d41
	ld   hl, wGameScreenBuffer+$87                             ; $1d44
	call DisplayBTypeScoreMultipliersBasedOnLevel              ; $1d47

	ld   de, SCORE_3_LINES                                     ; $1d4a
	ld   hl, wGameScreenBuffer+$e7                             ; $1d4d
	call DisplayBTypeScoreMultipliersBasedOnLevel              ; $1d50

	ld   de, SCORE_4_LINES                                     ; $1d53
	ld   hl, wGameScreenBuffer+$147                            ; $1d56
	call DisplayBTypeScoreMultipliersBasedOnLevel              ; $1d59

; clear score
	ld   hl, wScoreBCD                                         ; $1d5c
	ld   b, $03                                                ; $1d5f
	xor  a                                                     ; $1d61

.clearScore:
	ld   [hl+], a                                              ; $1d62
	dec  b                                                     ; $1d63
	jr   nz, .clearScore                                       ; $1d64

.fromLevel0:
	ld   a, $80                                                ; $1d66
	ldh  [hTimer1], a                                          ; $1d68

; set played and hidden piece to invisible, and send to oam
	ld   a, SPRITE_SPEC_HIDDEN                                 ; $1d6a
	ld   [wSpriteSpecs], a                                     ; $1d6c
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                     ; $1d6f
	call Copy1stSpriteSpecToSprite4                            ; $1d72
	call Copy2ndSpriteSpecToSprite8                            ; $1d75

; init sound, reset lines back to 25, then next state
	call ThunkInitSound                                        ; $1d78
	ld   a, $25                                                ; $1d7b
	ldh  [hNumLinesCompletedBCD], a                            ; $1d7d
	ld   a, GS_SCORE_UPDATE_AFTER_B_TYPE_LEVEL_DONE            ; $1d7f
	ldh  [hGameState], a                                       ; $1d81
	ret                                                        ; $1d83


DisplayBTypeScoreMultipliersBasedOnLevel:
	push hl                                                    ; $1d84

; clear score
	ld   hl, wScoreBCD                                         ; $1d85
	ld   b, $03                                                ; $1d88
	xor  a                                                     ; $1d8a

.clearScore:
	ld   [hl+], a                                              ; $1d8b
	dec  b                                                     ; $1d8c
	jr   nz, .clearScore                                       ; $1d8d

; add score category * (level + 1)
	ldh  a, [hBTypeLevel]                                      ; $1d8f
	ld   b, a                                                  ; $1d91
	inc  b                                                     ; $1d92

.addScore:
	ld   hl, wScoreBCD                                         ; $1d93
	call AddScoreValueDEontoBaseScoreHL                        ; $1d96
	dec  b                                                     ; $1d99
	jr   nz, .addScore                                         ; $1d9a

; get orig ram loc
	pop  hl                                                    ; $1d9c
	ld   b, $03                                                ; $1d9d
	ld   de, wScoreBCD+2                                       ; $1d9f

; stay in this upper loop, while no digit left to display
.checkForDigit:
	ld   a, [de]                                               ; $1da2
	and  $f0                                                   ; $1da3
	jr   nz, .hasTens                                          ; $1da5

	ld   a, [de]                                               ; $1da7
	and  $0f                                                   ; $1da8
	jr   nz, .hasDigits                                        ; $1daa

	dec  e                                                     ; $1dac
	dec  b                                                     ; $1dad
	jr   nz, .checkForDigit                                    ; $1dae

	ret                                                        ; $1db0

.hasTens:
; store in ram loc
	ld   a, [de]                                               ; $1db1
	and  $f0                                                   ; $1db2
	swap a                                                     ; $1db4
	ld   [hl+], a                                              ; $1db6

.hasDigits:
	ld   a, [de]                                               ; $1db7
	and  $0f                                                   ; $1db8
	ld   [hl+], a                                              ; $1dba

; to next byte
	dec  e                                                     ; $1dbb
	dec  b                                                     ; $1dbc
	jr   nz, .hasTens                                          ; $1dbd

	ret                                                        ; $1dbf


GameState0b_ScoreUpdateAfterBTypeLevelDone:
; proceed when timer 0
	ldh  a, [hTimer1]                                          ; $1dc0
	and  a                                                     ; $1dc2
	ret  nz                                                    ; $1dc3

; start having scores processed
	ld   a, $01                                                ; $1dc4
	ld   [wCurrScoreCategIsProcessingOrUpdating], a            ; $1dc6

	ld   a, $05                                                ; $1dc9
	ldh  [hTimer1], a                                          ; $1dcb
	ret                                                        ; $1dcd


GameState22_DancersInit:
; proceed when timer done
	ldh  a, [hTimer1]                                          ; $1dce
	and  a                                                     ; $1dd0
	ret  nz                                                    ; $1dd1

; load dancers layout and clear oam
	ld   hl, wGameScreenBuffer+2                               ; $1dd2
	ld   de, GameScreenLayout_Dancers                          ; $1dd5
	call CopyToGameScreenUntilByteReadEquFFhThenSetVramTransfer ; $1dd8
	call Clear_wOam                                            ; $1ddb

; load invisible dancers specs
	ld   hl, wSpriteSpecs                                      ; $1dde
	ld   de, SpriteSpecStruct_Dancers                          ; $1de1
	ld   c, NUM_DANCERS                                        ; $1de4
	call CopyCSpriteSpecStructsFromDEtoHL                      ; $1de6

; jumper and kicker also use OBP1
	ld   a, $10                                                ; $1de9
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF*6+SPR_SPEC_BaseXFlip ; $1deb
	ld   [hl], a                                               ; $1dee
	ld   l, SPR_SPEC_SIZEOF*7+SPR_SPEC_BaseXFlip               ; $1def
	ld   [hl], a                                               ; $1df1

; set active and SPR_SPEC_StartingAnimCounter counters per dancer
	ld   hl, wSpriteSpecs+SPR_SPEC_ActiveAnimCounter           ; $1df2
	ld   de, Dancers_AnimationTimers                           ; $1df5
	ld   b, NUM_DANCERS                                        ; $1df8

.setNextDancerAnimDetails:
	ld   a, [de]                                               ; $1dfa
	ld   [hl+], a                                              ; $1dfb
	ld   [hl+], a                                              ; $1dfc
	inc  de                                                    ; $1dfd

; to next dancer
	push de                                                    ; $1dfe
	ld   de, SPR_SPEC_SIZEOF-2                                 ; $1dff
	add  hl, de                                                ; $1e02
	pop  de                                                    ; $1e03
	dec  b                                                     ; $1e04
	jr   nz, .setNextDancerAnimDetails                         ; $1e05

; get num dancers to show based on high chosen, if
	ldh  a, [hBTypeHigh]                                       ; $1e07
	cp   $05                                                   ; $1e09
	jr   nz, .numDancersInB                                    ; $1e0b

	ld   a, NUM_DANCERS-1                                      ; $1e0d

.numDancersInB:
	inc  a                                                     ; $1e0f
	ld   b, a                                                  ; $1e10

; set visible those dancers
	ld   hl, wSpriteSpecs                                      ; $1e11
	ld   de, SPR_SPEC_SIZEOF                                   ; $1e14
	xor  a                                                     ; $1e17

.loopSetVisible:
	ld   [hl], a                                               ; $1e18
	add  hl, de                                                ; $1e19
	dec  b                                                     ; $1e1a
	jr   nz, .loopSetVisible                                   ; $1e1b

; play song based on high chosen
	ldh  a, [hBTypeHigh]                                       ; $1e1d
	add  MUS_DANCERS_HIGH_0                                    ; $1e1f
	ld   [wSongToStart], a                                     ; $1e21

; reset lines to complete back to 25, set timer, and go to next state
	ld   a, $25                                                ; $1e24
	ldh  [hNumLinesCompletedBCD], a                            ; $1e26
	ld   a, $1b                                                ; $1e28
	ldh  [hTimer1], a                                          ; $1e2a
	ld   a, GS_DANCERS_MAIN                                    ; $1e2c
	ldh  [hGameState], a                                       ; $1e2e
	ret                                                        ; $1e30


Dancers_AnimationTimers:
	db $1c, $0f, $1e, $32, $20
	db $18, $26, $1d, $28, $2b


GameState23_sendDancersToOam:
	ld   a, NUM_DANCERS                                        ; $1e3b
	call CopyASpriteSpecsToShadowOam                           ; $1e3d
	ret                                                        ; $1e40


GameState23_DancersMain:
; show dancers after a few frames
	ldh  a, [hTimer1]                                          ; $1e41
	cp   $14                                                   ; $1e43
	jr   z, GameState23_sendDancersToOam                       ; $1e45

; ret if timer still going
	and  a                                                     ; $1e47
	ret  nz                                                    ; $1e48

; toggle dancer's sprite when counter is 0
	ld   hl, wSpriteSpecs+SPR_SPEC_ActiveAnimCounter           ; $1e49
	ld   de, SPR_SPEC_SIZEOF                                   ; $1e4c
	ld   b, NUM_DANCERS                                        ; $1e4f

.nextDancer:
	push hl                                                    ; $1e51
	dec  [hl]                                                  ; $1e52
	jr   nz, .toNextDancer                                     ; $1e53

; dancer-specific counter is now 0
; get start counter ($0f) and store in active counter ($0e)
	inc  l                                                     ; $1e55
	ld   a, [hl-]                                              ; $1e56
	ld   [hl], a                                               ; $1e57

; get spec idx
	ld   a, l                                                  ; $1e58
	and  $f0                                                   ; $1e59
	or   SPR_SPEC_SpecIdx                                      ; $1e5b
	ld   l, a                                                  ; $1e5d
	ld   a, [hl]                                               ; $1e5e

; toggle and store in spec idx
	xor  $01                                                   ; $1e5f
	ld   [hl], a                                               ; $1e61

; special cases for jumper
	cp   SPRITE_SPEC_JUMPER_1                                  ; $1e62
	jr   z, .isJumperStanding                                  ; $1e64

	cp   SPRITE_SPEC_JUMPER_2                                  ; $1e66
	jr   z, .isJumperJumping                                   ; $1e68

.toNextDancer:
	pop  hl                                                    ; $1e6a
	add  hl, de                                                ; $1e6b
	dec  b                                                     ; $1e6c
	jr   nz, .nextDancer                                       ; $1e6d

; done processing dancers, send to oam
	ld   a, NUM_DANCERS                                        ; $1e6f
	call CopyASpriteSpecsToShadowOam                           ; $1e71
	ld   a, [wSongBeingPlayed]                                 ; $1e74
	and  a                                                     ; $1e77
	ret  nz                                                    ; $1e78

; clear oam and set state when music is stopped
	call Clear_wOam                                            ; $1e79

; set shuttle state if highest high, otherwise standard level finished
	ldh  a, [hBTypeHigh]                                       ; $1e7c
	cp   $05                                                   ; $1e7e
	ld   a, GS_SHUTTLE_SCENE_INIT                              ; $1e80
	jr   z, .setGameState                                      ; $1e82

	ld   a, GS_B_TYPE_LEVEL_FINISHED                           ; $1e84

.setGameState:
	ldh  [hGameState], a                                       ; $1e86
	ret                                                        ; $1e88

; set Ys for jumper based on animation
.isJumperStanding:
	dec  l                                                     ; $1e89
	dec  l                                                     ; $1e8a
	ld   [hl], $67                                             ; $1e8b
	jr   .toNextDancer                                         ; $1e8d

.isJumperJumping:
	dec  l                                                     ; $1e8f
	dec  l                                                     ; $1e90
	ld   [hl], $5d                                             ; $1e91
	jr   .toNextDancer                                         ; $1e93


After4ScoreCategoriesProcessed:
	xor  a                                                     ; $1e95
	ld   [wCurrScoreCategIsProcessingOrUpdating], a            ; $1e96

; get non-BCD num drops into HL, when done jump
	ld   de, wNumDrops                                         ; $1e99
	ld   a, [de]                                               ; $1e9c
	ld   l, a                                                  ; $1e9d
	inc  de                                                    ; $1e9e
	ld   a, [de]                                               ; $1e9f
	ld   h, a                                                  ; $1ea0
	or   l                                                     ; $1ea1
	jp   z, IncScoreCategoryProcessedAfterBTypeDone            ; $1ea2

; store num drops-1 back into orig num drops
	dec  hl                                                    ; $1ea5
	ld   a, h                                                  ; $1ea6
	ld   [de], a                                               ; $1ea7
	dec  de                                                    ; $1ea8
	ld   a, l                                                  ; $1ea9
	ld   [de], a                                               ; $1eaa

; add 1 onto drops total rolling up,
	ld   de, $0001                                             ; $1eab
	ld   hl, wDropsTotalRollingUp                              ; $1eae
	push de                                                    ; $1eb1
	call AddScoreValueDEontoBaseScoreHL                        ; $1eb2

; display total to vram
	ld   de, wDropsTotalRollingUp+2                            ; $1eb5
	ld   hl, $99a5                                             ; $1eb8
	call DisplayBCDNum6DigitsIfForced                          ; $1ebb

; clear timer
	xor  a                                                     ; $1ebe
	ldh  [hTimer1], a                                          ; $1ebf

; add 1 onto total score
	pop  de                                                    ; $1ec1
	ld   hl, wScoreBCD                                         ; $1ec2
	call AddScoreValueDEontoBaseScoreHL                        ; $1ec5
	ld   de, wScoreBCD+2                                       ; $1ec8

; display total score, and play sound
	ld   hl, $9a25                                             ; $1ecb
	call DisplayBCDNum6Digits                                  ; $1ece
	ld   a, SND_CONFIRM_OR_LETTER_TYPED                        ; $1ed1
	ld   [wSquareSoundToPlay], a                               ; $1ed3
	ret                                                        ; $1ed6


ProcessScoreUpdatesAfterBTypeLevelDone:
; wait until game state B sets this to 1 or 2
	ld   a, [wCurrScoreCategIsProcessingOrUpdating]            ; $1ed7
	and  a                                                     ; $1eda
	ret  z                                                     ; $1edb

; jump if all 4 done
	ld   a, [wNumScoreCategoriesProcessed]                     ; $1edc
	cp   $04                                                   ; $1edf
	jr   z, After4ScoreCategoriesProcessed                     ; $1ee1

; process relevant category
	ld   de, SCORE_1_LINE                                      ; $1ee3
	ld   bc, $9823                                             ; $1ee6
	ld   hl, wLinesClearedStructs                              ; $1ee9
	and  a                                                     ; $1eec
	jr   z, .processCategory                                   ; $1eed

	ld   de, SCORE_2_LINES                                     ; $1eef
	ld   bc, $9883                                             ; $1ef2
	ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF         ; $1ef5
	cp   $01                                                   ; $1ef8
	jr   z, .processCategory                                   ; $1efa

	ld   de, SCORE_3_LINES                                     ; $1efc
	ld   bc, $98e3                                             ; $1eff
	ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF*2       ; $1f02
	cp   $02                                                   ; $1f05
	jr   z, .processCategory                                   ; $1f07

	ld   de, SCORE_4_LINES                                     ; $1f09
	ld   bc, $9943                                             ; $1f0c
	ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF*3       ; $1f0f

.processCategory:
	call ProcessCurrentScoreCategory                           ; $1f12
	ret                                                        ; $1f15


GameState0c_UnusedPreShuttleLiftOff:
; go to shuttle liftoff when buttons pressed
	ldh  a, [hButtonsPressed]                                  ; $1f16
	and  a                                                     ; $1f18
	ret  z                                                     ; $1f19

	ld   a, GS_SHUTTLE_SCENE_LIFTOFF                           ; $1f1a
	ldh  [hGameState], a                                       ; $1f1c
	ret                                                        ; $1f1e


GameState0d_GameOverScreenClearing:
; proceeed when timer done
	ldh  a, [hTimer1]                                          ; $1f1f
	and  a                                                     ; $1f21
	ret  nz                                                    ; $1f22

; play music and check if 2 player
	ld   a, MUS_GAME_OVER                                      ; $1f23
	ld   [wSongToStart], a                                     ; $1f25

	ldh  a, [hIs2Player]                                       ; $1f28
	and  a                                                     ; $1f2a
	jr   z, .is1player                                         ; $1f2b

; 2 player
	ld   a, $3f                                      ; $1f2d: $3e $3f
	ldh  [hTimer1], a                                    ; $1f2f: $e0 $a6

	ld   a, GS_1b                                      ; $1f31: $3e $1b
	ldh  [hSerialInterruptHandled], a                                    ; $1f33: $e0 $cc
	jr   .setGameState                                 ; $1f35: $18 $37

.is1player:
	ld   a, TILE_EMPTY                                         ; $1f37
	call FillGameScreenBufferWithTileAandSetToVramTransfer     ; $1f39

; pipe box with game over text
	ld   hl, wGameScreenBuffer+$43                             ; $1f3c
	ld   de, GameInnerScreenLayout_GameOver                    ; $1f3f
	ld   c, $07                                                ; $1f42
	call CopyGameScreenInnerText                               ; $1f44

; please try again text
	ld   hl, wGameScreenBuffer+$183                            ; $1f47
	ld   de, GameInnerScreen_TryAgain                          ; $1f4a
	ld   c, $06                                                ; $1f4d
	call CopyGameScreenInnerText                               ; $1f4f

; jump immediately if B type
	ldh  a, [hGameType]                                        ; $1f52
	cp   GAME_TYPE_A_TYPE                                      ; $1f54
	jr   nz, .setGameStateGameOverScreen                       ; $1f56

; A type - if past a score threshold, go to rocket screens
	ld   hl, wScoreBCD+2                                       ; $1f58
	ld   a, [hl]                                               ; $1f5b

; 200,000+
	ld   b, SPRITE_SPEC_BIG_ROCKET                             ; $1f5c
	cp   $20                                                   ; $1f5e
	jr   nc, .setRocketSpecIdxThenNextState                    ; $1f60

; 150,000+ - SPRITE_SPEC_MEDIUM_ROCKET
	inc  b                                                     ; $1f62
	cp   $15                                                   ; $1f63
	jr   nc, .setRocketSpecIdxThenNextState                    ; $1f65

; 100,000+ - SPRITE_SPEC_SMALL_ROCKET
	inc  b                                                     ; $1f67
	cp   $10                                                   ; $1f68
	jr   nc, .setRocketSpecIdxThenNextState                    ; $1f6a

.setGameStateGameOverScreen:
	ld   a, GS_LEVEL_ENDED_MAIN                                ; $1f6c

.setGameState:
	ldh  [hGameState], a                                       ; $1f6e
	ret                                                        ; $1f70

.setRocketSpecIdxThenNextState:
; also set timer
	ld   a, b                                                  ; $1f71
	ldh  [hATypeRocketSpecIdx], a                              ; $1f72
	ld   a, $90                                                ; $1f74
	ldh  [hTimer1], a                                          ; $1f76
	ld   a, GS_PRE_ROCKET_SCENE_WAIT                           ; $1f78
	ldh  [hGameState], a                                       ; $1f7a
	ret                                                        ; $1f7c


CopyGameScreenInnerText:
; 1 tile either side
.nextRow:
	ld   b, GAME_SQUARE_WIDTH-2                                ; $1f7d
	push hl                                                    ; $1f7f

; copy to screen
.nextCol:
	ld   a, [de]                                               ; $1f80
	ld   [hl+], a                                              ; $1f81
	inc  de                                                    ; $1f82
	dec  b                                                     ; $1f83
	jr   nz, .nextCol                                          ; $1f84

; next row
	pop  hl                                                    ; $1f86
	push de                                                    ; $1f87
	ld   de, GB_TILE_WIDTH                                     ; $1f88
	add  hl, de                                                ; $1f8b
	pop  de                                                    ; $1f8c
	dec  c                                                     ; $1f8d
	jr   nz, .nextRow                                          ; $1f8e

	ret                                                        ; $1f90


AddOnCompletedLinesScore:
; ret if not A Type
	ldh  a, [hGameType]                                        ; $1f91
	cp   GAME_TYPE_A_TYPE                                      ; $1f93
	ret  nz                                                    ; $1f95

; ret if not in-game
	ldh  a, [hGameState]                                       ; $1f96
	and  a                                                     ; $1f98
	ret  nz                                                    ; $1f99

; ret if not currently copying ram buffer row 14 to vram
	ldh  a, [hRowsShiftingDownState]                           ; $1f9a
	cp   $05                                                   ; $1f9c
	ret  nz                                                    ; $1f9e

; get lines cleared in A, until A is non-0
	ld   hl, wLinesClearedStructs+LINES_CLEARED_Num            ; $1f9f
	ld   bc, LINES_CLEARED_SIZEOF                              ; $1fa2
	ld   a, [hl]                                               ; $1fa5
	ld   de, SCORE_1_LINE                                      ; $1fa6
	and  a                                                     ; $1fa9
	jr   nz, .afterChoosingScoreCateg                          ; $1faa

; to next score categ, etc
	add  hl, bc                                                ; $1fac
	ld   a, [hl]                                               ; $1fad
	ld   de, SCORE_2_LINES                                     ; $1fae
	and  a                                                     ; $1fb1
	jr   nz, .afterChoosingScoreCateg                          ; $1fb2

	add  hl, bc                                                ; $1fb4
	ld   a, [hl]                                               ; $1fb5
	ld   de, SCORE_3_LINES                                     ; $1fb6
	and  a                                                     ; $1fb9
	jr   nz, .afterChoosingScoreCateg                          ; $1fba

; ret if still 0 at last categ
	add  hl, bc                                                ; $1fbc
	ld   de, SCORE_4_LINES                                     ; $1fbd
	ld   a, [hl]                                               ; $1fc0
	and  a                                                     ; $1fc1
	ret  z                                                     ; $1fc2

.afterChoosingScoreCateg:
; clear num lines
	ld   [hl], $00                                             ; $1fc3

; eg B = 1 for level 0
	ldh  a, [hATypeLinesThresholdToPassForNextLevel]           ; $1fc5
	ld   b, a                                                  ; $1fc7
	inc  b                                                     ; $1fc8

.loop:
; add categ score repeatedly based on level
	push bc                                                    ; $1fc9
	push de                                                    ; $1fca
	ld   hl, wScoreBCD                                         ; $1fcb
	call AddScoreValueDEontoBaseScoreHL                        ; $1fce
	pop  de                                                    ; $1fd1
	pop  bc                                                    ; $1fd2
	dec  b                                                     ; $1fd3
	jr   nz, .loop                                             ; $1fd4

	ret                                                        ; $1fd6


FillGameScreenBufferWithTileAandSetToVramTransfer:
; start to fill rows going down with tile A
	push af                                                    ; $1fd7
	ld   a, ROWS_SHIFTING_DOWN_ROW_START                       ; $1fd8
	ldh  [hRowsShiftingDownState], a                           ; $1fda
	pop  af                                                    ; $1fdc

FillGameScreenBufferWithTileA:
	ld   hl, wGameScreenBuffer+2                               ; $1fdd
	ld   c, GAME_SCREEN_ROWS                                   ; $1fe0
	ld   de, GB_TILE_WIDTH                                     ; $1fe2

.nextRow:
	push hl                                                    ; $1fe5
	ld   b, GAME_SQUARE_WIDTH                                  ; $1fe6

.nextCol:
	ld   [hl+], a                                              ; $1fe8
	dec  b                                                     ; $1fe9
	jr   nz, .nextCol                                          ; $1fea

	pop  hl                                                    ; $1fec
	add  hl, de                                                ; $1fed
	dec  c                                                     ; $1fee
	jr   nz, .nextRow                                          ; $1fef

	ret                                                        ; $1ff1


; useless?
FillBottom2RowsOfTileMapWithEmptyTile:
; fill 2 game rows on gb's vram screen with empty tiles
	ld   hl, wGameScreenBuffer+$3c2                            ; $1ff2
	ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                   ; $1ff5
	ld   c, $02                                                ; $1ff8
	ld   a, TILE_EMPTY                                         ; $1ffa

.nextRow:
	ld   b, GAME_SQUARE_WIDTH                                  ; $1ffc

.nextCol:
	ld   [hl+], a                                              ; $1ffe
	dec  b                                                     ; $1fff
	jr   nz, .nextCol                                          ; $2000

	add  hl, de                                                ; $2002
	dec  c                                                     ; $2003
	jr   nz, .nextRow                                          ; $2004

	ret                                                        ; $2006


PlayNextPieceLoadNextAndHiddenPiece:
; visible
	ld   hl, wSpriteSpecs                                      ; $2007
	ld   [hl], $00                                             ; $200a

; Y of $18
	inc  l                                                     ; $200c
	ld   [hl], $18                                             ; $200d

; X of $3f
	inc  l                                                     ; $200f
	ld   [hl], $3f                                             ; $2010

; Spec Idx from sprite spec 2 spec idx
	inc  l                                                     ; $2012
	ld   a, [wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx]    ; $2013
	ld   [hl], a                                               ; $2016

; store piece type in C
	and  $fc                                                   ; $2017
	ld   c, a                                                  ; $2019

	ldh  a, [hPrevOrCurrDemoPlayed]                            ; $201a
	and  a                                                     ; $201c
	jr   nz, .inDemoOr2Player                                  ; $201d

	ldh  a, [hIs2Player]                                       ; $201f
	and  a                                                     ; $2021
	jr   z, .only1player                                       ; $2022

.inDemoOr2Player:
; get next piece
	ld   h, HIGH(wDemoPieces)                                  ; $2024
	ldh  a, [hLowByteOfCurrDemoStepAddress]                    ; $2026
	ld   l, a                                                  ; $2028
	ld   e, [hl]                                               ; $2029

; check if done
	inc  hl                                                    ; $202a
	ld   a, h                                                  ; $202b
	cp   HIGH(wDemoPieces.end)                                 ; $202c
	jr   nz, .setNextDemoStep                                  ; $202e

	ld   hl, wDemoPieces                                       ; $2030

.setNextDemoStep:
	ld   a, l                                                  ; $2033
	ldh  [hLowByteOfCurrDemoStepAddress], a                    ; $2034

;
	ldh  a, [$d3]                                    ; $2036: $f0 $d3
	and  a                                           ; $2038: $a7
	jr   z, .skipDIV                              ; $2039: $28 $2a

	or   $80                                         ; $203b: $f6 $80
	ldh  [$d3], a                                    ; $203d: $e0 $d3
	jr   .skipDIV                                 ; $203f: $18 $24

.only1player:
; try 3 times to gen a new random piece
	ld   h, $03                                                ; $2041

.upToDIV:
	ldh  a, [rDIV]                                             ; $2043
	ld   b, a                                                  ; $2045

.xorAloop:
	xor  a                                                     ; $2046

.nextB:
	dec  b                                                     ; $2047
	jr   z, .bEqu0                                             ; $2048

; loop A up to $1c and back while b isn't 0
	inc  a                                                     ; $204a
	inc  a                                                     ; $204b
	inc  a                                                     ; $204c
	inc  a                                                     ; $204d
	cp   $1c                                                   ; $204e
	jr   z, .xorAloop                                          ; $2050

	jr   .nextB                                                ; $2052

.bEqu0:
; final A (multiple of 4) into D
	ld   d, a                                                  ; $2054

; hidden random val to go into loaded piece
	ldh  a, [hHiddenLoadedPiece]                               ; $2055
	ld   e, a                                                  ; $2057
	dec  h                                                     ; $2058
	jr   z, .hDone                                             ; $2059

; h not 0 yet, | last random val, curr random val, and loaded piece
; loaded piece -> played piece
; last random val -> loaded piece
; curr random val -> last random val
; re-randomize if upper 6 bits not changed from last spec idx
	or   d                                                     ; $205b
	or   c                                                     ; $205c
	and  $fc                                                   ; $205d
	cp   c                                                     ; $205f
	jr   z, .upToDIV                                           ; $2060

.hDone:
; store multiple of 4
	ld   a, d                                                  ; $2062
	ldh  [hHiddenLoadedPiece], a                               ; $2063

.skipDIV:
	ld   a, e                                                  ; $2065
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx], a    ; $2066
	call Copy2ndSpriteSpecToSprite8                            ; $2069

; update frames to move down for piece
	ldh  a, [hNumFramesUntilPiecesMoveDown]                    ; $206c
	ldh  [hNumFramesUntilCurrPieceMovesDown], a                ; $206e
	ret                                                        ; $2070


InGameHandlePieceFalling:
.holdingDown:
; check if pressing down if we can press
	ld   a, [wCanPressDownToMakePieceFall]                     ; $2071
	and  a                                                     ; $2074
	jr   z, .afterCheckingIfPressedDown                        ; $2075

	ldh  a, [hButtonsPressed]                                  ; $2077
	and  PADF_DOWN|PADF_LEFT|PADF_RIGHT                        ; $2079
	cp   PADF_DOWN                                             ; $207b
	jr   nz, .afterPressedDown                                 ; $207d

; just pressed
	xor  a                                                     ; $207f
	ld   [wCanPressDownToMakePieceFall], a                     ; $2080

.afterCheckingIfPressedDown:
; proceed when timer 2 is 0
	ldh  a, [hTimer2]                                          ; $2083
	and  a                                                     ; $2085
	jr   nz, .sendActivePieceToOam                             ; $2086

; proceed if piece falling state = 0, and rows aren't shifting down
	ldh  a, [hPieceFallingState]                               ; $2088
	and  a                                                     ; $208a
	jr   nz, .sendActivePieceToOam                             ; $208b

; FALLING_PIECE_NONE
	ldh  a, [hRowsShiftingDownState]                           ; $208d
	and  a                                                     ; $208f
	jr   nz, .sendActivePieceToOam                             ; $2090

; process down every 3 frames
	ld   a, $03                                                ; $2092
	ldh  [hTimer2], a                                          ; $2094

; inc times held without lifting down
	ld   hl, hNumTimesHoldingDownEvery3Frames                  ; $2096
	inc  [hl]                                                  ; $2099
	jr   .afterIncTimesHoldingDownForPiece                     ; $209a

.start:
	ldh  a, [hButtonsHeld]                                     ; $209c
	and  PADF_DOWN|PADF_LEFT|PADF_RIGHT                        ; $209e
	cp   PADF_DOWN                                             ; $20a0
	jr   z, .holdingDown                                       ; $20a2

.afterPressedDown:
; reset times held for new press
	ld   hl, hNumTimesHoldingDownEvery3Frames                  ; $20a4
	ld   [hl], $00                                             ; $20a7

; dec frames, and return if > 0
	ldh  a, [hNumFramesUntilCurrPieceMovesDown]                ; $20a9
	and  a                                                     ; $20ab
	jr   z, .currScoreEqu0                                     ; $20ac

	dec  a                                                     ; $20ae
	ldh  [hNumFramesUntilCurrPieceMovesDown], a                ; $20af

.sendActivePieceToOam:
	call Copy1stSpriteSpecToSprite4                            ; $20b1
	ret                                                        ; $20b4

.currScoreEqu0:
; dont proceed if rows are flashing
	ldh  a, [hPieceFallingState]                               ; $20b5
	cp   FALLING_PIECE_ALL_ROWS_PROCESSED_AFTER_DROP           ; $20b7
	ret  z                                                     ; $20b9

; dont proceed if rows are being shifted down
	ldh  a, [hRowsShiftingDownState]                           ; $20ba
	and  a                                                     ; $20bc
	ret  nz                                                    ; $20bd

; update score for piece, ie keep looping in range of top score
	ldh  a, [hNumFramesUntilPiecesMoveDown]                    ; $20be
	ldh  [hNumFramesUntilCurrPieceMovesDown], a                ; $20c0

.afterIncTimesHoldingDownForPiece:
; move piece down, and store prev Y
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $20c2
	ld   a, [hl]                                               ; $20c5
	ldh  [hNumCompletedTetrisRows], a                          ; $20c6
	add  $08                                                   ; $20c8
	ld   [hl], a                                               ; $20ca

; send active piece to oam and ret if no collision
	call Copy1stSpriteSpecToSprite4                            ; $20cb
	call RetZIfNoCollisionForPiece                             ; $20ce
	and  a                                                     ; $20d1
	ret  z                                                     ; $20d2

; collision detected, reset Y to previous, and send to oam
	ldh  a, [hNumCompletedTetrisRows]                          ; $20d3
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                 ; $20d5
	ld   [hl], a                                               ; $20d8
	call Copy1stSpriteSpecToSprite4                            ; $20d9

; set hit bottom state, and allow pressing down without releasing
	ld   a, FALLING_PIECE_HIT_BOTTOM                           ; $20dc
	ldh  [hPieceFallingState], a                               ; $20de
	ld   [wCanPressDownToMakePieceFall], a                     ; $20e0

	ldh  a, [hNumTimesHoldingDownEvery3Frames]                 ; $20e3
	and  a                                                     ; $20e5
	jr   z, .fromNotHoldingDown                                ; $20e6

; held down for piece until now
	ld   c, a                                                  ; $20e8
	ldh  a, [hGameType]                                        ; $20e9
	cp   GAME_TYPE_A_TYPE                                      ; $20eb
	jr   z, .isAType                                           ; $20ed

; is B type, get num drops in HL
	ld   de, wNumDrops                                         ; $20ef
	ld   a, [de]                                               ; $20f2
	ld   l, a                                                  ; $20f3
	inc  de                                                    ; $20f4
	ld   a, [de]                                               ; $20f5
	ld   h, a                                                  ; $20f6

; add times holding down to num drops
	ld   b, $00                                                ; $20f7
	dec  c                                                     ; $20f9
	add  hl, bc                                                ; $20fa

; store back num drops
	ld   a, h                                                  ; $20fb
	ld   [de], a                                               ; $20fc
	ld   a, l                                                  ; $20fd
	dec  de                                                    ; $20fe
	ld   [de], a                                               ; $20ff

.clearTimesHoldingDown:
	xor  a                                                     ; $2100
	ldh  [hNumTimesHoldingDownEvery3Frames], a                 ; $2101

.fromNotHoldingDown:
; check if orig coords when active piece loaded
	ld   a, [wSpriteSpecs+SPR_SPEC_BaseYOffset]                ; $2103
	cp   $18                                                   ; $2106
	ret  nz                                                    ; $2108

	ld   a, [wSpriteSpecs+SPR_SPEC_BaseXOffset]                ; $2109
	cp   $3f                                                   ; $210c
	ret  nz                                                    ; $210e

; give a change to move piece left and right, but skipping game over once
; while in orig coords
	ld   hl, hIsPieceStuckOnTopRow                             ; $210f
	ld   a, [hl]                                               ; $2112
	cp   $01                                                   ; $2113
	jr   nz, .skipGameOver                                     ; $2115

; clear sound, set game over state, and play game over wav sound
	call ThunkInitSound                                        ; $2117
	ld   a, GS_GAME_OVER_INIT                                  ; $211a
	ldh  [hGameState], a                                       ; $211c
	ld   a, WAV_GAME_OVER                                      ; $211e
	ld   [wWavSoundToPlay], a                                  ; $2120
	ret                                                        ; $2123

.skipGameOver:
	inc  [hl]                                                  ; $2124
	ret                                                        ; $2125

.isAType:
; add num drops to score
	xor  a                                                     ; $2126

.keepAdding:
	dec  c                                                     ; $2127
	jr   z, .addDropsToScore                                   ; $2128

	inc  a                                                     ; $212a
	daa                                                        ; $212b
	jr   .keepAdding                                           ; $212c

.addDropsToScore:
	ld   e, a                                                  ; $212e
	ld   d, $00                                                ; $212f
	ld   hl, wScoreBCD                                         ; $2131
	call AddScoreValueDEontoBaseScoreHL                        ; $2134

; set that we've added to score, for vblank interrupt
	ld   a, $01                                                ; $2137
	ld   [wATypeJustAddedDropsToScore], a                      ; $2139
	jr   .clearTimesHoldingDown                                ; $213c


InGameCheckIfAnyTetrisRowsComplete:
; ret if wrong state
	ldh  a, [hPieceFallingState]                               ; $213e
	cp   FALLING_PIECE_CHECK_COMPLETED_ROWS                    ; $2140
	ret  nz                                                    ; $2142

; play sound
	ld   a, NOISE_PIECE_HIT_FLOOR                              ; $2143
	ld   [wNoiseSoundToPlay], a                                ; $2145

; clear counter
	xor  a                                                     ; $2148
	ldh  [hNumCompletedTetrisRows], a                          ; $2149

; check every row from the 3rd row down
	ld   de, wRamBufferAddressesForCompletedRows               ; $214b
	ld   hl, wGameScreenBuffer+2*GB_TILE_WIDTH+2               ; $214e
	ld   b, GAME_SCREEN_ROWS-2                                 ; $2151

.nextRow:
	ld   c, GAME_SQUARE_WIDTH                                  ; $2153
	push hl                                                    ; $2155

.nextCol:
	ld   a, [hl+]                                              ; $2156
	cp   TILE_EMPTY                                            ; $2157
	jp   z, .emptyTileFoundInRow                               ; $2159

	dec  c                                                     ; $215c
	jr   nz, .nextCol                                          ; $215d

; no empty tiles in row, add row to completed rows list
	pop  hl                                                    ; $215f
	ld   a, h                                                  ; $2160
	ld   [de], a                                               ; $2161
	inc  de                                                    ; $2162
	ld   a, l                                                  ; $2163
	ld   [de], a                                               ; $2164
	inc  de                                                    ; $2165

; inc num completed rows
	ldh  a, [hNumCompletedTetrisRows]                          ; $2166
	inc  a                                                     ; $2168
	ldh  [hNumCompletedTetrisRows], a                          ; $2169

.toNextRow:
	push de                                                    ; $216b
	ld   de, GB_TILE_WIDTH                                     ; $216c
	add  hl, de                                                ; $216f
	pop  de                                                    ; $2170
	dec  b                                                     ; $2171
	jr   nz, .nextRow                                          ; $2172

; all rows processed, set state
	ld   a, FALLING_PIECE_ALL_ROWS_PROCESSED_AFTER_DROP        ; $2174
	ldh  [hPieceFallingState], a                               ; $2176
	dec  a                                                     ; $2178
	ldh  [hTimer1], a                                          ; $2179

; proceed if any rows completed, and put that num in B
	ldh  a, [hNumCompletedTetrisRows]                          ; $217b
	and  a                                                     ; $217d
	ret  z                                                     ; $217e

	ld   b, a                                                  ; $217f

; process line count for game type
	ld   hl, hNumLinesCompletedBCD                             ; $2180
	ldh  a, [hGameType]                                        ; $2183
	cp   GAME_TYPE_B_TYPE                                      ; $2185
	jr   z, .gameTypeB                                         ; $2187

; game type A, add to num lines word
	ld   a, b                                                  ; $2189
	add  [hl]                                                  ; $218a
	daa                                                        ; $218b
	ld   [hl+], a                                              ; $218c
	ld   a, $00                                                ; $218d
	adc  [hl]                                                  ; $218f
	daa                                                        ; $2190
	ld   [hl], a                                               ; $2191
	jr   nc, .afterGameTypeNumLinesProcessing                  ; $2192

; if carry out of high byte, score is 9999
	ld   [hl], $99                                             ; $2194
	dec  hl                                                    ; $2196
	ld   [hl], $99                                             ; $2197
	jr   .afterGameTypeNumLinesProcessing                      ; $2199

.gameTypeB:
; get current lines - lines just completed, with min of 0
	ld   a, [hl]                                               ; $219b
	or   a                                                     ; $219c
	sub  b                                                     ; $219d
	jr   z, .clearNumLinesCompleted                            ; $219e

	jr   c, .clearNumLinesCompleted                            ; $21a0

; store back in ram
	daa                                                        ; $21a2
	ld   [hl], a                                               ; $21a3

; if subbed all the way down to 9x, set to 0 instead
	and  $f0                                                   ; $21a4
	cp   $90                                                   ; $21a6
	jr   z, .clearNumLinesCompleted                            ; $21a8

.afterGameTypeNumLinesProcessing:
; num lines just completed in A
	ld   a, b                                                  ; $21aa

; based on lines cleared..
	ld   c, SND_NON_4_LINES_CLEARED                            ; $21ab
	ld   hl, wLinesClearedStructs                              ; $21ad
	ld   b, $00                                                ; $21b0
	cp   $01                                                   ; $21b2
	jr   z, .end                                               ; $21b4

	ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF         ; $21b6
	ld   b, $01                                                ; $21b9
	cp   $02                                                   ; $21bb
	jr   z, .end                                               ; $21bd

	ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF*2       ; $21bf
	ld   b, $02                                                ; $21c2
	cp   $03                                                   ; $21c4
	jr   z, .end                                               ; $21c6

	ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF*3       ; $21c8
	ld   b, $04                                                ; $21cb
	ld   c, SND_4_LINES_CLEARED                                ; $21cd

.end:
; inc its counter
	inc  [hl]                                                  ; $21cf

	ld   a, b                                        ; $21d0: $78
	ldh  [$dc], a                                    ; $21d1: $e0 $dc

; and play relevant sound
	ld   a, c                                                  ; $21d3
	ld   [wSquareSoundToPlay], a                               ; $21d4
	ret                                                        ; $21d7

.emptyTileFoundInRow:
	pop  hl                                                    ; $21d8
	jr   .toNextRow                                            ; $21d9

.clearNumLinesCompleted:
	xor  a                                                     ; $21db
	ldh  [hNumLinesCompletedBCD], a                            ; $21dc
	jr   .afterGameTypeNumLinesProcessing                      ; $21de


FlashCompletedTetrisRows:
; ret if not in right state, or timer still ticking
	ldh  a, [hPieceFallingState]                               ; $21e0
	cp   FALLING_PIECE_ALL_ROWS_PROCESSED_AFTER_DROP           ; $21e2
	ret  nz                                                    ; $21e4

	ldh  a, [hTimer1]                                          ; $21e5
	and  a                                                     ; $21e7
	ret  nz                                                    ; $21e8

; process each completed row
	ld   de, wRamBufferAddressesForCompletedRows               ; $21e9

; alternate contents of row based on counter
	ldh  a, [hTetrisFlashCount]                                ; $21ec
	bit  0, a                                                  ; $21ee
	jr   nz, .flashRowsWithOrigTile                            ; $21f0

	ld   a, [de]                                               ; $21f2
	and  a                                                     ; $21f3
	jr   z, .doneWithFallingPiecePlayNextPiece                 ; $21f4

.upperOuterLoop:
; get vram dest address for row
	sub  HIGH(wGameScreenBuffer-_SCRN0)                        ; $21f6
	ld   h, a                                                  ; $21f8
	inc  de                                                    ; $21f9
	ld   a, [de]                                               ; $21fa
	ld   l, a                                                  ; $21fb

; when counter = 6, use an empty tile to clear
	ldh  a, [hTetrisFlashCount]                                ; $21fc
	cp   $06                                                   ; $21fe
	ld   a, TILE_FLASHING_PIECE                                ; $2200
	jr   nz, .flashRow                                         ; $2202

	ld   a, TILE_EMPTY                                         ; $2204

; set for entire row
.flashRow:
	ld   c, GAME_SQUARE_WIDTH                                  ; $2206

.flashRowLoop:
	ld   [hl+], a                                              ; $2208
	dec  c                                                     ; $2209
	jr   nz, .flashRowLoop                                     ; $220a

; continue if more rows
	inc  de                                                    ; $220c
	ld   a, [de]                                               ; $220d
	and  a                                                     ; $220e
	jr   nz, .upperOuterLoop                                   ; $220f

.incFlashCount:
; inc flash counter
	ldh  a, [hTetrisFlashCount]                                ; $2211
	inc  a                                                     ; $2213
	ldh  [hTetrisFlashCount], a                                ; $2214

	cp   $07                                                   ; $2216
	jr   z, .flashed7times                                     ; $2218

; 10 frames until next flash
	ld   a, $0a                                                ; $221a
	ldh  [hTimer1], a                                          ; $221c
	ret                                                        ; $221e

.flashed7times:
; clear counter, set timer until shift
	xor  a                                                     ; $221f
	ldh  [hTetrisFlashCount], a                                ; $2220
	
	ld   a, $0d                                                ; $2222
	ldh  [hTimer1], a                                          ; $2224

; shift ram buffer, then later on vram rows display
	ld   a, ROWS_SHIFTING_DOWN_SHIFT_RAM_BUFFER                ; $2226
	ldh  [hRowsShiftingDownState], a                           ; $2228

.finishedHandlingPieceFalling:
	lda FALLING_PIECE_NONE                                     ; $222a
	ldh  [hPieceFallingState], a                               ; $222b
	ret                                                        ; $222d

.flashRowsWithOrigTile:
; get vram row address from screen buffer, with high byte into C
; ram buffer high byte in H
	ld   a, [de]                                               ; $222e
	ld   h, a                                                  ; $222f
	sub  HIGH(wGameScreenBuffer-_SCRN0)                        ; $2230
	ld   c, a                                                  ; $2232
	inc  de                                                    ; $2233
	ld   a, [de]                                               ; $2234
	ld   l, a                                                  ; $2235

; set for entire row
	ld   b, GAME_SQUARE_WIDTH                                  ; $2236

.origTileCopyLoop:
	ld   a, [hl]                                               ; $2238
	push hl                                                    ; $2239
	ld   h, c                                                  ; $223a
	ld   [hl], a                                               ; $223b
	pop  hl                                                    ; $223c
	inc  hl                                                    ; $223d
	dec  b                                                     ; $223e
	jr   nz, .origTileCopyLoop                                 ; $223f

; try more rows
	inc  de                                                    ; $2241
	ld   a, [de]                                               ; $2242
	and  a                                                     ; $2243
	jr   nz, .flashRowsWithOrigTile                            ; $2244

	jr   .incFlashCount                                        ; $2246

.doneWithFallingPiecePlayNextPiece:
	call PlayNextPieceLoadNextAndHiddenPiece                   ; $2248
	jr   .finishedHandlingPieceFalling                         ; $224b


ShiftEntireGameRamBufferDownARow:
; ret if timer still ticking, or not in right state
	ldh  a, [hTimer1]                                          ; $224d
	and  a                                                     ; $224f
	ret  nz                                                    ; $2250

	ldh  a, [hRowsShiftingDownState]                           ; $2251
	cp   ROWS_SHIFTING_DOWN_SHIFT_RAM_BUFFER                   ; $2253
	ret  nz                                                    ; $2255

; get ram addresses into hl
	ld   de, wRamBufferAddressesForCompletedRows               ; $2256
	ld   a, [de]                                               ; $2259

.nextCompletedRow:
	ld   h, a                                                  ; $225a
	inc  de                                                    ; $225b
	ld   a, [de]                                               ; $225c
	ld   l, a                                                  ; $225d

; push pointers to completed rows, and ram buffer address
	push de                                                    ; $225e
	push hl                                                    ; $225f

; prev ram buffer row in hl, curr in de
	ld   bc, -GB_TILE_WIDTH                                    ; $2260
	add  hl, bc                                                ; $2263
	pop  de                                                    ; $2264

.nextRow:
	push hl                                                    ; $2265
	ld   b, GAME_SQUARE_WIDTH                                  ; $2266

; copy entire prev row into current
.rowShiftCopy:
	ld   a, [hl+]                                              ; $2268
	ld   [de], a                                               ; $2269
	inc  de                                                    ; $226a
	dec  b                                                     ; $226b
	jr   nz, .rowShiftCopy                                     ; $226c

; pop start of row, get into de, hl = prev ram buffer row
	pop  hl                                                    ; $226e
	push hl                                                    ; $226f
	pop  de                                                    ; $2270
	ld   bc, -GB_TILE_WIDTH                                    ; $2271
	add  hl, bc                                                ; $2274

; stop when about to copy from top of screen
	ld   a, h                                                  ; $2275
	cp   HIGH(wGameScreenBuffer-$20)                           ; $2276
	jr   nz, .nextRow                                          ; $2278

	pop  de                                                    ; $227a
	inc  de                                                    ; $227b
	ld   a, [de]                                               ; $227c
	and  a                                                     ; $227d
	jr   nz, .nextCompletedRow                                 ; $227e

; clear top row
	ld   hl, wGameScreenBuffer+2                               ; $2280
	ld   a, TILE_EMPTY                                         ; $2283
	ld   b, GAME_SQUARE_WIDTH                                  ; $2285

.clearTopRow:
	ld   [hl+], a                                              ; $2287
	dec  b                                                     ; $2288
	jr   nz, .clearTopRow                                      ; $2289

; start to shift rows down
	call ClearPointersToCompletedTetrisRows                    ; $228b
	ld   a, ROWS_SHIFTING_DOWN_ROW_START                       ; $228e
	ldh  [hRowsShiftingDownState], a                           ; $2290
	ret                                                        ; $2292


ClearPointersToCompletedTetrisRows:
	ld   hl, wRamBufferAddressesForCompletedRows               ; $2293
	xor  a                                                     ; $2296
	ld   b, wRamBufferAddressesForCompletedRows.end-wRamBufferAddressesForCompletedRows ; $2297

.loop:
	ld   [hl+], a                                              ; $2299
	dec  b                                                     ; $229a
	jr   nz, .loop                                             ; $229b

	ret                                                        ; $229d


CopyRamBufferRow17ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $229e
	cp   ROWS_SHIFTING_DOWN_ROW_START                          ; $22a0
	ret  nz                                                    ; $22a2

	ld   hl, _SCRN0+GB_TILE_WIDTH*17+2                         ; $22a3
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*17+2              ; $22a6
	call CopyRamBufferRowToVram                                ; $22a9
	ret                                                        ; $22ac


CopyRamBufferRow16ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $22ad
	cp   $03                                                   ; $22af
	ret  nz                                                    ; $22b1

	ld   hl, _SCRN0+GB_TILE_WIDTH*16+2                         ; $22b2
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*16+2              ; $22b5
	call CopyRamBufferRowToVram                                ; $22b8
	ret                                                        ; $22bb


CopyRamBufferRow15ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $22bc
	cp   $04                                                   ; $22be
	ret  nz                                                    ; $22c0

	ld   hl, _SCRN0+GB_TILE_WIDTH*15+2                         ; $22c1
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*15+2              ; $22c4
	call CopyRamBufferRowToVram                                ; $22c7
	ret                                                        ; $22ca


CopyRamBufferRow14ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $22cb
	cp   $05                                                   ; $22cd
	ret  nz                                                    ; $22cf

	ld   hl, _SCRN0+GB_TILE_WIDTH*14+2                         ; $22d0
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*14+2              ; $22d3
	call CopyRamBufferRowToVram                                ; $22d6
	ret                                                        ; $22d9


CopyRamBufferRow13ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $22da
	cp   $06                                                   ; $22dc
	ret  nz                                                    ; $22de

	ld   hl, _SCRN0+GB_TILE_WIDTH*13+2                         ; $22df
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*13+2              ; $22e2
	call CopyRamBufferRowToVram                                ; $22e5
	ret                                                        ; $22e8


CopyRamBufferRow12ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $22e9
	cp   $07                                                   ; $22eb
	ret  nz                                                    ; $22ed

	ld   hl, _SCRN0+GB_TILE_WIDTH*12+2                         ; $22ee
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*12+2              ; $22f1
	call CopyRamBufferRowToVram                                ; $22f4
	ret                                                        ; $22f7


CopyRamBufferRow11ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $22f8
	cp   $08                                                   ; $22fa
	ret  nz                                                    ; $22fc

	ld   hl, _SCRN0+GB_TILE_WIDTH*11+2                         ; $22fd
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*11+2              ; $2300
	call CopyRamBufferRowToVram                                ; $2303

;
	ldh  a, [hIs2Player]                                    ; $2306: $f0 $c5
	and  a                                           ; $2308: $a7
	ldh  a, [hGameState]                                    ; $2309: $f0 $e1
	jr   nz, .is2Player                             ; $230b: $20 $08

; ret if 1 player and not in-game
	and  a                                           ; $230d: $a7
	ret  nz                                          ; $230e: $c0

.loop:
	ld   a, NOISE_TETRIS_ROWS_FELL                                      ; $230f: $3e $01
	ld   [wNoiseSoundToPlay], a                                  ; $2311: $ea $f8 $df
	ret                                              ; $2314: $c9

.is2Player:
	cp   GS_2PLAYER_IN_GAME_MAIN                                         ; $2315: $fe $1a
	ret  nz                                          ; $2317: $c0

	ldh  a, [$d4]                                    ; $2318: $f0 $d4
	and  a                                           ; $231a: $a7
	jr   z, .loop                              ; $231b: $28 $f2

	ld   a, SND_TETRIS_ROWS_FELL                                      ; $231d: $3e $05
	ld   [wSquareSoundToPlay], a                                  ; $231f: $ea $e0 $df
	ret                                              ; $2322: $c9


CopyRamBufferRow10ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $2323
	cp   $09                                                   ; $2325
	ret  nz                                                    ; $2327

	ld   hl, _SCRN0+GB_TILE_WIDTH*10+2                         ; $2328
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*10+2              ; $232b
	call CopyRamBufferRowToVram                                ; $232e
	ret                                                        ; $2331


CopyRamBufferRow9ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $2332
	cp   $0a                                                   ; $2334
	ret  nz                                                    ; $2336

	ld   hl, _SCRN0+GB_TILE_WIDTH*9+2                          ; $2337
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*9+2               ; $233a
	call CopyRamBufferRowToVram                                ; $233d
	ret                                                        ; $2340


CopyRamBufferRow8ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $2341
	cp   $0b                                                   ; $2343
	ret  nz                                                    ; $2345

	ld   hl, _SCRN0+GB_TILE_WIDTH*8+2                          ; $2346
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*8+2               ; $2349
	call CopyRamBufferRowToVram                                ; $234c
	ret                                                        ; $234f


CopyRamBufferRow7ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $2350
	cp   $0c                                                   ; $2352
	ret  nz                                                    ; $2354

	ld   hl, _SCRN0+GB_TILE_WIDTH*7+2                          ; $2355
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*7+2               ; $2358
	call CopyRamBufferRowToVram                                ; $235b
	ret                                                        ; $235e


CopyRamBufferRow6ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $235f
	cp   $0d                                                   ; $2361
	ret  nz                                                    ; $2363

	ld   hl, _SCRN0+GB_TILE_WIDTH*6+2                          ; $2364
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*6+2               ; $2367
	call CopyRamBufferRowToVram                                ; $236a
	ret                                                        ; $236d


CopyRamBufferRow5ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $236e
	cp   $0e                                                   ; $2370
	ret  nz                                                    ; $2372

	ld   hl, _SCRN0+GB_TILE_WIDTH*5+2                          ; $2373
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*5+2               ; $2376
	call CopyRamBufferRowToVram                                ; $2379
	ret                                                        ; $237c


CopyRamBufferRow4ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $237d
	cp   $0f                                                   ; $237f
	ret  nz                                                    ; $2381

	ld   hl, _SCRN0+GB_TILE_WIDTH*4+2                          ; $2382
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*4+2               ; $2385
	call CopyRamBufferRowToVram                                ; $2388
	ret                                                        ; $238b


CopyRamBufferRow3ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $238c
	cp   $10                                                   ; $238e
	ret  nz                                                    ; $2390

	ld   hl, _SCRN0+GB_TILE_WIDTH*3+2                          ; $2391
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*3+2               ; $2394
	call CopyRamBufferRowToVram                                ; $2397

; check if level is updated
	call CheckIfATypeNextLevelReached                          ; $239a
	ret                                                        ; $239d


CopyRamBufferRow2ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $239e
	cp   $11                                                   ; $23a0
	ret  nz                                                    ; $23a2

	ld   hl, _SCRN0+GB_TILE_WIDTH*2+2                          ; $23a3
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH*2+2               ; $23a6
	call CopyRamBufferRowToVram                                ; $23a9

; update score in screen 1
	ld   hl, _SCRN1+$6d                                        ; $23ac
	call DisplayGameATypeScoreIfInGameAndForced                ; $23af
	ld   a, $01                                                ; $23b2
	ldh  [hFoundDisplayableScoreDigit], a                      ; $23b4
	ret                                                        ; $23b6


CopyRamBufferRow1ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $23b7
	cp   $12                                                   ; $23b9
	ret  nz                                                    ; $23bb

	ld   hl, _SCRN0+GB_TILE_WIDTH+2                            ; $23bc
	ld   de, wGameScreenBuffer+GB_TILE_WIDTH+2                 ; $23bf
	call CopyRamBufferRowToVram                                ; $23c2

; update score in screen 0
	ld   hl, _SCRN0+$6d                                        ; $23c5
	call DisplayGameATypeScoreIfInGameAndForced                ; $23c8
	ret                                                        ; $23cb


CopyRamBufferRow0ToVram:
	ldh  a, [hRowsShiftingDownState]                           ; $23cc
	cp   $13                                                   ; $23ce
	ret  nz                                                    ; $23d0

; can make pieces fall again
	ld   [wCanPressDownToMakePieceFall], a                     ; $23d1

; display buffer with updated rows
	ld   hl, _SCRN0+2                                          ; $23d4
	ld   de, wGameScreenBuffer+2                               ; $23d7
	call CopyRamBufferRowToVram                                ; $23da

; clear state of rows falling and check player
	lda ROWS_SHIFTING_DOWN_NONE                                ; $23dd
	ldh  [hRowsShiftingDownState], a                           ; $23de

	ldh  a, [hIs2Player]                                       ; $23e0
	and  a                                                     ; $23e2
	ldh  a, [hGameState]                                       ; $23e3
	jr   nz, .is2player                                        ; $23e5

; is 1 player, ret if not GS_IN_GAME_MAIN
	and  a                                                     ; $23e7
	ret  nz                                                    ; $23e8

.getLinesToDisplay:
; below is for Type A
	ld   hl, _SCRN0+$14e                                       ; $23e9
	ld   de, hNumLinesCompletedBCD+1                           ; $23ec
	ld   c, $02                                                ; $23ef

	ldh  a, [hGameType]                                        ; $23f1
	cp   GAME_TYPE_A_TYPE                                      ; $23f3
	jr   z, .displayLines                                      ; $23f5

; B type
	ld   hl, _SCRN0+$150                                       ; $23f7
	ld   de, hNumLinesCompletedBCD                             ; $23fa
	ld   c, $01                                                ; $23fd

.displayLines:
	call DisplayBCDNum2CDigits                                 ; $23ff
	ldh  a, [hGameType]                                        ; $2402

; simply play next piece for type A game
	cp   GAME_TYPE_A_TYPE                                      ; $2404
	jr   z, .playNextPiece                                     ; $2406

; play next piece if type B and still outstanding lines to do
	ldh  a, [hNumLinesCompletedBCD]                            ; $2408
	and  a                                                     ; $240a
	jr   nz, .playNextPiece                                    ; $240b

; set timer, and play song
	ld   a, $64                                                ; $240d
	ldh  [hTimer1], a                                          ; $240f

	ld   a, MUS_B_TYPE_LEVEL_FINISHED                          ; $2411
	ld   [wSongToStart], a                                     ; $2413

; end of level updates
	ldh  a, [hIs2Player]                                       ; $2416
	and  a                                                     ; $2418
	jr   z, .is1playerEnd                                      ; $2419

; is 2 player
	ldh  [$d5], a                                    ; $241b: $e0 $d5
	ret                                              ; $241d: $c9

.is1playerEnd:
; set game state based on if max level
	ldh  a, [hBTypeLevel]                                      ; $241e
	cp   $09                                                   ; $2420
	ld   a, GS_B_TYPE_LEVEL_FINISHED                           ; $2422
	jr   nz, .setGameState                                     ; $2424

	ld   a, GS_DANCERS_INIT                                    ; $2426

.setGameState:
	ldh  [hGameState], a                                       ; $2428
	ret                                                        ; $242a

.playNextPiece:
	call PlayNextPieceLoadNextAndHiddenPiece                   ; $242b
	ret                                                        ; $242e

.is2player:
	cp   GS_2PLAYER_IN_GAME_MAIN                                         ; $242f: $fe $1a
	ret  nz                                          ; $2431: $c0

	ldh  a, [$d4]                                    ; $2432: $f0 $d4
	and  a                                           ; $2434: $a7
	jr   z, .getLinesToDisplay                              ; $2435: $28 $b2

	xor  a                                           ; $2437: $af
	ldh  [$d4], a                                    ; $2438: $e0 $d4
	ret                                              ; $243a: $c9


DisplayGameATypeScoreIfInGameAndForced:
; ret if not in-game
	ldh  a, [hGameState]                                       ; $243b
	and  a                                                     ; $243d
	ret  nz                                                    ; $243e

; score is relevant for A-type
	ldh  a, [hGameType]                                        ; $243f
	cp   GAME_TYPE_A_TYPE                                      ; $2441
	ret  nz                                                    ; $2443

	ld   de, wScoreBCD+2                                       ; $2444
	call DisplayBCDNum6DigitsIfForced                          ; $2447
	ret                                                        ; $244a


; eg for level 0, must do 10 lines. For level 1, must do 20 lines, etc
CheckIfATypeNextLevelReached:
; ret if not in-game
	ldh  a, [hGameState]                                       ; $244b
	and  a                                                     ; $244d
	ret  nz                                                    ; $244e

; ret if not A-type
	ldh  a, [hGameType]                                        ; $244f
	cp   GAME_TYPE_A_TYPE                                      ; $2451
	ret  nz                                                    ; $2453

; ret if == $14 (max value of level 20)
	ld   hl, hATypeLinesThresholdToPassForNextLevel            ; $2454
	ld   a, [hl]                                               ; $2457
	cp   $14                                                   ; $2458
	ret  z                                                     ; $245a

; a and b is level
	call ABisBCDofValInHL                                      ; $245b

; get num lines completed BCD+1, and ret if >= 1000
	ldh  a, [hNumLinesCompletedBCD+1]                          ; $245e
	ld   d, a                                                  ; $2460
	and  $f0                                                   ; $2461
	ret  nz                                                    ; $2463

; get num lines completed units digit, in tens spot in D
	ld   a, d                                                  ; $2464
	and  $0f                                                   ; $2465
	swap a                                                     ; $2467
	ld   d, a                                                  ; $2469

; get num lines completed low byte's tens digit in units spot in D
	ldh  a, [hNumLinesCompletedBCD]                            ; $246a
	and  $f0                                                   ; $246c
	swap a                                                     ; $246e
	or   d                                                     ; $2470

; return if that value is now less than or equal to the lines threshold for level
	cp   b                                                     ; $2471
	ret  c                                                     ; $2472

	ret  z                                                     ; $2473

; else inc that lines threshold, and put low digit in C
	inc  [hl]                                                  ; $2474
	call ABisBCDofValInHL                                      ; $2475
	and  $0f                                                   ; $2478
	ld   c, a                                                  ; $247a

; loop twice for units, then tens digit
	ld   hl, _SCRN0+$f1                                        ; $247b

.nextDigit:
; lines threshold in vram for both screens
	ld   [hl], c                                               ; $247e
	ld   h, HIGH(_SCRN1+$f1)                                   ; $247f
	ld   [hl], c                                               ; $2481

; get high digit in C
	ld   a, b                                                  ; $2482
	and  $f0                                                   ; $2483
	jr   z, .afterSendingNewLevelToVram                        ; $2485

	swap a                                                     ; $2487
	ld   c, a                                                  ; $2489

; end after next loop
	ld   a, l                                                  ; $248a
	cp   $f0                                                   ; $248b
	jr   z, .afterSendingNewLevelToVram                        ; $248d

	ld   hl, _SCRN0+$f0                                        ; $248f
	jr   .nextDigit                                            ; $2492

.afterSendingNewLevelToVram:
	ld   a, SND_REACHED_NEXT_LEVEL                             ; $2494
	ld   [wSquareSoundToPlay], a                               ; $2496
	call SetNumFramesUntilPiecesMoveDown                       ; $2499
	ret                                                        ; $249c


ABisBCDofValInHL:
; ret if [hl] == 0, else put in B
	ld   a, [hl]                                               ; $249d
	ld   b, a                                                  ; $249e
	and  a                                                     ; $249f
	ret  z                                                     ; $24a0

; with A = 0, += 1 with daa until B = 0
	xor  a                                                     ; $24a1

.loop:
	or   a                                                     ; $24a2
	inc  a                                                     ; $24a3
	daa                                                        ; $24a4
	dec  b                                                     ; $24a5
	jr   z, .copyAtoB                                          ; $24a6

	jr   .loop                                                 ; $24a8

.copyAtoB:
	ld   b, a                                                  ; $24aa
	ret                                                        ; $24ab


CopyRamBufferRowToVram:
	ld   b, GAME_SQUARE_WIDTH                                  ; $24ac

.loop:
	ld   a, [de]                                               ; $24ae
	ld   [hl], a                                               ; $24af
	inc  l                                                     ; $24b0
	inc  e                                                     ; $24b1
	dec  b                                                     ; $24b2
	jr   nz, .loop                                             ; $24b3

; copy next row next vblank
	ldh  a, [hRowsShiftingDownState]                           ; $24b5
	inc  a                                                     ; $24b7
	ldh  [hRowsShiftingDownState], a                           ; $24b8
	ret                                                        ; $24ba


InGameCheckButtonsPressed:
; return if piece not in play (hit bottom)
	ld   hl, wSpriteSpecs                                      ; $24bb
	ld   a, [hl]                                               ; $24be
	cp   SPRITE_SPEC_HIDDEN                                    ; $24bf
	ret  z                                                     ; $24c1

	ld   l, SPR_SPEC_SpecIdx                                   ; $24c2
	ld   a, [hl]                                               ; $24c4
	ldh  [hPreRotationSpecIdx], a                              ; $24c5

; check if rotating
	ldh  a, [hButtonsPressed]                                  ; $24c7
	ld   b, a                                                  ; $24c9
	bit  PADB_B, b                                             ; $24ca
	jr   nz, .pressedB                                         ; $24cc

	bit  PADB_A, b                                             ; $24ce
	jr   z, .afterCollisionCheck                               ; $24d0

; pressed A, spec idx -= 1, wrapping 0 to 3
	ld   a, [hl]                                               ; $24d2
	and  $03                                                   ; $24d3
	jr   z, .pressedAAnimation0                                ; $24d5

	dec  [hl]                                                  ; $24d7
	jr   .afterRotation                                        ; $24d8

.pressedAAnimation0:
	ld   a, [hl]                                               ; $24da
	or   $03                                                   ; $24db
	ld   [hl], a                                               ; $24dd
	jr   .afterRotation                                        ; $24de

.pressedB:
; spec idx += 1, wrapping 3 to 0
	ld   a, [hl]                                               ; $24e0
	and  $03                                                   ; $24e1
	cp   $03                                                   ; $24e3
	jr   z, .pressedBAnimation3                                ; $24e5

	inc  [hl]                                                  ; $24e7
	jr   .afterRotation                                        ; $24e8

.pressedBAnimation3:
	ld   a, [hl]                                               ; $24ea
	and  $fc                                                   ; $24eb
	ld   [hl], a                                               ; $24ed

.afterRotation:
; play rotate sound and send to oam
	ld   a, SND_PIECE_ROTATED                                  ; $24ee
	ld   [wSquareSoundToPlay], a                               ; $24f0
	call Copy1stSpriteSpecToSprite4                            ; $24f3
	call RetZIfNoCollisionForPiece                             ; $24f6
	and  a                                                     ; $24f9
	jr   z, .afterCollisionCheck                               ; $24fa

; collision detected, dont play sound, use orig spec idx and send to oam
	lda SND_NONE                                               ; $24fc
	ld   [wSquareSoundToPlay], a                               ; $24fd
	ld   hl, wSpriteSpecs+SPR_SPEC_SpecIdx                     ; $2500
	ldh  a, [hPreRotationSpecIdx]                              ; $2503
	ld   [hl], a                                               ; $2505
	call Copy1stSpriteSpecToSprite4                            ; $2506

.afterCollisionCheck:
; check horiz movement, buttons pressed in B, buttons held in C
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseXOffset                 ; $2509
	ldh  a, [hButtonsPressed]                                  ; $250c
	ld   b, a                                                  ; $250e
	ldh  a, [hButtonsHeld]                                     ; $250f
	ld   c, a                                                  ; $2511

; store orig X
	ld   a, [hl]                                               ; $2512
	ldh  [hPreHorizMovementSpecIdx], a                         ; $2513
	bit  PADB_RIGHT, b                                         ; $2515

; orig sticky counter
	ld   a, $17                                                ; $2517
	jr   nz, .pressedRight                                     ; $2519

	bit  PADB_RIGHT, c                                         ; $251b
	jr   z, .notHeldRight                                      ; $251d

; held right, process when sticky counter at 0
	ldh  a, [hStickyButtonCounter]                             ; $251f
	dec  a                                                     ; $2521
	ldh  [hStickyButtonCounter], a                             ; $2522
	ret  nz                                                    ; $2524

	ld   a, $09                                                ; $2525

.pressedRight:
	ldh  [hStickyButtonCounter], a                             ; $2527

; add 8 to X, send to oam, play sound and check collision
	ld   a, [hl]                                               ; $2529
	add  $08                                                   ; $252a
	ld   [hl], a                                               ; $252c
	call Copy1stSpriteSpecToSprite4                            ; $252d
	ld   a, SND_PIECE_MOVED_HORIZ                              ; $2530
	ld   [wSquareSoundToPlay], a                               ; $2532
	call RetZIfNoCollisionForPiece                             ; $2535
	and  a                                                     ; $2538
	ret  z                                                     ; $2539

.afterHorizCollisionCheck:
; collision detected, dont play a sound, get back orig X,
; send to OAM and use lowest sticky counter to allow rotating if moving
	ld   hl, wSpriteSpecs+SPR_SPEC_BaseXOffset                 ; $253a
	lda SND_NONE                                               ; $253d
	ld   [wSquareSoundToPlay], a                               ; $253e
	ldh  a, [hPreHorizMovementSpecIdx]                         ; $2541
	ld   [hl], a                                               ; $2543
	call Copy1stSpriteSpecToSprite4                            ; $2544
	ld   a, $01                                                ; $2547

.notHeldLeft:
; store highest val in sticky counter
	ldh  [hStickyButtonCounter], a                             ; $2549
	ret                                                        ; $254b

.notHeldRight:
	bit  PADB_LEFT, b                                          ; $254c

; sticky counter
	ld   a, $17                                                ; $254e
	jr   nz, .pressedLeft                                      ; $2550

	bit  PADB_LEFT, c                                          ; $2552
	jr   z, .notHeldLeft                                       ; $2554

; process left when sticky counter is 0
	ldh  a, [hStickyButtonCounter]                             ; $2556
	dec  a                                                     ; $2558
	ldh  [hStickyButtonCounter], a                             ; $2559
	ret  nz                                                    ; $255b

	ld   a, $09                                                ; $255c

.pressedLeft:
	ldh  [hStickyButtonCounter], a                             ; $255e

; X -= 8, play sound, send to oam, and check for collision
	ld   a, [hl]                                               ; $2560
	sub  $08                                                   ; $2561
	ld   [hl], a                                               ; $2563
	ld   a, SND_PIECE_MOVED_HORIZ                              ; $2564
	ld   [wSquareSoundToPlay], a                               ; $2566
	call Copy1stSpriteSpecToSprite4                            ; $2569
	call RetZIfNoCollisionForPiece                             ; $256c
	and  a                                                     ; $256f
	ret  z                                                     ; $2570

	jr   .afterHorizCollisionCheck                             ; $2571


RetZIfNoCollisionForPiece:
; hl is 1st address for active piece
	ld   hl, wOam+OAM_SIZEOF*4                                 ; $2573
	ld   b, $04                                                ; $2576

.nextSprite:
; get Y into A
	ld   a, [hl+]                                              ; $2578
	ldh  [hCurrPieceSquarePixelY], a                           ; $2579

; jump if X became 0 somehow
	ld   a, [hl+]                                              ; $257b
	and  a                                                     ; $257c
	jr   z, .fromXis0                                          ; $257d

	ldh  [hCurrPieceSquarePixelX], a                           ; $257f

; push oam address for tile idx, and num sprites left
	push hl                                                    ; $2581
	push bc                                                    ; $2582
	call GetScreen0AddressOfPieceSquare                        ; $2583

; get ram buffer address
	ld   a, h                                                  ; $2586
	add  HIGH(wGameScreenBuffer-_SCRN0)                        ; $2587
	ld   h, a                                                  ; $2589
	ld   a, [hl]                                               ; $258a
	cp   TILE_EMPTY                                            ; $258b
	jr   nz, .notEmpty                                         ; $258d

; is empty tile, get tile idx address and inc to next sprite Y
	pop  bc                                                    ; $258f
	pop  hl                                                    ; $2590
	inc  l                                                     ; $2591
	inc  l                                                     ; $2592

; to next sprite
	dec  b                                                     ; $2593
	jr   nz, .nextSprite                                       ; $2594

; or num sprites left = 0 (ie all blanks at piece)
.fromXis0:
	xor  a                                                     ; $2596
	ldh  [hPieceCollisionDetected], a                          ; $2597
	ret                                                        ; $2599

.notEmpty:
	pop  bc                                                    ; $259a
	pop  hl                                                    ; $259b
	ld   a, $01                                                ; $259c
	ldh  [hPieceCollisionDetected], a                          ; $259e
	ret                                                        ; $25a0


InGameAddPieceToVram:
; ret if wrong state
	ldh  a, [hPieceFallingState]                               ; $25a1
	cp   FALLING_PIECE_HIT_BOTTOM                              ; $25a3
	ret  nz                                                    ; $25a5

; piece is 4 squares, get oam details for played piece
	ld   hl, wOam+OAM_SIZEOF*4                                 ; $25a6
	ld   b, $04                                                ; $25a9

.nextSquareOfPiece:
; get square Y
	ld   a, [hl+]                                              ; $25ab
	ldh  [hCurrPieceSquarePixelY], a                           ; $25ac

; if square X = 0, we're done here
	ld   a, [hl+]                                              ; $25ae
	and  a                                                     ; $25af
	jr   z, .nextState                                         ; $25b0

	ldh  [hCurrPieceSquarePixelX], a                           ; $25b2

; preserve while getting screen addr of square
	push hl                                                    ; $25b4
	push bc                                                    ; $25b5
	call GetScreen0AddressOfPieceSquare                        ; $25b6
; screen 0 addr in de
	push hl                                                    ; $25b9
	pop  de                                                    ; $25ba
	pop  bc                                                    ; $25bb
	pop  hl                                                    ; $25bc

.waitUntilVramAndOamFree:
	ldh  a, [rSTAT]                                            ; $25bd
	and  STATF_LCD                                             ; $25bf
	jr   nz, .waitUntilVramAndOamFree                          ; $25c1

; store tile index into screen 0
	ld   a, [hl]                                               ; $25c3
	ld   [de], a                                               ; $25c4

; as well as game screen buffer
	ld   a, d                                                  ; $25c5
	add  HIGH(wGameScreenBuffer-_SCRN0)                        ; $25c6
	ld   d, a                                                  ; $25c8
	ld   a, [hl+]                                              ; $25c9
	ld   [de], a                                               ; $25ca
	inc  l                                                     ; $25cb
	dec  b                                                     ; $25cc
	jr   nz, .nextSquareOfPiece                                ; $25cd

.nextState:
	ld   a, FALLING_PIECE_CHECK_COMPLETED_ROWS                 ; $25cf
	ldh  [hPieceFallingState], a                               ; $25d1

; hide active piece
	ld   hl, wSpriteSpecs                                      ; $25d3
	ld   [hl], SPRITE_SPEC_HIDDEN                              ; $25d6
	ret                                                        ; $25d8


; in: BC - vram dest of counts of current num lines
; in: DE - score for line count
; in: HL - ram source of line count byte struct
ProcessCurrentScoreCategory:
; jump if current is updating
	ld   a, [wCurrScoreCategIsProcessingOrUpdating]            ; $25d9
	cp   $02                                                   ; $25dc
	jr   z, .displayTotalScoreWhileCurrentCategIsUpdating      ; $25de

; push score categ, and jump if num lines in categ = 0
	push de                                                    ; $25e0
	ld   a, [hl]                                               ; $25e1
	or   a                                                     ; $25e2
	jr   z, .currentCategScoreLineCountEqu0                    ; $25e3

; reduce the count by 1, and increase the next by 1
	dec  a                                                     ; $25e5
	ld   [hl+], a                                              ; $25e6
	ld   a, [hl]                                               ; $25e7
	inc  a                                                     ; $25e8
	daa                                                        ; $25e9
	ld   [hl], a                                               ; $25ea

; display units
	and  $0f                                                   ; $25eb
	ld   [bc], a                                               ; $25ed

; go left a tile and display tens if non-0
	dec  c                                                     ; $25ee
	ld   a, [hl+]                                              ; $25ef
	swap a                                                     ; $25f0
	and  $0f                                                   ; $25f2
	jr   z, .afterDisplaying10s                                ; $25f4

	ld   [bc], a                                               ; $25f6

.afterDisplaying10s:
; push 10s vram dest, add (level+1) * categ score
	push bc                                                    ; $25f7
	ldh  a, [hBTypeLevel]                                      ; $25f8
	ld   b, a                                                  ; $25fa
	inc  b                                                     ; $25fb

.addCategScore:
	push hl                                                    ; $25fc
	call AddScoreValueDEontoBaseScoreHL                        ; $25fd
	pop  hl                                                    ; $2600
	dec  b                                                     ; $2601
	jr   nz, .addCategScore                                    ; $2602

; pop 10s vram dest, inc hl to last struct byte, and push it
	pop  bc                                                    ; $2604
	inc  hl                                                    ; $2605
	inc  hl                                                    ; $2606
	push hl                                                    ; $2607

; hl equals vram dest of highest byte of total score for categ
	ld   hl, $0023                                             ; $2608
	add  hl, bc                                                ; $260b

; de = address of last struct byte, to display it
	pop  de                                                    ; $260c
	call DisplayBCDNum6Digits                                  ; $260d

; de = 10s vram dest of categ count
	pop  de                                                    ; $2610

; add the categ score onto the total score
	ldh  a, [hBTypeLevel]                                      ; $2611
	ld   b, a                                                  ; $2613
	inc  b                                                     ; $2614
	ld   hl, wScoreBCD                                         ; $2615

.addToTotalScore:
	push hl                                                    ; $2618
	call AddScoreValueDEontoBaseScoreHL                        ; $2619
	pop  hl                                                    ; $261c
	dec  b                                                     ; $261d
	jr   nz, .addToTotalScore                                  ; $261e

; set to is updating
	ld   a, $02                                                ; $2620
	ld   [wCurrScoreCategIsProcessingOrUpdating], a            ; $2622
	ret                                                        ; $2625

.displayTotalScoreWhileCurrentCategIsUpdating:
; display total score for stage
	ld   de, wScoreBCD+2                                       ; $2626
	ld   hl, $9a25                                             ; $2629
	call DisplayBCDNum6Digits                                  ; $262c

; play sound and no more updates until game state B allows it after 5 frames
	ld   a, SND_CONFIRM_OR_LETTER_TYPED                        ; $262f
	ld   [wSquareSoundToPlay], a                               ; $2631

	xor  a                                                     ; $2634
	ld   [wCurrScoreCategIsProcessingOrUpdating], a            ; $2635
	ret                                                        ; $2638

; ie when updating is done
.currentCategScoreLineCountEqu0:
	pop  de                                                    ; $2639

IncScoreCategoryProcessedAfterBTypeDone:
; higher timer after each category
	ld   a, $21                                                ; $263a
	ldh  [hTimer1], a                                          ; $263c

	xor  a                                                     ; $263e
	ld   [wCurrScoreCategIsProcessingOrUpdating], a            ; $263f

; set states after 4 lines processed, and drops processed
	ld   a, [wNumScoreCategoriesProcessed]                     ; $2642
	inc  a                                                     ; $2645
	ld   [wNumScoreCategoriesProcessed], a                     ; $2646
	cp   $05                                                   ; $2649
	ret  nz                                                    ; $264b

	ld   a, GS_LEVEL_ENDED_MAIN                                ; $264c
	ldh  [hGameState], a                                       ; $264e
	ret                                                        ; $2650


ClearScoreCategoryVarsAndTotalScore:
; clear score category vars
	ld   hl, wLinesClearedStructs                              ; $2651
	ld   b, wScoreCategoryVarsEnd-wLinesClearedStructs         ; $2654
	xor  a                                                     ; $2656

.clearStructs:
	ld   [hl+], a                                              ; $2657
	dec  b                                                     ; $2658
	jr   nz, .clearStructs                                     ; $2659

; clear current/total score
	ld   hl, wScoreBCD                                         ; $265b
	ld   b, $03                                                ; $265e

.clearScore:
	ld   [hl+], a                                              ; $2660
	dec  b                                                     ; $2661
	jr   nz, .clearScore                                       ; $2662

	ret                                                        ; $2664


UnusedStoreBCDByteInHLInDestDE:
	ld   a, [hl]                                               ; $2665
	and  $f0                                                   ; $2666
	swap a                                                     ; $2668
	ld   [de], a                                               ; $266a
	ld   a, [hl]                                               ; $266b
	and  $0f                                                   ; $266c
	inc  e                                                     ; $266e
	ld   [de], a                                               ; $266f
	ret                                                        ; $2670


Copy2SpriteSpecsToShadowOam:
	ld   a, $02                                                ; $2671

CopyASpriteSpecsToShadowOam:
	ldh  [hNumSpriteSpecs], a                                  ; $2673

	; LOW(wOam)
	xor  a                                                     ; $2675
	ldh  [hCurr_wOam_SpriteAddr+1], a                          ; $2676
	ld   a, HIGH(wOam)                                         ; $2678
	ldh  [hCurr_wOam_SpriteAddr], a                            ; $267a

	ld   hl, wSpriteSpecs                                      ; $267c
	call CopyToShadowOamBasedOnSpriteSpec                      ; $267f
	ret                                                        ; $2682


Copy1stSpriteSpecToSprite4:
	ld   a, $01                                                ; $2683
	ldh  [hNumSpriteSpecs], a                                  ; $2685
	ld   a, LOW(wOam+OAM_SIZEOF*4)                             ; $2687
	ldh  [hCurr_wOam_SpriteAddr+1], a                          ; $2689
	ld   a, HIGH(wOam+OAM_SIZEOF*4)                            ; $268b
	ldh  [hCurr_wOam_SpriteAddr], a                            ; $268d
	ld   hl, wSpriteSpecs                                      ; $268f
	call CopyToShadowOamBasedOnSpriteSpec                      ; $2692
	ret                                                        ; $2695


Copy2ndSpriteSpecToSprite8:
	ld   a, $01                                                ; $2696
	ldh  [hNumSpriteSpecs], a                                  ; $2698
	ld   a, LOW(wOam+OAM_SIZEOF*8)                             ; $269a
	ldh  [hCurr_wOam_SpriteAddr+1], a                          ; $269c
	ld   a, HIGH(wOam+OAM_SIZEOF*8)                            ; $269e
	ldh  [hCurr_wOam_SpriteAddr], a                            ; $26a0
	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                      ; $26a2
	call CopyToShadowOamBasedOnSpriteSpec                      ; $26a5
	ret                                                        ; $26a8


DisplayBlackColumnFromHLdown:
	ld   b, GB_TILE_HEIGHT                                     ; $26a9
	ld   a, TILE_BLACK                                         ; $26ab
	ld   de, GB_TILE_WIDTH                                     ; $26ad

.loop:
	ld   [hl], a                                               ; $26b0
	add  hl, de                                                ; $26b1
	dec  b                                                     ; $26b2
	jr   nz, .loop                                             ; $26b3

	ret                                                        ; $26b5


CopyDEintoHLwhileFFhNotFound:
.loop:
	ld   a, [de]                                               ; $26b6
	cp   $ff                                                   ; $26b7
	ret  z                                                     ; $26b9

	ld   [hl+], a                                              ; $26ba
	inc  de                                                    ; $26bb
	jr   .loop                                                 ; $26bc


StubInterruptHandler:
	reti                                                       ; $26be


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
	ld   hl, _SCRN0+$3ff                                       ; $2795

FillScreenFromHLdownWithEmptyTile:
	ld   bc, $0400                                             ; $2798

.loop:
	ld   a, TILE_EMPTY                                         ; $279b
	ld   [hl-], a                                              ; $279d
	dec  bc                                                    ; $279e
	ld   a, b                                                  ; $279f
	or   c                                                     ; $27a0
	jr   nz, .loop                                             ; $27a1

	ret                                                        ; $27a3


CopyHLtoDE_BCbytes:
.loop:
	ld   a, [hl+]                                              ; $27a4
	ld   [de], a                                               ; $27a5
	inc  de                                                    ; $27a6
	dec  bc                                                    ; $27a7
	ld   a, b                                                  ; $27a8
	or   c                                                     ; $27a9
	jr   nz, .loop                                             ; $27aa

	ret                                                        ; $27ac


LoadAsciiAndMenuScreenGfx:
	call CopyAsciiTileData                                     ; $27ad

; further graphics (menu screen bits) after ascii from title screen
	ld   bc, $00a0                                             ; $27b0
	call CopyHLtoDE_BCbytes                                    ; $27b3

	ld   hl, Gfx_MenuScreens                                   ; $27b6
	ld   de, _VRAM+$300                                        ; $27b9
	ld   bc, Gfx_MenuScreens.end-Gfx_MenuScreens+$b0           ; $27bc
	call CopyHLtoDE_BCbytes                                    ; $27bf
	ret                                                        ; $27c2


CopyAsciiTileData:
	ld   hl, Gfx_Ascii                                         ; $27c3
	ld   bc, Gfx_Ascii.end-Gfx_Ascii                           ; $27c6
	ld   de, _VRAM                                             ; $27c9

.loop:
	ld   a, [hl+]                                              ; $27cc
	ld   [de], a                                               ; $27cd
	inc  de                                                    ; $27ce
	ld   [de], a                                               ; $27cf
	inc  de                                                    ; $27d0
	dec  bc                                                    ; $27d1
	ld   a, b                                                  ; $27d2
	or   c                                                     ; $27d3
	jr   nz, .loop                                             ; $27d4

	ret                                                        ; $27d6


CopyAsciiAndTitleScreenTileData:
	call CopyAsciiTileData                                     ; $27d7

; overruns into tile layout, actually $770 bytes
	ld   bc, Gfx_TitleScreen.end-Gfx_TitleScreen+$0630         ; $27da
	call CopyHLtoDE_BCbytes                                    ; $27dd
	ret                                                        ; $27e0


UnusedCopyHLtoVram1000hBytes:
	ld   bc, $1000                                             ; $27e1

CopyHLtoVramBCbytes:
	ld   de, _VRAM                                             ; $27e4
	call CopyHLtoDE_BCbytes                                    ; $27e7

Stub_27ea:
	ret                                                        ; $27ea


; in: DE - source addr
CopyLayoutToScreen0:
	ld   hl, _SCRN0                                            ; $27eb

; in: DE - source addr
; in: HL - vram dest addr
CopyLayoutToHL:
	ld   b, SCREEN_TILE_HEIGHT                                 ; $27ee

; in: B - number of rows to copy to
; in: DE - source addr
; in: HL - vram dest addr
CopyLayoutBrowsToHL:
.loopRow:
; push current start vram addr
	push hl                                                    ; $27f0
	ld   c, SCREEN_TILE_WIDTH                                  ; $27f1

.loopCol:
	ld   a, [de]                                               ; $27f3
	ld   [hl+], a                                              ; $27f4
	inc  de                                                    ; $27f5
	dec  c                                                     ; $27f6
	jr   nz, .loopCol                                          ; $27f7

; next row below start of current
	pop  hl                                                    ; $27f9
	push de                                                    ; $27fa
	ld   de, GB_TILE_WIDTH                                     ; $27fb
	add  hl, de                                                ; $27fe
	pop  de                                                    ; $27ff
	dec  b                                                     ; $2800
	jr   nz, .loopRow                                          ; $2801

	ret                                                        ; $2803


CopyToGameScreenUntilByteReadEquFFhThenSetVramTransfer:
.nextRow:
	ld   b, GAME_SQUARE_WIDTH                                  ; $2804
	push hl                                                    ; $2806

.loop:
; done when byte read == $ff
	ld   a, [de]                                               ; $2807
	cp   $ff                                                   ; $2808
	jr   z, .done                                              ; $280a

; copy to dest
	ld   [hl+], a                                              ; $280c
	inc  de                                                    ; $280d
	dec  b                                                     ; $280e
	jr   nz, .loop                                             ; $280f

; to next row
	pop  hl                                                    ; $2811
	push de                                                    ; $2812
	ld   de, GB_TILE_WIDTH                                     ; $2813
	add  hl, de                                                ; $2816
	pop  de                                                    ; $2817
	jr   .nextRow                                              ; $2818

.done:
	pop  hl                                                    ; $281a

; transfer to vram a row at a time
	ld   a, ROWS_SHIFTING_DOWN_ROW_START                       ; $281b
	ldh  [hRowsShiftingDownState], a                           ; $281d
	ret                                                        ; $281f


TurnOffLCD:
; preserve IE
	ldh  a, [rIE]                                              ; $2820

; disable vblank interrupt
	ldh  [hTempIE], a                                          ; $2822
	res  0, a                                                  ; $2824
	ldh  [rIE], a                                              ; $2826

.waitUntilInVBlank:
	ldh  a, [rLY]                                              ; $2828
	cp   $91                                                   ; $282a
	jr   nz, .waitUntilInVBlank                                ; $282c

; turn off LCD
	ldh  a, [rLCDC]                                            ; $282e
	and  $ff-LCDCF_ON                                          ; $2830
	ldh  [rLCDC], a                                            ; $2832

; restore IE
	ldh  a, [hTempIE]                                          ; $2834
	ldh  [rIE], a                                              ; $2836
	ret                                                        ; $2838


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
	ld   a, $20                                                ; $29a6
	ldh  [rP1], a                                              ; $29a8
	ldh  a, [rP1]                                              ; $29aa
	ldh  a, [rP1]                                              ; $29ac
	ldh  a, [rP1]                                              ; $29ae
	ldh  a, [rP1]                                              ; $29b0
	cpl                                                        ; $29b2
	and  $0f                                                   ; $29b3
	swap a                                                     ; $29b5
	ld   b, a                                                  ; $29b7
	ld   a, $10                                                ; $29b8
	ldh  [rP1], a                                              ; $29ba
	ldh  a, [rP1]                                              ; $29bc
	ldh  a, [rP1]                                              ; $29be
	ldh  a, [rP1]                                              ; $29c0
	ldh  a, [rP1]                                              ; $29c2
	ldh  a, [rP1]                                              ; $29c4
	ldh  a, [rP1]                                              ; $29c6
	ldh  a, [rP1]                                              ; $29c8
	ldh  a, [rP1]                                              ; $29ca
	ldh  a, [rP1]                                              ; $29cc
	ldh  a, [rP1]                                              ; $29ce
	cpl                                                        ; $29d0
	and  $0f                                                   ; $29d1
	or   b                                                     ; $29d3
	ld   c, a                                                  ; $29d4
	ldh  a, [hButtonsHeld]                                     ; $29d5
	xor  c                                                     ; $29d7
	and  c                                                     ; $29d8
	ldh  [hButtonsPressed], a                                  ; $29d9
	ld   a, c                                                  ; $29db
	ldh  [hButtonsHeld], a                                     ; $29dc
	ld   a, $30                                                ; $29de
	ldh  [rP1], a                                              ; $29e0
	ret                                                        ; $29e2


GetScreen0AddressOfPieceSquare:
; get square tile Y
	ldh  a, [hCurrPieceSquarePixelY]                           ; $29e3
	sub  PIECE_START_Y                                         ; $29e5
	srl  a                                                     ; $29e7
	srl  a                                                     ; $29e9
	srl  a                                                     ; $29eb
	ld   de, $0000                                             ; $29ed
	ld   e, a                                                  ; $29f0

; get row offset in screen 0
	ld   hl, _SCRN0                                            ; $29f1
	ld   b, $20                                                ; $29f4

.loop:
	add  hl, de                                                ; $29f6
	dec  b                                                     ; $29f7
	jr   nz, .loop                                             ; $29f8

; get square tile X
	ldh  a, [hCurrPieceSquarePixelX]                           ; $29fa
	sub  $08                                                   ; $29fc
	srl  a                                                     ; $29fe
	srl  a                                                     ; $2a00
	srl  a                                                     ; $2a02
	ld   de, $0000                                             ; $2a04
	ld   e, a                                                  ; $2a07

; add onto screen 0
	add  hl, de                                                ; $2a08
	ld   a, h                                                  ; $2a09
	ldh  [hCurrPieceSquareScreen0Addr+1], a                    ; $2a0a
	ld   a, l                                                  ; $2a0c
	ldh  [hCurrPieceSquareScreen0Addr], a                      ; $2a0d
	ret                                                        ; $2a0f


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
	ldh  a, [hFoundDisplayableScoreDigit]                      ; $2a36
	and  a                                                     ; $2a38
	ret  z                                                     ; $2a39

DisplayBCDNum6Digits:
	ld   c, $03                                                ; $2a3a

DisplayBCDNum2CDigits:
	xor  a                                                     ; $2a3c
	ldh  [hFoundDisplayableScoreDigit], a                      ; $2a3d

.nextByte:
; put byte in B
	ld   a, [de]                                               ; $2a3f
	ld   b, a                                                  ; $2a40

; check tens bit of byte
	swap a                                                     ; $2a41
	and  $0f                                                   ; $2a43
	jr   nz, .tensNot0                                         ; $2a45

; tens bit of byte = 0, use empty or 0 based on if we're drawing digits
	ldh  a, [hFoundDisplayableScoreDigit]                      ; $2a47
	and  a                                                     ; $2a49
	ld   a, TILE_0                                             ; $2a4a
	jr   nz, .displayTens                                      ; $2a4c

	ld   a, TILE_EMPTY                                         ; $2a4e

.displayTens:
	ld   [hl+], a                                              ; $2a50

; check low digit
	ld   a, b                                                  ; $2a51
	and  $0f                                                   ; $2a52
	jr   nz, .onesNot0                                         ; $2a54

; digit = 0
	ldh  a, [hFoundDisplayableScoreDigit]                      ; $2a56
	and  a                                                     ; $2a58
	ld   a, TILE_0                                             ; $2a59
	jr   nz, .displayOnes                                      ; $2a5b

; not displaying tiles yet, display 0 digit if last byte
	ld   a, $01                                                ; $2a5d
	cp   c                                                     ; $2a5f
	ld   a, TILE_0                                             ; $2a60
	jr   z, .displayOnes                                       ; $2a62

	ld   a, TILE_EMPTY                                         ; $2a64

.displayOnes:
	ld   [hl+], a                                              ; $2a66

; next vram dest and C
	dec  e                                                     ; $2a67
	dec  c                                                     ; $2a68
	jr   nz, .nextByte                                         ; $2a69

; reset this for next display
	xor  a                                                     ; $2a6b
	ldh  [hFoundDisplayableScoreDigit], a                      ; $2a6c
	ret                                                        ; $2a6e

; for below 2 labels, set that we can now display further digits even if 0
.tensNot0:
	push af                                                    ; $2a6f
	ld   a, $01                                                ; $2a70
	ldh  [hFoundDisplayableScoreDigit], a                      ; $2a72
	pop  af                                                    ; $2a74
	jr   .displayTens                                          ; $2a75

.onesNot0:
	push af                                                    ; $2a77
	ld   a, $01                                                ; $2a78
	ldh  [hFoundDisplayableScoreDigit], a                      ; $2a7a
	pop  af                                                    ; $2a7c
	jr   .displayOnes                                          ; $2a7d


OamDmaFunction:
	ld   a, HIGH(wOam)                                         ; $2a7f
	ldh  [rDMA], a                                             ; $2a81
	ld   a, $28                                                ; $2a83

.wait:
	dec  a                                                     ; $2a85
	jr   nz, .wait                                             ; $2a86

	ret                                                        ; $2a88


; HL - source of sprite specs, used to generate sprite vars, $10 per spec
; [HL+0] - 0 if showing sprites, $80 if hiding the sprites
; [$8f] - num sprite specs
; difference between base y/x and the offset vars, is that base is the center of the tile
;   where y and x flipping flip around
CopyToShadowOamBasedOnSpriteSpec:
.nextStructInSpriteSpec:
; store address of sprite specs
	ld   a, h                                                  ; $2a89
	ldh  [hSpriteSpecSrcAddr], a                               ; $2a8a
	ld   a, l                                                  ; $2a8c
	ldh  [hSpriteSpecSrcAddr+1], a                             ; $2a8d

; only starting byte of $00 or $80 allowed
	ld   a, [hl]                                               ; $2a8f
	and  a                                                     ; $2a90
	jr   z, .dontHideNextSpritesBeingProcessed                 ; $2a91

	cp   $80                                                   ; $2a93
	jr   z, .hideNextSpritesBeingProcessed                     ; $2a95

.checkIfMoreSpriteSpecs:
; to next struct by adding $10
	ldh  a, [hSpriteSpecSrcAddr]                               ; $2a97
	ld   h, a                                                  ; $2a99
	ldh  a, [hSpriteSpecSrcAddr+1]                             ; $2a9a
	ld   l, a                                                  ; $2a9c
	ld   de, SPR_SPEC_SIZEOF                                   ; $2a9d
	add  hl, de                                                ; $2aa0
	
; check if more sprite specs to process
	ldh  a, [hNumSpriteSpecs]                                  ; $2aa1
	dec  a                                                     ; $2aa3
	ldh  [hNumSpriteSpecs], a                                  ; $2aa4
	ret  z                                                     ; $2aa6

	jr   .nextStructInSpriteSpec                               ; $2aa7

.showNextSpritesCheckIfMoreSpriteSpecs:
; no longer hide sprites, and look to next sprite spec
	xor  a                                                     ; $2aa9
	ldh  [hShouldHideCurrSprite], a                            ; $2aaa
	jr   .checkIfMoreSpriteSpecs                               ; $2aac

.hideNextSpritesBeingProcessed:
	ldh  [hShouldHideCurrSprite], a                            ; $2aae

.dontHideNextSpritesBeingProcessed:
; copy from hl to ff86-ff8c
	ld   b, SPR_SPEC_DISPLAY_ENDOF                             ; $2ab0
	ld   de, hCurrSpriteSpecStruct                             ; $2ab2

.copyLoop1:
	ld   a, [hl+]                                              ; $2ab5
	ld   [de], a                                               ; $2ab6
	inc  de                                                    ; $2ab7
	dec  b                                                     ; $2ab8
	jr   nz, .copyLoop1                                        ; $2ab9

; initial double index into SpriteData
	ldh  a, [hCurrSpriteSpecIdx]                               ; $2abb

; get double index into sprite data table
	ld   hl, SpriteData                                        ; $2abd
	rlca                                                       ; $2ac0
	ld   e, a                                                  ; $2ac1
	ld   d, $00                                                ; $2ac2
	add  hl, de                                                ; $2ac4

; get word into de (pointer to a word and y/x base offset)
	ld   e, [hl]                                               ; $2ac5
	inc  hl                                                    ; $2ac6
	ld   d, [hl]                                               ; $2ac7

; get word into hl (address of tile indexes and y/x offsets per tile)
	ld   a, [de]                                               ; $2ac8
	ld   l, a                                                  ; $2ac9
	inc  de                                                    ; $2aca
	ld   a, [de]                                               ; $2acb
	ld   h, a                                                  ; $2acc
	inc  de                                                    ; $2acd

; store next word (base y/x offsets for sprite spec)
	ld   a, [de]                                               ; $2ace
	ldh  [hCurrSpriteSpecBaseYOffset], a                       ; $2acf
	inc  de                                                    ; $2ad1
	ld   a, [de]                                               ; $2ad2
	ldh  [hCurrSpriteSpecBaseXOffset], a                       ; $2ad3

; get the word from hl into de (adress of y/x offsets per tile)
; tile indexes come after
	ld   e, [hl]                                               ; $2ad5
	inc  hl                                                    ; $2ad6
	ld   d, [hl]                                               ; $2ad7

.bigLoop:
; init vars - just the base x flip for current sprite
	inc  hl                                                    ; $2ad8
	ldh  a, [hCurrSpecBaseXFlip]                               ; $2ad9
	ldh  [hCurrSpriteXFlipWithinCurrSpec], a                   ; $2adb

; get byte from last table
; exit big loop if ff
	ld   a, [hl]                                               ; $2add
	cp   $ff                                                   ; $2ade
	jr   z, .showNextSpritesCheckIfMoreSpriteSpecs             ; $2ae0

	cp   $fd                                                   ; $2ae2
	jr   nz, .dataByteNotFFhOrFDh                              ; $2ae4

; if fd, x flip the current sprite
	ldh  a, [hCurrSpecBaseXFlip]                               ; $2ae6
	xor  $20                                                   ; $2ae8
	ldh  [hCurrSpriteXFlipWithinCurrSpec], a                   ; $2aea
	inc  hl                                                    ; $2aec
	ld   a, [hl]                                               ; $2aed
	jr   .setTileIndex                                         ; $2aee

.dataByteEquFEh:
; get new y/x offset
	inc  de                                                    ; $2af0
	inc  de                                                    ; $2af1
	jr   .bigLoop                                              ; $2af2

.dataByteNotFFhOrFDh:
	cp   $fe                                                   ; $2af4
	jr   z, .dataByteEquFEh                                    ; $2af6

.setTileIndex:
	ldh  [hCurrSpriteTileIndex], a                             ; $2af8

; spec base y in B, y offset for tile in C
	ldh  a, [hCurrSpriteSpecBaseY]                             ; $2afa
	ld   b, a                                                  ; $2afc
	ld   a, [de]                                               ; $2afd
	ld   c, a                                                  ; $2afe

; calculate final y from if entire thing flipped around center
	ldh  a, [hCurrSpecEntireSpecYXFlipped]                     ; $2aff
	bit  6, a                                                  ; $2b01
	jr   nz, .spriteSpecYFlipped                               ; $2b03

; sprite spec base y + sprite spec base y offset + y offset for tile = tile Y
	ldh  a, [hCurrSpriteSpecBaseYOffset]                       ; $2b05
	add  b                                                     ; $2b07
	adc  c                                                     ; $2b08
	jr   .setSpriteY                                           ; $2b09

.spriteSpecYFlipped:
; sprite spec base Y - sprite spec base y offset - y offset for tile - 8 = tile Y
	ld   a, b                                                  ; $2b0b
	push af                                                    ; $2b0c
	ldh  a, [hCurrSpriteSpecBaseYOffset]                       ; $2b0d
	ld   b, a                                                  ; $2b0f
	pop  af                                                    ; $2b10
	sub  b                                                     ; $2b11
	sbc  c                                                     ; $2b12
	sbc  $08                                                   ; $2b13

.setSpriteY:
	ldh  [hCurrSpriteY], a                                     ; $2b15

; by default, skip to next y/x offsets, for next sprite
	ldh  a, [hCurrSpriteSpecBaseX]                             ; $2b17
	ld   b, a                                                  ; $2b19
	inc  de                                                    ; $2b1a
	ld   a, [de]                                               ; $2b1b
	inc  de                                                    ; $2b1c
	ld   c, a                                                  ; $2b1d

; calculate final x from if entire thing flipped around center
	ldh  a, [hCurrSpecEntireSpecYXFlipped]                     ; $2b1e
	bit  5, a                                                  ; $2b20
	jr   nz, .spriteSpecXFlipped                               ; $2b22

; sprite spec base x + sprite spec base x offset + x offset for tile = tile X
	ldh  a, [hCurrSpriteSpecBaseXOffset]                       ; $2b24
	add  b                                                     ; $2b26
	adc  c                                                     ; $2b27
	jr   .setSpriteX                                           ; $2b28

.spriteSpecXFlipped:
; sprite spec base X - sprite spec base x offset - x offset for tile - 8 = tile X
	ld   a, b                                                  ; $2b2a
	push af                                                    ; $2b2b
	ldh  a, [hCurrSpriteSpecBaseXOffset]                       ; $2b2c
	ld   b, a                                                  ; $2b2e
	pop  af                                                    ; $2b2f
	sub  b                                                     ; $2b30
	sbc  c                                                     ; $2b31
	sbc  $08                                                   ; $2b32

.setSpriteX:
	ldh  [hCurrSpriteX], a                                     ; $2b34

; get hl from curr wOam address for sprite
	push hl                                                    ; $2b36
	ldh  a, [hCurr_wOam_SpriteAddr]                            ; $2b37
	ld   h, a                                                  ; $2b39
	ldh  a, [hCurr_wOam_SpriteAddr+1]                          ; $2b3a
	ld   l, a                                                  ; $2b3c

; if this var set, hide sprite
	ldh  a, [hShouldHideCurrSprite]                            ; $2b3d
	and  a                                                     ; $2b3f
	jr   z, .dontHideSprite                                    ; $2b40

; store tile Y out of screen
	ld   a, $ff                                                ; $2b42
	jr   .setSpriteVars                                        ; $2b44

.dontHideSprite:
; store tile Y
	ldh  a, [hCurrSpriteY]                                     ; $2b46

.setSpriteVars:
	ld   [hl+], a                                              ; $2b48

; store tile X
	ldh  a, [hCurrSpriteX]                                     ; $2b49
	ld   [hl+], a                                              ; $2b4b

; store tile Index
	ldh  a, [hCurrSpriteTileIndex]                             ; $2b4c
	ld   [hl+], a                                              ; $2b4e

; todo: attr made from $94|$8b|$8a
	ldh  a, [hCurrSpriteXFlipWithinCurrSpec]                   ; $2b4f
	ld   b, a                                                  ; $2b51
	ldh  a, [hCurrSpecEntireSpecYXFlipped]                     ; $2b52
	or   b                                                     ; $2b54
	ld   b, a                                                  ; $2b55
	ldh  a, [$8a]                                              ; $2b56
	or   b                                                     ; $2b58
	ld   [hl+], a                                              ; $2b59

; set addr for next sprite
	ld   a, h                                                  ; $2b5a
	ldh  [hCurr_wOam_SpriteAddr], a                            ; $2b5b
	ld   a, l                                                  ; $2b5d
	ldh  [hCurr_wOam_SpriteAddr+1], a                          ; $2b5e

	pop  hl                                                    ; $2b60
	jp   .bigLoop                                              ; $2b61
	

INCLUDE "data/spriteData.s"
INCLUDE "data/gfxAndLayouts.s"
INCLUDE "data/demoPieces.s"
