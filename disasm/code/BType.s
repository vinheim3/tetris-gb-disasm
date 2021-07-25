GameState05_BTypeLevelFinished:
; proceed when timer 0
    ldh  a, [hTimer1]                                            ; $1d26
    and  a                                                       ; $1d28
    ret  nz                                                      ; $1d29

; display layout
    ld   hl, wGameScreenBuffer+2                                 ; $1d2a
    ld   de, GameScreenLayout_ScoreTotals                        ; $1d2d
    call CopyToGameScreenUntilByteReadEquFFhThenSetVramTransfer  ; $1d30

; jump if level 0
    ldh  a, [hBTypeLevel]                                        ; $1d33
    and  a                                                       ; $1d35
    jr   z, .fromLevel0                                          ; $1d36

; level 1+, override score mults, eg level 7 = $40 * 7 for the 1st one
    ld   de, SCORE_1_LINE                                        ; $1d38
    ld   hl, wGameScreenBuffer+$27                               ; $1d3b
    call DisplayBTypeScoreMultipliersBasedOnLevel                ; $1d3e

    ld   de, SCORE_2_LINES                                       ; $1d41
    ld   hl, wGameScreenBuffer+$87                               ; $1d44
    call DisplayBTypeScoreMultipliersBasedOnLevel                ; $1d47

    ld   de, SCORE_3_LINES                                       ; $1d4a
    ld   hl, wGameScreenBuffer+$e7                               ; $1d4d
    call DisplayBTypeScoreMultipliersBasedOnLevel                ; $1d50

    ld   de, SCORE_4_LINES                                       ; $1d53
    ld   hl, wGameScreenBuffer+$147                              ; $1d56
    call DisplayBTypeScoreMultipliersBasedOnLevel                ; $1d59

; clear score
    ld   hl, wScoreBCD                                           ; $1d5c
    ld   b, $03                                                  ; $1d5f
    xor  a                                                       ; $1d61

.clearScore:
    ld   [hl+], a                                                ; $1d62
    dec  b                                                       ; $1d63
    jr   nz, .clearScore                                         ; $1d64

.fromLevel0:
    ld   a, $80                                                  ; $1d66
    ldh  [hTimer1], a                                            ; $1d68

; set played and hidden piece to invisible, and send to oam
    ld   a, SPRITE_SPEC_HIDDEN                                   ; $1d6a
    ld   [wSpriteSpecs], a                                       ; $1d6c
    ld   [wSpriteSpecs+SPR_SPEC_SIZEOF], a                       ; $1d6f
    call Copy1stSpriteSpecToSprite4                              ; $1d72
    call Copy2ndSpriteSpecToSprite8                              ; $1d75

; init sound, reset lines back to 25, then next state
    call ThunkInitSound                                          ; $1d78
    ld   a, $25                                                  ; $1d7b
    ldh  [hNumLinesCompletedBCD], a                              ; $1d7d
    ld   a, GS_SCORE_UPDATE_AFTER_B_TYPE_LEVEL_DONE              ; $1d7f
    ldh  [hGameState], a                                         ; $1d81
    ret                                                          ; $1d83


DisplayBTypeScoreMultipliersBasedOnLevel:
    push hl                                                      ; $1d84

; clear score
    ld   hl, wScoreBCD                                           ; $1d85
    ld   b, $03                                                  ; $1d88
    xor  a                                                       ; $1d8a

.clearScore:
    ld   [hl+], a                                                ; $1d8b
    dec  b                                                       ; $1d8c
    jr   nz, .clearScore                                         ; $1d8d

; add score category * (level + 1)
    ldh  a, [hBTypeLevel]                                        ; $1d8f
    ld   b, a                                                    ; $1d91
    inc  b                                                       ; $1d92

.addScore:
    ld   hl, wScoreBCD                                           ; $1d93
    call AddScoreValueDEontoBaseScoreHL                          ; $1d96
    dec  b                                                       ; $1d99
    jr   nz, .addScore                                           ; $1d9a

; get orig ram loc
    pop  hl                                                      ; $1d9c
    ld   b, $03                                                  ; $1d9d
    ld   de, wScoreBCD+2                                         ; $1d9f

