EnvelopeData:
	db $00, $00, $00, $00, $00, $00, $10, $00
	db $0f, $00, $00, $11, $00, $0f, $f0, $01
	db $12, $10, $ff, $ef, $01, $12, $10, $ff
	db $ef, $01, $12, $10, $ff, $ef, $01, $12
	db $10, $ff, $ef, $01, $12, $10, $ff, $ef
	db $01, $12, $10, $ff, $ef, $01, $12, $10
	db $ff, $ef, $01, $12, $10, $ff, $ef, $00
	db $0f


FrequencyTable:
	dw $002c ; C2
	dw $009c
	dw $0106
	dw $016b
	dw $01c9
	dw $0223
	dw $0277
	dw $02c6
	dw $0312
	dw $0356
	dw $039b
	dw $03da
	dw $0416 ; C3
	dw $044e
	dw $0483
	dw $04b5
	dw $04e5
	dw $0511
	dw $053b
	dw $0563
	dw $0589
	dw $05ac
	dw $05ce
	dw $05ed
	dw $060a ; C4
	dw $0627 ; C#4
	dw $0642 ; D4
	dw $065b ; D#4
	dw $0672
	dw $0689
	dw $069e
	dw $06b2
	dw $06c4
	dw $06d6
	dw $06e7
	dw $06f7
	dw $0706 ; C5
	dw $0714
	dw $0721
	dw $072d
	dw $0739
	dw $0744
	dw $074f
	dw $0759
	dw $0762
	dw $076b
	dw $0773
	dw $077b
	dw $0783 ; C6
	dw $078a
	dw $0790
	dw $0797
	dw $079d
	dw $07a2
	dw $07a7
	dw $07ac
	dw $07b1
	dw $07b6
	dw $07ba
	dw $07be
	dw $07c1 ; C7
	dw $07c4
	dw $07c8
	dw $07cb
	dw $07ce
	dw $07d1
	dw $07d4
	dw $07d6
	dw $07d9
	dw $07db
	dw $07dd
	dw $07df ; B7


UnusedNop:
	nop


NoiseStructBytes6toA:
	db $00, $00, $00, $00, $c0
	db $a1, $00, $3a, $00, $c0
	db $b1, $00, $29, $01, $c0
	db $61, $00, $3a, $00, $c0


WavRam_Init_After4LinesCleared:
	db $12, $34, $45, $67, $9a, $bc, $de, $fe
	db $98, $7a, $b7, $be, $a8, $76, $54, $31
	
	
UnusedWavRam:
	db $01, $23, $44, $55, $67, $88, $9a, $bb
	db $a9, $88, $76, $55, $44, $33, $22, $11
	
	
WavRam_6ec9:
	db $01, $23, $45, $67, $89, $ab, $cd, $ef
	db $fe, $dc, $ba, $98, $76, $54, $32, $10


WavRam_Init_GameOver:
	db $a1, $82, $23, $34, $45, $56, $67, $78
	db $89, $9a, $ab, $bc, $cd, $64, $32, $10


DefaultWavRam:
	db $11, $23, $56, $78, $99, $98, $76, $67
	db $9a, $df, $fe, $c9, $85, $42, $11, $31
	
	
TemposTable_6ef9:
	db $02, $04, $08, $10, $20, $40, $0c, $18
	db $30, $05, $00, $01
	
TemposTable_6f05:
	db $03, $05, $0a, $14, $28, $50, $0f, $1e
	db $3c

; only 16 entries allowed per table, so unused ones in below 2 tables
TemposTable_6f0e:
	db $03, $06, $0c, $18, $30, $60, $12, $24
	db $48, $08, $10, $00, $07, $0e, $1c, $38
	db $70, $15, $2a, $54, $04, $08, $10, $20
	db $40, $80, $18, $30, $60

TemposTable_6f2b:
	db $04, $09, $12, $24, $48, $90, $1b, $36
	db $6c, $0c, $18, $04, $0a, $14, $28, $50
	db $a0, $1e, $3c, $78

Song1_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song1_Sq1Data
	dw $7cff
	dw $7d11
	dw $7d21

Song2_SoundData:
	db $00
	dw TemposTable_6f05
	dw $7e48
	dw $7e44
	dw $7e4a
	dw $7e4c

Song3_SoundData:
	db $00 ; $df80
	dw TemposTable_6f0e
	dw Song3_Sq1Data
	dw Song3_Sq2Data
	dw Song3_WavData
	dw Song3_NoiseData

Song4_SoundData:
	db $00
	dw TemposTable_6ef9
	dw $7600
	dw $75fc
	dw $7602
	dw $0000

Song5_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $714c
	dw $7142
	dw $7156
	dw $7162

Song6_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $72c6
	dw $72b8
	dw $72d4
	dw $7302

Song7_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song7_Sq1Data
	dw Song7_Sq2Data
	dw $0000
	dw $0000

Song8_SoundData:
	db $00
	dw TemposTable_6f05
	dw $7e9d
	dw $7e91
	dw $7ea9
	dw $7eb5

Song9_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $7c28
	dw $7c24
	dw $7c2a
	dw $7c2c

Song10_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $0000
	dw $7a00
	dw $0000
	dw $0000

Song11_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $0000
	dw $7a26
	dw $7a2a
	dw $0000

Song12_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $7a73
	dw $7a6f
	dw $7a75
	dw $0000

Song13_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $7adf
	dw $7ae3
	dw $7ae5
	dw $7ae7

Song14_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $7b65
	dw $7b6b
	dw $7b6f
	dw $7b73

Song15_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $786c
	dw $7876
	dw $787e
	dw $7886

Song16_SoundData:
	db $00
	dw TemposTable_6f2b
	dw $7543
	dw $754b
	dw $7551
	dw $0000

Song17_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $758d
	dw $7595
	dw $759b
	dw $0000


Song7_Sq2Data:
.start:
	dw Song7_Sq2_Section1Data
	dw $7034
	dw $7016
	dw $704d
	dw $7093
	JumpSection .start
	

Song7_Sq1Data:
	db $62
	ld   [hl], b                                     ; $7009: $70
	ld   [hl], h                                     ; $700a: $74
	ld   [hl], b                                     ; $700b: $70
	ld   h, d                                        ; $700c: $62
	ld   [hl], b                                     ; $700d: $70
	add  l                                           ; $700e: $85
	ld   [hl], b                                     ; $700f: $70
	db   $f4                                         ; $7010: $f4
	ld   [hl], b                                     ; $7011: $70
	rst  $38                                         ; $7012: $ff
	rst  $38                                         ; $7013: $ff
	db $08, $70 
	

Song7_Sq2_Section1Data:
	db $9d
	ld   [hl], h                                     ; $7017: $74

jr_001_7018:
	nop                                              ; $7018: $00
	ld   b, c                                        ; $7019: $41
	and  d                                           ; $701a: $a2
	ld   b, h                                        ; $701b: $44
	ld   c, h                                        ; $701c: $4c
	ld   d, [hl]                                     ; $701d: $56
	ld   c, h                                        ; $701e: $4c
	ld   b, d                                        ; $701f: $42

jr_001_7020:
	ld   c, h                                        ; $7020: $4c
	ld   b, h                                        ; $7021: $44
	ld   c, h                                        ; $7022: $4c
	ld   a, $4c                                      ; $7023: $3e $4c
	inc  a                                           ; $7025: $3c
	ld   c, h                                        ; $7026: $4c
	ld   b, h                                        ; $7027: $44
	ld   c, h                                        ; $7028: $4c
	ld   d, [hl]                                     ; $7029: $56
	ld   c, h                                        ; $702a: $4c
	ld   b, d                                        ; $702b: $42
	ld   c, h                                        ; $702c: $4c
	ld   b, h                                        ; $702d: $44
	ld   c, h                                        ; $702e: $4c
	ld   a, $4c                                      ; $702f: $3e $4c
	inc  a                                           ; $7031: $3c
	ld   c, h                                        ; $7032: $4c
	nop                                              ; $7033: $00
	ld   b, h                                        ; $7034: $44
	ld   c, h                                        ; $7035: $4c
	ld   b, h                                        ; $7036: $44
	ld   a, $4e                                      ; $7037: $3e $4e
	ld   c, b                                        ; $7039: $48
	ld   b, d                                        ; $703a: $42
	ld   c, b                                        ; $703b: $48
	ld   b, d                                        ; $703c: $42
	ld   a, [hl-]                                    ; $703d: $3a
	ld   c, h                                        ; $703e: $4c
	ld   b, h                                        ; $703f: $44
	ld   a, $4c                                      ; $7040: $3e $4c
	ld   c, b                                        ; $7042: $48
	ld   b, h                                        ; $7043: $44
	ld   b, d                                        ; $7044: $42
	ld   a, $3c                                      ; $7045: $3e $3c
	inc  [hl]                                        ; $7047: $34
	inc  a                                           ; $7048: $3c
	ld   b, d                                        ; $7049: $42
	ld   c, h                                        ; $704a: $4c
	ld   c, b                                        ; $704b: $48
	nop                                              ; $704c: $00
	ld   b, h                                        ; $704d: $44
	ld   c, h                                        ; $704e: $4c
	ld   b, h                                        ; $704f: $44
	ld   a, $4e                                      ; $7050: $3e $4e
	ld   c, b                                        ; $7052: $48
	ld   b, d                                        ; $7053: $42
	ld   c, b                                        ; $7054: $48
	ld   b, d                                        ; $7055: $42
	ld   a, [hl-]                                    ; $7056: $3a
	ld   d, d                                        ; $7057: $52
	ld   c, b                                        ; $7058: $48
	ld   c, h                                        ; $7059: $4c
	ld   d, d                                        ; $705a: $52
	ld   c, h                                        ; $705b: $4c
	ld   b, h                                        ; $705c: $44
	ld   a, [hl-]                                    ; $705d: $3a
	ld   b, d                                        ; $705e: $42
	xor  b                                           ; $705f: $a8
	ld   b, h                                        ; $7060: $44
	nop                                              ; $7061: $00
	sbc  l                                           ; $7062: $9d
	ld   h, h                                        ; $7063: $64
	nop                                              ; $7064: $00
	ld   b, c                                        ; $7065: $41
	and  e                                           ; $7066: $a3
	ld   h, $3e                                      ; $7067: $26 $3e
	inc  a                                           ; $7069: $3c
	ld   h, $2c                                      ; $706a: $26 $2c
	inc  [hl]                                        ; $706c: $34
	ld   a, $36                                      ; $706d: $3e $36
	inc  [hl]                                        ; $706f: $34
	ld   a, $2c                                      ; $7070: $3e $2c
	inc  [hl]                                        ; $7072: $34
	nop                                              ; $7073: $00
	ld   h, $3e                                      ; $7074: $26 $3e
	jr   nc, jr_001_709a                             ; $7076: $30 $22

	ld   a, [hl-]                                    ; $7078: $3a
	inc  l                                           ; $7079: $2c
	ld   e, $36                                      ; $707a: $1e $36
	jr   nc, jr_001_7020                             ; $707c: $30 $a2

	inc  [hl]                                        ; $707e: $34
	ld   [hl], $34                                   ; $707f: $36 $34
	jr   nc, jr_001_70af                             ; $7081: $30 $2c

	ld   a, [hl+]                                    ; $7083: $2a
	nop                                              ; $7084: $00
	and  e                                           ; $7085: $a3
	ld   h, $3e                                      ; $7086: $26 $3e
	jr   nc, jr_001_70ac                             ; $7088: $30 $22

	ld   a, [hl-]                                    ; $708a: $3a
	ld   a, [hl+]                                    ; $708b: $2a
	inc  l                                           ; $708c: $2c
	inc  [hl]                                        ; $708d: $34
	inc  [hl]                                        ; $708e: $34
	inc  l                                           ; $708f: $2c
	ld   [hl+], a                                    ; $7090: $22
	inc  d                                           ; $7091: $14
	nop                                              ; $7092: $00
	and  d                                           ; $7093: $a2
	ld   d, d                                        ; $7094: $52
	ld   c, [hl]                                     ; $7095: $4e
	ld   c, h                                        ; $7096: $4c
	ld   c, b                                        ; $7097: $48
	ld   b, h                                        ; $7098: $44
	ld   b, d                                        ; $7099: $42

jr_001_709a:
	ld   b, h                                        ; $709a: $44
	ld   c, b                                        ; $709b: $48
	ld   c, h                                        ; $709c: $4c
	ld   b, h                                        ; $709d: $44
	ld   c, b                                        ; $709e: $48
	ld   c, [hl]                                     ; $709f: $4e
	ld   c, h                                        ; $70a0: $4c
	ld   c, [hl]                                     ; $70a1: $4e
	and  e                                           ; $70a2: $a3
	ld   d, d                                        ; $70a3: $52
	ld   b, d                                        ; $70a4: $42
	and  d                                           ; $70a5: $a2
	ld   b, h                                        ; $70a6: $44
	ld   c, b                                        ; $70a7: $48
	and  e                                           ; $70a8: $a3
	ld   c, h                                        ; $70a9: $4c
	ld   c, b                                        ; $70aa: $48
	ld   c, h                                        ; $70ab: $4c

jr_001_70ac:
	ld   d, [hl]                                     ; $70ac: $56
	ld   d, b                                        ; $70ad: $50
	and  d                                           ; $70ae: $a2

jr_001_70af:
	ld   d, [hl]                                     ; $70af: $56
	ld   e, d                                        ; $70b0: $5a
	and  e                                           ; $70b1: $a3
	ld   e, h                                        ; $70b2: $5c
	ld   e, d                                        ; $70b3: $5a
	and  d                                           ; $70b4: $a2
	ld   d, [hl]                                     ; $70b5: $56
	ld   d, d                                        ; $70b6: $52
	ld   d, b                                        ; $70b7: $50
	ld   c, h                                        ; $70b8: $4c
	ld   d, b                                        ; $70b9: $50
	ld   c, d                                        ; $70ba: $4a
	xor  b                                           ; $70bb: $a8
	ld   c, h                                        ; $70bc: $4c

jr_001_70bd:
	and  a                                           ; $70bd: $a7
	ld   d, d                                        ; $70be: $52
	and  c                                           ; $70bf: $a1
	ld   d, [hl]                                     ; $70c0: $56
	ld   e, b                                        ; $70c1: $58
	and  e                                           ; $70c2: $a3
	ld   d, [hl]                                     ; $70c3: $56
	and  d                                           ; $70c4: $a2
	ld   d, d                                        ; $70c5: $52
	ld   c, [hl]                                     ; $70c6: $4e
	ld   d, d                                        ; $70c7: $52
	ld   c, h                                        ; $70c8: $4c
	ld   c, [hl]                                     ; $70c9: $4e
	ld   c, b                                        ; $70ca: $48
	and  a                                           ; $70cb: $a7
	ld   d, [hl]                                     ; $70cc: $56
	and  c                                           ; $70cd: $a1
	ld   e, d                                        ; $70ce: $5a

jr_001_70cf:
	ld   e, h                                        ; $70cf: $5c
	and  e                                           ; $70d0: $a3
	ld   e, d                                        ; $70d1: $5a
	and  d                                           ; $70d2: $a2
	ld   d, [hl]                                     ; $70d3: $56
	ld   d, h                                        ; $70d4: $54
	ld   d, [hl]                                     ; $70d5: $56
	ld   d, b                                        ; $70d6: $50
	ld   d, h                                        ; $70d7: $54
	ld   c, h                                        ; $70d8: $4c
	ld   e, d                                        ; $70d9: $5a
	ld   d, h                                        ; $70da: $54
	ld   c, h                                        ; $70db: $4c

jr_001_70dc:
	ld   d, h                                        ; $70dc: $54
	ld   e, d                                        ; $70dd: $5a
	ld   h, b                                        ; $70de: $60
	ld   h, [hl]                                     ; $70df: $66
	ld   d, h                                        ; $70e0: $54
	ld   h, h                                        ; $70e1: $64
	ld   d, h                                        ; $70e2: $54
	ld   h, b                                        ; $70e3: $60
	ld   d, h                                        ; $70e4: $54
	and  e                                           ; $70e5: $a3
	ld   e, h                                        ; $70e6: $5c
	and  d                                           ; $70e7: $a2
	ld   h, b                                        ; $70e8: $60
	ld   e, h                                        ; $70e9: $5c
	ld   e, d                                        ; $70ea: $5a
	ld   e, h                                        ; $70eb: $5c
	and  c                                           ; $70ec: $a1
	ld   d, [hl]                                     ; $70ed: $56
	ld   e, d                                        ; $70ee: $5a
	and  h                                           ; $70ef: $a4
	ld   d, [hl]                                     ; $70f0: $56
	and  d                                           ; $70f1: $a2
	ld   bc, $a200                                   ; $70f2: $01 $00 $a2
	inc  [hl]                                        ; $70f5: $34
	ld   a, [hl-]                                    ; $70f6: $3a
	ld   b, h                                        ; $70f7: $44
	ld   a, [hl-]                                    ; $70f8: $3a
	jr   nc, jr_001_7135                             ; $70f9: $30 $3a

	inc  [hl]                                        ; $70fb: $34
	ld   a, [hl-]                                    ; $70fc: $3a
	inc  l                                           ; $70fd: $2c
	ld   a, [hl-]                                    ; $70fe: $3a
	ld   a, [hl+]                                    ; $70ff: $2a
	ld   a, [hl-]                                    ; $7100: $3a
	inc  l                                           ; $7101: $2c
	ld   a, [hl-]                                    ; $7102: $3a
	ld   b, h                                        ; $7103: $44
	ld   a, [hl-]                                    ; $7104: $3a
	jr   nc, @+$3c                                   ; $7105: $30 $3a

	inc  [hl]                                        ; $7107: $34
	ld   a, [hl-]                                    ; $7108: $3a
	inc  l                                           ; $7109: $2c
	ld   a, [hl-]                                    ; $710a: $3a
	ld   a, [hl+]                                    ; $710b: $2a
	ld   a, [hl-]                                    ; $710c: $3a
	inc  l                                           ; $710d: $2c
	inc  [hl]                                        ; $710e: $34
	inc  l                                           ; $710f: $2c
	ld   h, $3e                                      ; $7110: $26 $3e
	jr   c, jr_001_7146                              ; $7112: $38 $32

	jr   c, jr_001_7140                              ; $7114: $38 $2a

	jr   c, jr_001_714a                              ; $7116: $38 $32

	jr   c, jr_001_70bd                              ; $7118: $38 $a3

	inc  [hl]                                        ; $711a: $34
	ld   b, d                                        ; $711b: $42
	ld   a, [hl+]                                    ; $711c: $2a
	and  d                                           ; $711d: $a2
	inc  [hl]                                        ; $711e: $34
	ld   a, [hl-]                                    ; $711f: $3a
	ld   b, d                                        ; $7120: $42
	ld   a, [hl-]                                    ; $7121: $3a
	jr   nc, jr_001_715e                             ; $7122: $30 $3a

	ld   l, $34                                      ; $7124: $2e $34
	ld   h, $34                                      ; $7126: $26 $34
	ld   l, $34                                      ; $7128: $2e $34
	xor  b                                           ; $712a: $a8
	jr   nc, jr_001_70cf                             ; $712b: $30 $a2

	ld   [hl-], a                                    ; $712d: $32
	jr   c, jr_001_715a                              ; $712e: $38 $2a

	jr   c, jr_001_7164                              ; $7130: $38 $32

	jr   c, jr_001_70dc                              ; $7132: $38 $a8

	inc  [hl]                                        ; $7134: $34

jr_001_7135:
	and  e                                           ; $7135: $a3
	inc  [hl]                                        ; $7136: $34
	ld   a, [hl+]                                    ; $7137: $2a
	inc  h                                           ; $7138: $24
	inc  e                                           ; $7139: $1c
	jr   nz, jr_001_7160                             ; $713a: $20 $24

	inc  l                                           ; $713c: $2c
	jr   nc, jr_001_7173                             ; $713d: $30 $34

	xor  b                                           ; $713f: $a8

jr_001_7140:
	ld   h, $00                                      ; $7140: $26 $00
	ld   l, b                                        ; $7142: $68
	ld   [hl], c                                     ; $7143: $71
	ld   l, b                                        ; $7144: $68
	ld   [hl], c                                     ; $7145: $71

jr_001_7146:
	xor  [hl]                                        ; $7146: $ae
	ld   [hl], c                                     ; $7147: $71
	rst  $38                                         ; $7148: $ff
	rst  $38                                         ; $7149: $ff

jr_001_714a:
	ld   b, d                                        ; $714a: $42
	ld   [hl], c                                     ; $714b: $71
	bit  6, c                                        ; $714c: $cb $71
	bit  6, c                                        ; $714e: $cb $71
	dec  e                                           ; $7150: $1d
	ld   [hl], d                                     ; $7151: $72
	rst  $38                                         ; $7152: $ff
	rst  $38                                         ; $7153: $ff
	ld   c, h                                        ; $7154: $4c
	ld   [hl], c                                     ; $7155: $71
	ld   a, [hl-]                                    ; $7156: $3a
	ld   [hl], d                                     ; $7157: $72
	ld   a, [hl-]                                    ; $7158: $3a
	ld   [hl], d                                     ; $7159: $72

jr_001_715a:
	ld   a, a                                        ; $715a: $7f
	ld   [hl], d                                     ; $715b: $72
	ld   a, a                                        ; $715c: $7f
	ld   [hl], d                                     ; $715d: $72

jr_001_715e:
	rst  $38                                         ; $715e: $ff
	rst  $38                                         ; $715f: $ff

