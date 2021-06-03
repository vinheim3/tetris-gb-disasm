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

; clear some vars and init sound
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $05dc
    xor  a                                                       ; $05de
    ldh  [rSB], a                                                ; $05df
    ldh  [hNextSerialByteToLoad], a                              ; $05e1
    ldh  [h2toThePowerOf_LinesClearedMinus1], a                  ; $05e3
    ldh  [h2toThePowerOf_OtherPlayersLinesClearedMinus1], a      ; $05e5
    ldh  [hOtherPlayersMultiplierToProcess], a                   ; $05e7
    ldh  [hCurrPlayersRowsShiftedUpDueToOtherPlayer], a          ; $05e9
    ldh  [hCurrPlayerJustFinishedRequiredLines], a               ; $05eb
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

; is master, shuffle loaded pieces
    call ShuffleHiddenPieces2Player                              ; $0681
    call ShuffleHiddenPieces2Player                              ; $0684
    call ShuffleHiddenPieces2Player                              ; $0687

; $100 times, shuffle pieces and set them for master
    ld   b, $00                                                  ; $068a
    ld   hl, wDemoOrMultiplayerPieces                            ; $068c

.loop:
    call ShuffleHiddenPieces2Player                              ; $068f
    ld   [hl+], a                                                ; $0692
    dec  b                                                       ; $0693
    jr   nz, .loop                                               ; $0694

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

; have master transfer in vblank, then clear some vars
    ld   a, $03                                                  ; $06aa
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $06ac
    xor  a                                                       ; $06ae
    ldh  [rSB], a                                                ; $06af
    ldh  [hNextSerialByteToLoad], a                              ; $06b1
    ldh  [h2toThePowerOf_LinesClearedMinus1], a                  ; $06b3
    ldh  [h2toThePowerOf_OtherPlayersLinesClearedMinus1], a      ; $06b5
    ldh  [hOtherPlayersMultiplierToProcess], a                   ; $06b7
    ldh  [hCurrPlayersRowsShiftedUpDueToOtherPlayer], a          ; $06b9
    ldh  [hCurrPlayerJustFinishedRequiredLines], a               ; $06bb
    ldh  [hRowsShiftingDownState], a                             ; $06bd
    ldh  [hSerialInterruptHandled], a                            ; $06bf

; load a row of dark solid blocks to act as hard floor under the last of random blocks
    ld   hl, wDarkSolidBlocksUnderRandomBlocks                   ; $06c1
    ld   b, GAME_SQUARE_WIDTH                                    ; $06c4
    ld   a, TILE_DARK_SOLID_BLOCK                                ; $06c6

.copyDarkSolid:
    ld   [hl+], a                                                ; $06c8
    dec  b                                                       ; $06c9
    jr   nz, .copyDarkSolid                                      ; $06ca

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

; clear score-related vars
    xor  a                                                       ; $06f5
    ldh  [hNumWinningGames], a                                   ; $06f6
    ldh  [hNumLosingGames], a                                    ; $06f8
    ldh  [hSelfIsAdvantage], a                                   ; $06fa
    ldh  [hOtherIsAdvantage], a                                  ; $06fc
    ldh  [hIsDeuce], a                                           ; $06fe

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
    ldh  [hOppositeSerialByteToWinningLosingState], a            ; $0840

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

    ld   a, GS_2_PLAYER_SYNC_HIGH_BLOCKS_AND_PIECES              ; $08bb
    ldh  [hGameState], a                                         ; $08bd

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
    
    
GameState19_2PlayerSyncHighBlocksAndPieces:
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

; send passive a byte to say we're in this state
    ld   a, SB_MASTER_GS_19_PING                                 ; $08fb
    ldh  [rSB], a                                                ; $08fd
    ld   a, SC_REQUEST_TRANSFER|SC_MASTER                        ; $08ff
    ldh  [rSC], a                                                ; $0901

.waitUntilSerialInterruptHandled:
    ldh  a, [hSerialInterruptHandled]                            ; $0903
    and  a                                                       ; $0905
    jr   z, .waitUntilSerialInterruptHandled                     ; $0906

; only proceed when passive pings back that they are also in this state
    ldh  a, [rSB]                                                ; $0908
    cp   SB_PASSIVE_PING_WHEN_SYNCING                            ; $090a
    jr   nz, .waitUntilPassiveSends55h                           ; $090c

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
; this will set the random blocks based on master's high
    ldh  a, [w2PlayerHighSelected_1]                             ; $0931
    cp   $05                                                     ; $0933
    jr   z, .waitUntilPassivePresent                             ; $0935

; get starting row of blocks based on high
    ld   hl, wGameScreenBuffer+$222                              ; $0937
    ld   de, GB_TILE_WIDTH*2                                     ; $093a

.getToBufferStartRow:
    add  hl, de                                                  ; $093d
    inc  a                                                       ; $093e
    cp   $05                                                     ; $093f
    jr   nz, .getToBufferStartRow                                ; $0941

; hl now higher in screen based on high
; de is at the bottom (previously loaded high blocks)
; do row copies for 10 rows
    ld   de, wGameScreenBuffer+$222                              ; $0943
    ld   c, $0a                                                  ; $0946

.nextRow2:
    ld   b, GAME_SQUARE_WIDTH                                    ; $0948

.nextCol2:
; copy from bottom to top for row
    ld   a, [de]                                                 ; $094a
    ld   [hl+], a                                                ; $094b
    inc  e                                                       ; $094c
    dec  b                                                       ; $094d
    jr   nz, .nextCol2                                           ; $094e

; hl to row above
    push de                                                      ; $0950
    ld   de, -(GB_TILE_WIDTH+GAME_SQUARE_WIDTH)                  ; $0951
    add  hl, de                                                  ; $0954
    pop  de                                                      ; $0955

; de to row above
    push hl                                                      ; $0956
    ld   hl, -(GB_TILE_WIDTH+GAME_SQUARE_WIDTH)                  ; $0957
    add  hl, de                                                  ; $095a
    push hl                                                      ; $095b
    pop  de                                                      ; $095c
    pop  hl                                                      ; $095d

; to next row
    dec  c                                                       ; $095e
    jr   nz, .nextRow2                                           ; $095f

; every tile above that is considered empty
    ld   de, -(GB_TILE_WIDTH+GAME_SQUARE_WIDTH)                  ; $0961

.toPrevRow:
    ld   b, GAME_SQUARE_WIDTH                                    ; $0964
    ld   a, h                                                    ; $0966
    cp   HIGH(wGameScreenBuffer)                                 ; $0967
    jr   z, .waitUntilPassivePresent                             ; $0969

    ld   a, TILE_EMPTY                                           ; $096b

.setEmpty:
    ld   [hl+], a                                                ; $096d
    dec  b                                                       ; $096e
    jr   nz, .setEmpty                                           ; $096f

    add  hl, de                                                  ; $0971
    jr   .toPrevRow                                              ; $0972

; after high-related code
.waitUntilPassivePresent:
; wait and ping that we're ready for next stage
    call SerialTransferWaitFunc                                  ; $0974
    call SerialTransferWaitFunc                                  ; $0977
    xor  a                                                       ; $097a
    ldh  [hSerialInterruptHandled], a                            ; $097b
    ld   a, SB_MASTER_GS_19_PING                                 ; $097d
    ldh  [rSB], a                                                ; $097f
    ld   a, SC_REQUEST_TRANSFER|SC_MASTER                        ; $0981
    ldh  [rSC], a                                                ; $0983

.waitUntilPassivePingedBack:
    ldh  a, [hSerialInterruptHandled]                            ; $0985
    and  a                                                       ; $0987
    jr   z, .waitUntilPassivePingedBack                          ; $0988

; proceed when passive sends back that they're ready
    ldh  a, [rSB]                                                ; $098a
    cp   SB_PASSIVE_PING_WHEN_SYNCING                            ; $098c
    jr   nz, .waitUntilPassivePresent                            ; $098e

; send $100 loaded pieces to player 2
    ld   hl, wDemoOrMultiplayerPieces                            ; $0990
    ld   b, $00                                                  ; $0993

.sendNextPieceToPassive:
    xor  a                                                       ; $0995
    ldh  [hSerialInterruptHandled], a                            ; $0996

; transfer the tile idx
    ld   a, [hl+]                                                ; $0998
    call SerialTransferWaitFunc                                  ; $0999
    ldh  [rSB], a                                                ; $099c
    ld   a, SC_REQUEST_TRANSFER|SC_MASTER                        ; $099e
    ldh  [rSC], a                                                ; $09a0

.waitUntilPieceSentToPassive:
    ldh  a, [hSerialInterruptHandled]                            ; $09a2
    and  a                                                       ; $09a4
    jr   z, .waitUntilPieceSentToPassive                         ; $09a5

    inc  b                                                       ; $09a7
    jr   nz, .sendNextPieceToPassive                             ; $09a8

; wait for final pings before executing the same code
.waitUntilBothPlayersFinalPinging:
    call SerialTransferWaitFunc                                  ; $09aa
    call SerialTransferWaitFunc                                  ; $09ad
    xor  a                                                       ; $09b0
    ldh  [hSerialInterruptHandled], a                            ; $09b1
    ld   a, SB_MASTER_GS_19_FINAL_PING                           ; $09b3
    ldh  [rSB], a                                                ; $09b5
    ld   a, SC_REQUEST_TRANSFER|SC_MASTER                        ; $09b7
    ldh  [rSC], a                                                ; $09b9

.waitUntilTransferFinished:
    ldh  a, [hSerialInterruptHandled]                            ; $09bb
    and  a                                                       ; $09bd
    jr   z, .waitUntilTransferFinished                           ; $09be

    ldh  a, [rSB]                                                ; $09c0
    cp   SB_PASSIVE_GS_19_FINAL_PING                             ; $09c2
    jr   nz, .waitUntilBothPlayersFinalPinging                   ; $09c4

