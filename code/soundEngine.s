INCLUDE "includes.s"

SECTION "Sound Engine", ROMX[$6480], BANK[$1]

SquareSoundEffectTable_Init:
	dw SquareEffectInit_MovingSelection
	dw SquareEffectInit_ConfirmOrLetterTyped
	dw SquareEffectInit_PieceRotated
	dw SquareEffectInit_PieceMovedHoriz
	dw SquareEffectInit_TetrisRowsFell
	dw SquareEffectInit_Non4LinesCleared
	dw SquareEffectInit_4LinesCleared
	dw SquareEffectInit_ReachedNextLevel

SquareSoundEffectTable_Update:
	dw SquareEffectUpdate_MovingSelection
	dw SquareEffectUpdate_Common
	dw SquareEffectUpdate_PieceRotated
	dw SquareEffectUpdate_Common
	dw SquareEffectUpdate_Common
	dw SquareEffectUpdate_Non4LinesCleared
	dw SquareEffectUpdate_4LinesCleared
	dw SquareEffectUpdate_ReachedNextLevel

	
NoiseSoundEffect_Init:
	dw NoiseEffectInit_TetrisRowsFell
	dw NoiseEffectInit_PieceHitFloor
	dw NoiseEffectInit_RocketGas
	dw NoiseEffectInit_RocketFire

NoiseSoundEffect_Update:
	dw NoiseEffectUpdate_Common
	dw NoiseEffectUpdate_Common
	dw NoiseEffectUpdate_Common
	dw NoiseEffectUpdate_RocketFire


SongsSoundChannelsData:
	dw Song1_SoundData
	dw Song2_SoundData
	dw Song3_SoundData
	dw Song4_SoundData
	dw Song5_SoundData
	dw Song6_SoundData
	dw Song7_SoundData
	dw Song8_SoundData
	dw Song9_SoundData
	dw Song10_SoundData
	dw Song11_SoundData
	dw Song12_SoundData
	dw Song13_SoundData
	dw Song14_SoundData
	dw Song15_SoundData
	dw Song16_SoundData
	dw Song17_SoundData


Stub:
	ret                                                        ; $64d2


UpdateSound:
; preserve regs
	push af                                                    ; $64d3
	push bc                                                    ; $64d4
	push de                                                    ; $64d5
	push hl                                                    ; $64d6

; check pause activity as priority
	ld   a, [wGamePausedActivity]                              ; $64d7
	cp   $01                                                   ; $64da
	jr   z, .gameJustPaused                                    ; $64dc

	cp   $02                                                   ; $64de
	jr   z, .gameJustUnpaused                                  ; $64e0

; when pause-related counter is set, process the pause sound
	ld   a, [wGamePausedSoundTimer]                            ; $64e2
	and  a                                                     ; $64e5
	jr   nz, .processPausedCounter                             ; $64e6

.endPath:
	ldh  a, [hPrevOrCurrDemoPlayed]                            ; $64e8
	and  a                                                     ; $64ea
	jr   z, .dontUnset                                         ; $64eb

; if a demo was just played, reset music+effects to play
	xor  a                                                     ; $64ed
	ld   [wSquareSoundToPlay], a                               ; $64ee
	ld   [wSongToStart], a                                     ; $64f1
	ld   [wWavSoundToPlay], a                                  ; $64f4
	ld   [wNoiseSoundToPlay], a                                ; $64f7

.dontUnset:
	call Stub                                                  ; $64fa

; process sound effects
	call UpdateSquareEffects                                   ; $64fd
	call UpdateNoiseEffects                                    ; $6500
	call UpdateWavEffects                                      ; $6503

; process music
	call InitSong                                              ; $6506
	call UpdateMusic.start                                     ; $6509
	call SetSongsAudTermRegs                                   ; $650c

.done:
; clear sounds to play, and just paused activity
	xor  a                                                     ; $650f
	ld   [wSquareSoundToPlay], a                               ; $6510
	ld   [wSongToStart], a                                     ; $6513
	ld   [wWavSoundToPlay], a                                  ; $6516
	ld   [wNoiseSoundToPlay], a                                ; $6519
	ld   [wGamePausedActivity], a                              ; $651c

; restore regs
	pop  hl                                                    ; $651f
	pop  de                                                    ; $6520
	pop  bc                                                    ; $6521
	pop  af                                                    ; $6522
	ret                                                        ; $6523

.gameJustPaused:
; sound regs cleared, clear sound effects being played
	call ResetSoundHwRegs                                      ; $6524
	xor  a                                                     ; $6527
	ld   [wSquareEffectBeingPlayed], a                         ; $6528
	ld   [wWavEffectBeingPlayed], a                            ; $652b
	ld   [wNoiseEffectBeingPlayed], a                          ; $652e

; set no sound effect in play (res bit 7) on all channel control bytes
	ld   hl, wAud3Struct+AUD_Control                           ; $6531
	res  7, [hl]                                               ; $6534
	ld   hl, wAud1Struct+AUD_Control                           ; $6536
	res  7, [hl]                                               ; $6539
	ld   hl, wAud2Struct+AUD_Control                           ; $653b
	res  7, [hl]                                               ; $653e
	ld   hl, wAud4Struct+AUD_Control                           ; $6540
	res  7, [hl]                                               ; $6543

; set default ram values
	ld   hl, DefaultWavRam                                     ; $6545
	call CopyFromHLintoWav3Ram                                 ; $6548

; initial countdown timer
	ld   a, $30                                                ; $654b
	ld   [wGamePausedSoundTimer], a                            ; $654d

.setAud2RegsToPause1:
; pattern is pause1-pause2-pause1-pause2
	ld   hl, Aud2RegVals_Pause1                                ; $6550

.copyIntoAud2Regs:
	call CopyDefaultValsInHLIntoAud2Regs                       ; $6553
	jr   .done                                                 ; $6556

.setAud2RegsToPause2:
	ld   hl, Aud2RegVals_Pause2                                ; $6558
	jr   .copyIntoAud2Regs                                     ; $655b

.gameJustUnpaused:
; process normal update sound
	xor  a                                                     ; $655d
	ld   [wGamePausedSoundTimer], a                            ; $655e
	jr   .endPath                                              ; $6561

.processPausedCounter:
	ld   hl, wGamePausedSoundTimer                             ; $6563
	dec  [hl]                                                  ; $6566

	ld   a, [hl]                                               ; $6567
	cp   $28                                                   ; $6568
	jr   z, .setAud2RegsToPause2                               ; $656a

	cp   $20                                                   ; $656c
	jr   z, .setAud2RegsToPause1                               ; $656e

	cp   $18                                                   ; $6570
	jr   z, .setAud2RegsToPause2                               ; $6572

; once we hit $10, inc to keep > 0
; (keep going down here instead of normal update sound)
	cp   $10                                                   ; $6574
	jr   nz, .done                                             ; $6576

	inc  [hl]                                                  ; $6578
	jr   .done                                                 ; $6579


Aud2RegVals_Pause1:
	db $b2, $e3, $83, $c7
	

Aud2RegVals_Pause2:
	db $b2, $e3, $c1, $c7
	

IsSoundEffect_MovingSelection:
	ld   a, [wWavEffectBeingPlayed]                            ; $6583
	cp   SND_MOVING_SELECTION                                  ; $6586
	ret                                                        ; $6588


IsSoundEffect_TetrisRowsFell:
	ld   a, [wSquareEffectBeingPlayed]                         ; $6589
	cp   SND_TETRIS_ROWS_FELL                                  ; $658c
	ret                                                        ; $658e


IsSoundEffect_4LinesCleared:
	ld   a, [wSquareEffectBeingPlayed]                         ; $658f
	cp   SND_4_LINES_CLEARED                                   ; $6592
	ret                                                        ; $6594


IsSoundEffect_ReachedNextLevel:
	ld   a, [wSquareEffectBeingPlayed]                         ; $6595
	cp   SND_REACHED_NEXT_LEVEL                                ; $6598
	ret                                                        ; $659a


Aud1RegValsInit_MovingSelection:
	db $00, $b5, $d0, $40, $c7


Aud1RegValsUpdate_MovingSelection:
	db $00, $b5, $20, $40, $c7
	

Aud1RegValsInit_ConfirmOrLetterTyped:
	db $00, $b6, $a1, $80, $c7


SquareEffectInit_MovingSelection:
	ld   a, $05                                                ; $65aa
	ld   hl, Aud1RegValsInit_MovingSelection                   ; $65ac
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $65af


; in: DE - dfe2
SquareEffectUpdate_MovingSelection:
; wait until delay counter hits threshold
	call IncCounterInDE_retZifHitsThreshold                    ; $65b2
	and  a                                                     ; $65b5
	ret  nz                                                    ; $65b6

; threshold hit
	ld   hl, wSquareEffectMiscCounter                          ; $65b7
	inc  [hl]                                                  ; $65ba

; 1 time, copy values into aud 1 regs
	ld   a, [hl]                                               ; $65bb
	cp   $02                                                   ; $65bc
	jr   z, ClearAud1RegsAndVars                               ; $65be

	ld   hl, Aud1RegValsUpdate_MovingSelection                 ; $65c0
	jp   CopyDefaultValsInHLIntoAud1Regs                       ; $65c3


SquareEffectInit_ConfirmOrLetterTyped:
	ld   a, $03                                                ; $65c6
	ld   hl, Aud1RegValsInit_ConfirmOrLetterTyped              ; $65c8
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $65cb


SquareEffectUpdate_Common:
; common effect is to clear regs and vars when threshold is hit
	call IncCounterInDE_retZifHitsThreshold                    ; $65ce
	and  a                                                     ; $65d1
	ret  nz                                                    ; $65d2

ClearAud1RegsAndVars:
	xor  a                                                     ; $65d3
	ld   [wSquareEffectBeingPlayed], a                         ; $65d4
	ldh  [rAUD1SWEEP], a                                       ; $65d7

; default envelope: increase
	ld   a, $08                                                ; $65d9
	ldh  [rAUD1ENV], a                                         ; $65db

