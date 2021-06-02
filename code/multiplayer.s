GameState2a_passive:
; bit cleared on transfer finished
    ld   hl, rSC                                                 ; $05c0
    set  7, [hl]                                                 ; $05c3
    jr   GameState2a_2PlayerGameMusicTypeInit.cont               ; $05c5


GameState2a_2PlayerGameMusicTypeInit:
; have passive stream pings, and master controls
    ld   a, SF_PASSIVE_STREAMING_BYTES                           ; $05c7
    ldh  [hSerialInterruptFunc], a                               ; $05c9

; set SC bit 7 above if passive
    ldh  a, [hMultiplayerPlayerRole]                             ; $05cb
    cp   MP_ROLE_MASTER                                          ; $05cd
    jr   nz, GameState2a_passive                                 ; $05cf

.cont:
; init screen, but hide the A type/ B type choice as not relevant for 1 player
    call GameMusicTypeInitWithoutDisablingSerialRegs             ; $05d1
    ld   a, SPRITE_SPEC_HIDDEN                                   ; $05d4
    ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                       ; $05d6
    call Copy2SpriteSpecsToShadowOam                             ; $05d9

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
    ldh  [hRowsShiftingDownState], a                             ; $05ed
    call ThunkInitSound                                          ; $05ef

; set next state
    ld   a, GS_2PLAYER_GAME_MUSIC_TYPE_MAIN                      ; $05f2
    ldh  [hGameState], a                                         ; $05f4
    ret                                                          ; $05f6


GameState2b_2PlayerGameMusicTypeMain:
    ldh  a, [hMultiplayerPlayerRole]                             ; $05f7
    cp   MP_ROLE_MASTER                                          ; $05f9
    jr   z, .isMaster                                            ; $05fb

; is passive, and this var set..
    ldh  a, [hPassiveShouldUpdateMusicOamAndPlaySong]            ; $05fd
    and  a                                                       ; $05ff
    jr   z, .cont                                                ; $0600

; once change music selection oam, and play relevant song
    xor  a                                                       ; $0602
    ldh  [hPassiveShouldUpdateMusicOamAndPlaySong], a            ; $0603
    ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $0605
    call SetSpriteSpecCoordsForMusicType                         ; $0608
    call PlaySongBasedOnMusicTypeChosen                          ; $060b
    call Copy2SpriteSpecsToShadowOam                             ; $060e
    jr   .cont                                                   ; $0611

.isMaster:
; if master, process A and Start here instead of 1 player code
    ldh  a, [hButtonsPressed]                                    ; $0613
    bit  PADB_A, a                                               ; $0615
    jr   nz, .cont                                               ; $0617

    bit  PADB_START, a                                           ; $0619
    jr   nz, .cont                                               ; $061b

; called if master and neither A or Start pressed
    call GameState0f_MusicTypeMain                               ; $061d

.cont:
    ldh  a, [hMultiplayerPlayerRole]                             ; $0620
    cp   MP_ROLE_MASTER                                          ; $0622
    jr   z, .isMaster2                                           ; $0624

; is passive - wait until master processes transfer
    ldh  a, [hSerialInterruptHandled]                            ; $0626
    and  a                                                       ; $0628
    ret  z                                                       ; $0629

    xor  a                                                       ; $062a
    ldh  [hSerialInterruptHandled], a                            ; $062b

; continuously ping master
    ld   a, SB_PASSIVES_PING_IN_MUSIC_SCREEN                     ; $062d
    ldh  [hNextSerialByteToLoad], a                              ; $062f

; once master indicates going to the next screen, do so as well
    ldh  a, [hSerialByteRead]                                    ; $0631
    cp   SB_GAME_MUSIC_SCREEN_TO_NEXT                            ; $0633
    jr   z, .toNextGameState                                     ; $0635

; otherwise, the byte sent is a music type..
    ld   b, a                                                    ; $0637
    ldh  a, [hMusicType]                                         ; $0638
    cp   b                                                       ; $063a
    ret  z                                                       ; $063b

; set the type if chosen, and next frame, update oam and play song
    ld   a, b                                                    ; $063c
    ldh  [hMusicType], a                                         ; $063d
    ld   a, $01                                                  ; $063f
    ldh  [hPassiveShouldUpdateMusicOamAndPlaySong], a            ; $0641
    ret                                                          ; $0643

