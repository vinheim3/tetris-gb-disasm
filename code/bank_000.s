; Disassembly of "OR"
; This file was created with:
; mgbdis v1.4 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

INCLUDE "includes.s"

SECTION "ROM Bank $000", ROM0[$0]

RST_00::
	jp   Begin2                                                     ; $0000

ds $08-@, $00

RST_08::
	jp   Begin2                                                     ; $0008

ds $28-@, $ff

SECTION "RST $28", ROM0[$28]

JumpTable::
	add  a                                                          ; $0028
	pop  hl                                                         ; $0029
	ld   e, a                                                       ; $002a
	ld   d, $00                                                     ; $002b
	add  hl, de                                                     ; $002d
	ld   e, [hl]                                                    ; $002e
	inc  hl                                                         ; $002f
	ld   d, [hl]                                                    ; $0030
	push de                                                         ; $0031
	pop  hl                                                         ; $0032
	jp   hl                                                         ; $0033

ds $40-@, $ff

VBlankInterrupt::
	jp   VBlankInterruptHandler                                     ; $0040

ds $48-@, $ff

LCDCInterrupt::
	jp   StubInterruptHandler                                       ; $0048

ds $50-@, $ff

TimerOverflowInterrupt::
	jp   StubInterruptHandler                                       ; $0050

ds $58-@, $ff

SerialTransferCompleteInterrupt::
	jp   SerialInterruptHandler                                     ; $0058


SerialInterruptHandler:
; preserve regs, call relevant serial func, flag that interrupt is done, then restore regs
	push af                                                         ; $005b
	push hl                                                         ; $005c
	push de                                                         ; $005d
	push bc                                                         ; $005e
	call SerialInterruptInner                                       ; $005f
	ld   a, $01                                                     ; $0062
	ldh  [hSerialInterruptHandled], a                               ; $0064
	pop  bc                                                         ; $0066
	pop  de                                                         ; $0067
	pop  hl                                                         ; $0068
	pop  af                                                         ; $0069
	reti                                                            ; $006a


SerialInterruptInner:
	ldh  a, [hSerialInterruptFunc]                                  ; $006b
	RST_JumpTable                                                   ; $006d
	dw SerialFunc0_titleScreen
	dw SerialFunc1_InGame
	dw SerialFunc2_2PlayerInGame
	dw SerialFunc3_PassiveStreamingBytes
	dw Stub_27ea

; Setting up 2 player
SerialFunc0_titleScreen:
	ldh  a, [hGameState]                                            ; $0078
	cp   GS_TITLE_SCREEN_MAIN                                       ; $007a
	jr   z, .titleScreenMain                                        ; $007c

	cp   GS_TITLE_SCREEN_INIT                                       ; $007e
	ret  z                                                          ; $0080

	ld   a, GS_TITLE_SCREEN_INIT                                    ; $0081
	ldh  [hGameState], a                                            ; $0083
	ret                                                             ; $0085

.titleScreenMain:
; in title screen, passive gameboy pings this SB to let a master gb know
	ldh  a, [rSB]                                                   ; $0086
	cp   SB_PASSIVES_PING_IN_TITLE_SCREEN                           ; $0088
	jr   nz, .checkIfPassive                                        ; $008a

	ld   a, MP_ROLE_MASTER                                          ; $008c
	ldh  [hMultiplayerPlayerRole], a                                ; $008e
	ld   a, SC_MASTER                                               ; $0090
	jr   .setSC                                                     ; $0092

.checkIfPassive:
; this SB is sent by the master gb when pressing Start on 2 player option
; receiving GB is assigned the passive role
	cp   SB_MASTER_PRESSING_START                                   ; $0094
	ret  nz                                                         ; $0096

	ld   a, MP_ROLE_PASSIVE                                         ; $0097
	ldh  [hMultiplayerPlayerRole], a                                ; $0099
	lda SC_PASSIVE                                                  ; $009b

.setSC:
	ldh  [rSC], a                                                   ; $009c
	ret                                                             ; $009e


SerialFunc1_InGame:
; simply get the byte the other player sent
	ldh  a, [rSB]                                                   ; $009f
	ldh  [hSerialByteRead], a                                       ; $00a1
	ret                                                             ; $00a3


SerialFunc2_2PlayerInGame:
; load serial byte for respective player
	ldh  a, [rSB]                                                   ; $00a4
	ldh  [hSerialByteRead], a                                       ; $00a6
	ldh  a, [hMultiplayerPlayerRole]                                ; $00a8
	cp   MP_ROLE_MASTER                                             ; $00aa
	ret  z                                                          ; $00ac

; if passive, auto-load next byte, and default the one after to $ff
	ldh  a, [hNextSerialByteToLoad]                                 ; $00ad
	ldh  [rSB], a                                                   ; $00af
	ld   a, $ff                                                     ; $00b1
	ldh  [hNextSerialByteToLoad], a                                 ; $00b3
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                          ; $00b5
	ldh  [rSC], a                                                   ; $00b7
	ret                                                             ; $00b9


SerialFunc3_PassiveStreamingBytes:
; load serial byte for respective player
	ldh  a, [rSB]                                                   ; $00ba
	ldh  [hSerialByteRead], a                                       ; $00bc
	ldh  a, [hMultiplayerPlayerRole]                                ; $00be
	cp   MP_ROLE_MASTER                                             ; $00c0
	ret  z                                                          ; $00c2

; if passive, load a new byte in, wait??, then set SC bit 7
	ldh  a, [hNextSerialByteToLoad]                                 ; $00c3
	ldh  [rSB], a                                                   ; $00c5
	ei                                                              ; $00c7
	call SerialTransferWaitFunc                                     ; $00c8
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                          ; $00cb
	ldh  [rSC], a                                                   ; $00cd
	ret                                                             ; $00cf


UnusedSerialFunc_clearIntFlagsIfSerialFunc2_2PlayerInGame:
	ldh  a, [hSerialInterruptFunc]                                  ; $00d0
	cp   SF_2_PLAYER_IN_GAME                                        ; $00d2
	ret  nz                                                         ; $00d4

	xor  a                                                          ; $00d5
	ldh  [rIF], a                                                   ; $00d6
	ei                                                              ; $00d8
	ret                                                             ; $00d9

ds $100-@, $ff

Boot::
	nop                                                             ; $0100
	jp   Begin                                                      ; $0101

	
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
	jp   Begin2                                                     ; $0150


UnusedGetScreenTileInHLWhileOamFree:
	call GetScreen0AddressOfPieceSquare                             ; $0153

.waitUntilVramAndOamFree:
	ldh  a, [rSTAT]                                                 ; $0156
	and  STATF_LCD                                                  ; $0158
	jr   nz, .waitUntilVramAndOamFree                               ; $015a

; get screen 0 tile in B
	ld   b, [hl]                                                    ; $015c

.waitUntilVramAndOamFree2:
	ldh  a, [rSTAT]                                                 ; $015d
	and  STATF_LCD                                                  ; $015f
	jr   nz, .waitUntilVramAndOamFree2                              ; $0161

; get the same tile in A, and check if still same as B
	ld   a, [hl]                                                    ; $0163
	and  b                                                          ; $0164
	ret                                                             ; $0165


; in: DE - a score value (category * count)
; in: HL - 3 score bytes
AddScoreValueDEontoBaseScoreHL:
; add base score with additional score
	ld   a, e                                                       ; $0166
	add  [hl]                                                       ; $0167
	daa                                                             ; $0168
	ld   [hl+], a                                                   ; $0169

	ld   a, d                                                       ; $016a
	adc  [hl]                                                       ; $016b
	daa                                                             ; $016c
	ld   [hl+], a                                                   ; $016d

	ld   a, $00                                                     ; $016e
	adc  [hl]                                                       ; $0170
	daa                                                             ; $0171
	ld   [hl], a                                                    ; $0172

; always set, so we display a score
	ld   a, $01                                                     ; $0173
	ldh  [hFoundDisplayableScoreDigit], a                           ; $0175
	ret  nc                                                         ; $0177

; if carry found in last byte, max score is 999,999
	ld   a, $99                                                     ; $0178
	ld   [hl-], a                                                   ; $017a
	ld   [hl-], a                                                   ; $017b
	ld   [hl], a                                                    ; $017c
	ret                                                             ; $017d


VBlankInterruptHandler:
; preserve regs
	push af                                                         ; $017e
	push bc                                                         ; $017f
	push de                                                         ; $0180
	push hl                                                         ; $0181

; if master should transfer
	ldh  a, [hMasterShouldSerialTransferInVBlank]                   ; $0182
	and  a                                                          ; $0184
	jr   z, .afterMasterTransfer                                    ; $0185

	ldh  a, [hMultiplayerPlayerRole]                                ; $0187
	cp   MP_ROLE_MASTER                                             ; $0189
	jr   nz, .afterMasterTransfer                                   ; $018b