; default high: restart sound
	ld   a, $80                                                ; $65dd
	ldh  [rAUD1HIGH], a                                        ; $65df

; sound effect no longer taking over
	ld   hl, wAud1Struct+AUD_Control                           ; $65e1
	res  7, [hl]                                               ; $65e4
	ret                                                        ; $65e6


Aud1RegVals_4LinesCleared_1:
	db $00, $80, $e1, $c1, $87


Aud1RegVals_4LinesCleared_2:
	db $00, $80, $e1, $ac, $87


SquareEffectInit_4LinesCleared:
	ld   hl, Aud1RegVals_4LinesCleared_1                       ; $65f1
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $65f4


SquareEffectUpdate_4LinesCleared:
	ld   hl, wSquareEffectMiscCounter                          ; $65f7
	inc  [hl]                                                  ; $65fa
	ld   a, [hl]                                               ; $65fb

; step 2 and 4, use sound 2
	cp   $04                                                   ; $65fc
	jr   z, .sound2                                            ; $65fe

; step 1 and 3, use sound 1
	cp   $0b                                                   ; $6600
	jr   z, .sound1                                            ; $6602

	cp   $0f                                                   ; $6604
	jr   z, .sound2                                            ; $6606

; step 4, use wav
	cp   $18                                                   ; $6608
	jp   z, .finalWav                                          ; $660a

	ret                                                        ; $660d

.finalWav:
; and clear aud 1 regs
	ld   a, WAV_AFTER_4_LINES_CLEARED                          ; $660e
	ld   hl, wWavSoundToPlay                                   ; $6610
	ld   [hl], a                                               ; $6613

	jp   ClearAud1RegsAndVars                                  ; $6614

.sound2:
	ld   hl, Aud1RegVals_4LinesCleared_2                       ; $6617
	jp   CopyDefaultValsInHLIntoAud1Regs                       ; $661a

.sound1:
	ld   hl, Aud1RegVals_4LinesCleared_1                       ; $661d
	jp   CopyDefaultValsInHLIntoAud1Regs                       ; $6620


Aud1RegValsInit_PieceMovedHoriz:
	db $48, $bc, $42, $66, $87


SquareEffectInit_PieceMovedHoriz:
; dont override other in-game effects
	call IsSoundEffect_MovingSelection                         ; $6628
	ret  z                                                     ; $662b

	call IsSoundEffect_ReachedNextLevel                        ; $662c
	ret  z                                                     ; $662f

	call IsSoundEffect_4LinesCleared                           ; $6630
	ret  z                                                     ; $6633

	call IsSoundEffect_TetrisRowsFell                          ; $6634
	ret  z                                                     ; $6637

; load regs with relevant vals
	ld   a, $02                                                ; $6638
	ld   hl, Aud1RegValsInit_PieceMovedHoriz                   ; $663a
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $663d


Aud1RegVals_ReachedNextLevel_0and4:
	db $00, $b0, $f1, $b6, $c7


Aud1RegVals_ReachedNextLevel_1:
	db $00, $b0, $f1, $c4, $c7 
	
	
Aud1RegVals_ReachedNextLevel_2:
	db $00, $b0, $f1, $ce, $c7


Aud1RegVals_ReachedNextLevel_3:
	db $00, $b0, $f1, $db, $c7


SquareEffectInit_ReachedNextLevel:
	call IsSoundEffect_4LinesCleared                           ; $6654
	ret  z                                                     ; $6657

	ld   a, $07                                                ; $6658
	ld   hl, Aud1RegVals_ReachedNextLevel_0and4                ; $665a
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $665d


SquareEffectUpdate_ReachedNextLevel:
; proceed when delay done
	call IncCounterInDE_retZifHitsThreshold                    ; $6660
	and  a                                                     ; $6663
	ret  nz                                                    ; $6664

; different effect at certain counter levels
	ld   hl, wSquareEffectMiscCounter                          ; $6665
	inc  [hl]                                                  ; $6668
	ld   a, [hl]                                               ; $6669
	cp   $01                                                   ; $666a
	jr   z, .sound1                                            ; $666c

	cp   $02                                                   ; $666e
	jr   z, .sound2                                            ; $6670

	cp   $03                                                   ; $6672
	jr   z, .sound3                                            ; $6674

	cp   $04                                                   ; $6676
	jr   z, .sound4                                            ; $6678

; finally clear
	cp   $05                                                   ; $667a
	jp   z, ClearAud1RegsAndVars                               ; $667c

	ret                                                        ; $667f

.sound1:
	ld   hl, Aud1RegVals_ReachedNextLevel_1                    ; $6680
	jr   .copyIntoAud1Regs                                     ; $6683

.sound2:
	ld   hl, Aud1RegVals_ReachedNextLevel_2                    ; $6685
	jr   .copyIntoAud1Regs                                     ; $6688

.sound3:
	ld   hl, Aud1RegVals_ReachedNextLevel_3                    ; $668a
	jr   .copyIntoAud1Regs                                     ; $668d

.sound4:
	ld   hl, Aud1RegVals_ReachedNextLevel_0and4                ; $668f

.copyIntoAud1Regs:
	jp   CopyDefaultValsInHLIntoAud1Regs                       ; $6692


Aud1RegValsInit_Non4LinesCleared:
	db $3e, $80, $e3, $00, $c4
	
	
Aud1EnvData_Non4LinesCleared:
	db $93, $83, $83, $73, $63, $53, $43, $33, $23, $13, $00


Aud1FreqLoData_Non4LinesCleared:
	db $00, $23, $43, $63, $83, $a3, $c3, $d3, $e3, $ff


SquareEffectInit_Non4LinesCleared:
; dont override other in-game effects
	call IsSoundEffect_MovingSelection                         ; $66af
	ret  z                                                     ; $66b2

	call IsSoundEffect_ReachedNextLevel                        ; $66b3
	ret  z                                                     ; $66b6

	call IsSoundEffect_4LinesCleared                           ; $66b7
	ret  z                                                     ; $66ba

	ld   a, $06                                                ; $66bb
	ld   hl, Aud1RegValsInit_Non4LinesCleared                  ; $66bd
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $66c0


SquareEffectUpdate_Non4LinesCleared:
	call IncCounterInDE_retZifHitsThreshold                    ; $66c3
	and  a                                                     ; $66c6
	ret  nz                                                    ; $66c7

; counter hit, get bc from counter
	ld   hl, wSquareEffectMiscCounter                          ; $66c8
	ld   c, [hl]                                               ; $66cb
	inc  [hl]                                                  ; $66cc
	ld   b, $00                                                ; $66cd

; get env val in E, and clear when at last value of $00
	ld   hl, Aud1EnvData_Non4LinesCleared                      ; $66cf
	add  hl, bc                                                ; $66d2
	ld   a, [hl]                                               ; $66d3
	and  a                                                     ; $66d4
	jp   z, ClearAud1RegsAndVars                               ; $66d5

	ld   e, a                                                  ; $66d8

; get freq lo from other table
	ld   hl, Aud1FreqLoData_Non4LinesCleared                   ; $66d9
	add  hl, bc                                                ; $66dc
	ld   a, [hl]                                               ; $66dd
	ld   d, a                                                  ; $66de

; freq hi
	ld   b, $86                                                ; $66df

SetAud1EnvLowHighToEDB:
	ld   c, LOW(rAUD1ENV)                                      ; $66e1
	ld   a, e                                                  ; $66e3
	ldh  [c], a                                                ; $66e4
	inc  c                                                     ; $66e5
	ld   a, d                                                  ; $66e6
	ldh  [c], a                                                ; $66e7
	inc  c                                                     ; $66e8
	ld   a, b                                                  ; $66e9
	ldh  [c], a                                                ; $66ea
	ret                                                        ; $66eb


Aud1RegValsInit_PieceRotated:
	db $3b, $80, $b2, $87, $87


Aud1EnvData_PieceRotated:
	db $a2, $93, $62, $43, $23, $00


Aud1FreqLoData_PieceRotated:
	db $80, $40, $80, $40, $80


SquareEffectInit_PieceRotated:
; dont override other in-game effects
	call IsSoundEffect_MovingSelection                         ; $66fc
	ret  z                                                     ; $66ff

	call IsSoundEffect_ReachedNextLevel                        ; $6700
	ret  z                                                     ; $6703

	call IsSoundEffect_4LinesCleared                           ; $6704
	ret  z                                                     ; $6707

	call IsSoundEffect_TetrisRowsFell                          ; $6708
	ret  z                                                     ; $670b

; actually set init regs
	ld   a, $03                                                ; $670c
	ld   hl, Aud1RegValsInit_PieceRotated                      ; $670e
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $6711


SquareEffectUpdate_PieceRotated:
; proceed when counter threshold hit
	call IncCounterInDE_retZifHitsThreshold                    ; $6714
	and  a                                                     ; $6717
	ret  nz                                                    ; $6718

; get misc counter in BC, then inc stored misc counter
	ld   hl, wSquareEffectMiscCounter                          ; $6719
	ld   c, [hl]                                               ; $671c
	inc  [hl]                                                  ; $671d
	ld   b, $00                                                ; $671e

; get E (env) from table, or clear aud 1 regs if 0 (last value)
	ld   hl, Aud1EnvData_PieceRotated                          ; $6720
	add  hl, bc                                                ; $6723
	ld   a, [hl]                                               ; $6724
	and  a                                                     ; $6725
	jp   z, ClearAud1RegsAndVars                               ; $6726

	ld   e, a                                                  ; $6729

; get associated D (freq lo) from other table
	ld   hl, Aud1FreqLoData_PieceRotated                       ; $672a
	add  hl, bc                                                ; $672d
	ld   a, [hl]                                               ; $672e
	ld   d, a                                                  ; $672f

; freq hi
	ld   b, $87                                                ; $6730
	jr   SetAud1EnvLowHighToEDB                                ; $6732