.isMaster2:
; check if processing special A/Start case
    ldh  a, [hButtonsPressed]                                    ; $0644
    bit  PADB_START, a                                           ; $0646
    jr   nz, .load50hIntoSerialByte                              ; $0648

    bit  PADB_A, a                                               ; $064a
    jr   nz, .load50hIntoSerialByte                              ; $064c

; neither A or Start pressed, ie did game state $0f
    ldh  a, [hSerialInterruptHandled]                            ; $064e
    and  a                                                       ; $0650
    ret  z                                                       ; $0651

; if did serial transfer, and passive ping not sent (went to next state)
; go to next state as well
    xor  a                                                       ; $0652
    ldh  [hSerialInterruptHandled], a                            ; $0653
    ldh  a, [hNextSerialByteToLoad]                              ; $0655
    cp   SB_GAME_MUSIC_SCREEN_TO_NEXT                            ; $0657
    jr   z, .toNextGameState                                     ; $0659

; else send music byte 
    ldh  a, [hMusicType]                                         ; $065b

.loadNextSerialByte:
    ldh  [hNextSerialByteToLoad], a                              ; $065d
    ld   a, $01                                                  ; $065f
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0661
    ret                                                          ; $0663

.toNextGameState:
    call Clear_wOam                                              ; $0664
    ld   a, GS_MARIO_LUIGI_SCREEN_INIT                           ; $0667
    ldh  [hGameState], a                                         ; $0669
    ret                                                          ; $066b

.load50hIntoSerialByte:
    ld   a, SB_GAME_MUSIC_SCREEN_TO_NEXT                         ; $066c
    jr   .loadNextSerialByte                                     ; $066e


GameState16_passive:
; keep bit 7 set, in case checking when it's cleared
    ld   hl, rSC                                                 ; $0670
    set  7, [hl]                                                 ; $0673
    jr   GameState16_MarioLuigiScreenInit.cont                   ; $0675


GameState16_MarioLuigiScreenInit:
; passive just streams pings, master controls
    ld   a, SF_PASSIVE_STREAMING_BYTES                           ; $0677
    ldh  [hSerialInterruptFunc], a                               ; $0679

    ldh  a, [hMultiplayerPlayerRole]                             ; $067b
    cp   MP_ROLE_MASTER                                          ; $067d
    jr   nz, GameState16_passive                                 ; $067f

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
    call TurnOffLCD                                              ; $0696
    call LoadAsciiAndMenuScreenGfx                               ; $0699
    ld   de, Layout_MarioLuigiScreen                             ; $069c
    call CopyLayoutToScreen0                                     ; $069f

; clear oam and fill game screen with empty tiles
    call Clear_wOam                                              ; $06a2
    ld   a, TILE_EMPTY                                           ; $06a5
    call FillGameScreenBufferWithTileA                           ; $06a7

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
    ldh  a, [h2PlayerGameFinished]                               ; $06cc
    and  a                                                       ; $06ce
    jp   nz, GameState17_MarioLuigiScreenMain.goTo2PlayerInGame  ; $06cf

; play relevant song here, and turn on lcd
    call PlaySongBasedOnMusicTypeChosen                          ; $06d2
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $06d5
    ldh  [rLCDC], a                                              ; $06d7

; load OAM for mario/luigi heads
    ld   hl, wOam+OAM_SIZEOF*$20                                 ; $06d9
    ld   de, .marioLuigiHeads                                    ; $06dc
    ld   b, $20                                                  ; $06df
    call CopyDEtoHL_Bbytes                                       ; $06e1

; load oam from specs for high chosen
    ld   hl, wSpriteSpecs                                        ; $06e4
    ld   de, SpriteSpecStruct_2PlayerHighsFlashing1              ; $06e7
    ld   c, $02                                                  ; $06ea
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $06ec

; set spec coords and send to OAM
    call Set2PlayerHighCoords                                    ; $06ef
    call Copy2SpriteSpecsToShadowOam                             ; $06f2

;
    xor  a                                           ; $06f5: $af
    ldh  [$d7], a                                    ; $06f6: $e0 $d7
    ldh  [$d8], a                                    ; $06f8: $e0 $d8
    ldh  [$d9], a                                    ; $06fa: $e0 $d9
    ldh  [$da], a                                    ; $06fc: $e0 $da
    ldh  [$db], a                                    ; $06fe: $e0 $db

; go to main state
    ld   a, GS_MARIO_LUIGI_SCREEN_MAIN                           ; $0700
    ldh  [hGameState], a                                         ; $0702
    ret                                                          ; $0704

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
    ld   a, [de]                                                 ; $0725
    ld   [hl+], a                                                ; $0726
    inc  de                                                      ; $0727
    dec  b                                                       ; $0728
    jr   nz, .loop                                               ; $0729

    ret                                                          ; $072b


