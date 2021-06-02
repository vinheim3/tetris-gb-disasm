GameState26_ShuttleSceneInit:
; display rocket scene (and its right metal structure) and left metal structure
    call DisplayRocketScene                                      ; $1167
    ld   hl, _SCRN1+$e6                                          ; $116a
    ld   de, ShuttleMetalStructureLeft                           ; $116d
    ld   b, $07                                                  ; $1170
    call CopyDEintoHLsColumn_Bbytes                              ; $1172

    ld   hl, _SCRN1+$e7                                          ; $1175
    ld   de, ShuttleMetalStructureRight                          ; $1178
    ld   b, $07                                                  ; $117b
    call CopyDEintoHLsColumn_Bbytes                              ; $117d

; platform extensions to rocket
    ld   hl, _SCRN1+$108                                         ; $1180
    ld   [hl], $72                                               ; $1183
    inc  l                                                       ; $1185
    ld   [hl], $c4                                               ; $1186
    ld   hl, _SCRN1+$128                                         ; $1188
    ld   [hl], $b7                                               ; $118b
    inc  l                                                       ; $118d
    ld   [hl], $b8                                               ; $118e

; load spec struct and send to shadow oam
    ld   de, SpriteSpecStruct_ShuttleAndGas                      ; $1190
    ld   hl, wSpriteSpecs                                        ; $1193
    ld   c, $03                                                  ; $1196
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $1198

    ld   a, $03                                                  ; $119b
    call CopyASpriteSpecsToShadowOam                             ; $119d

; turn on lcd with shared window/bg
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_BG9C00|LCDCF_OBJON|LCDCF_BGON ; $11a0
    ldh  [rLCDC], a                                              ; $11a2

; set timer, next state and music
    ld   a, $bb                                                  ; $11a4
    ldh  [hTimer1], a                                            ; $11a6
    ld   a, GS_SHUTTLE_SCENE_SHOW_CLOUDS                         ; $11a8
    ldh  [hGameState], a                                         ; $11aa
    ld   a, MUS_LIFTOFF                                          ; $11ac
    ld   [wSongToStart], a                                       ; $11ae
    ret                                                          ; $11b1


DisplayRocketScene:
; display gfx with lcd off
    call TurnOffLCD                                              ; $11b2
    ld   hl, Gfx_RocketScene                                     ; $11b5
    ld   bc, Gfx_RocketScene.end-Gfx_RocketScene+$160            ; $11b8
    call CopyHLtoVramBCbytes                                     ; $11bb

; displayed on _SCRN1
    ld   hl, _SCRN1+$3ff                                         ; $11be
    call FillScreenFromHLdownWithEmptyTile                       ; $11c1

    ld   hl, _SCRN1+$1c0                                         ; $11c4
    ld   de, Layout_RocketScene                                  ; $11c7
    ld   b, $04                                                  ; $11ca
    call CopyLayoutBrowsToHL                                     ; $11cc

; tall structure next to rocket
    ld   hl, _SCRN1+$ec                                          ; $11cf
    ld   de, RocketMetalStructureLeft                            ; $11d2
    ld   b, $07                                                  ; $11d5
    call CopyDEintoHLsColumn_Bbytes                              ; $11d7

    ld   hl, _SCRN1+$ed                                          ; $11da
    ld   de, RocketMetalStructureRight                           ; $11dd
    ld   b, $07                                                  ; $11e0
    call CopyDEintoHLsColumn_Bbytes                              ; $11e2
    ret                                                          ; $11e5


GameState27_ShuttleSceneShowClouds:
; proceed when timer when reaches 0
    ldh  a, [hTimer1]                                            ; $11e6
    and  a                                                       ; $11e8
    ret  nz                                                      ; $11e9

; set visibility of gas clouds
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden        ; $11ea
    ld   [hl], $00                                               ; $11ed
    ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                    ; $11ef
    ld   [hl], $00                                               ; $11f1