SquareEffectInit_TetrisRowsFell:
; dont play sound if 4 lines cleared music is playing
	call IsSoundEffect_4LinesCleared                           ; $6734
	ret  z                                                     ; $6737

	ld   a, $28                                                ; $6738
	ld   hl, Aud1RegValsInit_TetrisRowsFell                    ; $673a
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $673d


Aud1RegValsInit_TetrisRowsFell:
	db $b7, $80, $90, $ff, $83


Aud4RegValsInit_PieceHitFloor:
	db $00, $d1, $45, $80


Aud4RegValsInit_TetrisRowsFell:
	db $00, $f1, $54, $80


Aud4RegValsInit_RocketGas:
	db $00, $d5, $65, $80
	
	
Aud4RegValsInit_RocketFire:
	db $00, $70, $66, $80
	

Aud4RegValsUpdate_RocketFire_Poly:
	db $65, $65, $65, $64, $57, $56
	db $55, $54, $54, $54, $54, $54
	db $47, $46, $46, $45, $45, $45
	db $44, $44, $44, $34, $34, $34
	db $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $34, $34, $34


Aud4RegValsUpdate_RocketFire_Env:
	db $70, $60, $70, $70, $70, $80
	db $90, $a0, $d0, $f0, $e0, $d0
	db $c0, $b0, $a0, $90, $80, $70
	db $60, $50, $40, $30, $30, $20
	db $20, $20, $20, $20, $20, $20
	db $20, $20, $20, $20, $10, $10


NoiseEffectInit_RocketGas:
	ld   a, $30                                                ; $679d
	ld   hl, Aud4RegValsInit_RocketGas                         ; $679f
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $67a2


NoiseEffectInit_RocketFire:
	ld   a, $30                                                ; $67a5
	ld   hl, Aud4RegValsInit_RocketFire                        ; $67a7
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $67aa


NoiseEffectUpdate_RocketFire:
; proceed when delay finished
	call IncCounterInDE_retZifHitsThreshold                    ; $67ad
	and  a                                                     ; $67b0
	ret  nz                                                    ; $67b1

; use counter as table idx, stop sound when counter hits $24
	ld   hl, wNoiseEffectMiscCounter                           ; $67b2
	ld   a, [hl]                                               ; $67b5
	ld   c, a                                                  ; $67b6
	cp   $24                                                   ; $67b7
	jp   z, NoiseEffectUpdate_ClearNoise                       ; $67b9

	inc  [hl]                                                  ; $67bc

; first table in poly
	ld   b, $00                                                ; $67bd
	push bc                                                    ; $67bf
	ld   hl, Aud4RegValsUpdate_RocketFire_Poly                 ; $67c0
	add  hl, bc                                                ; $67c3
	ld   a, [hl]                                               ; $67c4
	ldh  [rAUD4POLY], a                                        ; $67c5

; second table in env
	pop  bc                                                    ; $67c7
	ld   hl, Aud4RegValsUpdate_RocketFire_Env                  ; $67c8
	add  hl, bc                                                ; $67cb
	ld   a, [hl]                                               ; $67cc
	ldh  [rAUD4ENV], a                                         ; $67cd

; restart sound
	ld   a, $80                                                ; $67cf
	ldh  [rAUD4GO], a                                          ; $67d1
	ret                                                        ; $67d3


NoiseEffectInit_TetrisRowsFell:
	ld   a, $20                                                ; $67d4
	ld   hl, Aud4RegValsInit_TetrisRowsFell                    ; $67d6
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $67d9


NoiseEffectInit_PieceHitFloor:
	ld   a, $12                                                ; $67dc
	ld   hl, Aud4RegValsInit_PieceHitFloor                     ; $67de
	jp   SetInitialRegValuesHLForSoundEffect_UpdateDelayA      ; $67e1


NoiseEffectUpdate_Common:
; simply clear noise when delay finished
	call IncCounterInDE_retZifHitsThreshold                    ; $67e4
	and  a                                                     ; $67e7
	ret  nz                                                    ; $67e8

NoiseEffectUpdate_ClearNoise:
; clear noise
	xor  a                                                     ; $67e9
	ld   [wNoiseEffectBeingPlayed], a                          ; $67ea

; default increase
	ld   a, $08                                                ; $67ed
	ldh  [rAUD4ENV], a                                         ; $67ef

; restart sound
	ld   a, $80                                                ; $67f1
	ldh  [rAUD4GO], a                                          ; $67f3

; tell music there's no sound being played
	ld   hl, wAud4Struct+AUD_Control                           ; $67f5
	res  7, [hl]                                               ; $67f8
	ret                                                        ; $67fa


Aud3RegValsInit_GameOver:
	db $80, $3a, $20, $60, $c6
	
	
WavEffectInit_GameOver:
	ld   hl, WavRam_Init_GameOver                              ; $6800
	call InitWavEffect_pauseOtherChannels                      ; $6803

; get val from $d0 to $ef and store
	ldh  a, [rDIV]                                             ; $6806
	and  $1f                                                   ; $6808
	ld   b, a                                                  ; $680a
	ld   a, $d0                                                ; $680b
	add  b                                                     ; $680d
	ld   [wWavEffectRandomVal], a                              ; $680e

; set default wav hw regs
	ld   hl, Aud3RegValsInit_GameOver                          ; $6811
	jp   CopyDefaultValsInHLIntoAud3Regs                       ; $6814


WavEffectUpdate_GameOver:
; random value between 0 and $0f in B (aud 3 low)
	ldh  a, [rDIV]                                             ; $6817
	and  $0f                                                   ; $6819
	ld   b, a                                                  ; $681b

; inc counter
	ld   hl, wWavEffectMiscCounter                             ; $681c
	inc  [hl]                                                  ; $681f
	ld   a, [hl]                                               ; $6820

; inc byte in random val twice while counter < $0e
	ld   hl, wWavEffectRandomVal                               ; $6821
	cp   $0e                                                   ; $6824
	jr   nc, .miscCounterGTE0eh                                ; $6826

	inc  [hl]                                                  ; $6828
	inc  [hl]                                                  ; $6829

.setAud3Low:
	ld   a, [hl]                                               ; $682a
	and  $f0                                                   ; $682b
	or   b                                                     ; $682d
	ld   c, LOW(rAUD3LOW)                                      ; $682e
	ldh  [c], a                                                ; $6830
	ret                                                        ; $6831

.miscCounterGTE0eh:
	cp   $1e                                                   ; $6832
	jp   z, ClearWavVarsAndRegs_ResumeMusic                    ; $6834

; misc counter >= $0e, but < $1e, dec random val 3 times
	dec  [hl]                                                  ; $6837
	dec  [hl]                                                  ; $6838
	dec  [hl]                                                  ; $6839
	jr   .setAud3Low                                           ; $683a


UpdateWavEffects:
; exec relevant init/update func
	ld   a, [wWavSoundToPlay]                                  ; $683c
	cp   WAV_AFTER_4_LINES_CLEARED                             ; $683f
	jp   z, WavEffectInit_After4LinesCleared                   ; $6841

	cp   WAV_GAME_OVER                                         ; $6844
	jp   z, WavEffectInit_GameOver                             ; $6846

	ld   a, [wWavEffectBeingPlayed]                            ; $6849
	cp   WAV_AFTER_4_LINES_CLEARED                             ; $684c
	jp   z, WavEffectUpdate_After4LinesCleared                 ; $684e

	cp   WAV_GAME_OVER                                         ; $6851
	jp   z, WavEffectUpdate_GameOver                           ; $6853

	ret                                                        ; $6856


Aud3RegValsInit_After4LinesCleared:
	db $80, $80, $20, $9d, $87


Aud3RegValsUpdate_After4LinesCleared_1:
	db $80, $f8, $20, $98, $87


Aud3RegValsUpdate_After4LinesCleared_2:
	db $80, $fb, $20, $96, $87


Aud3RegValsUpdate_After4LinesCleared_3:
	db $80, $f6, $20, $95, $87


WavEffectInit_After4LinesCleared:
; initial wav ram
	ld   hl, WavRam_Init_After4LinesCleared                    ; $686b
	call InitWavEffect_pauseOtherChannels                      ; $686e

; save current lo, and inc low over time
	ld   hl, Aud3RegValsInit_After4LinesCleared+3              ; $6871
	ld   a, [hl]                                               ; $6874
	ld   [wWavEffectCurrLoVal], a                              ; $6875

	ld   a, $01                                                ; $6878
	ld   [wWavEffectShouldIncOrDec], a                         ; $687a

; set reg vals
	ld   hl, Aud3RegValsInit_After4LinesCleared                ; $687d

.copyIntoAud3Regs:
	jp   CopyDefaultValsInHLIntoAud3Regs                       ; $6880


WavEffectUpdate_sound1:
; dont inc or dev
	ld   a, $00                                                ; $6883
	ld   [wWavEffectShouldIncOrDec], a                         ; $6885

	ld   hl, Aud3RegValsUpdate_After4LinesCleared_1+3          ; $6888
	ld   a, [hl]                                               ; $688b
	ld   [wWavEffectCurrLoVal], a                              ; $688c

	ld   hl, Aud3RegValsUpdate_After4LinesCleared_1            ; $688f
	jr   WavEffectInit_After4LinesCleared.copyIntoAud3Regs     ; $6892


WavEffectUpdate_sound2:
; inc low over time
	ld   a, $01                                                ; $6894
	ld   [wWavEffectShouldIncOrDec], a                         ; $6896

	ld   hl, Aud3RegValsUpdate_After4LinesCleared_2+3          ; $6899
	ld   a, [hl]                                               ; $689c
	ld   [wWavEffectCurrLoVal], a                              ; $689d

	ld   hl, Aud3RegValsUpdate_After4LinesCleared_2            ; $68a0
	jr   WavEffectInit_After4LinesCleared.copyIntoAud3Regs     ; $68a3


