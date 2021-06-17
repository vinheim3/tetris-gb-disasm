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
	dw Song1_Sq2Data
	dw Song1_WavData
	dw Song1_NoiseData

Song2_SoundData:
	db $00
	dw TemposTable_6f05
	dw Song2_Sq1Data
	dw Song2_Sq2Data
	dw Song2_WavData
	dw Song2_NoiseData

Song3_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song3_Sq1Data
	dw Song3_Sq2Data
	dw Song3_WavData
	dw Song3_NoiseData

Song4_SoundData:
	db $00
	dw TemposTable_6ef9
	dw Song4_Sq1Data
	dw Song4_Sq2Data
	dw Song4_WavData
	dw $0000

Song5_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song5_Sq1Data
	dw Song5_Sq2Data
	dw Song5_WavData
	dw Song5_NoiseData

Song6_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song6_Sq1Data
	dw Song6_Sq2Data
	dw Song6_WavData
	dw Song6_NoiseData

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
	dw Song8_Sq1Data
	dw Song8_Sq2Data
	dw Song8_WavData
	dw Song8_NoiseData

Song9_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song9_Sq1Data
	dw Song9_Sq2Data
	dw Song9_WavData
	dw Song9_NoiseData

Song10_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $0000
	dw Song10_Sq2Data
	dw $0000
	dw $0000

Song11_SoundData:
	db $00
	dw TemposTable_6f0e
	dw $0000
	dw Song11_Sq2Data
	dw Song11_WavData
	dw $0000

Song12_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song12_Sq1Data
	dw Song12_Sq2Data
	dw Song12_WavData
	dw $0000

Song13_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song13_Sq1Data
	dw Song13_Sq2Data
	dw Song13_WavData
	dw Song13_NoiseData

Song14_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song14_Sq1Data
	dw Song14_Sq2Data
	dw Song14_WavData
	dw Song14_NoiseData

Song15_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song15_Sq1Data
	dw Song15_Sq2Data
	dw Song15_WavData
	dw Song15_NoiseData

Song16_SoundData:
	db $00
	dw TemposTable_6f2b
	dw Song16_Sq1Data
	dw Song16_Sq2Data
	dw Song16_WavData
	dw $0000

Song17_SoundData:
	db $00
	dw TemposTable_6f0e
	dw Song17_Sq1Data
	dw Song17_Sq2Data
	dw Song17_WavData
	dw $0000


Song7_Sq2Data:
:	dw Song7_Sq2_Section1Data
	dw Song7_Sq2_Section2Data
	dw Song7_Sq2_Section1Data
	dw Song7_Sq2_Section3Data
	dw Song7_Sq2_Section4Data
	JumpSection :-
	

Song7_Sq1Data:
:	dw Song7_Sq1_Section1Data
	dw Song7_Sq1_Section2Data
	dw Song7_Sq1_Section1Data
	dw Song7_Sq1_Section3Data
	dw Song7_Sq1_Section4Data
	JumpSection :-
	

Song7_Sq2_Section1Data:
	SetParams $74, $41
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Csharp, 5
	PlayNote Fsharp, 5
	PlayNote Csharp, 5
	PlayNote Gsharp, 4
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Csharp, 5
	PlayNote Fsharp, 4
	PlayNote Csharp, 5
	PlayNote Fnote, 4
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Csharp, 5
	PlayNote Fsharp, 5
	PlayNote Csharp, 5
	PlayNote Gsharp, 4
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Csharp, 5
	PlayNote Fsharp, 4
	PlayNote Csharp, 5
	PlayNote Fnote, 4
	PlayNote Csharp, 5
	NextSection


Song7_Sq2_Section2Data:
	PlayNote Anote, 4
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Dnote, 5
	PlayNote Bnote, 4
	PlayNote Gsharp, 4
	PlayNote Bnote, 4
	PlayNote Gsharp, 4
	PlayNote Enote, 4
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Csharp, 5
	PlayNote Bnote, 4
	PlayNote Anote, 4
	PlayNote Gsharp, 4
	PlayNote Fsharp, 4
	PlayNote Fnote, 4
	PlayNote Csharp, 4
	PlayNote Fnote, 4
	PlayNote Gsharp, 4
	PlayNote Csharp, 5
	PlayNote Bnote, 4
	NextSection


Song7_Sq2_Section3Data:
	PlayNote Anote, 4
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Dnote, 5
	PlayNote Bnote, 4
	PlayNote Gsharp, 4
	PlayNote Bnote, 4
	PlayNote Gsharp, 4
	PlayNote Enote, 4
	PlayNote Enote, 5
	PlayNote Bnote, 4
	PlayNote Csharp, 5
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Enote, 4
	PlayNote Gsharp, 4
	UseTempo 8
	PlayNote Anote, 4
	NextSection


Song7_Sq1_Section1Data:
	SetParams $64, $41
	UseTempo 3
	PlayNote Fsharp, 3
	PlayNote Fsharp, 4
	PlayNote Fnote, 4
	PlayNote Fsharp, 3
	PlayNote Anote, 3
	PlayNote Csharp, 4
	PlayNote Fsharp, 4
	PlayNote Dnote, 4
	PlayNote Csharp, 4
	PlayNote Fsharp, 4
	PlayNote Anote, 3
	PlayNote Csharp, 4
	NextSection


Song7_Sq1_Section2Data:
	PlayNote Fsharp, 3
	PlayNote Fsharp, 4
	PlayNote Bnote, 3
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	PlayNote Bnote, 3
	UseTempo 2
	PlayNote Csharp, 4
	PlayNote Dnote, 4
	PlayNote Csharp, 4
	PlayNote Bnote, 3
	PlayNote Anote, 3
	PlayNote Gsharp, 3
	NextSection


Song7_Sq1_Section3Data:
	UseTempo 3
	PlayNote Fsharp, 3
	PlayNote Fsharp, 4
	PlayNote Bnote, 3
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Gsharp, 3
	PlayNote Anote, 3
	PlayNote Csharp, 4
	PlayNote Csharp, 4
	PlayNote Anote, 3
	PlayNote Enote, 3
	PlayNote Anote, 2
	NextSection


Song7_Sq2_Section4Data:
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Csharp, 5
	PlayNote Bnote, 4
	PlayNote Anote, 4
	PlayNote Gsharp, 4
	PlayNote Anote, 4
	PlayNote Bnote, 4
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Bnote, 4
	PlayNote Dnote, 5
	PlayNote Csharp, 5
	PlayNote Dnote, 5
	UseTempo 3
	PlayNote Enote, 5
	PlayNote Gsharp, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Bnote, 4
	UseTempo 3
	PlayNote Csharp, 5
	PlayNote Bnote, 4
	PlayNote Csharp, 5
	PlayNote Fsharp, 5
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Fsharp, 5
	PlayNote Gsharp, 5
	UseTempo 3
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Fsharp, 5
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	PlayNote Csharp, 5
	PlayNote Dsharp, 5
	PlayNote Cnote, 5
	UseTempo 8
	PlayNote Csharp, 5
	UseTempo 7
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Fsharp, 5
	PlayNote Gnote, 5
	UseTempo 3
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Dnote, 5
	PlayNote Bnote, 4
	UseTempo 7
	PlayNote Fsharp, 5
	UseTempo 1
	PlayNote Gsharp, 5
	PlayNote Anote, 5
	UseTempo 3
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Fsharp, 5
	PlayNote Fnote, 5
	PlayNote Fsharp, 5
	PlayNote Dsharp, 5
	PlayNote Fnote, 5
	PlayNote Csharp, 5
	PlayNote Gsharp, 5
	PlayNote Fnote, 5
	PlayNote Csharp, 5
	PlayNote Fnote, 5
	PlayNote Gsharp, 5
	PlayNote Bnote, 5
	PlayNote Dnote, 6
	PlayNote Fnote, 5
	PlayNote Csharp, 6
	PlayNote Fnote, 5
	PlayNote Bnote, 5
	PlayNote Fnote, 5
	UseTempo 3
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Bnote, 5
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Fsharp, 5
	PlayNote Gsharp, 5
	UseTempo 4
	PlayNote Fsharp, 5
	UseTempo 2
	DisableEnvelope
	NextSection
	
	