GameState19_commonEnd:
    call LoadBottomRowWithBlocks                                 ; $09c6

; re-enable vblank, go to next state
    ld   a, IEF_SERIAL|IEF_VBLANK                                ; $09c9
    ldh  [rIE], a                                                ; $09cb
    ld   a, GS_2_PLAYER_SYNC_AT_IN_GAME_INIT_END                 ; $09cd
    ldh  [hGameState], a                                         ; $09cf

; initially copy rows upwards onto screen
    ld   a, ROWS_SHIFTING_DOWN_ROW_START                         ; $09d1
    ldh  [hRowsShiftingDownState], a                             ; $09d3

; passive to continuously stream bytes
    ld   a, SF_PASSIVE_STREAMING_BYTES                           ; $09d5
    ldh  [hSerialInterruptFunc], a                               ; $09d7

; passive, just set bit high to wait for clear
    ldh  a, [hMultiplayerPlayerRole]                             ; $09d9
    cp   MP_ROLE_MASTER                                          ; $09db
    jr   z, .afterPassiveCheck                                   ; $09dd

    ld   hl, rSC                                                 ; $09df
    set  7, [hl]                                                 ; $09e2

.afterPassiveCheck:
; load in active piece and next piece
    ld   hl, wDemoOrMultiplayerPieces                            ; $09e4
    ld   a, [hl+]                                                ; $09e7
    ld   [wSpriteSpecs+SPR_SPEC_SpecIdx], a                      ; $09e8
    ld   a, [hl+]                                                ; $09eb
    ld   [wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx], a      ; $09ec

; store address of next piece
    ld   a, h                                                    ; $09ef
    ldh  [h2PlayerAddressOfNextPiece], a                         ; $09f0
    ld   a, l                                                    ; $09f2
    ldh  [h2PlayerAddressOfNextPiece+1], a                       ; $09f3
    ret                                                          ; $09f5

GameState19_passive:
; B = 1 to 6
    ldh  a, [w2PlayerHighSelected_2]                             ; $09f6
    inc  a                                                       ; $09f8
    ld   b, a                                                    ; $09f9

; go up a number of rows based on high (starting row of random blocks)
    ld   hl, wGameScreenBuffer+$242                              ; $09fa
    ld   de, -$40                                                ; $09fd

.toDecB:
    dec  b                                                       ; $0a00
    jr   z, .waitUntilMasterPresent                              ; $0a01

    add  hl, de                                                  ; $0a03
    jr   .toDecB                                                 ; $0a04

.waitUntilMasterPresent:
; wait, then ping master
    call SerialTransferWaitFunc                                  ; $0a06
    xor  a                                                       ; $0a09
    ldh  [hSerialInterruptHandled], a                            ; $0a0a
    ld   a, SB_PASSIVE_PING_WHEN_SYNCING                         ; $0a0c
    ldh  [rSB], a                                                ; $0a0e
    ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                       ; $0a10
    ldh  [rSC], a                                                ; $0a12

.waitUntilPingToMasterHandled:
    ldh  a, [hSerialInterruptHandled]                            ; $0a14
    and  a                                                       ; $0a16
    jr   z, .waitUntilPingToMasterHandled                        ; $0a17

; if master sent back initial byte, proceed, else loop up
    ldh  a, [rSB]                                                ; $0a19
    cp   SB_MASTER_GS_19_PING                                    ; $0a1b
    jr   nz, .waitUntilMasterPresent                             ; $0a1d

; at this point, master will send bytes about 10 rows of high-related starting blocks
    ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                     ; $0a1f
    ld   c, $0a                                                  ; $0a22

.nextRow:
    ld   b, GAME_SQUARE_WIDTH                                    ; $0a24

.nextCol:
; ping master 0s at this time
    lda SB_PASSIVE_PING_LOADING_HIGH_BLOCKS                      ; $0a26
    ldh  [hSerialInterruptHandled], a                            ; $0a27
    ldh  [rSB], a                                                ; $0a29
    ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                       ; $0a2b
    ldh  [rSC], a                                                ; $0a2d

.waitUntilMasterSendsStartingBlock:
    ldh  a, [hSerialInterruptHandled]                            ; $0a2f
    and  a                                                       ; $0a31
    jr   z, .waitUntilMasterSendsStartingBlock                   ; $0a32

; set byte based on starting row for high blocks (from up high)
    ldh  a, [rSB]                                                ; $0a34
    ld   [hl+], a                                                ; $0a36
    dec  b                                                       ; $0a37
    jr   nz, .nextCol                                            ; $0a38

    add  hl, de                                                  ; $0a3a
    dec  c                                                       ; $0a3b
    jr   nz, .nextRow                                            ; $0a3c

; proceed once master + passive send back usual pings
.waitUntilMasterReadyToSendPieces:
    call SerialTransferWaitFunc                                  ; $0a3e
    xor  a                                                       ; $0a41
    ldh  [hSerialInterruptHandled], a                            ; $0a42
    ld   a, SB_PASSIVE_PING_WHEN_SYNCING                         ; $0a44
    ldh  [rSB], a                                                ; $0a46
    ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                       ; $0a48
    ldh  [rSC], a                                                ; $0a4a

.waitUntilTransferFinished:
    ldh  a, [hSerialInterruptHandled]                            ; $0a4c
    and  a                                                       ; $0a4e
    jr   z, .waitUntilTransferFinished                           ; $0a4f

    ldh  a, [rSB]                                                ; $0a51
    cp   SB_MASTER_GS_19_PING                                    ; $0a53
    jr   nz, .waitUntilMasterReadyToSendPieces                   ; $0a55

; start loading those pieces
    ld   b, $00                                                  ; $0a57
    ld   hl, wDemoOrMultiplayerPieces                            ; $0a59

.loadNextPiece:
    xor  a                                                       ; $0a5c
    ldh  [hSerialInterruptHandled], a                            ; $0a5d
    ldh  [rSB], a                                                ; $0a5f
    ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                       ; $0a61
    ldh  [rSC], a                                                ; $0a63

.waitUntilTransferFinished2:
    ldh  a, [hSerialInterruptHandled]                            ; $0a65
    and  a                                                       ; $0a67
    jr   z, .waitUntilTransferFinished2                          ; $0a68

; read from byte into mult pieces
    ldh  a, [rSB]                                                ; $0a6a
    ld   [hl+], a                                                ; $0a6c
    inc  b                                                       ; $0a6d
    jr   nz, .loadNextPiece                                      ; $0a6e

; wait for final pings before executing the same code
.waitUntilBothPlayersFinalPinging:
    call SerialTransferWaitFunc                                  ; $0a70
    xor  a                                                       ; $0a73
    ldh  [hSerialInterruptHandled], a                            ; $0a74
    ld   a, SB_PASSIVE_GS_19_FINAL_PING                          ; $0a76
    ldh  [rSB], a                                                ; $0a78
    ld   a, SC_REQUEST_TRANSFER|SC_PASSIVE                       ; $0a7a
    ldh  [rSC], a                                                ; $0a7c

.waitUntilTransferFinished3:
    ldh  a, [hSerialInterruptHandled]                            ; $0a7e
    and  a                                                       ; $0a80
    jr   z, .waitUntilTransferFinished3                          ; $0a81

    ldh  a, [rSB]                                                ; $0a83
    cp   SB_MASTER_GS_19_FINAL_PING                              ; $0a85
    jr   nz, .waitUntilBothPlayersFinalPinging                   ; $0a87

    jp   GameState19_commonEnd                                   ; $0a89


LoadBottomRowWithBlocks:
    ld   hl, wGameScreenBuffer+$242                              ; $0a8c
    ld   a, TILE_PIECE_SQUARES_START                             ; $0a8f
    ld   b, GAME_SQUARE_WIDTH                                    ; $0a91

.nextCol:
    ld   [hl+], a                                                ; $0a93
    dec  b                                                       ; $0a94
    jr   nz, .nextCol                                            ; $0a95

    ret                                                          ; $0a97


SerialTransferWaitFunc:
    push bc                                                      ; $0a98
    ld   b, $fa                                                  ; $0a99

.loop:
    ld   b, b                                                    ; $0a9b
    dec  b                                                       ; $0a9c
    jr   nz, .loop                                               ; $0a9d

    pop  bc                                                      ; $0a9f
    ret                                                          ; $0aa0


ShuffleHiddenPieces2Player:
    push hl                                                      ; $0aa1
    push bc                                                      ; $0aa2

; piece base spec idx in C
    ldh  a, [hPrevHiddenPiece]                                   ; $0aa3
    and  $fc                                                     ; $0aa5
    ld   c, a                                                    ; $0aa7

; 3 times try to get a new piece
    ld   h, $03                                                  ; $0aa8

.nextRandomVal:
; random val in B
    ldh  a, [rDIV]                                               ; $0aaa
    ld   b, a                                                    ; $0aac

.loop1chTo0:
    xor  a                                                       ; $0aad

.toDecB:
    dec  b                                                       ; $0aae
    jr   z, .afterBEqu0                                          ; $0aaf

; loop A through piece indexes
    inc  a                                                       ; $0ab1
    inc  a                                                       ; $0ab2
    inc  a                                                       ; $0ab3
    inc  a                                                       ; $0ab4
    cp   $1c                                                     ; $0ab5
    jr   z, .loop1chTo0                                          ; $0ab7

    jr   .toDecB                                                 ; $0ab9

.afterBEqu0:
; get random piece idx in D, hidden piece in E..
    ld   d, a                                                    ; $0abb
    ldh  a, [hHiddenLoadedPiece]                                 ; $0abc
    ld   e, a                                                    ; $0abe
    dec  h                                                       ; $0abf
    jr   z, .fromTriesExhausted                                  ; $0ac0