WavEffectUpdate_sound3:
; dec over time
	ld   a, $02                                                ; $68a5
	ld   [wWavEffectShouldIncOrDec], a                         ; $68a7

	ld   hl, Aud3RegValsUpdate_After4LinesCleared_3+3          ; $68aa
	ld   a, [hl]                                               ; $68ad
	ld   [wWavEffectCurrLoVal], a                              ; $68ae

	ld   hl, Aud3RegValsUpdate_After4LinesCleared_3            ; $68b1
	jr   WavEffectInit_After4LinesCleared.copyIntoAud3Regs     ; $68b4


WavEffectUpdate_After4LinesCleared:
; check misc counter
	ld   hl, wWavEffectMiscCounter                             ; $68b6
	inc  [hl]                                                  ; $68b9
	ld   a, [hl+]                                              ; $68ba
	cp   $09                                                   ; $68bb
	jr   z, WavEffectUpdate_sound1                             ; $68bd

	cp   $13                                                   ; $68bf
	jr   z, WavEffectUpdate_sound2                             ; $68c1

	cp   $17                                                   ; $68c3
	jr   z, WavEffectUpdate_sound3                             ; $68c5

; last counter to end effect
	cp   $20                                                   ; $68c7
	jr   z, ClearWavVarsAndRegs_ResumeMusic                    ; $68c9

; when above thresholds dont match, check if shoudl inc or dev (dff5)
	ld   a, [hl+]                                              ; $68cb
	cp   $00                                                   ; $68cc
	ret  z                                                     ; $68ce

	cp   $01                                                   ; $68cf
	jr   z, .incLowVal                                         ; $68d1

	cp   $02                                                   ; $68d3
	jr   z, .decLowVal                                         ; $68d5

	ret                                                        ; $68d7

; inc or dev curr low val (dff6)
.incLowVal:
	inc  [hl]                                                  ; $68d8
	inc  [hl]                                                  ; $68d9
	jr   .setLowVal                                            ; $68da

.decLowVal:
	dec  [hl]                                                  ; $68dc
	dec  [hl]                                                  ; $68dd

.setLowVal:
	ld   a, [hl]                                               ; $68de
	ldh  [rAUD3LOW], a                                         ; $68df
	ret                                                        ; $68e1

	
ClearWavVarsAndRegs_ResumeMusic:
	xor  a                                                     ; $68e2
	ld   [wWavEffectBeingPlayed], a                            ; $68e3
	ldh  [rAUD3ENA], a                                         ; $68e6

; resume music
	ld   hl, wAud3Struct+AUD_Control                           ; $68e8
	res  7, [hl]                                               ; $68eb
	ld   hl, wAud1Struct+AUD_Control                           ; $68ed
	res  7, [hl]                                               ; $68f0
	ld   hl, wAud2Struct+AUD_Control                           ; $68f2
	res  7, [hl]                                               ; $68f5
	ld   hl, wAud4Struct+AUD_Control                           ; $68f7
	res  7, [hl]                                               ; $68fa

; wav ram is based on if A Type or not
	ld   a, [wSongBeingPlayed]                                 ; $68fc
	cp   MUS_A_TYPE                                            ; $68ff
	jr   z, .isMusAType                                        ; $6901

	ld   hl, DefaultWavRam                                     ; $6903
	jr   InitWavEffect_pauseOtherChannels.copyToWavRam         ; $6906

.isMusAType:
	ld   hl, WavRam_6ec9                                       ; $6908
	jr   InitWavEffect_pauseOtherChannels.copyToWavRam         ; $690b


; in: HL - address of wav ram
InitWavEffect_pauseOtherChannels:
; set wav sound to being played
	push hl                                                    ; $690d
	ld   [wWavEffectBeingPlayed], a                            ; $690e

; tell music a wav effect is playing
	ld   hl, wAud3Struct+AUD_Control                           ; $6911
	set  7, [hl]                                               ; $6914

; clear counters, misc var and disable aud 3
	xor  a                                                     ; $6916
	ld   [wWavEffectMiscCounter], a                            ; $6917
	ld   [wWavEffectShouldIncOrDec], a                         ; $691a
	ld   [wWavEffectCurrLoVal], a                              ; $691d
	ldh  [rAUD3ENA], a                                         ; $6920

; prevent other channels from playing at the same time as a wav effect
	ld   hl, wAud1Struct+AUD_Control                           ; $6922
	set  7, [hl]                                               ; $6925
	ld   hl, wAud2Struct+AUD_Control                           ; $6927
	set  7, [hl]                                               ; $692a
	ld   hl, wAud4Struct+AUD_Control                           ; $692c
	set  7, [hl]                                               ; $692f
	pop  hl                                                    ; $6931

.copyToWavRam:
	call CopyFromHLintoWav3Ram                                 ; $6932
	ret                                                        ; $6935


; in: A - frames until sound effect plays
; in: DE - 3rd byte (frame counter) of sound effect struct
; in: HL - address of default reg vals
SetInitialRegValuesHLForSoundEffect_UpdateDelayA:
; set sound being played to orig idx
	push af                                                    ; $6936
	dec  e                                                     ; $6937
	ld   a, [wOrigSoundEffectIdx]                              ; $6938
	ld   [de], a                                               ; $693b
	inc  e                                                     ; $693c
	pop  af                                                    ; $693d

; orig A in sound effect struct frame counter threshold
	inc  e                                                     ; $693e
	ld   [de], a                                               ; $693f

; 0 in [de] frame counter, [de+2] misc counter and 
; [de+3] misc var 1, eg wav's should inc/dev or random val
	dec  e                                                     ; $6940
	xor  a                                                     ; $6941
	ld   [de], a                                               ; $6942

	inc  e                                                     ; $6943
	inc  e                                                     ; $6944
	ld   [de], a                                               ; $6945

	inc  e                                                     ; $6946
	ld   [de], a                                               ; $6947

; set defaults for relevant reg
	ld   a, e                                                  ; $6948
	cp   LOW(wSquareSoundToPlay+5)                             ; $6949
	jr   z, CopyDefaultValsInHLIntoAud1Regs                    ; $694b

	cp   LOW(wWavSoundToPlay+5)                                ; $694d
	jr   z, CopyDefaultValsInHLIntoAud3Regs                    ; $694f

	cp   LOW(wNoiseSoundToPlay+5)                              ; $6951
	jr   z, CopyDefaultValsInHLIntoAud4Regs                    ; $6953

	ret                                                        ; $6955


CopyDefaultValsInHLIntoAud1Regs:
	push bc                                                    ; $6956
	ld   c, LOW(rAUD1SWEEP)                                    ; $6957
	ld   b, rAUD1HIGH-rAUD1SWEEP+1                             ; $6959
	jr   CopyDefaultValsInHLIntoAudCRegs                       ; $695b


CopyDefaultValsInHLIntoAud2Regs:
	push bc                                                    ; $695d
	ld   c, LOW(rAUD2LEN)                                      ; $695e
	ld   b, rAUD2HIGH-rAUD2LEN+1                               ; $6960
	jr   CopyDefaultValsInHLIntoAudCRegs                       ; $6962


CopyDefaultValsInHLIntoAud3Regs:
	push bc                                                    ; $6964
	ld   c, LOW(rAUD3ENA)                                      ; $6965
	ld   b, rAUD3HIGH-rAUD3ENA+1                               ; $6967
	jr   CopyDefaultValsInHLIntoAudCRegs                       ; $6969


CopyDefaultValsInHLIntoAud4Regs:
	push bc                                                    ; $696b
	ld   c, LOW(rAUD4LEN)                                      ; $696c
	ld   b, rAUD4GO-rAUD4LEN+1                                 ; $696e

CopyDefaultValsInHLIntoAudCRegs:
.loop:
	ld   a, [hl+]                                              ; $6970
	ldh  [c], a                                                ; $6971
	inc  c                                                     ; $6972
	dec  b                                                     ; $6973
	jr   nz, .loop                                             ; $6974

	pop  bc                                                    ; $6976
	ret                                                        ; $6977


StoreOrigSoundEffectIdx_HLequAddressForSongData_tableHL_incEtwice:
	inc  e                                                     ; $6978
	ld   [wOrigSoundEffectIdx], a                              ; $6979

HLequAddressForSongData_tableHL_incE:
	inc  e                                                     ; $697c

; hl += 2(a-1)
	dec  a                                                     ; $697d
	sla  a                                                     ; $697e
	ld   c, a                                                  ; $6980
	ld   b, $00                                                ; $6981
	add  hl, bc                                                ; $6983

; get hl from [hl]
	ld   c, [hl]                                               ; $6984
	inc  hl                                                    ; $6985
	ld   b, [hl]                                               ; $6986
	ld   l, c                                                  ; $6987
	ld   h, b                                                  ; $6988

; A is also H
	ld   a, h                                                  ; $6989
	ret                                                        ; $698a


IncCounterInDE_retZifHitsThreshold:
	push de                                                    ; $698b
; inc byte in de
	ld   l, e                                                  ; $698c
	ld   h, d                                                  ; $698d
	inc  [hl]                                                  ; $698e

; if equal to [de+1]..
	ld   a, [hl+]                                              ; $698f
	cp   [hl]                                                  ; $6990
	jr   nz, .done                                             ; $6991

; clear [de]
	dec  l                                                     ; $6993
	xor  a                                                     ; $6994
	ld   [hl], a                                               ; $6995

.done:
	pop  de                                                    ; $6996
	ret                                                        ; $6997


CopyFromHLintoWav3Ram:
	push bc                                                    ; $6998
	ld   c, LOW(_AUD3WAVERAM)                                  ; $6999

.loop:
	ld   a, [hl+]                                              ; $699b
	ldh  [c], a                                                ; $699c
	inc  c                                                     ; $699d
	ld   a, c                                                  ; $699e
	cp   $40                                                   ; $699f
	jr   nz, .loop                                             ; $69a1

	pop  bc                                                    ; $69a3
	ret                                                        ; $69a4