Song7_Sq1_Section4Data:
	UseTempo 2
	PlayNote Csharp, 4
	PlayNote Enote, 4
	PlayNote Anote, 4
	PlayNote Enote, 4
	PlayNote Bnote, 3
	PlayNote Enote, 4
	PlayNote Csharp, 4
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	PlayNote Gsharp, 3
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	PlayNote Anote, 4
	PlayNote Enote, 4
	PlayNote Bnote, 3
	PlayNote Enote, 4
	PlayNote Csharp, 4
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	PlayNote Gsharp, 3
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Csharp, 4
	PlayNote Anote, 3
	PlayNote Fsharp, 3
	PlayNote Fsharp, 4
	PlayNote Dsharp, 4
	PlayNote Cnote, 4
	PlayNote Dsharp, 4
	PlayNote Gsharp, 3
	PlayNote Dsharp, 4
	PlayNote Cnote, 4
	PlayNote Dsharp, 4
	UseTempo 3
	PlayNote Csharp, 4
	PlayNote Gsharp, 4
	PlayNote Gsharp, 3
	UseTempo 2
	PlayNote Csharp, 4
	PlayNote Enote, 4
	PlayNote Gsharp, 4
	PlayNote Enote, 4
	PlayNote Bnote, 3
	PlayNote Enote, 4
	PlayNote Asharp, 3
	PlayNote Csharp, 4
	PlayNote Fsharp, 3
	PlayNote Csharp, 4
	PlayNote Asharp, 3
	PlayNote Csharp, 4
	UseTempo 8
	PlayNote Bnote, 3
	UseTempo 2
	PlayNote Cnote, 4
	PlayNote Dsharp, 4
	PlayNote Gsharp, 3
	PlayNote Dsharp, 4
	PlayNote Cnote, 4
	PlayNote Dsharp, 4
	UseTempo 8
	PlayNote Csharp, 4
	UseTempo 3
	PlayNote Csharp, 4
	PlayNote Gsharp, 3
	PlayNote Fnote, 3
	PlayNote Csharp, 3
	PlayNote Dsharp, 3
	PlayNote Fnote, 3
	PlayNote Anote, 3
	PlayNote Bnote, 3
	PlayNote Csharp, 4
	UseTempo 8
	PlayNote Fsharp, 3
	NextSection


Song5_Sq2Data:
:	dw Song5_Sq2_Section1Data
	dw Song5_Sq2_Section1Data
	dw Song5_Sq2_Section2Data
	JumpSection :-


Song5_Sq1Data:
:	dw Song5_Sq1_Section1Data
	dw Song5_Sq1_Section1Data
	dw Song5_Sq1_Section2Data
	JumpSection :-


Song5_WavData:
:	dw Song5_Wav_Section1Data
	dw Song5_Wav_Section1Data
	dw Song5_Wav_Section2Data
	dw Song5_Wav_Section2Data
	JumpSection :-


Song5_NoiseData:
:	dw Song5_Noise_Section1Data
	JumpSection :-
	

Song5_Sq2_Section1Data:
	SetParams $84, $81
	UseTempo 3
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Cnote, 5
	PlayNote Bnote, 4
	UseTempo 3
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Cnote, 5
	UseTempo 7
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Dnote, 5
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Cnote, 5
	PlayNote Anote, 4
	PlayNote Anote, 4
	DisableEnvelope
	UseTempo 2
	DisableEnvelope
	UseTempo 3
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Fnote, 5
	UseTempo 3
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Gnote, 5
	PlayNote Fnote, 5
	UseTempo 7
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Dnote, 5
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Cnote, 5
	PlayNote Anote, 4
	PlayNote Anote, 4
	DisableEnvelope
	NextSection
	
	
Song5_Sq2_Section2Data:
	SetParams $50, $81
	UseTempo 4
	PlayNote Enote, 4
	PlayNote Cnote, 4
	PlayNote Dnote, 4
	PlayNote Bnote, 3
	UseTempo 4
	PlayNote Cnote, 4
	PlayNote Anote, 3
	UseTempo 8
	PlayNote Gsharp, 3
	UseTempo 3
	DisableEnvelope
	UseTempo 4
	PlayNote Enote, 4
	PlayNote Cnote, 4
	PlayNote Dnote, 4
	PlayNote Bnote, 3
	UseTempo 3
	PlayNote Cnote, 4
	PlayNote Enote, 4
	UseTempo 4
	PlayNote Anote, 4
	PlayNote Gsharp, 4
	DisableEnvelope
	NextSection
	
	
Song5_Sq1_Section1Data:
	SetParams $43, $81
	UseTempo 3
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Gsharp, 4
	PlayNote Anote, 4
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Gsharp, 4
	UseTempo 7
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Cnote, 5
	DisableEnvelope
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Gsharp, 4
	PlayNote Gsharp, 4
	UseTempo 2
	PlayNote Enote, 4
	PlayNote Gsharp, 4
	PlayNote Anote, 4
	UseTempo 3
	PlayNote Bnote, 4
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Anote, 4
	PlayNote Enote, 4
	PlayNote Enote, 4
	DisableEnvelope
	UseTempo 2
	PlayNote Dnote, 3
	UseTempo 3
	PlayNote Fnote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Cnote, 5
	UseTempo 1
	PlayNote Cnote, 5
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Anote, 4
	UseTempo 7
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Enote, 4
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Fnote, 4
	PlayNote Enote, 4
	PlayNote Gsharp, 4
	PlayNote Enote, 4
	PlayNote Gsharp, 4
	PlayNote Anote, 4
	PlayNote Bnote, 4
	PlayNote Gsharp, 4
	PlayNote Cnote, 5
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Cnote, 5
	PlayNote Enote, 4
	DisableEnvelope
	UseTempo 3
	PlayNote Enote, 4
	PlayNote Enote, 4
	DisableEnvelope
	NextSection
	
	
Song5_Sq1_Section2Data:
	SetParams $30, $81
	UseTempo 4
	PlayNote Cnote, 4
	PlayNote Anote, 3
	PlayNote Bnote, 3
	PlayNote Gsharp, 3
	PlayNote Anote, 3
	PlayNote Enote, 3
	UseTempo 4
	PlayNote Enote, 3
	UseTempo 3
	PlayNote Bnote, 3
	DisableEnvelope
	UseTempo 4
	PlayNote Cnote, 4
	PlayNote Anote, 3
	PlayNote Bnote, 3
	PlayNote Gsharp, 3
	UseTempo 3
	PlayNote Anote, 3
	PlayNote Cnote, 4
	UseTempo 4
	PlayNote Enote, 4
	PlayNote Dnote, 4
	DisableEnvelope
	NextSection