; if hidden/prev random piece | random piece idx | prev hidden == prev hidden, try again
    or   d                                                       ; $0ac2
    or   c                                                       ; $0ac3
    and  $fc                                                     ; $0ac4
    cp   c                                                       ; $0ac6
    jr   z, .nextRandomVal                                       ; $0ac7

.fromTriesExhausted:
; random piece in hidden, hidden piece in fc, ret prev hidden
    ld   a, d                                                    ; $0ac9
    ldh  [hHiddenLoadedPiece], a                                 ; $0aca
    ld   a, e                                                    ; $0acc
    ldh  [hPrevHiddenPiece], a                                   ; $0acd
    pop  bc                                                      ; $0acf
    pop  hl                                                      ; $0ad0
    ret                                                          ; $0ad1


GameState1c_2PlayerSyncAtInGameInitEnd:
; no serial
    ld   a, IEF_VBLANK                                           ; $0ad2
    ldh  [rIE], a                                                ; $0ad4

; jump if game buffer not yet fully copied to screen
    ldh  a, [hRowsShiftingDownState]                             ; $0ad6
    and  a                                                       ; $0ad8
    jr   nz, .rowsNotYetLoaded                                   ; $0ad9

; wait until both players in this state (when rows all loaded)
    ld   b, $44                                                  ; $0adb
    ld   c, $20                                                  ; $0add
    call ReturnFromCallersContextUntilBothPlayersCommunicatingBC ; $0adf

; serial func is like passively streaming, although loaded byte is set to $ff after transfer
    ld   a, SF_2_PLAYER_IN_GAME                                  ; $0ae2
    ldh  [hSerialInterruptFunc], a                               ; $0ae4

; hide next piece if var set
    ld   a, [wNextPieceHidden]                                   ; $0ae6
    and  a                                                       ; $0ae9
    jr   z, .afterHidden                                         ; $0aea

    ld   a, SPRITE_SPEC_HIDDEN                                   ; $0aec
    ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                       ; $0aee

.afterHidden:
; copy pieces to oam, play song
    call Copy1stSpriteSpecToSprite4                              ; $0af1
    call Copy2ndSpriteSpecToSprite8                              ; $0af4
    call PlaySongBasedOnMusicTypeChosen                          ; $0af7

; set that 0 games had been finished since menu, and go to next state
    xor  a                                                       ; $0afa
    ldh  [h2PlayerGameFinished], a                               ; $0afb
    ld   a, GS_2PLAYER_IN_GAME_MAIN                              ; $0afd
    ldh  [hGameState], a                                         ; $0aff
    ret                                                          ; $0b01

.rowsNotYetLoaded:
    cp   $05                                                     ; $0b02
    ret  nz                                                      ; $0b04

; now at 5th row being loaded, hide all left side line markings
    ld   hl, wOam+OAM_SIZEOF*12                                  ; $0b05
    ld   b, $12                                                  ; $0b08

.loopWallMarkings:
    ld   [hl], $f0                                               ; $0b0a
    inc  hl                                                      ; $0b0c
    ld   [hl], $10                                               ; $0b0d
    inc  hl                                                      ; $0b0f
    ld   [hl], TILE_2_PLAYER_LINE_MARKING                        ; $0b10
    inc  hl                                                      ; $0b12
    ld   [hl], $80                                               ; $0b13
    inc  hl                                                      ; $0b15
    dec  b                                                       ; $0b16
    jr   nz, .loopWallMarkings                                   ; $0b17

; get value between 0 and $18
    ld   a, [wDemoOrMultiplayerPieces.end-1]                     ; $0b19

; l += A % 10, ie put an empty tile in the dark solid blocks
.loopUntilBequ0:
    ld   b, $0a                                                  ; $0b1c
    ld   hl, wDarkSolidBlocksUnderRandomBlocks                   ; $0b1e

.nextB:
    dec  a                                                       ; $0b21
    jr   z, .done                                                ; $0b22

    inc  l                                                       ; $0b24
    dec  b                                                       ; $0b25
    jr   nz, .nextB                                              ; $0b26

    jr   .loopUntilBequ0                                         ; $0b28

.done:
    ld   [hl], TILE_EMPTY                                        ; $0b2a

; transfer in vblank
    ld   a, $03                                                  ; $0b2c
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0b2e
    ret                                                          ; $0b30


GameState1a_2PlayerInGameMain:
; no serial
    ld   a, IEF_VBLANK                                           ; $0b31
    ldh  [rIE], a                                                ; $0b33

; last sprite is a heart
    ld   hl, wOam+OAM_SIZEOF*39                                  ; $0b35
    xor  a                                                       ; $0b38
    ld   [hl+], a                                                ; $0b39
    ld   [hl], $50                                               ; $0b3a
    inc  l                                                       ; $0b3c
    ld   [hl], "<3"                                              ; $0b3d
    inc  l                                                       ; $0b3f
    ld   [hl], $00                                               ; $0b40
 
    call InGameCheckResetAndPause.start                          ; $0b42
 
; if still paused, none of the functions below execute
    call InGame2PlayerCheckUnpaused                              ; $0b45

; normal in-game functionality, except last which plays custom song
    call InGameCheckButtonsPressed                               ; $0b48
    call InGameHandlePieceFalling.start                          ; $0b4b
    call InGameCheckIfAnyTetrisRowsComplete                      ; $0b4e
    call InGameAddPieceToVram                                    ; $0b51
    call ShiftEntireGameRamBufferDownARow                        ; $0b54
    call CheckAlmostLosingStatus                                 ; $0b57

; check if we're done now
    ldh  a, [hCurrPlayerJustFinishedRequiredLines]               ; $0b5a
    and  a                                                       ; $0b5c
    jr   z, .notYetFinished                                      ; $0b5d

; send level finished byte
    ld   a, SB_LEVEL_WON                                         ; $0b5f
    ldh  [hNextSerialByteToLoad], a                              ; $0b61
    ldh  [hNumRowsUpOurTetrisPiecesAre], a                       ; $0b63

; store opposite
    ld   a, SB_LEVEL_LOST                                        ; $0b65
    ldh  [hOppositeSerialByteToWinningLosingState], a            ; $0b67

; go to end game state and set timer
    ld   a, GS_2_PLAYER_GAME_END                                 ; $0b69
    ldh  [hGameState], a                                         ; $0b6b
    ld   a, $05                                                  ; $0b6d
    ldh  [hTimer2], a                                            ; $0b6f
    jr   .afterLevelDone                                         ; $0b71

.notYetFinished:
; if not in game over, skip below including that we should transfer in vblank
    ldh  a, [hGameState]                                         ; $0b73
    cp   GS_GAME_OVER_INIT                                       ; $0b75
    jr   nz, .end                                                ; $0b77

; in game over init state, during InGameHandlePieceFalling, send level lost byte
    ld   a, SB_LEVEL_LOST                                        ; $0b79
    ldh  [hNextSerialByteToLoad], a                              ; $0b7b
    ldh  [hNumRowsUpOurTetrisPiecesAre], a                       ; $0b7d

; store opposite
    ld   a, SB_LEVEL_WON                                         ; $0b7f
    ldh  [hOppositeSerialByteToWinningLosingState], a            ; $0b81

.afterLevelDone:
; clear some vars
    xor  a                                                       ; $0b83
    ldh  [h2toThePowerOf_LinesClearedMinus1], a                  ; $0b84
    ldh  [h2toThePowerOf_OtherPlayersLinesClearedMinus1], a      ; $0b86
    ldh  [hOtherPlayersMultiplierToProcess], a                   ; $0b88
    ldh  [hCurrPlayersRowsShiftedUpDueToOtherPlayer], a          ; $0b8a

; if master, set that transfer should happen
    ldh  a, [hMultiplayerPlayerRole]                             ; $0b8c
    cp   MP_ROLE_MASTER                                          ; $0b8e
    jr   nz, .end                                                ; $0b90

    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0b92

.end:
    call InGame2PlayerProcessSerialByte                          ; $0b94
    call CheckIfOtherPlayerCleared2PlusLines                     ; $0b97
    ret                                                          ; $0b9a


; plays or unplays an 'almost losing' song
CheckAlmostLosingStatus:
; loop through entire game screen buffer, looking for non-empty tiles
    ld   de, GB_TILE_WIDTH                                       ; $0b9b
    ld   hl, wGameScreenBuffer+2                                 ; $0b9e
    ld   a, TILE_EMPTY                                           ; $0ba1
    ld   c, GAME_SCREEN_ROWS                                     ; $0ba3

.nextRow:
    ld   b, GAME_SQUARE_WIDTH                                    ; $0ba5
    push hl                                                      ; $0ba7

; jump if game buffer has a non-empty tile
.nextCol:
    cp   [hl]                                                    ; $0ba8
    jr   nz, .afterLoop                                          ; $0ba9

    inc  hl                                                      ; $0bab
    dec  b                                                       ; $0bac
    jr   nz, .nextCol                                            ; $0bad

    pop  hl                                                      ; $0baf
    add  hl, de                                                  ; $0bb0
    dec  c                                                       ; $0bb1
    jr   nz, .nextRow                                            ; $0bb2

; re-push, so pop hl works the same for both branches
    push hl                                                      ; $0bb4

.afterLoop:
    pop  hl                                                      ; $0bb5

; C is now 0 if all blank tiles, 1 if non-blanks on bottom row, etc
    ld   a, c                                                    ; $0bb6
    ldh  [hNumRowsUpOurTetrisPiecesAre], a                       ; $0bb7
    cp   $0c                                                     ; $0bb9

; jump if near in top 1/3 of screen
    ld   a, [wSongBeingPlayed]                                   ; $0bbb
    jr   nc, .nearTop                                            ; $0bbe