InitSound:
; clear things being played, and any controls
	xor  a                                                     ; $69a5
	ld   [wSquareEffectBeingPlayed], a                         ; $69a6
	ld   [wSongBeingPlayed], a                                 ; $69a9
	ld   [wWavEffectBeingPlayed], a                            ; $69ac
	ld   [wNoiseEffectBeingPlayed], a                          ; $69af
	ld   [wAud1Struct+AUD_Control], a                          ; $69b2
	ld   [wAud2Struct+AUD_Control], a                          ; $69b5
	ld   [wAud3Struct+AUD_Control], a                          ; $69b8
	ld   [wAud4Struct+AUD_Control], a                          ; $69bb

; output to all terminals
	ld   a, $ff                                                ; $69be
	ldh  [rAUDTERM], a                                         ; $69c0

; make sure aud term filter func outputs to all
	ld   a, AUD_TERM_SPEC_OUTPUT_VAL                           ; $69c2
	ld   [wAudTermSongsSpec], a                                ; $69c4

ResetSoundHwRegs:
; default env (increase)
	ld   a, $08                                                ; $69c7
	ldh  [rAUD1ENV], a                                         ; $69c9
	ldh  [rAUD2ENV], a                                         ; $69cb
	ldh  [rAUD4ENV], a                                         ; $69cd

; restart sound
	ld   a, $80                                                ; $69cf
	ldh  [rAUD1HIGH], a                                        ; $69d1
	ldh  [rAUD2HIGH], a                                        ; $69d3
	ldh  [rAUD4GO], a                                          ; $69d5

; disable sweep and aud 3's wave
	xor  a                                                     ; $69d7
	ldh  [rAUD1SWEEP], a                                       ; $69d8
	ldh  [rAUD3ENA], a                                         ; $69da
	ret                                                        ; $69dc


UpdateSquareEffects:
	ld   de, wSquareSoundToPlay                                ; $69dd
	ld   a, [de]                                               ; $69e0
	and  a                                                     ; $69e1
	jr   z, .noSquareEffectToPlay                              ; $69e2

; play square effect, set ctrl bit so music doesn't play over
	ld   hl, wAud1Struct+AUD_Control                           ; $69e4
	set  7, [hl]                                               ; $69e7
	ld   hl, SquareSoundEffectTable_Init                       ; $69e9

; this func sets de to frame counter
	call StoreOrigSoundEffectIdx_HLequAddressForSongData_tableHL_incEtwice ; $69ec
	jp   hl                                                    ; $69ef

.noSquareEffectToPlay:
; check sound effect being played, and call its update func
	inc  e                                                     ; $69f0
	ld   a, [de]                                               ; $69f1
	and  a                                                     ; $69f2
	jr   z, .done                                              ; $69f3

	ld   hl, SquareSoundEffectTable_Update                     ; $69f5

; this func sets de to frame counter
	call HLequAddressForSongData_tableHL_incE                  ; $69f8
	jp   hl                                                    ; $69fb

.done:
	ret                                                        ; $69fc


UpdateNoiseEffects:
	ld   de, wNoiseSoundToPlay                                 ; $69fd
	ld   a, [de]                                               ; $6a00
	and  a                                                     ; $6a01
	jr   z, .noNoiseEffectToPlay                               ; $6a02

; play noise effect, set ctrl bit so music doesn't play over
	ld   hl, wAud4Struct+AUD_Control                           ; $6a04
	set  7, [hl]                                               ; $6a07
	ld   hl, NoiseSoundEffect_Init                             ; $6a09

; this func sets de to frame counter
	call StoreOrigSoundEffectIdx_HLequAddressForSongData_tableHL_incEtwice ; $6a0c
	jp   hl                                                    ; $6a0f

.noNoiseEffectToPlay:
; check noise effect being played, and call its update func
	inc  e                                                     ; $6a10
	ld   a, [de]                                               ; $6a11
	and  a                                                     ; $6a12
	jr   z, .done                                              ; $6a13

	ld   hl, NoiseSoundEffect_Update                           ; $6a15

; this func sets de to frame counter
	call HLequAddressForSongData_tableHL_incE                  ; $6a18
	jp   hl                                                    ; $6a1b

.done:
	ret                                                        ; $6a1c


; Basically inits sound data and regs, but is mute in the context used
MuteSound:
	call InitSound                                             ; $6a1d
	ret                                                        ; $6a20


InitSong:
; var is cleared later in UpdateSound, so init once
	ld   hl, wSongToStart                                      ; $6a21
	ld   a, [hl+]                                              ; $6a24
	and  a                                                     ; $6a25
	ret  z                                                     ; $6a26

; option to mute
	cp   MUS_MUTE                                              ; $6a27
	jr   z, MuteSound                                          ; $6a29

; set wSongBeingPlayed, then into B, to set up its vars
	ld   [hl], a                                               ; $6a2b
	ld   b, a                                                  ; $6a2c
	ld   hl, SongsSoundChannelsData                            ; $6a2d
	and  $1f                                                   ; $6a30
	call HLequAddressForSongData_tableHL_incE                  ; $6a32
	call SetSongsInitialSoundChannelVars                       ; $6a35

; get its aud term spec
	call SetSongsAudTermVars                                   ; $6a38
	ret                                                        ; $6a3b


SetSongsAudTermVars:
	ld   a, [wSongBeingPlayed]                                 ; $6a3c
	and  a                                                     ; $6a3f
	ret  z                                                     ; $6a40

; inc to address for song's aud term data
	ld   hl, SongAudTermData                                   ; $6a41

.nextSong:
	dec  a                                                     ; $6a44
	jr   z, .setSongVars                                       ; $6a45

	inc  hl                                                    ; $6a47
	inc  hl                                                    ; $6a48
	inc  hl                                                    ; $6a49
	inc  hl                                                    ; $6a4a
	jr   .nextSong                                             ; $6a4b

; then set, and clear counter + chosen output val
.setSongVars:
	ld   a, [hl+]                                              ; $6a4d
	ld   [wAudTermSongsSpec], a                                ; $6a4e
	ld   a, [hl+]                                              ; $6a51
	ld   [wAudTermCounterValueToHitToChangeOutput], a          ; $6a52
	ld   a, [hl+]                                              ; $6a55
	ld   [wAudTermOutputValue1], a                             ; $6a56
	ld   a, [hl+]                                              ; $6a59
	ld   [wAudTermOutputValue2], a                             ; $6a5a
	xor  a                                                     ; $6a5d
	ld   [wAudTermCounterUntilChangingOutput], a               ; $6a5e
	ld   [wAudTermSelectedOutputVal], a                        ; $6a61
	ret                                                        ; $6a64


SetSongsAudTermRegs:
; default aud term when no song chosen is to output to all
	ld   a, [wSongBeingPlayed]                                 ; $6a65
	and  a                                                     ; $6a68
	jr   z, .outputAllTo1and2terminal                          ; $6a69

	ld   hl, wAudTermCounterUntilChangingOutput                ; $6a6b

; use 1st output val if spec is 1
	ld   a, [wAudTermSongsSpec]                                ; $6a6e
	cp   AUD_TERM_SPEC_USE_1ST_OUTPUT_VAL                      ; $6a71
	jr   z, .use1stOutputValue                                 ; $6a73

; output to all if spec is 1
	cp   AUD_TERM_SPEC_OUTPUT_VAL                              ; $6a75
	jr   z, .outputAllTo1and2terminal                          ; $6a77

; inc aud term counter, if equal to threshold...
	inc  [hl]                                                  ; $6a79
	ld   a, [hl+]                                              ; $6a7a
	cp   [hl]                                                  ; $6a7b
	jr   nz, .notTimeToSwapOutput                              ; $6a7c

; reset wAudTermCounterUntilChangingOutput
	dec  l                                                     ; $6a7e
	ld   [hl], $00                                             ; $6a7f

; inc wAudTermSelectedOutputVal
	inc  l                                                     ; $6a81
	inc  l                                                     ; $6a82
	inc  [hl]                                                  ; $6a83

; B = 1st output val if wAudTermSelectedOutputVal even, else 2nd output val
	ld   a, [wAudTermOutputValue1]                             ; $6a84
	bit  0, [hl]                                               ; $6a87
	jp   z, .checkWavAndNoiseOutput                            ; $6a89

	ld   a, [wAudTermOutputValue2]                             ; $6a8c

.checkWavAndNoiseOutput:
	ld   b, a                                                  ; $6a8f

; set bit 2 and 6 (wave) of B if wave non-zero
	ld   a, [wWavEffectBeingPlayed]                            ; $6a90
	and  a                                                     ; $6a93
	jr   z, .afterDecidingWavOutput                            ; $6a94

	set  2, b                                                  ; $6a96
	set  6, b                                                  ; $6a98

.afterDecidingWavOutput:
; set bit 3 and 7 (noise) of B if noise non-zero
	ld   a, [wNoiseEffectBeingPlayed]                          ; $6a9a
	and  a                                                     ; $6a9d
	jr   z, .setAudTermToB                                     ; $6a9e

	set  3, b                                                  ; $6aa0
	set  7, b                                                  ; $6aa2

.setAudTermToB:
	ld   a, b                                                  ; $6aa4

.setAudTerm:
	ldh  [rAUDTERM], a                                         ; $6aa5
	ret                                                        ; $6aa7

.outputAllTo1and2terminal:
	ld   a, $ff                                                ; $6aa8
	jr   .setAudTerm                                           ; $6aaa

.use1stOutputValue:
	ld   a, [wAudTermOutputValue1]                             ; $6aac
	jr   .checkWavAndNoiseOutput                               ; $6aaf

.notTimeToSwapOutput:
; output to all if sound effect being played
	ld   a, [wNoiseEffectBeingPlayed]                          ; $6ab1
	and  a                                                     ; $6ab4
	jr   nz, .outputAllTo1and2terminal                         ; $6ab5

	ld   a, [wWavEffectBeingPlayed]                            ; $6ab7
	and  a                                                     ; $6aba
	jr   nz, .outputAllTo1and2terminal                         ; $6abb

	ret                                                        ; $6abd


