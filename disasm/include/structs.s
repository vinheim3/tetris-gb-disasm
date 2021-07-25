rsreset
AUD_PointerToAddrContainingSoundData rw 1 ; 0/1
AUD_FramesUntilNextNote rb 1 ; 2
AUD_FramesBetweenEveryNote rb 1 ; 3
AUD_AddressOfSoundData rw 1 ; 4/5
; 3 bytes from SetParam
AUD_AudEnv rb 1 ; 6
AUD_7 rb 1
AUD_AudLen rb 1 ; 8
AUD_Frequency rw 1 ; 9/a
AUD_IsNoEnvelope rb 1 ; b
AUD_c rb 1
AUD_d rb 1
AUD_EnvelopeIndex rb 1 ; e
; bit 7 set when sound effect is taking over
AUD_Control rb 1
AUD_SIZEOF rb

AUD_WavRamAddress EQU AUD_AudEnv
AUD_OutputVolume EQU AUD_AudLen

; AUD_OutputVolume - when bit 7 set, and frames until next == 6, change volume to 50%

rsreset
SPR_SPEC_Hidden rb 1 ; 0
SPR_SPEC_BaseYOffset rb 1 ; 1
SPR_SPEC_BaseXOffset rb 1 ; 2
SPR_SPEC_SpecIdx rb 1 ; 3 - re-used as the current sprite's tile idx
SPR_SPEC_4 rb 1
SPR_SPEC_EntireSpecYXFlipped rb 1 ; 5
SPR_SPEC_BaseXFlip rb 1 ; 6
SPR_SPEC_DISPLAY_ENDOF rb $e-7
SPR_SPEC_ActiveAnimCounter rb 1 ; $e
SPR_SPEC_StartingAnimCounter rb 1 ; $f
SPR_SPEC_SIZEOF rb

rsreset
OAM_Y rb 1 ; 0
OAM_X rb 1 ; 1
OAM_TILE_IDX rb 1 ; 2
OAM_TILE_ATTR rb 1 ; 3
OAM_SIZEOF rb

rsreset
HISCORE_Score1 rb 3 ; BCD
HISCORE_Score2 rb 3 ; BCD
HISCORE_Score3 rb 3 ; BCD
HISCORE_Name1 rb 6
HISCORE_Name2 rb 6
HISCORE_Name3 rb 6
HISCORE_SIZEOF rb

rsreset
LINES_CLEARED_Num rb 1 ; 0
LINES_CLEARED_NumRollingUp rb 1 ; 1
LINES_CLEARED_TotalScore rb 3 ; 2
LINES_CLEARED_SIZEOF rb