; set timer and next state
    ld   a, $ff                                                  ; $11f3
    ldh  [hTimer1], a                                            ; $11f5
    ld   a, GS_SHUTTLE_SCENE_FLASH_CLOUDS_GET_BIGGER             ; $11f7
    ldh  [hGameState], a                                         ; $11f9
    ret                                                          ; $11fb


GameState28_ShuttleSceneFlashCloudsGetBigger:
; while timer not 0, flash small clouds
    ldh  a, [hTimer1]                                            ; $11fc
    and  a                                                       ; $11fe
    jr   z, .showBiggerClouds                                    ; $11ff

    call ToggleNonRocketSpritesVisibilityEvery10Frames           ; $1201
    ret                                                          ; $1204

.showBiggerClouds:
; set state, and replace clouds with bigger ones
    ld   a, GS_SHUTTLE_SCENE_FLASH_BIG_CLOUDS_REMOVE_PLATFORM    ; $1205
    ldh  [hGameState], a                                         ; $1207
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx       ; $1209
    ld   [hl], SPRITE_SPEC_BIG_LIFTOFF_GAS                       ; $120c
    ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_SpecIdx                   ; $120e
    ld   [hl], SPRITE_SPEC_BIG_LIFTOFF_GAS                       ; $1210

; set timer and clear game screen
    ld   a, $ff                                                  ; $1212
    ldh  [hTimer1], a                                            ; $1214
    ld   a, TILE_EMPTY                                           ; $1216
    call FillGameScreenBufferWithTileAandSetToVramTransfer       ; $1218
    ret                                                          ; $121b


GameState29_ShuttleSceneFlashBigCloudsRemovePlatforms:
; while timer not 0, flash bigger clouds
    ldh  a, [hTimer1]                                            ; $121c
    and  a                                                       ; $121e
    jr   z, .removePlatforms                                     ; $121f

    call ToggleNonRocketSpritesVisibilityEvery10Frames           ; $1221
    ret                                                          ; $1224

.removePlatforms:
; set state
    ld   a, GS_SHUTTLE_SCENE_LIFTOFF                             ; $1225
    ldh  [hGameState], a                                         ; $1227

; clear platforms
    ld   hl, _SCRN1+$108                                         ; $1229
    ld   b, TILE_EMPTY                                           ; $122c
    call StoreBinHLwhenLCDFree                                   ; $122e
    ld   hl, _SCRN1+$109                                         ; $1231
    call StoreBinHLwhenLCDFree                                   ; $1234
    ld   hl, _SCRN1+$128                                         ; $1237
    call StoreBinHLwhenLCDFree                                   ; $123a
    ld   hl, _SCRN1+$129                                         ; $123d
    call StoreBinHLwhenLCDFree                                   ; $1240
    ret                                                          ; $1243


GameState02_ShuttleSceneLiftoff:
; while timer not 0, flash gas
    ldh  a, [hTimer1]                                            ; $1244
    and  a                                                       ; $1246
    jr   nz, .flashNonRocketBits                                 ; $1247

; dec Y of rocket every 10 frames
    ld   a, $0a                                                  ; $1249
    ldh  [hTimer1], a                                            ; $124b

; dec Y until $58 reached
    ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $124d
    dec  [hl]                                                    ; $1250
    ld   a, [hl]                                                 ; $1251
    cp   $58                                                     ; $1252
    jr   nz, .flashNonRocketBits                                 ; $1254

; once $58 reached, make thrusters visible $20 pixels down, X of $4c
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden        ; $1256
    ld   [hl], $00                                               ; $1259
    inc  l                                                       ; $125b
    add  $20                                                     ; $125c
    ld   [hl+], a                                                ; $125e
    ld   [hl], $4c                                               ; $125f
    inc  l                                                       ; $1261
    ld   [hl], SPRITE_SPEC_SMALL_TRIPLE_THRUSTER_FIRE            ; $1262

; make 3rd item invisible, and send all 3 to oam
    ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                    ; $1264
    ld   [hl], $80                                               ; $1266
    ld   a, $03                                                  ; $1268
    call CopyASpriteSpecsToShadowOam                             ; $126a

