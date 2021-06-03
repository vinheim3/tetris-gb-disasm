
GameState24_CopyrightDisplay:
	call TurnOffLCD                                                 ; $0369

	call CopyAsciiAndTitleScreenTileData                            ; $036c
	ld   de, Layout_Copyright                                       ; $036f
	call CopyLayoutToScreen0                                        ; $0372
	call Clear_wOam                                                 ; $0375

; set demo pieces
	ld   hl, wDemoPieces                                            ; $0378
	ld   de, DemoPieces                                             ; $037b

.copyLoop:
	ld   a, [de]                                                    ; $037e
	ld   [hl+], a                                                   ; $037f
	inc  de                                                         ; $0380
	ld   a, h                                                       ; $0381
	cp   HIGH(wDemoPieces.end)                                      ; $0382
	jr   nz, .copyLoop                                              ; $0384

; show all, with bg data at $8000, displayed at $9800
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $0386
	ldh  [rLCDC], a                                                 ; $0388

; timer until title screen
	ld   a, $fa                                                     ; $038a
	ldh  [hTimer1], a                                               ; $038c

; set next game state
	ld   a, GS_COPYRIGHT_WAITING                                    ; $038e
	ldh  [hGameState], a                                            ; $0390
	ret                                                             ; $0392


GameState25_CopyrightWaiting:
; wait for timer, set a new one, then go to next state
	ldh  a, [hTimer1]                                               ; $0393
	and  a                                                          ; $0395
	ret  nz                                                         ; $0396

	ld   a, $fa                                                     ; $0397
	ldh  [hTimer1], a                                               ; $0399
	ld   a, GS_COPYRIGHT_CAN_CONTINUE                               ; $039b
	ldh  [hGameState], a                                            ; $039d
	ret                                                             ; $039f


GameState35_CopyrightCanContinue:
; go to next game state, when timer is done, or a button is pressed
	ldh  a, [hButtonsPressed]                                       ; $03a0
	and  a                                                          ; $03a2
	jr   nz, .setNewState                                           ; $03a3

	ldh  a, [hTimer1]                                               ; $03a5
	and  a                                                          ; $03a7
	ret  nz                                                         ; $03a8

.setNewState:
	ld   a, GS_TITLE_SCREEN_INIT                                    ; $03a9
	ldh  [hGameState], a                                            ; $03ab
	ret                                                             ; $03ad


GameState06_TitleScreenInit:
	call TurnOffLCD                                                 ; $03ae

; reset some vars
	xor  a                                                          ; $03b1
	ldh  [hIsRecordingDemo], a                                      ; $03b2
	ldh  [hPieceFallingState], a                                    ; $03b4
	ldh  [hTetrisFlashCount], a                                     ; $03b6
	ldh  [hPieceCollisionDetected], a                               ; $03b8
	ldh  [h1stHighScoreHighestByteForLevel], a                      ; $03ba
	ldh  [hNumLinesCompletedBCD+1], a                               ; $03bc
	ldh  [hRowsShiftingDownState], a                                ; $03be
	ldh  [hMustEnterHighScore], a                                   ; $03c0

; clear some in-game vars and load gfx
	call ClearPointersToCompletedTetrisRows                         ; $03c2
	call ClearScoreCategoryVarsAndTotalScore                        ; $03c5
	call CopyAsciiAndTitleScreenTileData                            ; $03c8

; clear screen buffer
	ld   hl, wGameScreenBuffer                                      ; $03cb

.clearScreenBuffer:
	ld   a, TILE_EMPTY                                              ; $03ce
	ld   [hl+], a                                                   ; $03d0
	ld   a, h                                                       ; $03d1
	cp   HIGH(wGameScreenBuffer.end)                                ; $03d2
	jr   nz, .clearScreenBuffer                                     ; $03d4

; black lines where game bricks would be
	ld   hl, wGameScreenBuffer+1                                    ; $03d6
	call DisplayBlackColumnFromHLdown                               ; $03d9
	ld   hl, wGameScreenBuffer+$c                                   ; $03dc
	call DisplayBlackColumnFromHLdown                               ; $03df

; black row under screen
	ld   hl, wGameScreenBuffer+$241                                 ; $03e2
	ld   b, $0c                                                     ; $03e5
	ld   a, TILE_BLACK                                              ; $03e7

.displayBlackRow:
	ld   [hl+], a                                                   ; $03e9
	dec  b                                                          ; $03ea
	jr   nz, .displayBlackRow                                       ; $03eb

; set display and oam
	ld   de, Layout_TitleScreen                                     ; $03ed
	call CopyLayoutToScreen0                                        ; $03f0
	call Clear_wOam                                                 ; $03f3

; cursor OAM
	ld   hl, wOam                                                   ; $03f6
	ld   [hl], $80                                                  ; $03f9
	inc  l                                                          ; $03fb
	ld   [hl], $10                                                  ; $03fc
	inc  l                                                          ; $03fe
	ld   [hl], TILE_CURSOR                                          ; $03ff