SongAudTermData:
	db $01, $24, %11101111, $56
	db $01, $00, %11100101, $00
	db $01, $20, %11111101, $00
	db $01, $20, %11011110, $f7
	db $03, $18, $7f, $f7
	db $03, $18, $f7, $7f
	db $03, $48, $df, $5b
	db $01, $18, %11011011, $e7
	db $01, $00, %11111101, $f7
	db $03, $20, $7f, $f7
	db $01, $20, %11101101, $f7
	db $01, $20, %11101101, $f7
	db $01, $20, %11101101, $f7
	db $01, $20, %11101101, $f7
	db $01, $20, %11101101, $f7
	db $01, $20, %11101111, $f7
	db $01, $20, %11101111, $f7


; bc = [hl+1/hl], [de+1/de] = [bc+1/bc]
StoreWordInWordInHLintoDE:
	ld   a, [hl+]                                              ; $6b02
	ld   c, a                                                  ; $6b03
	ld   a, [hl]                                               ; $6b04
	ld   b, a                                                  ; $6b05
	ld   a, [bc]                                               ; $6b06
	ld   [de], a                                               ; $6b07
	inc  e                                                     ; $6b08
	inc  bc                                                    ; $6b09
	ld   a, [bc]                                               ; $6b0a
	ld   [de], a                                               ; $6b0b
	ret                                                        ; $6b0c


StoreWordInHLIintoDE:
	ld   a, [hl+]                                              ; $6b0d
	ld   [de], a                                               ; $6b0e
	inc  e                                                     ; $6b0f
	ld   a, [hl+]                                              ; $6b10
	ld   [de], a                                               ; $6b11
	ret                                                        ; $6b12


SetSongsInitialSoundChannelVars:
; reset regs and aud term counters
	call ResetSoundHwRegs                                      ; $6b13
	xor  a                                                     ; $6b16
	ld   [wAudTermCounterUntilChangingOutput], a               ; $6b17
	ld   [wAudTermSelectedOutputVal], a                        ; $6b1a

; unused 1st hl into df80
	ld   de, wUnused_df80                                      ; $6b1d
	ld   b, $00                                                ; $6b20
	ld   a, [hl+]                                              ; $6b22
	ld   [de], a                                               ; $6b23
	inc  e                                                     ; $6b24

; store address to song's tempo configs
	call StoreWordInHLIintoDE                                  ; $6b25

; start to pointing to first address for each sound channel
	ld   de, wAud1Struct+AUD_PointerToAddrContainingSoundData  ; $6b28
	call StoreWordInHLIintoDE                                  ; $6b2b
	ld   de, wAud2Struct+AUD_PointerToAddrContainingSoundData  ; $6b2e
	call StoreWordInHLIintoDE                                  ; $6b31
	ld   de, wAud3Struct+AUD_PointerToAddrContainingSoundData  ; $6b34
	call StoreWordInHLIintoDE                                  ; $6b37
	ld   de, wAud4Struct+AUD_PointerToAddrContainingSoundData  ; $6b3a
	call StoreWordInHLIintoDE                                  ; $6b3d

; store address pointed to
	ld   hl, wAud1Struct+AUD_PointerToAddrContainingSoundData  ; $6b40
	ld   de, wAud1Struct+AUD_AddressOfSoundData                ; $6b43
	call StoreWordInWordInHLintoDE                             ; $6b46
	ld   hl, wAud2Struct+AUD_PointerToAddrContainingSoundData  ; $6b49
	ld   de, wAud2Struct+AUD_AddressOfSoundData                ; $6b4c
	call StoreWordInWordInHLintoDE                             ; $6b4f
	ld   hl, wAud3Struct+AUD_PointerToAddrContainingSoundData  ; $6b52
	ld   de, wAud3Struct+AUD_AddressOfSoundData                ; $6b55
	call StoreWordInWordInHLintoDE                             ; $6b58
	ld   hl, wAud4Struct+AUD_PointerToAddrContainingSoundData  ; $6b5b
	ld   de, wAud4Struct+AUD_AddressOfSoundData                ; $6b5e
	call StoreWordInWordInHLintoDE                             ; $6b61

; set timer to play next note immediately..
	ldbc $04, AUD_SIZEOF                                       ; $6b64
	ld   hl, wAudStructs+AUD_FramesUntilNextNote               ; $6b67

.loop:
; by storing 1 in above, adding to get to next sound channel, for 4 sound channels
	ld   [hl], $01                                             ; $6b6a
	ld   a, c                                                  ; $6b6c
	add  l                                                     ; $6b6d
	ld   l, a                                                  ; $6b6e
	dec  b                                                     ; $6b6f
	jr   nz, .loop                                             ; $6b70

; clear envelope idxes for non-noise
	xor  a                                                     ; $6b72
	ld   [wAud1Struct+AUD_EnvelopeIndex], a                    ; $6b73
	ld   [wAud2Struct+AUD_EnvelopeIndex], a                    ; $6b76
	ld   [wAud3Struct+AUD_EnvelopeIndex], a                    ; $6b79
	ret                                                        ; $6b7c


ProcessSoundByte9dh_SetParams:
.aud3:
	push hl                                                    ; $6b7d

; aud 3 off, then copy from DE (1st 2 sound data bytes below) into wav ram
	xor  a                                                     ; $6b7e
	ldh  [rAUD3ENA], a                                         ; $6b7f
	ld   l, e                                                  ; $6b81
	ld   h, d                                                  ; $6b82
	call CopyFromHLintoWav3Ram                                 ; $6b83
	pop  hl                                                    ; $6b86
	jr   .end                                                  ; $6b87

.start:
; called with sound byte address (dfx4), get next sound data byte into E
	call IncWordInHL                                           ; $6b89
	call GetABInWordStoredInHL                                 ; $6b8c
	ld   e, a                                                  ; $6b8f

; get next sound data byte into D
	call IncWordInHL                                           ; $6b90
	call GetABInWordStoredInHL                                 ; $6b93
	ld   d, a                                                  ; $6b96

; get next sound data byte into C
	call IncWordInHL                                           ; $6b97
	call GetABInWordStoredInHL                                 ; $6b9a
	ld   c, a                                                  ; $6b9d

; SetParam bytes in dfx6, dfx7, dfx8, then dec back to sound channel address (dfx4)
	inc  l                                                     ; $6b9e
	inc  l                                                     ; $6b9f
	ld   [hl], e                                               ; $6ba0
	inc  l                                                     ; $6ba1
	ld   [hl], d                                               ; $6ba2
	inc  l                                                     ; $6ba3
	ld   [hl], c                                               ; $6ba4
	dec  l                                                     ; $6ba5
	dec  l                                                     ; $6ba6
	dec  l                                                     ; $6ba7
	dec  l                                                     ; $6ba8

; if aud 3, jump to copy to wav ram
	push hl                                                    ; $6ba9
	ld   hl, wCurrSoundChannelBeingProcessed                   ; $6baa
	ld   a, [hl]                                               ; $6bad
	pop  hl                                                    ; $6bae
	cp   $03                                                   ; $6baf
	jr   z, .aud3                                              ; $6bb1

.end:
; inc sound data byte address
	call IncWordInHL                                           ; $6bb3
	jp   UpdateMusic.processNextSoundByte                      ; $6bb6


IncWordInHL:
	push de                                                    ; $6bb9
	ld   a, [hl+]                                              ; $6bba
	ld   e, a                                                  ; $6bbb
	ld   a, [hl-]                                              ; $6bbc
	ld   d, a                                                  ; $6bbd
	inc  de                                                    ; $6bbe

.store:
	ld   a, e                                                  ; $6bbf
	ld   [hl+], a                                              ; $6bc0
	ld   a, d                                                  ; $6bc1
	ld   [hl-], a                                              ; $6bc2
	pop  de                                                    ; $6bc3
	ret                                                        ; $6bc4


IncWordTwiceInHL:
	push de                                                    ; $6bc5
	ld   a, [hl+]                                              ; $6bc6
	ld   e, a                                                  ; $6bc7
	ld   a, [hl-]                                              ; $6bc8
	ld   d, a                                                  ; $6bc9
	inc  de                                                    ; $6bca
	inc  de                                                    ; $6bcb
	jr   IncWordInHL.store                                     ; $6bcc


GetABInWordStoredInHL:
	ld   a, [hl+]                                              ; $6bce
	ld   c, a                                                  ; $6bcf
	ld   a, [hl-]                                              ; $6bd0
	ld   b, a                                                  ; $6bd1
	ld   a, [bc]                                               ; $6bd2
	ld   b, a                                                  ; $6bd3
	ret                                                        ; $6bd4


UpdateMusic:
; --
; -- When it's not time to process the next sound data byte
; --
.thunk_toNextSndChannelFromStructIdx2:
	pop  hl                                                    ; $6bd5
	jr   .toNextSndChannelFromStructIdx2                       ; $6bd6

.processCurrSoundByteEnvelope:
; jumped to with frames until next note (dfx2)
	ld   a, [wCurrSoundChannelBeingProcessed]                  ; $6bd8
	cp   $03                                                   ; $6bdb
	jr   nz, .passedWaveEnvelope                               ; $6bdd

; is wave, if output vol bit 7 clear, dont do 50% volume
	ld   a, [wAud3Struct+AUD_OutputVolume]                     ; $6bdf
	bit  7, a                                                  ; $6be2
	jr   z, .passedWaveEnvelope                                ; $6be4

	ld   a, [hl]                                               ; $6be6
	cp   $06                                                   ; $6be7
	jr   nz, .passedWaveEnvelope                               ; $6be9

; 50% volume
	ld   a, $40                                                ; $6beb
	ldh  [rAUD3LEVEL], a                                       ; $6bed

.passedWaveEnvelope:
; push frames until next note (dfx2), hl = bool is no envlope (dfxb)
	push hl                                                    ; $6bef
	ld   a, l                                                  ; $6bf0
	add  $09                                                   ; $6bf1
	ld   l, a                                                  ; $6bf3

; get A from it, if set, dont adjust with envlope
	ld   a, [hl]                                               ; $6bf4
	and  a                                                     ; $6bf5
	jr   nz, .thunk_toNextSndChannelFromStructIdx2             ; $6bf6