; set state and play sound
    ld   a, GS_SHUTTLE_SCENE_SHOOT_FIRE                          ; $126d
    ldh  [hGameState], a                                         ; $126f
    ld   a, NOISE_ROCKET_FIRE                                    ; $1271
    ld   [wNoiseSoundToPlay], a                                  ; $1273
    ret                                                          ; $1276

.flashNonRocketBits:
    call ToggleNonRocketSpritesVisibilityEvery10Frames           ; $1277
    ret                                                          ; $127a


GameState03_ShuttleSceneShootFire:
; change fire while timer not 0
    ldh  a, [hTimer1]                                            ; $127b
    and  a                                                       ; $127d
    jr   nz, .checkTimer2                                        ; $127e

; every 10 frames, move rocket up
    ld   a, $0a                                                  ; $1280
    ldh  [hTimer1], a                                            ; $1282
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset   ; $1284
    dec  [hl]                                                    ; $1287
    ld   l, SPR_SPEC_BaseYOffset                                 ; $1288
    dec  [hl]                                                    ; $128a

; change fire while Y not $d0
    ld   a, [hl]                                                 ; $128b
    cp   $d0                                                     ; $128c
    jr   nz, .checkTimer2                                        ; $128e

; set coords of congrats text
    ld   a, HIGH(_SCRN1+$82)                                     ; $1290
    ldh  [hTypedTextCharLoc], a                                  ; $1292
    ld   a, LOW(_SCRN1+$82)                                      ; $1294
    ldh  [hTypedTextCharLoc+1], a                                ; $1296

; set state
    ld   a, GS_SHUTTLE_SCENE_SHOW_CONGRATULATIONS                ; $1298
    ldh  [hGameState], a                                         ; $129a
    ret                                                          ; $129c

.checkTimer2:
    ldh  a, [hTimer2]                                            ; $129d
    and  a                                                       ; $129f
    jr   nz, .sendSpritesToOam                                   ; $12a0

; every 6 frames, change thruster fire size
    ld   a, $06                                                  ; $12a2
    ldh  [hTimer2], a                                            ; $12a4
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx       ; $12a6
    ld   a, [hl]                                                 ; $12a9
    xor  $01                                                     ; $12aa
    ld   [hl], a                                                 ; $12ac

.sendSpritesToOam:
    ld   a, $03                                                  ; $12ad
    call CopyASpriteSpecsToShadowOam                             ; $12af
    ret                                                          ; $12b2


    setcharmap congrats

GameState2c_ShuttleSceneShowCongratulations:
; proceed when timer 0
    ldh  a, [hTimer1]                                            ; $12b3
    and  a                                                       ; $12b5
    ret  nz                                                      ; $12b6

; perform below every 6 frames
    ld   a, $06                                                  ; $12b7
    ldh  [hTimer1], a                                            ; $12b9

; get index of curr char
    ldh  a, [hTypedTextCharLoc+1]                                ; $12bb
    sub  LOW(_SCRN1+$82)                                         ; $12bd
    ld   e, a                                                    ; $12bf
    ld   d, $00                                                  ; $12c0
    ld   hl, .congratsText                                       ; $12c2

; de = addr of char
    add  hl, de                                                  ; $12c5
    push hl                                                      ; $12c6
    pop  de                                                      ; $12c7

; get vram dest in hl
    ldh  a, [hTypedTextCharLoc]                                  ; $12c8
    ld   h, a                                                    ; $12ca
    ldh  a, [hTypedTextCharLoc+1]                                ; $12cb
    ld   l, a                                                    ; $12cd

; store char in dest
    ld   a, [de]                                                 ; $12ce
    call StoreAinHLwhenLCDFree                                   ; $12cf

; get address below tile and store underline there
    push hl                                                      ; $12d2
    ld   de, GB_TILE_WIDTH                                       ; $12d3
    add  hl, de                                                  ; $12d6
    ld   b, "_"                                                  ; $12d7
    call StoreBinHLwhenLCDFree                                   ; $12d9
    pop  hl                                                      ; $12dc

