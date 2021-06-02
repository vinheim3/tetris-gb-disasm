GameState08_GameMusicTypeInit:
; no serial interrupts from this point
    ld   a, IEF_VBLANK                                           ; $1444
    ldh  [rIE], a                                                ; $1446
    xor  a                                                       ; $1448
    ldh  [rSB], a                                                ; $1449
    ldh  [rSC], a                                                ; $144b
    ldh  [rIF], a                                                ; $144d

GameMusicTypeInitWithoutDisablingSerialRegs:
; turn off LCD, load screen, then clear oam
    call TurnOffLCD                                              ; $144f
    call LoadAsciiAndMenuScreenGfx                               ; $1452
    ld   de, Layout_GameMusicTypeScreen                          ; $1455
    call CopyLayoutToScreen0                                     ; $1458
    call Clear_wOam                                              ; $145b

; initial sprites for selected game/music option
    ld   hl, wSpriteSpecs                                        ; $145e
    ld   de, SpriteSpecStruct_GameMusicAType                     ; $1461
    ld   c, $02                                                  ; $1464
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $1466

; 1st sprite spec is for music
    ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $1469
    call PlayMovingSelectionSnd_SetSpriteSpecCoordsForMusicType  ; $146c

; set game type (spec 2) sprite spec X
    ldh  a, [hGameType]                                          ; $146f
    ld   e, SPR_SPEC_SIZEOF+SPR_SPEC_BaseXOffset                 ; $1471
    ld   [de], a                                                 ; $1473

; set sprite spec idx
    inc  de                                                      ; $1474
    cp   GAME_TYPE_A_TYPE                                        ; $1475
    ld   a, SPRITE_SPEC_A_TYPE                                   ; $1477
    jr   z, .setGameTypeSpriteSpec                               ; $1479

    ld   a, SPRITE_SPEC_B_TYPE                                   ; $147b

.setGameTypeSpriteSpec:
    ld   [de], a                                                 ; $147d

; copy to oam, play relevant music, turn on LCD, go to main state
    call Copy2SpriteSpecsToShadowOam                             ; $147e
    call PlaySongBasedOnMusicTypeChosen                          ; $1481
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $1484
    ldh  [rLCDC], a                                              ; $1486
    ld   a, GS_GAME_TYPE_MAIN                                    ; $1488
    ldh  [hGameState], a                                         ; $148a

Stub_148c:
    ret                                                          ; $148c


PlayMovingSelectionSnd_SetSpriteSpecCoordsForMusicType:
    ld   a, SND_MOVING_SELECTION                                 ; $148d
    ld   [wSquareSoundToPlay], a                                 ; $148f

SetSpriteSpecCoordsForMusicType:
; music type from 0-3
    ldh  a, [hMusicType]                                         ; $1492
    push af                                                      ; $1494
    sub  MUSIC_TYPES_START                                       ; $1495

; bc = double index, hl is offset in below table
    add  a                                                       ; $1497
    ld   c, a                                                    ; $1498
    ld   b, $00                                                  ; $1499
    ld   hl, .coords                                             ; $149b
    add  hl, bc                                                  ; $149e

; set sprite spec Y, then Z
    ld   a, [hl+]                                                ; $149f
    ld   [de], a                                                 ; $14a0
    inc  de                                                      ; $14a1
    ld   a, [hl]                                                 ; $14a2
    ld   [de], a                                                 ; $14a3
    inc  de                                                      ; $14a4

; orig music type = spec idx
    pop  af                                                      ; $14a5
    ld   [de], a                                                 ; $14a6
    ret                                                          ; $14a7

.coords:
    db $70, $37
    db $70, $77
    db $80, $37
    db $80, $77


GameState0f_MusicTypeMain:
; get buttons and flash music text
    ld   de, wSpriteSpecs                                        ; $14b0
    call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $14b3

    ld   hl, hMusicType                                          ; $14b6
    ld   a, [hl]                                                 ; $14b9

; pressing Start in here or game type has the same effect, go to a/b type screen
    bit  PADB_START, b                                           ; $14ba
    jp   nz, GameState0e_GameTypeMain.pressedStart               ; $14bc

; pressing A here has the effect above, as this is the last selection
    bit  PADB_A, b                                               ; $14bf
    jp   nz, GameState0e_GameTypeMain.pressedStart               ; $14c1

    bit  PADB_B, b                                               ; $14c4
    jr   nz, .pressedB                                           ; $14c6

.checkDirectionalButtons:
; inc to sprite spec's Y
    inc  e                                                       ; $14c8
    bit  PADB_RIGHT, b                                           ; $14c9
    jr   nz, .pressedRight                                       ; $14cb

    bit  PADB_LEFT, b                                            ; $14cd
    jr   nz, .pressedLeft                                        ; $14cf

    bit  PADB_UP, b                                              ; $14d1
    jr   nz, .pressedUp                                          ; $14d3

    bit  PADB_DOWN, b                                            ; $14d5
    jp   z, GameState0e_GameTypeMain.copyToShadowOamOnly         ; $14d7

; jump straight to copy if at bottom row already
    cp   MUSIC_TYPES_START+2                                     ; $14da
    jr   nc, .copyToShadowOam                                    ; $14dc

    add  $02                                                     ; $14de

.setMusicType:
    ld   [hl], a                                                 ; $14e0
    call PlayMovingSelectionSnd_SetSpriteSpecCoordsForMusicType  ; $14e1
    call PlaySongBasedOnMusicTypeChosen                          ; $14e4

.copyToShadowOam:
    call Copy2SpriteSpecsToShadowOam                             ; $14e7
    ret                                                          ; $14ea

.pressedUp:
; sub 2 if on bottom row
    cp   MUSIC_TYPES_START+2                                     ; $14eb
    jr   c, .copyToShadowOam                                     ; $14ed

    sub  $02                                                     ; $14ef
    jr   .setMusicType                                           ; $14f1

.pressedRight:
; skip if on right column
    cp   MUSIC_TYPES_START+1                                     ; $14f3
    jr   z, .copyToShadowOam                                     ; $14f5

    cp   MUSIC_TYPES_START+3                                     ; $14f7
    jr   z, .copyToShadowOam                                     ; $14f9

; else inc music type
    inc  a                                                       ; $14fb
    jr   .setMusicType                                           ; $14fc