; stay in this upper loop, while no digit left to display
.checkForDigit:
    ld   a, [de]                                                 ; $1da2
    and  $f0                                                     ; $1da3
    jr   nz, .hasTens                                            ; $1da5

    ld   a, [de]                                                 ; $1da7
    and  $0f                                                     ; $1da8
    jr   nz, .hasDigits                                          ; $1daa

    dec  e                                                       ; $1dac
    dec  b                                                       ; $1dad
    jr   nz, .checkForDigit                                      ; $1dae

    ret                                                          ; $1db0

.hasTens:
; store in ram loc
    ld   a, [de]                                                 ; $1db1
    and  $f0                                                     ; $1db2
    swap a                                                       ; $1db4
    ld   [hl+], a                                                ; $1db6

.hasDigits:
    ld   a, [de]                                                 ; $1db7
    and  $0f                                                     ; $1db8
    ld   [hl+], a                                                ; $1dba

; to next byte
    dec  e                                                       ; $1dbb
    dec  b                                                       ; $1dbc
    jr   nz, .hasTens                                            ; $1dbd

    ret                                                          ; $1dbf


GameState0b_ScoreUpdateAfterBTypeLevelDone:
; proceed when timer 0
    ldh  a, [hTimer1]                                            ; $1dc0
    and  a                                                       ; $1dc2
    ret  nz                                                      ; $1dc3

; start having scores processed
    ld   a, $01                                                  ; $1dc4
    ld   [wCurrScoreCategIsProcessingOrUpdating], a              ; $1dc6

    ld   a, $05                                                  ; $1dc9
    ldh  [hTimer1], a                                            ; $1dcb
    ret                                                          ; $1dcd


GameState22_DancersInit:
; proceed when timer done
    ldh  a, [hTimer1]                                            ; $1dce
    and  a                                                       ; $1dd0
    ret  nz                                                      ; $1dd1

; load dancers layout and clear oam
    ld   hl, wGameScreenBuffer+2                                 ; $1dd2
    ld   de, GameScreenLayout_Dancers                            ; $1dd5
    call CopyToGameScreenUntilByteReadEquFFhThenSetVramTransfer  ; $1dd8
    call Clear_wOam                                              ; $1ddb

; load invisible dancers specs
    ld   hl, wSpriteSpecs                                        ; $1dde
    ld   de, SpriteSpecStruct_Dancers                            ; $1de1
    ld   c, NUM_DANCERS                                          ; $1de4
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $1de6

; jumper and kicker also use OBP1
    ld   a, $10                                                  ; $1de9
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF*6+SPR_SPEC_BaseXFlip   ; $1deb
    ld   [hl], a                                                 ; $1dee
    ld   l, SPR_SPEC_SIZEOF*7+SPR_SPEC_BaseXFlip                 ; $1def
    ld   [hl], a                                                 ; $1df1

; set active and SPR_SPEC_StartingAnimCounter counters per dancer
    ld   hl, wSpriteSpecs+SPR_SPEC_ActiveAnimCounter             ; $1df2
    ld   de, Dancers_AnimationTimers                             ; $1df5
    ld   b, NUM_DANCERS                                          ; $1df8

.setNextDancerAnimDetails:
    ld   a, [de]                                                 ; $1dfa
    ld   [hl+], a                                                ; $1dfb
    ld   [hl+], a                                                ; $1dfc
    inc  de                                                      ; $1dfd

; to next dancer
    push de                                                      ; $1dfe
    ld   de, SPR_SPEC_SIZEOF-2                                   ; $1dff
    add  hl, de                                                  ; $1e02
    pop  de                                                      ; $1e03
    dec  b                                                       ; $1e04
    jr   nz, .setNextDancerAnimDetails                           ; $1e05

; get num dancers to show based on high chosen, if
    ldh  a, [hBTypeHigh]                                         ; $1e07
    cp   $05                                                     ; $1e09
    jr   nz, .numDancersInB                                      ; $1e0b

    ld   a, NUM_DANCERS-1                                        ; $1e0d

.numDancersInB:
    inc  a                                                       ; $1e0f
    ld   b, a                                                    ; $1e10

; set visible those dancers
    ld   hl, wSpriteSpecs                                        ; $1e11
    ld   de, SPR_SPEC_SIZEOF                                     ; $1e14
    xor  a                                                       ; $1e17

.loopSetVisible:
    ld   [hl], a                                                 ; $1e18
    add  hl, de                                                  ; $1e19
    dec  b                                                       ; $1e1a
    jr   nz, .loopSetVisible                                     ; $1e1b