jr_001_7160:
	ld   d, [hl]                                     ; $7160: $56
	ld   [hl], c                                     ; $7161: $71
	and  e                                           ; $7162: $a3
	ld   [hl], d                                     ; $7163: $72

jr_001_7164:
	rst  $38                                         ; $7164: $ff
	rst  $38                                         ; $7165: $ff
	ld   h, d                                        ; $7166: $62
	ld   [hl], c                                     ; $7167: $71
	sbc  l                                           ; $7168: $9d
	add  h                                           ; $7169: $84
	nop                                              ; $716a: $00
	add  c                                           ; $716b: $81
	and  e                                           ; $716c: $a3
	ld   d, d                                        ; $716d: $52
	and  d                                           ; $716e: $a2
	ld   c, b                                        ; $716f: $48
	ld   c, d                                        ; $7170: $4a
	and  e                                           ; $7171: $a3
	ld   c, [hl]                                     ; $7172: $4e

jr_001_7173:
	and  d                                           ; $7173: $a2
	ld   c, d                                        ; $7174: $4a
	ld   c, b                                        ; $7175: $48
	and  e                                           ; $7176: $a3
	ld   b, h                                        ; $7177: $44
	and  d                                           ; $7178: $a2
	ld   b, h                                        ; $7179: $44
	ld   c, d                                        ; $717a: $4a
	and  e                                           ; $717b: $a3
	ld   d, d                                        ; $717c: $52
	and  d                                           ; $717d: $a2
	ld   c, [hl]                                     ; $717e: $4e
	ld   c, d                                        ; $717f: $4a
	and  a                                           ; $7180: $a7
	ld   c, b                                        ; $7181: $48
	and  d                                           ; $7182: $a2
	ld   c, d                                        ; $7183: $4a
	and  e                                           ; $7184: $a3
	ld   c, [hl]                                     ; $7185: $4e
	ld   d, d                                        ; $7186: $52
	and  e                                           ; $7187: $a3
	ld   c, d                                        ; $7188: $4a
	ld   b, h                                        ; $7189: $44
	ld   b, h                                        ; $718a: $44
	ld   bc, $01a2                                   ; $718b: $01 $a2 $01
	and  e                                           ; $718e: $a3
	ld   c, [hl]                                     ; $718f: $4e
	and  d                                           ; $7190: $a2
	ld   d, h                                        ; $7191: $54
	and  e                                           ; $7192: $a3
	ld   e, h                                        ; $7193: $5c
	and  d                                           ; $7194: $a2
	ld   e, b                                        ; $7195: $58
	ld   d, h                                        ; $7196: $54
	and  a                                           ; $7197: $a7
	ld   d, d                                        ; $7198: $52
	and  d                                           ; $7199: $a2
	ld   c, d                                        ; $719a: $4a
	and  e                                           ; $719b: $a3
	ld   d, d                                        ; $719c: $52
	and  d                                           ; $719d: $a2
	ld   c, [hl]                                     ; $719e: $4e
	ld   c, d                                        ; $719f: $4a
	and  e                                           ; $71a0: $a3
	ld   c, b                                        ; $71a1: $48
	and  d                                           ; $71a2: $a2
	ld   c, b                                        ; $71a3: $48
	ld   c, d                                        ; $71a4: $4a
	and  e                                           ; $71a5: $a3
	ld   c, [hl]                                     ; $71a6: $4e
	ld   d, d                                        ; $71a7: $52
	and  e                                           ; $71a8: $a3
	ld   c, d                                        ; $71a9: $4a
	ld   b, h                                        ; $71aa: $44
	ld   b, h                                        ; $71ab: $44
	ld   bc, $9d00                                   ; $71ac: $01 $00 $9d
	ld   d, b                                        ; $71af: $50
	nop                                              ; $71b0: $00
	add  c                                           ; $71b1: $81
	and  h                                           ; $71b2: $a4
	ld   a, [hl-]                                    ; $71b3: $3a
	ld   [hl-], a                                    ; $71b4: $32
	ld   [hl], $30                                   ; $71b5: $36 $30
	and  h                                           ; $71b7: $a4
	ld   [hl-], a                                    ; $71b8: $32
	inc  l                                           ; $71b9: $2c
	xor  b                                           ; $71ba: $a8
	ld   a, [hl+]                                    ; $71bb: $2a
	and  e                                           ; $71bc: $a3
	ld   bc, $3aa4                                   ; $71bd: $01 $a4 $3a
	ld   [hl-], a                                    ; $71c0: $32
	ld   [hl], $30                                   ; $71c1: $36 $30
	and  e                                           ; $71c3: $a3
	ld   [hl-], a                                    ; $71c4: $32
	ld   a, [hl-]                                    ; $71c5: $3a
	and  h                                           ; $71c6: $a4
	ld   b, h                                        ; $71c7: $44
	ld   b, d                                        ; $71c8: $42
	ld   bc, $9d00                                   ; $71c9: $01 $00 $9d
	ld   b, e                                        ; $71cc: $43
	nop                                              ; $71cd: $00
	add  c                                           ; $71ce: $81
	and  e                                           ; $71cf: $a3
	ld   c, b                                        ; $71d0: $48
	and  d                                           ; $71d1: $a2
	ld   b, d                                        ; $71d2: $42
	ld   b, h                                        ; $71d3: $44
	ld   c, b                                        ; $71d4: $48
	and  c                                           ; $71d5: $a1
	ld   d, d                                        ; $71d6: $52
	ld   c, [hl]                                     ; $71d7: $4e
	and  d                                           ; $71d8: $a2
	ld   b, h                                        ; $71d9: $44
	ld   b, d                                        ; $71da: $42
	and  a                                           ; $71db: $a7
	ld   a, [hl-]                                    ; $71dc: $3a
	and  d                                           ; $71dd: $a2
	ld   b, h                                        ; $71de: $44
	ld   c, d                                        ; $71df: $4a
	ld   bc, $48a2                                   ; $71e0: $01 $a2 $48
	ld   b, h                                        ; $71e3: $44
	and  c                                           ; $71e4: $a1
	ld   b, d                                        ; $71e5: $42
	ld   b, d                                        ; $71e6: $42
	and  d                                           ; $71e7: $a2
	ld   a, [hl-]                                    ; $71e8: $3a
	ld   b, d                                        ; $71e9: $42
	ld   b, h                                        ; $71ea: $44
	and  e                                           ; $71eb: $a3
	ld   c, b                                        ; $71ec: $48
	ld   c, d                                        ; $71ed: $4a
	and  e                                           ; $71ee: $a3
	ld   b, h                                        ; $71ef: $44
	ld   a, [hl-]                                    ; $71f0: $3a
	ld   a, [hl-]                                    ; $71f1: $3a
	ld   bc, $1ea2                                   ; $71f2: $01 $a2 $1e
	and  e                                           ; $71f5: $a3
	inc  a                                           ; $71f6: $3c
	and  d                                           ; $71f7: $a2
	ld   b, h                                        ; $71f8: $44
	ld   c, d                                        ; $71f9: $4a
	and  c                                           ; $71fa: $a1
	ld   c, d                                        ; $71fb: $4a
	ld   c, d                                        ; $71fc: $4a
	and  d                                           ; $71fd: $a2
	ld   c, b                                        ; $71fe: $48
	ld   b, h                                        ; $71ff: $44
	and  a                                           ; $7200: $a7
	ld   b, b                                        ; $7201: $40
	and  d                                           ; $7202: $a2
	ld   a, [hl-]                                    ; $7203: $3a
	ld   b, b                                        ; $7204: $40
	and  c                                           ; $7205: $a1
	ld   b, h                                        ; $7206: $44
	ld   b, b                                        ; $7207: $40
	and  d                                           ; $7208: $a2
	inc  a                                           ; $7209: $3c
	ld   a, [hl-]                                    ; $720a: $3a
	ld   b, d                                        ; $720b: $42
	ld   a, [hl-]                                    ; $720c: $3a
	ld   b, d                                        ; $720d: $42
	ld   b, h                                        ; $720e: $44
	ld   c, b                                        ; $720f: $48
	ld   b, d                                        ; $7210: $42
	ld   c, d                                        ; $7211: $4a
	ld   b, d                                        ; $7212: $42
	and  c                                           ; $7213: $a1
	ld   b, h                                        ; $7214: $44
	ld   c, d                                        ; $7215: $4a
	ld   a, [hl-]                                    ; $7216: $3a
	ld   bc, $3aa3                                   ; $7217: $01 $a3 $3a
	ld   a, [hl-]                                    ; $721a: $3a
	ld   bc, $9d00                                   ; $721b: $01 $00 $9d
	jr   nc, jr_001_7220                             ; $721e: $30 $00

jr_001_7220:
	add  c                                           ; $7220: $81
	and  h                                           ; $7221: $a4
	ld   [hl-], a                                    ; $7222: $32
	inc  l                                           ; $7223: $2c
	jr   nc, jr_001_7250                             ; $7224: $30 $2a

jr_001_7226:
	inc  l                                           ; $7226: $2c
	ld   [hl+], a                                    ; $7227: $22
	and  h                                           ; $7228: $a4
	ld   [hl+], a                                    ; $7229: $22
	and  e                                           ; $722a: $a3
	jr   nc, jr_001_722e                             ; $722b: $30 $01

	and  h                                           ; $722d: $a4

jr_001_722e:
	ld   [hl-], a                                    ; $722e: $32
	inc  l                                           ; $722f: $2c
	jr   nc, jr_001_725c                             ; $7230: $30 $2a

	and  e                                           ; $7232: $a3
	inc  l                                           ; $7233: $2c
	ld   [hl-], a                                    ; $7234: $32
	and  h                                           ; $7235: $a4
	ld   a, [hl-]                                    ; $7236: $3a
	ld   [hl], $01                                   ; $7237: $36 $01
	nop                                              ; $7239: $00
	sbc  l                                           ; $723a: $9d
	ret                                              ; $723b: $c9


	ld   l, [hl]                                     ; $723c: $6e
	jr   nz, @-$5c                                   ; $723d: $20 $a2

	ld   [hl+], a                                    ; $723f: $22
	ld   a, [hl-]                                    ; $7240: $3a
	ld   [hl+], a                                    ; $7241: $22
	ld   a, [hl-]                                    ; $7242: $3a
	ld   [hl+], a                                    ; $7243: $22
	ld   a, [hl-]                                    ; $7244: $3a
	ld   [hl+], a                                    ; $7245: $22
	ld   a, [hl-]                                    ; $7246: $3a
	inc  l                                           ; $7247: $2c
	ld   b, h                                        ; $7248: $44
	inc  l                                           ; $7249: $2c
	ld   b, h                                        ; $724a: $44
	inc  l                                           ; $724b: $2c
	ld   b, h                                        ; $724c: $44
	inc  l                                           ; $724d: $2c
	ld   b, h                                        ; $724e: $44
	ld   a, [hl+]                                    ; $724f: $2a

jr_001_7250:
	ld   b, d                                        ; $7250: $42
	ld   a, [hl+]                                    ; $7251: $2a
	ld   b, d                                        ; $7252: $42
	ld   [hl+], a                                    ; $7253: $22
	ld   a, [hl-]                                    ; $7254: $3a
	ld   [hl+], a                                    ; $7255: $22
	ld   a, [hl-]                                    ; $7256: $3a
	inc  l                                           ; $7257: $2c
	ld   b, h                                        ; $7258: $44
	inc  l                                           ; $7259: $2c
	ld   b, h                                        ; $725a: $44
	inc  l                                           ; $725b: $2c

jr_001_725c:
	ld   b, h                                        ; $725c: $44
	jr   nc, jr_001_7291                             ; $725d: $30 $32

	ld   [hl], $1e                                   ; $725f: $36 $1e
	ld   bc, $011e                                   ; $7261: $01 $1e $01
	ld   e, $2c                                      ; $7264: $1e $2c
	inc  h                                           ; $7266: $24
	ld   a, [de]                                     ; $7267: $1a
	ld   [hl-], a                                    ; $7268: $32
	ld   bc, $1a32                                   ; $7269: $01 $32 $1a
	jr   z, jr_001_7296                              ; $726c: $28 $28

	ld   bc, $4830                                   ; $726e: $01 $30 $48
	ld   bc, HeaderROMSize                           ; $7271: $01 $48 $01
	ld   a, [hl-]                                    ; $7274: $3a
	ld   bc, $2c42                                   ; $7275: $01 $42 $2c
	ld   a, [hl-]                                    ; $7278: $3a
	inc  l                                           ; $7279: $2c
	ld   a, [hl-]                                    ; $727a: $3a
	and  e                                           ; $727b: $a3
	inc  l                                           ; $727c: $2c
	ld   bc, $9d00                                   ; $727d: $01 $00 $9d
	ret                                              ; $7280: $c9


	ld   l, [hl]                                     ; $7281: $6e
	jr   nz, jr_001_7226                             ; $7282: $20 $a2

	ld   b, h                                        ; $7284: $44
	ld   d, d                                        ; $7285: $52
	ld   b, h                                        ; $7286: $44
	ld   d, d                                        ; $7287: $52
	ld   b, h                                        ; $7288: $44
	ld   d, d                                        ; $7289: $52
	ld   b, h                                        ; $728a: $44
	ld   d, d                                        ; $728b: $52
	ld   b, d                                        ; $728c: $42
	ld   d, d                                        ; $728d: $52
	ld   b, d                                        ; $728e: $42
	ld   d, d                                        ; $728f: $52
	ld   b, d                                        ; $7290: $42

jr_001_7291:
	ld   d, d                                        ; $7291: $52
	ld   b, d                                        ; $7292: $42
	ld   d, d                                        ; $7293: $52
	ld   b, h                                        ; $7294: $44
	ld   d, d                                        ; $7295: $52

jr_001_7296:
	ld   b, h                                        ; $7296: $44
	ld   d, d                                        ; $7297: $52
	ld   b, h                                        ; $7298: $44
	ld   d, d                                        ; $7299: $52
	ld   b, h                                        ; $729a: $44
	ld   d, d                                        ; $729b: $52
	ld   b, d                                        ; $729c: $42
	ld   d, d                                        ; $729d: $52
	ld   b, d                                        ; $729e: $42
	ld   d, d                                        ; $729f: $52
	and  h                                           ; $72a0: $a4
	ld   bc, $a200                                   ; $72a1: $01 $00 $a2
	ld   bc, $0106                                   ; $72a4: $01 $06 $01
	ld   b, $01                                      ; $72a7: $06 $01
	and  c                                           ; $72a9: $a1
	ld   b, $06                                      ; $72aa: $06 $06
	and  d                                           ; $72ac: $a2
	ld   bc, $0106                                   ; $72ad: $01 $06 $01
	ld   b, $01                                      ; $72b0: $06 $01
	ld   b, $01                                      ; $72b2: $06 $01
	ld   b, $06                                      ; $72b4: $06 $06
	ld   b, $00                                      ; $72b6: $06 $00
	dec  bc                                          ; $72b8: $0b
	ld   [hl], e                                     ; $72b9: $73
	ccf                                              ; $72ba: $3f
	ld   [hl], e                                     ; $72bb: $73
	ld   h, a                                        ; $72bc: $67
	ld   [hl], e                                     ; $72bd: $73
	ld   h, a                                        ; $72be: $67
	ld   [hl], e                                     ; $72bf: $73
	ret                                              ; $72c0: $c9


	ld   [hl], e                                     ; $72c1: $73
	rst  $38                                         ; $72c2: $ff
	rst  $38                                         ; $72c3: $ff
	cp   b                                           ; $72c4: $b8
	ld   [hl], d                                     ; $72c5: $72
	ld   [$3c73], sp                                 ; $72c6: $08 $73 $3c
	ld   [hl], e                                     ; $72c9: $73
	adc  [hl]                                        ; $72ca: $8e
	ld   [hl], e                                     ; $72cb: $73
	adc  [hl]                                        ; $72cc: $8e
	ld   [hl], e                                     ; $72cd: $73
	ld   c, e                                        ; $72ce: $4b
	ld   [hl], h                                     ; $72cf: $74
	rst  $38                                         ; $72d0: $ff
	rst  $38                                         ; $72d1: $ff
	add  $72                                         ; $72d2: $c6 $72
	rra                                              ; $72d4: $1f
	ld   [hl], e                                     ; $72d5: $73
	ld   d, e                                        ; $72d6: $53
	ld   [hl], e                                     ; $72d7: $73
	or   l                                           ; $72d8: $b5
	ld   [hl], e                                     ; $72d9: $73
	or   l                                           ; $72da: $b5
	ld   [hl], e                                     ; $72db: $73
	or   l                                           ; $72dc: $b5
	ld   [hl], e                                     ; $72dd: $73
	or   l                                           ; $72de: $b5
	ld   [hl], e                                     ; $72df: $73
	or   l                                           ; $72e0: $b5
	ld   [hl], e                                     ; $72e1: $73
	or   l                                           ; $72e2: $b5
	ld   [hl], e                                     ; $72e3: $73
	ret  nz                                          ; $72e4: $c0

	ld   [hl], h                                     ; $72e5: $74
	sbc  $74                                         ; $72e6: $de $74
	sbc  $74                                         ; $72e8: $de $74
	sbc  $74                                         ; $72ea: $de $74
	xor  $74                                         ; $72ec: $ee $74
	cp   $74                                         ; $72ee: $fe $74
	cp   $74                                         ; $72f0: $fe $74
	ld   c, $75                                      ; $72f2: $0e $75
	ld   c, $75                                      ; $72f4: $0e $75
	ld   e, $75                                      ; $72f6: $1e $75
	ld   e, $75                                      ; $72f8: $1e $75
	ld   c, $75                                      ; $72fa: $0e $75
	ld   l, $75                                      ; $72fc: $2e $75
	rst  $38                                         ; $72fe: $ff
	rst  $38                                         ; $72ff: $ff
	call nc, $3372                                   ; $7300: $d4 $72 $33
	ld   [hl], e                                     ; $7303: $73
	rst  $38                                         ; $7304: $ff
	rst  $38                                         ; $7305: $ff
	ld   [bc], a                                     ; $7306: $02
	ld   [hl], e                                     ; $7307: $73
	and  l                                           ; $7308: $a5
	ld   bc, $9d00                                   ; $7309: $01 $00 $9d
	ld   h, d                                        ; $730c: $62
	nop                                              ; $730d: $00
	add  b                                           ; $730e: $80
	and  d                                           ; $730f: $a2
	ld   a, [hl-]                                    ; $7310: $3a
	and  c                                           ; $7311: $a1
	ld   a, [hl-]                                    ; $7312: $3a
	ld   a, [hl-]                                    ; $7313: $3a
	and  d                                           ; $7314: $a2
	jr   nc, jr_001_7347                             ; $7315: $30 $30

	ld   a, [hl-]                                    ; $7317: $3a
	and  c                                           ; $7318: $a1
	ld   a, [hl-]                                    ; $7319: $3a
	ld   a, [hl-]                                    ; $731a: $3a
	and  d                                           ; $731b: $a2
	jr   nc, jr_001_734e                             ; $731c: $30 $30

	nop                                              ; $731e: $00
	sbc  l                                           ; $731f: $9d
	jp   hl                                          ; $7320: $e9


	ld   l, [hl]                                     ; $7321: $6e
	and  b                                           ; $7322: $a0
	and  d                                           ; $7323: $a2
	ld   a, [hl-]                                    ; $7324: $3a
	and  c                                           ; $7325: $a1
	ld   a, [hl-]                                    ; $7326: $3a
	ld   a, [hl-]                                    ; $7327: $3a
	and  d                                           ; $7328: $a2
	jr   nc, jr_001_735b                             ; $7329: $30 $30

	ld   a, [hl-]                                    ; $732b: $3a
	and  c                                           ; $732c: $a1
	ld   a, [hl-]                                    ; $732d: $3a
	ld   a, [hl-]                                    ; $732e: $3a
	and  d                                           ; $732f: $a2
	jr   nc, jr_001_7362                             ; $7330: $30 $30

	nop                                              ; $7332: $00
	and  d                                           ; $7333: $a2
	ld   b, $a1                                      ; $7334: $06 $a1
	ld   b, $06                                      ; $7336: $06 $06
	and  d                                           ; $7338: $a2
	ld   b, $06                                      ; $7339: $06 $06
	nop                                              ; $733b: $00
	and  l                                           ; $733c: $a5
	ld   bc, $9d00                                   ; $733d: $01 $00 $9d
	ld   [hl-], a                                    ; $7340: $32
	nop                                              ; $7341: $00
	add  b                                           ; $7342: $80
	and  d                                           ; $7343: $a2
	ld   a, [hl-]                                    ; $7344: $3a
	and  c                                           ; $7345: $a1
	ld   a, [hl-]                                    ; $7346: $3a

jr_001_7347:
	ld   a, [hl-]                                    ; $7347: $3a
	and  d                                           ; $7348: $a2
	jr   nc, jr_001_737b                             ; $7349: $30 $30

	ld   a, [hl-]                                    ; $734b: $3a
	and  c                                           ; $734c: $a1
	ld   a, [hl-]                                    ; $734d: $3a

jr_001_734e:
	ld   a, [hl-]                                    ; $734e: $3a
	and  d                                           ; $734f: $a2
	jr   nc, jr_001_7382                             ; $7350: $30 $30

	nop                                              ; $7352: $00
	sbc  l                                           ; $7353: $9d
	jp   hl                                          ; $7354: $e9


	ld   l, [hl]                                     ; $7355: $6e
	and  b                                           ; $7356: $a0
	and  d                                           ; $7357: $a2
	ld   a, [hl-]                                    ; $7358: $3a
	and  c                                           ; $7359: $a1
	ld   a, [hl-]                                    ; $735a: $3a