; if 0, hl = control (dfxf)
	ld   a, l                                                  ; $6bf8
	add  $04                                                   ; $6bf9
	ld   l, a                                                  ; $6bfb
	bit  7, [hl]                                               ; $6bfc
	jr   nz, .thunk_toNextSndChannelFromStructIdx2             ; $6bfe

; if bit 7 clear (no sound effect in play), write to regs with adjusted envlope
; pop frames until next note (dfx2)
	pop  hl                                                    ; $6c00
	call WriteToFrequencyRegsAdjustedWithEnvelope              ; $6c01

.toNextSndChannelFromStructIdx2:
; jumped here with hl = frames until next note (dfx2)
	dec  l                                                     ; $6c04
	dec  l                                                     ; $6c05
	jp   .toNextSndChannel                                     ; $6c06


; --
; -- When sound data byte == 0
; --
.setNextAddrInCurrSndChannelData:
; jumped here with sound data address (dfx4)
; inc word in pointer to that address (dfx0), ie to get next sound data address
	dec  l                                                     ; $6c09
	dec  l                                                     ; $6c0a
	dec  l                                                     ; $6c0b
	dec  l                                                     ; $6c0c
	call IncWordTwiceInHL                                      ; $6c0d

.afterSpecialSoundByteAddress:
; de = address containing sound bytes (dfx4)
	ld   a, l                                                  ; $6c10
	add  $04                                                   ; $6c11
	ld   e, a                                                  ; $6c13
	ld   d, h                                                  ; $6c14

; update addr containing data bytes (dfx4)
	call StoreWordInWordInHLintoDE                             ; $6c15

; parse special cases of new sound data addresses
; if a sound channel high byte produces $00, stop the song
	cp   $00                                                   ; $6c18
	jr   z, .stopCurrSong                                      ; $6c1a

; if it produces $ff, pointer to next sound data struct comes after
	cp   $ff                                                   ; $6c1c
	jr   z, .sndChannelAddrEquFFFFh                            ; $6c1e

; else jump down with frames until next note (dfx2)
	inc  l                                                     ; $6c20
	jp   .afterSettingSoundDataAddress                         ; $6c21

.sndChannelAddrEquFFFFh:
; push pointer to sound data bytes (dfx0)
	dec  l                                                     ; $6c24
	push hl                                                    ; $6c25

; val after pointer to sound data bytes in E
	call IncWordTwiceInHL                                      ; $6c26
	call GetABInWordStoredInHL                                 ; $6c29
	ld   e, a                                                  ; $6c2c

; val after in D
	call IncWordInHL                                           ; $6c2d
	call GetABInWordStoredInHL                                 ; $6c30
	ld   d, a                                                  ; $6c33
	pop  hl                                                    ; $6c34

; store de in pointer to sound data bytes (dfx0)
	ld   a, e                                                  ; $6c35
	ld   [hl+], a                                              ; $6c36
	ld   a, d                                                  ; $6c37
	ld   [hl-], a                                              ; $6c38
	jr   .afterSpecialSoundByteAddress                         ; $6c39

.stopCurrSong:
	ld   hl, wSongBeingPlayed                                  ; $6c3b
	ld   [hl], $00                                             ; $6c3e
	call InitSound                                             ; $6c40
	ret                                                        ; $6c43

; --
; -- Function entrypoint
; --
.start:
; return early if no song played
	ld   hl, wSongBeingPlayed                                  ; $6c44
	ld   a, [hl]                                               ; $6c47
	and  a                                                     ; $6c48
	ret  z                                                     ; $6c49

; start with aud 1
	ld   a, $01                                                ; $6c4a
	ld   [wCurrSoundChannelBeingProcessed], a                  ; $6c4c
	ld   hl, wAudStructs                                       ; $6c4f

.nextSoundChannel:
; if high byte of pointer to sound data address (dfx1) == 0, go to next sound channel
	inc  l                                                     ; $6c52
	ld   a, [hl+]                                              ; $6c53
	and  a                                                     ; $6c54
	jp   z, .toNextSndChannelFromStructIdx2                    ; $6c55

; dec frames until next note (dfx2), handle envelope if not at 0 yet
	dec  [hl]                                                  ; $6c58
	jp   nz, .processCurrSoundByteEnvelope                     ; $6c59

.afterSettingSoundDataAddress:
; inc to address of sound bytes (dfx4)
	inc  l                                                     ; $6c5c
	inc  l                                                     ; $6c5d

.processNextSoundByte:
; sound byte == 0, go to next block
	call GetABInWordStoredInHL                                 ; $6c5e
	cp   $00                                                   ; $6c61
	jp   z, .setNextAddrInCurrSndChannelData                   ; $6c63

; if $9d, load some bytes, then do another sound byte
	cp   $9d                                                   ; $6c66
	jp   z, ProcessSoundByte9dh_SetParams.start                ; $6c68

; jump if not tempo selection - high nybble of $a
	and  $f0                                                   ; $6c6b
	cp   $a0                                                   ; $6c6d
	jr   nz, .contSoundByte                                    ; $6c6f

; high nybble == $a, low nybble, in C
	ld   a, b                                                  ; $6c71
	and  $0f                                                   ; $6c72
	ld   c, a                                                  ; $6c74
	ld   b, $00                                                ; $6c75

; push sound byte address (dfx4), hl = tempo addr
	push hl                                                    ; $6c77
	ld   de, wSongTempoAddr                                    ; $6c78
	ld   a, [de]                                               ; $6c7b
	ld   l, a                                                  ; $6c7c
	inc  de                                                    ; $6c7d
	ld   a, [de]                                               ; $6c7e
	ld   h, a                                                  ; $6c7f

; get val from hl, indexed low nybble into A
	add  hl, bc                                                ; $6c80
	ld   a, [hl]                                               ; $6c81
	pop  hl                                                    ; $6c82

; store in frames between every note (dfx3)
	dec  l                                                     ; $6c83
	ld   [hl+], a                                              ; $6c84

; get next sound byte from address (dfx4)
	call IncWordInHL                                           ; $6c85
	call GetABInWordStoredInHL                                 ; $6c88

.contSoundByte:
; sound byte in bc, point to next sound byte
	ld   a, b                                                  ; $6c8b
	ld   c, a                                                  ; $6c8c
	ld   b, $00                                                ; $6c8d
	call IncWordInHL                                           ; $6c8f

; branch off if noise, rejoin when about to write to regs
	ld   a, [wCurrSoundChannelBeingProcessed]                  ; $6c92
	cp   $04                                                   ; $6c95
	jp   z, .getNoiseDataToWrite                               ; $6c97

; push sound channel address (dfx4), hl/de = aud frequency low byte (dfx9)
	push hl                                                    ; $6c9a
	ld   a, l                                                  ; $6c9b
	add  $05                                                   ; $6c9c
	ld   l, a                                                  ; $6c9e
	ld   e, l                                                  ; $6c9f
	ld   d, h                                                  ; $6ca0

; hl = bool is no envlope (dfxb)
	inc  l                                                     ; $6ca1
	inc  l                                                     ; $6ca2

; jump if sound byte == 1
	ld   a, c                                                  ; $6ca3
	cp   $01                                                   ; $6ca4
	jr   z, .soundByte01                                       ; $6ca6

; set curr sound channel freq bytes, in frequency (dfxa/dfx9)
	ld   [hl], $00                                             ; $6ca8
	ld   hl, FrequencyTable-2                                  ; $6caa
	add  hl, bc                                                ; $6cad
	ld   a, [hl+]                                              ; $6cae
	ld   [de], a                                               ; $6caf
	inc  e                                                     ; $6cb0
	ld   a, [hl]                                               ; $6cb1
	ld   [de], a                                               ; $6cb2

	pop  hl                                                    ; $6cb3
	jp   .getNonNoiseDataToWrite                               ; $6cb4

.soundByte01:
; bool is no envelope (dfxb) = 1, pop sound channel address (dfx4)
	ld   [hl], $01                                             ; $6cb7
	pop  hl                                                    ; $6cb9
	jr   .getNonNoiseDataToWrite                               ; $6cba

.getNoiseDataToWrite:
; BC = sound byte, 1-idx of aud env table
	push hl                                                    ; $6cbc
	ld   de, wAud4Struct+6                                     ; $6cbd
	ld   hl, NoiseStructBytes6toA-1                            ; $6cc0
	add  hl, bc                                                ; $6cc3

; copy to shadow hw regs (dfx6, dfx7, dfx8, dfx9, dfxa)
.noiseLoop:
	ld   a, [hl+]                                              ; $6cc4
	ld   [de], a                                               ; $6cc5
	inc  e                                                     ; $6cc6
	ld   a, e                                                  ; $6cc7
	cp   LOW(wAud4Struct+$b)                                   ; $6cc8
	jr   nz, .noiseLoop                                        ; $6cca

; starting hw reg
	ld   c, LOW(rAUD4LEN)                                      ; $6ccc
	ld   hl, wAud4Struct+AUD_AddressOfSoundData                ; $6cce
	jr   .afterChoosingSndChannelBaseReg                       ; $6cd1

.getNonNoiseDataToWrite:
; push hl = sound channel address (dfx4)
	push hl                                                    ; $6cd3

; branch based on current sound channel
	ld   a, [wCurrSoundChannelBeingProcessed]                  ; $6cd4
	cp   $01                                                   ; $6cd7
	jr   z, .startWritingToSq1                                 ; $6cd9

	cp   $02                                                   ; $6cdb
	jr   z, .startWritingToSq2                                 ; $6cdd

; is wave
	ld   c, LOW(rAUD3ENA)                                      ; $6cdf
	ld   a, [wAud3Struct+AUD_Control]                          ; $6ce1
	bit  7, a                                                  ; $6ce4
	jr   nz, .contWave                                         ; $6ce6

