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
    ld   hl, $c400                                   ; $06c1: $21 $00 $c4
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
    cp   $05                                         ; $0b02: $fe $05
    ret  nz                                          ; $0b04: $c0

; now at 5th row being loaded,
    ld   hl, wOam+OAM_SIZEOF*12                                   ; $0b05: $21 $30 $c0
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

;
    ld   a, [$c3ff]                                  ; $0b19: $fa $ff $c3

jr_000_0b1c:
    ld   b, $0a                                      ; $0b1c: $06 $0a
    ld   hl, $c400                                   ; $0b1e: $21 $00 $c4

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
    ld   de, $c400                                   ; $0ccd: $11 $00 $c4
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
    call ReturnFromCallersContextUntilBothPlayersCommunicatingBC                               ; $0d17: $cd $3f $11
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
; proceed when timer done
    ldh  a, [hTimer1]                                            ; $0d32
    and  a                                                       ; $0d34
    ret  nz                                                      ; $0d35

;
    ldh  a, [$ef]                                    ; $0d36: $f0 $ef
    and  a                                           ; $0d38: $a7
    jr   nz, .cont_0d40                             ; $0d39: $20 $05

; inc winning games
    ldh  a, [hNumWinningGames]                                   ; $0d3b
    inc  a                                                       ; $0d3d
    ldh  [hNumWinningGames], a                                   ; $0d3e

.cont_0d40:
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

;
    ldh  a, [$ef]                                    ; $0d5b: $f0 $ef
    and  a                                           ; $0d5d: $a7
    jr   z, .copyHappySprites                              ; $0d5e: $28 $05

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
    ldh  a, [hNumWinningGames]                                    ; $0d7e: $f0 $d7
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
; go to next state and send that to passive
    ld   a, SB_WINNER_LOSER_SCREEN_TO_NEXT                       ; $0d91
    ldh  [hNextSerialByteToLoad], a                              ; $0d93
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0d95
    jr   GoPastWinnerGameStates                                  ; $0d97


GameState20_2PlayerWinnerMain:
; no serial
    ld   a, IEF_VBLANK                                      ; $0d99: $3e $01
    ldh  [rIE], a                                    ; $0d9b: $e0 $ff

    ldh  a, [hSerialInterruptHandled]                                    ; $0d9d: $f0 $cc
    jr   z, jr_000_0dad                              ; $0d9f: $28 $0c

; jump if master
    ldh  a, [hMultiplayerPlayerRole]                             ; $0da1
    cp   MP_ROLE_MASTER                                          ; $0da3
    jr   z, WinnerMainIsMaster                                   ; $0da5

; if passive, go next state if master had gone
    ldh  a, [hSerialByteRead]                                    ; $0da7
    cp   SB_WINNER_LOSER_SCREEN_TO_NEXT                          ; $0da9
    jr   z, GoPastWinnerGameStates                               ; $0dab

jr_000_0dad:
    call Call_000_0dbd                               ; $0dad: $cd $bd $0d
    ld   a, $03                                      ; $0db0: $3e $03
    call CopyASpriteSpecsToShadowOam                               ; $0db2: $cd $73 $26
    ret                                              ; $0db5: $c9


GoPastWinnerGameStates:
    ld   a, GS_POST_2_PLAYER_RESULTS                             ; $0db6
    ldh  [hGameState], a                                         ; $0db8
    ldh  [hSerialInterruptHandled], a                            ; $0dba
    ret                                                          ; $0dbc


Call_000_0dbd:
    ldh  a, [hTimer1]                                    ; $0dbd: $f0 $a6
    and  a                                           ; $0dbf: $a7
    jr   nz, jr_000_0de5                             ; $0dc0: $20 $23

    ld   hl, $ffc6                                   ; $0dc2: $21 $c6 $ff
    dec  [hl]                                        ; $0dc5: $35
    ld   a, $19                                      ; $0dc6: $3e $19
    ldh  [hTimer1], a                                    ; $0dc8: $e0 $a6
    call ClearPushStartText                               ; $0dca: $cd $60 $0f
    ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                                   ; $0dcd: $21 $01 $c2
    ld   a, [hl]                                     ; $0dd0: $7e
    xor  $30                                         ; $0dd1: $ee $30
    ld   [hl+], a                                    ; $0dd3: $22
    cp   $60                                         ; $0dd4: $fe $60
    call z, DisplayTextPushStart                            ; $0dd6: $cc $17 $0f
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
    ldh  a, [hNumWinningGames]                                    ; $0de5: $f0 $d7
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
; proceed when timer done
    ldh  a, [hTimer1]                                            ; $0e23
    and  a                                                       ; $0e25
    ret  nz                                                      ; $0e26

    ldh  a, [$ef]                                    ; $0e27: $f0 $ef
    and  a                                           ; $0e29: $a7
    jr   nz, .cont_0e31                             ; $0e2a: $20 $05

; inc losing games
    ldh  a, [hNumLosingGames]                                    ; $0e2c
    inc  a                                                       ; $0e2e
    ldh  [hNumLosingGames], a                                    ; $0e2f