jr_001_735b:
	ld   a, [hl-]                                    ; $735b: $3a
	and  d                                           ; $735c: $a2
	jr   nc, jr_001_738f                             ; $735d: $30 $30

	ld   a, [hl-]                                    ; $735f: $3a
	and  c                                           ; $7360: $a1
	ld   a, [hl-]                                    ; $7361: $3a

jr_001_7362:
	ld   a, [hl-]                                    ; $7362: $3a
	and  d                                           ; $7363: $a2
	jr   nc, jr_001_7396                             ; $7364: $30 $30

	nop                                              ; $7366: $00
	sbc  l                                           ; $7367: $9d
	add  d                                           ; $7368: $82
	nop                                              ; $7369: $00
	add  b                                           ; $736a: $80
	and  d                                           ; $736b: $a2
	ld   a, [hl-]                                    ; $736c: $3a
	ld   c, b                                        ; $736d: $48
	ld   d, d                                        ; $736e: $52
	ld   d, b                                        ; $736f: $50
	ld   d, d                                        ; $7370: $52
	and  c                                           ; $7371: $a1
	ld   c, b                                        ; $7372: $48
	ld   c, b                                        ; $7373: $48
	and  d                                           ; $7374: $a2
	ld   c, d                                        ; $7375: $4a
	ld   b, h                                        ; $7376: $44
	ld   c, b                                        ; $7377: $48
	and  c                                           ; $7378: $a1
	ld   b, b                                        ; $7379: $40
	ld   b, b                                        ; $737a: $40

jr_001_737b:
	and  d                                           ; $737b: $a2
	ld   b, h                                        ; $737c: $44
	ld   a, $40                                      ; $737d: $3e $40
	and  c                                           ; $737f: $a1
	ld   a, [hl-]                                    ; $7380: $3a
	ld   a, [hl-]                                    ; $7381: $3a

jr_001_7382:
	and  d                                           ; $7382: $a2
	ld   a, $38                                      ; $7383: $3e $38
	ld   a, [hl-]                                    ; $7385: $3a
	jr   nc, jr_001_73ba                             ; $7386: $30 $32

	jr   c, jr_001_73c4                              ; $7388: $38 $3a

	jr   nc, jr_001_73be                             ; $738a: $30 $32

	ld   a, $00                                      ; $738c: $3e $00
	sbc  l                                           ; $738e: $9d

jr_001_738f:
	ld   d, e                                        ; $738f: $53
	nop                                              ; $7390: $00
	ld   b, b                                        ; $7391: $40
	and  d                                           ; $7392: $a2
	jr   nc, jr_001_73d5                             ; $7393: $30 $40

	ld   b, b                                        ; $7395: $40

jr_001_7396:
	ld   b, h                                        ; $7396: $44
	ld   b, b                                        ; $7397: $40
	and  c                                           ; $7398: $a1
	ld   a, $40                                      ; $7399: $3e $40
	and  d                                           ; $739b: $a2
	ld   b, h                                        ; $739c: $44
	ld   a, $40                                      ; $739d: $3e $40
	and  c                                           ; $739f: $a1
	jr   c, jr_001_73dc                              ; $73a0: $38 $3a

	and  d                                           ; $73a2: $a2
	ld   a, $38                                      ; $73a3: $3e $38
	ld   a, [hl-]                                    ; $73a5: $3a
	and  c                                           ; $73a6: $a1
	ld   l, $30                                      ; $73a7: $2e $30
	and  d                                           ; $73a9: $a2
	jr   c, jr_001_73dc                              ; $73aa: $38 $30

	jr   nc, jr_001_73d6                             ; $73ac: $30 $28

	inc  l                                           ; $73ae: $2c
	inc  l                                           ; $73af: $2c
	jr   nc, @+$2a                                   ; $73b0: $30 $28

	inc  l                                           ; $73b2: $2c
	jr   c, jr_001_73b5                              ; $73b3: $38 $00

jr_001_73b5:
	sbc  l                                           ; $73b5: $9d
	jp   hl                                          ; $73b6: $e9


	ld   l, [hl]                                     ; $73b7: $6e
	and  b                                           ; $73b8: $a0
	and  d                                           ; $73b9: $a2

jr_001_73ba:
	ld   a, [hl-]                                    ; $73ba: $3a
	and  c                                           ; $73bb: $a1
	ld   a, [hl-]                                    ; $73bc: $3a
	ld   a, [hl-]                                    ; $73bd: $3a

jr_001_73be:
	and  d                                           ; $73be: $a2
	jr   nc, jr_001_73f1                             ; $73bf: $30 $30

	ld   a, [hl-]                                    ; $73c1: $3a
	and  c                                           ; $73c2: $a1
	ld   a, [hl-]                                    ; $73c3: $3a

jr_001_73c4:
	ld   a, [hl-]                                    ; $73c4: $3a
	and  d                                           ; $73c5: $a2
	jr   nc, jr_001_73f8                             ; $73c6: $30 $30

	nop                                              ; $73c8: $00
	xor  b                                           ; $73c9: $a8
	ld   a, [hl-]                                    ; $73ca: $3a
	and  d                                           ; $73cb: $a2
	ld   a, $38                                      ; $73cc: $3e $38
	xor  b                                           ; $73ce: $a8
	ld   a, [hl-]                                    ; $73cf: $3a
	and  e                                           ; $73d0: $a3
	ld   a, $a2                                      ; $73d1: $3e $a2
	ld   b, b                                        ; $73d3: $40
	and  c                                           ; $73d4: $a1

jr_001_73d5:
	ld   b, b                                        ; $73d5: $40

jr_001_73d6:
	ld   b, b                                        ; $73d6: $40
	and  d                                           ; $73d7: $a2
	ld   b, h                                        ; $73d8: $44
	ld   a, $40                                      ; $73d9: $3e $40
	and  c                                           ; $73db: $a1

jr_001_73dc:
	ld   b, b                                        ; $73dc: $40
	ld   b, b                                        ; $73dd: $40
	and  d                                           ; $73de: $a2
	ld   b, h                                        ; $73df: $44
	ld   a, $a8                                      ; $73e0: $3e $a8
	ld   b, b                                        ; $73e2: $40
	and  e                                           ; $73e3: $a3
	ld   b, h                                        ; $73e4: $44
	and  d                                           ; $73e5: $a2
	ld   c, b                                        ; $73e6: $48
	and  c                                           ; $73e7: $a1
	ld   c, b                                        ; $73e8: $48
	ld   c, b                                        ; $73e9: $48
	and  d                                           ; $73ea: $a2
	ld   c, d                                        ; $73eb: $4a
	ld   b, h                                        ; $73ec: $44
	ld   c, b                                        ; $73ed: $48
	and  c                                           ; $73ee: $a1
	ld   c, b                                        ; $73ef: $48

jr_001_73f0:
	ld   c, b                                        ; $73f0: $48

jr_001_73f1:
	and  d                                           ; $73f1: $a2
	ld   c, d                                        ; $73f2: $4a
	ld   b, h                                        ; $73f3: $44
	xor  b                                           ; $73f4: $a8
	ld   c, b                                        ; $73f5: $48

jr_001_73f6:
	and  e                                           ; $73f6: $a3
	ld   c, h                                        ; $73f7: $4c

jr_001_73f8:
	and  d                                           ; $73f8: $a2
	ld   c, [hl]                                     ; $73f9: $4e
	and  c                                           ; $73fa: $a1
	ld   c, [hl]                                     ; $73fb: $4e
	ld   c, [hl]                                     ; $73fc: $4e
	and  d                                           ; $73fd: $a2
	ld   c, [hl]                                     ; $73fe: $4e
	ld   c, [hl]                                     ; $73ff: $4e
	ld   d, d                                        ; $7400: $52
	ld   c, [hl]                                     ; $7401: $4e
	ld   c, [hl]                                     ; $7402: $4e
	ld   c, h                                        ; $7403: $4c
	ld   c, [hl]                                     ; $7404: $4e
	and  c                                           ; $7405: $a1
	ld   c, [hl]                                     ; $7406: $4e
	ld   c, [hl]                                     ; $7407: $4e
	and  d                                           ; $7408: $a2
	ld   c, [hl]                                     ; $7409: $4e
	ld   c, [hl]                                     ; $740a: $4e
	ld   d, d                                        ; $740b: $52
	ld   c, [hl]                                     ; $740c: $4e
	ld   c, [hl]                                     ; $740d: $4e
	ld   c, h                                        ; $740e: $4c
	ld   c, [hl]                                     ; $740f: $4e
	and  c                                           ; $7410: $a1
	ld   c, [hl]                                     ; $7411: $4e
	ld   c, [hl]                                     ; $7412: $4e
	and  d                                           ; $7413: $a2
	ld   c, [hl]                                     ; $7414: $4e
	ld   c, [hl]                                     ; $7415: $4e
	ld   c, h                                        ; $7416: $4c
	and  c                                           ; $7417: $a1
	ld   c, h                                        ; $7418: $4c
	ld   c, h                                        ; $7419: $4c
	and  d                                           ; $741a: $a2
	ld   c, h                                        ; $741b: $4c
	ld   c, h                                        ; $741c: $4c
	ld   c, d                                        ; $741d: $4a
	and  c                                           ; $741e: $a1
	ld   c, d                                        ; $741f: $4a
	ld   c, d                                        ; $7420: $4a
	and  d                                           ; $7421: $a2
	ld   c, d                                        ; $7422: $4a
	ld   b, h                                        ; $7423: $44
	ld   a, $40                                      ; $7424: $3e $40
	ld   b, h                                        ; $7426: $44
	ld   [hl], $44                                   ; $7427: $36 $44
	and  c                                           ; $7429: $a1
	ld   b, b                                        ; $742a: $40
	ld   b, b                                        ; $742b: $40
	and  d                                           ; $742c: $a2
	ld   [hl], $a3                                   ; $742d: $36 $a3
	ld   b, b                                        ; $742f: $40
	and  c                                           ; $7430: $a1
	ld   [hl], $3a                                   ; $7431: $36 $3a
	and  d                                           ; $7433: $a2
	ld   [hl], $30                                   ; $7434: $36 $30
	ld   b, h                                        ; $7436: $44
	and  c                                           ; $7437: $a1
	ld   b, b                                        ; $7438: $40
	ld   b, b                                        ; $7439: $40
	and  d                                           ; $743a: $a2
	ld   [hl], $a3                                   ; $743b: $36 $a3
	ld   b, b                                        ; $743d: $40
	and  c                                           ; $743e: $a1
	ld   [hl], $3a                                   ; $743f: $36 $3a
	and  d                                           ; $7441: $a2
	ld   [hl], $2e                                   ; $7442: $36 $2e
	and  l                                           ; $7444: $a5
	ld   [hl], $a8                                   ; $7445: $36 $a8

jr_001_7447:
	ld   bc, $38a3                                   ; $7447: $01 $a3 $38
	nop                                              ; $744a: $00
	xor  b                                           ; $744b: $a8
	jr   nc, jr_001_73f0                             ; $744c: $30 $a2

	jr   nc, jr_001_7480                             ; $744e: $30 $30

	xor  b                                           ; $7450: $a8
	jr   nc, jr_001_73f6                             ; $7451: $30 $a3

	ld   [hl], $a5                                   ; $7453: $36 $a5
	ld   bc, $01a8                                   ; $7455: $01 $a8 $01
	and  e                                           ; $7458: $a3
	ld   a, $a2                                      ; $7459: $3e $a2
	ld   b, b                                        ; $745b: $40
	and  c                                           ; $745c: $a1
	ld   b, b                                        ; $745d: $40
	ld   b, b                                        ; $745e: $40
	and  d                                           ; $745f: $a2
	ld   b, h                                        ; $7460: $44
	ld   a, $40                                      ; $7461: $3e $40
	and  c                                           ; $7463: $a1
	ld   b, b                                        ; $7464: $40
	ld   b, b                                        ; $7465: $40
	and  d                                           ; $7466: $a2
	ld   b, h                                        ; $7467: $44
	ld   a, $a8                                      ; $7468: $3e $a8
	ld   [hl], $a3                                   ; $746a: $36 $a3
	ld   a, [hl-]                                    ; $746c: $3a
	and  d                                           ; $746d: $a2
	ld   a, $a1                                      ; $746e: $3e $a1
	ld   b, b                                        ; $7470: $40
	ld   b, h                                        ; $7471: $44
	and  d                                           ; $7472: $a2
	ld   a, $44                                      ; $7473: $3e $44
	ld   c, b                                        ; $7475: $48
	ld   c, b                                        ; $7476: $48
	ld   c, b                                        ; $7477: $48
	ld   a, [hl-]                                    ; $7478: $3a
	ld   a, $a1                                      ; $7479: $3e $a1
	ld   b, b                                        ; $747b: $40
	ld   b, h                                        ; $747c: $44
	and  d                                           ; $747d: $a2
	ld   a, $44                                      ; $747e: $3e $44

jr_001_7480:
	ld   b, [hl]                                     ; $7480: $46
	ld   b, [hl]                                     ; $7481: $46

jr_001_7482:
	ld   b, [hl]                                     ; $7482: $46
	ld   a, [hl-]                                    ; $7483: $3a
	ld   a, $a1                                      ; $7484: $3e $a1

jr_001_7486:
	ld   b, b                                        ; $7486: $40
	ld   b, h                                        ; $7487: $44
	and  d                                           ; $7488: $a2

jr_001_7489:
	ld   a, $44                                      ; $7489: $3e $44
	ld   a, [hl-]                                    ; $748b: $3a
	and  c                                           ; $748c: $a1

jr_001_748d:
	ld   a, $40                                      ; $748d: $3e $40
	and  d                                           ; $748f: $a2
	ld   a, [hl-]                                    ; $7490: $3a
	ld   b, b                                        ; $7491: $40

jr_001_7492:
	ld   a, [hl-]                                    ; $7492: $3a
	and  c                                           ; $7493: $a1
	ld   a, $40                                      ; $7494: $3e $40

jr_001_7496:
	and  d                                           ; $7496: $a2
	ld   a, $3e                                      ; $7497: $3e $3e

jr_001_7499:
	inc  l                                           ; $7499: $2c
	ld   a, [hl-]                                    ; $749a: $3a
	ld   a, $26                                      ; $749b: $3e $26

jr_001_749d:
	jr   nc, @-$5d                                   ; $749d: $30 $a1

	jr   nc, jr_001_74d1                             ; $749f: $30 $30

	and  d                                           ; $74a1: $a2
	jr   nc, jr_001_7447                             ; $74a2: $30 $a3

	jr   nc, jr_001_7447                             ; $74a4: $30 $a1

	jr   nc, jr_001_74dc                             ; $74a6: $30 $34

	and  d                                           ; $74a8: $a2

jr_001_74a9:
	jr   nc, jr_001_74d3                             ; $74a9: $30 $28

	ld   l, $a1                                      ; $74ab: $2e $a1

jr_001_74ad:
	ld   l, $2e                                      ; $74ad: $2e $2e
	and  d                                           ; $74af: $a2
	ld   l, $a3                                      ; $74b0: $2e $a3
	ld   l, $a1                                      ; $74b2: $2e $a1
	ld   l, $32                                      ; $74b4: $2e $32
	and  d                                           ; $74b6: $a2
	ld   l, $28                                      ; $74b7: $2e $28
	and  l                                           ; $74b9: $a5
	ld   h, $a8                                      ; $74ba: $26 $a8
	ld   bc, $2ca3                                   ; $74bc: $01 $a3 $2c
	nop                                              ; $74bf: $00
	and  d                                           ; $74c0: $a2
	ld   a, [hl-]                                    ; $74c1: $3a
	and  c                                           ; $74c2: $a1
	ld   a, [hl-]                                    ; $74c3: $3a
	ld   a, [hl-]                                    ; $74c4: $3a
	and  d                                           ; $74c5: $a2
	ld   [hl-], a                                    ; $74c6: $32
	inc  l                                           ; $74c7: $2c
	ld   a, [hl-]                                    ; $74c8: $3a
	and  c                                           ; $74c9: $a1
	ld   a, [hl-]                                    ; $74ca: $3a
	ld   a, [hl-]                                    ; $74cb: $3a
	and  d                                           ; $74cc: $a2
	jr   c, jr_001_74ff                              ; $74cd: $38 $30

	ld   a, [hl-]                                    ; $74cf: $3a
	and  c                                           ; $74d0: $a1

jr_001_74d1:
	ld   a, [hl-]                                    ; $74d1: $3a
	ld   a, [hl-]                                    ; $74d2: $3a

jr_001_74d3:
	and  d                                           ; $74d3: $a2
	ld   [hl-], a                                    ; $74d4: $32
	inc  l                                           ; $74d5: $2c
	ld   a, [hl-]                                    ; $74d6: $3a
	and  c                                           ; $74d7: $a1
	ld   a, [hl-]                                    ; $74d8: $3a
	ld   a, [hl-]                                    ; $74d9: $3a
	and  d                                           ; $74da: $a2
	inc  l                                           ; $74db: $2c

jr_001_74dc:
	ld   e, $00                                      ; $74dc: $1e $00
	and  d                                           ; $74de: $a2
	jr   z, jr_001_7482                              ; $74df: $28 $a1

	ld   b, b                                        ; $74e1: $40
	jr   z, jr_001_7486                              ; $74e2: $28 $a2

	ld   e, $36                                      ; $74e4: $1e $36
	jr   z, jr_001_7489                              ; $74e6: $28 $a1

	ld   b, b                                        ; $74e8: $40
	jr   z, jr_001_748d                              ; $74e9: $28 $a2

	ld   e, $36                                      ; $74eb: $1e $36
	nop                                              ; $74ed: $00
	and  d                                           ; $74ee: $a2
	jr   z, jr_001_7492                              ; $74ef: $28 $a1

	ld   b, b                                        ; $74f1: $40
	jr   z, jr_001_7496                              ; $74f2: $28 $a2

	ld   e, $36                                      ; $74f4: $1e $36
	jr   z, jr_001_7499                              ; $74f6: $28 $a1

	ld   b, b                                        ; $74f8: $40
	jr   z, jr_001_749d                              ; $74f9: $28 $a2

	inc  l                                           ; $74fb: $2c
	ld   b, h                                        ; $74fc: $44
	nop                                              ; $74fd: $00
	and  d                                           ; $74fe: $a2

jr_001_74ff:
	ld   e, $a1                                      ; $74ff: $1e $a1
	ld   [hl], $1e                                   ; $7501: $36 $1e
	and  d                                           ; $7503: $a2
	ld   e, $36                                      ; $7504: $1e $36
	jr   z, jr_001_74a9                              ; $7506: $28 $a1

	ld   b, b                                        ; $7508: $40
	jr   z, jr_001_74ad                              ; $7509: $28 $a2

	jr   z, jr_001_754d                              ; $750b: $28 $40

	nop                                              ; $750d: $00
	and  d                                           ; $750e: $a2
	ld   e, $a1                                      ; $750f: $1e $a1
	ld   [hl], $1e                                   ; $7511: $36 $1e
	and  d                                           ; $7513: $a2
	ld   e, $36                                      ; $7514: $1e $36
	ld   e, $a1                                      ; $7516: $1e $a1
	ld   [hl], $1e                                   ; $7518: $36 $1e
	and  d                                           ; $751a: $a2
	ld   e, $36                                      ; $751b: $1e $36
	nop                                              ; $751d: $00
	and  d                                           ; $751e: $a2
	ld   [hl+], a                                    ; $751f: $22
	and  c                                           ; $7520: $a1
	ld   a, [hl-]                                    ; $7521: $3a
	ld   [hl+], a                                    ; $7522: $22
	and  d                                           ; $7523: $a2
	ld   [hl+], a                                    ; $7524: $22
	ld   a, [hl-]                                    ; $7525: $3a
	ld   [hl+], a                                    ; $7526: $22
	and  c                                           ; $7527: $a1
	ld   a, [hl-]                                    ; $7528: $3a
	ld   [hl+], a                                    ; $7529: $22
	and  d                                           ; $752a: $a2
	ld   [hl+], a                                    ; $752b: $22
	ld   a, [hl-]                                    ; $752c: $3a
	nop                                              ; $752d: $00
	and  d                                           ; $752e: $a2
	ld   e, $a1                                      ; $752f: $1e $a1
	ld   [hl], $1e                                   ; $7531: $36 $1e
	and  d                                           ; $7533: $a2
	ld   e, $36                                      ; $7534: $1e $36
	ld   e, $a1                                      ; $7536: $1e $a1
	ld   [hl], $1e                                   ; $7538: $36 $1e
	and  d                                           ; $753a: $a2
	and  h                                           ; $753b: $a4
	ld   a, $00                                      ; $753c: $3e $00
	ld   [hl], $3e                                   ; $753e: $36 $3e
	ld   b, h                                        ; $7540: $44
	and  h                                           ; $7541: $a4
	ld   b, h                                        ; $7542: $44
	ld   d, a                                        ; $7543: $57
	ld   [hl], l                                     ; $7544: $75
	ld   h, d                                        ; $7545: $62
	ld   [hl], l                                     ; $7546: $75
	rst  $38                                         ; $7547: $ff
	rst  $38                                         ; $7548: $ff
	ld   b, l                                        ; $7549: $45
	ld   [hl], l                                     ; $754a: $75
	ld   e, [hl]                                     ; $754b: $5e
	ld   [hl], l                                     ; $754c: $75