; not near top, play orig song if losing song is playing
    cp   MUS_2_PLAYER_ALMOST_LOSING                              ; $0bc0
    ret  nz                                                      ; $0bc2

    call PlaySongBasedOnMusicTypeChosen                          ; $0bc3
    ret                                                          ; $0bc6

.nearTop:
; ret if already playing 
    cp   MUS_2_PLAYER_ALMOST_LOSING                              ; $0bc7
    ret  z                                                       ; $0bc9

; ret if already dead
    ld   a, [wWavSoundToPlay]                                    ; $0bca
    cp   WAV_GAME_OVER                                           ; $0bcd
    ret  z                                                       ; $0bcf

; play almost losing song
    ld   a, MUS_2_PLAYER_ALMOST_LOSING                           ; $0bd0
    ld   [wSongToStart], a                                       ; $0bd2
    ret                                                          ; $0bd5

    
MasterPausedSerialByteRead:
; continue if master
    ldh  a, [hMultiplayerPlayerRole]                             ; $0bd6
    cp   MP_ROLE_MASTER                                          ; $0bd8
    jr   z, InGame2PlayerProcessSerialByte.afterProcessingSerialByte ; $0bda

; if passive, set game just paused
    ld   a, $01                                                  ; $0bdc
    ld   [wGamePausedActivity], a                                ; $0bde
    ldh  [hGamePaused], a                                        ; $0be1

; save serial byte it was going to load, but not byte read
    ldh  a, [hNextSerialByteToLoad]                              ; $0be3
    ldh  [hPausedNextSerialByteToLoad], a                        ; $0be5
    xor  a                                                       ; $0be7
    ldh  [hPausedSerialByteRead], a                              ; $0be8
    ldh  [hNextSerialByteToLoad], a                              ; $0bea

    call Display2PlayerPauseText                                 ; $0bec
    ret                                                          ; $0bef


InGame2PlayerProcessSerialByte:
; ret if no serial bytes to process
    ldh  a, [hSerialInterruptHandled]                            ; $0bf0
    and  a                                                       ; $0bf2
    ret  z                                                       ; $0bf3

; oam address of line markings
    ld   hl, wOam+OAM_SIZEOF*12                                  ; $0bf4
    ld   de, OAM_SIZEOF                                          ; $0bf7

; check serial byte
    xor  a                                                       ; $0bfa
    ldh  [hSerialInterruptHandled], a                            ; $0bfb

    ldh  a, [hSerialByteRead]                                    ; $0bfd
    cp   SB_LEVEL_LOST                                           ; $0bff
    jr   z, .otherPlayerLost                                     ; $0c01

    cp   SB_LEVEL_WON                                            ; $0c03
    jr   z, .otherPlayerWon                                      ; $0c05

    cp   SB_MASTER_PAUSED                                        ; $0c07
    jr   z, MasterPausedSerialByteRead                           ; $0c09

; store serial byte in B as well
    ld   b, a                                                    ; $0c0b
    and  a                                                       ; $0c0c
    jr   z, .noLineMarkings                                      ; $0c0d

    bit  7, a                                                    ; $0c0f
    jr   nz, .serialByteBit7set                                  ; $0c11

    cp   $13                                                     ; $0c13
    jr   nc, .afterProcessingSerialByte                          ; $0c15

; B = 1 to $12 (num line markings to draw), C = $12-B+1, ie $12 to 1
    ld   a, GAME_SCREEN_ROWS                                     ; $0c17
    sub  b                                                       ; $0c19
    ld   c, a                                                    ; $0c1a
    inc  c                                                       ; $0c1b

.drawBLineMarkings:
; Y on screen from $98, going up (-8)
    ld   a, $98                                                  ; $0c1c

.loopShownMarkings:
    ld   [hl], a                                                 ; $0c1e
    add  hl, de                                                  ; $0c1f
    sub  $08                                                     ; $0c20
    dec  b                                                       ; $0c22
    jr   nz, .loopShownMarkings                                  ; $0c23

.afterShownLineMarkings:
; for remaining sprites, set Y out of screen
    ld   a, $f0                                                  ; $0c25

.loopHiddenMarkings:
    dec  c                                                       ; $0c27
    jr   z, .afterProcessingSerialByte                           ; $0c28

    ld   [hl], a                                                 ; $0c2a
    add  hl, de                                                  ; $0c2b
    jr   .loopHiddenMarkings                                     ; $0c2c

.afterProcessingSerialByte:
; if we just cleared 2+ lines
    ldh  a, [h2toThePowerOf_LinesClearedMinus1]                  ; $0c2e
    and  a                                                       ; $0c30
    jr   z, .afterProcessingSerialBytecont                       ; $0c31

; send other player our 2^x with bit 7 set
    or   $80                                                     ; $0c33
    ldh  [hNumRowsUpOurTetrisPiecesAre], a                       ; $0c35
    xor  a                                                       ; $0c37
    ldh  [h2toThePowerOf_LinesClearedMinus1], a                  ; $0c38

.afterProcessingSerialBytecont:
; dont reprocess serial byte
    ld   a, $ff                                                  ; $0c3a
    ldh  [hSerialByteRead], a                                    ; $0c3c
    ldh  a, [hMultiplayerPlayerRole]                             ; $0c3e

; if passive, dont set masters var. either way, report to each other
; the line markings to draw based on how high up our pieces are
    cp   MP_ROLE_MASTER                                          ; $0c40
    ldh  a, [hNumRowsUpOurTetrisPiecesAre]                       ; $0c42
    jr   nz, .setNextSerialByteToLoad                            ; $0c44

    ldh  [hNextSerialByteToLoad], a                              ; $0c46
    ld   a, $01                                                  ; $0c48
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0c4a
    ret                                                          ; $0c4c

.setNextSerialByteToLoad:
    ldh  [hNextSerialByteToLoad], a                              ; $0c4d
    ret                                                          ; $0c4f

.otherPlayerWon:
; other player won, and we won, jump
    ldh  a, [hOppositeSerialByteToWinningLosingState]            ; $0c50
    cp   SB_LEVEL_LOST                                           ; $0c52
    jr   z, .wonOrLostAtTheSameTime                              ; $0c54

; otherwise we lost
    ld   a, SB_LEVEL_WON                                         ; $0c56
    ldh  [hOppositeSerialByteToWinningLosingState], a            ; $0c58
    ld   a, GS_GAME_OVER_INIT                                    ; $0c5a
    ldh  [hGameState], a                                         ; $0c5c
    jr   .afterProcessingSerialByte                              ; $0c5e

.noLineMarkings:
; B = 1 to $12 yields C = $12 to 1
; here B = 0, yields C = $13, ie C = $13-num line markings
    ld   c, $13                                                  ; $0c60
    jr   .afterShownLineMarkings                                 ; $0c62

.otherPlayerLost:
; other player lost, and we lost, jump
    ldh  a, [hOppositeSerialByteToWinningLosingState]            ; $0c64
    cp   SB_LEVEL_WON                                            ; $0c66
    jr   z, .wonOrLostAtTheSameTime                              ; $0c68

; otherwise we won
    ld   a, SB_LEVEL_LOST                                        ; $0c6a
    ldh  [hOppositeSerialByteToWinningLosingState], a            ; $0c6c
    ld   a, GS_2_PLAYER_GAME_END                                 ; $0c6e
    ldh  [hGameState], a                                         ; $0c70

; set timer
    ld   a, $05                                                  ; $0c72
    ldh  [hTimer2], a                                            ; $0c74

; draw $12 line markings, hide 1
    ld   c, $01                                                  ; $0c76
    ld   b, $12                                                  ; $0c78
    jr   .drawBLineMarkings                                      ; $0c7a

.wonOrLostAtTheSameTime:
    ld   a, $01                                                  ; $0c7c
    ldh  [hWonOrLostAtTheSameTimeAsOtherPlayer], a               ; $0c7e
    jr   .afterProcessingSerialByte                              ; $0c80

.serialByteBit7set:
; player cleared 2+ lines, A is 2 lines->1, 3 lines->2, 4 lines->4
    and  $7f                                                     ; $0c82
    cp   $05                                                     ; $0c84
    jr   nc, .afterProcessingSerialByte                          ; $0c86

; after sanity check, store other player's lines cleared multiplier
    ldh  [h2toThePowerOf_OtherPlayersLinesClearedMinus1], a      ; $0c88
    jr   .afterProcessingSerialBytecont                          ; $0c8a


CheckIfOtherPlayerCleared2PlusLines:
    ldh  a, [hOtherPlayersMultiplierToProcess]                   ; $0c8c
    and  a                                                       ; $0c8e
    jr   z, .checkIfMultiplierToProcess                          ; $0c8f

; if multiplier to process, and exec'd function to play next piece, jump
    bit  7, a                                                    ; $0c91
    ret  z                                                       ; $0c93

    and  $07                                                     ; $0c94
    jr   .multiplierToProcessAfterPlayingPiece                   ; $0c96

.checkIfMultiplierToProcess:
; continue if other player cleared 2+ lines
    ldh  a, [h2toThePowerOf_OtherPlayersLinesClearedMinus1]      ; $0c98
    and  a                                                       ; $0c9a
    ret  z                                                       ; $0c9b

; store the multiplier once, dont do anything until after a piece is played
    ldh  [hOtherPlayersMultiplierToProcess], a                   ; $0c9c
    xor  a                                                       ; $0c9e
    ldh  [h2toThePowerOf_OtherPlayersLinesClearedMinus1], a      ; $0c9f
    ret                                                          ; $0ca1

.multiplierToProcessAfterPlayingPiece:
; 1, 2 or 4 in C
    ld   c, a                                                    ; $0ca2
    push bc                                                      ; $0ca3

; get starting row, the higher the other player's multiplier,
; the higher we're shifting rows
    ld   hl, wGameScreenBuffer+$22                               ; $0ca4
    ld   de, -GB_TILE_WIDTH                                      ; $0ca7