.pressedLeft:
; skip if on left column
    cp   MUSIC_TYPES_START+0                                     ; $14fe
    jr   z, .copyToShadowOam                                     ; $1500

    cp   MUSIC_TYPES_START+2                                     ; $1502
    jr   z, .copyToShadowOam                                     ; $1504

; else dec music type
    dec  a                                                       ; $1506
    jr   .setMusicType                                           ; $1507

.pressedB:
    push af                                                      ; $1509
    ldh  a, [hIs2Player]                                         ; $150a
    and  a                                                       ; $150c
    jr   z, .not2player                                          ; $150d

; is 2 player - dont allow going back
    pop  af                                                      ; $150f
    jr   .checkDirectionalButtons                                ; $1510

.not2player:
    pop  af                                                      ; $1512
    ld   a, GS_GAME_TYPE_MAIN                                    ; $1513
    jr   GameState0e_GameTypeMain.setGameStateClearSpecIdx       ; $1515


PlaySongBasedOnMusicTypeChosen:
    ldh  a, [hMusicType]                                         ; $1517
    sub  MUSIC_TYPE_A_TYPE-MUS_A_TYPE                            ; $1519
    cp   MUSIC_TYPE_OFF-(MUSIC_TYPE_A_TYPE-MUS_A_TYPE)           ; $151b
    jr   nz, .playSong                                           ; $151d

    ld   a, $ff                                                  ; $151f

.playSong:
    ld   [wSongToStart], a                                       ; $1521
    ret                                                          ; $1524


GameState0e_GameTypeMain:
; spr spec #1 - music type, #2 here is game type
    ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF                        ; $1525
    call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $1528

    ld   hl, hGameType                                           ; $152b
    ld   a, [hl]                                                 ; $152e
    bit  PADB_START, b                                           ; $152f
    jr   nz, .pressedStart                                       ; $1531

    bit  PADB_A, b                                               ; $1533
    jr   nz, .pressedA                                           ; $1535

; inc into spot in sprite spec struct where spec X is
    inc  e                                                       ; $1537
    inc  e                                                       ; $1538
    bit  PADB_RIGHT, b                                           ; $1539
    jr   nz, .pressedRight                                       ; $153b

    bit  PADB_LEFT, b                                            ; $153d
    jr   z, .copyToShadowOamOnly                                 ; $153f

; pressed left, if not on A type already, use new game type and sprite spec idx
    cp   GAME_TYPE_A_TYPE                                        ; $1541
    jr   z, .copyToShadowOamOnly                                 ; $1543

    ld   a, GAME_TYPE_A_TYPE                                     ; $1545
    ld   b, SPRITE_SPEC_A_TYPE                                   ; $1547
    jr   .setGameTypeAndSpriteSpecIdx                            ; $1549

.pressedRight:
; if not on B type already, use new game type and sprite spec idx
    cp   GAME_TYPE_B_TYPE                                        ; $154b
    jr   z, .copyToShadowOamOnly                                 ; $154d

    ld   a, GAME_TYPE_B_TYPE                                     ; $154f
    ld   b, SPRITE_SPEC_B_TYPE                                   ; $1551

.setGameTypeAndSpriteSpecIdx:
; set game type
    ld   [hl], a                                                 ; $1553

; play moving selection sound
    push af                                                      ; $1554
    ld   a, SND_MOVING_SELECTION                                 ; $1555
    ld   [wSquareSoundToPlay], a                                 ; $1557
    pop  af                                                      ; $155a

; the game type var is also the X
    ld   [de], a                                                 ; $155b
    inc  de                                                      ; $155c

; then set spec idx
    ld   a, b                                                    ; $155d

.setSpecIdx:
    ld   [de], a                                                 ; $155e

.copyToShadowOamOnly:
    call Copy2SpriteSpecsToShadowOam                             ; $155f
    ret                                                          ; $1562

.pressedStart:
; play confirm sound
    ld   a, SND_CONFIRM_OR_LETTER_TYPED                          ; $1563
    ld   [wSquareSoundToPlay], a                                 ; $1565

; skip music selection and go to the selected game type's screen
    ldh  a, [hGameType]                                          ; $1568
    cp   GAME_TYPE_A_TYPE                                        ; $156a
    ld   a, GS_A_TYPE_SELECTION_INIT                             ; $156c
    jr   z, .setGameStateClearSpecIdx                            ; $156e

    ld   a, GS_B_TYPE_SELECTION_INIT                             ; $1570

.setGameStateClearSpecIdx:
    ldh  [hGameState], a                                         ; $1572
    xor  a                                                       ; $1574
    jr   .setSpecIdx                                             ; $1575

.pressedA:
    ld   a, GS_MUSIC_TYPE_MAIN                                   ; $1577
    jr   .setGameStateClearSpecIdx                               ; $1579


GameState10_ATypeSelectionInit:
; load gfx and data with lcd off, and clear oam
    call TurnOffLCD                                              ; $157b
    ld   de, Layout_ATypeSelectionScreen                         ; $157e
    call CopyLayoutToScreen0                                     ; $1581
    call DisplayDottedLinesForHighScore                          ; $1584
    call Clear_wOam                                              ; $1587

; default option is level 0
    ld   hl, wSpriteSpecs                                        ; $158a
    ld   de, SpriteSpecStruct_ATypeFlashing0                     ; $158d
    ld   c, $01                                                  ; $1590
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $1592

; send sprite spec level to oam
    ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $1595
    ldh  a, [hATypeLevel]                                        ; $1598
    ld   hl, ATypeLevelsCoords                                   ; $159a
    call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $159d
    call Copy2SpriteSpecsToShadowOam                             ; $15a0

; display high scores' names and score
    call DisplayATypeHighScoresForLevel                          ; $15a3
    call DisplayHighScoresAndNamesForLevel                       ; $15a6

; turn on LCD and set main state
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $15a9
    ldh  [rLCDC], a                                              ; $15ab
    ld   a, GS_A_TYPE_SELECTION_MAIN                             ; $15ad
    ldh  [hGameState], a                                         ; $15af

; if must enter high score, set state, otherwise set A type music
    ldh  a, [hMustEnterHighScore]                                ; $15b1
    and  a                                                       ; $15b3
    jr   nz, .setGameStateToEnterHighScore                       ; $15b4

    call PlaySongBasedOnMusicTypeChosen                          ; $15b6
    ret                                                          ; $15b9