jr_001_754d:
	rst  $38                                         ; $754d: $ff
	rst  $38                                         ; $754e: $ff
	ld   c, e                                        ; $754f: $4b
	ld   [hl], l                                     ; $7550: $75
	ld   a, h                                        ; $7551: $7c
	ld   [hl], l                                     ; $7552: $75
	rst  $38                                         ; $7553: $ff
	rst  $38                                         ; $7554: $ff
	ld   d, c                                        ; $7555: $51
	ld   [hl], l                                     ; $7556: $75
	sbc  l                                           ; $7557: $9d
	jr   nz, jr_001_755a                             ; $7558: $20 $00

jr_001_755a:
	add  c                                           ; $755a: $81
	xor  d                                           ; $755b: $aa
	ld   bc, $9d00                                   ; $755c: $01 $00 $9d
	ld   [hl], b                                     ; $755f: $70
	nop                                              ; $7560: $00
	add  c                                           ; $7561: $81
	and  d                                           ; $7562: $a2
	ld   b, d                                        ; $7563: $42
	ld   [hl-], a                                    ; $7564: $32
	jr   c, jr_001_75a9                              ; $7565: $38 $42

	ld   b, [hl]                                     ; $7567: $46
	inc  [hl]                                        ; $7568: $34
	inc  a                                           ; $7569: $3c
	ld   b, [hl]                                     ; $756a: $46
	ld   c, d                                        ; $756b: $4a
	jr   c, jr_001_75b0                              ; $756c: $38 $42

	ld   c, d                                        ; $756e: $4a
	ld   c, h                                        ; $756f: $4c
	inc  a                                           ; $7570: $3c
	ld   b, d                                        ; $7571: $42
	ld   c, h                                        ; $7572: $4c
	ld   b, [hl]                                     ; $7573: $46
	inc  [hl]                                        ; $7574: $34
	inc  a                                           ; $7575: $3c
	ld   b, [hl]                                     ; $7576: $46
	ld   b, b                                        ; $7577: $40
	ld   l, $34                                      ; $7578: $2e $34
	ld   b, b                                        ; $757a: $40
	nop                                              ; $757b: $00
	sbc  l                                           ; $757c: $9d
	jp   hl                                          ; $757d: $e9


	ld   l, [hl]                                     ; $757e: $6e
	ld   hl, $42a8                                   ; $757f: $21 $a8 $42
	and  e                                           ; $7582: $a3
	ld   a, [hl+]                                    ; $7583: $2a
	xor  b                                           ; $7584: $a8
	ld   b, d                                        ; $7585: $42
	and  e                                           ; $7586: $a3
	ld   a, [hl+]                                    ; $7587: $2a
	xor  b                                           ; $7588: $a8
	ld   b, d                                        ; $7589: $42
	and  e                                           ; $758a: $a3
	ld   a, [hl+]                                    ; $758b: $2a
	nop                                              ; $758c: $00
	and  c                                           ; $758d: $a1
	ld   [hl], l                                     ; $758e: $75
	xor  h                                           ; $758f: $ac
	ld   [hl], l                                     ; $7590: $75
	rst  $38                                         ; $7591: $ff
	rst  $38                                         ; $7592: $ff
	adc  a                                           ; $7593: $8f
	ld   [hl], l                                     ; $7594: $75
	xor  b                                           ; $7595: $a8
	ld   [hl], l                                     ; $7596: $75
	rst  $38                                         ; $7597: $ff
	rst  $38                                         ; $7598: $ff
	sub  l                                           ; $7599: $95
	ld   [hl], l                                     ; $759a: $75
	xor  $75                                         ; $759b: $ee $75
	rst  $38                                         ; $759d: $ff
	rst  $38                                         ; $759e: $ff
	sbc  e                                           ; $759f: $9b
	ld   [hl], l                                     ; $75a0: $75
	sbc  l                                           ; $75a1: $9d
	jr   nz, jr_001_75a4                             ; $75a2: $20 $00

jr_001_75a4:
	add  c                                           ; $75a4: $81
	xor  d                                           ; $75a5: $aa
	ld   bc, $9d00                                   ; $75a6: $01 $00 $9d

jr_001_75a9:
	ld   [hl], b                                     ; $75a9: $70
	nop                                              ; $75aa: $00
	add  c                                           ; $75ab: $81
	and  d                                           ; $75ac: $a2
	ld   c, h                                        ; $75ad: $4c
	ld   b, d                                        ; $75ae: $42
	ld   d, b                                        ; $75af: $50

jr_001_75b0:
	ld   b, d                                        ; $75b0: $42
	ld   d, h                                        ; $75b1: $54
	ld   b, d                                        ; $75b2: $42
	ld   d, b                                        ; $75b3: $50
	ld   b, d                                        ; $75b4: $42
	ld   d, [hl]                                     ; $75b5: $56
	ld   b, d                                        ; $75b6: $42
	ld   d, h                                        ; $75b7: $54
	ld   b, d                                        ; $75b8: $42
	ld   d, b                                        ; $75b9: $50
	ld   b, d                                        ; $75ba: $42
	ld   d, h                                        ; $75bb: $54
	ld   b, d                                        ; $75bc: $42
	ld   c, h                                        ; $75bd: $4c
	ld   b, d                                        ; $75be: $42
	ld   d, b                                        ; $75bf: $50
	ld   b, d                                        ; $75c0: $42
	ld   d, h                                        ; $75c1: $54
	ld   b, d                                        ; $75c2: $42
	ld   d, b                                        ; $75c3: $50
	ld   b, d                                        ; $75c4: $42
	ld   d, [hl]                                     ; $75c5: $56
	ld   b, d                                        ; $75c6: $42
	ld   d, h                                        ; $75c7: $54
	ld   b, d                                        ; $75c8: $42
	ld   d, b                                        ; $75c9: $50

jr_001_75ca:
	ld   b, d                                        ; $75ca: $42
	ld   d, h                                        ; $75cb: $54
	ld   b, d                                        ; $75cc: $42
	ld   e, d                                        ; $75cd: $5a
	ld   b, [hl]                                     ; $75ce: $46
	ld   d, [hl]                                     ; $75cf: $56
	ld   b, [hl]                                     ; $75d0: $46
	ld   d, h                                        ; $75d1: $54
	ld   b, [hl]                                     ; $75d2: $46
	ld   d, b                                        ; $75d3: $50
	ld   b, [hl]                                     ; $75d4: $46
	ld   c, [hl]                                     ; $75d5: $4e
	ld   b, [hl]                                     ; $75d6: $46
	ld   d, b                                        ; $75d7: $50
	ld   b, [hl]                                     ; $75d8: $46
	ld   d, h                                        ; $75d9: $54
	ld   b, [hl]                                     ; $75da: $46
	ld   d, b                                        ; $75db: $50
	ld   b, [hl]                                     ; $75dc: $46
	ld   d, b                                        ; $75dd: $50
	ld   a, $4c                                      ; $75de: $3e $4c
	ld   a, $4c                                      ; $75e0: $3e $4c
	ld   a, $4a                                      ; $75e2: $3e $4a
	ld   a, $4a                                      ; $75e4: $3e $4a
	ld   a, $46                                      ; $75e6: $3e $46
	ld   a, $4a                                      ; $75e8: $3e $4a
	ld   a, $50                                      ; $75ea: $3e $50
	ld   a, $00                                      ; $75ec: $3e $00
	sbc  l                                           ; $75ee: $9d
	jp   hl                                          ; $75ef: $e9


	ld   l, [hl]                                     ; $75f0: $6e
	ld   hl, $4ca5                                   ; $75f1: $21 $a5 $4c
	ld   c, d                                        ; $75f4: $4a
	ld   b, [hl]                                     ; $75f5: $46
	ld   b, d                                        ; $75f6: $42
	db $38, $3e

	ld   b, d                                        ; $75f9: $42
	ld   b, d                                        ; $75fa: $42
	nop                                              ; $75fb: $00
	inc  b                                           ; $75fc: $04
	halt                                             ; $75fd: $76
	nop                                              ; $75fe: $00
	nop                                              ; $75ff: $00
	inc  d                                           ; $7600: $14
	halt                                             ; $7601: $76
	inc  hl                                          ; $7602: $23
	halt                                             ; $7603: $76
	sbc  l                                           ; $7604: $9d
	or   d                                           ; $7605: $b2
	nop                                              ; $7606: $00
	add  b                                           ; $7607: $80
	and  d                                           ; $7608: $a2
	ld   h, b                                        ; $7609: $60
	ld   e, h                                        ; $760a: $5c
	ld   h, b                                        ; $760b: $60
	ld   e, h                                        ; $760c: $5c
	ld   h, b                                        ; $760d: $60
	ld   h, d                                        ; $760e: $62
	ld   h, b                                        ; $760f: $60
	ld   e, h                                        ; $7610: $5c
	and  h                                           ; $7611: $a4
	ld   h, b                                        ; $7612: $60
	nop                                              ; $7613: $00
	sbc  l                                           ; $7614: $9d
	sub  d                                           ; $7615: $92
	nop                                              ; $7616: $00
	add  b                                           ; $7617: $80
	and  d                                           ; $7618: $a2
	ld   d, d                                        ; $7619: $52
	ld   c, [hl]                                     ; $761a: $4e
	ld   d, d                                        ; $761b: $52
	ld   c, [hl]                                     ; $761c: $4e
	ld   d, d                                        ; $761d: $52
	ld   d, h                                        ; $761e: $54
	ld   d, d                                        ; $761f: $52
	ld   c, [hl]                                     ; $7620: $4e
	and  h                                           ; $7621: $a4
	ld   d, d                                        ; $7622: $52
	sbc  l                                           ; $7623: $9d
	jp   hl                                          ; $7624: $e9


	ld   l, [hl]                                     ; $7625: $6e
	jr   nz, jr_001_75ca                             ; $7626: $20 $a2

	ld   h, d                                        ; $7628: $62
	ld   h, b                                        ; $7629: $60
	ld   h, d                                        ; $762a: $62
	ld   h, b                                        ; $762b: $60
	ld   h, d                                        ; $762c: $62
	ld   h, [hl]                                     ; $762d: $66
	ld   h, d                                        ; $762e: $62
	ld   h, b                                        ; $762f: $60
	and  e                                           ; $7630: $a3
	ld   h, d                                        ; $7631: $62
	db $01 
	
	
	
Song3_Sq2Data:
	dw Song3_Sq2_Section1Data
	dw Song3_Sq2_Section2Data
	dw Song3_Sq2_Section2Data
	EndSong

Song3_Sq1Data:
	dw Song3_Sq1_Section1Data
	dw Song3_Sq1_Section2Data
	dw Song3_Sq1_Section3Data

Song3_WavData:
	dw Song3_Wav_Section1Data
	dw Song3_Wav_Section2Data
	dw Song3_Wav_Section2Data
	dw Song3_Wav_Section3Data
	dw Song3_Wav_Section2Data
	dw Song3_Wav_Section2Data
	dw Song3_Wav_Section4Data
	dw Song3_Wav_Section3Data
	dw Song3_Wav_Section2Data
	dw Song3_Wav_Section2Data
	dw Song3_Wav_Section4Data
	dw Song3_Wav_Section3Data
	dw Song3_Wav_Section5Data
	dw Song3_Wav_Section6Data
	dw Song3_Wav_Section4Data
	dw Song3_Wav_Section3Data
	dw Song3_Wav_Section2Data

Song3_NoiseData:
	dw Song3_Noise_Section1Data
	dw Song3_Noise_Section1Data
	dw Song3_Noise_Section2Data
	dw Song3_Noise_Section2Data
	dw Song3_Noise_Section2Data
	dw Song3_Noise_Section2Data


Song3_Sq2_Section1Data::
	SetParams $c3, $80
	UseTempo 2
	PlayNote Fnote, 4
	PlayNote Fsharp, 4
	PlayNote Fnote, 4
	PlayNote Fsharp, 4
	PlayNote Dsharp, 4
	PlayNote Dsharp, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Fnote, 4
	PlayNote Fsharp, 4
	PlayNote Fnote, 4
	PlayNote Fsharp, 4
	PlayNote Dsharp, 4
	PlayNote Dsharp, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	DisableEnvelope
	PlayNote Bnote, 4
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Gsharp, 4
	DisableEnvelope
	PlayNote Asharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	PlayNote Asharp, 4
	UseTempo 2
	PlayNote Gsharp, 4
	PlayNote Gsharp, 4
	PlayNote Dsharp, 4
	UseTempo 3
	PlayNote Fnote, 4
	DisableEnvelope
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Gsharp, 4
	PlayNote Fsharp, 4
	PlayNote Gsharp, 4
	PlayNote Fnote, 4
	PlayNote Fnote, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Gsharp, 4
	PlayNote Fsharp, 4
	PlayNote Gsharp, 4
	PlayNote Fnote, 4
	PlayNote Fnote, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	DisableEnvelope
	PlayNote Fsharp, 5
	DisableEnvelope
	PlayNote Fnote, 5
	DisableEnvelope
	PlayNote Fnote, 5
	DisableEnvelope
	PlayNote Dsharp, 5
	UseTempo 2
	DisableEnvelope
	UseTempo 1
	PlayNote Dsharp, 5
	PlayNote Fnote, 5
	UseTempo 2
	PlayNote Dsharp, 5
	PlayNote Dnote, 5
	UseTempo 3
	PlayNote Dsharp, 5
	DisableEnvelope
	NextSection
	
Song3_Sq1_Section1Data::
	SetParams $74, $80
	UseTempo 2
	PlayNote Dnote, 4
	PlayNote Dsharp, 4
	PlayNote Dnote, 4
	PlayNote Dsharp, 4
	PlayNote Asharp, 3
	PlayNote Fsharp, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Dnote, 4
	PlayNote Dsharp, 4
	PlayNote Dnote, 4
	PlayNote Dsharp, 4
	PlayNote Asharp, 3
	PlayNote Fsharp, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	DisableEnvelope
	PlayNote Dnote, 4
	DisableEnvelope
	PlayNote Dnote, 4
	DisableEnvelope
	PlayNote Cnote, 4
	DisableEnvelope
	PlayNote Dnote, 4
	PlayNote Dnote, 4
	PlayNote Cnote, 4
	PlayNote Cnote, 4
	PlayNote Bnote, 3
	UseTempo 3
	PlayNote Dnote, 4
	DisableEnvelope
	UseTempo 2
	PlayNote Dsharp, 4
	PlayNote Fnote, 4
	PlayNote Dsharp, 4
	PlayNote Fnote, 4
	PlayNote Dnote, 4
	PlayNote Dnote, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Dsharp, 4
	PlayNote Fnote, 4
	PlayNote Dsharp, 4
	PlayNote Fnote, 4
	PlayNote Dnote, 4
	PlayNote Dnote, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	DisableEnvelope
	PlayNote Dsharp, 5
	DisableEnvelope
	PlayNote Dnote, 5
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Asharp, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	UseTempo 3
	PlayNote Gnote, 4
	DisableEnvelope
	NextSection
	
Song3_Wav_Section1Data:
; wav ram address, output level
	SetParams DefaultWavRam, $20
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Fsharp, 4
	PlayNote Dsharp, 3
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Fsharp, 4
	PlayNote Dsharp, 3
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Asharp, 3
	PlayNote Fnote, 4
	PlayNote Asharp, 3
	PlayNote Fnote, 3
	PlayNote Fnote, 3
	PlayNote Fnote, 3
	PlayNote Fnote, 3
	PlayNote Fnote, 4
	PlayNote Gsharp, 3
	PlayNote Fsharp, 4
	PlayNote Gsharp, 3
	PlayNote Fsharp, 4
	UseTempo 6
	PlayNote Asharp, 3
	UseTempo 3
	DisableEnvelope
	UseTempo 1
	DisableEnvelope
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Asharp, 3
	PlayNote Asharp, 3
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Bnote, 4
	PlayNote Asharp, 4
	PlayNote Asharp, 3
	PlayNote Asharp, 3
	UseTempo 3
	DisableEnvelope
	UseTempo 2
	PlayNote Gsharp, 3
	PlayNote Fnote, 4
	PlayNote Gsharp, 3
	PlayNote Fnote, 4
	PlayNote Asharp, 3
	PlayNote Fsharp, 4
	PlayNote Asharp, 3
	PlayNote Fsharp, 4
	PlayNote Asharp, 3
	PlayNote Gsharp, 4
	PlayNote Asharp, 3
	PlayNote Gsharp, 4
	UseTempo 6
	PlayNote Dsharp, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 1
	DisableEnvelope
	NextSection

Song3_Noise_Section1Data:
	xor  b                                           ; $775b: $a8
	ld   bc, $06a2                                   ; $775c: $01 $a2 $06
	dec  bc                                          ; $775f: $0b
	xor  b                                           ; $7760: $a8
	ld   bc, $06a2                                   ; $7761: $01 $a2 $06
	dec  bc                                          ; $7764: $0b
	and  l                                           ; $7765: $a5
	ld   bc, $0001                                   ; $7766: $01 $01 $00


Song3_Sq2_Section2Data:
	SetParams $c5, $80
	UseTempo 1
	PlayNote Asharp, 4
	PlayNote Cnote, 5
	UseTempo 4
	PlayNote Asharp, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Dsharp, 5
	UseTempo 8
	PlayNote Cnote, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 1
	PlayNote Gsharp, 4
	PlayNote Asharp, 4
	UseTempo 4
	PlayNote Gsharp, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Dnote, 5
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Dsharp, 5
	UseTempo 4
	PlayNote Asharp, 4
	UseTempo 7
	DisableEnvelope
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Asharp, 4
	UseTempo 4
	PlayNote Gnote, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Asharp, 4
	UseTempo 1
	PlayNote Asharp, 4
	PlayNote Cnote, 5
	UseTempo 4
	PlayNote Gsharp, 4
	UseTempo 7
	DisableEnvelope
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dsharp, 4
	UseTempo 4
	PlayNote Dnote, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Fnote, 4
	UseTempo 7
	PlayNote Gsharp, 4
	UseTempo 4
	PlayNote Gnote, 4
	UseTempo 2
	DisableEnvelope
	NextSection
	
Song3_Sq1_Section2Data:
	SetParams $84, $41
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gsharp, 4
	UseTempo 4
	PlayNote Gnote, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Gnote, 4
	UseTempo 8
	PlayNote Gsharp, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 1
	PlayNote Fnote, 4
	PlayNote Gnote, 4
	UseTempo 4
	PlayNote Fnote, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Fnote, 4
	UseTempo 1
	PlayNote Fnote, 4
	PlayNote Gnote, 4
	UseTempo 4
	PlayNote Gnote, 4
	UseTempo 7
	DisableEnvelope
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Cnote, 4
	UseTempo 4
	PlayNote Asharp, 3
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dsharp, 4
	UseTempo 4
	PlayNote Cnote, 4
	UseTempo 7
	DisableEnvelope
	UseTempo 1
	PlayNote Asharp, 3
	PlayNote Cnote, 4
	UseTempo 4
	PlayNote Asharp, 3
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Gsharp, 3
	UseTempo 7
	PlayNote Bnote, 3
	UseTempo 4
	PlayNote Asharp, 3
	UseTempo 2
	DisableEnvelope
	NextSection
	
Song3_Wav_Section2Data:
	UseTempo 2
	PlayNote Dsharp, 4
	PlayNote Dsharp, 4
	DisableEnvelope
	PlayNote Dsharp, 4
	PlayNote Dsharp, 4
	PlayNote Dsharp, 4
	DisableEnvelope
	PlayNote Dsharp, 4
	NextSection

Song3_Wav_Section3Data:
	PlayNote Asharp, 3
	PlayNote Asharp, 3
	DisableEnvelope
	PlayNote Asharp, 3
	PlayNote Asharp, 3
	PlayNote Asharp, 3
	DisableEnvelope
	PlayNote Asharp, 3
	NextSection

Song3_Wav_Section4Data:
	PlayNote Gsharp, 3
	PlayNote Gsharp, 3
	DisableEnvelope
	PlayNote Gsharp, 3
	PlayNote Gsharp, 3
	PlayNote Gsharp, 3
	DisableEnvelope
	PlayNote Gsharp, 3
	NextSection

Song3_Wav_Section5Data:
	UseTempo 2
	PlayNote Dsharp, 4
	PlayNote Dsharp, 4
	DisableEnvelope
	PlayNote Dsharp, 4
	PlayNote Dnote, 4
	PlayNote Dnote, 4
	DisableEnvelope
	PlayNote Dnote, 4
	NextSection

Song3_Wav_Section6Data:
	PlayNote Cnote, 4
	PlayNote Cnote, 4
	DisableEnvelope
	PlayNote Cnote, 4
	PlayNote Asharp, 3
	PlayNote Asharp, 3
	DisableEnvelope
	PlayNote Asharp, 3
	NextSection

Song3_Noise_Section2Data:
	and  d                                           ; $781a: $a2
	ld   b, $0b                                      ; $781b: $06 $0b
	ld   bc, $0606                                   ; $781d: $01 $06 $06
	dec  bc                                          ; $7820: $0b
	ld   bc, $0606                                   ; $7821: $01 $06 $06
	dec  bc                                          ; $7824: $0b
	ld   bc, $0606                                   ; $7825: $01 $06 $06
	dec  bc                                          ; $7828: $0b
	ld   bc, $0606                                   ; $7829: $01 $06 $06
	dec  bc                                          ; $782c: $0b
	ld   bc, $0606                                   ; $782d: $01 $06 $06
	dec  bc                                          ; $7830: $0b
	ld   bc, $0606                                   ; $7831: $01 $06 $06
	dec  bc                                          ; $7834: $0b
	ld   bc, $0106                                   ; $7835: $01 $06 $01
	dec  bc                                          ; $7838: $0b
	ld   bc, $000b                                   ; $7839: $01 $0b $00