.getStartingRow:
    add  hl, de                                                  ; $0caa
    dec  c                                                       ; $0cab
    jr   nz, .getStartingRow                                     ; $0cac

; hl is high up, de is top of screen
    ld   de, wGameScreenBuffer+$22                               ; $0cae
    ld   c, GAME_SCREEN_ROWS-1                                   ; $0cb1

; copy rows upwards
.copyNextRow:
    ld   b, GAME_SQUARE_WIDTH                                    ; $0cb3

.copyNextCol:
    ld   a, [de]                                                 ; $0cb5
    ld   [hl+], a                                                ; $0cb6
    inc  e                                                       ; $0cb7
    dec  b                                                       ; $0cb8
    jr   nz, .copyNextCol                                        ; $0cb9

; hl to next row
    push de                                                      ; $0cbb
    ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                     ; $0cbc
    add  hl, de                                                  ; $0cbf
    pop  de                                                      ; $0cc0

; de to next row
    push hl                                                      ; $0cc1
    ld   hl, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                     ; $0cc2
    add  hl, de                                                  ; $0cc5
    push hl                                                      ; $0cc6
    pop  de                                                      ; $0cc7
    pop  hl                                                      ; $0cc8

    dec  c                                                       ; $0cc9
    jr   nz, .copyNextRow                                        ; $0cca

; C is multiplier, hl now bottom of high-related blocks
    pop  bc                                                      ; $0ccc

; copy dark solid blocks underneath our loaded high-related blocks
.copyDarkSolidRow:
    ld   de, wDarkSolidBlocksUnderRandomBlocks                   ; $0ccd
    ld   b, GAME_SQUARE_WIDTH                                    ; $0cd0

.copyDarkSolidCol:
    ld   a, [de]                                                 ; $0cd2
    ld   [hl+], a                                                ; $0cd3
    inc  de                                                      ; $0cd4
    dec  b                                                       ; $0cd5
    jr   nz, .copyDarkSolidCol                                   ; $0cd6

    push de                                                      ; $0cd8
    ld   de, GB_TILE_WIDTH-GAME_SQUARE_WIDTH                     ; $0cd9
    add  hl, de                                                  ; $0cdc
    pop  de                                                      ; $0cdd
    dec  c                                                       ; $0cde
    jr   nz, .copyDarkSolidRow                                   ; $0cdf

; copy rows to vram
    ld   a, ROWS_SHIFTING_DOWN_ROW_START                         ; $0ce1
    ldh  [hRowsShiftingDownState], a                             ; $0ce3
    ldh  [hCurrPlayersRowsShiftedUpDueToOtherPlayer], a          ; $0ce5

; multiplier now processed
    xor  a                                                       ; $0ce7
    ldh  [hOtherPlayersMultiplierToProcess], a                   ; $0ce8
    ret                                                          ; $0cea


GameState1b_2PlayerGameEnd:
; proceed when timer done
    ldh  a, [hTimer1]                                            ; $0ceb
    and  a                                                       ; $0ced
    ret  nz                                                      ; $0cee

; no serial
    ld   a, IEF_VBLANK                                           ; $0cef
    ldh  [rIE], a                                                ; $0cf1

; read each other's bytes passive stream bytes
    ld   a, SF_PASSIVE_STREAMING_BYTES                           ; $0cf3
    ldh  [hSerialInterruptFunc], a                               ; $0cf5

; check our opposite state and opponent's state
    ldh  a, [hOppositeSerialByteToWinningLosingState]            ; $0cf7
    cp   SB_LEVEL_WON                                            ; $0cf9
    jr   nz, .notLost                                            ; $0cfb

; jump if opponent did not lose
    ldh  a, [hSerialByteRead]                                    ; $0cfd
    cp   SB_LEVEL_LOST                                           ; $0cff
    jr   nz, .cont                                               ; $0d01

.tie:
; set that we tied
    ld   a, $01                                                  ; $0d03
    ldh  [hWonOrLostAtTheSameTimeAsOtherPlayer], a               ; $0d05
    jr   .cont                                                   ; $0d07

.notLost:
    cp   SB_LEVEL_LOST                                           ; $0d09
    jr   nz, .cont                                               ; $0d0b

; jump if our opponent won
    ldh  a, [hSerialByteRead]                                    ; $0d0d
    cp   SB_LEVEL_WON                                            ; $0d0f
    jr   z, .tie                                                 ; $0d11

.cont:
; wait until both players in this post-game state
    ld   b, $34                                                  ; $0d13
    ld   c, $43                                                  ; $0d15
    call ReturnFromCallersContextUntilBothPlayersCommunicatingBC ; $0d17

; no shifting down state
    lda ROWS_SHIFTING_DOWN_NONE                                  ; $0d1a
    ldh  [hRowsShiftingDownState], a                             ; $0d1b

; go to loser state if we lost, winner if we won
    ldh  a, [hOppositeSerialByteToWinningLosingState]            ; $0d1d
    cp   SB_LEVEL_LOST                                           ; $0d1f
    ld   a, GS_2_PLAYER_LOSER_INIT                               ; $0d21
    jr   nz, .setGameState                                       ; $0d23

    ld   a, GS_2_PLAYER_WINNER_INIT                              ; $0d25

.setGameState:
    ldh  [hGameState], a                                         ; $0d27

; set timer, and
    ld   a, $28                                                  ; $0d29
    ldh  [hTimer1], a                                            ; $0d2b
    ld   a, $1d                                                  ; $0d2d
    ldh  [h5GamesFinishedTimer], a                               ; $0d2f
    ret                                                          ; $0d31


GameState1d_2PlayerWinnerInit:
; proceed when timer done
    ldh  a, [hTimer1]                                            ; $0d32
    and  a                                                       ; $0d34
    ret  nz                                                      ; $0d35

; if a tie, dont change score
    ldh  a, [hWonOrLostAtTheSameTimeAsOtherPlayer]               ; $0d36
    and  a                                                       ; $0d38
    jr   nz, .cont                                               ; $0d39

; inc winning games
    ldh  a, [hNumWinningGames]                                   ; $0d3b
    inc  a                                                       ; $0d3d
    ldh  [hNumWinningGames], a                                   ; $0d3e

.cont:
    call LoadWinnerLoserScreen                                   ; $0d40

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

; set timer
    ld   a, $19                                                  ; $0d57
    ldh  [hTimer1], a                                            ; $0d59

; if a tie, hide baby sprites
    ldh  a, [hWonOrLostAtTheSameTimeAsOtherPlayer]               ; $0d5b
    and  a                                                       ; $0d5d
    jr   z, .copyHappySprites                                    ; $0d5e

; hide baby mario/luigi
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF*2                      ; $0d60
    ld   [hl], SPRITE_SPEC_HIDDEN                                ; $0d63

.copyHappySprites:
    ld   a, $03                                                  ; $0d65
    call CopyASpriteSpecsToShadowOam                             ; $0d67

; go to main state and play game done song
    ld   a, GS_2_PLAYER_WINNER_MAIN                              ; $0d6a
    ldh  [hGameState], a                                         ; $0d6c
    ld   a, MUS_MULTIPLAYER_GAME_FINISHED                        ; $0d6e
    ld   [wSongToStart], a                                       ; $0d70

; if now won 5 games, play a special song
    ldh  a, [hNumWinningGames]                                   ; $0d73
    cp   $05                                                     ; $0d75
    ret  nz                                                      ; $0d77

    ld   a, MUS_MULTIPLAYER_GAMES_FINISHED                       ; $0d78
    ld   [wSongToStart], a                                       ; $0d7a
    ret                                                          ; $0d7d


WinnerMainIsMaster:
    ldh  a, [hNumWinningGames]                                   ; $0d7e
    cp   $05                                                     ; $0d80
    jr   nz, .notWonAll5                                         ; $0d82

; won 5 games
    ldh  a, [h5GamesFinishedTimer]                               ; $0d84
    and  a                                                       ; $0d86
    jr   z, .toNextState                                         ; $0d87

    jr   GameState20_2PlayerWinnerMain.end                       ; $0d89

.notWonAll5:
    ldh  a, [hButtonsPressed]                                    ; $0d8b
    bit  PADB_START, a                                           ; $0d8d
    jr   z, GameState20_2PlayerWinnerMain.end                    ; $0d8f

.toNextState:
; go to next state and send that to passive
    ld   a, SB_WINNER_LOSER_SCREEN_TO_NEXT                       ; $0d91
    ldh  [hNextSerialByteToLoad], a                              ; $0d93
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0d95
    jr   GoPastWinnerGameStates                                  ; $0d97


GameState20_2PlayerWinnerMain:
; no serial
    ld   a, IEF_VBLANK                                           ; $0d99
    ldh  [rIE], a                                                ; $0d9b

    ldh  a, [hSerialInterruptHandled]                            ; $0d9d
    jr   z, .end                                                 ; $0d9f

; jump if master
    ldh  a, [hMultiplayerPlayerRole]                             ; $0da1
    cp   MP_ROLE_MASTER                                          ; $0da3
    jr   z, WinnerMainIsMaster                                   ; $0da5

; if passive, go next state if master had gone
    ldh  a, [hSerialByteRead]                                    ; $0da7
    cp   SB_WINNER_LOSER_SCREEN_TO_NEXT                          ; $0da9
    jr   z, GoPastWinnerGameStates                               ; $0dab

.end:
    call ProcessWinnerMainTimer                                  ; $0dad

; send mario/luigi sprites
    ld   a, $03                                                  ; $0db0
    call CopyASpriteSpecsToShadowOam                             ; $0db2
    ret                                                          ; $0db5


GoPastWinnerGameStates:
    ld   a, GS_POST_2_PLAYER_RESULTS                             ; $0db6
    ldh  [hGameState], a                                         ; $0db8
    ldh  [hSerialInterruptHandled], a                            ; $0dba
    ret                                                          ; $0dbc