; play song based on high chosen
    ldh  a, [hBTypeHigh]                                         ; $1e1d
    add  MUS_DANCERS_HIGH_0                                      ; $1e1f
    ld   [wSongToStart], a                                       ; $1e21

; reset lines to complete back to 25, set timer, and go to next state
    ld   a, $25                                                  ; $1e24
    ldh  [hNumLinesCompletedBCD], a                              ; $1e26
    ld   a, $1b                                                  ; $1e28
    ldh  [hTimer1], a                                            ; $1e2a
    ld   a, GS_DANCERS_MAIN                                      ; $1e2c
    ldh  [hGameState], a                                         ; $1e2e
    ret                                                          ; $1e30


Dancers_AnimationTimers:
    db $1c, $0f, $1e, $32, $20
    db $18, $26, $1d, $28, $2b


GameState23_sendDancersToOam:
    ld   a, NUM_DANCERS                                          ; $1e3b
    call CopyASpriteSpecsToShadowOam                             ; $1e3d
    ret                                                          ; $1e40


GameState23_DancersMain:
; show dancers after a few frames
    ldh  a, [hTimer1]                                            ; $1e41
    cp   $14                                                     ; $1e43
    jr   z, GameState23_sendDancersToOam                         ; $1e45

; ret if timer still going
    and  a                                                       ; $1e47
    ret  nz                                                      ; $1e48

; toggle dancer's sprite when counter is 0
    ld   hl, wSpriteSpecs+SPR_SPEC_ActiveAnimCounter             ; $1e49
    ld   de, SPR_SPEC_SIZEOF                                     ; $1e4c
    ld   b, NUM_DANCERS                                          ; $1e4f

.nextDancer:
    push hl                                                      ; $1e51
    dec  [hl]                                                    ; $1e52
    jr   nz, .toNextDancer                                       ; $1e53

; dancer-specific counter is now 0
; get start counter ($0f) and store in active counter ($0e)
    inc  l                                                       ; $1e55
    ld   a, [hl-]                                                ; $1e56
    ld   [hl], a                                                 ; $1e57

; get spec idx
    ld   a, l                                                    ; $1e58
    and  $f0                                                     ; $1e59
    or   SPR_SPEC_SpecIdx                                        ; $1e5b
    ld   l, a                                                    ; $1e5d
    ld   a, [hl]                                                 ; $1e5e

; toggle and store in spec idx
    xor  $01                                                     ; $1e5f
    ld   [hl], a                                                 ; $1e61

; special cases for jumper
    cp   SPRITE_SPEC_JUMPER_1                                    ; $1e62
    jr   z, .isJumperStanding                                    ; $1e64

    cp   SPRITE_SPEC_JUMPER_2                                    ; $1e66
    jr   z, .isJumperJumping                                     ; $1e68

.toNextDancer:
    pop  hl                                                      ; $1e6a
    add  hl, de                                                  ; $1e6b
    dec  b                                                       ; $1e6c
    jr   nz, .nextDancer                                         ; $1e6d

; done processing dancers, send to oam
    ld   a, NUM_DANCERS                                          ; $1e6f
    call CopyASpriteSpecsToShadowOam                             ; $1e71
    ld   a, [wSongBeingPlayed]                                   ; $1e74
    and  a                                                       ; $1e77
    ret  nz                                                      ; $1e78

; clear oam and set state when music is stopped
    call Clear_wOam                                              ; $1e79

; set shuttle state if highest high, otherwise standard level finished
    ldh  a, [hBTypeHigh]                                         ; $1e7c
    cp   $05                                                     ; $1e7e
    ld   a, GS_SHUTTLE_SCENE_INIT                                ; $1e80
    jr   z, .setGameState                                        ; $1e82

    ld   a, GS_B_TYPE_LEVEL_FINISHED                             ; $1e84

.setGameState:
    ldh  [hGameState], a                                         ; $1e86
    ret                                                          ; $1e88

; set Ys for jumper based on animation
.isJumperStanding:
    dec  l                                                       ; $1e89
    dec  l                                                       ; $1e8a
    ld   [hl], $67                                               ; $1e8b
    jr   .toNextDancer                                           ; $1e8d

.isJumperJumping:
    dec  l                                                       ; $1e8f
    dec  l                                                       ; $1e90
    ld   [hl], $5d                                               ; $1e91
    jr   .toNextDancer                                           ; $1e93