Song3_Sq1_Section3Data:
	SetParams $66, $81
	UseTempo 7
	PlayNote Gnote, 5
	PlayNote Gsharp, 5
	UseTempo 3
	PlayNote Gnote, 5
	UseTempo 7
	PlayNote Asharp, 5
	UseTempo 4
	PlayNote Gsharp, 5
	UseTempo 2
	DisableEnvelope
	UseTempo 7
	PlayNote Dsharp, 5
	PlayNote Fnote, 5
	UseTempo 3
	PlayNote Gnote, 5
	UseTempo 7
	PlayNote Gsharp, 5
	UseTempo 4
	PlayNote Gnote, 5
	UseTempo 2
	DisableEnvelope
	UseTempo 7
	PlayNote Dsharp, 5
	UseTempo 3
	PlayNote Dnote, 5
	UseTempo 7
	PlayNote Dnote, 5
	PlayNote Gnote, 5
	PlayNote Fnote, 5
	UseTempo 3
	PlayNote Cnote, 5
	UseTempo 7
	PlayNote Gsharp, 5
	PlayNote Asharp, 5
	UseTempo 3
	PlayNote Gsharp, 5
	UseTempo 7
	PlayNote Fnote, 5
	UseTempo 4
	PlayNote Dsharp, 5
	UseTempo 2
	DisableEnvelope
	NextSection



	db $8e                                   ; $786c: $8e
	ld   a, b                                        ; $786d: $78
	ld   de, $8e79                                   ; $786e: $11 $79 $8e
	ld   a, b                                        ; $7871: $78
	sub  [hl]                                        ; $7872: $96
	ld   a, c                                        ; $7873: $79
	nop                                              ; $7874: $00
	nop                                              ; $7875: $00
	xor  l                                           ; $7876: $ad
	ld   a, b                                        ; $7877: $78
	jr   c, jr_001_78f3                              ; $7878: $38 $79

	xor  l                                           ; $787a: $ad
	ld   a, b                                        ; $787b: $78

jr_001_787c:
	cp   d                                           ; $787c: $ba
	ld   a, c                                        ; $787d: $79
	push de                                          ; $787e: $d5
	ld   a, b                                        ; $787f: $78
	ld   e, [hl]                                     ; $7880: $5e
	ld   a, c                                        ; $7881: $79
	push de                                          ; $7882: $d5
	ld   a, b                                        ; $7883: $78
	db   $dd                                         ; $7884: $dd
	ld   a, c                                        ; $7885: $79
	cp   $78                                         ; $7886: $fe $78
	add  h                                           ; $7888: $84
	ld   a, c                                        ; $7889: $79
	cp   $78                                         ; $788a: $fe $78
	add  h                                           ; $788c: $84
	ld   a, c                                        ; $788d: $79
	sbc  l                                           ; $788e: $9d
	pop  de                                          ; $788f: $d1
	nop                                              ; $7890: $00
	add  b                                           ; $7891: $80
	and  d                                           ; $7892: $a2
	ld   e, h                                        ; $7893: $5c
	and  c                                           ; $7894: $a1
	ld   e, h                                        ; $7895: $5c
	ld   e, d                                        ; $7896: $5a
	and  d                                           ; $7897: $a2
	ld   e, h                                        ; $7898: $5c
	ld   e, h                                        ; $7899: $5c
	ld   d, [hl]                                     ; $789a: $56
	ld   d, d                                        ; $789b: $52
	ld   c, [hl]                                     ; $789c: $4e
	ld   d, [hl]                                     ; $789d: $56
	and  d                                           ; $789e: $a2
	ld   d, d                                        ; $789f: $52
	and  c                                           ; $78a0: $a1
	ld   d, d                                        ; $78a1: $52
	ld   d, b                                        ; $78a2: $50
	and  d                                           ; $78a3: $a2
	ld   d, d                                        ; $78a4: $52
	ld   d, d                                        ; $78a5: $52
	ld   c, h                                        ; $78a6: $4c
	ld   c, b                                        ; $78a7: $48
	ld   b, h                                        ; $78a8: $44
	and  c                                           ; $78a9: $a1
	ld   c, h                                        ; $78aa: $4c
	ld   d, d                                        ; $78ab: $52
	nop                                              ; $78ac: $00
	sbc  l                                           ; $78ad: $9d
	or   d                                           ; $78ae: $b2
	nop                                              ; $78af: $00
	add  b                                           ; $78b0: $80
	and  d                                           ; $78b1: $a2
	ld   d, d                                        ; $78b2: $52
	and  c                                           ; $78b3: $a1
	ld   d, d                                        ; $78b4: $52
	ld   d, d                                        ; $78b5: $52
	and  d                                           ; $78b6: $a2
	ld   d, d                                        ; $78b7: $52
	and  c                                           ; $78b8: $a1
	ld   d, d                                        ; $78b9: $52
	ld   d, d                                        ; $78ba: $52
	and  d                                           ; $78bb: $a2
	ld   b, h                                        ; $78bc: $44
	and  c                                           ; $78bd: $a1
	ld   b, h                                        ; $78be: $44
	ld   b, h                                        ; $78bf: $44
	and  d                                           ; $78c0: $a2
	ld   b, h                                        ; $78c1: $44
	ld   bc, $a14c                                   ; $78c2: $01 $4c $a1
	ld   c, h                                        ; $78c5: $4c
	ld   c, h                                        ; $78c6: $4c
	and  d                                           ; $78c7: $a2
	ld   c, h                                        ; $78c8: $4c
	and  c                                           ; $78c9: $a1
	ld   c, h                                        ; $78ca: $4c
	ld   c, h                                        ; $78cb: $4c
	and  d                                           ; $78cc: $a2
	ld   a, [hl-]                                    ; $78cd: $3a
	and  c                                           ; $78ce: $a1
	ld   a, [hl-]                                    ; $78cf: $3a
	ld   a, [hl-]                                    ; $78d0: $3a
	and  d                                           ; $78d1: $a2
	ld   a, [hl-]                                    ; $78d2: $3a
	ld   bc, $9d00                                   ; $78d3: $01 $00 $9d
	jp   hl                                          ; $78d6: $e9


	ld   l, [hl]                                     ; $78d7: $6e
	jr   nz, jr_001_787c                             ; $78d8: $20 $a2

	ld   e, h                                        ; $78da: $5c
	and  c                                           ; $78db: $a1
	ld   e, h                                        ; $78dc: $5c
	ld   e, h                                        ; $78dd: $5c
	and  d                                           ; $78de: $a2
	ld   e, h                                        ; $78df: $5c
	and  c                                           ; $78e0: $a1
	ld   e, h                                        ; $78e1: $5c
	ld   e, h                                        ; $78e2: $5c
	and  d                                           ; $78e3: $a2
	ld   c, [hl]                                     ; $78e4: $4e
	and  c                                           ; $78e5: $a1
	ld   d, d                                        ; $78e6: $52
	ld   d, d                                        ; $78e7: $52
	and  d                                           ; $78e8: $a2
	ld   d, [hl]                                     ; $78e9: $56
	ld   bc, $5ca2                                   ; $78ea: $01 $a2 $5c
	and  c                                           ; $78ed: $a1
	ld   e, h                                        ; $78ee: $5c
	ld   e, h                                        ; $78ef: $5c
	and  d                                           ; $78f0: $a2
	ld   e, h                                        ; $78f1: $5c
	and  c                                           ; $78f2: $a1

jr_001_78f3:
	ld   e, h                                        ; $78f3: $5c
	ld   e, h                                        ; $78f4: $5c
	and  d                                           ; $78f5: $a2
	ld   b, h                                        ; $78f6: $44
	and  c                                           ; $78f7: $a1
	ld   c, b                                        ; $78f8: $48
	ld   c, b                                        ; $78f9: $48
	and  d                                           ; $78fa: $a2
	ld   c, h                                        ; $78fb: $4c
	ld   bc, $a200                                   ; $78fc: $01 $00 $a2
	ld   b, $a7                                      ; $78ff: $06 $a7
	ld   bc, $0ba2                                   ; $7901: $01 $a2 $0b
	dec  bc                                          ; $7904: $0b
	dec  bc                                          ; $7905: $0b
	ld   bc, $06a2                                   ; $7906: $01 $a2 $06
	and  a                                           ; $7909: $a7
	ld   bc, $0ba2                                   ; $790a: $01 $a2 $0b
	dec  bc                                          ; $790d: $0b
	dec  bc                                          ; $790e: $0b
	ld   bc, $a200                                   ; $790f: $01 $00 $a2
	ld   c, b                                        ; $7912: $48
	and  c                                           ; $7913: $a1
	ld   c, b                                        ; $7914: $48
	ld   d, d                                        ; $7915: $52
	and  d                                           ; $7916: $a2
	ld   b, h                                        ; $7917: $44
	and  c                                           ; $7918: $a1
	ld   b, h                                        ; $7919: $44
	ld   d, d                                        ; $791a: $52
	and  d                                           ; $791b: $a2
	ld   b, d                                        ; $791c: $42
	and  c                                           ; $791d: $a1
	ld   b, d                                        ; $791e: $42
	ld   d, d                                        ; $791f: $52
	and  d                                           ; $7920: $a2
	ld   c, b                                        ; $7921: $48
	and  c                                           ; $7922: $a1
	ld   c, b                                        ; $7923: $48
	ld   d, d                                        ; $7924: $52
	and  d                                           ; $7925: $a2
	ld   c, h                                        ; $7926: $4c
	and  c                                           ; $7927: $a1
	ld   c, h                                        ; $7928: $4c
	ld   d, d                                        ; $7929: $52
	and  d                                           ; $792a: $a2
	ld   b, h                                        ; $792b: $44
	and  c                                           ; $792c: $a1
	ld   b, h                                        ; $792d: $44
	ld   d, d                                        ; $792e: $52
	and  d                                           ; $792f: $a2
	ld   c, b                                        ; $7930: $48
	ld   b, h                                        ; $7931: $44
	and  c                                           ; $7932: $a1
	ld   c, b                                        ; $7933: $48
	ld   d, d                                        ; $7934: $52
	ld   d, [hl]                                     ; $7935: $56
	ld   e, d                                        ; $7936: $5a
	nop                                              ; $7937: $00
	ld   a, [hl-]                                    ; $7938: $3a
	and  c                                           ; $7939: $a1
	ld   a, [hl-]                                    ; $793a: $3a
	ld   a, [hl-]                                    ; $793b: $3a
	and  d                                           ; $793c: $a2
	ld   a, [hl-]                                    ; $793d: $3a
	and  c                                           ; $793e: $a1
	ld   a, [hl-]                                    ; $793f: $3a
	ld   a, [hl-]                                    ; $7940: $3a
	and  d                                           ; $7941: $a2
	ld   a, [hl-]                                    ; $7942: $3a
	and  c                                           ; $7943: $a1
	ld   a, [hl-]                                    ; $7944: $3a
	ld   a, [hl-]                                    ; $7945: $3a
	and  d                                           ; $7946: $a2
	ld   a, [hl-]                                    ; $7947: $3a
	and  c                                           ; $7948: $a1
	ld   a, [hl-]                                    ; $7949: $3a
	ld   a, [hl-]                                    ; $794a: $3a
	and  d                                           ; $794b: $a2
	ld   a, [hl-]                                    ; $794c: $3a
	and  c                                           ; $794d: $a1
	ld   a, [hl-]                                    ; $794e: $3a
	ld   a, [hl-]                                    ; $794f: $3a
	and  d                                           ; $7950: $a2
	ld   a, [hl-]                                    ; $7951: $3a
	and  c                                           ; $7952: $a1
	ld   a, [hl-]                                    ; $7953: $3a
	ld   a, [hl-]                                    ; $7954: $3a
	and  d                                           ; $7955: $a2
	ld   [hl], $a1                                   ; $7956: $36 $a1
	ld   [hl], $36                                   ; $7958: $36 $36
	and  d                                           ; $795a: $a2
	ld   [hl], $01                                   ; $795b: $36 $01
	nop                                              ; $795d: $00
	ld   c, b                                        ; $795e: $48
	and  c                                           ; $795f: $a1
	ld   c, b                                        ; $7960: $48
	ld   c, b                                        ; $7961: $48
	and  d                                           ; $7962: $a2
	ld   c, b                                        ; $7963: $48
	and  c                                           ; $7964: $a1
	ld   c, b                                        ; $7965: $48
	ld   c, b                                        ; $7966: $48
	and  d                                           ; $7967: $a2
	ld   c, b                                        ; $7968: $48
	and  c                                           ; $7969: $a1
	ld   c, b                                        ; $796a: $48
	ld   c, b                                        ; $796b: $48
	and  d                                           ; $796c: $a2
	ld   c, b                                        ; $796d: $48
	and  c                                           ; $796e: $a1
	ld   c, b                                        ; $796f: $48
	ld   c, b                                        ; $7970: $48
	and  d                                           ; $7971: $a2
	ld   b, h                                        ; $7972: $44
	and  c                                           ; $7973: $a1
	ld   b, h                                        ; $7974: $44
	ld   b, h                                        ; $7975: $44
	and  d                                           ; $7976: $a2
	ld   b, h                                        ; $7977: $44
	and  c                                           ; $7978: $a1
	ld   b, h                                        ; $7979: $44
	ld   b, h                                        ; $797a: $44
	and  d                                           ; $797b: $a2
	ld   b, d                                        ; $797c: $42
	and  c                                           ; $797d: $a1
	ld   b, d                                        ; $797e: $42
	ld   b, d                                        ; $797f: $42
	and  d                                           ; $7980: $a2
	ld   b, d                                        ; $7981: $42
	ld   bc, $a200                                   ; $7982: $01 $00 $a2
	ld   bc, $010b                                   ; $7985: $01 $0b $01
	dec  bc                                          ; $7988: $0b
	ld   bc, $010b                                   ; $7989: $01 $0b $01
	dec  bc                                          ; $798c: $0b
	ld   bc, $010b                                   ; $798d: $01 $0b $01
	dec  bc                                          ; $7990: $0b
	ld   bc, $0b0b                                   ; $7991: $01 $0b $0b
	ld   bc, $a200                                   ; $7994: $01 $00 $a2
	ld   c, b                                        ; $7997: $48
	and  c                                           ; $7998: $a1
	ld   c, b                                        ; $7999: $48
	ld   d, d                                        ; $799a: $52
	and  d                                           ; $799b: $a2
	ld   b, h                                        ; $799c: $44
	and  c                                           ; $799d: $a1
	ld   b, h                                        ; $799e: $44
	ld   d, d                                        ; $799f: $52
	and  d                                           ; $79a0: $a2
	ld   b, d                                        ; $79a1: $42
	and  c                                           ; $79a2: $a1
	ld   b, d                                        ; $79a3: $42
	ld   d, d                                        ; $79a4: $52
	and  d                                           ; $79a5: $a2
	ld   c, b                                        ; $79a6: $48
	and  c                                           ; $79a7: $a1
	ld   c, b                                        ; $79a8: $48
	ld   d, d                                        ; $79a9: $52
	and  d                                           ; $79aa: $a2
	ld   c, h                                        ; $79ab: $4c
	and  c                                           ; $79ac: $a1
	ld   c, h                                        ; $79ad: $4c
	ld   d, d                                        ; $79ae: $52
	and  d                                           ; $79af: $a2
	ld   c, b                                        ; $79b0: $48
	and  c                                           ; $79b1: $a1
	ld   c, b                                        ; $79b2: $48
	ld   d, d                                        ; $79b3: $52
	and  d                                           ; $79b4: $a2
	ld   b, h                                        ; $79b5: $44
	ld   d, d                                        ; $79b6: $52
	and  e                                           ; $79b7: $a3
	ld   e, h                                        ; $79b8: $5c
	nop                                              ; $79b9: $00
	ld   a, [hl-]                                    ; $79ba: $3a
	and  c                                           ; $79bb: $a1
	ld   a, [hl-]                                    ; $79bc: $3a
	ld   a, [hl-]                                    ; $79bd: $3a
	and  d                                           ; $79be: $a2
	ld   a, [hl-]                                    ; $79bf: $3a
	and  c                                           ; $79c0: $a1
	ld   a, [hl-]                                    ; $79c1: $3a
	ld   a, [hl-]                                    ; $79c2: $3a
	and  d                                           ; $79c3: $a2
	ld   a, [hl-]                                    ; $79c4: $3a
	and  c                                           ; $79c5: $a1
	ld   a, [hl-]                                    ; $79c6: $3a
	ld   a, [hl-]                                    ; $79c7: $3a
	and  d                                           ; $79c8: $a2
	ld   a, [hl-]                                    ; $79c9: $3a
	and  c                                           ; $79ca: $a1
	ld   a, [hl-]                                    ; $79cb: $3a
	ld   a, [hl-]                                    ; $79cc: $3a
	and  d                                           ; $79cd: $a2
	ld   a, [hl-]                                    ; $79ce: $3a
	and  c                                           ; $79cf: $a1
	ld   a, [hl-]                                    ; $79d0: $3a
	ld   a, [hl-]                                    ; $79d1: $3a
	and  d                                           ; $79d2: $a2
	ld   a, [hl-]                                    ; $79d3: $3a
	and  c                                           ; $79d4: $a1
	ld   a, [hl-]                                    ; $79d5: $3a
	ld   a, [hl-]                                    ; $79d6: $3a
	and  d                                           ; $79d7: $a2
	ld   bc, $a33a                                   ; $79d8: $01 $3a $a3
	ld   c, h                                        ; $79db: $4c
	nop                                              ; $79dc: $00
	ld   c, b                                        ; $79dd: $48
	and  c                                           ; $79de: $a1
	ld   c, b                                        ; $79df: $48
	ld   c, b                                        ; $79e0: $48
	and  d                                           ; $79e1: $a2
	ld   c, b                                        ; $79e2: $48
	and  c                                           ; $79e3: $a1
	ld   c, b                                        ; $79e4: $48
	ld   c, b                                        ; $79e5: $48
	and  d                                           ; $79e6: $a2
	ld   c, b                                        ; $79e7: $48
	and  c                                           ; $79e8: $a1
	ld   c, b                                        ; $79e9: $48
	ld   c, b                                        ; $79ea: $48
	and  d                                           ; $79eb: $a2
	ld   c, b                                        ; $79ec: $48
	and  c                                           ; $79ed: $a1
	ld   c, b                                        ; $79ee: $48
	ld   c, b                                        ; $79ef: $48
	and  d                                           ; $79f0: $a2
	ld   b, h                                        ; $79f1: $44

jr_001_79f2:
	and  c                                           ; $79f2: $a1
	ld   b, h                                        ; $79f3: $44
	ld   b, h                                        ; $79f4: $44
	and  d                                           ; $79f5: $a2
	ld   b, h                                        ; $79f6: $44
	and  c                                           ; $79f7: $a1
	ld   b, h                                        ; $79f8: $44
	ld   b, h                                        ; $79f9: $44
	and  d                                           ; $79fa: $a2
	ld   bc, $a34c                                   ; $79fb: $01 $4c $a3
	ld   b, h                                        ; $79fe: $44
	nop                                              ; $79ff: $00
	inc  b                                           ; $7a00: $04
	ld   a, d                                        ; $7a01: $7a
	nop                                              ; $7a02: $00
	nop                                              ; $7a03: $00
	sbc  l                                           ; $7a04: $9d
	jp   nz, $4000                           ; $7a05: $c2 $00 $40

	and  d                                           ; $7a08: $a2
	ld   e, h                                        ; $7a09: $5c
	and  c                                           ; $7a0a: $a1
	ld   e, h                                        ; $7a0b: $5c
	ld   e, d                                        ; $7a0c: $5a
	and  d                                           ; $7a0d: $a2
	ld   e, h                                        ; $7a0e: $5c
	ld   e, h                                        ; $7a0f: $5c
	ld   d, [hl]                                     ; $7a10: $56
	ld   d, d                                        ; $7a11: $52
	ld   c, [hl]                                     ; $7a12: $4e
	ld   d, [hl]                                     ; $7a13: $56
	and  d                                           ; $7a14: $a2
	ld   d, d                                        ; $7a15: $52
	and  c                                           ; $7a16: $a1
	ld   d, d                                        ; $7a17: $52
	ld   d, b                                        ; $7a18: $50
	and  d                                           ; $7a19: $a2
	ld   d, d                                        ; $7a1a: $52
	ld   d, d                                        ; $7a1b: $52
	ld   c, h                                        ; $7a1c: $4c
	ld   c, b                                        ; $7a1d: $48
	and  c                                           ; $7a1e: $a1
	ld   b, h                                        ; $7a1f: $44
	ld   b, d                                        ; $7a20: $42
	and  d                                           ; $7a21: $a2
	ld   b, h                                        ; $7a22: $44
	and  h                                           ; $7a23: $a4
	ld   bc, $2c00                                   ; $7a24: $01 $00 $2c
	ld   a, d                                        ; $7a27: $7a
	nop                                              ; $7a28: $00
	nop                                              ; $7a29: $00
	ld   c, e                                        ; $7a2a: $4b
	ld   a, d                                        ; $7a2b: $7a
	sbc  l                                           ; $7a2c: $9d
	jp   nz, $8000                                   ; $7a2d: $c2 $00 $80

	and  d                                           ; $7a30: $a2
	ld   e, h                                        ; $7a31: $5c
	and  c                                           ; $7a32: $a1
	ld   e, h                                        ; $7a33: $5c
	ld   e, d                                        ; $7a34: $5a
	and  d                                           ; $7a35: $a2
	ld   e, h                                        ; $7a36: $5c
	ld   e, h                                        ; $7a37: $5c
	ld   d, [hl]                                     ; $7a38: $56
	ld   d, d                                        ; $7a39: $52
	ld   c, [hl]                                     ; $7a3a: $4e
	ld   d, [hl]                                     ; $7a3b: $56
	and  d                                           ; $7a3c: $a2
	ld   d, d                                        ; $7a3d: $52
	and  c                                           ; $7a3e: $a1
	ld   d, d                                        ; $7a3f: $52
	ld   d, b                                        ; $7a40: $50
	and  d                                           ; $7a41: $a2
	ld   d, d                                        ; $7a42: $52
	ld   c, h                                        ; $7a43: $4c
	ld   b, h                                        ; $7a44: $44
	ld   d, d                                        ; $7a45: $52
	and  e                                           ; $7a46: $a3
	ld   e, h                                        ; $7a47: $5c
	and  h                                           ; $7a48: $a4
	ld   bc, $9d00                                   ; $7a49: $01 $00 $9d
	jp   hl                                          ; $7a4c: $e9


	ld   l, [hl]                                     ; $7a4d: $6e
	jr   nz, jr_001_79f2                             ; $7a4e: $20 $a2

	ld   e, h                                        ; $7a50: $5c
	and  c                                           ; $7a51: $a1
	ld   e, h                                        ; $7a52: $5c
	ld   e, h                                        ; $7a53: $5c
	and  d                                           ; $7a54: $a2
	ld   e, h                                        ; $7a55: $5c
	and  c                                           ; $7a56: $a1
	ld   e, h                                        ; $7a57: $5c
	ld   e, h                                        ; $7a58: $5c
	and  d                                           ; $7a59: $a2
	ld   c, [hl]                                     ; $7a5a: $4e