.setGameStateToEnterHighScore:
    ld   a, GS_ENTERING_HIGH_SCORE                               ; $15ba

.setGameState:
    ldh  [hGameState], a                                         ; $15bc
    ret                                                          ; $15be


GameState11_ATypeSelectionMain:
    ld   de, wSpriteSpecs                                        ; $15bf
    call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $15c2

    ld   hl, hATypeLevel                                         ; $15c5

; pressing start or A goes to in game
    ld   a, GS_IN_GAME_INIT                                      ; $15c8
    bit  PADB_START, b                                           ; $15ca
    jr   nz, GameState10_ATypeSelectionInit.setGameState         ; $15cc

    bit  PADB_A, b                                               ; $15ce
    jr   nz, GameState10_ATypeSelectionInit.setGameState         ; $15d0

; pressing B goes back to prev screen
    ld   a, GS_GAME_MUSIC_TYPE_INIT                              ; $15d2
    bit  PADB_B, b                                               ; $15d4
    jr   nz, GameState10_ATypeSelectionInit.setGameState         ; $15d6

; get level in A
    ld   a, [hl]                                                 ; $15d8
    bit  PADB_RIGHT, b                                           ; $15d9
    jr   nz, .pressedRight                                       ; $15db

    bit  PADB_LEFT, b                                            ; $15dd
    jr   nz, .pressedLeft                                        ; $15df

    bit  PADB_UP, b                                              ; $15e1
    jr   nz, .pressedUp                                          ; $15e3

    bit  PADB_DOWN, b                                            ; $15e5
    jr   z, .sendSpritesToOam                                    ; $15e7

; pressed down, ignore if on bottom row
    cp   $05                                                     ; $15e9
    jr   nc, .sendSpritesToOam                                   ; $15eb

; else add 5 to be on bottom row
    add  $05                                                     ; $15ed
    jr   .setNewLevel                                            ; $15ef

.pressedRight:
; can wrap from 4 to 5, stop when at 9 already
    cp   $09                                                     ; $15f1
    jr   z, .sendSpritesToOam                                    ; $15f3

    inc  a                                                       ; $15f5

.setNewLevel:
    ld   [hl], a                                                 ; $15f6

; play sound, change spec based on new level
    ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $15f7
    ld   hl, ATypeLevelsCoords                                   ; $15fa
    call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $15fd

; display level-relevant high scores
    call DisplayATypeHighScoresForLevel                          ; $1600

.sendSpritesToOam:
    call Copy2SpriteSpecsToShadowOam                             ; $1603
    ret                                                          ; $1606

.pressedLeft:
; can wrap from 5 to 4, stop when at 0 already
    and  a                                                       ; $1607
    jr   z, .sendSpritesToOam                                    ; $1608

    dec  a                                                       ; $160a
    jr   .setNewLevel                                            ; $160b

.pressedUp:
; ignore if 0-4 (top row), else -5 to go to prev row
    cp   $05                                                     ; $160d
    jr   c, .sendSpritesToOam                                    ; $160f

    sub  $05                                                     ; $1611
    jr   .setNewLevel                                            ; $1613


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
    call TurnOffLCD                                              ; $1629
    ld   de, Layout_BTypeSelectionScreen                         ; $162c
    call CopyLayoutToScreen0                                     ; $162f
    call Clear_wOam                                              ; $1632

; get sprite specs for both level and high options
    ld   hl, wSpriteSpecs                                        ; $1635
    ld   de, SpriteSpecStruct_BTypeLevelAndHigh                  ; $1638
    ld   c, $02                                                  ; $163b
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $163d

; level spec idx coords
    ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $1640
    ldh  a, [hBTypeLevel]                                        ; $1643
    ld   hl, BTypeLevelsCoords                                   ; $1645
    call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $1648

; high spec idx coords, then send both to oam
    ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset   ; $164b
    ldh  a, [hBTypeHigh]                                         ; $164e
    ld   hl, BTypeHighsCoords                                    ; $1650
    call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $1653
    call Copy2SpriteSpecsToShadowOam                             ; $1656

; display high's name and score
    call DisplayBTypeHighScoresForLevel                          ; $1659
    call DisplayHighScoresAndNamesForLevel                       ; $165c

; turn on LCD and set default main state
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON ; $165f
    ldh  [rLCDC], a                                              ; $1661
    ld   a, GS_B_TYPE_SELECTION_MAIN                             ; $1663
    ldh  [hGameState], a                                         ; $1665

; set enter high score state if relevant, otherwise start music
    ldh  a, [hMustEnterHighScore]                                ; $1667
    and  a                                                       ; $1669
    jr   nz, .setEnterHiScore                                    ; $166a

    call PlaySongBasedOnMusicTypeChosen                          ; $166c
    ret                                                          ; $166f

.setEnterHiScore:
    ld   a, GS_ENTERING_HIGH_SCORE                               ; $1670
    ldh  [hGameState], a                                         ; $1672
    ret                                                          ; $1674


GameState13_setGameStateMakeSpriteVisible:
    ldh  [hGameState], a                                         ; $1675
    xor  a                                                       ; $1677
    ld   [de], a                                                 ; $1678
    ret                                                          ; $1679


GameState13_BTypeSelectionMain:
    ld   de, wSpriteSpecs                                        ; $167a
    call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $167d

    ld   hl, hBTypeLevel                                         ; $1680

; pressing start, A, or B goes to the relevant game state
    ld   a, GS_IN_GAME_INIT                                      ; $1683
    bit  PADB_START, b                                           ; $1685
    jr   nz, GameState13_setGameStateMakeSpriteVisible           ; $1687

    ld   a, GS_B_TYPE_HIGH_MAIN                                  ; $1689
    bit  PADB_A, b                                               ; $168b
    jr   nz, GameState13_setGameStateMakeSpriteVisible           ; $168d

    ld   a, GS_GAME_MUSIC_TYPE_INIT                              ; $168f
    bit  PADB_B, b                                               ; $1691
    jr   nz, GameState13_setGameStateMakeSpriteVisible           ; $1693

; check directions
    ld   a, [hl]                                                 ; $1695
    bit  PADB_RIGHT, b                                           ; $1696
    jr   nz, .pressedRight                                       ; $1698

    bit  PADB_LEFT, b                                            ; $169a
    jr   nz, .pressedLeft                                        ; $169c

    bit  PADB_UP, b                                              ; $169e
    jr   nz, .pressedUp                                          ; $16a0

    bit  PADB_DOWN, b                                            ; $16a2
    jr   z, .sendToOam                                           ; $16a4