; load the pending byte and initiate transfer
	xor  a                                                          ; $018d
	ldh  [hMasterShouldSerialTransferInVBlank], a                   ; $018e
	ldh  a, [hNextSerialByteToLoad]                                 ; $0190
	ldh  [rSB], a                                                   ; $0192
	ld   hl, rSC                                                    ; $0194
	ld   [hl], SC_REQUEST_TRANSFER|SC_MASTER                        ; $0197

.afterMasterTransfer:
	call FlashCompletedTetrisRows                                   ; $0199
	call CopyRamBufferRow0ToVram                                    ; $019c
	call CopyRamBufferRow1ToVram                                    ; $019f
	call CopyRamBufferRow2ToVram                                    ; $01a2
	call CopyRamBufferRow3ToVram                                    ; $01a5
	call CopyRamBufferRow4ToVram                                    ; $01a8
	call CopyRamBufferRow5ToVram                                    ; $01ab
	call CopyRamBufferRow6ToVram                                    ; $01ae
	call CopyRamBufferRow7ToVram                                    ; $01b1
	call CopyRamBufferRow8ToVram                                    ; $01b4
	call CopyRamBufferRow9ToVram                                    ; $01b7
	call CopyRamBufferRow10ToVram                                   ; $01ba
	call CopyRamBufferRow11ToVram                                   ; $01bd
	call CopyRamBufferRow12ToVram                                   ; $01c0
	call CopyRamBufferRow13ToVram                                   ; $01c3
	call CopyRamBufferRow14ToVram                                   ; $01c6
	call CopyRamBufferRow15ToVram                                   ; $01c9
	call CopyRamBufferRow16ToVram                                   ; $01cc
	call CopyRamBufferRow17ToVram                                   ; $01cf
	call ProcessScoreUpdatesAfterBTypeLevelDone                     ; $01d2
	call hOamDmaFunction                                            ; $01d5
	call DisplayHighScoresAndNamesForLevel                          ; $01d8

; if just added drops to score..
	ld   a, [wATypeJustAddedDropsToScore]                           ; $01db
	and  a                                                          ; $01de
	jr   z, .end                                                    ; $01df

; and all rows are processed
	ldh  a, [hPieceFallingState]                                    ; $01e1
	cp   FALLING_PIECE_ALL_ROWS_PROCESSED_AFTER_DROP                ; $01e3
	jr   nz, .end                                                   ; $01e5

; show score on screen 0 (if somehow forced), and screen 1
	ld   hl, _SCRN0+$6d                                             ; $01e7
	call DisplayGameATypeScoreIfInGameAndForced                     ; $01ea

	ld   a, $01                                                     ; $01ed
	ldh  [hFoundDisplayableScoreDigit], a                           ; $01ef
	ld   hl, _SCRN1+$6d                                             ; $01f1
	call DisplayGameATypeScoreIfInGameAndForced                     ; $01f4

; clear that we've just added drops to score
	xor  a                                                          ; $01f7
	ld   [wATypeJustAddedDropsToScore], a                           ; $01f8

.end:
; inc an unused counter
	ld   hl, hVBlankInterruptCounter                                ; $01fb
	inc  [hl]                                                       ; $01fe

; clear scroll regs, and set interrupt as handled
	xor  a                                                          ; $01ff
	ldh  [rSCX], a                                                  ; $0200
	ldh  [rSCY], a                                                  ; $0202

	inc  a                                                          ; $0204
	ldh  [hVBlankInterruptFinished], a                              ; $0205

; restore regs
	pop  hl                                                         ; $0207
	pop  de                                                         ; $0208
	pop  bc                                                         ; $0209
	pop  af                                                         ; $020a
	reti                                                            ; $020b


Begin2:
	xor  a                                                          ; $020c
	ld   hl, $dfff                                                  ; $020d

; clear $d000-$dfff
	ld   c, $10                                                     ; $0210
	ld   b, $00                                                     ; $0212

.clear2ndWram:
	ld   [hl-], a                                                   ; $0214
	dec  b                                                          ; $0215
	jr   nz, .clear2ndWram                                          ; $0216

	dec  c                                                          ; $0218
	jr   nz, .clear2ndWram                                          ; $0219

Reset:
; allow vblank and not serial
	ld   a, IEF_VBLANK                                              ; $021b
	di                                                              ; $021d
	ldh  [rIF], a                                                   ; $021e
	ldh  [rIE], a                                                   ; $0220

; clear hw regs
	xor  a                                                          ; $0222
	ldh  [rSCY], a                                                  ; $0223
	ldh  [rSCX], a                                                  ; $0225
	ldh  [hUnusedFFA4], a                                           ; $0227
	ldh  [rSTAT], a                                                 ; $0229
	ldh  [rSB], a                                                   ; $022b
	ldh  [rSC], a                                                   ; $022d

; turn on LCD, and wait until in vblank area (specifically line $94)
	ld   a, LCDCF_ON                                                ; $022f
	ldh  [rLCDC], a                                                 ; $0231

.waitUntilVBlank:
	ldh  a, [rLY]                                                   ; $0233
	cp   $94                                                        ; $0235
	jr   nz, .waitUntilVBlank                                       ; $0237

; turn off lcd again
	ld   a, LCDCF_OFF|LCDCF_OBJON|LCDCF_BGON                        ; $0239
	ldh  [rLCDC], a                                                 ; $023b

; standard palettes
	ld   a, %11100100                                               ; $023d
	ldh  [rBGP], a                                                  ; $023f
	ldh  [rOBP0], a                                                 ; $0241

; palette with white as non-transparent, eg for jumping dancers
	ld   a, %11000100                                               ; $0243
	ldh  [rOBP1], a                                                 ; $0245

; all sound on
	ld   hl, rAUDENA                                                ; $0247
	ld   a, $80                                                     ; $024a
	ld   [hl-], a                                                   ; $024c

; channels outputted to all sound S01 and S02
	ld   a, $ff                                                     ; $024d
	ld   [hl-], a                                                   ; $024f

; vol max without setting vin
	ld   [hl], $77                                                  ; $0250

; set rom bank for some reason, and set SP
	ld   a, $01                                                     ; $0252
	ld   [rROMB0], a                                                ; $0254
	ld   sp, wStackTop                                              ; $0257

; clear last page of wram
	xor  a                                                          ; $025a
	ld   hl, $dfff                                                  ; $025b
	ld   b, $00                                                     ; $025e

.clearLastPage:
	ld   [hl-], a                                                   ; $0260
	dec  b                                                          ; $0261
	jr   nz, .clearLastPage                                         ; $0262

; clear 1st bank of wram
	ld   hl, $cfff                                                  ; $0264
	ld   c, $10                                                     ; $0267
	ld   b, $00                                                     ; $0269

.clear1stWram:
	ld   [hl-], a                                                   ; $026b
	dec  b                                                          ; $026c
	jr   nz, .clear1stWram                                          ; $026d

	dec  c                                                          ; $026f
	jr   nz, .clear1stWram                                          ; $0270

; clear all vram
	ld   hl, $9fff                                                  ; $0272
	ld   c, $20                                                     ; $0275
	xor  a                                                          ; $0277
	ld   b, $00                                                     ; $0278

.clearVram:
	ld   [hl-], a                                                   ; $027a
	dec  b                                                          ; $027b
	jr   nz, .clearVram                                             ; $027c

	dec  c                                                          ; $027e
	jr   nz, .clearVram                                             ; $027f

; clear oam, and some unusable space
	ld   hl, $feff                                                  ; $0281
	ld   b, $00                                                     ; $0284

.clearOam:
	ld   [hl-], a                                                   ; $0286
	dec  b                                                          ; $0287
	jr   nz, .clearOam                                              ; $0288

; clear all hram, but also $ff7f
	ld   hl, $fffe                                                  ; $028a
	ld   b, $80                                                     ; $028d

.clearHram:
	ld   [hl-], a                                                   ; $028f
	dec  b                                                          ; $0290
	jr   nz, .clearHram                                             ; $0291

; copy OAM DMA function, plus 2 extra bytes
	ld   c, LOW(hOamDmaFunction)                                    ; $0293
	ld   b, hOamDmaFunction.end-hOamDmaFunction+2                   ; $0295
	ld   hl, OamDmaFunction                                         ; $0297

.copyOamDmaFunc:
	ld   a, [hl+]                                                   ; $029a
	ldh  [c], a                                                     ; $029b
	inc  c                                                          ; $029c
	dec  b                                                          ; $029d
	jr   nz, .copyOamDmaFunc                                        ; $029e

; clear tilemap and sound
	call FillScreen0FromHLdownWithEmptyTile                         ; $02a0
	call ThunkInitSound                                             ; $02a3