jr_001_7a5b:
	ld   d, d                                        ; $7a5b: $52
	ld   d, [hl]                                     ; $7a5c: $56
	ld   bc, $5ca2                                   ; $7a5d: $01 $a2 $5c
	and  c                                           ; $7a60: $a1
	ld   e, h                                        ; $7a61: $5c
	ld   e, h                                        ; $7a62: $5c
	and  d                                           ; $7a63: $a2
	ld   e, h                                        ; $7a64: $5c
	and  c                                           ; $7a65: $a1
	ld   e, h                                        ; $7a66: $5c
	ld   e, h                                        ; $7a67: $5c
	and  d                                           ; $7a68: $a2
	ld   d, d                                        ; $7a69: $52
	ld   c, h                                        ; $7a6a: $4c
	ld   b, h                                        ; $7a6b: $44
	ld   bc, $01a5                                   ; $7a6c: $01 $a5 $01
	ld   [hl], a                                     ; $7a6f: $77
	ld   a, d                                        ; $7a70: $7a
	nop                                              ; $7a71: $00
	nop                                              ; $7a72: $00
	sub  [hl]                                        ; $7a73: $96
	ld   a, d                                        ; $7a74: $7a
	or   h                                           ; $7a75: $b4
	ld   a, d                                        ; $7a76: $7a
	sbc  l                                           ; $7a77: $9d
	jp   nz, $8000                                   ; $7a78: $c2 $00 $80

	and  d                                           ; $7a7b: $a2
	ld   e, h                                        ; $7a7c: $5c
	and  c                                           ; $7a7d: $a1
	ld   e, h                                        ; $7a7e: $5c
	ld   e, d                                        ; $7a7f: $5a
	and  d                                           ; $7a80: $a2
	ld   e, h                                        ; $7a81: $5c
	ld   e, h                                        ; $7a82: $5c
	ld   d, [hl]                                     ; $7a83: $56
	ld   d, d                                        ; $7a84: $52
	ld   c, [hl]                                     ; $7a85: $4e
	ld   d, [hl]                                     ; $7a86: $56
	and  d                                           ; $7a87: $a2
	ld   d, d                                        ; $7a88: $52
	and  c                                           ; $7a89: $a1
	ld   d, d                                        ; $7a8a: $52
	ld   d, b                                        ; $7a8b: $50
	and  d                                           ; $7a8c: $a2
	ld   d, d                                        ; $7a8d: $52
	ld   c, h                                        ; $7a8e: $4c
	ld   b, h                                        ; $7a8f: $44
	ld   d, d                                        ; $7a90: $52
	and  e                                           ; $7a91: $a3
	ld   e, h                                        ; $7a92: $5c
	and  h                                           ; $7a93: $a4
	ld   bc, $9d00                                   ; $7a94: $01 $00 $9d
	jp   nz, $4000                           ; $7a97: $c2 $00 $40

	and  d                                           ; $7a9a: $a2
	ld   c, [hl]                                     ; $7a9b: $4e
	and  c                                           ; $7a9c: $a1
	ld   c, [hl]                                     ; $7a9d: $4e
	ld   d, d                                        ; $7a9e: $52
	and  d                                           ; $7a9f: $a2
	ld   d, [hl]                                     ; $7aa0: $56
	ld   c, [hl]                                     ; $7aa1: $4e
	and  e                                           ; $7aa2: $a3
	ld   c, b                                        ; $7aa3: $48
	ld   c, b                                        ; $7aa4: $48
	and  d                                           ; $7aa5: $a2
	ld   c, h                                        ; $7aa6: $4c
	and  c                                           ; $7aa7: $a1
	ld   c, h                                        ; $7aa8: $4c
	ld   c, d                                        ; $7aa9: $4a
	and  d                                           ; $7aaa: $a2
	ld   c, h                                        ; $7aab: $4c
	ld   b, h                                        ; $7aac: $44
	inc  [hl]                                        ; $7aad: $34
	ld   c, h                                        ; $7aae: $4c
	and  e                                           ; $7aaf: $a3
	ld   c, h                                        ; $7ab0: $4c
	and  l                                           ; $7ab1: $a5
	ld   bc, $9d00                                   ; $7ab2: $01 $00 $9d
	jp   hl                                          ; $7ab5: $e9


	ld   l, [hl]                                     ; $7ab6: $6e
	jr   nz, jr_001_7a5b                             ; $7ab7: $20 $a2

	ld   e, h                                        ; $7ab9: $5c
	and  c                                           ; $7aba: $a1
	ld   e, h                                        ; $7abb: $5c
	ld   e, h                                        ; $7abc: $5c
	and  d                                           ; $7abd: $a2
	ld   e, h                                        ; $7abe: $5c
	and  c                                           ; $7abf: $a1
	ld   e, h                                        ; $7ac0: $5c
	ld   e, h                                        ; $7ac1: $5c
	and  d                                           ; $7ac2: $a2
	ld   c, [hl]                                     ; $7ac3: $4e
	ld   d, d                                        ; $7ac4: $52
	and  c                                           ; $7ac5: $a1
	ld   d, [hl]                                     ; $7ac6: $56
	ld   d, [hl]                                     ; $7ac7: $56
	and  d                                           ; $7ac8: $a2
	ld   d, [hl]                                     ; $7ac9: $56
	and  d                                           ; $7aca: $a2
	ld   e, h                                        ; $7acb: $5c

jr_001_7acc:
	and  c                                           ; $7acc: $a1
	ld   e, h                                        ; $7acd: $5c
	ld   e, h                                        ; $7ace: $5c
	and  d                                           ; $7acf: $a2
	ld   e, h                                        ; $7ad0: $5c
	and  c                                           ; $7ad1: $a1
	ld   e, h                                        ; $7ad2: $5c
	ld   e, h                                        ; $7ad3: $5c
	and  d                                           ; $7ad4: $a2
	ld   d, d                                        ; $7ad5: $52
	ld   c, h                                        ; $7ad6: $4c
	and  c                                           ; $7ad7: $a1
	ld   b, h                                        ; $7ad8: $44
	ld   b, h                                        ; $7ad9: $44
	and  d                                           ; $7ada: $a2
	ld   bc, $01a5                                   ; $7adb: $01 $a5 $01
	nop                                              ; $7ade: $00
	jp   hl                                          ; $7adf: $e9


	ld   a, d                                        ; $7ae0: $7a
	nop                                              ; $7ae1: $00
	nop                                              ; $7ae2: $00
	ld   [$257b], sp                                 ; $7ae3: $08 $7b $25
	ld   a, e                                        ; $7ae6: $7b
	ld   c, a                                        ; $7ae7: $4f
	ld   a, e                                        ; $7ae8: $7b
	sbc  l                                           ; $7ae9: $9d
	jp   nz, $8000                                   ; $7aea: $c2 $00 $80

	and  d                                           ; $7aed: $a2
	ld   e, h                                        ; $7aee: $5c
	and  c                                           ; $7aef: $a1
	ld   e, h                                        ; $7af0: $5c
	ld   e, d                                        ; $7af1: $5a
	and  d                                           ; $7af2: $a2
	ld   e, h                                        ; $7af3: $5c
	ld   e, h                                        ; $7af4: $5c
	ld   d, [hl]                                     ; $7af5: $56
	ld   d, d                                        ; $7af6: $52
	ld   c, [hl]                                     ; $7af7: $4e
	ld   d, [hl]                                     ; $7af8: $56
	and  d                                           ; $7af9: $a2
	ld   d, d                                        ; $7afa: $52
	and  c                                           ; $7afb: $a1
	ld   d, d                                        ; $7afc: $52
	ld   d, b                                        ; $7afd: $50
	and  d                                           ; $7afe: $a2
	ld   d, d                                        ; $7aff: $52
	ld   c, h                                        ; $7b00: $4c
	ld   b, h                                        ; $7b01: $44
	ld   d, d                                        ; $7b02: $52
	and  e                                           ; $7b03: $a3
	ld   e, h                                        ; $7b04: $5c
	and  h                                           ; $7b05: $a4
	ld   bc, $9d00                                   ; $7b06: $01 $00 $9d
	or   d                                           ; $7b09: $b2
	nop                                              ; $7b0a: $00
	add  b                                           ; $7b0b: $80
	and  d                                           ; $7b0c: $a2
	ld   c, [hl]                                     ; $7b0d: $4e
	and  c                                           ; $7b0e: $a1
	ld   c, [hl]                                     ; $7b0f: $4e
	ld   d, d                                        ; $7b10: $52
	and  d                                           ; $7b11: $a2
	ld   d, [hl]                                     ; $7b12: $56
	ld   c, [hl]                                     ; $7b13: $4e
	and  e                                           ; $7b14: $a3
	ld   c, b                                        ; $7b15: $48
	ld   c, b                                        ; $7b16: $48
	and  d                                           ; $7b17: $a2
	ld   c, h                                        ; $7b18: $4c
	and  c                                           ; $7b19: $a1
	ld   c, h                                        ; $7b1a: $4c
	ld   c, d                                        ; $7b1b: $4a
	and  d                                           ; $7b1c: $a2
	ld   c, h                                        ; $7b1d: $4c
	ld   b, h                                        ; $7b1e: $44
	inc  [hl]                                        ; $7b1f: $34
	ld   c, h                                        ; $7b20: $4c
	and  e                                           ; $7b21: $a3
	ld   c, h                                        ; $7b22: $4c
	and  l                                           ; $7b23: $a5
	ld   bc, $e99d                                   ; $7b24: $01 $9d $e9
	ld   l, [hl]                                     ; $7b27: $6e
	jr   nz, jr_001_7acc                             ; $7b28: $20 $a2

	ld   e, h                                        ; $7b2a: $5c
	and  c                                           ; $7b2b: $a1
	ld   e, h                                        ; $7b2c: $5c
	ld   e, h                                        ; $7b2d: $5c
	and  d                                           ; $7b2e: $a2
	ld   e, h                                        ; $7b2f: $5c
	and  c                                           ; $7b30: $a1
	ld   e, h                                        ; $7b31: $5c
	ld   e, h                                        ; $7b32: $5c
	ld   c, [hl]                                     ; $7b33: $4e
	ld   d, [hl]                                     ; $7b34: $56
	ld   e, h                                        ; $7b35: $5c
	ld   d, [hl]                                     ; $7b36: $56
	ld   c, [hl]                                     ; $7b37: $4e
	ld   b, h                                        ; $7b38: $44
	ld   a, $44                                      ; $7b39: $3e $44
	and  d                                           ; $7b3b: $a2
	ld   e, h                                        ; $7b3c: $5c
	and  c                                           ; $7b3d: $a1
	ld   e, h                                        ; $7b3e: $5c
	ld   e, h                                        ; $7b3f: $5c
	and  d                                           ; $7b40: $a2
	ld   e, h                                        ; $7b41: $5c
	and  c                                           ; $7b42: $a1
	ld   e, h                                        ; $7b43: $5c
	ld   e, h                                        ; $7b44: $5c
	ld   d, d                                        ; $7b45: $52
	ld   c, h                                        ; $7b46: $4c
	ld   b, h                                        ; $7b47: $44
	ld   c, h                                        ; $7b48: $4c
	ld   e, h                                        ; $7b49: $5c
	ld   bc, $01a2                                   ; $7b4a: $01 $a2 $01
	and  l                                           ; $7b4d: $a5
	ld   bc, $0ba2                                   ; $7b4e: $01 $a2 $0b
	dec  bc                                          ; $7b51: $0b
	dec  bc                                          ; $7b52: $0b
	dec  bc                                          ; $7b53: $0b
	and  d                                           ; $7b54: $a2
	dec  bc                                          ; $7b55: $0b
	dec  bc                                          ; $7b56: $0b
	dec  bc                                          ; $7b57: $0b
	ld   bc, $0ba2                                   ; $7b58: $01 $a2 $0b
	dec  bc                                          ; $7b5b: $0b
	dec  bc                                          ; $7b5c: $0b
	dec  bc                                          ; $7b5d: $0b
	and  d                                           ; $7b5e: $a2
	dec  bc                                          ; $7b5f: $0b
	dec  bc                                          ; $7b60: $0b
	dec  bc                                          ; $7b61: $0b
	ld   bc, $01a5                                   ; $7b62: $01 $a5 $01
	ld   [hl], a                                     ; $7b65: $77
	ld   a, e                                        ; $7b66: $7b
	adc  $7b                                         ; $7b67: $ce $7b
	nop                                              ; $7b69: $00
	nop                                              ; $7b6a: $00
	sub  [hl]                                        ; $7b6b: $96
	ld   a, e                                        ; $7b6c: $7b
	ldh  a, [c]                                      ; $7b6d: $f2
	ld   a, e                                        ; $7b6e: $7b
	xor  b                                           ; $7b6f: $a8
	ld   a, e                                        ; $7b70: $7b
	ld   [bc], a                                     ; $7b71: $02
	ld   a, h                                        ; $7b72: $7c
	cp   e                                           ; $7b73: $bb
	ld   a, e                                        ; $7b74: $7b
	ld   [de], a                                     ; $7b75: $12
	ld   a, h                                        ; $7b76: $7c
	sbc  l                                           ; $7b77: $9d
	pop  de                                          ; $7b78: $d1
	nop                                              ; $7b79: $00
	add  b                                           ; $7b7a: $80
	and  d                                           ; $7b7b: $a2
	ld   e, h                                        ; $7b7c: $5c
	and  c                                           ; $7b7d: $a1
	ld   e, h                                        ; $7b7e: $5c
	ld   e, d                                        ; $7b7f: $5a
	and  d                                           ; $7b80: $a2
	ld   e, h                                        ; $7b81: $5c
	ld   e, h                                        ; $7b82: $5c
	ld   d, [hl]                                     ; $7b83: $56
	ld   d, d                                        ; $7b84: $52
	ld   c, [hl]                                     ; $7b85: $4e
	ld   d, [hl]                                     ; $7b86: $56
	and  d                                           ; $7b87: $a2
	ld   d, d                                        ; $7b88: $52
	and  c                                           ; $7b89: $a1
	ld   d, d                                        ; $7b8a: $52
	ld   d, b                                        ; $7b8b: $50
	and  d                                           ; $7b8c: $a2
	ld   d, d                                        ; $7b8d: $52
	ld   d, d                                        ; $7b8e: $52
	ld   c, h                                        ; $7b8f: $4c
	ld   c, b                                        ; $7b90: $48
	ld   b, h                                        ; $7b91: $44
	and  c                                           ; $7b92: $a1
	ld   c, h                                        ; $7b93: $4c
	ld   d, d                                        ; $7b94: $52
	nop                                              ; $7b95: $00
	and  d                                           ; $7b96: $a2
	ld   d, d                                        ; $7b97: $52
	and  a                                           ; $7b98: $a7
	ld   bc, $44a2                                   ; $7b99: $01 $a2 $44
	ld   b, h                                        ; $7b9c: $44
	ld   b, h                                        ; $7b9d: $44
	ld   bc, $a74c                                   ; $7b9e: $01 $4c $a7
	ld   bc, $3aa2                                   ; $7ba1: $01 $a2 $3a
	ld   a, [hl-]                                    ; $7ba4: $3a
	ld   a, [hl-]                                    ; $7ba5: $3a
	ld   bc, $a200                                   ; $7ba6: $01 $00 $a2
	ld   e, h                                        ; $7ba9: $5c
	and  a                                           ; $7baa: $a7
	ld   bc, $4ea2                                   ; $7bab: $01 $a2 $4e
	ld   d, d                                        ; $7bae: $52
	ld   d, [hl]                                     ; $7baf: $56
	ld   bc, $5ca2                                   ; $7bb0: $01 $a2 $5c
	and  a                                           ; $7bb3: $a7
	ld   bc, $44a2                                   ; $7bb4: $01 $a2 $44
	ld   c, b                                        ; $7bb7: $48
	ld   c, h                                        ; $7bb8: $4c
	ld   bc, $a200                                   ; $7bb9: $01 $00 $a2
	ld   b, $a7                                      ; $7bbc: $06 $a7
	ld   bc, $0ba2                                   ; $7bbe: $01 $a2 $0b
	dec  bc                                          ; $7bc1: $0b
	dec  bc                                          ; $7bc2: $0b
	ld   bc, $06a2                                   ; $7bc3: $01 $a2 $06
	and  a                                           ; $7bc6: $a7
	ld   bc, $0ba2                                   ; $7bc7: $01 $a2 $0b
	dec  bc                                          ; $7bca: $0b
	dec  bc                                          ; $7bcb: $0b
	ld   bc, $a200                                   ; $7bcc: $01 $00 $a2
	ld   c, b                                        ; $7bcf: $48
	and  c                                           ; $7bd0: $a1
	ld   c, b                                        ; $7bd1: $48
	ld   d, d                                        ; $7bd2: $52
	and  d                                           ; $7bd3: $a2
	ld   b, h                                        ; $7bd4: $44
	and  c                                           ; $7bd5: $a1
	ld   b, h                                        ; $7bd6: $44
	ld   d, d                                        ; $7bd7: $52
	and  d                                           ; $7bd8: $a2
	ld   b, d                                        ; $7bd9: $42
	and  c                                           ; $7bda: $a1
	ld   b, d                                        ; $7bdb: $42
	ld   d, d                                        ; $7bdc: $52
	and  d                                           ; $7bdd: $a2
	ld   c, b                                        ; $7bde: $48
	and  c                                           ; $7bdf: $a1
	ld   c, b                                        ; $7be0: $48
	ld   d, d                                        ; $7be1: $52
	and  d                                           ; $7be2: $a2
	ld   c, h                                        ; $7be3: $4c
	and  c                                           ; $7be4: $a1
	ld   c, h                                        ; $7be5: $4c
	ld   d, d                                        ; $7be6: $52
	and  d                                           ; $7be7: $a2
	ld   c, b                                        ; $7be8: $48
	and  c                                           ; $7be9: $a1
	ld   c, b                                        ; $7bea: $48
	ld   d, d                                        ; $7beb: $52
	and  d                                           ; $7bec: $a2
	ld   e, h                                        ; $7bed: $5c
	ld   d, d                                        ; $7bee: $52
	and  e                                           ; $7bef: $a3
	ld   e, h                                        ; $7bf0: $5c
	nop                                              ; $7bf1: $00
	ld   bc, $013a                                   ; $7bf2: $01 $3a $01
	ld   a, [hl-]                                    ; $7bf5: $3a
	ld   bc, $013a                                   ; $7bf6: $01 $3a $01
	ld   a, [hl-]                                    ; $7bf9: $3a
	ld   bc, $013a                                   ; $7bfa: $01 $3a $01
	ld   a, [hl-]                                    ; $7bfd: $3a
	ld   bc, $a33a                                   ; $7bfe: $01 $3a $a3
	inc  [hl]                                        ; $7c01: $34
	ld   bc, HeaderROMSize                           ; $7c02: $01 $48 $01
	ld   c, b                                        ; $7c05: $48
	ld   bc, HeaderROMSize                           ; $7c06: $01 $48 $01
	ld   c, b                                        ; $7c09: $48
	ld   bc, HeaderNewLicenseeCode                   ; $7c0a: $01 $44 $01
	ld   b, h                                        ; $7c0d: $44
	ld   bc, $a34c                                   ; $7c0e: $01 $4c $a3
	ld   b, h                                        ; $7c11: $44
	and  d                                           ; $7c12: $a2
	ld   bc, $010b                                   ; $7c13: $01 $0b $01
	dec  bc                                          ; $7c16: $0b
	ld   bc, $010b                                   ; $7c17: $01 $0b $01
	dec  bc                                          ; $7c1a: $0b
	ld   bc, $010b                                   ; $7c1b: $01 $0b $01
	dec  bc                                          ; $7c1e: $0b
	and  d                                           ; $7c1f: $a2

