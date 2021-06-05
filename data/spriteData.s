; last data table byte == $fd - x flip next tile
; last data table byte == $fe - skip next coords
; last data table byte == $ff - end
; last data table byte == others - specifies the tile index


SpriteData:
	dw SpriteSpec_00
	dw SpriteSpec_01
	dw SpriteSpec_02
	dw SpriteSpec_03
	dw SpriteSpec_04
	dw SpriteSpec_05
	dw SpriteSpec_06
	dw SpriteSpec_07
	dw SpriteSpec_08
	dw SpriteSpec_09
	dw SpriteSpec_0a
	dw SpriteSpec_0b
	dw SpriteSpec_0c
	dw SpriteSpec_0d
	dw SpriteSpec_0e
	dw SpriteSpec_0f
	dw SpriteSpec_10
	dw SpriteSpec_11
	dw SpriteSpec_12
	dw SpriteSpec_13
	dw SpriteSpec_14
	dw SpriteSpec_15
	dw SpriteSpec_16
	dw SpriteSpec_17
	dw SpriteSpec_18
	dw SpriteSpec_19
	dw SpriteSpec_1a
	dw SpriteSpec_1b
	dw SpriteSpec_1c
	dw SpriteSpec_1d
	dw SpriteSpec_1e
	dw SpriteSpec_1f
	dw SpriteSpec_20
	dw SpriteSpec_21
	dw SpriteSpec_22
	dw SpriteSpec_23
	dw SpriteSpec_24
	dw SpriteSpec_25
	dw SpriteSpec_26
	dw SpriteSpec_27
	dw SpriteSpec_28
	dw SpriteSpec_29
	dw SpriteSpec_2a
	dw SpriteSpec_2b
	dw SpriteSpec_2c
	dw SpriteSpec_2d
	dw SpriteSpec_2e
	dw SpriteSpec_2f
	dw SpriteSpec_30
	dw SpriteSpec_31
	dw SpriteSpec_32
	dw SpriteSpec_33
	dw SpriteSpec_34
	dw SpriteSpec_35
	dw SpriteSpec_36
	dw SpriteSpec_37
	dw SpriteSpec_38
	dw SpriteSpec_39
	dw SpriteSpec_3a
	dw SpriteSpec_3b
	dw SpriteSpec_3c
	dw SpriteSpec_3d
	dw SpriteSpec_3e
	dw SpriteSpec_3f
	dw SpriteSpec_40
	dw SpriteSpec_41
	dw SpriteSpec_42
	dw SpriteSpec_43
	dw SpriteSpec_44
	dw SpriteSpec_45
	dw SpriteSpec_46
	dw SpriteSpec_47
	dw SpriteSpec_48
	dw SpriteSpec_49
	dw SpriteSpec_4a
	dw SpriteSpec_4b
	dw SpriteSpec_4c
	dw SpriteSpec_4d
	dw SpriteSpec_4e
	dw SpriteSpec_4f
	dw SpriteSpec_50
	dw SpriteSpec_51
	dw SpriteSpec_52
	dw SpriteSpec_53
	dw SpriteSpec_54
	dw SpriteSpec_55
	dw SpriteSpec_56
	dw SpriteSpec_57
	dw SpriteSpec_58
	dw SpriteSpec_59
	dw SpriteSpec_5a
	dw SpriteSpec_5b
	dw SpriteSpec_5c
	dw SpriteSpec_5d

SpriteSpec_00:
	dw SpriteTiles_00
	db $ef, $f0

SpriteSpec_01:
	dw SpriteTiles_01
	db $ef, $f0

SpriteSpec_02:
	dw SpriteTiles_02
	db $ef, $f0

SpriteSpec_03:
	dw SpriteTiles_03
	db $ef, $f0

SpriteSpec_04:
	dw SpriteTiles_04
	db $ef, $f0

SpriteSpec_05:
	dw SpriteTiles_05
	db $ef, $f0

SpriteSpec_06:
	dw SpriteTiles_06
	db $ef, $f0

