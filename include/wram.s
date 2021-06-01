INCLUDE "includes.s"

SECTION "WRAM", WRAM0[$c000]

wOam:: ; $c000
    ds $a0
.end::

; low 2 digits of score in byte 1, next in byte 2, etc
wScoreBCD:: ; $c0a0
    ds 3

; 4 addresses + 1 byte for end marker (0)
wRamBufferAddressesForCompletedRows:: ; $c0a3
    ds 9 ; big-endian
.end::

wLinesClearedStructs:: ; $c0ac
    ds 4 * LINES_CLEARED_SIZEOF
wNumDrops:: ; $c0c0
    dw
wDropsTotalRollingUp:: ; $c0c2
    ds 3
wNumScoreCategoriesProcessed:: ; $c0c5
    db
; 1 if can process current score category
; 2 if current score category is being processed
wCurrScoreCategIsProcessingOrUpdating:: ; $c0c6
    db
wScoreCategoryVarsEnd::

wCanPressDownToMakePieceFall:: ; $c0c7
    db

wc0c8:
    ds $e-8

wATypeJustAddedDropsToScore:: ; $c0ce
    db

wc0cf:
    ds $de-$cf

wNextPieceHidden:: ; $c0de
    db

wc0df:
    ds $200-$df

wSpriteSpecs:: ; $c200
    ds $100 ; unknown size, but multiple of $10

; also pieces for 2 player
wDemoPieces:: ; $c300
    ds $100 ; actually $30 in size
.end::

wc400:
    ds $800-$400

; contains screen contents pre-effect,
; eg orig tile idxes when flashing completed rows
wGameScreenBuffer:: ; $c800
    ds $400
.end::

wcc00:
    ds $fff-$c00

wStackTop:: ; $cfff
    db ; just to fill this ram space

wBTypeHighScores:: ; $d000
    ds HISCORE_SIZEOF * 10 * 6

wATypeHighScores:: ; $d654
    ds HISCORE_SIZEOF * 10

wd762:
    ds $f70-$762

wCurrSoundChannelBeingProcessed:: ; $df70
    db

    union

wOrigSoundEffectIdx:: ; $df71
    db

    nextu

wUnusedShadowAudLen:: ; $df71
    db

    endu

wdf72:
    ds 5-2

wAudTermCounterUntilChangingOutput:: ; $df75
    db
wAudTermCounterValueToHitToChangeOutput:: ; $df76
    db
; is inc'ed everytime above 2 are equal
; 2 values are chosen based on even and odd
wAudTermSelectedOutputVal:: ; $df77
    db
; 1 - 1st aud term value is always used
; 3 - output to all
; else (unused) - use above counters
wAudTermSongsSpec:: ; $df78
    db
wAudTermOutputValue1:: ; $df79
    db
wAudTermOutputValue2:: ; $df7a
    db

wdf7b:
    ds $e-$b

; counts down, doing a different sound at points
wGamePausedSoundTimer:: ; $df7e
    db

; 0 - none, 1 - just paused, 2 - just unpaused
wGamePausedActivity:: ; $df7f
    db

wUnused_df80:: ; $df80
    db

wSongTempoAddr:: ; $df81
    dw

wdf83:
    ds $90-$83

wAudStructs:: ; $df90
wAud1Struct:: ; $df90
    ds AUD_SIZEOF

wAud2Struct:: ; $dfa0
    ds AUD_SIZEOF

wAud3Struct:: ; $dfb0
    ds AUD_SIZEOF

wAud4Struct:: ; $dfc0
    ds AUD_SIZEOF

wdfd0:
    ds $e0-$d0

wSquareSoundToPlay:: ; $dfe0
    db
wSquareEffectBeingPlayed:: ; $dfe1
    db
wSquareEffectFrameCounter:: ; $dfe2
    db
wSquareEffectFrameCounterThreshold:: ; dfe3
    db
wSquareEffectMiscCounter:: ; $dfe4
    db

wdfe5:
    ds 8-5

wSongToStart:: ; $dfe8
    db
wSongBeingPlayed:: ; $dfe9
    db

wdfea:
    ds $f0-$ea

wWavSoundToPlay:: ; $dff0
    db
wWavEffectBeingPlayed:: ; $dff1
    db
wWavEffectFrameCounter:: ; $dff2
    db
wWavEffectFrameCounterThreshold:: ; dff3
    db
wWavEffectMiscCounter:: ; $dff4
    db
    union
wWavEffectRandomVal:: ; $dff5
    db
    nextu
; 0 - neither, 1 - inc, 2 - dec
wWavEffectShouldIncOrDec:: ; $dff5
    endu
wWavEffectCurrLoVal:: ; $dff6
    db

wdff7:
    ds 8-7

wNoiseSoundToPlay:: ; $dff8
    db
wNoiseEffectBeingPlayed:: ; $dff9
    db
wNoiseEffectFrameCounter:: ; $dffa
    db
wNoiseEffectFrameCounterThreshold:: ; dffb
    db
wNoiseEffectMiscCounter:: ; $dffc
    db