; pressed down, +5 if not on bottom row
    cp   $05                                                     ; $16a6
    jr   nc, .sendToOam                                          ; $16a8

    add  $05                                                     ; $16aa
    jr   .setNewSpriteCoords                                     ; $16ac

.pressedRight:
; wrap around from 4 to 5, dont go past 9
    cp   $09                                                     ; $16ae
    jr   z, .sendToOam                                           ; $16b0

    inc  a                                                       ; $16b2

.setNewSpriteCoords:
; set level, and display sprite appropriately
    ld   [hl], a                                                 ; $16b3
    ld   de, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $16b4
    ld   hl, BTypeLevelsCoords                                   ; $16b7
    call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $16ba

; display scores for new level
    call DisplayBTypeHighScoresForLevel                          ; $16bd

.sendToOam:
    call Copy2SpriteSpecsToShadowOam                             ; $16c0
    ret                                                          ; $16c3

.pressedLeft:
; allow if not at 0, ie wrap from 5 to 4
    and  a                                                       ; $16c4
    jr   z, .sendToOam                                           ; $16c5

    dec  a                                                       ; $16c7
    jr   .setNewSpriteCoords                                     ; $16c8

.pressedUp:
; allow, -5, if not on top row already
    cp   $05                                                     ; $16ca
    jr   c, .sendToOam                                           ; $16cc

    sub  $05                                                     ; $16ce
    jr   .setNewSpriteCoords                                     ; $16d0


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
    ldh  [hGameState], a                                         ; $16e6
    xor  a                                                       ; $16e8
    ld   [de], a                                                 ; $16e9
    ret                                                          ; $16ea


GameState14_BTypeHighMain:
    ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF                        ; $16eb
    call GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden ; $16ee
    ld   hl, hBTypeHigh                                          ; $16f1

; go to in-game init state when start or A pressed
    ld   a, GS_IN_GAME_INIT                                      ; $16f4
    bit  PADB_START, b                                           ; $16f6
    jr   nz, GameState14_setGameStateMakeSpriteVisible           ; $16f8

    bit  PADB_A, b                                               ; $16fa
    jr   nz, GameState14_setGameStateMakeSpriteVisible           ; $16fc

; go back to level state if pressing B
    ld   a, GS_B_TYPE_SELECTION_MAIN                             ; $16fe
    bit  PADB_B, b                                               ; $1700
    jr   nz, GameState14_setGameStateMakeSpriteVisible           ; $1702

; check directionals
    ld   a, [hl]                                                 ; $1704
    bit  PADB_RIGHT, b                                           ; $1705
    jr   nz, .pressedRight                                       ; $1707

    bit  PADB_LEFT, b                                            ; $1709
    jr   nz, .pressedLeft                                        ; $170b

    bit  PADB_UP, b                                              ; $170d
    jr   nz, .pressedUp                                          ; $170f

    bit  PADB_DOWN, b                                            ; $1711
    jr   z, .sendToOam                                           ; $1713

; pressed down, +3 if not on bottom row
    cp   $03                                                     ; $1715
    jr   nc, .sendToOam                                          ; $1717

    add  $03                                                     ; $1719
    jr   .setNewHighSpriteCoords                                 ; $171b

.pressedRight:
; +1 if not at 5 already, ie wrap from 2 to 3
    cp   $05                                                     ; $171d
    jr   z, .sendToOam                                           ; $171f

    inc  a                                                       ; $1721

.setNewHighSpriteCoords:
; set new high's coords
    ld   [hl], a                                                 ; $1722
    ld   de, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset   ; $1723
    ld   hl, BTypeHighsCoords                                    ; $1726
    call PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable ; $1729

; display relevant scores for level+high
    call DisplayBTypeHighScoresForLevel                          ; $172c

.sendToOam:
    call Copy2SpriteSpecsToShadowOam                             ; $172f
    ret                                                          ; $1732

.pressedLeft:
; -1 when not on 0, ie wrap from 3 to 2
    and  a                                                       ; $1733
    jr   z, .sendToOam                                           ; $1734

    dec  a                                                       ; $1736
    jr   .setNewHighSpriteCoords                                 ; $1737

.pressedUp:
; -3 if not on top row
    cp   $03                                                     ; $1739
    jr   c, .sendToOam                                           ; $173b

    sub  $03                                                     ; $173d
    jr   .setNewHighSpriteCoords                                 ; $173f


BTypeHighsCoords:
    db $40, $70
    db $40, $80
    db $40, $90
    db $50, $70
    db $50, $80
    db $50, $90


UnusedNop_174d:
    nop                                                          ; $174d


PlayMovingSound_SetNumberSpecStructsCoordsAndSpecIdxFromHLtable:
    push af                                                      ; $174e
    ld   a, SND_MOVING_SELECTION                                 ; $174f
    ld   [wSquareSoundToPlay], a                                 ; $1751
    pop  af                                                      ; $1754

SetNumberSpecStructsCoordsAndSpecIdxFromHLtable:
    push af                                                      ; $1755
; hl += 2a
    add  a                                                       ; $1756
    ld   c, a                                                    ; $1757
    ld   b, $00                                                  ; $1758
    add  hl, bc                                                  ; $175a

; copy y/x from hl table to de
    ld   a, [hl+]                                                ; $175b
    ld   [de], a                                                 ; $175c
    inc  de                                                      ; $175d
    ld   a, [hl]                                                 ; $175e
    ld   [de], a                                                 ; $175f
    inc  de                                                      ; $1760
    pop  af                                                      ; $1761

; then spec idx
    add  SPRITE_SPEC_IDX_0                                       ; $1762
    ld   [de], a                                                 ; $1764
    ret                                                          ; $1765


; in: DE - sprite spec address
; out: B - buttons pressed
GetButtonsPressedB_AlternateSpriteSpecBetweenShownAndHidden:
; alternate every $10 frames
    ldh  a, [hButtonsPressed]                                    ; $1766
    ld   b, a                                                    ; $1768
    ldh  a, [hTimer1]                                            ; $1769
    and  a                                                       ; $176b
    ret  nz                                                      ; $176c

    ld   a, $10                                                  ; $176d
    ldh  [hTimer1], a                                            ; $176f