; no wav sound effect in play, clear enable and re-enable
	xor  a                                                     ; $6ce8
	ldh  [c], a                                                ; $6ce9
	ld   a, $80                                                ; $6cea
	ldh  [c], a                                                ; $6cec

.contWave:
; go to wav len
	inc  c                                                     ; $6ced

; go to wav struct len (dfx8)
	inc  l                                                     ; $6cee
	inc  l                                                     ; $6cef
	inc  l                                                     ; $6cf0
	inc  l                                                     ; $6cf1

; wav len = 0, output volume from param 3 (dfx8)
	ld   a, [hl+]                                              ; $6cf2
	ld   e, a                                                  ; $6cf3
	ld   d, $00                                                ; $6cf4
	jr   .fromWav                                              ; $6cf6

.startWritingToSq2:
	ld   c, LOW(rAUD2LEN)                                      ; $6cf8
	jr   .afterChoosingSndChannelBaseReg                       ; $6cfa

.startWritingToSq1:
	ld   c, LOW(rAUD1LEN)-1                                    ; $6cfc
	ld   a, $00                                                ; $6cfe
	inc  c                                                     ; $6d00

.afterChoosingSndChannelBaseReg:
; to high byte of wav ram address (dfx7), it's 0 if non-wav
	inc  l                                                     ; $6d01
	inc  l                                                     ; $6d02
	inc  l                                                     ; $6d03
	ld   a, [hl-]                                              ; $6d04
	and  a                                                     ; $6d05
	jr   nz, .hasWavRam                                        ; $6d06

; aud env for non-wav from (dfx6)
	ld   a, [hl+]                                              ; $6d08
	ld   e, a                                                  ; $6d09

.after_hasWavRam:
; struct byte after current in D (aud len / dfx8)
	inc  l                                                     ; $6d0a
	ld   a, [hl+]                                              ; $6d0b
	ld   d, a                                                  ; $6d0c

.fromWav:
; push frequency (dfx9), go to bool is no envlope (dfxb)
	push hl                                                    ; $6d0d
	inc  l                                                     ; $6d0e
	inc  l                                                     ; $6d0f

; if no envelope, set E (env) to 1
	ld   a, [hl+]                                              ; $6d10
	and  a                                                     ; $6d11
	jr   z, .afterDisabledEnvelopeCheck                        ; $6d12

	ld   e, $01                                                ; $6d14

.afterDisabledEnvelopeCheck:
; store 0 in envelope idx (dfxe)
	inc  l                                                     ; $6d16
	inc  l                                                     ; $6d17
	ld   [hl], $00                                             ; $6d18

; get a from envelope idx (dfxf), later skip hw reg writes if its bit 7 is set
; ie sound effect is playing over it
	inc  l                                                     ; $6d1a
	ld   a, [hl]                                               ; $6d1b

; pop frequency low (dfx9)
	pop  hl                                                    ; $6d1c
	bit  7, a                                                  ; $6d1d
	jr   nz, .skippingHwRegWrites                              ; $6d1f

; here we start writing to sound regs
; D in 1st (len)
	ld   a, d                                                  ; $6d21
	ldh  [c], a                                                ; $6d22
	inc  c                                                     ; $6d23

; E in 2nd (env)
	ld   a, e                                                  ; $6d24
	ldh  [c], a                                                ; $6d25
	inc  c                                                     ; $6d26

; aud frequency (dfx9, dfxa) in 3rd (freq lo) and 4th (freq hi)
	ld   a, [hl+]                                              ; $6d27
	ldh  [c], a                                                ; $6d28
	inc  c                                                     ; $6d29

; freq hi bit 7 set (sound restarts)
	ld   a, [hl]                                               ; $6d2a
	or   $80                                                   ; $6d2b
	ldh  [c], a                                                ; $6d2d

; unused: control byte (dfxf), res bit 0
	ld   a, l                                                  ; $6d2e
	or   $05                                                   ; $6d2f
	ld   l, a                                                  ; $6d31
	res  0, [hl]                                               ; $6d32

.skippingHwRegWrites:
; pop sound byte address (dfx4)
	pop  hl                                                    ; $6d34

; reset tempo counter (copy dfx3 into dfx2), then hl is struct start (dfx0)
	dec  l                                                     ; $6d35
	ld   a, [hl-]                                              ; $6d36
	ld   [hl-], a                                              ; $6d37
	dec  l                                                     ; $6d38

.toNextSndChannel:
; done once channel 4 is done
	ld   de, wCurrSoundChannelBeingProcessed                   ; $6d39
	ld   a, [de]                                               ; $6d3c
	cp   $04                                                   ; $6d3d
	jr   z, .done                                              ; $6d3f

; otherwise, set next snd channel to process, and jump to next struct
	inc  a                                                     ; $6d41
	ld   [de], a                                               ; $6d42
	ld   de, AUD_SIZEOF                                        ; $6d43
	add  hl, de                                                ; $6d46
	jp   .nextSoundChannel                                     ; $6d47

.done:
; inc all envelope idxes
	ld   hl, wAud1Struct+AUD_EnvelopeIndex                     ; $6d4a
	inc  [hl]                                                  ; $6d4d
	ld   hl, wAud2Struct+AUD_EnvelopeIndex                     ; $6d4e
	inc  [hl]                                                  ; $6d51
	ld   hl, wAud3Struct+AUD_EnvelopeIndex                     ; $6d52
	inc  [hl]                                                  ; $6d55
	ret                                                        ; $6d56

.hasWavRam:
; unused functionality, inc l due to using [hl-] previously
	ld   b, $00                                                ; $6d57
	push hl                                                    ; $6d59
	pop  hl                                                    ; $6d5a
	inc  l                                                     ; $6d5b
	jr   .after_hasWavRam                                      ; $6d5c


GetEinDEplusBdiv2:
	ld   a, b                                                  ; $6d5e
	srl  a                                                     ; $6d5f
	ld   l, a                                                  ; $6d61
	ld   h, $00                                                ; $6d62
	add  hl, de                                                ; $6d64
	ld   e, [hl]                                               ; $6d65
	ret                                                        ; $6d66


WriteToFrequencyRegsAdjustedWithEnvelope:
; push frames until next note (dfx2), hl = aud len (dfx8)
	push hl                                                    ; $6d67
	ld   a, l                                                  ; $6d68
	add  $06                                                   ; $6d69
	ld   l, a                                                  ; $6d6b

; if low nybble of aud len == 0, we're done
	ld   a, [hl]                                               ; $6d6c
	and  $0f                                                   ; $6d6d
	jr   z, .done                                              ; $6d6f

; store low nybble here (unused)
	ld   [wUnusedShadowAudLen], a                              ; $6d71

; jump to handler for sound channel
	ld   a, [wCurrSoundChannelBeingProcessed]                  ; $6d74
	ld   c, LOW(rAUD1LOW)                                      ; $6d77
	cp   $01                                                   ; $6d79
	jr   z, .sndChannels1to3                                   ; $6d7b

	ld   c, LOW(rAUD2LOW)                                      ; $6d7d
	cp   $02                                                   ; $6d7f
	jr   z, .sndChannels1to3                                   ; $6d81

	ld   c, LOW(rAUD3LOW)                                      ; $6d83
	cp   $03                                                   ; $6d85
	jr   z, .sndChannels1to3                                   ; $6d87

.done:
	pop  hl                                                    ; $6d89
	ret                                                        ; $6d8a

.sndChannels1to3:
; get de from frequency (dfxa/dfx9)
	inc  l                                                     ; $6d8b
	ld   a, [hl+]                                              ; $6d8c
	ld   e, a                                                  ; $6d8d
	ld   a, [hl]                                               ; $6d8e
	ld   d, a                                                  ; $6d8f

; push frequency
	push de                                                    ; $6d90

; hl = envelope idx (dfxe)
	ld   a, l                                                  ; $6d91
	add  $04                                                   ; $6d92
	ld   l, a                                                  ; $6d94

; idx in B
	ld   b, [hl]                                               ; $6d95
	ld   a, [wUnusedShadowAudLen]                              ; $6d96
	cp   $01                                                   ; $6d99
	jr   .lowNybble01                                          ; $6d9b

; unused
	cp   $03                                                   ; $6d9d
	jr   .lowNybble03                                          ; $6d9f

.lowNybble03:
; -1 frequency
	ld   hl, $ffff                                             ; $6da1
	jr   .end                                                  ; $6da4

.lowNybble01:
	ld   de, EnvelopeData                                      ; $6da6
	call GetEinDEplusBdiv2                                     ; $6da9

; get relevant nybble of envelope byte
	bit  0, b                                                  ; $6dac
	jr   nz, .afterEnvelopeNybbleInE                           ; $6dae

	swap e                                                     ; $6db0

.afterEnvelopeNybbleInE:
; store low nybble in A
	ld   a, e                                                  ; $6db2
	and  $0f                                                   ; $6db3

; if highest bit of nybble unset, positive adjust
	bit  3, a                                                  ; $6db5
	jr   z, .getPositiveHighAdjust                             ; $6db7

; else negative
	ld   h, $ff                                                ; $6db9
	or   $f0                                                   ; $6dbb
	jr   .afterGettingEnvelopeAdjust                           ; $6dbd

.getPositiveHighAdjust:
	ld   h, $00                                                ; $6dbf

.afterGettingEnvelopeAdjust:
	ld   l, a                                                  ; $6dc1

.end:
; pop frequency, adjust with hl, and write to regs
	pop  de                                                    ; $6dc2
	add  hl, de                                                ; $6dc3
	ld   a, l                                                  ; $6dc4
	ldh  [c], a                                                ; $6dc5
	inc  c                                                     ; $6dc6
	ld   a, h                                                  ; $6dc7
	ldh  [c], a                                                ; $6dc8
	jr   .done                                                 ; $6dc9


INCLUDE "data/songData.s"


SECTION "Sound Thunk Funcs", ROMX[$7ff0], BANK[$1]

ThunkUpdateSound::
	jp   UpdateSound                                           ; $7ff0


ThunkInitSound::
	jp   InitSound                                             ; $7ff3