; start playing sound
	ld   a, MUS_TITLE_SCREEN                                        ; $0401
	ld   [wSongToStart], a                                          ; $0403

; set LCD state, game state and timer
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $0406
	ldh  [rLCDC], a                                                 ; $0408
	ld   a, GS_TITLE_SCREEN_MAIN                                    ; $040a
	ldh  [hGameState], a                                            ; $040c
	ld   a, $7d                                                     ; $040e
	ldh  [hTimer1], a                                               ; $0410

; if demo had played, shorter timer before next demo
	ld   a, $04                                                     ; $0412
	ldh  [hTimerMultiplier], a                                      ; $0414

	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $0416
	and  a                                                          ; $0418
	ret  nz                                                         ; $0419

; else set a longer time
	ld   a, $13                                                     ; $041a
	ldh  [hTimerMultiplier], a                                      ; $041c
	ret                                                             ; $041e


PlayDemo:
	ld   a, GAME_TYPE_A_TYPE                                        ; $041f
	ldh  [hGameType], a                                             ; $0421

; for demo 2, a type level 9
	ld   a, $09                                                     ; $0423
	ldh  [hATypeLevel], a                                           ; $0425

; defaults for either demo
	xor  a                                                          ; $0427
	ldh  [hIs2Player], a                                            ; $0428
	ldh  [hLowByteOfCurrDemoStepAddress], a                         ; $042a
	ldh  [hDemoButtonsHeld], a                                      ; $042c
	ldh  [hFramesUntilNextDemoInput], a                             ; $042e

; demo 2 input address
	ld   a, HIGH(Demo2Inputs)                                       ; $0430
	ldh  [hAddressOfDemoInput], a                                   ; $0432
	ld   a, LOW(Demo2Inputs)                                        ; $0434
	ldh  [hAddressOfDemoInput+1], a                                 ; $0436

; flip between demo 1 and 2
	ldh  a, [hPrevOrCurrDemoPlayed]                                 ; $0438
	cp   $02                                                        ; $043a
	ld   a, $02                                                     ; $043c
	jr   nz, .setDemoPlayed                                         ; $043e

; for demo 1 - b type level 9, high 2
	ld   a, GAME_TYPE_B_TYPE                                        ; $0440
	ldh  [hGameType], a                                             ; $0442
	ld   a, $09                                                     ; $0444
	ldh  [hBTypeLevel], a                                           ; $0446
	ld   a, $02                                                     ; $0448
	ldh  [hBTypeHigh], a                                            ; $044a

; demo 1 input address
	ld   a, HIGH(Demo1Inputs)                                       ; $044c
	ldh  [hAddressOfDemoInput], a                                   ; $044e
	ld   a, LOW(Demo1Inputs)                                        ; $0450
	ldh  [hAddressOfDemoInput+1], a                                 ; $0452

