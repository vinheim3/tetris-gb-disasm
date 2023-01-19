; --
; -- Misc
; --

macro ldbc
    ld bc, (\1<<8)|\2
endm

; for xor a where 0 can be subbed with a constant
macro lda
ASSERT \1 == $00
    xor a
endm

; --
; -- Music
; --

Cnote = 0
Csharp = 1
Dnote = 2
Dsharp = 3
Enote = 4
Fnote = 5
Fsharp = 6
Gnote = 7
Gsharp = 8
Anote = 9
Asharp = 10
Bnote = 11
; Sound data bytes
; C2 = 2, C#2 = 4
macro PlayNote
    db (\1+1+(\2-2)*12)*2
endm
macro SetParams
    db $9d
    dw \1
    db \2
endm
macro UseTempo
    db $a0|\1
endm
macro DisableEnvelope
    db $01
endm
macro NextSection
    db $00
endm
macro PlayNoise
    db \1*5+1
endm

; Used in tables containing sound byte addresses
macro JumpSection
    dw $ffff, \1
endm
macro EndSong
    dw $0000
endm