; play sound for every letter shown
    inc  hl                                                      ; $12dd
    ld   a, SND_CONFIRM_OR_LETTER_TYPED                          ; $12de
    ld   [wSquareSoundToPlay], a                                 ; $12e0

; store next char vram dest
    ld   a, h                                                    ; $12e3
    ldh  [hTypedTextCharLoc], a                                  ; $12e4
    ld   a, l                                                    ; $12e6
    ldh  [hTypedTextCharLoc+1], a                                ; $12e7

; set timer and state once at the end
    cp   $82+.end-.congratsText                                  ; $12e9
    ret  nz                                                      ; $12eb

    ld   a, $ff                                                  ; $12ec
    ldh  [hTimer1], a                                            ; $12ee
    ld   a, GS_CONGRATS_WAITING_BEFORE_B_TYPE_SCORE              ; $12f0
    ldh  [hGameState], a                                         ; $12f2
    ret                                                          ; $12f4

.congratsText:
    db "CONGRATULATIONS!"
.end:

    setcharmap new


GameState2d_CongratsWaitingBeforeBTypeScore:
; proceed when timer 0
    ldh  a, [hTimer1]                                            ; $1305
    and  a                                                       ; $1307
    ret  nz                                                      ; $1308

; load gfx with lcd off, and clear tetris rows
    call TurnOffLCD                                              ; $1309
    call LoadAsciiAndMenuScreenGfx                               ; $130c
    call ClearPointersToCompletedTetrisRows                      ; $130f

; turn on lcd and set state
    ld   a, LCDCF_ON|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON         ; $1312
    ldh  [rLCDC], a                                              ; $1314
    ld   a, GS_B_TYPE_LEVEL_FINISHED                             ; $1316
    ldh  [hGameState], a                                         ; $1318
    ret                                                          ; $131a


GameState34_PreRocketSceneWait:
    ldh  a, [hTimer1]                                            ; $131b
    and  a                                                       ; $131d
    ret  nz                                                      ; $131e

    ld   a, GS_ROCKET_SCENE_INIT                                 ; $131f
    ldh  [hGameState], a                                         ; $1321
    ret                                                          ; $1323


GameState2e_RocketSceneInit:
; load gfx and sprite specs (hidden gas for now)
    call DisplayRocketScene                                      ; $1324
    ld   de, SpriteSpecStruct_RocketAndGas                       ; $1327
    ld   hl, wSpriteSpecs                                        ; $132a
    ld   c, $03                                                  ; $132d
    call CopyCSpriteSpecStructsFromDEtoHL                        ; $132f

; override rocket if score < 200,000, then send to shadow oam
    ldh  a, [hATypeRocketSpecIdx]                                ; $1332
    ld   [wSpriteSpecs+SPR_SPEC_SpecIdx], a                      ; $1334
    ld   a, $03                                                  ; $1337
    call CopyASpriteSpecsToShadowOam                             ; $1339

; clear rocket spec idx
    xor  a                                                       ; $133c
    ldh  [hATypeRocketSpecIdx], a                                ; $133d

; bg and window share screen 1
    ld   a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_BG8000|LCDCF_BG9C00|LCDCF_OBJON|LCDCF_BGON ; $133f
    ldh  [rLCDC], a                                              ; $1341

; set timer, next state and music
    ld   a, $bb                                                  ; $1343
    ldh  [hTimer1], a                                            ; $1345
    ld   a, GS_ROCKET_SCENE_SHOW_CLOUDS                          ; $1347
    ldh  [hGameState], a                                         ; $1349
    ld   a, MUS_LIFTOFF                                          ; $134b
    ld   [wSongToStart], a                                       ; $134d
    ret                                                          ; $1350


GameState2f_RocketSceneShowClouds:
; proceed when timer done
    ldh  a, [hTimer1]                                            ; $1351
    and  a                                                       ; $1353
    ret  nz                                                      ; $1354