.cont_0e31:
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

;
    ldh  a, [$ef]                                    ; $0e4c: $f0 $ef
    and  a                                           ; $0e4e: $a7
    jr   z, .copySadSprites                              ; $0e4f: $28 $05

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
    ldh  a, [hNumLosingGames]                                    ; $0e6f: $f0 $d8
    cp   $05                                         ; $0e71: $fe $05
    jr   nz, jr_000_0e7c                             ; $0e73: $20 $07

; lost 5
    ldh  a, [$c6]                                    ; $0e75: $f0 $c6
    and  a                                           ; $0e77: $a7
    jr   z, jr_000_0e82                              ; $0e78: $28 $08

    jr   jr_000_0e9e                                 ; $0e7a: $18 $22

jr_000_0e7c:
    ldh  a, [hButtonsPressed]                                    ; $0e7c: $f0 $81
    bit  PADB_START, a                                        ; $0e7e: $cb $5f
    jr   z, jr_000_0e9e                              ; $0e80: $28 $1c

jr_000_0e82:
; go to next state and send that to passive
    ld   a, SB_WINNER_LOSER_SCREEN_TO_NEXT                       ; $0e82
    ldh  [hNextSerialByteToLoad], a                              ; $0e84
    ldh  [hMasterShouldSerialTransferInVBlank], a                ; $0e86
    jr   GoPastLoserGameStates                                   ; $0e88


GameState21_2PlayerLoserMain:
; no serial interrupt
    ld   a, IEF_VBLANK                                      ; $0e8a: $3e $01
    ldh  [rIE], a                                    ; $0e8c: $e0 $ff

    ldh  a, [hSerialInterruptHandled]                                    ; $0e8e: $f0 $cc
    jr   z, jr_000_0e9e                              ; $0e90: $28 $0c

; jump if master
    ldh  a, [hMultiplayerPlayerRole]                             ; $0e92
    cp   MP_ROLE_MASTER                                          ; $0e94
    jr   z, LoserMainIsMaster                                    ; $0e96

; if passive, go next state if master had gone
    ldh  a, [hSerialByteRead]                                    ; $0e98
    cp   SB_WINNER_LOSER_SCREEN_TO_NEXT                          ; $0e9a
    jr   z, GoPastLoserGameStates                                ; $0e9c

jr_000_0e9e:
    call Call_000_0eae                               ; $0e9e: $cd $ae $0e
    ld   a, $02                                      ; $0ea1: $3e $02
    call CopyASpriteSpecsToShadowOam                               ; $0ea3: $cd $73 $26
    ret                                              ; $0ea6: $c9


GoPastLoserGameStates:
    ld   a, GS_POST_2_PLAYER_RESULTS                             ; $0ea7
    ldh  [hGameState], a                                         ; $0ea9
    ldh  [hSerialInterruptHandled], a                            ; $0eab
    ret                                                          ; $0ead


Call_000_0eae:
    ldh  a, [hTimer1]                                    ; $0eae: $f0 $a6
    and  a                                           ; $0eb0: $a7
    jr   nz, jr_000_0ecf                             ; $0eb1: $20 $1c

    ld   hl, $ffc6                                   ; $0eb3: $21 $c6 $ff
    dec  [hl]                                        ; $0eb6: $35

    ld   a, $19                                      ; $0eb7: $3e $19
    ldh  [hTimer1], a                                    ; $0eb9: $e0 $a6

    call ClearPushStartText                               ; $0ebb: $cd $60 $0f
    ld   hl, $c211                                   ; $0ebe: $21 $11 $c2
    ld   a, [hl]                                     ; $0ec1: $7e
    xor  $08                                         ; $0ec2: $ee $08
    ld   [hl+], a                                    ; $0ec4: $22
    cp   $68                                         ; $0ec5: $fe $68
    call z, DisplayTextPushStart                            ; $0ec7: $cc $17 $0f
    inc  l                                           ; $0eca: $2c
    ld   a, [hl]                                     ; $0ecb: $7e
    xor  $01                                         ; $0ecc: $ee $01
    ld   [hl], a                                     ; $0ece: $77

jr_000_0ecf:
    ldh  a, [hNumLosingGames]                                    ; $0ecf: $f0 $d8
    cp   $05                                         ; $0ed1: $fe $05
    jr   nz, jr_000_0f07                             ; $0ed3: $20 $32

; lost 5 games
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


    setcharmap congrats

DisplayTextPushStart:
    push af                                          ; $0f17: $f5
    push hl                                          ; $0f18: $e5

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
    ldh  a, [$ef]                                    ; $0fb9: $f0 $ef
    and  a                                           ; $0fbb: $a7
    jr   nz, jr_000_0fc1                             ; $0fbc: $20 $03

    call ProcessDeuceAdvantageLogic                               ; $0fbe: $cd $85 $10

jr_000_0fc1:
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

;
    call Clear_wOam                                              ; $111a
    xor  a                                           ; $111d: $af
    ldh  [$ef], a                                    ; $111e: $e0 $ef

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