; flip visibility
    ld   a, [de]                                                 ; $1771
    xor  SPRITE_SPEC_HIDDEN                                      ; $1772
    ld   [de], a                                                 ; $1774
    ret                                                          ; $1775


CopyCSpriteSpecStructsFromDEtoHL:
.nextSpriteSpec:
; 6 sprite spec values copied from de to hl
    push hl                                                      ; $1776
    ld   b, $06                                                  ; $1777

.loop:
    ld   a, [de]                                                 ; $1779
    ld   [hl+], a                                                ; $177a
    inc  de                                                      ; $177b
    dec  b                                                       ; $177c
    jr   nz, .loop                                               ; $177d

; add $10 for next sprite spec
    pop  hl                                                      ; $177f
    ld   a, $10                                                  ; $1780
    add  l                                                       ; $1782
    ld   l, a                                                    ; $1783
    dec  c                                                       ; $1784
    jr   nz, .nextSpriteSpec                                     ; $1785

; end with $80
    ld   [hl], $80                                               ; $1787
    ret                                                          ; $1789


Clear_wOam:
    xor  a                                                       ; $178a
    ld   hl, wOam                                                ; $178b
    ld   b, wOam.end-wOam                                        ; $178e

.loop:
    ld   [hl+], a                                                ; $1790
    dec  b                                                       ; $1791
    jr   nz, .loop                                               ; $1792

    ret                                                          ; $1794


DisplayATypeHighScoresForLevel:
    call DisplayDottedLinesForHighScore                          ; $1795

; loop until we get the high score address for the current level
    ldh  a, [hATypeLevel]                                        ; $1798
    ld   hl, wATypeHighScores                                    ; $179a
    ld   de, HISCORE_SIZEOF                                      ; $179d

.decA:
    and  a                                                       ; $17a0
    jr   z, .afterHiScoreAddrForLevel                            ; $17a1

    dec  a                                                       ; $17a3
    add  hl, de                                                  ; $17a4
    jr   .decA                                                   ; $17a5

.afterHiScoreAddrForLevel:
; go to highest byte of score 1, and put in DE
    inc  hl                                                      ; $17a7
    inc  hl                                                      ; $17a8
    push hl                                                      ; $17a9
    pop  de                                                      ; $17aa
    call SetNewHighScoreIfAchieved_SendNameAndScoreToRamBuffer   ; $17ab
    ret                                                          ; $17ae


DisplayBTypeHighScoresForLevel:
    call DisplayDottedLinesForHighScore                          ; $17af
    ldh  a, [hBTypeLevel]                                        ; $17b2
    ld   hl, wBTypeHighScores                                    ; $17b4
    ld   de, HISCORE_SIZEOF * 6                                  ; $17b7

; loop until we get the high score address for the current level
.decA1:
    and  a                                                       ; $17ba
    jr   z, .afterHiScoreAddrForLevel                            ; $17bb

    dec  a                                                       ; $17bd
    add  hl, de                                                  ; $17be
    jr   .decA1                                                  ; $17bf

.afterHiScoreAddrForLevel:
    ldh  a, [hBTypeHigh]                                         ; $17c1
    ld   de, HISCORE_SIZEOF                                      ; $17c3

; loop until we get the high score address for the current high in level
.decA2:
    and  a                                                       ; $17c6
    jr   z, .afterHiScoreAddrForLevelAndHigh                     ; $17c7

    dec  a                                                       ; $17c9
    add  hl, de                                                  ; $17ca
    jr   .decA2                                                  ; $17cb

.afterHiScoreAddrForLevelAndHigh:
; go to highest byte of score 1, and put in DE
    inc  hl                                                      ; $17cd
    inc  hl                                                      ; $17ce
    push hl                                                      ; $17cf
    pop  de                                                      ; $17d0
    call SetNewHighScoreIfAchieved_SendNameAndScoreToRamBuffer   ; $17d1
    ret                                                          ; $17d4


; in: HL - ram location of high score
; in: DE - game screen buffer for high score
CopyHighScoreValueToRamBuffer:
    ld   b, $03                                                  ; $17d5

.nextByteToCheckIfEmpty:
; stay in upper loop, while highest digit not found
    ld   a, [hl]                                                 ; $17d7
    and  $f0                                                     ; $17d8
    jr   nz, .hasTens                                            ; $17da

; check digits
    inc  e                                                       ; $17dc
    ld   a, [hl-]                                                ; $17dd
    and  $0f                                                     ; $17de
    jr   nz, .storeDigits                                        ; $17e0

    inc  e                                                       ; $17e2
    dec  b                                                       ; $17e3
    jr   nz, .nextByteToCheckIfEmpty                             ; $17e4

    ret                                                          ; $17e6

.hasTens:
; store 10s in dest
    ld   a, [hl]                                                 ; $17e7
    and  $f0                                                     ; $17e8
    swap a                                                       ; $17ea
    ld   [de], a                                                 ; $17ec

; get digits
    inc  e                                                       ; $17ed
    ld   a, [hl-]                                                ; $17ee
    and  $0f                                                     ; $17ef

.storeDigits:
    ld   [de], a                                                 ; $17f1
    inc  e                                                       ; $17f2

; check next byte
    dec  b                                                       ; $17f3
    jr   nz, .hasTens                                            ; $17f4

    ret                                                          ; $17f6


CopyHLtoDEbackwards_3bytes:
    ld   b, $03                                                  ; $17f7

CopyHLtoDEbackwards_Bbytes:
.loop:
    ld   a, [hl-]                                                ; $17f9
    ld   [de], a                                                 ; $17fa
    dec  de                                                      ; $17fb
    dec  b                                                       ; $17fc
    jr   nz, .loop                                               ; $17fd

    ret                                                          ; $17ff


SetNewHighScoreIfAchieved_SendNameAndScoreToRamBuffer:
; store address of 3-byte BCD
    ld   a, d                                                    ; $1800
    ldh  [h1stHighScoreHighestByteForLevel], a                   ; $1801
    ld   a, e                                                    ; $1803
    ldh  [h1stHighScoreHighestByteForLevel+1], a                 ; $1804

; check 3 high scores
    ld   c, $03                                                  ; $1806