SpriteSpec_07:
	dw SpriteTiles_07
	db $ef, $f0

SpriteSpec_08:
	dw SpriteTiles_08
	db $ef, $f0

SpriteSpec_09:
	dw SpriteTiles_09
	db $ef, $f0

SpriteSpec_0a:
	dw SpriteTiles_0a
	db $ef, $f0

SpriteSpec_0b:
	dw SpriteTiles_0b
	db $ef, $f0

SpriteSpec_0c:
	dw SpriteTiles_0c
	db $ef, $f0

SpriteSpec_0d:
	dw SpriteTiles_0d
	db $ef, $f0

SpriteSpec_0e:
	dw SpriteTiles_0e
	db $ef, $f0

SpriteSpec_0f:
	dw SpriteTiles_0f
	db $ef, $f0

SpriteSpec_10:
	dw SpriteTiles_10
	db $ef, $f0

SpriteSpec_11:
	dw SpriteTiles_11
	db $ef, $f0

SpriteSpec_12:
	dw SpriteTiles_12
	db $ef, $f0

SpriteSpec_13:
	dw SpriteTiles_13
	db $ef, $f0

SpriteSpec_14:
	dw SpriteTiles_14
	db $ef, $f0

SpriteSpec_15:
	dw SpriteTiles_15
	db $ef, $f0

SpriteSpec_16:
	dw SpriteTiles_16
	db $ef, $f0

SpriteSpec_17:
	dw SpriteTiles_17
	db $ef, $f0

SpriteSpec_18:
	dw SpriteTiles_18
	db $ef, $f0

SpriteSpec_19:
	dw SpriteTiles_19
	db $ef, $f0

SpriteSpec_1a:
	dw SpriteTiles_1a
	db $ef, $f0

SpriteSpec_1b:
	dw SpriteTiles_1b
	db $ef, $f0

SpriteSpec_1c:
	dw SpriteTiles_1c
	db $00, $e8

SpriteSpec_1d:
	dw SpriteTiles_1d
	db $00, $e8

SpriteSpec_1e:
	dw SpriteTiles_1e
	db $00, $e8

SpriteSpec_1f:
	dw SpriteTiles_1f
	db $00, $e8

SpriteSpec_20:
	dw SpriteTiles_20
	db $00, $00

SpriteSpec_21:
	dw SpriteTiles_21
	db $00, $00

SpriteSpec_22:
	dw SpriteTiles_22
	db $00, $00

SpriteSpec_23:
	dw SpriteTiles_23
	db $00, $00

SpriteSpec_24:
	dw SpriteTiles_24
	db $00, $00

SpriteSpec_25:
	dw SpriteTiles_25
	db $00, $00

SpriteSpec_26:
	dw SpriteTiles_26
	db $00, $00

SpriteSpec_27:
	dw SpriteTiles_27
	db $00, $00

SpriteSpec_28:
	dw SpriteTiles_28
	db $00, $00

SpriteSpec_29:
	dw SpriteTiles_29
	db $00, $00

SpriteSpec_2a:
	dw SpriteTiles_2a
	db $f0, $f8

SpriteSpec_2b:
SpriteSpec_2d:
	dw SpriteTiles_2d
	db $f0, $f8

SpriteSpec_2e:
	dw SpriteTiles_2e
	db $f0, $f0

SpriteSpec_2f:
	dw SpriteTiles_2f
	db $f0, $f0

SpriteSpec_30:
	dw SpriteTiles_30
	db $f8, $f8

SpriteSpec_31:
	dw SpriteTiles_31
	db $f8, $f8

SpriteSpec_32:
	dw SpriteTiles_32
	db $f8, $f8

SpriteSpec_33:
	dw SpriteTiles_33
	db $f8, $f8

SpriteSpec_36:
	dw SpriteTiles_36
	db $f0, $f8

SpriteSpec_37:
	dw SpriteTiles_37
	db $f0, $f8

SpriteSpec_3a:
	dw SpriteTiles_3a
	db $f0, $f0

SpriteSpec_3b:
	dw SpriteTiles_3b
	db $f0, $f0