Song5_Wav_Section1Data:
	SetParams WavRam_6ec9, $20
	UseTempo 2
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Anote, 4
	PlayNote Anote, 3
	PlayNote Anote, 4
	PlayNote Anote, 3
	PlayNote Anote, 4
	PlayNote Anote, 3
	PlayNote Anote, 4
	PlayNote Gsharp, 3
	PlayNote Gsharp, 4
	PlayNote Gsharp, 3
	PlayNote Gsharp, 4
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Anote, 4
	PlayNote Anote, 3
	PlayNote Anote, 4
	PlayNote Anote, 3
	PlayNote Anote, 4
	PlayNote Bnote, 3
	PlayNote Cnote, 4
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	DisableEnvelope
	PlayNote Dnote, 3
	DisableEnvelope
	PlayNote Dnote, 3
	PlayNote Anote, 3
	PlayNote Fnote, 3
	PlayNote Cnote, 3
	PlayNote Cnote, 4
	DisableEnvelope
	PlayNote Cnote, 4
	PlayNote Cnote, 3
	PlayNote Gnote, 3
	PlayNote Gnote, 3
	DisableEnvelope
	PlayNote Bnote, 3
	PlayNote Bnote, 4
	DisableEnvelope
	PlayNote Bnote, 4
	DisableEnvelope
	PlayNote Enote, 4
	DisableEnvelope
	PlayNote Gsharp, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	UseTempo 3
	PlayNote Anote, 3
	DisableEnvelope
	NextSection
	
	
Song5_Wav_Section2Data:
	SetParams WavRam_6ec9, $20
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	UseTempo 4
	DisableEnvelope
	NextSection
	
	
Song5_Noise_Section1Data:
	UseTempo 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 0
	PlayNoise 1
	PlayNoise 0
	UseTempo 1
	PlayNoise 1
	PlayNoise 1
	UseTempo 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 0
	PlayNoise 1
	PlayNoise 0
	PlayNoise 1
	PlayNoise 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 1
	NextSection


Song6_Sq2Data:
:	dw Song6_Sq2_Section1Data
	dw Song6_Sq2_Section2Data
	dw Song6_Sq2_Section3Data
	dw Song6_Sq2_Section3Data
	dw Song6_Sq2_Section4Data
	JumpSection :-


Song6_Sq1Data:
:	dw Song6_Sq1_Section1Data
	dw Song6_Sq1_Section2Data
	dw Song6_Sq1_Section3Data
	dw Song6_Sq1_Section3Data
	dw Song6_Sq1_Section4Data
	JumpSection :-


Song6_WavData:
:	dw Song6_Wav_Section1Data
	dw Song6_Wav_Section2Data
	dw Song6_Wav_Section3Data
	dw Song6_Wav_Section3Data
	dw Song6_Wav_Section3Data
	dw Song6_Wav_Section3Data
	dw Song6_Wav_Section3Data
	dw Song6_Wav_Section3Data
	dw Song6_Wav_Section4Data
	dw Song6_Wav_Section5Data
	dw Song6_Wav_Section5Data
	dw Song6_Wav_Section5Data
	dw Song6_Wav_Section6Data
	dw Song6_Wav_Section7Data
	dw Song6_Wav_Section7Data
	dw Song6_Wav_Section8Data
	dw Song6_Wav_Section8Data
	dw Song6_Wav_Section9Data
	dw Song6_Wav_Section9Data
	dw Song6_Wav_Section8Data
	dw Song6_Wav_Section10Data
	JumpSection :-
	
	
Song6_NoiseData:
:	dw Song6_Noise_Section1Data
	JumpSection :-
	

Song6_Sq1_Section1Data:
	UseTempo 5
	DisableEnvelope
	NextSection
	
	
Song6_Sq2_Section1Data:
	SetParams $62, $80
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	NextSection


Song6_Wav_Section1Data:
	SetParams DefaultWavRam, $a0
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	NextSection


Song6_Noise_Section1Data:
	UseTempo 2
	PlayNoise 1
	UseTempo 1
	PlayNoise 1
	PlayNoise 1
	UseTempo 2
	PlayNoise 1
	PlayNoise 1
	NextSection


Song6_Sq1_Section2Data:
	UseTempo 5
	DisableEnvelope
	NextSection
	
	
Song6_Sq2_Section2Data:
	SetParams $32, $80
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	NextSection


Song6_Wav_Section2Data:
	SetParams DefaultWavRam, $a0
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	NextSection


Song6_Sq2_Section3Data:
	SetParams $82, $80
	UseTempo 2
	PlayNote Enote, 4
	PlayNote Bnote, 4
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Cnote, 5
	PlayNote Anote, 4
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Dsharp, 4
	PlayNote Enote, 4
	PlayNote Bnote, 3
	PlayNote Cnote, 4
	PlayNote Dsharp, 4
	PlayNote Enote, 4
	PlayNote Bnote, 3
	PlayNote Cnote, 4
	PlayNote Fsharp, 4
	NextSection


Song6_Sq1_Section3Data:
	SetParams $53, $40
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	PlayNote Anote, 4
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Dsharp, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Dsharp, 4
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Asharp, 3
	PlayNote Bnote, 3
	UseTempo 2
	PlayNote Dsharp, 4
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	PlayNote Gnote, 3
	PlayNote Anote, 3
	PlayNote Anote, 3
	PlayNote Bnote, 3
	PlayNote Gnote, 3
	PlayNote Anote, 3
	PlayNote Dsharp, 4
	NextSection


Song6_Wav_Section3Data:
	SetParams DefaultWavRam, $a0
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	NextSection


Song6_Sq2_Section4Data:
	UseTempo 8
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Dsharp, 4
	UseTempo 8
	PlayNote Enote, 4
	UseTempo 3
	PlayNote Fsharp, 4
	UseTempo 2
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	UseTempo 8
	PlayNote Gnote, 4
	UseTempo 3
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Cnote, 5
	PlayNote Anote, 4
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Cnote, 5
	PlayNote Anote, 4
	UseTempo 8
	PlayNote Bnote, 4
	UseTempo 3
	PlayNote Csharp, 5
	UseTempo 2
	PlayNote Dnote, 5
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	PlayNote Csharp, 5
	PlayNote Dnote, 5
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	PlayNote Csharp, 5
	PlayNote Dnote, 5
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Csharp, 5
	UseTempo 2
	PlayNote Csharp, 5
	PlayNote Csharp, 5
	PlayNote Cnote, 5
	UseTempo 1
	PlayNote Cnote, 5
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Cnote, 5
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	PlayNote Anote, 4
	PlayNote Dnote, 4
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Dnote, 4
	UseTempo 3
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Dnote, 4
	PlayNote Bnote, 3
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Dnote, 4
	UseTempo 3
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Dnote, 4
	PlayNote Asharp, 3
	UseTempo 5
	PlayNote Dnote, 4
	UseTempo 8
	DisableEnvelope
	UseTempo 3
	PlayNote Dsharp, 4
	NextSection