GameState17_MarioLuigiScreenMain:
    ldh  a, [hMultiplayerPlayerRole]                             ; $072c
    cp   MP_ROLE_MASTER                                          ; $072e
    jr   z, .isMaster                                            ; $0730

; is passive, jump if no bytes read
    ldh  a, [hSerialInterruptHandled]                            ; $0732
    and  a                                                       ; $0734
    jr   z, .afterPassiveSerialByteHandled                       ; $0735

; if read $60, go to next state (master Start pressed)
    ldh  a, [hSerialByteRead]                                    ; $0737
    cp   SB_MARIO_LUIGI_SCREEN_TO_NEXT                           ; $0739
    jr   z, .passiveReadByteToTransitionState                    ; $073b

; if byte is < 6, it's the high of player 1
    cp   $06                                                     ; $073d
    jr   nc, .checkOwnHigh                                       ; $073f

    ldh  [w2PlayerHighSelected_1], a                             ; $0741

.checkOwnHigh:
; send master our current high chosen
    ldh  a, [w2PlayerHighSelected_2]                             ; $0743
    ldh  [hNextSerialByteToLoad], a                              ; $0745
    xor  a                                                       ; $0747
    ldh  [hSerialInterruptHandled], a                            ; $0748

.afterPassiveSerialByteHandled:
; now process buttons
    ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF                        ; $074a
    call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $074d
    ld   hl, w2PlayerHighSelected_2                              ; $0750
    jr   .checkPlayersButtons                                    ; $0753

.isMaster:
    ldh  a, [hButtonsPressed]                                    ; $0755
    bit  PADB_START, a                                           ; $0757
    jr   z, .notPressedStart                                     ; $0759

; pressed start
    ld   a, SB_MARIO_LUIGI_SCREEN_TO_NEXT                        ; $075b
    jr   .masterSendSerialByte                                   ; $075d

.notPressedStart:
; check if going next state after interrupt handled
    ldh  a, [hSerialInterruptHandled]                            ; $075f
    and  a                                                       ; $0761
    jr   z, .masterNoInterruptHandled                            ; $0762

    ldh  a, [hNextSerialByteToLoad]                              ; $0764
    cp   SB_MARIO_LUIGI_SCREEN_TO_NEXT                           ; $0766
    jr   nz, .masterNotTransitioningState                        ; $0768

.passiveReadByteToTransitionState:
    call Clear_wOam                                              ; $076a

.goTo2PlayerInGame:
    ldh  a, [h2PlayerGameFinished]                               ; $076d
    and  a                                                       ; $076f
    jr   nz, .aGameFinished                                      ; $0770

; go to in-game, ret if passive
    ld   a, GS_2PLAYER_IN_GAME_INIT                              ; $0772
    ldh  [hGameState], a                                         ; $0774
    ldh  a, [hMultiplayerPlayerRole]                             ; $0776
    cp   MP_ROLE_MASTER                                          ; $0778
    ret  nz                                                      ; $077a

; if master, set completed rows to 0, and fill screen with random blocks
    xor  a                                                       ; $077b
    ldh  [hNumCompletedTetrisRows], a                            ; $077c
    ld   a, $06                                                  ; $077e
    ld   de, -$20                                                ; $0780
    ld   hl, wGameScreenBuffer+$1a2                              ; $0783
    call PopulateGameScreenWithRandomBlocks                      ; $0786
    ret                                                          ; $0789

.aGameFinished:
; if passive, go in-game init from here
    ldh  a, [hMultiplayerPlayerRole]                             ; $078a
    cp   MP_ROLE_MASTER                                          ; $078c
    jp   nz, GameState18_2PlayerInGameInit.initWithoutTurningOffLCD ; $078e

; if master, set completed rows to 0, and fill screen with random blocks
    xor  a                                                       ; $0791
    ldh  [hNumCompletedTetrisRows], a                            ; $0792
    ld   a, $06                                                  ; $0794
    ld   de, -$20                                                ; $0796
    ld   hl, wGameScreenBuffer+$1a2                              ; $0799
    call PopulateGameScreenWithRandomBlocks                      ; $079c

; then go in-game init from here
    jp   GameState18_2PlayerInGameInit.initWithoutTurningOffLCD  ; $079f