SpriteSpec_3c:
	dw SpriteTiles_3c
	db $f8, $f8

SpriteSpec_3d:
	dw SpriteTiles_3d
	db $f8, $f8

SpriteSpec_3e:
	dw SpriteTiles_3e
	db $f8, $f8

SpriteSpec_3f:
SpriteSpec_42:
	dw SpriteTiles_42
	db $f8, $f8

SpriteSpec_43:
SpriteSpec_44:
	dw SpriteTiles_44
	db $f8, $f8

SpriteSpec_45:
	dw SpriteTiles_45
	db $f8, $f8

SpriteSpec_46:
	dw SpriteTiles_46
	db $f8, $f8

SpriteSpec_47:
	dw SpriteTiles_47
	db $f8, $f8

SpriteSpec_48:
	dw SpriteTiles_48
	db $f8, $f8

SpriteSpec_49:
	dw SpriteTiles_49
	db $f8, $f8

SpriteSpec_4a:
	dw SpriteTiles_4a
	db $f8, $f8

SpriteSpec_4b:
	dw SpriteTiles_4b
	db $f8, $f8

SpriteSpec_4c:
	dw SpriteTiles_4c
	db $f8, $f8

SpriteSpec_4d:
	dw SpriteTiles_4d
	db $f8, $f8

SpriteSpec_4e:
	dw SpriteTiles_4e
	db $f8, $f8

SpriteSpec_4f:
	dw SpriteTiles_4f
	db $f8, $f8

SpriteSpec_50:
	dw SpriteTiles_50
	db $f8, $f8

SpriteSpec_51:
	dw SpriteTiles_51
	db $f8, $f8

SpriteSpec_52:
	dw SpriteTiles_52
	db $f8, $f8

SpriteSpec_53:
	dw SpriteTiles_53
	db $f8, $f8

SpriteSpec_54:
	dw SpriteTiles_54
	db $f8, $f8

SpriteSpec_55:
	dw SpriteTiles_55
	db $f8, $f8

SpriteSpec_56:
	dw SpriteTiles_56
	db $f0, $f0

SpriteSpec_57:
	dw SpriteTiles_57
	db $f8, $f8

SpriteTiles_00:
	dw SpriteCoords_00
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $84, $84, $84, $fe, $84, $ff

SpriteTiles_01:
	dw SpriteCoords_01
	db $fe, $fe, $fe, $fe, $fe, $84, $fe, $fe, $fe, $84, $fe, $fe, $fe, $84, $84, $ff

SpriteTiles_02:
	dw SpriteCoords_02
	db $fe, $fe, $fe, $fe, $fe, $fe, $84, $fe, $84, $84, $84, $fe, $ff

SpriteTiles_03:
	dw SpriteCoords_03
	db $fe, $fe, $fe, $fe, $84, $84, $fe, $fe, $fe, $84, $fe, $fe, $fe, $84, $ff

SpriteTiles_04:
	dw SpriteCoords_04
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $81, $81, $81, $fe, $fe, $fe, $81, $ff

SpriteTiles_05:
	dw SpriteCoords_05
	db $fe, $fe, $fe, $fe, $fe, $81, $81, $fe, $fe, $81, $fe, $fe, $fe, $81, $ff

SpriteTiles_06:
	dw SpriteCoords_06
	db $fe, $fe, $fe, $fe, $81, $fe, $fe, $fe, $81, $81, $81, $ff

SpriteTiles_07:
	dw SpriteCoords_07
	db $fe, $fe, $fe, $fe, $fe, $81, $fe, $fe, $fe, $81, $fe, $fe, $81, $81, $ff

SpriteTiles_08:
	dw SpriteCoords_08
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $8a, $8b, $8b, $8f, $ff

SpriteTiles_09:
	dw SpriteCoords_09
	db $fe, $80, $fe, $fe, $fe, $88, $fe, $fe, $fe, $88, $fe, $fe, $fe, $89, $ff

SpriteTiles_0a:
	dw SpriteCoords_0a
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $8a, $8b, $8b, $8f, $ff