.nextHiScore:
; push current high score's highest byte
    ld   hl, wScoreBCD+2                                         ; $1808
    push de                                                      ; $180b
    ld   b, $03                                                  ; $180c

.nextScoreByteToCompare:
; once current high score - current score yields a carry, jump
    ld   a, [de]                                                 ; $180e
    sub  [hl]                                                    ; $180f
    jr   c, .currScoreHigherThanAHighScore                       ; $1810

    jr   nz, .toNextHiScore                                      ; $1812

    dec  l                                                       ; $1814
    dec  de                                                      ; $1815
    dec  b                                                       ; $1816
    jr   nz, .nextScoreByteToCompare                             ; $1817

.toNextHiScore:
; de += 3 to next
    pop  de                                                      ; $1819
    inc  de                                                      ; $181a
    inc  de                                                      ; $181b
    inc  de                                                      ; $181c
    dec  c                                                       ; $181d
    jr   nz, .nextHiScore                                        ; $181e

    jr   .afterNoHighScore                                       ; $1820

.currScoreHigherThanAHighScore:
; popped de is current high score's highest byte
    pop  de                                                      ; $1822

; get highest byte of 1st high score
    ldh  a, [h1stHighScoreHighestByteForLevel]                   ; $1823
    ld   d, a                                                    ; $1825
    ldh  a, [h1stHighScoreHighestByteForLevel+1]                 ; $1826
    ld   e, a                                                    ; $1828

    push de                                                      ; $1829
    push bc                                                      ; $182a

; de = highest byte of 3rd high score
    ld   hl, $0006                                               ; $182b
    add  hl, de                                                  ; $182e
    push hl                                                      ; $182f
    pop  de                                                      ; $1830

; hl = highest byte of 2nd high score
    dec  hl                                                      ; $1831
    dec  hl                                                      ; $1832
    dec  hl                                                      ; $1833

; c = 3 if curr score > 1st high score
; c = 2 if curr score > 2nd high score
; c = 1 if curr score > 3rd high score
.shiftLowerScoresDown:
; eg if score > 1st high score, then 2 times we want to shift a score down (2nd + 3rd)
    dec  c                                                       ; $1834
    jr   z, .setCurrHighScore                                    ; $1835

    call CopyHLtoDEbackwards_3bytes                              ; $1837
    jr   .shiftLowerScoresDown                                   ; $183a

.setCurrHighScore:
; copy curr score into its high score
    ld   hl, wScoreBCD+2                                         ; $183c
    ld   b, $03                                                  ; $183f

.setCurrLoop:
    ld   a, [hl-]                                                ; $1841
    ld   [de], a                                                 ; $1842
    dec  e                                                       ; $1843
    dec  b                                                       ; $1844
    jr   nz, .setCurrLoop                                        ; $1845

; pop above C=3 to 1, and above highest byte of 1st high score
    pop  bc                                                      ; $1847
    pop  de                                                      ; $1848

; store C
    ld   a, c                                                    ; $1849
    ldh  [hReversedHighScoreRanking], a                          ; $184a

; later hl = highest byte of 2nd high score name
    ld   hl, $0012                                               ; $184c
    add  hl, de                                                  ; $184f
    push hl                                                      ; $1850

; later de = highest byte of 3rd high score name
    ld   de, $0006                                               ; $1851
    add  hl, de                                                  ; $1854
    push hl                                                      ; $1855
    pop  de                                                      ; $1856
    pop  hl                                                      ; $1857

; similar to above, but with names
.shiftLowerNamesDown:
    dec  c                                                       ; $1858
    jr   z, .setCurrName                                         ; $1859

    ld   b, $06                                                  ; $185b
    call CopyHLtoDEbackwards_Bbytes                              ; $185d
    jr   .shiftLowerNamesDown                                    ; $1860

; name starts dotted, with A in 1st spot
.setCurrName:
    ld   a, "<...>"                                              ; $1862
    ld   b, $05                                                  ; $1864

.copyDottedName:
    ld   [de], a                                                 ; $1866
    dec  de                                                      ; $1867
    dec  b                                                       ; $1868
    jr   nz, .copyDottedName                                     ; $1869

    ld   a, "A"                                                  ; $186b
    ld   [de], a                                                 ; $186d

; store A ram location
    ld   a, d                                                    ; $186e
    ldh  [hTypedTextCharLoc], a                                  ; $186f
    ld   a, e                                                    ; $1871
    ldh  [hTypedTextCharLoc+1], a                                ; $1872

; flash counter and letter counter
    xor  a                                                       ; $1874
    ldh  [hTetrisFlashCount], a                                  ; $1875
    ldh  [hTypedLetterCounter], a                                ; $1877

; play relevant song and set must enter high score, to go to correct state
    ld   a, MUS_ENTER_HIGH_SCORE                                 ; $1879
    ld   [wSongToStart], a                                       ; $187b
    ldh  [hMustEnterHighScore], a                                ; $187e

.afterNoHighScore:
; de is ram address for 1st place high score value
    ld   de, wGameScreenBuffer+$1ac                              ; $1880
    ldh  a, [h1stHighScoreHighestByteForLevel]                   ; $1883
    ld   h, a                                                    ; $1885
    ldh  a, [h1stHighScoreHighestByteForLevel+1]                 ; $1886
    ld   l, a                                                    ; $1888

; send to ram buffer, the 3 relevant high scores
    ld   b, $03                                                  ; $1889

.displayNextScore:
; preserve high score ram src, ram buffer, and B
    push hl                                                      ; $188b
    push de                                                      ; $188c
    push bc                                                      ; $188d

    call CopyHighScoreValueToRamBuffer                           ; $188e

; restore ram buffer dest and B, adding a row onto ram buffer dest for next score
    pop  bc                                                      ; $1891
    pop  de                                                      ; $1892
    ld   hl, GB_TILE_WIDTH                                       ; $1893
    add  hl, de                                                  ; $1896
    push hl                                                      ; $1897
    pop  de                                                      ; $1898

; restore hl
    pop  hl                                                      ; $1899

; add 3 onto hl for next score
    push de                                                      ; $189a
    ld   de, $0003                                               ; $189b
    add  hl, de                                                  ; $189e
    pop  de                                                      ; $189f
    dec  b                                                       ; $18a0
    jr   nz, .displayNextScore                                   ; $18a1