ProcessWinnerMainTimer:
    ldh  a, [hTimer1]                                            ; $0dbd
    and  a                                                       ; $0dbf
    jr   nz, .afterTimerCheck                                    ; $0dc0

; main timer done
    ld   hl, h5GamesFinishedTimer                                ; $0dc2
    dec  [hl]                                                    ; $0dc5

; animate adult every $19 frames, and clear text
    ld   a, $19                                                  ; $0dc6
    ldh  [hTimer1], a                                            ; $0dc8
    call ClearPushStartText                                      ; $0dca

; y to jump up high and down
    ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $0dcd
    ld   a, [hl]                                                 ; $0dd0
    xor  $30                                                     ; $0dd1
    ld   [hl+], a                                                ; $0dd3
    cp   $60                                                     ; $0dd4
    call z, DisplayTextPushStart                                 ; $0dd6

; animate adult, flipping both spec idxes
    inc  l                                                       ; $0dd9
    push af                                                      ; $0dda
    ld   a, [hl]                                                 ; $0ddb
    xor  $01                                                     ; $0ddc
    ld   [hl], a                                                 ; $0dde
    ld   l, SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx                     ; $0ddf
    ld   [hl-], a                                                ; $0de1

; set y of 2nd adult sprite
    pop  af                                                      ; $0de2
    dec  l                                                       ; $0de3
    ld   [hl], a                                                 ; $0de4

.afterTimerCheck:
; timer=7, fall 2 pixels
; timer=6, hide
    ldh  a, [hNumWinningGames]                                   ; $0de5
    cp   $05                                                     ; $0de7
    jr   nz, .end                                                ; $0de9

; won 5 games
    ldh  a, [h5GamesFinishedTimer]                               ; $0deb
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF*2+SPR_SPEC_BaseYOffset ; $0ded

; last step, baby is hidden
    cp   $06                                                     ; $0df0
    jr   z, .hideBabySprite                                      ; $0df2

    cp   $08                                                     ; $0df4
    jr   nc, .end                                                ; $0df6

; 0-5, or 7
    ld   a, [hl]                                                 ; $0df8
    cp   $72                                                     ; $0df9
    jr   nc, .turnBabyToSmallGas                                 ; $0dfb

; if small gas (y >= $72), return, otherwise y+= 2
    cp   $69                                                     ; $0dfd
    ret  z                                                       ; $0dff

    inc  [hl]                                                    ; $0e00
    inc  [hl]                                                    ; $0e01
    ret                                                          ; $0e02

.turnBabyToSmallGas:
; Y = $69 (1 pixel down), spec is baby gas
    ld   [hl], $69                                               ; $0e03
    inc  l                                                       ; $0e05
    inc  l                                                       ; $0e06
    ld   [hl], SPRITE_SPEC_BABY_GAS                              ; $0e07
    ld   a, SND_NON_4_LINES_CLEARED                              ; $0e09
    ld   [wSquareSoundToPlay], a                                 ; $0e0b
    ret                                                          ; $0e0e

.hideBabySprite:
    dec  l                                                       ; $0e0f
    ld   [hl], SPRITE_SPEC_HIDDEN                                ; $0e10
    ret                                                          ; $0e12

.end:
; reset timer ever 15 frames
    ldh  a, [hTimer2]                                            ; $0e13
    and  a                                                       ; $0e15
    ret  nz                                                      ; $0e16

    ld   a, $0f                                                  ; $0e17
    ldh  [hTimer2], a                                            ; $0e19

; animate baby sprite
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF*2+SPR_SPEC_SpecIdx     ; $0e1b
    ld   a, [hl]                                                 ; $0e1e
    xor  $01                                                     ; $0e1f
    ld   [hl], a                                                 ; $0e21
    ret                                                          ; $0e22


GameState1e_2PlayerLoserInit:
; proceed when timer done
    ldh  a, [hTimer1]                                            ; $0e23
    and  a                                                       ; $0e25
    ret  nz                                                      ; $0e26

; if lost at the same time, dont change score
    ldh  a, [hWonOrLostAtTheSameTimeAsOtherPlayer]               ; $0e27
    and  a                                                       ; $0e29
    jr   nz, .cont                                               ; $0e2a

; inc losing games
    ldh  a, [hNumLosingGames]                                    ; $0e2c
    inc  a                                                       ; $0e2e
    ldh  [hNumLosingGames], a                                    ; $0e2f

.cont:
    call LoadWinnerLoserScreen                                   ; $0e31

; load sad sprites for player
    ld   de, SpriteSpecStruct_MariosFacingAway                   ; $0e34
    ldh  a, [hMultiplayerPlayerRole]                             ; $0e37
    cp   MP_ROLE_MASTER                                          ; $0e39
    jr   z, .loadSadSprites                                      ; $0e3b

    ld   de, SpriteSpecStruct_LuigisFacingAway                   ; $0e3d

.loadSadSprites:
    ld   hl, wSpriteSpecs                                        ; $0e40
    ld   c, $02                                                  ; $0e43
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $0e45

; set timer
    ld   a, $19                                                  ; $0e48
    ldh  [hTimer1], a                                            ; $0e4a

; if no one won, hide baby sprites
    ldh  a, [hWonOrLostAtTheSameTimeAsOtherPlayer]               ; $0e4c
    and  a                                                       ; $0e4e
    jr   z, .copySadSprites                                      ; $0e4f

; hide baby mario/luigi
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF                        ; $0e51
    ld   [hl], SPRITE_SPEC_HIDDEN                                ; $0e54

.copySadSprites:
    ld   a, $02                                                  ; $0e56
    call CopyASpriteSpecsToShadowOam                             ; $0e58

; go to main state, and play game done song
    ld   a, GS_2_PLAYER_LOSER_MAIN                               ; $0e5b
    ldh  [hGameState], a                                         ; $0e5d
    ld   a, MUS_MULTIPLAYER_GAME_FINISHED                        ; $0e5f
    ld   [wSongToStart], a                                       ; $0e61

; if now lost 5 games, play a different song
    ldh  a, [hNumLosingGames]                                    ; $0e64
    cp   $05                                                     ; $0e66
    ret  nz                                                      ; $0e68

    ld   a, MUS_MULTIPLAYER_GAMES_FINISHED                       ; $0e69
    ld   [wSongToStart], a                                       ; $0e6b
    ret                                                          ; $0e6e


LoserMainIsMaster:
    ldh  a, [hNumLosingGames]                                    ; $0e6f
    cp   $05                                                     ; $0e71
    jr   nz, .notLost5                                           ; $0e73

; lost 5
    ldh  a, [h5GamesFinishedTimer]                               ; $0e75
    and  a                                                       ; $0e77
    jr   z, .toNextState                                         ; $0e78

    jr   GameState21_2PlayerLoserMain.end                        ; $0e7a

.notLost5:
    ldh  a, [hButtonsPressed]                                    ; $0e7c
    bit  PADB_START, a                                           ; $0e7e
    jr   z, GameState21_2PlayerLoserMain.end                     ; $0e80

.toNextState:
; go to next state and send that to passive
    ld   a, SB_WINNER_LOSER_SCREEN_TO_NEXT                       ; $0e82
    ldh  [hNextSerialByteToLoad], a                              ; $0e84
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0e86
    jr   GoPastLoserGameStates                                   ; $0e88


GameState21_2PlayerLoserMain:
; no serial interrupt
    ld   a, IEF_VBLANK                                           ; $0e8a
    ldh  [rIE], a                                                ; $0e8c

    ldh  a, [hSerialInterruptHandled]                            ; $0e8e
    jr   z, .end                                                 ; $0e90

; jump if master
    ldh  a, [hMultiplayerPlayerRole]                             ; $0e92
    cp   MP_ROLE_MASTER                                          ; $0e94
    jr   z, LoserMainIsMaster                                    ; $0e96

; if passive, go next state if master had gone
    ldh  a, [hSerialByteRead]                                    ; $0e98
    cp   SB_WINNER_LOSER_SCREEN_TO_NEXT                          ; $0e9a
    jr   z, GoPastLoserGameStates                                ; $0e9c

.end:
    call ProcessLoserMainTimer                                   ; $0e9e

; send mario/luigi sprites
    ld   a, $02                                                  ; $0ea1
    call CopyASpriteSpecsToShadowOam                             ; $0ea3
    ret                                                          ; $0ea6


GoPastLoserGameStates:
    ld   a, GS_POST_2_PLAYER_RESULTS                             ; $0ea7
    ldh  [hGameState], a                                         ; $0ea9
    ldh  [hSerialInterruptHandled], a                            ; $0eab
    ret                                                          ; $0ead


ProcessLoserMainTimer:
    ldh  a, [hTimer1]                                            ; $0eae
    and  a                                                       ; $0eb0
    jr   nz, .afterTimerCheck                                    ; $0eb1

; main timer done
    ld   hl, h5GamesFinishedTimer                                ; $0eb3
    dec  [hl]                                                    ; $0eb6

; animate baby every $19 frames, and clear text
    ld   a, $19                                                  ; $0eb7
    ldh  [hTimer1], a                                            ; $0eb9
    call ClearPushStartText                                      ; $0ebb

; y to jump up and down
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset   ; $0ebe
    ld   a, [hl]                                                 ; $0ec1
    xor  $08                                                     ; $0ec2
    ld   [hl+], a                                                ; $0ec4
    cp   $68                                                     ; $0ec5
    call z, DisplayTextPushStart                                 ; $0ec7

; animate baby
    inc  l                                                       ; $0eca
    ld   a, [hl]                                                 ; $0ecb
    xor  $01                                                     ; $0ecc
    ld   [hl], a                                                 ; $0ece