SpriteTiles_0b:
	dw SpriteCoords_0b
	db $fe, $80, $fe, $fe, $fe, $88, $fe, $fe, $fe, $88, $fe, $fe, $fe, $89, $ff

SpriteTiles_0c:
	dw SpriteCoords_0c
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $83, $83, $fe, $fe, $83, $83, $ff

SpriteTiles_0d:
	dw SpriteCoords_0d
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $83, $83, $fe, $fe, $83, $83, $ff

SpriteTiles_0e:
	dw SpriteCoords_0e
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $83, $83, $fe, $fe, $83, $83, $ff

SpriteTiles_0f:
	dw SpriteCoords_0f
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $83, $83, $fe, $fe, $83, $83, $ff

SpriteTiles_10:
	dw SpriteCoords_10
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $82, $82, $fe, $fe, $fe, $82, $82, $ff

SpriteTiles_11:
	dw SpriteCoords_11
	db $fe, $fe, $fe, $fe, $fe, $82, $fe, $fe, $82, $82, $fe, $fe, $82, $ff

SpriteTiles_12:
	dw SpriteCoords_12
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $82, $82, $fe, $fe, $fe, $82, $82, $ff

SpriteTiles_13:
	dw SpriteCoords_13
	db $fe, $fe, $fe, $fe, $fe, $82, $fe, $fe, $82, $82, $fe, $fe, $82, $ff

SpriteTiles_14:
	dw SpriteCoords_14
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $86, $86, $fe, $86, $86, $ff

SpriteTiles_15:
	dw SpriteCoords_15
	db $fe, $fe, $fe, $fe, $86, $fe, $fe, $fe, $86, $86, $fe, $fe, $fe, $86, $ff

SpriteTiles_16:
	dw SpriteCoords_16
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $86, $86, $fe, $86, $86, $ff

SpriteTiles_17:
	dw SpriteCoords_17
	db $fe, $fe, $fe, $fe, $86, $fe, $fe, $fe, $86, $86, $fe, $fe, $fe, $86, $ff

SpriteTiles_1a:
	dw SpriteCoords_1a
	db $fe, $fe, $fe, $fe, $fe, $85, $fe, $fe, $85, $85, $85, $ff

SpriteTiles_1b:
	dw SpriteCoords_1b
	db $fe, $fe, $fe, $fe, $fe, $85, $fe, $fe, $85, $85, $fe, $fe, $fe, $85, $ff

SpriteTiles_18:
	dw SpriteCoords_18
	db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $85, $85, $85, $fe, $fe, $85, $ff

SpriteTiles_19:
	dw SpriteCoords_19
	db $fe, $fe, $fe, $fe, $fe, $85, $fe, $fe, $fe, $85, $85, $fe, $fe, $85, $ff

SpriteTiles_1c:
	dw SpriteCoords_1c
	db "A-TYPE", $ff

SpriteTiles_1d:
	dw SpriteCoords_1d
	db "B-TYPE", $ff

SpriteTiles_1e:
	dw SpriteCoords_1e
	db "C-TYPE", $ff

SpriteTiles_1f:
	dw SpriteCoords_1f
	db " OFF  ", $ff

SpriteTiles_20:
	dw SpriteCoords_20
	db "0", $ff

SpriteTiles_21:
	dw SpriteCoords_21
	db "1", $ff

SpriteTiles_22:
	dw SpriteCoords_22
	db "2", $ff

SpriteTiles_23:
	dw SpriteCoords_23
	db "3", $ff

SpriteTiles_24:
	dw SpriteCoords_24
	db "4", $ff

SpriteTiles_25:
	dw SpriteCoords_25
	db "5", $ff

SpriteTiles_26:
	dw SpriteCoords_26
	db "6", $ff

SpriteTiles_27:
	dw SpriteCoords_27
	db "7", $ff

SpriteTiles_28:
	dw SpriteCoords_28
	db "8", $ff

SpriteTiles_29:
	dw SpriteCoords_29
	db "9", $ff