; make both rocket clouds visible
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden        ; $1355
    ld   [hl], $00                                               ; $1358
    ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                    ; $135a
    ld   [hl], $00                                               ; $135c

; set timer then next game state
    ld   a, $a0                                                  ; $135e
    ldh  [hTimer1], a                                            ; $1360
    ld   a, GS_ROCKET_SCENE_POWERING_UP                          ; $1362
    ldh  [hGameState], a                                         ; $1364
    ret                                                          ; $1366


GameState30_PoweringUp:
; toggle gas visibility until timer done and lifting off
    ldh  a, [hTimer1]                                            ; $1367
    and  a                                                       ; $1369
    jr   z, .liftingOff                                          ; $136a

    call ToggleNonRocketSpritesVisibilityEvery10Frames           ; $136c
    ret                                                          ; $136f

.liftingOff:
; set state, timer, and clear game screen buffer
    ld   a, GS_ROCKET_SCENE_LIFTOFF                              ; $1370
    ldh  [hGameState], a                                         ; $1372
    ld   a, $80                                                  ; $1374
    ldh  [hTimer1], a                                            ; $1376
    ld   a, TILE_EMPTY                                           ; $1378
    call FillGameScreenBufferWithTileAandSetToVramTransfer       ; $137a
    ret                                                          ; $137d


GameState31_RocketSceneLiftOff:
; while timer not 0, toggle visibility of gas clouds, or thrusters+fire
    ldh  a, [hTimer1]                                            ; $137e
    and  a                                                       ; $1380
    jr   nz, .toggleVisibility                                   ; $1381

; timer back at 10
    ld   a, $0a                                                  ; $1383
    ldh  [hTimer1], a                                            ; $1385

; move rocket up until it hits $6a
    ld   hl, wSpriteSpecs+SPR_SPEC_BaseYOffset                   ; $1387
    dec  [hl]                                                    ; $138a
    ld   a, [hl]                                                 ; $138b
    cp   $6a                                                     ; $138c
    jr   nz, .toggleVisibility                                   ; $138e

; once Y at $6a
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden        ; $1390
    ld   [hl], $00                                               ; $1393

; display new sprites at rocket + $10
    inc  l                                                       ; $1395
    add  $10                                                     ; $1396
    ld   [hl+], a                                                ; $1398

; new sprite X and spec idx
    ld   [hl], $54                                               ; $1399
    inc  l                                                       ; $139b
    ld   [hl], SPRITE_SPEC_THRUSTER                              ; $139c

; initially hide fire
    ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                    ; $139e
    ld   [hl], SPRITE_SPEC_HIDDEN                                ; $13a0
    ld   a, $03                                                  ; $13a2
    call CopyASpriteSpecsToShadowOam                             ; $13a4

; set new game state and play sound
    ld   a, GS_ROCKET_SCENE_SHOOT_FIRE                           ; $13a7
    ldh  [hGameState], a                                         ; $13a9

    ld   a, NOISE_ROCKET_FIRE                                    ; $13ab
    ld   [wNoiseSoundToPlay], a                                  ; $13ad
    ret                                                          ; $13b0

.toggleVisibility:
    call ToggleNonRocketSpritesVisibilityEvery10Frames           ; $13b1
    ret                                                          ; $13b4


GameState32_RocketSceneShootFire:
    ldh  a, [hTimer1]                                            ; $13b5
    and  a                                                       ; $13b7
    jr   nz, .checkTimer2                                        ; $13b8

; every 10 frames, decrease thruster and rocket Y
    ld   a, $0a                                                  ; $13ba
    ldh  [hTimer1], a                                            ; $13bc
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_BaseYOffset   ; $13be
    dec  [hl]                                                    ; $13c1
    ld   l, SPR_SPEC_BaseYOffset                                 ; $13c2
    dec  [hl]                                                    ; $13c4

; next state when Y at $e0
    ld   a, [hl]                                                 ; $13c5
    cp   $e0                                                     ; $13c6
    jr   nz, .checkTimer2                                        ; $13c8

    ld   a, GS_ROCKET_SCENE_END                                  ; $13ca
    ldh  [hGameState], a                                         ; $13cc
    ret                                                          ; $13ce