Song6_Sq1_Section4Data:
	UseTempo 8
	PlayNote Bnote, 3
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	UseTempo 8
	PlayNote Bnote, 3
	UseTempo 3
	PlayNote Dnote, 4
	UseTempo 5
	DisableEnvelope
	UseTempo 8
	DisableEnvelope
	UseTempo 3
	PlayNote Fsharp, 4
	UseTempo 2
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	UseTempo 8
	PlayNote Dnote, 4
	UseTempo 3
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Anote, 4
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	PlayNote Enote, 4
	PlayNote Fsharp, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Anote, 4
	PlayNote Asharp, 4
	PlayNote Asharp, 4
	PlayNote Asharp, 4
	PlayNote Enote, 4
	PlayNote Fsharp, 4
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Anote, 4
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Enote, 4
	PlayNote Gnote, 4
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Fsharp, 4
	PlayNote Gnote, 4
	UseTempo 2
	PlayNote Fsharp, 4
	PlayNote Fsharp, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	PlayNote Fsharp, 4
	PlayNote Fsharp, 3
	PlayNote Bnote, 3
	UseTempo 1
	PlayNote Bnote, 3
	PlayNote Bnote, 3
	UseTempo 2
	PlayNote Bnote, 3
	UseTempo 3
	PlayNote Bnote, 3
	UseTempo 1
	PlayNote Bnote, 3
	PlayNote Csharp, 4
	UseTempo 2
	PlayNote Bnote, 3
	PlayNote Gnote, 3
	PlayNote Asharp, 3
	UseTempo 1
	PlayNote Asharp, 3
	PlayNote Asharp, 3
	UseTempo 2
	PlayNote Asharp, 3
	UseTempo 3
	PlayNote Asharp, 3
	UseTempo 1
	PlayNote Asharp, 3
	PlayNote Cnote, 4
	UseTempo 2
	PlayNote Asharp, 3
	PlayNote Gnote, 3
	UseTempo 5
	PlayNote Fsharp, 3
	UseTempo 8
	DisableEnvelope
	UseTempo 3
	PlayNote Anote, 3
	NextSection


Song6_Wav_Section4Data:
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Cnote, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Dsharp, 4
	PlayNote Bnote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Cnote, 4
	PlayNote Anote, 3
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Anote, 3
	PlayNote Dnote, 3
	NextSection


Song6_Wav_Section5Data:
	UseTempo 2
	PlayNote Gnote, 3
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 3
	UseTempo 2
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	PlayNote Gnote, 3
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 3
	UseTempo 2
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	NextSection


Song6_Wav_Section6Data:
	UseTempo 2
	PlayNote Gnote, 3
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 3
	UseTempo 2
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	PlayNote Gnote, 3
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 3
	UseTempo 2
	PlayNote Anote, 3
	PlayNote Anote, 4
	NextSection


Song6_Wav_Section7Data:
	UseTempo 2
	PlayNote Dnote, 3
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	UseTempo 2
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	PlayNote Gnote, 3
	UseTempo 1
	PlayNote Gnote, 4
	PlayNote Gnote, 3
	UseTempo 2
	PlayNote Gnote, 3
	PlayNote Gnote, 4
	NextSection


Song6_Wav_Section8Data:
	UseTempo 2
	PlayNote Dnote, 3
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	UseTempo 2
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	UseTempo 2
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	NextSection


Song6_Wav_Section9Data:
	UseTempo 2
	PlayNote Enote, 3
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 3
	UseTempo 2
	PlayNote Enote, 3
	PlayNote Enote, 4
	PlayNote Enote, 3
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 3
	UseTempo 2
	PlayNote Enote, 3
	PlayNote Enote, 4
	NextSection


Song6_Wav_Section10Data:
	UseTempo 2
	PlayNote Dnote, 3
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	UseTempo 2
	PlayNote Dnote, 3
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dnote, 3
	UseTempo 2
	UseTempo 4
	PlayNote Fsharp, 4
	NextSection


; Unused
	PlayNote Dnote, 4
	PlayNote Fsharp, 4
	PlayNote Anote, 4
	UseTempo 4
	PlayNote Anote, 4


Song16_Sq1Data:
	dw Song16_Sq1_Section1Data
:	dw Song16_Sq1_Section2Data
	JumpSection :-


Song16_Sq2Data:
:	dw Song16_Sq2_Section1Data
	JumpSection :-


Song16_WavData:
:	dw Song16_Wav_Section1Data
	JumpSection :-
	

Song16_Sq1_Section1Data:
	SetParams $20, $81
	UseTempo 10
	DisableEnvelope
	NextSection
	
	
Song16_Sq2_Section1Data:
	SetParams $70, $81


Song16_Sq1_Section2Data:
	UseTempo 2
	PlayNote Gsharp, 4
	PlayNote Cnote, 4
	PlayNote Dsharp, 4
	PlayNote Gsharp, 4
	PlayNote Asharp, 4
	PlayNote Csharp, 4
	PlayNote Fnote, 4
	PlayNote Asharp, 4
	PlayNote Cnote, 5
	PlayNote Dsharp, 4
	PlayNote Gsharp, 4
	PlayNote Cnote, 5
	PlayNote Csharp, 5
	PlayNote Fnote, 4
	PlayNote Gsharp, 4
	PlayNote Csharp, 5
	PlayNote Asharp, 4
	PlayNote Csharp, 4
	PlayNote Fnote, 4
	PlayNote Asharp, 4
	PlayNote Gnote, 4
	PlayNote Asharp, 3
	PlayNote Csharp, 4
	PlayNote Gnote, 4
	NextSection


Song16_Wav_Section1Data:
	SetParams DefaultWavRam, $21
	UseTempo 8
	PlayNote Gsharp, 4
	UseTempo 3
	PlayNote Gsharp, 3
	UseTempo 8
	PlayNote Gsharp, 4
	UseTempo 3
	PlayNote Gsharp, 3
	UseTempo 8
	PlayNote Gsharp, 4
	UseTempo 3
	PlayNote Gsharp, 3
	NextSection


Song17_Sq1Data:
	dw Song17_Sq1_Section1Data
:	dw Song17_Sq1_Section2Data
	JumpSection :-


Song17_Sq2Data:
:	dw Song17_Sq2_Section1Data
	JumpSection :-


Song17_WavData:
:	dw Song17_Wav_Section1Data
	JumpSection :-
	

Song17_Sq1_Section1Data:
	SetParams $20, $81
	UseTempo 10
	DisableEnvelope
	NextSection
	
	
Song17_Sq2_Section1Data:
	SetParams $70, $81


Song17_Sq1_Section2Data:
	UseTempo 2
	PlayNote Csharp, 5
	PlayNote Gsharp, 4
	PlayNote Dsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fnote, 5
	PlayNote Gsharp, 4
	PlayNote Dsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fnote, 5
	PlayNote Gsharp, 4
	PlayNote Dsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fnote, 5
	PlayNote Gsharp, 4
	PlayNote Csharp, 5
	PlayNote Gsharp, 4
	PlayNote Dsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fnote, 5
	PlayNote Gsharp, 4
	PlayNote Dsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fnote, 5
	PlayNote Gsharp, 4
	PlayNote Dsharp, 5
	PlayNote Gsharp, 4
	PlayNote Fnote, 5
	PlayNote Gsharp, 4
	PlayNote Gsharp, 5
	PlayNote Asharp, 4
	PlayNote Fsharp, 5
	PlayNote Asharp, 4
	PlayNote Fnote, 5
	PlayNote Asharp, 4
	PlayNote Dsharp, 5
	PlayNote Asharp, 4
	PlayNote Dnote, 5
	PlayNote Asharp, 4
	PlayNote Dsharp, 5
	PlayNote Asharp, 4
	PlayNote Fnote, 5
	PlayNote Asharp, 4
	PlayNote Dsharp, 5
	PlayNote Asharp, 4
	PlayNote Dsharp, 5
	PlayNote Fsharp, 4
	PlayNote Csharp, 5
	PlayNote Fsharp, 4
	PlayNote Csharp, 5
	PlayNote Fsharp, 4
	PlayNote Cnote, 5
	PlayNote Fsharp, 4
	PlayNote Cnote, 5
	PlayNote Fsharp, 4
	PlayNote Asharp, 4
	PlayNote Fsharp, 4
	PlayNote Cnote, 5
	PlayNote Fsharp, 4
	PlayNote Dsharp, 5
	PlayNote Fsharp, 4
	NextSection