SpriteTiles_2a:
	dw SpriteCoords_2a
	db $2f, $01, $2f, $11, $20, $21, $30, $31, $ff

SpriteTiles_2b:
SpriteTiles_2d:
	dw SpriteCoords_2d
	db $2f, $03, $12, $13, $22, $23, $32, $33, $ff

SpriteTiles_2e:
	dw SpriteCoords_2e
	db $2f, $05, $fd, $05, $2f, $2f, $15, $04, $17, $24, $25, $26, $27, $34, $35, $36, $2f, $ff

SpriteTiles_2f:
	dw SpriteCoords_2f
	db $08, $37, $fd, $37, $fd, $08, $18, $19, $14, $1b, $28, $29, $2a, $2b, $60, $70, $36, $2f, $ff

SpriteTiles_30:
	dw SpriteCoords_30
	db $b9, $fd, $b9, $ba, $fd, $ba, $ff

SpriteTiles_31:
	dw SpriteCoords_31
	db $82, $fd, $82, $83, $fd, $83, $ff

SpriteTiles_32:
	dw SpriteCoords_32
	db $09, $0a, $3a, $3b, $ff

SpriteTiles_33:
	dw SpriteCoords_33
	db $0b, $40, $7c, $6f, $ff

SpriteTiles_36:
	dw SpriteCoords_36
	db $2f, $0f, $2f, $1f, $5f, $2c, $2f, $3f, $ff

SpriteTiles_37:
	dw SpriteCoords_37
	db $6c, $3c, $4b, $4c, $5b, $5c, $6b, $2f, $ff

SpriteTiles_3a:
	dw SpriteCoords_3a
	db $2f, $4d, $fd, $4d, $2f, $2f, $5d, $5e, $4e, $5f, $6d, $6e, $2f, $2f, $7d, $fd, $7d, $2f, $ff

SpriteTiles_3b:
	dw SpriteCoords_3b
	db $08, $77, $fd, $77, $fd, $08, $18, $78, $43, $53, $7a, $7b, $50, $2f, $2f, $02, $fd, $7d, $2f, $ff

SpriteTiles_3c:
	dw SpriteCoords_3c
	db $b9, $fd, $b9, $ba, $fd, $ba, $ff

SpriteTiles_3d:
	dw SpriteCoords_3d
	db $82, $fd, $82, $83, $fd, $83, $ff

SpriteTiles_3e:
	dw SpriteCoords_3e
	db $09, $0a, $3a, $3b, $ff

SpriteTiles_3f:
SpriteTiles_42:
	dw SpriteCoords_42
	db $0b, $40, $7c, $6f, $ff

SpriteTiles_43:
SpriteTiles_44:
	dw SpriteCoords_44
	db $dc, $dd, $e0, $e1, $ff

SpriteTiles_45:
	dw SpriteCoords_45
	db $de, $df, $e0, $e1, $ff

SpriteTiles_46:
	dw SpriteCoords_46
	db $de, $e2, $e0, $e4, $ff

SpriteTiles_47:
	dw SpriteCoords_47
	db $dc, $ee, $e0, $e3, $ff

SpriteTiles_48:
	dw SpriteCoords_48
	db $e5, $e6, $e7, $e8, $ff

SpriteTiles_49:
	dw SpriteCoords_49
	db $fd, $e6, $fd, $e5, $fd, $e8, $fd, $e7, $ff

SpriteTiles_4a:
	dw SpriteCoords_4a
	db $e9, $ea, $eb, $ec, $ff

SpriteTiles_4b:
	dw SpriteCoords_4b
	db $ed, $ea, $eb, $ec, $ff

SpriteTiles_4c:
	dw SpriteCoords_4c
	db $f2, $f4, $f3, $bf, $ff

SpriteTiles_4d:
	dw SpriteCoords_4d
	db $f4, $f2, $bf, $f3, $ff

SpriteTiles_4e:
	dw SpriteCoords_4e
	db $c2, $fd, $c2, $c3, $fd, $c3, $ff