.masterNotTransitioningState:
; if byte read is < 6, it's player 2's chosen high
    ldh  a, [hSerialByteRead]                                    ; $07a2
    cp   $06                                                     ; $07a4
    jr   nc, .afterCheckingPlayer2High                           ; $07a6

    ldh  [w2PlayerHighSelected_2], a                             ; $07a8

.afterCheckingPlayer2High:
; send own high to player 2
    ldh  a, [w2PlayerHighSelected_1]                             ; $07aa

.masterSendSerialByte:
    ldh  [hNextSerialByteToLoad], a                              ; $07ac
    xor  a                                                       ; $07ae
    ldh  [hSerialInterruptHandled], a                            ; $07af
    inc  a                                                       ; $07b1
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $07b2

.masterNoInterruptHandled:
; check buttons pressed
    ld   de, wSpriteSpecs                                        ; $07b4
    call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $07b7
    ld   hl, w2PlayerHighSelected_1                              ; $07ba

.checkPlayersButtons:
; A = player's high
    ld   a, [hl]                                                 ; $07bd
    bit  PADB_RIGHT, b                                           ; $07be
    jr   nz, .pressedRight                                       ; $07c0

    bit  PADB_LEFT, b                                            ; $07c2
    jr   nz, .pressedLeft                                        ; $07c4

    bit  PADB_UP, b                                              ; $07c6
    jr   nz, .pressedUp                                          ; $07c8

    bit  PADB_DOWN, b                                            ; $07ca
    jr   z, .afterDirectionalsSendToOam                          ; $07cc

; pressed down, +3 if not on bottom row
    cp   $03                                                     ; $07ce
    jr   nc, .afterDirectionalsSendToOam                         ; $07d0

    add  $03                                                     ; $07d2
    jr   .setNewHighAndPlaySound                                 ; $07d4

.pressedRight:
; +1 if not at last option
    cp   $05                                                     ; $07d6
    jr   z, .afterDirectionalsSendToOam                          ; $07d8

    inc  a                                                       ; $07da

.setNewHighAndPlaySound:
    ld   [hl], a                                                 ; $07db
    ld   a, SND_MOVING_SELECTION                                 ; $07dc
    ld   [wSquareSoundToPlay], a                                 ; $07de

.afterDirectionalsSendToOam:
    call Set2PlayerHighCoords                                    ; $07e1
    call Copy2SpriteSpecsToShadowOam                             ; $07e4
    ret                                                          ; $07e7

.pressedLeft:
; -1 if not at first option
    and  a                                                       ; $07e8
    jr   z, .afterDirectionalsSendToOam                          ; $07e9

    dec  a                                                       ; $07eb
    jr   .setNewHighAndPlaySound                                 ; $07ec

.pressedUp:
; -3 if not on top row
    cp   $03                                                     ; $07ee
    jr   c, .afterDirectionalsSendToOam                          ; $07f0

    sub  $03                                                     ; $07f2
    jr   .setNewHighAndPlaySound                                 ; $07f4


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
    ldh  a, [w2PlayerHighSelected_1]                             ; $080e
    ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $0810
    ld   hl, Player1HighCoords                                   ; $0813
    call SetNumberSpecStructsCoordsAndSpecIdxFromHLtable         ; $0816

    ldh  a, [w2PlayerHighSelected_2]                             ; $0819
    ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset   ; $081b
    ld   hl, Player2HighCoords                                   ; $081e
    call SetNumberSpecStructsCoordsAndSpecIdxFromHLtable         ; $0821
    ret                                                          ; $0824


GameState18_2PlayerInGameInit:
    call TurnOffLCD                                              ; $0825

.initWithoutTurningOffLCD:
; clear some vars
    xor  a                                                       ; $0828
    ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                       ; $0829
    ldh  [hPieceFallingState], a                                 ; $082c
    ldh  [hTetrisFlashCount], a                                  ; $082e
    ldh  [hPieceCollisionDetected], a                            ; $0830
    ldh  [h1stHighScoreHighestByteForLevel], a                   ; $0832
    ldh  [hNumLinesCompletedBCD+1], a                            ; $0834
    ldh  [hSerialInterruptHandled], a                            ; $0836
    ldh  [rSB], a                                                ; $0838
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $083a
    ldh  [hSerialByteRead], a                                    ; $083c
    ldh  [hNextSerialByteToLoad], a                              ; $083e
    ldh  [$d1], a                                    ; $0840: $e0 $d1