.checkTimer2:
; every 6 frames..
    ldh  a, [hTimer2]                                            ; $13cf
    and  a                                                       ; $13d1
    jr   nz, .copySpecsToOam                                     ; $13d2

    ld   a, $06                                                  ; $13d4
    ldh  [hTimer2], a                                            ; $13d6

; toggle the spec idx between SPRITE_SPEC_THRUSTER and SPRITE_SPEC_THRUSTER_FIRE
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_SpecIdx       ; $13d8
    ld   a, [hl]                                                 ; $13db
    xor  $01                                                     ; $13dc
    ld   [hl], a                                                 ; $13de

.copySpecsToOam:
    ld   a, $03                                                  ; $13df
    call CopyASpriteSpecsToShadowOam                             ; $13e1
    ret                                                          ; $13e4


GameState33_RocketSceneEnd:
; load gfx, clear sounds, and completed rows data
    call TurnOffLCD                                              ; $13e5
    call LoadAsciiAndMenuScreenGfx                               ; $13e8
    call ThunkInitSound                                          ; $13eb
    call ClearPointersToCompletedTetrisRows                      ; $13ee

; turn on lcd and go back to A type selection
    ld   a, LCDCF_ON|LCDCF_BG8000|LCDCF_OBJON|LCDCF_BGON         ; $13f1
    ldh  [rLCDC], a                                              ; $13f3
    ld   a, GS_A_TYPE_SELECTION_INIT                             ; $13f5
    ldh  [hGameState], a                                         ; $13f7
    ret                                                          ; $13f9


ToggleNonRocketSpritesVisibilityEvery10Frames:
; proceed when 2nd timer (used here) is 0
    ldh  a, [hTimer2]                                            ; $13fa
    and  a                                                       ; $13fc
    ret  nz                                                      ; $13fd

; alternate functionality here every 10 frames
    ld   a, $0a                                                  ; $13fe
    ldh  [hTimer2], a                                            ; $1400

; play gas expulsion noise
    ld   a, NOISE_ROCKET_GAS                                     ; $1402
    ld   [wNoiseSoundToPlay], a                                  ; $1404

; for both non-rocket sprites, toggle visibility
    ld   b, $02                                                  ; $1407
    ld   hl, wSpriteSpecs+SPR_SPEC_SIZEOF+SPR_SPEC_Hidden        ; $1409

.nextGas:
    ld   a, [hl]                                                 ; $140c
    xor  SPRITE_SPEC_HIDDEN                                      ; $140d
    ld   [hl], a                                                 ; $140f
    ld   l, SPR_SPEC_SIZEOF*2+SPR_SPEC_Hidden                    ; $1410
    dec  b                                                       ; $1412
    jr   nz, .nextGas                                            ; $1413

; copy rocket and non-rocket sprites to shadow oam
    ld   a, $03                                                  ; $1415
    call CopyASpriteSpecsToShadowOam                             ; $1417
    ret                                                          ; $141a


ShuttleMetalStructureLeft:
    db $c2, $ca, $ca, $ca, $ca, $ca, $ca

ShuttleMetalStructureRight:
    db $c3, $cb, $58, $48, $48, $48, $48


RocketMetalStructureLeft:
    db $c8, $73, $73, $73, $73, $73, $73

RocketMetalStructureRight:
    db $c9, $74, $74, $74, $74, $74, $74


CopyDEintoHLsColumn_Bbytes:
.loop:
    ld   a, [de]                                                 ; $1437
    ld   [hl], a                                                 ; $1438
    inc  de                                                      ; $1439
    push de                                                      ; $143a
    ld   de, GB_TILE_WIDTH                                       ; $143b
    add  hl, de                                                  ; $143e
    pop  de                                                      ; $143f
    dec  b                                                       ; $1440
    jr   nz, .loop                                               ; $1441

    ret                                                          ; $1443
    