SpriteTiles_4f:
	dw SpriteCoords_4f
	db $c4, $fd, $c4, $c5, $fd, $c5, $ff

SpriteTiles_50:
	dw SpriteCoords_50
	db $dc, $fd, $dc, $ef, $fd, $ef, $ff

SpriteTiles_51:
	dw SpriteCoords_51
	db $f0, $fd, $f0, $f1, $fd, $f1, $ff

SpriteTiles_52:
	dw SpriteCoords_52
	db $dc, $fd, $f0, $f1, $fd, $ef, $ff

SpriteTiles_53:
	dw SpriteCoords_53
	db $f0, $fd, $dc, $ef, $fd, $f1, $ff

SpriteTiles_54:
	dw SpriteCoords_54
	db $bd, $be, $bb, $bc, $ff

SpriteTiles_55:
	dw SpriteCoords_55
	db $b9, $ba, $da, $db, $ff

SpriteSpec_2c:
	dw SpriteTiles_2c
	db $e0, $f0

SpriteTiles_2c:
	dw SpriteCoords_2c
	db $c0, $c1, $c5, $c6, $cc, $cd, $75, $76, $a4, $a5, $a6, $a7, $54, $55, $56, $57, $44, $45, $46, $47, $a0, $a1, $a2, $a3, $9c, $9d, $9e, $9f, $ff

SpriteSpec_34:
	dw SpriteTiles_34
	db $f8, $e8

SpriteSpec_35:
	dw SpriteTiles_35
	db $f0, $e8

SpriteSpec_38:
	dw SpriteTiles_38
	db $00, $00

SpriteSpec_39:
	dw SpriteTiles_39
	db $00, $00

SpriteSpec_40:
	dw SpriteTiles_40
	db $00, $00

SpriteSpec_41:
	dw SpriteTiles_41
	db $00, $00

SpriteSpec_5c:
	dw SpriteTiles_5c
	db $00, $00

SpriteSpec_5d:
	dw SpriteTiles_5d
	db $00, $00

SpriteSpec_58:
	dw SpriteTiles_58
	db $d8, $f8

SpriteSpec_59:
	dw SpriteTiles_59
	db $e8, $f8

SpriteSpec_5a:
SpriteSpec_5b:
	dw SpriteTiles_5b
	db $f0, $f8

SpriteTiles_34:
	dw SpriteCoords_34
	db $63, $64, $65, $ff

SpriteTiles_35:
	dw SpriteCoords_35
	db $63, $64, $65, $66, $67, $68, $ff

SpriteTiles_38:
	dw SpriteCoords_38
	db $41, $41, $41, $ff

SpriteTiles_39:
	dw SpriteCoords_39
	db $42, $42, $42, $ff

SpriteTiles_40:
	dw SpriteCoords_40
	db $52, $52, $52, $62, $62, $62, $ff

SpriteTiles_41:
	dw SpriteCoords_41
	db $51, $51, $51, $61, $61, $61, $71, $71, $71, $ff

SpriteTiles_56:
	dw SpriteCoords_56
	db $2f, $2f, $2f, $2f, $2f, $2f, $2f, $2f, $63, $64, $fd, $64, $fd, $63, $66, $67, $fd, $67, $fd, $66, $ff

SpriteTiles_57:
	dw SpriteCoords_57
	db $2f, $2f, $63, $64, $ff

SpriteTiles_58:
	dw SpriteCoords_58
	db $00, $fd, $00, $10, $fd, $10, $4f, $fd, $4f, $80, $fd, $80, $80, $fd, $80, $81, $fd, $81, $97, $fd, $97, $ff

SpriteTiles_59:
	dw SpriteCoords_59
	db $98, $fd, $98, $99, $fd, $99, $80, $fd, $80, $9a, $fd, $9a, $9b, $fd, $9b, $ff

SpriteTiles_5a:
SpriteTiles_5b:
	dw SpriteCoords_5b
	db $a8, $fd, $a8, $a9, $fd, $a9, $aa, $fd, $aa, $ab, $fd, $ab, $ff