; enable both interrupts now
	ld   a, IEF_SERIAL|IEF_VBLANK                                   ; $02a6
	ldh  [rIE], a                                                   ; $02a8

; set defaults for game and music type
	ld   a, GAME_TYPE_A_TYPE                                        ; $02aa
	ldh  [hGameType], a                                             ; $02ac
	ld   a, MUSIC_TYPE_A_TYPE                                       ; $02ae
	ldh  [hMusicType], a                                            ; $02b0

; set starting game state
	ld   a, GS_COPYRIGHT_DISPLAY                                    ; $02b2
	ldh  [hGameState], a                                            ; $02b4

; turn on LCD
	ld   a, LCDCF_ON                                                ; $02b6
	ldh  [rLCDC], a                                                 ; $02b8

; clear some hw regs
	ei                                                              ; $02ba
	xor  a                                                          ; $02bb
	ldh  [rIF], a                                                   ; $02bc
	ldh  [rWY], a                                                   ; $02be
	ldh  [rWX], a                                                   ; $02c0
	ldh  [rTMA], a                                                  ; $02c2

MainLoop:
; main game loop updates
	call PollInput                                                  ; $02c4
	call ProcessGameState                                           ; $02c7
	call ThunkUpdateSound                                           ; $02ca

; standard soft reset
	ldh  a, [hButtonsHeld]                                          ; $02cd
	and  PADF_START|PADF_SELECT|PADF_B|PADF_A                       ; $02cf
	cp   PADF_START|PADF_SELECT|PADF_B|PADF_A                       ; $02d1
	jp   z, Reset                                                   ; $02d3

; decrease 2 timers
	ld   hl, hTimers                                                ; $02d6
	ld   b, hTimerEnd-hTimers                                       ; $02d9

.nextTimer:
	ld   a, [hl]                                                    ; $02db
	and  a                                                          ; $02dc
	jr   z, .toNextTimer                                            ; $02dd

	dec  [hl]                                                       ; $02df

.toNextTimer:
	inc  l                                                          ; $02e0
	dec  b                                                          ; $02e1
	jr   nz, .nextTimer                                             ; $02e2

; always make sure serial interrupt is enabled when 2 players set
	ldh  a, [hIs2Player]                                            ; $02e4
	and  a                                                          ; $02e6
	jr   z, .waitUntilVBlankIntDone                                 ; $02e7

; enable standard interrupts
	ld   a, IEF_SERIAL|IEF_VBLANK                                   ; $02e9
	ldh  [rIE], a                                                   ; $02eb

.waitUntilVBlankIntDone:
	ldh  a, [hVBlankInterruptFinished]                              ; $02ed
	and  a                                                          ; $02ef
	jr   z, .waitUntilVBlankIntDone                                 ; $02f0

; do main loop, then wait for vblank int done, before looping again
	xor  a                                                          ; $02f2
	ldh  [hVBlankInterruptFinished], a                              ; $02f3
	jp   MainLoop                                                   ; $02f5


ProcessGameState:
	ldh  a, [hGameState]                                            ; $02f8
	RST_JumpTable                                                   ; $02fa
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
	dw GameState19_2PlayerSyncHighBlocksAndPieces
	dw GameState1a_2PlayerInGameMain
	dw GameState1b_2PlayerGameEnd
	dw GameState1c_2PlayerSyncAtInGameInitEnd
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
	

INCLUDE "code/introScreens.s"


DemoSendPingsAndEndAfterAllStepsDone:
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $050c
	and  a                                                          ; $050e
	ret  z                                                          ; $050f