Song17_Wav_Section1Data:
	SetParams DefaultWavRam, $21
	UseTempo 5
	PlayNote Csharp, 5
	PlayNote Cnote, 5
	PlayNote Asharp, 4
	PlayNote Gsharp, 4
	PlayNote Dsharp, 4
	PlayNote Fsharp, 4
	PlayNote Gsharp, 4
	PlayNote Gsharp, 4
	NextSection


Song4_Sq2Data:
	dw Song4_Sq2_Section1Data
	EndSong


Song4_Sq1Data:
	dw Song4_Sq1_Section1Data


Song4_WavData:
	dw Song4_Wav_Section1Data
	

Song4_Sq2_Section1Data:
	SetParams $b2, $80
	UseTempo 2
	PlayNote Bnote, 5
	PlayNote Anote, 5
	PlayNote Bnote, 5
	PlayNote Anote, 5
	PlayNote Bnote, 5
	PlayNote Cnote, 6
	PlayNote Bnote, 5
	PlayNote Anote, 5
	UseTempo 4
	PlayNote Bnote, 5
	NextSection


Song4_Sq1_Section1Data:
	SetParams $92, $80
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Enote, 5
	PlayNote Fnote, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	UseTempo 4
	PlayNote Enote, 5


Song4_Wav_Section1Data:
	SetParams DefaultWavRam, $20
	UseTempo 2
	PlayNote Cnote, 6
	PlayNote Bnote, 5
	PlayNote Cnote, 6
	PlayNote Bnote, 5
	PlayNote Cnote, 6
	PlayNote Dnote, 6
	PlayNote Cnote, 6
	PlayNote Bnote, 5
	UseTempo 3
	PlayNote Cnote, 6
	DisableEnvelope
	
	
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
	UseTempo 8
	PlayNoise 0
	UseTempo 2
	PlayNoise 1
	PlayNoise 2
	UseTempo 8
	PlayNoise 0
	UseTempo 2
	PlayNoise 1
	PlayNoise 2
	UseTempo 5
	PlayNoise 0
	PlayNoise 0
	NextSection


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
	UseTempo 2
	PlayNoise 1
	PlayNoise 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 2
	PlayNoise 0
	PlayNoise 1
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	NextSection


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


Song15_Sq1Data:
	dw Song15_Sq1_Section1Data
	dw Song15_Sq1_Section2Data
	dw Song15_Sq1_Section1Data
	dw Song15_Sq1_Section3Data
	EndSong


Song15_Sq2Data:
	dw Song15_Sq2_Section1Data
	dw Song15_Sq2_Section2Data
	dw Song15_Sq2_Section1Data
	dw Song15_Sq2_Section3Data


Song15_WavData:
	dw Song15_Wav_Section1Data
	dw Song15_Wav_Section2Data
	dw Song15_Wav_Section1Data
	dw Song15_Wav_Section3Data


Song15_NoiseData:
	dw Song15_Noise_Section1Data
	dw Song15_Noise_Section2Data
	dw Song15_Noise_Section1Data
	dw Song15_Noise_Section2Data


Song15_Sq1_Section1Data:
	SetParams $d1, $80
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Fsharp, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Bnote, 4
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Enote, 5
	NextSection


Song15_Sq2_Section1Data:
	SetParams $b2, $80
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Csharp, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Csharp, 5
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	DisableEnvelope
	NextSection
	
	
Song15_Wav_Section1Data:
	SetParams DefaultWavRam, $20
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Dnote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Fsharp, 5
	DisableEnvelope
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Csharp, 5
	DisableEnvelope
	NextSection
	
	
Song15_Noise_Section1Data:
	UseTempo 2
	PlayNoise 1
	UseTempo 7
	PlayNoise 0
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	UseTempo 2
	PlayNoise 1
	UseTempo 7
	PlayNoise 0
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	NextSection
	
	
Song15_Sq1_Section2Data:
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Bnote, 4
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	PlayNote Fsharp, 5
	PlayNote Gsharp, 5
	NextSection


Song15_Sq2_Section2Data:
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Dnote, 4
	UseTempo 1
	PlayNote Dnote, 4
	PlayNote Dnote, 4
	UseTempo 2
	PlayNote Dnote, 4
	DisableEnvelope
	NextSection


Song15_Wav_Section2Data:
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	PlayNote Gsharp, 4
	UseTempo 2
	PlayNote Gsharp, 4
	DisableEnvelope
	NextSection
	
	
Song15_Noise_Section2Data:
	UseTempo 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	NextSection
	

Song15_Sq1_Section3Data:
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Anote, 5
	NextSection


Song15_Sq2_Section3Data:
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	PlayNote Enote, 4
	UseTempo 2
	DisableEnvelope
	PlayNote Enote, 4
	UseTempo 3
	PlayNote Csharp, 5
	NextSection


Song15_Wav_Section3Data:
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Anote, 4
	UseTempo 2
	DisableEnvelope
	PlayNote Csharp, 5
	UseTempo 3
	PlayNote Anote, 4
	NextSection


Song10_Sq2Data:
	dw Song10_Sq2_Section1Data
	EndSong


Song10_Sq2_Section1Data:
	SetParams $c2, $40
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Fsharp, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Gsharp, 4
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 4
	DisableEnvelope
	NextSection
	
	
Song11_Sq2Data:
	dw Song11_Sq2_Section1Data
	EndSong


Song11_WavData:
	dw Song11_Wav_Section1Data


Song11_Sq2_Section1Data:
	SetParams $c2, $80
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Fsharp, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Anote, 5
	UseTempo 4
	DisableEnvelope
	NextSection
	
	
Song11_Wav_Section1Data:
	SetParams DefaultWavRam, $20
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Enote, 5
	PlayNote Fsharp, 5
	DisableEnvelope
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Anote, 4
	DisableEnvelope
	UseTempo 5
	DisableEnvelope


Song12_Sq2Data:
	dw Song12_Sq2_Section1Data
	EndSong


Song12_Sq1Data:
	dw Song12_Sq1_Section1Data


Song12_WavData:
	dw Song12_Wav_Section1Data
	

Song12_Sq2_Section1Data:
	SetParams $c2, $80
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Fsharp, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Anote, 5
	UseTempo 4
	DisableEnvelope
	NextSection
	
	
Song12_Sq1_Section1Data:
	SetParams $c2, $40
	UseTempo 2
	PlayNote Dnote, 5
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Fsharp, 5
	PlayNote Dnote, 5
	UseTempo 3
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Csharp, 4
	PlayNote Csharp, 5
	UseTempo 3
	PlayNote Csharp, 5
	UseTempo 5
	DisableEnvelope
	NextSection
	
	
Song12_Wav_Section1Data:
	SetParams DefaultWavRam, $20
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Fsharp, 5
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Anote, 4
	UseTempo 2
	DisableEnvelope
	UseTempo 5
	DisableEnvelope
	NextSection


Song13_Sq1Data:
	dw Song13_Sq1_Section1Data
	EndSong


Song13_Sq2Data:
	dw Song13_Sq2_Section1Data
	
	
Song13_WavData:
	dw Song13_Wav_Section1Data


Song13_NoiseData:
	dw Song13_Noise_Section1Data
	

Song13_Sq1_Section1Data:
	SetParams $c2, $80
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Fsharp, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Anote, 5
	UseTempo 4
	DisableEnvelope
	NextSection
	
	
Song13_Sq2_Section1Data:
	SetParams $b2, $80
	UseTempo 2
	PlayNote Dnote, 5
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Fsharp, 5
	PlayNote Dnote, 5
	UseTempo 3
	PlayNote Bnote, 4
	PlayNote Bnote, 4
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Csharp, 4
	PlayNote Csharp, 5
	UseTempo 3
	PlayNote Csharp, 5
	UseTempo 5
	DisableEnvelope
	
	