.afterTimerCheck:
; timer=7, fall 4 pixels
; timer=6, turn to gas
; timer=5, hide
    ldh  a, [hNumLosingGames]                                    ; $0ecf
    cp   $05                                                     ; $0ed1
    jr   nz, .end                                                ; $0ed3

; lost 5 games
    ldh  a, [h5GamesFinishedTimer]                               ; $0ed5
    ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $0ed7

; last step, adult is hidden
    cp   $05                                                     ; $0eda
    jr   z, .hideAdultSprite                                     ; $0edc

; 2nd last step, adult is turned to gas
    cp   $06                                                     ; $0ede
    jr   z, .turnAdultToBigGas                                   ; $0ee0

; 0-4, or 7, proceed
    cp   $08                                                     ; $0ee2
    jr   nc, .end                                                ; $0ee4

; player falls over time, past a certain point, it's then hidden
    ld   a, [hl]                                                 ; $0ee6
    cp   $72                                                     ; $0ee7
    jr   nc, .hideAdultSprite                                    ; $0ee9

; if big gas (step 6), (0-4) return, ie player falls when timer = 7
    cp   $61                                                     ; $0eeb
    ret  z                                                       ; $0eed

    inc  [hl]                                                    ; $0eee
    inc  [hl]                                                    ; $0eef
    inc  [hl]                                                    ; $0ef0
    inc  [hl]                                                    ; $0ef1
    ret                                                          ; $0ef2

.turnAdultToBigGas:
; visible, with Y of $61 and turned to gas
    dec  l                                                       ; $0ef3
    ld   [hl], $00                                               ; $0ef4
    inc  l                                                       ; $0ef6
    ld   [hl], $61                                               ; $0ef7
    inc  l                                                       ; $0ef9
    inc  l                                                       ; $0efa
    ld   [hl], SPRITE_SPEC_ADULT_GAS                             ; $0efb
    ld   a, SND_NON_4_LINES_CLEARED                              ; $0efd
    ld   [wSquareSoundToPlay], a                                 ; $0eff
    ret                                                          ; $0f02

.hideAdultSprite:
    dec  l                                                       ; $0f03
    ld   [hl], SPRITE_SPEC_HIDDEN                                ; $0f04
    ret                                                          ; $0f06

.end:
; reset timer ever 15 frames
    ldh  a, [hTimer2]                                            ; $0f07
    and  a                                                       ; $0f09
    ret  nz                                                      ; $0f0a

    ld   a, $0f                                                  ; $0f0b
    ldh  [hTimer2], a                                            ; $0f0d

; animate adult sprite
    ld   hl, wSpriteSpecs+SPR_SPEC_SpecIdx                       ; $0f0f
    ld   a, [hl]                                                 ; $0f12
    xor  $01                                                     ; $0f13
    ld   [hl], a                                                 ; $0f15
    ret                                                          ; $0f16


    setcharmap congrats

DisplayTextPushStart:
    push af                                                      ; $0f17
    push hl                                                      ; $0f18

; text not relevant if won/lost 5
    ldh  a, [hNumWinningGames]                                   ; $0f19
    cp   $05                                                     ; $0f1b
    jr   z, .done                                                ; $0f1d

    ldh  a, [hNumLosingGames]                                    ; $0f1f
    cp   $05                                                     ; $0f21
    jr   z, .done                                                ; $0f23

; master - display PUSH START
    ldh  a, [hMultiplayerPlayerRole]                             ; $0f25
    cp   MP_ROLE_MASTER                                          ; $0f27
    jr   nz, .done                                               ; $0f29

    ld   hl, wOam+OAM_SIZEOF*$18                                 ; $0f2b
    ld   b, $24                                                  ; $0f2e
    ld   de, .sprites                                            ; $0f30

.loop:
    ld   a, [de]                                                 ; $0f33
    ld   [hl+], a                                                ; $0f34
    inc  de                                                      ; $0f35
    dec  b                                                       ; $0f36
    jr   nz, .loop                                               ; $0f37

.done:
    pop  hl                                                      ; $0f39
    pop  af                                                      ; $0f3a
    ret                                                          ; $0f3b

.sprites:
    db $42, $30, "P", $00
	db $42, $38, "U", $00
	db $42, $40, "S", $00
	db $42, $48, "H", $00

	db $42, $58, "S", $00
	db $42, $60, "T", $00
	db $42, $68, "A", $00
	db $42, $70, "R", $00
	db $42, $78, "T", $00


ClearPushStartText:
    ld   hl, wOam+OAM_SIZEOF*$18                                 ; $0f60
    ld   de, $0004                                               ; $0f63
    ld   b, $09                                                  ; $0f66
    xor  a                                                       ; $0f68

.loop:
    ld   [hl], a                                                 ; $0f69
    add  hl, de                                                  ; $0f6a
    dec  b                                                       ; $0f6b
    jr   nz, .loop                                               ; $0f6c

    ret                                                          ; $0f6e


LoadWinnerLoserScreen:
; load gfx with LCD off
    call TurnOffLCD                                              ; $0f6f
    ld   hl, Gfx_RocketScene                                     ; $0f72
    ld   bc, Gfx_RocketScene.end-Gfx_RocketScene+$300            ; $0f75
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

.afterBGdisplay:
; process deuce and advantage logic if not a tie
    ldh  a, [hWonOrLostAtTheSameTimeAsOtherPlayer]               ; $0fb9
    and  a                                                       ; $0fbb
    jr   nz, .afterDeuceAdvantageLogic                           ; $0fbc

    call ProcessDeuceAdvantageLogic                              ; $0fbe

.afterDeuceAdvantageLogic:
; skip below, eg drawing faces, if score = 0
    ldh  a, [hNumWinningGames]                                   ; $0fc1
    and  a                                                       ; $0fc3
    jr   z, .checkLosingGames                                    ; $0fc4

; if score of 5 (4 after deuce)..
    cp   $05                                                     ; $0fc6
    jr   nz, .afterWinningText                                   ; $0fc8

; draw text based on role
    ld   hl, _SCRN0+$a5                                          ; $0fca
    ld   b, $0b                                                  ; $0fcd
    ldh  a, [hMultiplayerPlayerRole]                             ; $0fcf
    cp   MP_ROLE_MASTER                                          ; $0fd1
    ld   de, TextMarioWins                                       ; $0fd3
    jr   z, .drawWinnerText                                      ; $0fd6

    ld   de, TextLuigiWins                                       ; $0fd8

.drawWinnerText:
    call CopyAndUnderlineTextDEtoHL_Bbytes                       ; $0fdb

; true score in A, then C below
    ld   a, $04                                                  ; $0fde

.afterWinningText:
; non-0 score here
    ld   c, a                                                    ; $0fe0

; draw faces based on if winner/loser
    ldh  a, [hMultiplayerPlayerRole]                             ; $0fe1
    cp   MP_ROLE_MASTER                                          ; $0fe3
    ld   a, TILE_LUIGI_FACE_TOP_LEFT                             ; $0fe5
    jr   nz, .drawFaces                                          ; $0fe7

    ld   a, TILE_MARIO_FACE_TOP_LEFT                             ; $0fe9

.drawFaces:
    ldh  [hMarioLuigiFaceTopLeftTileIdx], a                      ; $0feb
    ld   hl, _SCRN0+$1e7                                         ; $0fed
    call DrawCfaces                                              ; $0ff0

; if we are advantage..
    ldh  a, [hSelfIsAdvantage]                                   ; $0ff3
    and  a                                                       ; $0ff5
    jr   z, .checkLosingGames                                    ; $0ff6

; draw A
    ld   a, TILE_ADVANTAGE_FACE_TOP_LEFT                         ; $0ff8
    ldh  [hMarioLuigiFaceTopLeftTileIdx], a                      ; $0ffa
    ld   hl, _SCRN0+$1f0                                         ; $0ffc
    ld   c, $01                                                  ; $0fff
    call DrawCfaces                                              ; $1001

; draw advantage text too
    ld   hl, _SCRN0+$a6                                          ; $1004
    ld   de, TextAdvantage                                       ; $1007
    ld   b, $09                                                  ; $100a
    call CopyAndUnderlineTextDEtoHL_Bbytes                       ; $100c

.checkLosingGames:
; skip below, eg drawing faces, if losing score = 0
    ldh  a, [hNumLosingGames]                                    ; $100f
    and  a                                                       ; $1011
    jr   z, .afterWinningLosingGfx                               ; $1012

; if score of 5 (4 after deuce)..
    cp   $05                                                     ; $1014
    jr   nz, .afterLosingText                                    ; $1016

; draw text based on role
    ld   hl, _SCRN0+$a5                                          ; $1018
    ld   b, $0b                                                  ; $101b
    ldh  a, [hMultiplayerPlayerRole]                             ; $101d
    cp   MP_ROLE_MASTER                                          ; $101f
    ld   de, TextLuigiWins                                       ; $1021
    jr   z, .drawLoserText                                       ; $1024

    ld   de, TextMarioWins                                       ; $1026

.drawLoserText:
    call CopyAndUnderlineTextDEtoHL_Bbytes                       ; $1029

; true score in A, then C below
    ld   a, $04                                                  ; $102c

.afterLosingText:
; non-0 score here
    ld   c, a                                                    ; $102e

; draw faces based on if winner/loser
    ldh  a, [hMultiplayerPlayerRole]                             ; $102f
    cp   MP_ROLE_MASTER                                          ; $1031
    ld   a, TILE_MARIO_FACE_TOP_LEFT                             ; $1033
    jr   nz, .drawFaces2                                         ; $1035

    ld   a, TILE_LUIGI_FACE_TOP_LEFT                             ; $1037

.drawFaces2:
    ldh  [hNumCompletedTetrisRows], a                            ; $1039
    ld   hl, _SCRN0+$27                                          ; $103b
    call DrawCfaces                                              ; $103e