After4ScoreCategoriesProcessed:
    xor  a                                                       ; $1e95
    ld   [wCurrScoreCategIsProcessingOrUpdating], a              ; $1e96

; get non-BCD num drops into HL, when done jump
    ld   de, wNumDrops                                           ; $1e99
    ld   a, [de]                                                 ; $1e9c
    ld   l, a                                                    ; $1e9d
    inc  de                                                      ; $1e9e
    ld   a, [de]                                                 ; $1e9f
    ld   h, a                                                    ; $1ea0
    or   l                                                       ; $1ea1
    jp   z, IncScoreCategoryProcessedAfterBTypeDone              ; $1ea2

; store num drops-1 back into orig num drops
    dec  hl                                                      ; $1ea5
    ld   a, h                                                    ; $1ea6
    ld   [de], a                                                 ; $1ea7
    dec  de                                                      ; $1ea8
    ld   a, l                                                    ; $1ea9
    ld   [de], a                                                 ; $1eaa

; add 1 onto drops total rolling up,
    ld   de, $0001                                               ; $1eab
    ld   hl, wDropsTotalRollingUp                                ; $1eae
    push de                                                      ; $1eb1
    call AddScoreValueDEontoBaseScoreHL                          ; $1eb2

; display total to vram
    ld   de, wDropsTotalRollingUp+2                              ; $1eb5
    ld   hl, $99a5                                               ; $1eb8
    call DisplayBCDNum6DigitsIfForced                            ; $1ebb

; clear timer
    xor  a                                                       ; $1ebe
    ldh  [hTimer1], a                                            ; $1ebf

; add 1 onto total score
    pop  de                                                      ; $1ec1
    ld   hl, wScoreBCD                                           ; $1ec2
    call AddScoreValueDEontoBaseScoreHL                          ; $1ec5
    ld   de, wScoreBCD+2                                         ; $1ec8

; display total score, and play sound
    ld   hl, $9a25                                               ; $1ecb
    call DisplayBCDNum6Digits                                    ; $1ece
    ld   a, SND_CONFIRM_OR_LETTER_TYPED                          ; $1ed1
    ld   [wSquareSoundToPlay], a                                 ; $1ed3
    ret                                                          ; $1ed6


ProcessScoreUpdatesAfterBTypeLevelDone:
; wait until game state B sets this to 1 or 2
    ld   a, [wCurrScoreCategIsProcessingOrUpdating]              ; $1ed7
    and  a                                                       ; $1eda
    ret  z                                                       ; $1edb

; jump if all 4 done
    ld   a, [wNumScoreCategoriesProcessed]                       ; $1edc
    cp   $04                                                     ; $1edf
    jr   z, After4ScoreCategoriesProcessed                       ; $1ee1

; process relevant category
    ld   de, SCORE_1_LINE                                        ; $1ee3
    ld   bc, $9823                                               ; $1ee6
    ld   hl, wLinesClearedStructs                                ; $1ee9
    and  a                                                       ; $1eec
    jr   z, .processCategory                                     ; $1eed

    ld   de, SCORE_2_LINES                                       ; $1eef
    ld   bc, $9883                                               ; $1ef2
    ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF           ; $1ef5
    cp   $01                                                     ; $1ef8
    jr   z, .processCategory                                     ; $1efa

    ld   de, SCORE_3_LINES                                       ; $1efc
    ld   bc, $98e3                                               ; $1eff
    ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF*2         ; $1f02
    cp   $02                                                     ; $1f05
    jr   z, .processCategory                                     ; $1f07

    ld   de, SCORE_4_LINES                                       ; $1f09
    ld   bc, $9943                                               ; $1f0c
    ld   hl, wLinesClearedStructs+LINES_CLEARED_SIZEOF*3         ; $1f0f

.processCategory:
    call ProcessCurrentScoreCategory                             ; $1f12
    ret                                                          ; $1f15


GameState0c_UnusedPreShuttleLiftOff:
; go to shuttle liftoff when buttons pressed
    ldh  a, [hButtonsPressed]                                    ; $1f16
    and  a                                                       ; $1f18
    ret  z                                                       ; $1f19

    ld   a, GS_SHUTTLE_SCENE_LIFTOFF                             ; $1f1a
    ldh  [hGameState], a                                         ; $1f1c
    ret                                                          ; $1f1e
    