Song13_Wav_Section1Data:
	SetParams DefaultWavRam, $20
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Dnote, 5
	PlayNote Fsharp, 5
	PlayNote Anote, 5
	PlayNote Fsharp, 5
	PlayNote Dnote, 5
	PlayNote Anote, 4
	PlayNote Fsharp, 4
	PlayNote Anote, 4
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Anote, 4
	PlayNote Csharp, 5
	PlayNote Anote, 5
	DisableEnvelope
	UseTempo 2
	DisableEnvelope
	UseTempo 5
	DisableEnvelope

	
Song13_Noise_Section1Data:
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	UseTempo 5
	PlayNoise 0


Song14_Sq1Data:
	dw Song14_Sq1_Section1Data
	dw Song14_Sq1_Section2Data
	EndSong


Song14_Sq2Data:
	dw Song14_Sq2_Section1Data
	dw Song14_Sq2_Section2Data


Song14_WavData:
	dw Song14_Wav_Section1Data
	dw Song14_Wav_Section2Data


Song14_NoiseData:
	dw Song14_Noise_Section1Data
	dw Song14_Noise_Section2Data


Song14_Sq1_Section1Data:
	SetParams $d1, $80
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 1
	PlayNote Anote, 5
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Anote, 5
	PlayNote Anote, 5
	PlayNote Fsharp, 5
	PlayNote Enote, 5
	PlayNote Dnote, 5
	PlayNote Fsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	PlayNote Enote, 5
	PlayNote Csharp, 5
	PlayNote Bnote, 4
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Enote, 5
	NextSection


Song14_Sq2_Section1Data:
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 7
	DisableEnvelope
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Anote, 4
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Csharp, 5
	UseTempo 7
	DisableEnvelope
	UseTempo 2
	PlayNote Enote, 4
	PlayNote Enote, 4
	PlayNote Enote, 4
	DisableEnvelope
	NextSection
	
	
Song14_Wav_Section1Data:
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 7
	DisableEnvelope
	UseTempo 2
	PlayNote Dnote, 5
	PlayNote Enote, 5
	PlayNote Fsharp, 5
	DisableEnvelope
	UseTempo 2
	PlayNote Anote, 5
	UseTempo 7
	DisableEnvelope
	UseTempo 2
	PlayNote Anote, 4
	PlayNote Bnote, 4
	PlayNote Csharp, 5
	DisableEnvelope
	NextSection
	
	
Song14_Noise_Section1Data:
	UseTempo 2
	PlayNoise 1
	UseTempo 7
	PlayNoise 0
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	UseTempo 2
	PlayNoise 1
	UseTempo 7
	PlayNoise 0
	UseTempo 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	NextSection
	
	
Song14_Sq1_Section2Data:
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Anote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Csharp, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Bnote, 4
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Anote, 5
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Anote, 5
	NextSection


Song14_Sq2_Section2Data:
	DisableEnvelope
	PlayNote Enote, 4
	DisableEnvelope
	PlayNote Enote, 4
	DisableEnvelope
	PlayNote Enote, 4
	DisableEnvelope
	PlayNote Enote, 4
	DisableEnvelope
	PlayNote Enote, 4
	DisableEnvelope
	PlayNote Enote, 4
	DisableEnvelope
	PlayNote Enote, 4
	UseTempo 3
	PlayNote Csharp, 4


Song14_Wav_Section2Data:
	DisableEnvelope
	PlayNote Bnote, 4
	DisableEnvelope
	PlayNote Bnote, 4
	DisableEnvelope
	PlayNote Bnote, 4
	DisableEnvelope
	PlayNote Bnote, 4
	DisableEnvelope
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Csharp, 5
	UseTempo 3
	PlayNote Anote, 4


Song14_Noise_Section2Data:
	UseTempo 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 0
	PlayNoise 2
	UseTempo 2
	PlayNoise 0
	PlayNoise 2
	PlayNoise 2
	PlayNoise 0
	
	
Song9_Sq2Data:
	dw Song9_Sq2_Section1Data
	EndSong


Song9_Sq1Data:
	dw Song9_Sq1_Section1Data


Song9_WavData:
	dw Song9_Wav_Section1Data


Song9_NoiseData:
	dw Song9_Noise_Section1Data


Song9_Sq2_Section1Data:
	SetParams $b3, $80
	UseTempo 6
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Dsharp, 5
	UseTempo 6
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Dsharp, 5
	UseTempo 6
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Bnote, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 6
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Cnote, 5
	UseTempo 6
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Cnote, 5
	UseTempo 6
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Gsharp, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 6
	PlayNote Fsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	UseTempo 6
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Bnote, 4
	UseTempo 6
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Dsharp, 5
	UseTempo 6
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Fsharp, 5
	UseTempo 6
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 6
	NextSection


Song9_Sq1_Section1Data:
	SetParams $93, $c0
	UseTempo 6
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gnote, 4
	UseTempo 6
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gnote, 4
	UseTempo 6
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 6
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Dsharp, 4
	UseTempo 6
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Dsharp, 4
	UseTempo 6
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Enote, 4
	UseTempo 3
	DisableEnvelope
	UseTempo 6
	PlayNote Dsharp, 4
	UseTempo 1
	PlayNote Dsharp, 4
	UseTempo 6
	PlayNote Enote, 4
	UseTempo 1
	PlayNote Fsharp, 4
	UseTempo 6
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Anote, 4
	UseTempo 6
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Csharp, 5
	UseTempo 6
	PlayNote Gsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4


Song9_Wav_Section1Data:
	SetParams DefaultWavRam, $a0
	UseTempo 6
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Asharp, 4
	UseTempo 6
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Asharp, 4
	UseTempo 6
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Enote, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 6
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Gsharp, 4
	UseTempo 6
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Gsharp, 4
	UseTempo 6
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Csharp, 5
	UseTempo 3
	DisableEnvelope
	UseTempo 6
	PlayNote Bnote, 4
	UseTempo 1
	PlayNote Enote, 4
	UseTempo 6
	PlayNote Fsharp, 4
	UseTempo 1
	PlayNote Gsharp, 4
	UseTempo 6
	PlayNote Anote, 4
	UseTempo 1
	PlayNote Bnote, 4
	UseTempo 6
	PlayNote Csharp, 5
	UseTempo 1
	PlayNote Dsharp, 5
	UseTempo 6
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 4


Song9_Noise_Section1Data:
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 3
	PlayNoise 0
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 3
	PlayNoise 0
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 3
	PlayNoise 0
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	
	
Song1_Sq1Data:
	dw Song1_Sq1_Section1Data
	JumpSection :+
	

Song1_Sq2Data:
	dw Song1_Sq2_Section1Data
:	dw Song1_Sq1and2_Section2Data
.loop:
	dw Song1_Sq1and2_Section3Data
	dw Song1_Sq1and2_Section4Data
	dw Song1_Sq1and2_Section3Data
	dw Song1_Sq1and2_Section5Data
	dw Song1_Sq1and2_Section6Data
	JumpSection .loop


Song1_WavData:
	dw Song1_Wav_Section1Data
:	dw Song1_Wav_Section2Data
	dw Song1_Wav_Section3Data
	dw Song1_Wav_Section2Data
	dw Song1_Wav_Section4Data
	dw Song1_Wav_Section5Data
	JumpSection :-


Song1_NoiseData:
	dw Song1_Noise_Section1Data
:	dw Song1_Noise_Section2Data
	JumpSection :-
	