; if other player is advantage..
    ldh  a, [hOtherIsAdvantage]                                  ; $1041
    and  a                                                       ; $1043
    jr   z, .afterWinningLosingGfx                               ; $1044

; draw A
    ld   a, TILE_ADVANTAGE_FACE_TOP_LEFT                         ; $1046
    ldh  [hNumCompletedTetrisRows], a                            ; $1048
    ld   hl, _SCRN0+$30                                          ; $104a
    ld   c, $01                                                  ; $104d
    call DrawCfaces                                              ; $104f

.afterWinningLosingGfx:
    ldh  a, [hIsDeuce]                                           ; $1052
    and  a                                                       ; $1054
    jr   z, .turnOnLCDandClearOam                                ; $1055

    ld   hl, $98a7                                               ; $1057
    ld   de, TextDeuce                                           ; $105a
    ld   b, $06                                                  ; $105d
    call CopyAndUnderlineTextDEtoHL_Bbytes                       ; $105f

.turnOnLCDandClearOam:
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $1062
    ldh  [rLCDC], a                                              ; $1064
    call Clear_wOam                                              ; $1066
    ret                                                          ; $1069


; in: C - how many faces to draw
; faces are sequential in tilemap
DrawCfaces:
.nextFace:
    ldh  a, [hMarioLuigiFaceTopLeftTileIdx]                      ; $106a
    push hl                                                      ; $106c
    ld   de, GB_TILE_WIDTH                                       ; $106d

; loop per row
    ld   b, $02                                                  ; $1070

.nextRow:
; draw 2 tiles for column
    push hl                                                      ; $1072
    ld   [hl+], a                                                ; $1073
    inc  a                                                       ; $1074
    ld   [hl], a                                                 ; $1075
    inc  a                                                       ; $1076
    pop  hl                                                      ; $1077
    add  hl, de                                                  ; $1078
    dec  b                                                       ; $1079
    jr   nz, .nextRow                                            ; $107a

; 1 space between faces
    pop  hl                                                      ; $107c
    ld   de, $0003                                               ; $107d
    add  hl, de                                                  ; $1080
    dec  c                                                       ; $1081
    jr   nz, .nextFace                                           ; $1082

    ret                                                          ; $1084


ProcessDeuceAdvantageLogic:
    ld   hl, hNumWinningGames                                    ; $1085
    ld   de, hNumLosingGames                                     ; $1088

; check special cases
    ldh  a, [hSelfIsAdvantage]                                   ; $108b
    and  a                                                       ; $108d
    jr   nz, .wasSelfAdvantage                                   ; $108e

    ldh  a, [hOtherIsAdvantage]                                  ; $1090
    and  a                                                       ; $1092
    jr   nz, .wasOtherAdvantage                                  ; $1093

    ldh  a, [hIsDeuce]                                           ; $1095
    and  a                                                       ; $1097
    jr   nz, .wasDeuce                                           ; $1098

; if none of the other special cases, check if won/lost 4
    ld   a, [hl]                                                 ; $109a
    cp   $04                                                     ; $109b
    jr   z, .won4                                                ; $109d

    ld   a, [de]                                                 ; $109f
    cp   $04                                                     ; $10a0
    ret  nz                                                      ; $10a2

; lost 4
.setLostScoreTo5:
    ld   a, $05                                                  ; $10a3
    ld   [de], a                                                 ; $10a5
    jr   .clearDeuceAndAdvantages                                ; $10a6

; unused - if lost 3, clear advantages?
    ld   a, [de]                                                 ; $10a8
    cp   $03                                                     ; $10a9
    ret  nz                                                      ; $10ab

.thunkClearAdvantages:
; ld has no effect (xor a done after)
    ld   a, $03                                                  ; $10ac
    jr   .clearAdvantages                                        ; $10ae

.won4:
    ld   [hl], $05                                               ; $10b0

.clearDeuceAndAdvantages:
    xor  a                                                       ; $10b2
    ldh  [hIsDeuce], a                                           ; $10b3

.clearAdvantages:
    xor  a                                                       ; $10b5
    ldh  [hSelfIsAdvantage], a                                   ; $10b6
    ldh  [hOtherIsAdvantage], a                                  ; $10b8
    ret                                                          ; $10ba

.wasDeuce:
; if was deuce, but we've now won 4..
    ld   a, [hl]                                                 ; $10bb
    cp   $04                                                     ; $10bc
    jr   nz, .clearDeuceSetOtherAdvantage                        ; $10be

; set is advantage, and clear deuce..
    ldh  [hSelfIsAdvantage], a                                   ; $10c0

.clearDeuce:
    xor  a                                                       ; $10c2
    ldh  [hIsDeuce], a                                           ; $10c3
    ret                                                          ; $10c5

; otherwise it was other player's advantage
.clearDeuceSetOtherAdvantage:
    ldh  [hOtherIsAdvantage], a                                  ; $10c6
    jr   .clearDeuce                                             ; $10c8

.wasSelfAdvantage:
; if won an extra point, allow score of 5
    ld   a, [hl]                                                 ; $10ca
    cp   $05                                                     ; $10cb
    jr   z, .won4                                                ; $10cd

    jr   .thunkClearAdvantages                                   ; $10cf

.wasOtherAdvantage:
; if lost an extra point, allow losing score of 5
    ld   a, [de]                                                 ; $10d1
    cp   $05                                                     ; $10d2
    jr   z, .setLostScoreTo5                                     ; $10d4

    jr   .thunkClearAdvantages                                   ; $10d6


CopyAndUnderlineTextDEtoHL_Bbytes:
    push bc                                                      ; $10d8
    push hl                                                      ; $10d9

; copy DE to HL B bytes
.copyText:
    ld   a, [de]                                                 ; $10da
    ld   [hl+], a                                                ; $10db
    inc  de                                                      ; $10dc
    dec  b                                                       ; $10dd
    jr   nz, .copyText                                           ; $10de

; to next row
    pop  hl                                                      ; $10e0
    ld   de, GB_TILE_WIDTH                                       ; $10e1
    add  hl, de                                                  ; $10e4
    pop  bc                                                      ; $10e5
    ld   a, "_"                                                  ; $10e6

; underline text same B bytes
.underlineText:
    ld   [hl+], a                                                ; $10e8
    dec  b                                                       ; $10e9
    jr   nz, .underlineText                                      ; $10ea

    ret                                                          ; $10ec


TextDeuce:
    db "DEUCE!"
    
    
TextMarioWins:
    db "MARIO WINS!"


TextLuigiWins:
    db "LUIGI WINS!"
    

TextAdvantage:
    db "ADVANTAGE"

    setcharmap new


GameState1f_Post2PlayerResults:
; no serial
    ld   a, IEF_VBLANK                                           ; $1112
    ldh  [rIE], a                                                ; $1114

; proceed when timer is 0
    ldh  a, [hTimer1]                                            ; $1116
    and  a                                                       ; $1118
    ret  nz                                                      ; $1119

; clear oam and that a tie happened
    call Clear_wOam                                              ; $111a
    xor  a                                                       ; $111d
    ldh  [hWonOrLostAtTheSameTimeAsOtherPlayer], a               ; $111e

; dont proceed until both players in this state
    ld   b, $27                                                  ; $1120
    ld   c, $79                                                  ; $1122
    call ReturnFromCallersContextUntilBothPlayersCommunicatingBC ; $1124

    call ThunkInitSound                                          ; $1127

; once we've won or lost 5 games, the round is done
    ldh  a, [hNumWinningGames]                                   ; $112a
    cp   $05                                                     ; $112c
    jr   z, .winnerOfRoundsChosen                                ; $112e

    ldh  a, [hNumLosingGames]                                    ; $1130
    cp   $05                                                     ; $1132
    jr   z, .winnerOfRoundsChosen                                ; $1134

; set game finished so we can jump back into it soon
    ld   a, $01                                                  ; $1136
    ldh  [h2PlayerGameFinished], a                               ; $1138

.winnerOfRoundsChosen:
    ld   a, GS_MARIO_LUIGI_SCREEN_INIT                           ; $113a
    ldh  [hGameState], a                                         ; $113c
    ret                                                          ; $113e


; in: B - byte passive sends when hasn't received master's C
; in: C - byte master sends when master has seen passive's B
; pop hl is done for a player if it hasn't read the other player's b/c
ReturnFromCallersContextUntilBothPlayersCommunicatingBC:
; done if no interrupt handled
    ldh  a, [hSerialInterruptHandled]                            ; $113f
    and  a                                                       ; $1141
    jr   z, .done                                                ; $1142

    xor  a                                                       ; $1144
    ldh  [hSerialInterruptHandled], a                            ; $1145

; if master, ..
    ldh  a, [hMultiplayerPlayerRole]                             ; $1147
    cp   MP_ROLE_MASTER                                          ; $1149
    ldh  a, [hSerialByteRead]                                    ; $114b
    jr   nz, .passive                                            ; $114d

; if loaded byte is B (when passive hasn't read our C), send C
    cp   b                                                       ; $114f
    jr   z, .masterSendC                                         ; $1150

; else send 2 and return from caller's loop
    ld   a, $02                                                  ; $1152
    ldh  [hNextSerialByteToLoad], a                              ; $1154
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $1156

.done:
    pop  hl                                                      ; $1158
    ret                                                          ; $1159

.masterSendC:
    ld   a, c                                                    ; $115a
    ldh  [hNextSerialByteToLoad], a                              ; $115b
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $115d
    ret                                                          ; $115f

.passive:
; if passive and byte read is C (from master's send above), return
    cp   c                                                       ; $1160
    ret  z                                                       ; $1161

; else send B, eg if its 2, due to master not receiving our B yet
; and return from caller's loop
    ld   a, b                                                    ; $1162
    ldh  [hNextSerialByteToLoad], a                              ; $1163
    pop  hl                                                      ; $1165
    ret                                                          ; $1166