SpriteTiles_5c:
	dw SpriteCoords_5c
	db $41, $2f, $2f, $ff

SpriteTiles_5d:
	dw SpriteCoords_5d
	db $52, $2f, $62, $ff

SpriteCoords_00:
SpriteCoords_01:
SpriteCoords_02:
SpriteCoords_03:
SpriteCoords_04:
SpriteCoords_05:
SpriteCoords_06:
SpriteCoords_07:
SpriteCoords_08:
SpriteCoords_09:
SpriteCoords_0a:
SpriteCoords_0b:
SpriteCoords_0c:
SpriteCoords_0d:
SpriteCoords_0e:
SpriteCoords_0f:
SpriteCoords_10:
SpriteCoords_11:
SpriteCoords_12:
SpriteCoords_13:
SpriteCoords_14:
SpriteCoords_15:
SpriteCoords_16:
SpriteCoords_17:
SpriteCoords_18:
SpriteCoords_19:
SpriteCoords_1a:
SpriteCoords_1b:
SpriteCoords_2e:
SpriteCoords_2f:
SpriteCoords_3a:
SpriteCoords_3b:
SpriteCoords_56:
	db $00, $00, $00, $08, $00, $10, $00, $18, $08, $00, $08, $08, $08, $10, $08, $18, $10, $00, $10, $08, $10, $10, $10, $18, $18, $00, $18, $08, $18, $10, $18, $18

SpriteCoords_1c:
SpriteCoords_1d:
SpriteCoords_1e:
SpriteCoords_1f:
SpriteCoords_20:
SpriteCoords_21:
SpriteCoords_22:
SpriteCoords_23:
SpriteCoords_24:
SpriteCoords_25:
SpriteCoords_26:
SpriteCoords_27:
SpriteCoords_28:
SpriteCoords_29:
	db $00, $00, $00, $08, $00, $10, $00, $18, $00, $20, $00, $28, $00, $30, $00, $38

SpriteCoords_2a:
SpriteCoords_2b:
SpriteCoords_2d:
SpriteCoords_30:
SpriteCoords_31:
SpriteCoords_32:
SpriteCoords_33:
SpriteCoords_36:
SpriteCoords_37:
SpriteCoords_3c:
SpriteCoords_3d:
SpriteCoords_3e:
SpriteCoords_3f:
SpriteCoords_42:
SpriteCoords_43:
SpriteCoords_44:
SpriteCoords_45:
SpriteCoords_46:
SpriteCoords_47:
SpriteCoords_48:
SpriteCoords_49:
SpriteCoords_4a:
SpriteCoords_4b:
SpriteCoords_4c:
SpriteCoords_4d:
SpriteCoords_4e:
SpriteCoords_4f:
SpriteCoords_50:
SpriteCoords_51:
SpriteCoords_52:
SpriteCoords_53:
SpriteCoords_54:
SpriteCoords_55:
SpriteCoords_57:
SpriteCoords_58:
SpriteCoords_59:
SpriteCoords_5a:
SpriteCoords_5b:
SpriteCoords_5c:
SpriteCoords_5d:
	db $00, $00, $00, $08, $08, $00, $08, $08, $10, $00, $10, $08, $18, $00, $18, $08, $20, $00, $20, $08, $28, $00, $28, $08, $30, $00, $30, $08

SpriteCoords_2c:
	db $00, $08, $00, $10, $08, $08, $08, $10, $10, $00, $10, $08, $10, $10, $10, $18, $18, $00, $18, $08, $18, $10, $18, $18, $20, $00, $20, $08, $20, $10, $20, $18, $28, $00, $28, $08, $28, $10, $28, $18, $30, $00, $30, $08, $30, $10, $30, $18, $38, $00, $38, $08, $38, $10, $38, $18

SpriteCoords_34:
SpriteCoords_35:
SpriteCoords_38:
SpriteCoords_39:
SpriteCoords_40:
SpriteCoords_41:
	db $00, $00, $00, $08, $00, $10, $08, $00, $08, $08, $08, $10, $10, $00, $10, $08, $10, $10