; clear score vars, completed rows pointer, and fill bottom of tile map with empty tils
    call ClearScoreCategoryVarsAndTotalScore                     ; $0842
    call ClearPointersToCompletedTetrisRows                      ; $0845
    call FillBottom2RowsOfTileMapWithEmptyTile                   ; $0848

; clear rows shifting down state and OAM
    xor  a                                                       ; $084b
    ldh  [hRowsShiftingDownState], a                             ; $084c
    call Clear_wOam                                              ; $084e

; load layout to screen 0
    ld   de, Layout_2PlayerInGame                                ; $0851
    push de                                                      ; $0854

; must do 20 lines to increase level
    ld   a, $01                                                  ; $0855
    ldh  [hATypeLinesThresholdToPassForNextLevel], a             ; $0857
    ldh  [hIs2Player], a                                         ; $0859
    call CopyLayoutToScreen0                                     ; $085b

; also copy layout to screen 1
    pop  de                                                      ; $085e
    ld   hl, _SCRN1                                              ; $085f
    call CopyLayoutToHL                                          ; $0862

; copy pause screen layout to screen 1
    ld   de, GameInnerScreenLayout_Pause                         ; $0865
    ld   hl, _SCRN1+$63                                          ; $0868
    ld   c, $0a                                                  ; $086b
    call CopyGameScreenInnerText                                 ; $086d

; default sprite specs for active and passive piece
    ld   hl, wSpriteSpecs                                        ; $0870
    ld   de, SpriteSpecStruct_LPieceActive                       ; $0873
    call CopyDEintoHLwhileFFhNotFound                            ; $0876

    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                        ; $0879
    ld   de, SpriteSpecStruct_LPieceNext                         ; $087c
    call CopyDEintoHLwhileFFhNotFound                            ; $087f

; set 30 lines to beat
    ld   hl, _SCRN0+$151                                         ; $0882
    ld   a, $30                                                  ; $0885
    ldh  [hNumLinesCompletedBCD], a                              ; $0887

; and display 30
    ld   [hl], $00                                               ; $0889
    dec  l                                                       ; $088b
    ld   [hl], $03                                               ; $088c

; set pieces speed, and clear num completed rows
    call SetNumFramesUntilPiecesMoveDown                         ; $088e
    xor  a                                                       ; $0891
    ldh  [hNumCompletedTetrisRows], a                            ; $0892

; set face sprite based on player
    ldh  a, [hMultiplayerPlayerRole]                             ; $0894
    cp   MP_ROLE_MASTER                                          ; $0896

; master vals
    ld   de, .marioFace                                          ; $0898
    ldh  a, [w2PlayerHighSelected_1]                             ; $089b
    jr   z, .afterGettingFaceOam                                 ; $089d

; passive vals
    ld   de, .luigiFace                                          ; $089f
    ldh  a, [w2PlayerHighSelected_2]                             ; $08a2

.afterGettingFaceOam:
; store high in screen 0 and 1
    ld   hl, _SCRN0+$b0                                          ; $08a4
    ld   [hl], a                                                 ; $08a7
    ld   h, HIGH(_SCRN1)                                         ; $08a8
    ld   [hl], a                                                 ; $08aa

; copy face sprites oam
    ld   hl, wOam+OAM_SIZEOF*$20                                 ; $08ab
    ld   b, $10                                                  ; $08ae
    call CopyDEtoHL_Bbytes                                       ; $08b0

; 2 player is always clear num lines
    ld   a, GAME_TYPE_B_TYPE                                     ; $08b3
    ldh  [hGameType], a                                          ; $08b5

; turn on LCD, set game state and set in-game serial func
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $08b7
    ldh  [rLCDC], a                                              ; $08b9

    ld   a, GS_19                                      ; $08bb: $3e $19
    ldh  [hGameState], a                                    ; $08bd: $e0 $e1

    ld   a, SF_IN_GAME                                           ; $08bf
    ldh  [hSerialInterruptFunc], a                               ; $08c1
    ret                                                          ; $08c3

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
    ld   a, IEF_SERIAL                                           ; $08e4

    ldh  [rIE], a                                                ; $08e5
    xor  a                                                       ; $08e8
    ldh  [rIF], a                                                ; $08e9

; branch based on role
    ldh  a, [hMultiplayerPlayerRole]                             ; $08eb
    cp   MP_ROLE_MASTER                                          ; $08ed
    jp   nz, GameState19_passive                                 ; $08ef