jr_001_7c20:
	ld   bc, $0b0b                                   ; $7c20: $01 $0b $0b
	ld   bc, $7c2e                                   ; $7c23: $01 $2e $7c
	nop                                              ; $7c26: $00
	nop                                              ; $7c27: $00
	ld   h, e                                        ; $7c28: $63
	ld   a, h                                        ; $7c29: $7c
	sub  a                                           ; $7c2a: $97
	ld   a, h                                        ; $7c2b: $7c
	bit  7, h                                        ; $7c2c: $cb $7c

jr_001_7c2e:
	sbc  l                                           ; $7c2e: $9d
	or   e                                           ; $7c2f: $b3
	nop                                              ; $7c30: $00
	add  b                                           ; $7c31: $80
	and  [hl]                                        ; $7c32: $a6
	ld   d, d                                        ; $7c33: $52
	and  c                                           ; $7c34: $a1
	ld   d, b                                        ; $7c35: $50
	and  [hl]                                        ; $7c36: $a6
	ld   d, d                                        ; $7c37: $52
	and  c                                           ; $7c38: $a1
	ld   d, b                                        ; $7c39: $50
	and  [hl]                                        ; $7c3a: $a6
	ld   d, d                                        ; $7c3b: $52
	and  c                                           ; $7c3c: $a1
	ld   c, b                                        ; $7c3d: $48
	and  e                                           ; $7c3e: $a3
	ld   bc, $4ca6                                   ; $7c3f: $01 $a6 $4c
	and  c                                           ; $7c42: $a1
	ld   c, d                                        ; $7c43: $4a
	and  [hl]                                        ; $7c44: $a6
	ld   c, h                                        ; $7c45: $4c
	and  c                                           ; $7c46: $a1
	ld   c, d                                        ; $7c47: $4a
	and  [hl]                                        ; $7c48: $a6
	ld   c, h                                        ; $7c49: $4c
	and  c                                           ; $7c4a: $a1
	ld   b, d                                        ; $7c4b: $42
	and  e                                           ; $7c4c: $a3
	ld   bc, $3ea6                                   ; $7c4d: $01 $a6 $3e
	and  c                                           ; $7c50: $a1
	ld   b, d                                        ; $7c51: $42
	and  [hl]                                        ; $7c52: $a6
	ld   b, h                                        ; $7c53: $44
	and  c                                           ; $7c54: $a1
	ld   c, b                                        ; $7c55: $48
	and  [hl]                                        ; $7c56: $a6
	ld   c, h                                        ; $7c57: $4c
	and  c                                           ; $7c58: $a1
	ld   d, b                                        ; $7c59: $50
	and  [hl]                                        ; $7c5a: $a6
	ld   d, d                                        ; $7c5b: $52
	and  c                                           ; $7c5c: $a1
	ld   d, [hl]                                     ; $7c5d: $56
	and  [hl]                                        ; $7c5e: $a6
	ld   d, d                                        ; $7c5f: $52
	and  c                                           ; $7c60: $a1
	ld   l, d                                        ; $7c61: $6a
	nop                                              ; $7c62: $00
	sbc  l                                           ; $7c63: $9d
	sub  e                                           ; $7c64: $93
	nop                                              ; $7c65: $00
	ret  nz                                          ; $7c66: $c0

	and  [hl]                                        ; $7c67: $a6
	ld   b, d                                        ; $7c68: $42
	and  c                                           ; $7c69: $a1
	ld   b, b                                        ; $7c6a: $40
	and  [hl]                                        ; $7c6b: $a6
	ld   b, d                                        ; $7c6c: $42
	and  c                                           ; $7c6d: $a1
	ld   b, b                                        ; $7c6e: $40
	and  [hl]                                        ; $7c6f: $a6
	ld   b, d                                        ; $7c70: $42
	and  c                                           ; $7c71: $a1
	ld   b, d                                        ; $7c72: $42
	and  e                                           ; $7c73: $a3
	ld   bc, $3aa6                                   ; $7c74: $01 $a6 $3a
	and  c                                           ; $7c77: $a1
	jr   c, jr_001_7c20                              ; $7c78: $38 $a6

	ld   a, [hl-]                                    ; $7c7a: $3a
	and  c                                           ; $7c7b: $a1

Call_001_7c7c:
	jr   c, @-$58                                    ; $7c7c: $38 $a6

	ld   a, [hl-]                                    ; $7c7e: $3a
	and  c                                           ; $7c7f: $a1
	ld   a, [hl-]                                    ; $7c80: $3a
	and  e                                           ; $7c81: $a3
	ld   bc, $38a6                                   ; $7c82: $01 $a6 $38
	and  c                                           ; $7c85: $a1
	jr   c, jr_001_7c2e                              ; $7c86: $38 $a6

	ld   a, [hl-]                                    ; $7c88: $3a
	and  c                                           ; $7c89: $a1
	ld   a, $a6                                      ; $7c8a: $3e $a6
	ld   b, d                                        ; $7c8c: $42
	and  c                                           ; $7c8d: $a1
	ld   b, h                                        ; $7c8e: $44
	and  [hl]                                        ; $7c8f: $a6
	ld   c, b                                        ; $7c90: $48
	and  c                                           ; $7c91: $a1
	ld   c, h                                        ; $7c92: $4c
	and  [hl]                                        ; $7c93: $a6
	ld   b, d                                        ; $7c94: $42
	and  c                                           ; $7c95: $a1
	ld   b, d                                        ; $7c96: $42
	sbc  l                                           ; $7c97: $9d
	jp   hl                                          ; $7c98: $e9


	ld   l, [hl]                                     ; $7c99: $6e
	and  b                                           ; $7c9a: $a0
	and  [hl]                                        ; $7c9b: $a6
	ld   c, b                                        ; $7c9c: $48
	and  c                                           ; $7c9d: $a1
	ld   b, [hl]                                     ; $7c9e: $46
	and  [hl]                                        ; $7c9f: $a6
	ld   c, b                                        ; $7ca0: $48
	and  c                                           ; $7ca1: $a1
	ld   b, [hl]                                     ; $7ca2: $46
	and  [hl]                                        ; $7ca3: $a6
	ld   c, b                                        ; $7ca4: $48
	and  c                                           ; $7ca5: $a1
	ld   d, d                                        ; $7ca6: $52
	and  e                                           ; $7ca7: $a3
	ld   bc, $44a6                                   ; $7ca8: $01 $a6 $44
	and  c                                           ; $7cab: $a1
	ld   b, d                                        ; $7cac: $42
	and  [hl]                                        ; $7cad: $a6
	ld   b, h                                        ; $7cae: $44
	and  c                                           ; $7caf: $a1
	ld   b, d                                        ; $7cb0: $42
	and  [hl]                                        ; $7cb1: $a6
	ld   b, h                                        ; $7cb2: $44
	and  c                                           ; $7cb3: $a1
	ld   c, h                                        ; $7cb4: $4c
	and  e                                           ; $7cb5: $a3
	ld   bc, $48a6                                   ; $7cb6: $01 $a6 $48
	and  c                                           ; $7cb9: $a1
	ld   a, [hl-]                                    ; $7cba: $3a
	and  [hl]                                        ; $7cbb: $a6
	ld   a, $a1                                      ; $7cbc: $3e $a1
	ld   b, d                                        ; $7cbe: $42
	and  [hl]                                        ; $7cbf: $a6
	ld   b, h                                        ; $7cc0: $44
	and  c                                           ; $7cc1: $a1
	ld   c, b                                        ; $7cc2: $48
	and  [hl]                                        ; $7cc3: $a6
	ld   c, h                                        ; $7cc4: $4c
	and  c                                           ; $7cc5: $a1
	ld   d, b                                        ; $7cc6: $50
	and  [hl]                                        ; $7cc7: $a6
	ld   d, d                                        ; $7cc8: $52
	and  c                                           ; $7cc9: $a1
	ld   a, [hl-]                                    ; $7cca: $3a
	and  [hl]                                        ; $7ccb: $a6
	dec  bc                                          ; $7ccc: $0b
	and  c                                           ; $7ccd: $a1
	ld   b, $a6                                      ; $7cce: $06 $a6
	dec  bc                                          ; $7cd0: $0b
	and  c                                           ; $7cd1: $a1
	ld   b, $a6                                      ; $7cd2: $06 $a6
	dec  bc                                          ; $7cd4: $0b
	and  c                                           ; $7cd5: $a1
	ld   b, $a3                                      ; $7cd6: $06 $a3
	ld   bc, $0ba6                                   ; $7cd8: $01 $a6 $0b
	and  c                                           ; $7cdb: $a1
	ld   b, $a6                                      ; $7cdc: $06 $a6
	dec  bc                                          ; $7cde: $0b
	and  c                                           ; $7cdf: $a1
	ld   b, $a6                                      ; $7ce0: $06 $a6
	dec  bc                                          ; $7ce2: $0b
	and  c                                           ; $7ce3: $a1
	ld   b, $a3                                      ; $7ce4: $06 $a3
	ld   bc, $0ba6                                   ; $7ce6: $01 $a6 $0b
	and  c                                           ; $7ce9: $a1
	ld   b, $a6                                      ; $7cea: $06 $a6
	dec  bc                                          ; $7cec: $0b
	and  c                                           ; $7ced: $a1
	ld   b, $a6                                      ; $7cee: $06 $a6
	dec  bc                                          ; $7cf0: $0b
	and  c                                           ; $7cf1: $a1
	ld   b, $a3                                      ; $7cf2: $06 $a3
	ld   bc, $0ba6                                   ; $7cf4: $01 $a6 $0b
	and  c                                           ; $7cf7: $a1
	db $06 
	
	
Song1_Sq1Data:
	db $2e
	ld   a, l                                        ; $7cfa: $7d
	rst  $38                                         ; $7cfb: $ff
	rst  $38                                         ; $7cfc: $ff
	ld   bc, $297d                                   ; $7cfd: $01 $7d $29
	ld   a, l                                        ; $7d00: $7d
	dec  [hl]                                        ; $7d01: $35
	ld   a, l                                        ; $7d02: $7d
	ld   e, e                                        ; $7d03: $5b
	ld   a, l                                        ; $7d04: $7d
	add  d                                           ; $7d05: $82
	ld   a, l                                        ; $7d06: $7d
	ld   e, e                                        ; $7d07: $5b
	ld   a, l                                        ; $7d08: $7d
	and  h                                           ; $7d09: $a4
	ld   a, l                                        ; $7d0a: $7d
	add  $7d                                         ; $7d0b: $c6 $7d
	rst  $38                                         ; $7d0d: $ff
	rst  $38                                         ; $7d0e: $ff
	inc  bc                                          ; $7d0f: $03
	ld   a, l                                        ; $7d10: $7d
	dec  sp                                          ; $7d11: $3b
	ld   a, l                                        ; $7d12: $7d

jr_001_7d13:
	ld   l, h                                        ; $7d13: $6c
	ld   a, l                                        ; $7d14: $7d
	sub  e                                           ; $7d15: $93
	ld   a, l                                        ; $7d16: $7d
	ld   l, h                                        ; $7d17: $6c
	ld   a, l                                        ; $7d18: $7d
	or   l                                           ; $7d19: $b5
	ld   a, l                                        ; $7d1a: $7d
	rlca                                             ; $7d1b: $07
	ld   a, [hl]                                     ; $7d1c: $7e
	rst  $38                                         ; $7d1d: $ff
	rst  $38                                         ; $7d1e: $ff
	inc  de                                          ; $7d1f: $13
	ld   a, l                                        ; $7d20: $7d
	ld   a, $7d                                      ; $7d21: $3e $7d
	ld   b, c                                        ; $7d23: $41
	ld   a, l                                        ; $7d24: $7d
	rst  $38                                         ; $7d25: $ff
	rst  $38                                         ; $7d26: $ff
	inc  hl                                          ; $7d27: $23
	ld   a, l                                        ; $7d28: $7d
	sbc  l                                           ; $7d29: $9d
	ld   h, b                                        ; $7d2a: $60
	nop                                              ; $7d2b: $00
	add  c                                           ; $7d2c: $81
	nop                                              ; $7d2d: $00
	sbc  l                                           ; $7d2e: $9d
	jr   nz, jr_001_7d31                             ; $7d2f: $20 $00

jr_001_7d31:
	add  c                                           ; $7d31: $81
	xor  d                                           ; $7d32: $aa
	ld   bc, $a300                                   ; $7d33: $01 $00 $a3
	ld   bc, $5450                                   ; $7d36: $01 $50 $54
	ld   e, b                                        ; $7d39: $58
	nop                                              ; $7d3a: $00
	and  l                                           ; $7d3b: $a5
	ld   bc, $a500                                   ; $7d3c: $01 $00 $a5
	ld   bc, $a300                                   ; $7d3f: $01 $00 $a3
	ld   bc, $0106                                   ; $7d42: $01 $06 $01
	ld   b, $01                                      ; $7d45: $06 $01
	and  d                                           ; $7d47: $a2
	ld   b, $06                                      ; $7d48: $06 $06
	and  e                                           ; $7d4a: $a3
	ld   bc, $a306                                   ; $7d4b: $01 $06 $a3
	ld   bc, $0106                                   ; $7d4e: $01 $06 $01
	ld   b, $01                                      ; $7d51: $06 $01
	and  d                                           ; $7d53: $a2
	ld   b, $06                                      ; $7d54: $06 $06
	ld   bc, $0601                                   ; $7d56: $01 $01 $06
	ld   b, $00                                      ; $7d59: $06 $00
	and  a                                           ; $7d5b: $a7
	ld   e, d                                        ; $7d5c: $5a
	and  d                                           ; $7d5d: $a2
	ld   e, [hl]                                     ; $7d5e: $5e
	and  a                                           ; $7d5f: $a7
	ld   e, d                                        ; $7d60: $5a
	and  d                                           ; $7d61: $a2
	ld   e, b                                        ; $7d62: $58
	and  a                                           ; $7d63: $a7
	ld   e, b                                        ; $7d64: $58
	and  d                                           ; $7d65: $a2
	ld   d, h                                        ; $7d66: $54
	and  a                                           ; $7d67: $a7
	ld   e, b                                        ; $7d68: $58
	and  d                                           ; $7d69: $a2
	ld   d, h                                        ; $7d6a: $54
	nop                                              ; $7d6b: $00
	sbc  l                                           ; $7d6c: $9d
	ret                                              ; $7d6d: $c9


	ld   l, [hl]                                     ; $7d6e: $6e
	jr   nz, jr_001_7d13                             ; $7d6f: $20 $a2

	ld   e, d                                        ; $7d71: $5a
	ld   h, d                                        ; $7d72: $62
	ld   l, b                                        ; $7d73: $68
	ld   [hl], b                                     ; $7d74: $70
	ld   e, d                                        ; $7d75: $5a
	ld   h, d                                        ; $7d76: $62
	ld   l, b                                        ; $7d77: $68
	ld   [hl], b                                     ; $7d78: $70
	ld   e, d                                        ; $7d79: $5a
	ld   h, h                                        ; $7d7a: $64
	ld   h, [hl]                                     ; $7d7b: $66
	ld   l, h                                        ; $7d7c: $6c
	ld   e, d                                        ; $7d7d: $5a
	ld   h, h                                        ; $7d7e: $64
	ld   h, [hl]                                     ; $7d7f: $66
	ld   l, h                                        ; $7d80: $6c
	nop                                              ; $7d81: $00
	and  a                                           ; $7d82: $a7
	ld   d, h                                        ; $7d83: $54
	and  d                                           ; $7d84: $a2
	ld   d, b                                        ; $7d85: $50
	and  a                                           ; $7d86: $a7
	ld   d, h                                        ; $7d87: $54
	and  d                                           ; $7d88: $a2
	ld   d, b                                        ; $7d89: $50
	and  a                                           ; $7d8a: $a7
	ld   d, b                                        ; $7d8b: $50
	and  d                                           ; $7d8c: $a2
	ld   c, h                                        ; $7d8d: $4c
	and  a                                           ; $7d8e: $a7
	ld   c, d                                        ; $7d8f: $4a
	and  d                                           ; $7d90: $a2
	ld   d, b                                        ; $7d91: $50
	nop                                              ; $7d92: $00
	ld   e, b                                        ; $7d93: $58
	ld   e, [hl]                                     ; $7d94: $5e
	ld   h, h                                        ; $7d95: $64
	ld   l, h                                        ; $7d96: $6c
	ld   e, b                                        ; $7d97: $58
	ld   e, [hl]                                     ; $7d98: $5e
	ld   h, h                                        ; $7d99: $64
	ld   l, h                                        ; $7d9a: $6c
	ld   d, b                                        ; $7d9b: $50
	ld   d, h                                        ; $7d9c: $54
	ld   e, b                                        ; $7d9d: $58
	ld   e, [hl]                                     ; $7d9e: $5e
	ld   d, b                                        ; $7d9f: $50
	ld   e, b                                        ; $7da0: $58
	ld   e, [hl]                                     ; $7da1: $5e
	ld   h, h                                        ; $7da2: $64
	nop                                              ; $7da3: $00
	and  a                                           ; $7da4: $a7
	ld   d, h                                        ; $7da5: $54
	and  d                                           ; $7da6: $a2
	ld   d, b                                        ; $7da7: $50
	and  a                                           ; $7da8: $a7
	ld   d, h                                        ; $7da9: $54
	and  d                                           ; $7daa: $a2
	ld   d, b                                        ; $7dab: $50
	and  a                                           ; $7dac: $a7
	ld   d, b                                        ; $7dad: $50
	and  d                                           ; $7dae: $a2
	ld   c, h                                        ; $7daf: $4c
	and  a                                           ; $7db0: $a7
	ld   c, d                                        ; $7db1: $4a
	and  d                                           ; $7db2: $a2
	ld   b, [hl]                                     ; $7db3: $46
	nop                                              ; $7db4: $00
	ld   e, b                                        ; $7db5: $58
	ld   e, [hl]                                     ; $7db6: $5e
	ld   h, h                                        ; $7db7: $64
	ld   l, h                                        ; $7db8: $6c
	ld   e, b                                        ; $7db9: $58
	ld   e, [hl]                                     ; $7dba: $5e
	ld   h, h                                        ; $7dbb: $64
	ld   l, h                                        ; $7dbc: $6c
	ld   d, b                                        ; $7dbd: $50
	ld   d, h                                        ; $7dbe: $54
	ld   e, b                                        ; $7dbf: $58
	ld   e, [hl]                                     ; $7dc0: $5e
	ld   d, b                                        ; $7dc1: $50
	ld   e, b                                        ; $7dc2: $58
	ld   e, [hl]                                     ; $7dc3: $5e
	ld   h, h                                        ; $7dc4: $64
	nop                                              ; $7dc5: $00
	and  a                                           ; $7dc6: $a7
	ld   c, d                                        ; $7dc7: $4a
	and  d                                           ; $7dc8: $a2
	ld   c, h                                        ; $7dc9: $4c
	and  a                                           ; $7dca: $a7
	ld   c, d                                        ; $7dcb: $4a
	and  d                                           ; $7dcc: $a2
	ld   b, [hl]                                     ; $7dcd: $46
	and  a                                           ; $7dce: $a7
	ld   b, [hl]                                     ; $7dcf: $46
	and  d                                           ; $7dd0: $a2
	ld   b, h                                        ; $7dd1: $44
	and  a                                           ; $7dd2: $a7
	ld   b, [hl]                                     ; $7dd3: $46
	and  d                                           ; $7dd4: $a2
	ld   c, d                                        ; $7dd5: $4a
	and  a                                           ; $7dd6: $a7
	ld   c, h                                        ; $7dd7: $4c
	and  d                                           ; $7dd8: $a2
	ld   d, b                                        ; $7dd9: $50
	and  a                                           ; $7dda: $a7
	ld   c, h                                        ; $7ddb: $4c
	and  d                                           ; $7ddc: $a2
	ld   c, d                                        ; $7ddd: $4a
	and  a                                           ; $7dde: $a7
	ld   c, d                                        ; $7ddf: $4a
	and  d                                           ; $7de0: $a2
	ld   b, [hl]                                     ; $7de1: $46
	and  a                                           ; $7de2: $a7
	ld   c, d                                        ; $7de3: $4a
	and  d                                           ; $7de4: $a2
	ld   c, h                                        ; $7de5: $4c
	and  a                                           ; $7de6: $a7
	ld   d, b                                        ; $7de7: $50
	and  d                                           ; $7de8: $a2
	ld   c, [hl]                                     ; $7de9: $4e
	and  a                                           ; $7dea: $a7
	ld   d, b                                        ; $7deb: $50
	and  d                                           ; $7dec: $a2
	ld   d, d                                        ; $7ded: $52
	and  a                                           ; $7dee: $a7
	ld   e, b                                        ; $7def: $58
	and  d                                           ; $7df0: $a2
	ld   d, h                                        ; $7df1: $54
	and  a                                           ; $7df2: $a7
	ld   e, d                                        ; $7df3: $5a
	and  d                                           ; $7df4: $a2
	ld   d, h                                        ; $7df5: $54
	and  a                                           ; $7df6: $a7
	ld   d, d                                        ; $7df7: $52
	and  d                                           ; $7df8: $a2
	ld   d, b                                        ; $7df9: $50
	and  a                                           ; $7dfa: $a7
	ld   c, h                                        ; $7dfb: $4c
	and  d                                           ; $7dfc: $a2
	ld   c, d                                        ; $7dfd: $4a
	and  d                                           ; $7dfe: $a2
	ld   b, d                                        ; $7dff: $42
	jr   c, jr_001_7e3e                              ; $7e00: $38 $3c

	ld   c, d                                        ; $7e02: $4a
	and  e                                           ; $7e03: $a3
	ld   b, d                                        ; $7e04: $42
	ld   bc, $4a00                                   ; $7e05: $01 $00 $4a
	ld   d, d                                        ; $7e08: $52
	ld   e, b                                        ; $7e09: $58
	ld   e, [hl]                                     ; $7e0a: $5e
	ld   c, d                                        ; $7e0b: $4a
	ld   e, b                                        ; $7e0c: $58
	ld   e, [hl]                                     ; $7e0d: $5e
	ld   h, d                                        ; $7e0e: $62
	ld   d, h                                        ; $7e0f: $54
	ld   h, d                                        ; $7e10: $62
	ld   l, b                                        ; $7e11: $68
	ld   l, h                                        ; $7e12: $6c
	ld   d, h                                        ; $7e13: $54
	ld   h, d                                        ; $7e14: $62
	ld   l, b                                        ; $7e15: $68
	ld   l, h                                        ; $7e16: $6c
	ld   b, [hl]                                     ; $7e17: $46
	ld   c, h                                        ; $7e18: $4c