Song1_Sq2_Section1Data:
	SetParams $60, $81
	NextSection


Song1_Sq1_Section1Data:
	SetParams $20, $81
	UseTempo 10
	DisableEnvelope
	NextSection
	
	
Song1_Sq1and2_Section2Data:
	UseTempo 3
	DisableEnvelope
	PlayNote Dsharp, 5
	PlayNote Fnote, 5
	PlayNote Gnote, 5
	NextSection


Song1_Wav_Section1Data:
	UseTempo 5
	DisableEnvelope
	NextSection
	
	
Song1_Noise_Section1Data:
	UseTempo 5
	PlayNoise 0
	NextSection
	
	
Song1_Noise_Section2Data:
	UseTempo 3
	DisableEnvelope
	PlayNote Dnote, 2
	DisableEnvelope
	PlayNote Dnote, 2
	DisableEnvelope
	UseTempo 2
	PlayNote Dnote, 2
	PlayNote Dnote, 2
	UseTempo 3
	DisableEnvelope
	PlayNote Dnote, 2
	UseTempo 3
	DisableEnvelope
	PlayNote Dnote, 2
	DisableEnvelope
	PlayNote Dnote, 2
	DisableEnvelope
	UseTempo 2
	PlayNote Dnote, 2
	PlayNote Dnote, 2
	DisableEnvelope
	DisableEnvelope
	PlayNote Dnote, 2
	PlayNote Dnote, 2
	NextSection


Song1_Sq1and2_Section3Data:
	UseTempo 7
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Asharp, 5
	UseTempo 7
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Gnote, 5
	UseTempo 7
	PlayNote Gnote, 5
	UseTempo 2
	PlayNote Fnote, 5
	UseTempo 7
	PlayNote Gnote, 5
	UseTempo 2
	PlayNote Fnote, 5
	NextSection


Song1_Wav_Section2Data:
	SetParams WavRam_6ec9, $20
	UseTempo 2
	PlayNote Gsharp, 5
	PlayNote Cnote, 6
	PlayNote Dsharp, 6
	PlayNote Gnote, 6
	PlayNote Gsharp, 5
	PlayNote Cnote, 6
	PlayNote Dsharp, 6
	PlayNote Gnote, 6
	PlayNote Gsharp, 5
	PlayNote Csharp, 6
	PlayNote Dnote, 6
	PlayNote Fnote, 6
	PlayNote Gsharp, 5
	PlayNote Csharp, 6
	PlayNote Dnote, 6
	PlayNote Fnote, 6
	NextSection


Song1_Sq1and2_Section4Data:
	UseTempo 7
	PlayNote Fnote, 5
	UseTempo 2
	PlayNote Dsharp, 5
	UseTempo 7
	PlayNote Fnote, 5
	UseTempo 2
	PlayNote Dsharp, 5
	UseTempo 7
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 7
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Dsharp, 5
	NextSection


Song1_Wav_Section3Data:
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Fnote, 6
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Fnote, 6
	PlayNote Dsharp, 5
	PlayNote Fnote, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Dsharp, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	NextSection


Song1_Sq1and2_Section5Data:
	UseTempo 7
	PlayNote Fnote, 5
	UseTempo 2
	PlayNote Dsharp, 5
	UseTempo 7
	PlayNote Fnote, 5
	UseTempo 2
	PlayNote Dsharp, 5
	UseTempo 7
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 7
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Asharp, 4
	NextSection


Song1_Wav_Section4Data:
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Fnote, 6
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Fnote, 6
	PlayNote Dsharp, 5
	PlayNote Fnote, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Dsharp, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	NextSection


Song1_Sq1and2_Section6Data:
	UseTempo 7
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 7
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Asharp, 4
	UseTempo 7
	PlayNote Asharp, 4
	UseTempo 2
	PlayNote Anote, 4
	UseTempo 7
	PlayNote Asharp, 4
	UseTempo 2
	PlayNote Cnote, 5
	UseTempo 7
	PlayNote Csharp, 5
	UseTempo 2
	PlayNote Dsharp, 5
	UseTempo 7
	PlayNote Csharp, 5
	UseTempo 2
	PlayNote Cnote, 5
	UseTempo 7
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Asharp, 4
	UseTempo 7
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Csharp, 5
	UseTempo 7
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Dnote, 5
	UseTempo 7
	PlayNote Dsharp, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 7
	PlayNote Gnote, 5
	UseTempo 2
	PlayNote Fnote, 5
	UseTempo 7
	PlayNote Gsharp, 5
	UseTempo 2
	PlayNote Fnote, 5
	UseTempo 7
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Dsharp, 5
	UseTempo 7
	PlayNote Csharp, 5
	UseTempo 2
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Gsharp, 4
	PlayNote Dsharp, 4
	PlayNote Fnote, 4
	PlayNote Cnote, 5
	UseTempo 3
	PlayNote Gsharp, 4
	DisableEnvelope
	NextSection
	
	
Song1_Wav_Section5Data:
	PlayNote Cnote, 5
	PlayNote Enote, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Cnote, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Cnote, 6
	PlayNote Fnote, 5
	PlayNote Cnote, 6
	PlayNote Dsharp, 6
	PlayNote Fnote, 6
	PlayNote Fnote, 5
	PlayNote Cnote, 6
	PlayNote Dsharp, 6
	PlayNote Fnote, 6
	PlayNote Asharp, 4
	PlayNote Csharp, 5
	PlayNote Fnote, 5
	PlayNote Asharp, 5
	PlayNote Asharp, 4
	PlayNote Csharp, 5
	PlayNote Fnote, 5
	PlayNote Gsharp, 5
	PlayNote Dsharp, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Dsharp, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Fnote, 6
	PlayNote Cnote, 5
	PlayNote Dsharp, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Cnote, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Cnote, 6
	PlayNote Dnote, 5
	PlayNote Fnote, 5
	PlayNote Gsharp, 5
	PlayNote Cnote, 6
	PlayNote Dnote, 5
	PlayNote Fnote, 5
	PlayNote Gsharp, 5
	PlayNote Dnote, 6
	PlayNote Dsharp, 5
	PlayNote Gnote, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Dsharp, 5
	PlayNote Asharp, 5
	PlayNote Csharp, 6
	PlayNote Dsharp, 6
	UseTempo 8
	PlayNote Gsharp, 5
	UseTempo 3
	DisableEnvelope
	NextSection
	
	
Song2_Sq2Data:
	dw Song2_Sq2_Section1Data
	EndSong


Song2_Sq1Data:
	dw Song2_Sq1_Section1Data


Song2_WavData:
	dw Song2_Wav_Section1Data


Song2_NoiseData:
	dw Song2_Noise_Section1Data
	

Song2_Sq2_Section1Data:
	SetParams $b1, $80
	UseTempo 7
	DisableEnvelope
	UseTempo 1
	PlayNote Asharp, 5
	PlayNote Asharp, 5
	UseTempo 6
	PlayNote Dsharp, 6
	UseTempo 1
	PlayNote Asharp, 5
	UseTempo 4
	PlayNote Dsharp, 6
	NextSection


Song2_Sq1_Section1Data:
	SetParams $91, $80
	UseTempo 7
	DisableEnvelope
	UseTempo 1
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	UseTempo 6
	PlayNote Asharp, 5
	UseTempo 1
	PlayNote Gnote, 5
	UseTempo 4
	PlayNote Asharp, 5


Song2_Wav_Section1Data:
	SetParams DefaultWavRam, $20
	UseTempo 7
	DisableEnvelope
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Dnote, 5
	UseTempo 6
	PlayNote Gnote, 5
	UseTempo 1
	PlayNote Dsharp, 5
	UseTempo 3
	PlayNote Gnote, 5
	DisableEnvelope
	
	
