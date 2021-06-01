TILE_0 EQU $00
TILE_EMPTY EQU $2f
TILE_CURSOR EQU $58
TILE_PIECE_SQUARES_START EQU $80
TILE_SOLID_BLOCK EQU $87
TILE_FLASHING_PIECE EQU $8c
TILE_BLACK EQU $8e

SCREEN_TILE_WIDTH EQU $14
SCREEN_TILE_HEIGHT EQU $12
GB_TILE_WIDTH EQU $20
GB_TILE_HEIGHT EQU $20
BANK_0_END_LEN EQU 9
PIECE_START_Y EQU $10
PIECE_START_X EQU $00
GAME_SQUARE_WIDTH EQU $0a
GAME_SCREEN_ROWS EQU $12
NUM_DANCERS EQU $0a

; also sprite spec X coords
GAME_TYPE_A_TYPE EQU $37
GAME_TYPE_B_TYPE EQU $77
; also sprite spec idxes
MUSIC_TYPES_START EQU $1c
MUSIC_TYPE_A_TYPE EQU $1c
MUSIC_TYPE_B_TYPE EQU $1d
MUSIC_TYPE_C_TYPE EQU $1e
MUSIC_TYPE_OFF EQU $1f

FALLING_PIECE_NONE EQU $00
FALLING_PIECE_HIT_BOTTOM EQU $01
FALLING_PIECE_CHECK_COMPLETED_ROWS EQU $02
FALLING_PIECE_ALL_ROWS_PROCESSED_AFTER_DROP EQU $03

ROWS_SHIFTING_DOWN_NONE EQU $00
ROWS_SHIFTING_DOWN_SHIFT_RAM_BUFFER EQU $01
ROWS_SHIFTING_DOWN_ROW_START EQU $02

; bcd, multiplied by level
SCORE_1_LINE EQU $0040
SCORE_2_LINES EQU $0100
SCORE_3_LINES EQU $0300
SCORE_4_LINES EQU $1200

; --
; -- Game States
; --
GS_IN_GAME_MAIN EQU $00
GS_GAME_OVER_INIT EQU $01
GS_SHUTTLE_SCENE_LIFTOFF EQU $02
GS_SHUTTLE_SCENE_SHOOT_FIRE EQU $03
GS_LEVEL_ENDED_MAIN EQU $04
GS_B_TYPE_LEVEL_FINISHED EQU $05
GS_TITLE_SCREEN_INIT EQU $06
GS_TITLE_SCREEN_MAIN EQU $07
GS_GAME_MUSIC_TYPE_INIT EQU $08
; 09 - stub
GS_IN_GAME_INIT EQU $0a
GS_SCORE_UPDATE_AFTER_B_TYPE_LEVEL_DONE EQU $0b
; 0c - unused
GS_GAME_OVER_SCREEN_CLEARING EQU $0d
GS_GAME_TYPE_MAIN EQU $0e
GS_MUSIC_TYPE_MAIN EQU $0f
GS_A_TYPE_SELECTION_INIT EQU $10
GS_A_TYPE_SELECTION_MAIN EQU $11
GS_B_TYPE_SELECTION_INIT EQU $12
GS_B_TYPE_SELECTION_MAIN EQU $13
GS_B_TYPE_HIGH_MAIN EQU $14
GS_ENTERING_HIGH_SCORE EQU $15
GS_MARIO_LUIGI_SCREEN_INIT EQU $16
GS_MARIO_LUIGI_SCREEN_MAIN EQU $17
GS_2PLAYER_IN_GAME_INIT EQU $18
GS_19 EQU $19
GS_2PLAYER_IN_GAME_MAIN EQU $1a
GS_1b EQU $1b
GS_1c EQU $1c
GS_2_PLAYER_WINNER_INIT EQU $1d
GS_2_PLAYER_LOSER_INIT EQU $1e
GS_POST_2_PLAYER_RESULTS EQU $1f
GS_2_PLAYER_WINNER_MAIN EQU $20
GS_2_PLAYER_LOSER_MAIN EQU $21
GS_DANCERS_INIT EQU $22
GS_DANCERS_MAIN EQU $23
GS_COPYRIGHT_DISPLAY EQU $24
GS_COPYRIGHT_WAITING EQU $25
GS_SHUTTLE_SCENE_INIT EQU $26
GS_SHUTTLE_SCENE_SHOW_CLOUDS EQU $27
GS_SHUTTLE_SCENE_FLASH_CLOUDS_GET_BIGGER EQU $28
GS_SHUTTLE_SCENE_FLASH_BIG_CLOUDS_REMOVE_PLATFORM EQU $29
GS_2PLAYER_GAME_MUSIC_TYPE_INIT EQU $2a
GS_2PLAYER_GAME_MUSIC_TYPE_MAIN EQU $2b
GS_SHUTTLE_SCENE_SHOW_CONGRATULATIONS EQU $2c
GS_CONGRATS_WAITING_BEFORE_B_TYPE_SCORE EQU $2d
GS_ROCKET_SCENE_INIT EQU $2e
GS_ROCKET_SCENE_SHOW_CLOUDS EQU $2f
GS_ROCKET_SCENE_POWERING_UP EQU $30
GS_ROCKET_SCENE_LIFTOFF EQU $31
GS_ROCKET_SCENE_SHOOT_FIRE EQU $32
GS_ROCKET_SCENE_END EQU $33
GS_PRE_ROCKET_SCENE_WAIT EQU $34
GS_COPYRIGHT_CAN_CONTINUE EQU $35
; 36 - stub