jr_001_7e19:
	ld   d, h                                        ; $7e19: $54
	ld   e, [hl]                                     ; $7e1a: $5e
	ld   b, [hl]                                     ; $7e1b: $46
	ld   c, h                                        ; $7e1c: $4c
	ld   d, h                                        ; $7e1d: $54
	ld   e, d                                        ; $7e1e: $5a
	ld   d, b                                        ; $7e1f: $50
	ld   e, b                                        ; $7e20: $58
	ld   e, [hl]                                     ; $7e21: $5e
	ld   h, h                                        ; $7e22: $64
	ld   d, b                                        ; $7e23: $50
	ld   e, [hl]                                     ; $7e24: $5e
	ld   h, h                                        ; $7e25: $64
	ld   l, h                                        ; $7e26: $6c
	ld   c, d                                        ; $7e27: $4a
	ld   d, b                                        ; $7e28: $50
	ld   e, b                                        ; $7e29: $58
	ld   e, [hl]                                     ; $7e2a: $5e
	ld   c, d                                        ; $7e2b: $4a
	ld   e, b                                        ; $7e2c: $58
	ld   e, [hl]                                     ; $7e2d: $5e
	ld   h, d                                        ; $7e2e: $62
	ld   c, [hl]                                     ; $7e2f: $4e
	ld   d, h                                        ; $7e30: $54
	ld   e, d                                        ; $7e31: $5a
	ld   h, d                                        ; $7e32: $62
	ld   c, [hl]                                     ; $7e33: $4e
	ld   d, h                                        ; $7e34: $54
	ld   e, d                                        ; $7e35: $5a
	ld   h, [hl]                                     ; $7e36: $66
	ld   d, b                                        ; $7e37: $50
	ld   e, b                                        ; $7e38: $58
	ld   e, [hl]                                     ; $7e39: $5e
	ld   h, h                                        ; $7e3a: $64
	ld   d, b                                        ; $7e3b: $50
	ld   e, [hl]                                     ; $7e3c: $5e
	ld   h, h                                        ; $7e3d: $64

jr_001_7e3e:
	ld   l, b                                        ; $7e3e: $68
	xor  b                                           ; $7e3f: $a8
	ld   e, d                                        ; $7e40: $5a
	and  e                                           ; $7e41: $a3
	ld   bc, $4e00                                   ; $7e42: $01 $00 $4e
	ld   a, [hl]                                     ; $7e45: $7e
	nop                                              ; $7e46: $00
	nop                                              ; $7e47: $00
	ld   e, [hl]                                     ; $7e48: $5e
	ld   a, [hl]                                     ; $7e49: $7e
	ld   l, l                                        ; $7e4a: $6d
	ld   a, [hl]                                     ; $7e4b: $7e
	ld   a, l                                        ; $7e4c: $7d
	ld   a, [hl]                                     ; $7e4d: $7e
	sbc  l                                           ; $7e4e: $9d
	or   c                                           ; $7e4f: $b1
	nop                                              ; $7e50: $00
	add  b                                           ; $7e51: $80
	and  a                                           ; $7e52: $a7
	ld   bc, $5ea1                                   ; $7e53: $01 $a1 $5e
	ld   e, [hl]                                     ; $7e56: $5e
	and  [hl]                                        ; $7e57: $a6
	ld   l, b                                        ; $7e58: $68
	and  c                                           ; $7e59: $a1
	ld   e, [hl]                                     ; $7e5a: $5e
	and  h                                           ; $7e5b: $a4
	ld   l, b                                        ; $7e5c: $68
	nop                                              ; $7e5d: $00
	sbc  l                                           ; $7e5e: $9d
	sub  c                                           ; $7e5f: $91
	nop                                              ; $7e60: $00
	add  b                                           ; $7e61: $80
	and  a                                           ; $7e62: $a7
	ld   bc, $54a1                                   ; $7e63: $01 $a1 $54
	ld   d, h                                        ; $7e66: $54
	and  [hl]                                        ; $7e67: $a6
	ld   e, [hl]                                     ; $7e68: $5e
	and  c                                           ; $7e69: $a1
	ld   e, b                                        ; $7e6a: $58
	and  h                                           ; $7e6b: $a4
	ld   e, [hl]                                     ; $7e6c: $5e
	sbc  l                                           ; $7e6d: $9d
	jp   hl                                          ; $7e6e: $e9


	ld   l, [hl]                                     ; $7e6f: $6e
	jr   nz, jr_001_7e19                             ; $7e70: $20 $a7

	ld   bc, $4ea1                                   ; $7e72: $01 $a1 $4e
	ld   c, [hl]                                     ; $7e75: $4e
	and  [hl]                                        ; $7e76: $a6
	ld   e, b                                        ; $7e77: $58
	and  c                                           ; $7e78: $a1
	ld   d, b                                        ; $7e79: $50
	and  e                                           ; $7e7a: $a3
	ld   e, b                                        ; $7e7b: $58
	ld   bc, $01a7                                   ; $7e7c: $01 $a7 $01
	and  c                                           ; $7e7f: $a1
	ld   b, $06                                      ; $7e80: $06 $06
	and  [hl]                                        ; $7e82: $a6
	dec  bc                                          ; $7e83: $0b
	and  c                                           ; $7e84: $a1
	ld   b, $a0                                      ; $7e85: $06 $a0
	ld   b, $06                                      ; $7e87: $06 $06
	ld   b, $06                                      ; $7e89: $06 $06
	ld   b, $06                                      ; $7e8b: $06 $06
	ld   b, $06                                      ; $7e8d: $06 $06
	and  e                                           ; $7e8f: $a3
	ld   bc, $7ebb                                   ; $7e90: $01 $bb $7e
	jr   z, jr_001_7f14                              ; $7e93: $28 $7f

	cp   e                                           ; $7e95: $bb
	ld   a, [hl]                                     ; $7e96: $7e
	ld   [hl], e                                     ; $7e97: $73
	ld   a, a                                        ; $7e98: $7f
	rst  $38                                         ; $7e99: $ff
	rst  $38                                         ; $7e9a: $ff
	sub  c                                           ; $7e9b: $91
	ld   a, [hl]                                     ; $7e9c: $7e
	push hl                                          ; $7e9d: $e5
	ld   a, [hl]                                     ; $7e9e: $7e
	ld   c, a                                        ; $7e9f: $4f
	ld   a, a                                        ; $7ea0: $7f
	push hl                                          ; $7ea1: $e5

jr_001_7ea2:
	ld   a, [hl]                                     ; $7ea2: $7e
	sub  [hl]                                        ; $7ea3: $96
	ld   a, a                                        ; $7ea4: $7f
	rst  $38                                         ; $7ea5: $ff
	rst  $38                                         ; $7ea6: $ff
	sbc  l                                           ; $7ea7: $9d
	ld   a, [hl]                                     ; $7ea8: $7e
	ei                                               ; $7ea9: $fb
	ld   a, [hl]                                     ; $7eaa: $7e
	ld   h, c                                        ; $7eab: $61
	ld   a, a                                        ; $7eac: $7f
	ei                                               ; $7ead: $fb
	ld   a, [hl]                                     ; $7eae: $7e
	xor  [hl]                                        ; $7eaf: $ae
	ld   a, a                                        ; $7eb0: $7f
	rst  $38                                         ; $7eb1: $ff
	rst  $38                                         ; $7eb2: $ff
	xor  c                                           ; $7eb3: $a9
	ld   a, [hl]                                     ; $7eb4: $7e
	ld   de, $ff7f                                   ; $7eb5: $11 $7f $ff
	rst  $38                                         ; $7eb8: $ff
	or   l                                           ; $7eb9: $b5
	ld   a, [hl]                                     ; $7eba: $7e
	sbc  l                                           ; $7ebb: $9d
	add  d                                           ; $7ebc: $82
	nop                                              ; $7ebd: $00
	add  b                                           ; $7ebe: $80
	and  d                                           ; $7ebf: $a2
	ld   d, h                                        ; $7ec0: $54
	and  c                                           ; $7ec1: $a1
	ld   d, h                                        ; $7ec2: $54
	ld   d, h                                        ; $7ec3: $54
	ld   d, h                                        ; $7ec4: $54
	ld   c, d                                        ; $7ec5: $4a
	ld   b, [hl]                                     ; $7ec6: $46
	ld   c, d                                        ; $7ec7: $4a
	and  d                                           ; $7ec8: $a2
	ld   d, h                                        ; $7ec9: $54
	and  c                                           ; $7eca: $a1
	ld   d, h                                        ; $7ecb: $54
	ld   d, h                                        ; $7ecc: $54
	ld   d, h                                        ; $7ecd: $54
	ld   e, b                                        ; $7ece: $58
	ld   e, h                                        ; $7ecf: $5c
	ld   e, b                                        ; $7ed0: $58
	and  d                                           ; $7ed1: $a2
	ld   d, h                                        ; $7ed2: $54
	and  c                                           ; $7ed3: $a1
	ld   d, h                                        ; $7ed4: $54
	ld   d, h                                        ; $7ed5: $54
	ld   e, b                                        ; $7ed6: $58
	ld   d, h                                        ; $7ed7: $54
	ld   d, d                                        ; $7ed8: $52
	ld   d, h                                        ; $7ed9: $54
	and  c                                           ; $7eda: $a1
	ld   e, b                                        ; $7edb: $58
	ld   e, h                                        ; $7edc: $5c
	ld   e, b                                        ; $7edd: $58
	ld   e, h                                        ; $7ede: $5c
	and  d                                           ; $7edf: $a2
	ld   e, b                                        ; $7ee0: $58
	and  c                                           ; $7ee1: $a1
	ld   d, [hl]                                     ; $7ee2: $56
	ld   e, b                                        ; $7ee3: $58
	nop                                              ; $7ee4: $00
	sbc  l                                           ; $7ee5: $9d
	ld   h, d                                        ; $7ee6: $62
	nop                                              ; $7ee7: $00
	add  b                                           ; $7ee8: $80
	and  d                                           ; $7ee9: $a2
	ld   bc, HeaderNewLicenseeCode                   ; $7eea: $01 $44 $01
	ld   b, b                                        ; $7eed: $40
	ld   bc, HeaderNewLicenseeCode                   ; $7eee: $01 $44 $01
	ld   b, [hl]                                     ; $7ef1: $46
	ld   bc, HeaderNewLicenseeCode                   ; $7ef2: $01 $44 $01
	ld   b, h                                        ; $7ef5: $44
	ld   bc, $0140                                   ; $7ef6: $01 $40 $01
	ld   b, b                                        ; $7ef9: $40
	nop                                              ; $7efa: $00
	sbc  l                                           ; $7efb: $9d
	jp   hl                                          ; $7efc: $e9


	ld   l, [hl]                                     ; $7efd: $6e
	jr   nz, jr_001_7ea2                             ; $7efe: $20 $a2

	ld   d, h                                        ; $7f00: $54
	ld   d, h                                        ; $7f01: $54
	ld   c, d                                        ; $7f02: $4a
	ld   d, d                                        ; $7f03: $52
	ld   d, h                                        ; $7f04: $54
	ld   d, h                                        ; $7f05: $54
	ld   c, d                                        ; $7f06: $4a
	ld   e, b                                        ; $7f07: $58
	ld   d, h                                        ; $7f08: $54
	ld   d, h                                        ; $7f09: $54
	ld   d, d                                        ; $7f0a: $52
	ld   d, h                                        ; $7f0b: $54
	ld   c, [hl]                                     ; $7f0c: $4e
	ld   d, h                                        ; $7f0d: $54
	ld   c, d                                        ; $7f0e: $4a
	ld   d, d                                        ; $7f0f: $52
	nop                                              ; $7f10: $00
	and  d                                           ; $7f11: $a2
	ld   b, $0b                                      ; $7f12: $06 $0b

jr_001_7f14:
	ld   b, $0b                                      ; $7f14: $06 $0b
	ld   b, $0b                                      ; $7f16: $06 $0b
	ld   b, $0b                                      ; $7f18: $06 $0b
	ld   b, $0b                                      ; $7f1a: $06 $0b
	ld   b, $0b                                      ; $7f1c: $06 $0b
	ld   b, $a1                                      ; $7f1e: $06 $a1
	dec  bc                                          ; $7f20: $0b
	dec  bc                                          ; $7f21: $0b
	ld   b, $a2                                      ; $7f22: $06 $a2
	dec  bc                                          ; $7f24: $0b
	and  c                                           ; $7f25: $a1
	ld   b, $00                                      ; $7f26: $06 $00
	and  d                                           ; $7f28: $a2
	ld   e, [hl]                                     ; $7f29: $5e
	and  c                                           ; $7f2a: $a1
	ld   e, [hl]                                     ; $7f2b: $5e
	ld   e, [hl]                                     ; $7f2c: $5e
	ld   e, [hl]                                     ; $7f2d: $5e
	ld   d, h                                        ; $7f2e: $54
	ld   d, b                                        ; $7f2f: $50
	ld   d, h                                        ; $7f30: $54
	and  d                                           ; $7f31: $a2
	ld   e, [hl]                                     ; $7f32: $5e
	and  c                                           ; $7f33: $a1
	ld   e, [hl]                                     ; $7f34: $5e
	ld   e, [hl]                                     ; $7f35: $5e
	ld   e, [hl]                                     ; $7f36: $5e
	ld   h, d                                        ; $7f37: $62
	ld   h, [hl]                                     ; $7f38: $66
	ld   h, d                                        ; $7f39: $62
	and  d                                           ; $7f3a: $a2
	ld   e, [hl]                                     ; $7f3b: $5e
	and  c                                           ; $7f3c: $a1
	ld   e, [hl]                                     ; $7f3d: $5e
	ld   e, h                                        ; $7f3e: $5c
	and  d                                           ; $7f3f: $a2
	ld   e, b                                        ; $7f40: $58
	and  c                                           ; $7f41: $a1
	ld   e, b                                        ; $7f42: $58
	ld   d, h                                        ; $7f43: $54
	and  c                                           ; $7f44: $a1
	ld   d, d                                        ; $7f45: $52
	ld   d, h                                        ; $7f46: $54
	ld   d, d                                        ; $7f47: $52
	ld   d, h                                        ; $7f48: $54
	and  d                                           ; $7f49: $a2
	ld   d, d                                        ; $7f4a: $52
	and  c                                           ; $7f4b: $a1
	ld   c, [hl]                                     ; $7f4c: $4e
	ld   d, d                                        ; $7f4d: $52
	nop                                              ; $7f4e: $00
	and  d                                           ; $7f4f: $a2
	ld   bc, HeaderSGBFlag                           ; $7f50: $01 $46 $01
	ld   c, d                                        ; $7f53: $4a
	ld   bc, HeaderSGBFlag                           ; $7f54: $01 $46 $01
	ld   c, d                                        ; $7f57: $4a
	ld   bc, HeaderSGBFlag                           ; $7f58: $01 $46 $01
	ld   b, [hl]                                     ; $7f5b: $46
	ld   bc, HeaderSGBFlag                           ; $7f5c: $01 $46 $01
	ld   b, [hl]                                     ; $7f5f: $46
	nop                                              ; $7f60: $00
	and  d                                           ; $7f61: $a2
	ld   b, [hl]                                     ; $7f62: $46
	ld   d, h                                        ; $7f63: $54
	ld   d, h                                        ; $7f64: $54
	ld   d, h                                        ; $7f65: $54
	ld   b, [hl]                                     ; $7f66: $46
	ld   d, h                                        ; $7f67: $54
	ld   d, h                                        ; $7f68: $54
	ld   d, h                                        ; $7f69: $54
	ld   b, [hl]                                     ; $7f6a: $46
	ld   d, h                                        ; $7f6b: $54
	ld   d, d                                        ; $7f6c: $52
	ld   e, b                                        ; $7f6d: $58
	ld   b, h                                        ; $7f6e: $44
	ld   d, d                                        ; $7f6f: $52
	ld   c, d                                        ; $7f70: $4a
	ld   e, b                                        ; $7f71: $58
	nop                                              ; $7f72: $00
	and  d                                           ; $7f73: $a2
	ld   h, d                                        ; $7f74: $62
	and  c                                           ; $7f75: $a1
	ld   h, d                                        ; $7f76: $62
	ld   h, d                                        ; $7f77: $62
	ld   h, d                                        ; $7f78: $62
	ld   e, [hl]                                     ; $7f79: $5e
	ld   e, d                                        ; $7f7a: $5a
	ld   e, [hl]                                     ; $7f7b: $5e
	and  d                                           ; $7f7c: $a2
	ld   h, d                                        ; $7f7d: $62
	and  c                                           ; $7f7e: $a1
	ld   h, d                                        ; $7f7f: $62
	ld   h, d                                        ; $7f80: $62
	ld   h, d                                        ; $7f81: $62
	ld   e, [hl]                                     ; $7f82: $5e
	ld   e, d                                        ; $7f83: $5a
	ld   e, [hl]                                     ; $7f84: $5e
	and  d                                           ; $7f85: $a2
	ld   h, d                                        ; $7f86: $62
	and  c                                           ; $7f87: $a1
	ld   c, d                                        ; $7f88: $4a
	ld   c, [hl]                                     ; $7f89: $4e
	and  d                                           ; $7f8a: $a2
	ld   d, d                                        ; $7f8b: $52
	and  c                                           ; $7f8c: $a1
	ld   c, d                                        ; $7f8d: $4a
	ld   e, h                                        ; $7f8e: $5c
	and  e                                           ; $7f8f: $a3
	ld   e, b                                        ; $7f90: $58
	and  c                                           ; $7f91: $a1
	ld   d, h                                        ; $7f92: $54
	and  [hl]                                        ; $7f93: $a6
	ld   l, h                                        ; $7f94: $6c
	nop                                              ; $7f95: $00
	and  d                                           ; $7f96: $a2
	ld   bc, HeaderDestinationCode                   ; $7f97: $01 $4a $01
	ld   c, d                                        ; $7f9a: $4a
	ld   bc, HeaderDestinationCode                   ; $7f9b: $01 $4a $01
	ld   c, d                                        ; $7f9e: $4a
	ld   bc, $46a1                                   ; $7f9f: $01 $a1 $46
	ld   b, [hl]                                     ; $7fa2: $46
	and  d                                           ; $7fa3: $a2
	ld   b, [hl]                                     ; $7fa4: $46
	and  c                                           ; $7fa5: $a1
	ld   b, [hl]                                     ; $7fa6: $46
	ld   b, [hl]                                     ; $7fa7: $46
	and  e                                           ; $7fa8: $a3
	ld   b, [hl]                                     ; $7fa9: $46
	and  d                                           ; $7faa: $a2
	ld   b, h                                        ; $7fab: $44
	ld   bc, $a200                                   ; $7fac: $01 $00 $a2
	ld   b, d                                        ; $7faf: $42
	ld   e, d                                        ; $7fb0: $5a
	ld   d, b                                        ; $7fb1: $50
	ld   e, d                                        ; $7fb2: $5a
	ld   b, d                                        ; $7fb3: $42
	ld   e, d                                        ; $7fb4: $5a
	ld   d, b                                        ; $7fb5: $50
	ld   e, d                                        ; $7fb6: $5a
	ld   c, d                                        ; $7fb7: $4a
	and  c                                           ; $7fb8: $a1
	ld   d, d                                        ; $7fb9: $52
	ld   d, d                                        ; $7fba: $52
	and  d                                           ; $7fbb: $a2
	ld   d, d                                        ; $7fbc: $52
	and  c                                           ; $7fbd: $a1
	ld   d, d                                        ; $7fbe: $52
	ld   d, d                                        ; $7fbf: $52
	and  e                                           ; $7fc0: $a3
	ld   d, d                                        ; $7fc1: $52
	and  d                                           ; $7fc2: $a2
	ld   d, h                                        ; $7fc3: $54
	ld   bc, $0000                                   ; $7fc4: $01 $00 $00
	nop                                              ; $7fc7: $00