; hl = lowest byte of 1st name
    dec  hl                                                      ; $18a3
    dec  hl                                                      ; $18a4

; show relevant names for high scores
    ld   b, $03                                                  ; $18a5
    ld   de, wGameScreenBuffer+$1a4                              ; $18a7

.displayNextName:
    push de                                                      ; $18aa
    ld   c, $06                                                  ; $18ab

.nextNameChar:
; if before 6 chars are drawn, a blank spot is found, go to next name
    ld   a, [hl+]                                                ; $18ad
    and  a                                                       ; $18ae
    jr   z, .toNextName                                          ; $18af

; store and do next char
    ld   [de], a                                                 ; $18b1
    inc  de                                                      ; $18b2
    dec  c                                                       ; $18b3
    jr   nz, .nextNameChar                                       ; $18b4

.toNextName:
; de ram buffer dest is next row
    pop  de                                                      ; $18b6
    push hl                                                      ; $18b7
    ld   hl, GB_TILE_WIDTH                                       ; $18b8
    add  hl, de                                                  ; $18bb
    push hl                                                      ; $18bc
    pop  de                                                      ; $18bd

; next name
    pop  hl                                                      ; $18be
    dec  b                                                       ; $18bf
    jr   nz, .displayNextName                                    ; $18c0

; clear score vars
    call ClearScoreCategoryVarsAndTotalScore                     ; $18c2

    ld   a, $01                                                  ; $18c5
    ldh  [hJustSetHighScoreAndCopiedToRamBuffer], a              ; $18c7
    ret                                                          ; $18c9


DisplayHighScoresAndNamesForLevel:
    ldh  a, [hJustSetHighScoreAndCopiedToRamBuffer]              ; $18ca
    and  a                                                       ; $18cc
    ret  z                                                       ; $18cd

; dest and src for names
    ld   hl, _SCRN0+$1a4                                         ; $18ce
    ld   de, wGameScreenBuffer+$1a4                              ; $18d1

; 3 names and 3 scores
    ld   c, $06                                                  ; $18d4

.nextHighScore:
    push hl                                                      ; $18d6

.next6chars:
; copy whole name from buffer to vram
    ld   b, $06                                                  ; $18d7

.copyName:
    ld   a, [de]                                                 ; $18d9
    ld   [hl+], a                                                ; $18da
    inc  e                                                       ; $18db
    dec  b                                                       ; $18dc
    jr   nz, .copyName                                           ; $18dd

; hl/de = score
    inc  e                                                       ; $18df
    inc  l                                                       ; $18e0
    inc  e                                                       ; $18e1
    inc  l                                                       ; $18e2
    dec  c                                                       ; $18e3
    jr   z, .end                                                 ; $18e4

; loop to next if next is score
    bit  0, c                                                    ; $18e6
    jr   nz, .next6chars                                         ; $18e8

; after score, go to next row
    pop  hl                                                      ; $18ea
    ld   de, GB_TILE_WIDTH                                       ; $18eb
    add  hl, de                                                  ; $18ee
    push hl                                                      ; $18ef
    pop  de                                                      ; $18f0

; de is screen buffer again
    ld   a, HIGH(wGameScreenBuffer-_SCRN0)                       ; $18f1
    add  d                                                       ; $18f3
    ld   d, a                                                    ; $18f4
    jr   .nextHighScore                                          ; $18f5

.end:
    pop  hl                                                      ; $18f7
    xor  a                                                       ; $18f8
    ldh  [hJustSetHighScoreAndCopiedToRamBuffer], a              ; $18f9
    ret                                                          ; $18fb


DisplayDottedLinesForHighScore:
    ld   hl, wGameScreenBuffer+$1a4                              ; $18fc
    ld   de, GB_TILE_WIDTH                                       ; $18ff
    ld   a, "<...>"                                              ; $1902

; 3 rows of high screo
    ld   c, $03                                                  ; $1904

.nextRow:
; this many cols
    ld   b, $0e                                                  ; $1906
    push hl                                                      ; $1908

.nextCol:
    ld   [hl+], a                                                ; $1909
    dec  b                                                       ; $190a
    jr   nz, .nextCol                                            ; $190b

; inc to next vram row
    pop  hl                                                      ; $190d
    add  hl, de                                                  ; $190e
    dec  c                                                       ; $190f
    jr   nz, .nextRow                                            ; $1910

    ret                                                          ; $1912


GameState15_EnteringHighScore:
    ldh  a, [hReversedHighScoreRanking]                          ; $1913

; hl = 3rd high score name 1st char
    ld   hl, _SCRN0+$1e4                                         ; $1915
    ld   de, -$20                                                ; $1918

; loop getting right vram dest based on ranking
.decA:
    dec  a                                                       ; $191b
    jr   z, .afterRamDestAddrForScore                            ; $191c

    add  hl, de                                                  ; $191e
    jr   .decA                                                   ; $191f

.afterRamDestAddrForScore:
; go to dest based on which letter we're typing
    ldh  a, [hTypedLetterCounter]                                ; $1921
    ld   e, a                                                    ; $1923
    ld   d, $00                                                  ; $1924
    add  hl, de                                                  ; $1926

; get ram src of typed chars
    ldh  a, [hTypedTextCharLoc]                                  ; $1927
    ld   d, a                                                    ; $1929
    ldh  a, [hTypedTextCharLoc+1]                                ; $192a
    ld   e, a                                                    ; $192c

; every 7 frames..
    ldh  a, [hTimer1]                                            ; $192d
    and  a                                                       ; $192f
    jr   nz, .afterTimerCheck                                    ; $1930

    ld   a, $07                                                  ; $1932
    ldh  [hTimer1], a                                            ; $1934

; flash current letter
    ldh  a, [hTetrisFlashCount]                                  ; $1936
    xor  $01                                                     ; $1938
    ldh  [hTetrisFlashCount], a                                  ; $193a

; if curr char is 0, display empty, otherwise curr char
    ld   a, [de]                                                 ; $193c
    jr   z, .setTile                                             ; $193d

    ld   a, TILE_EMPTY                                           ; $193f

.setTile:
    call StoreAinHLwhenLCDFree                                   ; $1941

.afterTimerCheck:
    ldh  a, [hButtonsPressed]                                    ; $1944
    ld   b, a                                                    ; $1946
    ldh  a, [hButtonsHeld]                                       ; $1947
    ld   c, a                                                    ; $1949