; demo is being played, passively ping 0s (master on title screen isn't assigned master)
	call SerialTransferWaitFunc                                     ; $0510
	lda SB_PASSIVE_PING_IN_DEMO                                     ; $0513
	ldh  [rSB], a                                                   ; $0514
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                          ; $0516
	ldh  [rSC], a                                                   ; $0518

; if start pressed..
	ldh  a, [hButtonsPressed]                                       ; $051a
	bit  PADB_START, a                                              ; $051c
	jr   z, .startNotPressed                                        ; $051e

; send that we've ended demo
	ld   a, SB_ENDED_GAME_DEMO                                      ; $0520
	ldh  [rSB], a                                                   ; $0522
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                           ; $0524
	ldh  [rSC], a                                                   ; $0526
	ld   a, GS_TITLE_SCREEN_INIT                                    ; $0528
	ldh  [hGameState], a                                            ; $052a
	ret                                                             ; $052c

.startNotPressed:
; based on demo, ret if demo step is not past $10/$1d
	ld   hl, hLowByteOfCurrDemoStepAddress                          ; $052d
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $0530
	cp   $02                                                        ; $0532
	ld   b, $10                                                     ; $0534
	jr   z, .endIfDoneBSteps                                        ; $0536

	ld   b, $1d                                                     ; $0538

.endIfDoneBSteps:
	ld   a, [hl]                                                    ; $053a
	cp   b                                                          ; $053b
	ret  nz                                                         ; $053c

; else go to title screen
	ld   a, GS_TITLE_SCREEN_INIT                                    ; $053d
	ldh  [hGameState], a                                            ; $053f
	ret                                                             ; $0541


DemoPollInput:
; proceed if demo played
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $0542
	and  a                                                          ; $0544
	ret  z                                                          ; $0545

; return if recording demo
	ldh  a, [hIsRecordingDemo]                                      ; $0546
	cp   $ff                                                        ; $0548
	ret  z                                                          ; $054a

; once timer is 0, do main bit
	ldh  a, [hFramesUntilNextDemoInput]                             ; $054b
	and  a                                                          ; $054d
	jr   z, .mainBit                                                ; $054e

; else dec timer
	dec  a                                                          ; $0550
	ldh  [hFramesUntilNextDemoInput], a                             ; $0551
	jr   .clearButtonsPressedSetButtonsHeld                         ; $0553

.mainBit:
; get next input address
	ldh  a, [hAddressOfDemoInput]                                   ; $0555
	ld   h, a                                                       ; $0557
	ldh  a, [hAddressOfDemoInput+1]                                 ; $0558
	ld   l, a                                                       ; $055a

; next input in B
	ld   a, [hl+]                                                   ; $055b
	ld   b, a                                                       ; $055c

; process buttons pressed as normal
	ldh  a, [hDemoButtonsHeld]                                      ; $055d
	xor  b                                                          ; $055f
	and  b                                                          ; $0560
	ldh  [hButtonsPressed], a                                       ; $0561

; store next input
	ld   a, b                                                       ; $0563
	ldh  [hDemoButtonsHeld], a                                      ; $0564

; next byte is frames until next input
	ld   a, [hl+]                                                   ; $0566
	ldh  [hFramesUntilNextDemoInput], a                             ; $0567

; store current address of next data
	ld   a, h                                                       ; $0569
	ldh  [hAddressOfDemoInput], a                                   ; $056a
	ld   a, l                                                       ; $056c
	ldh  [hAddressOfDemoInput+1], a                                 ; $056d
	jr   .end                                                       ; $056f

.clearButtonsPressedSetButtonsHeld:
	xor  a                                                          ; $0571
	ldh  [hButtonsPressed], a                                       ; $0572

.end:
; store buttons held, eg for pressing Start, and process as if demo buttons held
	ldh  a, [hButtonsHeld]                                          ; $0574
	ldh  [hActualUserButtonsHeldDuringDemo], a                      ; $0576
	ldh  a, [hDemoButtonsHeld]                                      ; $0578
	ldh  [hButtonsHeld], a                                          ; $057a
	ret                                                             ; $057c


UnusedClearDemoButtonsHeld:
	xor  a                                                          ; $057d
	ldh  [hDemoButtonsHeld], a                                      ; $057e
	jr   DemoPollInput.clearButtonsPressedSetButtonsHeld            ; $0580

	ret                                                             ; $0582


DemoRecordInput:
; proceed if demo played
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $0583
	and  a                                                          ; $0585
	ret  z                                                          ; $0586

; proceed if recording
	ldh  a, [hIsRecordingDemo]                                      ; $0587
	cp   $ff                                                        ; $0589
	ret  nz                                                         ; $058b

; if buttons held == current demo buttons held, inc timer
	ldh  a, [hButtonsHeld]                                          ; $058c
	ld   b, a                                                       ; $058e
	ldh  a, [hDemoButtonsHeld]                                      ; $058f
	cp   b                                                          ; $0591
	jr   z, .incFrames                                              ; $0592

; else get demo input address
	ldh  a, [hAddressOfDemoInput]                                   ; $0594
	ld   h, a                                                       ; $0596
	ldh  a, [hAddressOfDemoInput+1]                                 ; $0597
	ld   l, a                                                       ; $0599

; store buttons held and frames until next demo input in that address
	ldh  a, [hDemoButtonsHeld]                                      ; $059a
	ld   [hl+], a                                                   ; $059c
	ldh  a, [hFramesUntilNextDemoInput]                             ; $059d
	ld   [hl+], a                                                   ; $059f

; store demo input address
	ld   a, h                                                       ; $05a0
	ldh  [hAddressOfDemoInput], a                                   ; $05a1
	ld   a, l                                                       ; $05a3
	ldh  [hAddressOfDemoInput+1], a                                 ; $05a4

; store buttons held
	ld   a, b                                                       ; $05a6
	ldh  [hDemoButtonsHeld], a                                      ; $05a7

; clear frames until next
	xor  a                                                          ; $05a9
	ldh  [hFramesUntilNextDemoInput], a                             ; $05aa
	ret                                                             ; $05ac

.incFrames:
	ldh  a, [hFramesUntilNextDemoInput]                             ; $05ad
	inc  a                                                          ; $05af
	ldh  [hFramesUntilNextDemoInput], a                             ; $05b0
	ret                                                             ; $05b2


DemoRestorePlayerButtonsHeld:
; proceed if demo played
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $05b3
	and  a                                                          ; $05b5
	ret  z                                                          ; $05b6

; return if recording demo
	ldh  a, [hIsRecordingDemo]                                      ; $05b7
	and  a                                                          ; $05b9
	ret  nz                                                         ; $05ba

; store ee in buttons held
	ldh  a, [hActualUserButtonsHeldDuringDemo]                      ; $05bb
	ldh  [hButtonsHeld], a                                          ; $05bd
	ret                                                             ; $05bf



INCLUDE "code/multiplayer.s"
INCLUDE "code/shuttleRocket.s"
INCLUDE "code/menuScreens.s"

	
StoreAinHLwhenLCDFree:
	ld   b, a                                                       ; $19fe

StoreBinHLwhenLCDFree:
.waitUntilVramAndOamFree:
	ldh  a, [rSTAT]                                                 ; $19ff
	and  STATF_LCD                                                  ; $1a01
	jr   nz, .waitUntilVramAndOamFree                               ; $1a03

	ld   [hl], b                                                    ; $1a05
	ret                                                             ; $1a06


GameState0a_InGameInit:
; turn off lcd and clear some in-game vars
	call TurnOffLCD                                                 ; $1a07
	xor  a                                                          ; $1a0a
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                          ; $1a0b
	ldh  [hPieceFallingState], a                                    ; $1a0e
	ldh  [hTetrisFlashCount], a                                     ; $1a10
	ldh  [hPieceCollisionDetected], a                               ; $1a12
	ldh  [h1stHighScoreHighestByteForLevel], a                      ; $1a14
	ldh  [hNumLinesCompletedBCD+1], a                               ; $1a16

; clear ram buffer
	ld   a, TILE_EMPTY                                              ; $1a18
	call FillGameScreenBufferWithTileAandSetToVramTransfer          ; $1a1a
	call FillBottom2RowsOfTileMapWithEmptyTile                      ; $1a1d

; clear scores, row shifting var and oam
	call ClearScoreCategoryVarsAndTotalScore                        ; $1a20
	lda ROWS_SHIFTING_DOWN_NONE                                     ; $1a23
	ldh  [hRowsShiftingDownState], a                                ; $1a24
	call Clear_wOam                                                 ; $1a26

; based on game type, get layout address in DE, level to check in HL
; and vram dest low byte of level number in A
	ldh  a, [hGameType]                                             ; $1a29

	ld   de, Layout_BTypeInGame                                     ; $1a2b
	ld   hl, hBTypeLevel                                            ; $1a2e
	cp   GAME_TYPE_B_TYPE                                           ; $1a31
	ld   a, LOW($9850)                                              ; $1a33
	jr   z, .afterGameTypeCheck                                     ; $1a35

; is A-type
	ld   a, LOW($98f1)                                              ; $1a37
	ld   hl, hATypeLevel                                            ; $1a39
	ld   de, Layout_ATypeInGame                                     ; $1a3c

.afterGameTypeCheck:
; cache vram dest for level
	push de                                                         ; $1a3f
	ldh  [hLowByteOfVramDestForLevelNum], a                         ; $1a40

; level is also lines threshold to pass, eg for 0, pass 10, for 1, pass 20
	ld   a, [hl]                                                    ; $1a42
	ldh  [hATypeLinesThresholdToPassForNextLevel], a                ; $1a43

; copy layout, pop layout address and draw to screen 1 as well
	call CopyLayoutToScreen0                                        ; $1a45
	pop  de                                                         ; $1a48
	ld   hl, _SCRN1                                                 ; $1a49
	call CopyLayoutToHL                                             ; $1a4c

; screen 1 is for pause text
	ld   de, GameInnerScreenLayout_Pause                            ; $1a4f
	ld   hl, _SCRN1+$63                                             ; $1a52
	ld   c, $0a                                                     ; $1a55
	call CopyGameScreenInnerText                                    ; $1a57

; get vram dest address for level num
	ld   h, HIGH(_SCRN0)                                            ; $1a5a
	ldh  a, [hLowByteOfVramDestForLevelNum]                         ; $1a5c
	ld   l, a                                                       ; $1a5e

; store level in vram dest and screen 1
	ldh  a, [hATypeLinesThresholdToPassForNextLevel]                ; $1a5f
	ld   [hl], a                                                    ; $1a61
	ld   h, HIGH(_SCRN1)                                            ; $1a62
	ld   [hl], a                                                    ; $1a64

; if hard mode..
	ldh  a, [hIsHardMode]                                           ; $1a65
	and  a                                                          ; $1a67
	jr   z, .afterHardModeCheck                                     ; $1a68

; draw hearts as well
	inc  hl                                                         ; $1a6a
	ld   [hl], "<3"                                                 ; $1a6b
	ld   h, HIGH(_SCRN0)                                            ; $1a6d
	ld   [hl], "<3"                                                 ; $1a6f

.afterHardModeCheck:
; copy sprite specs over for active and next piece
	ld   hl, wSpriteSpecs                                           ; $1a71
	ld   de, SpriteSpecStruct_LPieceActive                          ; $1a74
	call CopyDEintoHLwhileFFhNotFound                               ; $1a77

	ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                           ; $1a7a
	ld   de, SpriteSpecStruct_LPieceNext                            ; $1a7d
	call CopyDEintoHLwhileFFhNotFound                               ; $1a80

; address of num lines
	ld   hl, _SCRN0+$151                                            ; $1a83

; num lines completed starts at 25 for B Type (counting down to 0)
	ldh  a, [hGameType]                                             ; $1a86
	cp   GAME_TYPE_B_TYPE                                           ; $1a88
	ld   a, $25                                                     ; $1a8a
	jr   z, .setNumLinesCompleted                                   ; $1a8c

	xor  a                                                          ; $1a8e

.setNumLinesCompleted:
	ldh  [hNumLinesCompletedBCD], a                                 ; $1a8f

; store low byte of num lines
	and  $0f                                                        ; $1a91
	ld   [hl-], a                                                   ; $1a93
	jr   z, .setFramesUntilPieceMovesDown                           ; $1a94

; for B Type, also store the 2 from 25
	ld   [hl], $02                                                  ; $1a96

.setFramesUntilPieceMovesDown:
	call SetNumFramesUntilPiecesMoveDown                            ; $1a98

; if next piece hidden var set, make sure its written to spec
	ld   a, [wNextPieceHidden]                                      ; $1a9b
	and  a                                                          ; $1a9e
	jr   z, .afterPieceHiddenCheck                                  ; $1a9f

	ld   a, SPRITE_SPEC_HIDDEN                                      ; $1aa1
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                          ; $1aa3

.afterPieceHiddenCheck:

; load hidden piece
	call PlayNextPieceLoadNextAndHiddenPiece                        ; $1aa6
; load next piece and hidden piece
	call PlayNextPieceLoadNextAndHiddenPiece                        ; $1aa9
; load played piece, next piece and hidden piece
	call PlayNextPieceLoadNextAndHiddenPiece                        ; $1aac

; copy active sprite over
	call Copy1stSpriteSpecToSprite4                                 ; $1aaf

; reset completed rows count
	xor  a                                                          ; $1ab2
	ldh  [hNumCompletedTetrisRows], a                               ; $1ab3

; end now if A Type
	ldh  a, [hGameType]                                             ; $1ab5
	cp   GAME_TYPE_B_TYPE                                           ; $1ab7
	jr   nz, .end                                                   ; $1ab9

; B type, speed is slowest
	ld   a, $34                                                     ; $1abb
	ldh  [hNumFramesUntilCurrPieceMovesDown], a                     ; $1abd

; display high number in both screens
	ldh  a, [hBTypeHigh]                                            ; $1abf
	ld   hl, _SCRN0+$b0                                             ; $1ac1
	ld   [hl], a                                                    ; $1ac4
	ld   h, HIGH(_SCRN1)                                            ; $1ac5
	ld   [hl], a                                                    ; $1ac7
	and  a                                                          ; $1ac8
	jr   z, .end                                                    ; $1ac9

; if high != 0, put in B
	ld   b, a                                                       ; $1acb

; set up game field for B type demo
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $1acc
	and  a                                                          ; $1ace
	jr   z, .notDemo                                                ; $1acf

	call PopulateDemoBTypeScreenWithBlocks                          ; $1ad1
	jr   .end                                                       ; $1ad4

.notDemo:
; B is non-0 high value, add a number of random blocks
	ld   a, b                                                       ; $1ad6
	ld   de, -$40                                                   ; $1ad7
	ld   hl, _SCRN0+$202                                            ; $1ada
	call PopulateGameScreenWithRandomBlocks                         ; $1add

.end:
; turn on LCD and go to in-game
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $1ae0
	ldh  [rLCDC], a                                                 ; $1ae2
	lda GS_IN_GAME_MAIN                                             ; $1ae4
	ldh  [hGameState], a                                            ; $1ae5
	ret                                                             ; $1ae7


SetNumFramesUntilPiecesMoveDown:
; speed is determined by num lines completed
	ldh  a, [hATypeLinesThresholdToPassForNextLevel]                ; $1ae8
	ld   e, a                                                       ; $1aea

; hard mode, +10
	ldh  a, [hIsHardMode]                                           ; $1aeb
	and  a                                                          ; $1aed
	jr   z, .setTopSpeedForPieces                                   ; $1aee

	ld   a, $0a                                                     ; $1af0
	add  e                                                          ; $1af2

; dont go higher than $14
	cp   $15                                                        ; $1af3
	jr   c, .getIndexInDE                                           ; $1af5

	ld   a, $14                                                     ; $1af7

.getIndexInDE:
	ld   e, a                                                       ; $1af9

.setTopSpeedForPieces:
; get num frames needed for a piece to move down from table idxed DE
	ld   hl, .framesData                                            ; $1afa
	ld   d, $00                                                     ; $1afd
	add  hl, de                                                     ; $1aff
	ld   a, [hl]                                                    ; $1b00
	ldh  [hNumFramesUntilCurrPieceMovesDown], a                     ; $1b01
	ldh  [hNumFramesUntilPiecesMoveDown], a                         ; $1b03
	ret                                                             ; $1b05

.framesData:
	db $34, $30, $2c, $28, $24, $20, $1b, $15
	db $10, $0a, $09, $08, $07, $06, $05, $05
	db $04, $04, $03, $03, $02


PopulateDemoBTypeScreenWithBlocks:
	ld   hl, _SCRN0+$1c2                                            ; $1b1b
	ld   de, .layout                                                ; $1b1e
	ld   c, $04                                                     ; $1b21

.nextRow:
	ld   b, GAME_SQUARE_WIDTH                                       ; $1b23
	push hl                                                         ; $1b25

.nextCol:
	ld   a, [de]                                                    ; $1b26
	ld   [hl], a                                                    ; $1b27
	push hl                                                         ; $1b28
	ld   a, h                                                       ; $1b29
	add  HIGH(wGameScreenBuffer-_SCRN0)                             ; $1b2a
	ld   h, a                                                       ; $1b2c
	ld   a, [de]                                                    ; $1b2d
	ld   [hl], a                                                    ; $1b2e
	pop  hl                                                         ; $1b2f
	inc  l                                                          ; $1b30
	inc  de                                                         ; $1b31
	dec  b                                                          ; $1b32
	jr   nz, .nextCol                                               ; $1b33

	pop  hl                                                         ; $1b35
	push de                                                         ; $1b36
	ld   de, GB_TILE_WIDTH                                          ; $1b37
	add  hl, de                                                     ; $1b3a
	pop  de                                                         ; $1b3b
	dec  c                                                          ; $1b3c
	jr   nz, .nextRow                                               ; $1b3d

	ret                                                             ; $1b3f

.layout:
	db $85, $2f, $82, $86, $83, $2f, $2f, $80, $82, $85
	db $2f, $82, $84, $82, $83, $2f, $83, $2f, $87, $2f
	db $2f, $85, $2f, $83, $2f, $86, $82, $80, $81, $2f
	db $83, $2f, $86, $83, $2f, $85, $2f, $85, $2f, $2f


; in: A - num to multiply to DE
; in: DE - num rows of random blocks * -GB_TILE_WIDTH
; in: HL - vram dest start
PopulateGameScreenWithRandomBlocks:
	ld   b, a                                                       ; $1b68

.decB:
	dec  b                                                          ; $1b69
	jr   z, .mainLoop                                               ; $1b6a

	add  hl, de                                                     ; $1b6c
	jr   .decB                                                      ; $1b6d

.mainLoop:
; random val in B
	ldh  a, [rDIV]                                                  ; $1b6f
	ld   b, a                                                       ; $1b71

.fromWasTileEmpty:
	ld   a, TILE_PIECE_SQUARES_START                                ; $1b72

.toDecRandom:
	dec  b                                                          ; $1b74
	jr   z, .afterChoosingEmptyOrPieceSquare                        ; $1b75

; random val not 0 yet, jump every other loop
	cp   TILE_PIECE_SQUARES_START                                   ; $1b77
	jr   nz, .fromWasTileEmpty                                      ; $1b79

; 1st, 3rd run etc - start with empty tile
	ld   a, TILE_EMPTY                                              ; $1b7b
	jr   .toDecRandom                                               ; $1b7d

.afterChoosingEmptyOrPieceSquare:
	cp   TILE_EMPTY                                                 ; $1b7f
	jr   z, .pickedEmpty                                            ; $1b81

; if not empty, actually choose one of the 8 tiles from it
	ldh  a, [rDIV]                                                  ; $1b83
	and  $07                                                        ; $1b85
	or   TILE_PIECE_SQUARES_START                                   ; $1b87
	jr   .emptyOrActualPieceSquareChosen                            ; $1b89

.pickedEmpty:
	ldh  [hRandomSquareObstacleTileChosen], a                       ; $1b8b

.emptyOrActualPieceSquareChosen:
; push square chosen
	push af                                                         ; $1b8d

; if column equals $0b..
	ld   a, l                                                       ; $1b8e
	and  $0f                                                        ; $1b8f
	cp   $0b                                                        ; $1b91
	jr   nz, .popAFstoreChosenSquare                                ; $1b93

; at column $0b, use chosen square if previous chosen was empty
	ldh  a, [hRandomSquareObstacleTileChosen]                       ; $1b95
	cp   TILE_EMPTY                                                 ; $1b97
	jr   z, .popAFstoreChosenSquare                                 ; $1b99

; override square chosen with empty otherwise, so there is 1+ empty tiles per row
	pop  af                                                         ; $1b9b
	ld   a, TILE_EMPTY                                              ; $1b9c
	jr   .storeChosenSquare                                         ; $1b9e

.popAFstoreChosenSquare:
	pop  af                                                         ; $1ba0

.storeChosenSquare:
	ld   [hl], a                                                    ; $1ba1

; push vram address of current square, and the chosen tile idx
	push hl                                                         ; $1ba2
	push af                                                         ; $1ba3

; skip storing in screen buffer if 2 player
	ldh  a, [hIs2Player]                                            ; $1ba4
	and  a                                                          ; $1ba6
	jr   nz, .from2player                                           ; $1ba7

; if single-player, store in screen buffer too
	ld   de, wGameScreenBuffer-_SCRN0                               ; $1ba9
	add  hl, de                                                     ; $1bac

.from2player:
	pop  af                                                         ; $1bad
	ld   [hl], a                                                    ; $1bae

; get vram dest of current tile, +1, and if it reaches the end (col $0c)...
; otherwise do next
	pop  hl                                                         ; $1baf
	inc  hl                                                         ; $1bb0
	ld   a, l                                                       ; $1bb1
	and  $0f                                                        ; $1bb2
	cp   $0c                                                        ; $1bb4
	jr   nz, .mainLoop                                              ; $1bb6

; allow non-empty tiles again
	xor  a                                                          ; $1bb8
	ldh  [hRandomSquareObstacleTileChosen], a                       ; $1bb9

; once we reach $9axx..
	ld   a, h                                                       ; $1bbb
	and  $0f                                                        ; $1bbc
	cp   $0a                                                        ; $1bbe
	jr   z, .vramDestHighEqu9ah                                     ; $1bc0

.toNextRow:
	ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                        ; $1bc2
	add  hl, de                                                     ; $1bc5
	jr   .mainLoop                                                  ; $1bc6

; stop at $9a2c
.vramDestHighEqu9ah:
	ld   a, l                                                       ; $1bc8
	cp   LOW($9a2c)                                                 ; $1bc9
	jr   nz, .toNextRow                                             ; $1bcb

	ret                                                             ; $1bcd


GameState00_InGameMain:
; ret if paused
	call InGameCheckResetAndPause.start                             ; $1bce
	ldh  a, [hGamePaused]                                           ; $1bd1
	and  a                                                          ; $1bd3
	ret  nz                                                         ; $1bd4

; run demo funcs to manip pieces
	call DemoSendPingsAndEndAfterAllStepsDone                       ; $1bd5
	call DemoPollInput                                              ; $1bd8
	call DemoRecordInput                                            ; $1bdb

; regular main loop
	call InGameCheckButtonsPressed                                  ; $1bde
	call InGameHandlePieceFalling.start                             ; $1be1
	call InGameCheckIfAnyTetrisRowsComplete                         ; $1be4
	call InGameAddPieceToVram                                       ; $1be7
	call ShiftEntireGameRamBufferDownARow                           ; $1bea
	call AddOnCompletedLinesScore                                   ; $1bed

; restore buttons held eg to exit
	call DemoRestorePlayerButtonsHeld                               ; $1bf0
	ret                                                             ; $1bf3


InGameCheckResetAndPause:
.startNotPressed:
	bit  PADB_SELECT, a                                             ; $1bf4
	ret  z                                                          ; $1bf6

; select pressed - hides next piece
	ld   a, [wNextPieceHidden]                                      ; $1bf7
	xor  $01                                                        ; $1bfa
	ld   [wNextPieceHidden], a                                      ; $1bfc

	jr   z, .pieceNotHidden                                         ; $1bff

	ld   a, SPRITE_SPEC_HIDDEN                                      ; $1c01

.setPieceVisibility:
; and send to oam
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                          ; $1c03
	call Copy2ndSpriteSpecToSprite8                                 ; $1c06
	ret                                                             ; $1c09

.pieceNotHidden:
	xor  a                                                          ; $1c0a
	jr   .setPieceVisibility                                        ; $1c0b

.start:
; check if soft-resetting
	ldh  a, [hButtonsHeld]                                          ; $1c0d
	and  PADF_START|PADF_SELECT|PADF_B|PADF_A                       ; $1c0f
	cp   PADF_START|PADF_SELECT|PADF_B|PADF_A                       ; $1c11
	jp   z, Reset                                                   ; $1c13

; return if demo
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $1c16
	and  a                                                          ; $1c18
	ret  nz                                                         ; $1c19

	ldh  a, [hButtonsPressed]                                       ; $1c1a
	bit  PADB_START, a                                              ; $1c1c
	jr   z, .startNotPressed                                        ; $1c1e

; pressed start
	ldh  a, [hIs2Player]                                            ; $1c20
	and  a                                                          ; $1c22
	jr   nz, .is2Player                                             ; $1c23

	ld   hl, rLCDC                                                  ; $1c25

; flip game paused
	ldh  a, [hGamePaused]                                           ; $1c28
	xor  $01                                                        ; $1c2a
	ldh  [hGamePaused], a                                           ; $1c2c

	jr   z, .gameUnPaused                                           ; $1c2e

; game paused, get bg from $9c00 (containing pause text)
	set  3, [hl]                                                    ; $1c30

; set activity, for playing relevant sound
	ld   a, $01                                                     ; $1c32
	ld   [wGamePausedActivity], a                                   ; $1c34

; copy num lines
	ld   hl, $994e                                                  ; $1c37
	ld   de, $9d4e                                                  ; $1c3a
	ld   b, $04                                                     ; $1c3d

.waitUntilVramAndOamFree:
	ldh  a, [rSTAT]                                                 ; $1c3f
	and  STATF_LCD                                                  ; $1c41
	jr   nz, .waitUntilVramAndOamFree                               ; $1c43

	ld   a, [hl+]                                                   ; $1c45
	ld   [de], a                                                    ; $1c46
	inc  de                                                         ; $1c47
	dec  b                                                          ; $1c48
	jr   nz, .waitUntilVramAndOamFree                               ; $1c49

; set pieces to invisible
	ld   a, SPRITE_SPEC_HIDDEN                                      ; $1c4b

.setNextPieceVisibility:
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                          ; $1c4d

.setCurrPieceVisibilityAndSend2PiecesToOam:
	ld   [wSpriteSpecs], a                                          ; $1c50
	call Copy1stSpriteSpecToSprite4                                 ; $1c53
	call Copy2ndSpriteSpecToSprite8                                 ; $1c56
	ret                                                             ; $1c59

.gameUnPaused:
; get old bg back
	res  3, [hl]                                                    ; $1c5a

; set activity, for playing relevant sound
	ld   a, $02                                                     ; $1c5c
	ld   [wGamePausedActivity], a                                   ; $1c5e

; if next piece visible, display both pieces
	ld   a, [wNextPieceHidden]                                      ; $1c61
	and  a                                                          ; $1c64
	jr   z, .setNextPieceVisibility                                 ; $1c65

	xor  a                                                          ; $1c67
	jr   .setCurrPieceVisibilityAndSend2PiecesToOam                 ; $1c68

.is2Player:
; if passive, can't pause game
	ldh  a, [hMultiplayerPlayerRole]                                ; $1c6a
	cp   MP_ROLE_MASTER                                             ; $1c6c
	ret  nz                                                         ; $1c6e

; otherwise flip game paused, jump if game unpaused
	ldh  a, [hGamePaused]                                           ; $1c6f
	xor  $01                                                        ; $1c71
	ldh  [hGamePaused], a                                           ; $1c73
	jr   z, InGame2PlayerCheckUnpaused.gameUnpaused                 ; $1c75

; game paused
	ld   a, $01                                                     ; $1c77
	ld   [wGamePausedActivity], a                                   ; $1c79

; preserve serial-related bytes, and display pause text
	ldh  a, [hSerialByteRead]                                       ; $1c7c
	ldh  [hPausedSerialByteRead], a                                 ; $1c7e
	ldh  a, [hNextSerialByteToLoad]                                 ; $1c80
	ldh  [hPausedNextSerialByteToLoad], a                           ; $1c82
	call Display2PlayerPauseText                                    ; $1c84
	ret                                                             ; $1c87


InGame2PlayerCheckUnpaused:
; return if unpaused
	ldh  a, [hGamePaused]                                           ; $1c88
	and  a                                                          ; $1c8a
	ret  z                                                          ; $1c8b

; if no serial interrupt, return from caller's context
	ldh  a, [hSerialInterruptHandled]                               ; $1c8c
	jr   z, .popHL                                                  ; $1c8e

; check player role
	xor  a                                                          ; $1c90
	ldh  [hSerialInterruptHandled], a                               ; $1c91
	ldh  a, [hMultiplayerPlayerRole]                                ; $1c93
	cp   MP_ROLE_MASTER                                             ; $1c95
	jr   nz, .isPassive                                             ; $1c97

; tell passive we just paused, return from caller's context
	ld   a, SB_MASTER_PAUSED                                        ; $1c99
	ldh  [hNextSerialByteToLoad], a                                 ; $1c9b
	ldh  [hMasterShouldSerialTransferInVBlank], a                   ; $1c9d
	pop  hl                                                         ; $1c9f
	ret                                                             ; $1ca0

.isPassive:
; return from caller's context if master did not pause
	xor  a                                                          ; $1ca1
	ldh  [hNextSerialByteToLoad], a                                 ; $1ca2
	ldh  a, [hSerialByteRead]                                       ; $1ca4
	cp   SB_MASTER_PAUSED                                           ; $1ca6
	jr   z, .popHL                                                  ; $1ca8

.gameUnpaused:
; get the serial-related bytes before pausing
	ldh  a, [hPausedSerialByteRead]                                 ; $1caa
	ldh  [hSerialByteRead], a                                       ; $1cac
	ldh  a, [hPausedNextSerialByteToLoad]                           ; $1cae
	ldh  [hNextSerialByteToLoad], a                                 ; $1cb0

; set game just unpaused
	ld   a, $02                                                     ; $1cb2
	ld   [wGamePausedActivity], a                                   ; $1cb4
	xor  a                                                          ; $1cb7
	ldh  [hGamePaused], a                                           ; $1cb8

; remove pause text
	ld   hl, _SCRN0+$ee                                             ; $1cba
	ld   b, TILE_BLACK                                              ; $1cbd
	ld   c, $05                                                     ; $1cbf

.loop:
	call StoreBinHLwhenLCDFree                                      ; $1cc1
	inc  l                                                          ; $1cc4
	dec  c                                                          ; $1cc5
	jr   nz, .loop                                                  ; $1cc6

	ret                                                             ; $1cc8

.popHL:
	pop  hl                                                         ; $1cc9
	ret                                                             ; $1cca


Display2PlayerPauseText:
	ld   hl, _SCRN0+$ee                                             ; $1ccb
	ld   c, $05                                                     ; $1cce
	ld   de, .text                                                  ; $1cd0

.loop:
	ld   a, [de]                                                    ; $1cd3
	call StoreAinHLwhenLCDFree                                      ; $1cd4
	inc  de                                                         ; $1cd7
	inc  l                                                          ; $1cd8
	dec  c                                                          ; $1cd9
	jr   nz, .loop                                                  ; $1cda

	ret                                                             ; $1cdc

.text:
	db "PAUSE"
	
	
GameState01_GameOverInit:
; hide played and next piece, and send to oam
	ld   a, SPRITE_SPEC_HIDDEN                                      ; $1ce2
	ld   [wSpriteSpecs], a                                          ; $1ce4
	ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                          ; $1ce7
	call Copy1stSpriteSpecToSprite4                                 ; $1cea
	call Copy2ndSpriteSpecToSprite8                                 ; $1ced

; clear fall vars
	xor  a                                                          ; $1cf0
	ldh  [hPieceFallingState], a                                    ; $1cf1
	ldh  [hTetrisFlashCount], a                                     ; $1cf3
	call ClearPointersToCompletedTetrisRows                         ; $1cf5

; start to clear screen with a solid block, set timer, then next state
	ld   a, TILE_SOLID_BLOCK                                        ; $1cf8
	call FillGameScreenBufferWithTileAandSetToVramTransfer          ; $1cfa

	ld   a, $46                                                     ; $1cfd
	ldh  [hTimer1], a                                               ; $1cff

	ld   a, GS_GAME_OVER_SCREEN_CLEARING                            ; $1d01
	ldh  [hGameState], a                                            ; $1d03
	ret                                                             ; $1d05


GameState04_LevelEndedMain:
	ldh  a, [hButtonsPressed]                                       ; $1d06
	bit  PADB_A, a                                                  ; $1d08
	jr   nz, .aOrStartPressed                                       ; $1d0a

	bit  PADB_START, a                                              ; $1d0c
	ret  z                                                          ; $1d0e

.aOrStartPressed:
	lda ROWS_SHIFTING_DOWN_NONE                                     ; $1d0f
	ldh  [hRowsShiftingDownState], a                                ; $1d10

; if 2 player, next game state is always mario v luigi
	ldh  a, [hIs2Player]                                            ; $1d12
	and  a                                                          ; $1d14
	ld   a, GS_MARIO_LUIGI_SCREEN_INIT                              ; $1d15
	jr   nz, .setGameState                                          ; $1d17

; set relevant state based on game type for 1 player
	ldh  a, [hGameType]                                             ; $1d19
	cp   GAME_TYPE_A_TYPE                                           ; $1d1b
	ld   a, GS_A_TYPE_SELECTION_INIT                                ; $1d1d
	jr   z, .setGameState                                           ; $1d1f

	ld   a, GS_B_TYPE_SELECTION_INIT                                ; $1d21

.setGameState:
	ldh  [hGameState], a                                            ; $1d23
	ret                                                             ; $1d25


INCLUDE "code/BType.s"


GameState0d_GameOverScreenClearing:
; proceeed when timer done
	ldh  a, [hTimer1]                                               ; $1f1f
	and  a                                                          ; $1f21
	ret  nz                                                         ; $1f22

; play music and check if 2 player
	ld   a, MUS_GAME_OVER                                           ; $1f23
	ld   [wSongToStart], a                                          ; $1f25

	ldh  a, [hIs2Player]                                            ; $1f28
	and  a                                                          ; $1f2a
	jr   z, .is1player                                              ; $1f2b

; 2 player, go to game end to do next round
	ld   a, $3f                                                     ; $1f2d
	ldh  [hTimer1], a                                               ; $1f2f

	ld   a, GS_2_PLAYER_GAME_END                                    ; $1f31
	ldh  [hSerialInterruptHandled], a                               ; $1f33
	jr   .setGameState                                              ; $1f35

.is1player:
	ld   a, TILE_EMPTY                                              ; $1f37
	call FillGameScreenBufferWithTileAandSetToVramTransfer          ; $1f39

; pipe box with game over text
	ld   hl, wGameScreenBuffer+$43                                  ; $1f3c
	ld   de, GameInnerScreenLayout_GameOver                         ; $1f3f
	ld   c, $07                                                     ; $1f42
	call CopyGameScreenInnerText                                    ; $1f44

; please try again text
	ld   hl, wGameScreenBuffer+$183                                 ; $1f47
	ld   de, GameInnerScreen_TryAgain                               ; $1f4a
	ld   c, $06                                                     ; $1f4d
	call CopyGameScreenInnerText                                    ; $1f4f

; jump immediately if B type
	ldh  a, [hGameType]                                             ; $1f52
	cp   GAME_TYPE_A_TYPE                                           ; $1f54
	jr   nz, .setGameStateGameOverScreen                            ; $1f56

; A type - if past a score threshold, go to rocket screens
	ld   hl, wScoreBCD+2                                            ; $1f58
	ld   a, [hl]                                                    ; $1f5b

; 200,000+
	ld   b, SPRITE_SPEC_BIG_ROCKET                                  ; $1f5c
	cp   $20                                                        ; $1f5e
	jr   nc, .setRocketSpecIdxThenNextState                         ; $1f60

; 150,000+ - SPRITE_SPEC_MEDIUM_ROCKET
	inc  b                                                          ; $1f62
	cp   $15                                                        ; $1f63
	jr   nc, .setRocketSpecIdxThenNextState                         ; $1f65

; 100,000+ - SPRITE_SPEC_SMALL_ROCKET
	inc  b                                                          ; $1f67
	cp   $10                                                        ; $1f68
	jr   nc, .setRocketSpecIdxThenNextState                         ; $1f6a

.setGameStateGameOverScreen:
	ld   a, GS_LEVEL_ENDED_MAIN                                     ; $1f6c

.setGameState:
	ldh  [hGameState], a                                            ; $1f6e
	ret                                                             ; $1f70

.setRocketSpecIdxThenNextState:
; also set timer
	ld   a, b                                                       ; $1f71
	ldh  [hATypeRocketSpecIdx], a                                   ; $1f72
	ld   a, $90                                                     ; $1f74
	ldh  [hTimer1], a                                               ; $1f76
	ld   a, GS_PRE_ROCKET_SCENE_WAIT                                ; $1f78
	ldh  [hGameState], a                                            ; $1f7a
	ret                                                             ; $1f7c


CopyGameScreenInnerText:
; 1 tile either side
.nextRow:
	ld   b, GAME_SQUARE_WIDTH-2                                     ; $1f7d
	push hl                                                         ; $1f7f

; copy to screen
.nextCol:
	ld   a, [de]                                                    ; $1f80
	ld   [hl+], a                                                   ; $1f81
	inc  de                                                         ; $1f82
	dec  b                                                          ; $1f83
	jr   nz, .nextCol                                               ; $1f84

; next row
	pop  hl                                                         ; $1f86
	push de                                                         ; $1f87
	ld   de, GB_TILE_WIDTH                                          ; $1f88
	add  hl, de                                                     ; $1f8b
	pop  de                                                         ; $1f8c
	dec  c                                                          ; $1f8d
	jr   nz, .nextRow                                               ; $1f8e

	ret                                                             ; $1f90


AddOnCompletedLinesScore:
; ret if not A Type
	ldh  a, [hGameType]                                             ; $1f91
	cp   GAME_TYPE_A_TYPE                                           ; $1f93
	ret  nz                                                         ; $1f95

; ret if not in-game
	ldh  a, [hGameState]                                            ; $1f96
	and  a                                                          ; $1f98
	ret  nz                                                         ; $1f99

; ret if not currently copying ram buffer row 14 to vram
	ldh  a, [hRowsShiftingDownState]                                ; $1f9a
	cp   $05                                                        ; $1f9c
	ret  nz                                                         ; $1f9e

; get lines cleared in A, until A is non-0
	ld   hl, wLinesClearedStructs+LINES_CLEARED_Num                 ; $1f9f
	ld   bc, LINES_CLEARED_SIZEOF                                   ; $1fa2
	ld   a, [hl]                                                    ; $1fa5
	ld   de, SCORE_1_LINE                                           ; $1fa6
	and  a                                                          ; $1fa9
	jr   nz, .afterChoosingScoreCateg                               ; $1faa

; to next score categ, etc
	add  hl, bc                                                     ; $1fac
	ld   a, [hl]                                                    ; $1fad
	ld   de, SCORE_2_LINES                                          ; $1fae
	and  a                                                          ; $1fb1
	jr   nz, .afterChoosingScoreCateg                               ; $1fb2

	add  hl, bc                                                     ; $1fb4
	ld   a, [hl]                                                    ; $1fb5
	ld   de, SCORE_3_LINES                                          ; $1fb6
	and  a                                                          ; $1fb9
	jr   nz, .afterChoosingScoreCateg                               ; $1fba

; ret if still 0 at last categ
	add  hl, bc                                                     ; $1fbc
	ld   de, SCORE_4_LINES                                          ; $1fbd
	ld   a, [hl]                                                    ; $1fc0
	and  a                                                          ; $1fc1
	ret  z                                                          ; $1fc2

.afterChoosingScoreCateg:
; clear num lines
	ld   [hl], $00                                                  ; $1fc3

; eg B = 1 for level 0
	ldh  a, [hATypeLinesThresholdToPassForNextLevel]                ; $1fc5
	ld   b, a                                                       ; $1fc7
	inc  b                                                          ; $1fc8

.loop:
; add categ score repeatedly based on level
	push bc                                                         ; $1fc9
	push de                                                         ; $1fca
	ld   hl, wScoreBCD                                              ; $1fcb
	call AddScoreValueDEontoBaseScoreHL                             ; $1fce
	pop  de                                                         ; $1fd1
	pop  bc                                                         ; $1fd2
	dec  b                                                          ; $1fd3
	jr   nz, .loop                                                  ; $1fd4

	ret                                                             ; $1fd6


FillGameScreenBufferWithTileAandSetToVramTransfer:
; start to fill rows going down with tile A
	push af                                                         ; $1fd7
	ld   a, ROWS_SHIFTING_DOWN_ROW_START                            ; $1fd8
	ldh  [hRowsShiftingDownState], a                                ; $1fda
	pop  af                                                         ; $1fdc

FillGameScreenBufferWithTileA:
	ld   hl, wGameScreenBuffer+2                                    ; $1fdd
	ld   c, GAME_SCREEN_ROWS                                        ; $1fe0
	ld   de, GB_TILE_WIDTH                                          ; $1fe2

.nextRow:
	push hl                                                         ; $1fe5
	ld   b, GAME_SQUARE_WIDTH                                       ; $1fe6

.nextCol:
	ld   [hl+], a                                                   ; $1fe8
	dec  b                                                          ; $1fe9
	jr   nz, .nextCol                                               ; $1fea

	pop  hl                                                         ; $1fec
	add  hl, de                                                     ; $1fed
	dec  c                                                          ; $1fee
	jr   nz, .nextRow                                               ; $1fef

	ret                                                             ; $1ff1


; useless?
FillBottom2RowsOfTileMapWithEmptyTile:
; fill 2 game rows on gb's vram screen with empty tiles
	ld   hl, wGameScreenBuffer+$3c2                                 ; $1ff2
	ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                        ; $1ff5
	ld   c, $02                                                     ; $1ff8
	ld   a, TILE_EMPTY                                              ; $1ffa

.nextRow:
	ld   b, GAME_SQUARE_WIDTH                                       ; $1ffc

.nextCol:
	ld   [hl+], a                                                   ; $1ffe
	dec  b                                                          ; $1fff
	jr   nz, .nextCol                                               ; $2000

	add  hl, de                                                     ; $2002
	dec  c                                                          ; $2003
	jr   nz, .nextRow                                               ; $2004

	ret                                                             ; $2006


INCLUDE "code/inGameFlow.s"


; in: BC - vram dest of counts of current num lines
; in: DE - score for line count
; in: HL - ram source of line count byte struct
ProcessCurrentScoreCategory:
; jump if current is updating
	ld   a, [wCurrScoreCategIsProcessingOrUpdating]                 ; $25d9
	cp   $02                                                        ; $25dc
	jr   z, .displayTotalScoreWhileCurrentCategIsUpdating           ; $25de

; push score categ, and jump if num lines in categ = 0
	push de                                                         ; $25e0
	ld   a, [hl]                                                    ; $25e1
	or   a                                                          ; $25e2
	jr   z, .currentCategScoreLineCountEqu0                         ; $25e3

; reduce the count by 1, and increase the next by 1
	dec  a                                                          ; $25e5
	ld   [hl+], a                                                   ; $25e6
	ld   a, [hl]                                                    ; $25e7
	inc  a                                                          ; $25e8
	daa                                                             ; $25e9
	ld   [hl], a                                                    ; $25ea

; display units
	and  $0f                                                        ; $25eb
	ld   [bc], a                                                    ; $25ed

; go left a tile and display tens if non-0
	dec  c                                                          ; $25ee
	ld   a, [hl+]                                                   ; $25ef
	swap a                                                          ; $25f0
	and  $0f                                                        ; $25f2
	jr   z, .afterDisplaying10s                                     ; $25f4

	ld   [bc], a                                                    ; $25f6

.afterDisplaying10s:
; push 10s vram dest, add (level+1) * categ score
	push bc                                                         ; $25f7
	ldh  a, [hBTypeLevel]                                           ; $25f8
	ld   b, a                                                       ; $25fa
	inc  b                                                          ; $25fb

.addCategScore:
	push hl                                                         ; $25fc
	call AddScoreValueDEontoBaseScoreHL                             ; $25fd
	pop  hl                                                         ; $2600
	dec  b                                                          ; $2601
	jr   nz, .addCategScore                                         ; $2602

; pop 10s vram dest, inc hl to last struct byte, and push it
	pop  bc                                                         ; $2604
	inc  hl                                                         ; $2605
	inc  hl                                                         ; $2606
	push hl                                                         ; $2607

; hl equals vram dest of highest byte of total score for categ
	ld   hl, $0023                                                  ; $2608
	add  hl, bc                                                     ; $260b

; de = address of last struct byte, to display it
	pop  de                                                         ; $260c
	call DisplayBCDNum6Digits                                       ; $260d

; de = 10s vram dest of categ count
	pop  de                                                         ; $2610

; add the categ score onto the total score
	ldh  a, [hBTypeLevel]                                           ; $2611
	ld   b, a                                                       ; $2613
	inc  b                                                          ; $2614
	ld   hl, wScoreBCD                                              ; $2615

.addToTotalScore:
	push hl                                                         ; $2618
	call AddScoreValueDEontoBaseScoreHL                             ; $2619
	pop  hl                                                         ; $261c
	dec  b                                                          ; $261d
	jr   nz, .addToTotalScore                                       ; $261e

; set to is updating
	ld   a, $02                                                     ; $2620
	ld   [wCurrScoreCategIsProcessingOrUpdating], a                 ; $2622
	ret                                                             ; $2625

.displayTotalScoreWhileCurrentCategIsUpdating:
; display total score for stage
	ld   de, wScoreBCD+2                                            ; $2626
	ld   hl, $9a25                                                  ; $2629
	call DisplayBCDNum6Digits                                       ; $262c

; play sound and no more updates until game state B allows it after 5 frames
	ld   a, SND_CONFIRM_OR_LETTER_TYPED                             ; $262f
	ld   [wSquareSoundToPlay], a                                    ; $2631

	xor  a                                                          ; $2634
	ld   [wCurrScoreCategIsProcessingOrUpdating], a                 ; $2635
	ret                                                             ; $2638

; ie when updating is done
.currentCategScoreLineCountEqu0:
	pop  de                                                         ; $2639

IncScoreCategoryProcessedAfterBTypeDone:
; higher timer after each category
	ld   a, $21                                                     ; $263a
	ldh  [hTimer1], a                                               ; $263c

	xor  a                                                          ; $263e
	ld   [wCurrScoreCategIsProcessingOrUpdating], a                 ; $263f

; set states after 4 lines processed, and drops processed
	ld   a, [wNumScoreCategoriesProcessed]                          ; $2642
	inc  a                                                          ; $2645
	ld   [wNumScoreCategoriesProcessed], a                          ; $2646
	cp   $05                                                        ; $2649
	ret  nz                                                         ; $264b

	ld   a, GS_LEVEL_ENDED_MAIN                                     ; $264c
	ldh  [hGameState], a                                            ; $264e
	ret                                                             ; $2650


ClearScoreCategoryVarsAndTotalScore:
; clear score category vars
	ld   hl, wLinesClearedStructs                                   ; $2651
	ld   b, wScoreCategoryVarsEnd-wLinesClearedStructs              ; $2654
	xor  a                                                          ; $2656

.clearStructs:
	ld   [hl+], a                                                   ; $2657
	dec  b                                                          ; $2658
	jr   nz, .clearStructs                                          ; $2659

; clear current/total score
	ld   hl, wScoreBCD                                              ; $265b
	ld   b, $03                                                     ; $265e

.clearScore:
	ld   [hl+], a                                                   ; $2660
	dec  b                                                          ; $2661
	jr   nz, .clearScore                                            ; $2662

	ret                                                             ; $2664


; also has PollInput
INCLUDE "code/gfx.s"

INCLUDE "data/spriteData.s"
INCLUDE "data/gfxAndLayouts.s"
INCLUDE "data/demoPieces.s"