; is master
.waitUntilPassiveSends55h:
    call SerialTransferWaitFunc                                  ; $08f2
    call SerialTransferWaitFunc                                  ; $08f5
    xor  a                                                       ; $08f8
    ldh  [hSerialInterruptHandled], a                            ; $08f9

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
    ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                     ; $090e
    ld   c, $0a                                                  ; $0911
    ld   hl, wGameScreenBuffer+$102                              ; $0913

.nextRow:
    ld   b, GAME_SQUARE_WIDTH                                    ; $0916

.nextCol:
    xor  a                                                       ; $0918
    ldh  [hSerialInterruptHandled], a                            ; $0919
    call SerialTransferWaitFunc                                  ; $091b

; send tile idx
    ld   a, [hl+]                                                ; $091e
    ldh  [rSB], a                                                ; $091f
    ld   a, SC_REQUEST_TRANSFER|SC_MASTER                        ; $0921
    ldh  [rSC], a                                                ; $0923

.waitUntilSerialInterruptHandled2:
    ldh  a, [hSerialInterruptHandled]                            ; $0925
    and  a                                                       ; $0927
    jr   z, .waitUntilSerialInterruptHandled2                    ; $0928

    dec  b                                                       ; $092a
    jr   nz, .nextCol                                            ; $092b

    add  hl, de                                                  ; $092d
    dec  c                                                       ; $092e
    jr   nz, .nextRow                                            ; $092f

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
    push bc                                                      ; $0a98
    ld   b, $fa                                                  ; $0a99

.loop:
    ld   b, b                                                    ; $0a9b
    dec  b                                                       ; $0a9c
    jr   nz, .loop                                               ; $0a9d

    pop  bc                                                      ; $0a9f
    ret                                                          ; $0aa0


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
    ld   de, SpriteSpecStruct_StandingMarioCryingBabyMario       ; $0d43
    ldh  a, [hMultiplayerPlayerRole]                             ; $0d46
    cp   MP_ROLE_MASTER                                          ; $0d48
    jr   z, .loadHappySprites                                    ; $0d4a

    ld   de, SpriteSpecStruct_StandingLuigiCryingBabyLuigi       ; $0d4c

.loadHappySprites:
    ld   hl, wSpriteSpecs                                        ; $0d4f
    ld   c, $03                                                  ; $0d52
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $0d54

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
    call TurnOffLCD                                              ; $0f6f
    ld   hl, Gfx_RocketScene                                     ; $0f72
    ld   bc, Gfx_RocketScene.end-Gfx_RocketScene+$160            ; $0f75
    call CopyHLtoVramBCbytes                                     ; $0f78
    call FillScreen0FromHLdownWithEmptyTile                      ; $0f7b

; display mario and luigi score screen
    ld   hl, _SCRN0                                              ; $0f7e
    ld   de, Layout_MarioScore                                   ; $0f81
    ld   b, $04                                                  ; $0f84
    call CopyLayoutBrowsToHL                                     ; $0f86

; Layout_BricksAndLuigiScore
    ld   hl, _SCRN0+$180                                         ; $0f89
    ld   b, $06                                                  ; $0f8c
    call CopyLayoutBrowsToHL                                     ; $0f8e

; for master, layout is fine now
    ldh  a, [hMultiplayerPlayerRole]                             ; $0f91
    cp   MP_ROLE_MASTER                                          ; $0f93
    jr   nz, .afterBGdisplay                                     ; $0f95

    setcharmap congrats

; is passive - swap mario/luigi text display
    ld   hl, _SCRN0+$41                                          ; $0f97
    ld   [hl], "L"                                               ; $0f9a
    inc  l                                                       ; $0f9c
    ld   [hl], "U"                                               ; $0f9d
    inc  l                                                       ; $0f9f
    ld   [hl], "I"                                               ; $0fa0
    inc  l                                                       ; $0fa2
    ld   [hl], "G"                                               ; $0fa3
    inc  l                                                       ; $0fa5
    ld   [hl], "I"                                               ; $0fa6

    ld   hl, _SCRN0+$201                                         ; $0fa8
    ld   [hl], "M"                                               ; $0fab
    inc  l                                                       ; $0fad
    ld   [hl], "A"                                               ; $0fae
    inc  l                                                       ; $0fb0
    ld   [hl], "R"                                               ; $0fb1
    inc  l                                                       ; $0fb3
    ld   [hl], "I"                                               ; $0fb4
    inc  l                                                       ; $0fb6
    ld   [hl], "O"                                               ; $0fb7

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