; start from step $11 (after demo 2's steps)
	ld   a, $11                                                     ; $0454
	ldh  [hLowByteOfCurrDemoStepAddress], a                         ; $0456
	ld   a, $01                                                     ; $0458

.setDemoPlayed:
	ldh  [hPrevOrCurrDemoPlayed], a                                 ; $045a

; set game state
	ld   a, GS_IN_GAME_INIT                                         ; $045c
	ldh  [hGameState], a                                            ; $045e

; load screen while lcd off
	call TurnOffLCD                                                 ; $0460
	call LoadAsciiAndMenuScreenGfx                                  ; $0463
	ld   de, Layout_GameMusicTypeScreen                             ; $0466
	call CopyLayoutToScreen0                                        ; $0469
	call Clear_wOam                                                 ; $046c

; turn on LCD
	ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $046f
	ldh  [rLCDC], a                                                 ; $0471
	ret                                                             ; $0473


UnusedSetRecordingDemo:
	ld   a, $ff                                                     ; $0474
	ldh  [hIsRecordingDemo], a                                      ; $0476
	ret                                                             ; $0478


GameState07_TitleScreenMain:
; timer multiplier * $7d until a demo plays
	ldh  a, [hTimer1]                                               ; $0479
	and  a                                                          ; $047b
	jr   nz, .afterTimerCheck                                       ; $047c

	ld   hl, hTimerMultiplier                                       ; $047e
	dec  [hl]                                                       ; $0481
	jr   z, PlayDemo                                                ; $0482

	ld   a, $7d                                                     ; $0484
	ldh  [hTimer1], a                                               ; $0486

.afterTimerCheck:
; send $55 to indicate to a master GB that we're active
	call SerialTransferWaitFunc                                     ; $0488
	ld   a, SB_PASSIVES_PING_IN_TITLE_SCREEN                        ; $048b
	ldh  [rSB], a                                                   ; $048d
	ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                          ; $048f
	ldh  [rSC], a                                                   ; $0491

; if a byte was processed..
	ldh  a, [hSerialInterruptHandled]                               ; $0493
	and  a                                                          ; $0495
	jr   z, .checkButtonsPressed                                    ; $0496

; and we've been assigned a role, go to multiplayer state
; ie auto-start for passive GB
	ldh  a, [hMultiplayerPlayerRole]                                ; $0498
	and  a                                                          ; $049a
	jr   nz, .setGameStateTo2ah                                     ; $049b

; otherwise state is invalid
	xor  a                                                          ; $049d
	ldh  [hSerialInterruptHandled], a                               ; $049e
	jr   .multiplayerInvalid                                        ; $04a0

.checkButtonsPressed:
; buttons pressed in B, is 2 player in A
	ldh  a, [hButtonsPressed]                                       ; $04a2
	ld   b, a                                                       ; $04a4
	ldh  a, [hIs2Player]                                            ; $04a5

; select flips between 2 options, left/right does as intended
	bit  PADB_SELECT, b                                             ; $04a7
	jr   nz, .flipNumPlayersOption                                  ; $04a9

	bit  PADB_RIGHT, b                                              ; $04ab
	jr   nz, .pressedRight                                          ; $04ad

	bit  PADB_LEFT, b                                               ; $04af
	jr   nz, .pressedLeft                                           ; $04b1

; start to select an option, other buttons are invalid
	bit  PADB_START, b                                              ; $04b3
	ret  z                                                          ; $04b5

; if 1 player, set 1player state in A
	and  a                                                          ; $04b6
	ld   a, GS_GAME_MUSIC_TYPE_INIT                                 ; $04b7
	jr   z, .is1Player                                              ; $04b9

; 2-player start
	ld   a, b                                                       ; $04bb
	cp   PADF_START                                                 ; $04bc
	ret  nz                                                         ; $04be

; if we're still master, continue
	ldh  a, [hMultiplayerPlayerRole]                                ; $04bf
	cp   MP_ROLE_MASTER                                             ; $04c1
	jr   z, .setGameStateTo2ah                                      ; $04c3

; if 1st gb to press start, send a start request and wait for a reponse
	ld   a, SB_MASTER_PRESSING_START                                ; $04c5
	ldh  [rSB], a                                                   ; $04c7
	ld   a, SC_REQUEST_TRANSFER|SC_MASTER                           ; $04c9
	ldh  [rSC], a                                                   ; $04cb

.waitUntilSerialIntHandled:
	ldh  a, [hSerialInterruptHandled]                               ; $04cd
	and  a                                                          ; $04cf
	jr   z, .waitUntilSerialIntHandled                              ; $04d0

; if not assigned a role, no listening gb
	ldh  a, [hMultiplayerPlayerRole]                                ; $04d2
	and  a                                                          ; $04d4
	jr   z, .multiplayerInvalid                                     ; $04d5

.setGameStateTo2ah:
	ld   a, GS_2PLAYER_GAME_MUSIC_TYPE_INIT                         ; $04d7

.setGameState:
	ldh  [hGameState], a                                            ; $04d9

; clear main timer, level and b type high, and demo played
	xor  a                                                          ; $04db
	ldh  [hTimer1], a                                               ; $04dc
	ldh  [hATypeLevel], a                                           ; $04de
	ldh  [hBTypeLevel], a                                           ; $04e0
	ldh  [hBTypeHigh], a                                            ; $04e2
	ldh  [hPrevOrCurrDemoPlayed], a                                 ; $04e4
	ret                                                             ; $04e6

.is1Player:
	push af                                                         ; $04e7
; if down held while on title screen, set hard mode
	ldh  a, [hButtonsHeld]                                          ; $04e8
	bit  PADB_DOWN, a                                               ; $04ea
	jr   z, .afterDownCheck                                         ; $04ec

	ldh  [hIsHardMode], a                                           ; $04ee

.afterDownCheck:
	pop  af                                                         ; $04f0
	jr   .setGameState                                              ; $04f1

.flipNumPlayersOption:
	xor  $01                                                        ; $04f3

.setNumPlayersOpt:
	ldh  [hIs2Player], a                                            ; $04f5

; set cursor X based on if 1 player or 2 players
	and  a                                                          ; $04f7
	ld   a, $10                                                     ; $04f8
	jr   z, .setCursorX                                             ; $04fa

	ld   a, $60                                                     ; $04fc

.setCursorX:
	ld   [wOam+OAM_X], a                                            ; $04fe
	ret                                                             ; $0501

.pressedRight:
; ret if already 2 player
	and  a                                                          ; $0502
	ret  nz                                                         ; $0503

	xor  a                                                          ; $0504
	jr   .flipNumPlayersOption                                      ; $0505

.pressedLeft:
; ret if already 1 player
	and  a                                                          ; $0507
	ret  z                                                          ; $0508

.multiplayerInvalid:
; set to 1 player
	xor  a                                                          ; $0509
	jr   .setNumPlayersOpt                                          ; $050a