; initial sticky counter
    ld   a, $17                                                  ; $194a
    bit  PADB_UP, b                                              ; $194c
    jr   nz, .upPressed                                          ; $194e

    bit  PADB_UP, c                                              ; $1950
    jr   nz, .upHeld                                             ; $1952

    bit  PADB_DOWN, b                                            ; $1954
    jr   nz, .downPressed                                        ; $1956

    bit  PADB_DOWN, c                                            ; $1958
    jr   nz, .downHeld                                           ; $195a

    bit  PADB_A, b                                               ; $195c
    jr   nz, .aPressed                                           ; $195e

    bit  PADB_B, b                                               ; $1960
    jp   nz, .bPressed                                           ; $1962

    bit  PADB_START, b                                           ; $1965
    ret  z                                                       ; $1967

.done:
    ld   a, [de]                                                 ; $1968
    call StoreAinHLwhenLCDFree                                   ; $1969
    call PlaySongBasedOnMusicTypeChosen                          ; $196c
    xor  a                                                       ; $196f
    ldh  [hMustEnterHighScore], a                                ; $1970

; set relevant state based on game type
    ldh  a, [hGameType]                                          ; $1972
    cp   GAME_TYPE_A_TYPE                                        ; $1974
    ld   a, GS_A_TYPE_SELECTION_MAIN                             ; $1976
    jr   z, .setGameState                                        ; $1978

    ld   a, GS_B_TYPE_SELECTION_MAIN                             ; $197a

.setGameState:
    ldh  [hGameState], a                                         ; $197c
    ret                                                          ; $197e

.upHeld:
; process up every 9 frames
    ldh  a, [hStickyButtonCounter]                               ; $197f
    dec  a                                                       ; $1981
    ldh  [hStickyButtonCounter], a                               ; $1982
    ret  nz                                                      ; $1984

    ld   a, $09                                                  ; $1985

.upPressed:
    ldh  [hStickyButtonCounter], a                               ; $1987

; allow heart in hard mode
    ld   b, "*"                                                  ; $1989
    ldh  a, [hIsHardMode]                                        ; $198b
    and  a                                                       ; $198d
    jr   z, .afterUpHardModeCheck                                ; $198e

    ld   b, "<3"                                                 ; $1990

.afterUpHardModeCheck:
    ld   a, [de]                                                 ; $1992
    cp   b                                                       ; $1993
    jr   nz, .notUpLastChar                                      ; $1994

    ld   a, TILE_EMPTY-1                                         ; $1996

.incChar:
    inc  a                                                       ; $1998

.setChar:
    ld   [de], a                                                 ; $1999
    ld   a, SND_MOVING_SELECTION                                 ; $199a
    ld   [wSquareSoundToPlay], a                                 ; $199c
    ret                                                          ; $199f

.notUpLastChar:
; if not last char or blank, inc to next char
    cp   TILE_EMPTY                                              ; $19a0
    jr   nz, .incChar                                            ; $19a2

; if blank, go to A
    ld   a, "A"                                                  ; $19a4
    jr   .setChar                                                ; $19a6

.downHeld:
; process down every 9 frames
    ldh  a, [hStickyButtonCounter]                               ; $19a8
    dec  a                                                       ; $19aa
    ldh  [hStickyButtonCounter], a                               ; $19ab
    ret  nz                                                      ; $19ad

    ld   a, $09                                                  ; $19ae

.downPressed:
    ldh  [hStickyButtonCounter], a                               ; $19b0

; allow heart in hard mode
    ld   b, "*"                                                  ; $19b2
    ldh  a, [hIsHardMode]                                        ; $19b4
    and  a                                                       ; $19b6
    jr   z, .afterDownHardModeCheck                              ; $19b7

    ld   b, "<3"                                                 ; $19b9

.afterDownHardModeCheck:
; check if at A already
    ld   a, [de]                                                 ; $19bb
    cp   "A"                                                     ; $19bc
    jr   nz, .notDownLastChar                                    ; $19be

    ld   a, TILE_EMPTY+1                                         ; $19c0

.decChar:
    dec  a                                                       ; $19c2
    jr   .setChar                                                ; $19c3

.notDownLastChar:
; check if blank tile (next is the x or <3)
    cp   TILE_EMPTY                                              ; $19c5
    jr   nz, .decChar                                            ; $19c7

    ld   a, b                                                    ; $19c9
    jr   .setChar                                                ; $19ca

.aPressed:
; store selection in LCD
    ld   a, [de]                                                 ; $19cc
    call StoreAinHLwhenLCDFree                                   ; $19cd
    ld   a, SND_CONFIRM_OR_LETTER_TYPED                          ; $19d0
    ld   [wSquareSoundToPlay], a                                 ; $19d2

; inc letter counter, finishing when 6 letters done
    ldh  a, [hTypedLetterCounter]                                ; $19d5
    inc  a                                                       ; $19d7
    cp   $06                                                     ; $19d8
    jr   z, .done                                                ; $19da

    ldh  [hTypedLetterCounter], a                                ; $19dc

; go to next ram src, setting it as A by default
    inc  de                                                      ; $19de
    ld   a, [de]                                                 ; $19df
    cp   "<...>"                                                 ; $19e0
    jr   nz, .setNextCharLoc                                     ; $19e2

    ld   a, "A"                                                  ; $19e4
    ld   [de], a                                                 ; $19e6

.setNextCharLoc:
    ld   a, d                                                    ; $19e7
    ldh  [hTypedTextCharLoc], a                                  ; $19e8
    ld   a, e                                                    ; $19ea
    ldh  [hTypedTextCharLoc+1], a                                ; $19eb
    ret                                                          ; $19ed

.bPressed:
; if at 1st letter, return
    ldh  a, [hTypedLetterCounter]                                ; $19ee
    and  a                                                       ; $19f0
    ret  z                                                       ; $19f1

; store current letter in LCD
    ld   a, [de]                                                 ; $19f2
    call StoreAinHLwhenLCDFree                                   ; $19f3

; dec counter and position in vram, then set char loc
    ldh  a, [hTypedLetterCounter]                                ; $19f6
    dec  a                                                       ; $19f8
    ldh  [hTypedLetterCounter], a                                ; $19f9
    dec  de                                                      ; $19fb
    jr   .setNextCharLoc                                         ; $19fc