Song2_Noise_Section1Data:
	UseTempo 7
	PlayNoise 0
	UseTempo 1
	PlayNoise 1
	PlayNoise 1
	UseTempo 6
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	UseTempo 0
	PlayNoise 1
	PlayNoise 1
	PlayNoise 1
	PlayNoise 1
	PlayNoise 1
	PlayNoise 1
	PlayNoise 1
	PlayNoise 1
	UseTempo 3
	PlayNoise 0
	
	
Song8_Sq2Data:
:	dw Song8_Sq2_Section1Data
	dw Song8_Sq2_Section2Data
	dw Song8_Sq2_Section1Data
	dw Song8_Sq2_Section3Data
	JumpSection :-


Song8_Sq1Data:
:	dw Song8_Sq1_Section1Data
	dw Song8_Sq1_Section2Data
	dw Song8_Sq1_Section1Data
	dw Song8_Sq1_Section3Data
	JumpSection :-


Song8_WavData:
:	dw Song8_Wav_Section1Data
	dw Song8_Wav_Section2Data
	dw Song8_Wav_Section1Data
	dw Song8_Wav_Section3Data
	JumpSection :-


Song8_NoiseData:
:	dw Song8_Noise_Section1Data
	JumpSection :-
	

Song8_Sq2_Section1Data:
	SetParams $82, $80
	UseTempo 2
	PlayNote Fnote, 5
	UseTempo 1
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Cnote, 5
	PlayNote Asharp, 4
	PlayNote Cnote, 5
	UseTempo 2
	PlayNote Fnote, 5
	UseTempo 1
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Gnote, 5
	PlayNote Anote, 5
	PlayNote Gnote, 5
	UseTempo 2
	PlayNote Fnote, 5
	UseTempo 1
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Gnote, 5
	PlayNote Fnote, 5
	PlayNote Enote, 5
	PlayNote Fnote, 5
	UseTempo 1
	PlayNote Gnote, 5
	PlayNote Anote, 5
	PlayNote Gnote, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Gnote, 5
	UseTempo 1
	PlayNote Fsharp, 5
	PlayNote Gnote, 5
	NextSection


Song8_Sq1_Section1Data:
	SetParams $62, $80
	UseTempo 2
	DisableEnvelope
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Gnote, 4
	DisableEnvelope
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Anote, 4
	DisableEnvelope
	PlayNote Gnote, 4
	DisableEnvelope
	PlayNote Gnote, 4
	NextSection


Song8_Wav_Section1Data:
	SetParams DefaultWavRam, $20
	UseTempo 2
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Cnote, 5
	PlayNote Enote, 5
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Cnote, 5
	PlayNote Gnote, 5
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Enote, 5
	PlayNote Fnote, 5
	PlayNote Dnote, 5
	PlayNote Fnote, 5
	PlayNote Cnote, 5
	PlayNote Enote, 5
	NextSection


Song8_Noise_Section1Data:
	UseTempo 2
	PlayNoise 1
	PlayNoise 2
	PlayNoise 1
	PlayNoise 2
	PlayNoise 1
	PlayNoise 2
	PlayNoise 1
	PlayNoise 2
	PlayNoise 1
	PlayNoise 2
	PlayNoise 1
	PlayNoise 2
	PlayNoise 1
	UseTempo 1
	PlayNoise 2
	PlayNoise 2
	PlayNoise 1
	UseTempo 2
	PlayNoise 2
	UseTempo 1
	PlayNoise 1
	NextSection


Song8_Sq2_Section2Data:
	UseTempo 2
	PlayNote Asharp, 5
	UseTempo 1
	PlayNote Asharp, 5
	PlayNote Asharp, 5
	PlayNote Asharp, 5
	PlayNote Fnote, 5
	PlayNote Dsharp, 5
	PlayNote Fnote, 5
	UseTempo 2
	PlayNote Asharp, 5
	UseTempo 1
	PlayNote Asharp, 5
	PlayNote Asharp, 5
	PlayNote Asharp, 5
	PlayNote Cnote, 6
	PlayNote Dnote, 6
	PlayNote Cnote, 6
	UseTempo 2
	PlayNote Asharp, 5
	UseTempo 1
	PlayNote Asharp, 5
	PlayNote Anote, 5
	UseTempo 2
	PlayNote Gnote, 5
	UseTempo 1
	PlayNote Gnote, 5
	PlayNote Fnote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Fnote, 5
	PlayNote Enote, 5
	PlayNote Fnote, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Dnote, 5
	PlayNote Enote, 5
	NextSection


Song8_Sq1_Section2Data:
	UseTempo 2
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Cnote, 5
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Cnote, 5
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Asharp, 4
	DisableEnvelope
	PlayNote Asharp, 4
	NextSection


Song8_Wav_Section2Data:
	UseTempo 2
	PlayNote Asharp, 4
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Asharp, 4
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Fnote, 5
	PlayNote Asharp, 4
	PlayNote Fnote, 5
	PlayNote Enote, 5
	PlayNote Gnote, 5
	PlayNote Anote, 4
	PlayNote Enote, 5
	PlayNote Cnote, 5
	PlayNote Gnote, 5
	NextSection


Song8_Sq2_Section3Data:
	UseTempo 2
	PlayNote Cnote, 6
	UseTempo 1
	PlayNote Cnote, 6
	PlayNote Cnote, 6
	PlayNote Cnote, 6
	PlayNote Asharp, 5
	PlayNote Gsharp, 5
	PlayNote Asharp, 5
	UseTempo 2
	PlayNote Cnote, 6
	UseTempo 1
	PlayNote Cnote, 6
	PlayNote Cnote, 6
	PlayNote Cnote, 6
	PlayNote Asharp, 5
	PlayNote Gsharp, 5
	PlayNote Asharp, 5
	UseTempo 2
	PlayNote Cnote, 6
	UseTempo 1
	PlayNote Cnote, 5
	PlayNote Dnote, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Cnote, 5
	PlayNote Anote, 5
	UseTempo 3
	PlayNote Gnote, 5
	UseTempo 1
	PlayNote Fnote, 5
	UseTempo 6
	PlayNote Fnote, 6
	NextSection


Song8_Sq1_Section3Data:
	UseTempo 2
	DisableEnvelope
	PlayNote Cnote, 5
	DisableEnvelope
	PlayNote Cnote, 5
	DisableEnvelope
	PlayNote Cnote, 5
	DisableEnvelope
	PlayNote Cnote, 5
	DisableEnvelope
	UseTempo 1
	PlayNote Asharp, 4
	PlayNote Asharp, 4
	UseTempo 2
	PlayNote Asharp, 4
	UseTempo 1
	PlayNote Asharp, 4
	PlayNote Asharp, 4
	UseTempo 3
	PlayNote Asharp, 4
	UseTempo 2
	PlayNote Anote, 4
	DisableEnvelope
	NextSection
	
	
Song8_Wav_Section3Data:
	UseTempo 2
	PlayNote Gsharp, 4
	PlayNote Gsharp, 5
	PlayNote Dsharp, 5
	PlayNote Gsharp, 5
	PlayNote Gsharp, 4
	PlayNote Gsharp, 5
	PlayNote Dsharp, 5
	PlayNote Gsharp, 5
	PlayNote Cnote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Enote, 5
	UseTempo 1
	PlayNote Enote, 5
	PlayNote Enote, 5
	UseTempo 3
	PlayNote Enote, 5
	UseTempo 2
	PlayNote Fnote, 5
	DisableEnvelope
	NextSection