; --
; -- Sounds
; --
; music from 1 to 17
MUS_NONE EQU $00
MUS_ENTER_HIGH_SCORE EQU $01
MUS_B_TYPE_LEVEL_FINISHED EQU $02
MUS_TITLE_SCREEN EQU $03
MUS_GAME_OVER EQU $04
MUS_A_TYPE EQU $05
MUS_B_TYPE EQU $06
MUS_C_TYPE EQU $07
MUS_08 EQU $08
MUS_09 EQU $09
MUS_DANCERS_HIGH_0 EQU $0a
MUS_DANCERS_HIGH_1 EQU $0b
MUS_DANCERS_HIGH_2 EQU $0c
MUS_DANCERS_HIGH_3 EQU $0d
MUS_DANCERS_HIGH_4 EQU $0e
MUS_DANCERS_HIGH_5 EQU $0f
MUS_LIFTOFF EQU $10
MUS_11 EQU $11
MUS_MUTE EQU $ff
; sound effects
SND_NONE EQU $00
SND_MOVING_SELECTION EQU $01
SND_CONFIRM_OR_LETTER_TYPED EQU $02
SND_PIECE_ROTATED EQU $03
SND_PIECE_MOVED_HORIZ EQU $04
SND_TETRIS_ROWS_FELL EQU $05
SND_NON_4_LINES_CLEARED EQU $06
SND_4_LINES_CLEARED EQU $07
SND_REACHED_NEXT_LEVEL EQU $08
; wav effects
WAV_NONE EQU $00
WAV_AFTER_4_LINES_CLEARED EQU $01
WAV_GAME_OVER EQU $02
; noise effects
NOISE_NONE EQU $00
NOISE_TETRIS_ROWS_FELL EQU $01
NOISE_PIECE_HIT_FLOOR EQU $02
NOISE_ROCKET_GAS EQU $03
NOISE_ROCKET_FIRE EQU $04
; misc
AUD_TERM_SPEC_USE_1ST_OUTPUT_VAL EQU $01
AUD_TERM_SPEC_OUTPUT_VAL EQU $03

; --
; -- Serial
; --
; HW writes
SC_REQUEST_TRANSFER EQU $80
SC_PASSIVE EQU $00
SC_MASTER EQU $01

; SB bytes - title screen
SB_MASTER_PRESSING_START EQU $29
SB_PASSIVES_PING_IN_TITLE_SCREEN EQU $55

; SB bytes - game/music type screen
SB_PASSIVES_PING_IN_MUSIC_SCREEN EQU $39
SB_GAME_MUSIC_SCREEN_TO_NEXT EQU $50
; master can also send a byte for music type chosen

; Mario/Luigi Screen
SB_MARIO_LUIGI_SCREEN_TO_NEXT EQU $60
; master can also send a byte for high chosen

;
SB_ENDED_GAME_DEMO EQU $33

; Misc
MP_ROLE_PASSIVE EQU $55
MP_ROLE_MASTER EQU $29

; Serial funcs
SF_TITLE_SCREEN EQU $00
SF_IN_GAME EQU $01
SF_02 EQU $02
SF_PASSIVE_STREAMING_BYTES EQU $03

; --
; -- Sprite Specs
; --
SPRITE_SPEC_HIDDEN EQU $80
SPRITE_SPEC_L_PIECE EQU $00
SPRITE_SPEC_REVERSE_L_PIECE EQU $04
SPRITE_SPEC_STRAIGHT_PIECE EQU $08
SPRITE_SPEC_SQUARE_PIECE EQU $0c
SPRITE_SPEC_Z_PIECE EQU $10
SPRITE_SPEC_REVERSE_Z_PIECE EQU $14
SPRITE_SPEC_POINTY_PIECE EQU $18
SPRITE_SPEC_A_TYPE EQU $1c
SPRITE_SPEC_B_TYPE EQU $1d
SPRITE_SPEC_IDX_0 EQU $20
SPRITE_SPEC_IDX_1 EQU $21
SPRITE_SPEC_STANDING_MARIO EQU $2a
SPRITE_SPEC_SHUTTLE EQU $2c
SPRITE_SPEC_CRYING_LUIGI_1 EQU $32
SPRITE_SPEC_SMALL_LIFTOFF_GAS EQU $34
SPRITE_SPEC_BIG_LIFTOFF_GAS EQU $35
SPRITE_SPEC_STANDING_LUIGI EQU $36
SPRITE_SPEC_BABY_LUIGI_FACING_AWAY EQU $30
SPRITE_SPEC_MARIO_FACING_AWAY EQU $2e
SPRITE_SPEC_LUIGI_FACING_AWAY EQU $3a
SPRITE_SPEC_BABY_MARIO_FACING_AWAY EQU $3c
SPRITE_SPEC_CRYING_MARIO_1 EQU $3e
SPRITE_SPEC_SMALL_TRIPLE_THRUSTER_FIRE EQU $40
SPRITE_SPEC_VIOLINIST_2 EQU $44
SPRITE_SPEC_DOUBLE_BASS_1 EQU $46
SPRITE_SPEC_BELLY_DRUM_1 EQU $48
SPRITE_SPEC_GUITARIST_1 EQU $4a
SPRITE_SPEC_COUPLE_1 EQU $4c
SPRITE_SPEC_CLAPPER_1 EQU $4e
SPRITE_SPEC_JUMPER_1 EQU $50
SPRITE_SPEC_JUMPER_2 EQU $51
SPRITE_SPEC_KICKER_1 EQU $52
SPRITE_SPEC_SWORDSMAN_1 EQU $54
SPRITE_SPEC_SWORDSMAN_2 EQU $55
SPRITE_SPEC_BIG_ROCKET EQU $58
SPRITE_SPEC_MEDIUM_ROCKET EQU $59
SPRITE_SPEC_SMALL_ROCKET EQU $5a
SPRITE_SPEC_THRUSTER EQU $5c
SPRITE_SPEC_THRUSTER_FIRE EQU $5d