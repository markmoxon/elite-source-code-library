\ ******************************************************************************
\
\       Name: equipSprites
\       Type: Variable
\   Category: Equipment
\    Summary: Sprite configuration data for the sprites that show the equipment
\             fitted to our Cobra Mk III on the Equip Ship screen
\
\ ------------------------------------------------------------------------------
\
\ Each equipment sprite is described by four entries in the table, as follows:
\
\   * Byte #0: %vhyyyyyy, where:
\
\       * %v is the vertical flip flag (0 = no flip, 1 = flip vertically)
\
\       * %h is the horizontal flip flag (0 = no flip, 1 = flip horizontally)
\
\       * %yyyyyy is the sprite's tile pattern number, which is added to 140 to
\         give the final pattern number
\
\   * Byte #1: Pixel x-coordinate of the sprite's position on the Cobra Mk III
\
\   * Byte #2: Pixel y-coordinate of the sprite's position on the Cobra Mk III
\
\   * Byte #3: %xxxxxxyy, where:
\
\       * %xxxxxx00 is the offset of the sprite to use in the sprite buffer
\
\       * %yy is the sprite palette (0 to 3)
\
\ ******************************************************************************

.equipSprites

                        \ Equipment sprite 0: E.C.M. (1 of 3)

 EQUB %00011111         \ v = 0, h = 0, tile pattern = 31
 EQUB 85                \ x-coordinate = 85
 EQUB 182 + YPAL        \ y-coordinate = 182
 EQUB %00010100         \ sprite number = 5, sprite palette = 0

                        \ Equipment sprite 1: E.C.M. (2 of 3)

 EQUB %00100000         \ v = 0, h = 0, tile pattern = 32
 EQUB 156               \ x-coordinate = 156
 EQUB 156 + YPAL        \ y-coordinate = 156
 EQUB %00011000         \ sprite number = 6, sprite palette = 0

                        \ Equipment sprite 2: E.C.M. (3 of 3)

 EQUB %00100001         \ v = 0, h = 0, tile pattern = 33
 EQUB 156               \ x-coordinate = 156
 EQUB 164 + YPAL        \ y-coordinate = 164
 EQUB %00011100         \ sprite number = 7, sprite palette = 0

                        \ Equipment sprite 3: Front laser (1 of 2)

 EQUB %00000111         \ v = 0, h = 0, tile pattern = 7
 EQUB 68                \ x-coordinate = 68
 EQUB 161 + YPAL        \ y-coordinate = 161
 EQUB %00100000         \ sprite number = 8, sprite palette = 0

                        \ Equipment sprite 4: Front laser (2 of 2)

 EQUB %00001010         \ v = 0, h = 0, tile pattern = 10
 EQUB 171               \ x-coordinate = 171
 EQUB 172 + YPAL        \ y-coordinate = 172
 EQUB %00100100         \ sprite number = 9, sprite palette = 0

                        \ Equipment sprite 5: Left laser (1 of 2), non-military

 EQUB %00001001         \ v = 0, h = 0, tile pattern = 9
 EQUB 20                \ x-coordinate = 20
 EQUB 198 + YPAL        \ y-coordinate = 198
 EQUB %00101000         \ sprite number = 10, sprite palette = 0

                        \ Equipment sprite 6: Left laser (2 of 2), non-military

 EQUB %00001001         \ v = 0, h = 0, tile pattern = 9
 EQUB 124               \ x-coordinate = 124
 EQUB 170 + YPAL        \ y-coordinate = 170
 EQUB %00101100         \ sprite number = 11, sprite palette = 0

                        \ Equipment sprite 7: Right laser (1 of 2), non-military

 EQUB %01001001         \ v = 0, h = 1, tile pattern = 9
 EQUB 116               \ x-coordinate = 116
 EQUB 198 + YPAL        \ y-coordinate = 198
 EQUB %00110000         \ sprite number = 12, sprite palette = 0

                        \ Equipment sprite 8: Right laser (2 of 2), non-military

 EQUB %01001001         \ v = 0, h = 1, tile pattern = 9
 EQUB 220               \ x-coordinate = 220
 EQUB 170 + YPAL        \ y-coordinate = 170
 EQUB %00110100         \ sprite number = 13, sprite palette = 0

                        \ Equipment sprite 9: Rear laser (1 of 1)

 EQUB %10000111         \ v = 1, h = 0, tile pattern = 7
 EQUB 68                \ x-coordinate = 68
 EQUB 206 + YPAL        \ y-coordinate = 206
 EQUB %01110100         \ sprite number = 29, sprite palette = 0

                        \ Equipment sprite 10: Left military laser (1 of 2)

 EQUB %00010101         \ v = 0, h = 0, tile pattern = 21
 EQUB 16                \ x-coordinate = 16
 EQUB 198 + YPAL        \ y-coordinate = 198
 EQUB %00101000         \ sprite number = 10, sprite palette = 0

                        \ Equipment sprite 11: Left military laser (2 of 2)

 EQUB %00010101         \ v = 0, h = 0, tile pattern = 21
 EQUB 121               \ x-coordinate = 121
 EQUB 170 + YPAL        \ y-coordinate = 170
 EQUB %00101100         \ sprite number = 11, sprite palette = 0

                        \ Equipment sprite 12: Right military laser (1 of 2)

 EQUB %01010101         \ v = 0, h = 1, tile pattern = 21
 EQUB 118               \ x-coordinate = 118
 EQUB 198 + YPAL        \ y-coordinate = 198
 EQUB %00110000         \ sprite number = 12, sprite palette = 0

                        \ Equipment sprite 13: Right military laser (2 of 2)

 EQUB %01010101         \ v = 0, h = 1, tile pattern = 21
 EQUB 222               \ x-coordinate = 222
 EQUB 170 + YPAL        \ y-coordinate = 170
 EQUB %00110100         \ sprite number = 13, sprite palette = 0

                        \ Equipment sprite 14: Fuel scoops (1 of 2)

 EQUB %00011110         \ v = 0, h = 0, tile pattern = 30
 EQUB 167               \ x-coordinate = 167
 EQUB 185 + YPAL        \ y-coordinate = 185
 EQUB %00111101         \ sprite number = 15, sprite palette = 1

                        \ Equipment sprite 15: Fuel scoops (2 of 2)

 EQUB %01011110         \ v = 0, h = 1, tile pattern = 30
 EQUB 175               \ x-coordinate = 175
 EQUB 185 + YPAL        \ y-coordinate = 185
 EQUB %01000001         \ sprite number = 16, sprite palette = 1

                        \ Equipment sprite 16: Naval energy unit (1 of 2)

 EQUB %00011010         \ v = 0, h = 0, tile pattern = 26
 EQUB 79                \ x-coordinate = 79
 EQUB 196 + YPAL        \ y-coordinate = 196
 EQUB %10101100         \ sprite number = 43, sprite palette = 0

                        \ Equipment sprite 17: Naval energy unit (2 of 2)

 EQUB %00011011         \ v = 0, h = 0, tile pattern = 27
 EQUB 79                \ x-coordinate = 79
 EQUB 196 + YPAL        \ y-coordinate = 196
 EQUB %10110001         \ sprite number = 44, sprite palette = 1

                        \ Equipment sprite 18: Standard energy unit (1 of 2)

 EQUB %00011010         \ v = 0, h = 0, tile pattern = 26
 EQUB 56                \ x-coordinate = 56
 EQUB 196 + YPAL        \ y-coordinate = 196
 EQUB %01000100         \ sprite number = 17, sprite palette = 0

                        \ Equipment sprite 19: Standard energy unit (2 of 2)

 EQUB %00011011         \ v = 0, h = 0, tile pattern = 27
 EQUB 56                \ x-coordinate = 56
 EQUB 196 + YPAL        \ y-coordinate = 196
 EQUB %01001001         \ sprite number = 18, sprite palette = 1

                        \ Equipment sprite 20: Missile 1 (1 of 2)

 EQUB %00000000         \ v = 0, h = 0, tile pattern = 0
 EQUB 29                \ x-coordinate = 29
 EQUB 187 + YPAL        \ y-coordinate = 187
 EQUB %01001101         \ sprite number = 19, sprite palette = 1

                        \ Equipment sprite 21: Missile 1 (2 of 2)

 EQUB %00000001         \ v = 0, h = 0, tile pattern = 1
 EQUB 208               \ x-coordinate = 208
 EQUB 176 + YPAL        \ y-coordinate = 176
 EQUB %01010001         \ sprite number = 20, sprite palette = 1

                        \ Equipment sprite 22: Missile 2 (1 of 2)

 EQUB %01000000         \ v = 0, h = 1, tile pattern = 0
 EQUB 108               \ x-coordinate = 108
 EQUB 187 + YPAL        \ y-coordinate = 187
 EQUB %01010101         \ sprite number = 21, sprite palette = 1

                        \ Equipment sprite 23: Missile 2 (2 of 2)

 EQUB %01000001         \ v = 0, h = 1, tile pattern = 1
 EQUB 136               \ x-coordinate = 136
 EQUB 176 + YPAL        \ y-coordinate = 176
 EQUB %01011001         \ sprite number = 22, sprite palette = 1

                        \ Equipment sprite 24: Missile 3 (1 of 2)

 EQUB %00000000         \ v = 0, h = 0, tile pattern = 0
 EQUB 22                \ x-coordinate = 22
 EQUB 192 + YPAL        \ y-coordinate = 192
 EQUB %01011101         \ sprite number = 23, sprite palette = 1

                        \ Equipment sprite 25: Missile 3 (2 of 2)

 EQUB %00000001         \ v = 0, h = 0, tile pattern = 1
 EQUB 214               \ x-coordinate = 214
 EQUB 175 + YPAL        \ y-coordinate = 175
 EQUB %01100001         \ sprite number = 24, sprite palette = 1

                        \ Equipment sprite 26: Missile 4 (1 of 2)

 EQUB %01000000         \ v = 0, h = 1, tile pattern = 0
 EQUB 115               \ x-coordinate = 115
 EQUB 192 + YPAL        \ y-coordinate = 192
 EQUB %01100101         \ sprite number = 25, sprite palette = 1

                        \ Equipment sprite 27: Missile 4 (2 of 2)

 EQUB %01000001         \ v = 0, h = 1, tile pattern = 1
 EQUB 130               \ x-coordinate = 130
 EQUB 175 + YPAL        \ y-coordinate = 175
 EQUB %01101001         \ sprite number = 26, sprite palette = 1

                        \ Equipment sprite 28: Energy bomb (1 of 3)

 EQUB %00010111         \ v = 0, h = 0, tile pattern = 23
 EQUB 64                \ x-coordinate = 64
 EQUB 206 + YPAL        \ y-coordinate = 206
 EQUB %01101100         \ sprite number = 27, sprite palette = 0

                        \ Equipment sprite 29: Energy bomb (2 of 3)

 EQUB %00011000         \ v = 0, h = 0, tile pattern = 24
 EQUB 72                \ x-coordinate = 72
 EQUB 206 + YPAL        \ y-coordinate = 206
 EQUB %01110000         \ sprite number = 28, sprite palette = 0

                        \ Equipment sprite 30: Energy bomb (3 of 3)

 EQUB %00011001         \ v = 0, h = 0, tile pattern = 25
 EQUB 68                \ x-coordinate = 68
 EQUB 206 + YPAL        \ y-coordinate = 206
 EQUB %00111010         \ sprite number = 14, sprite palette = 2

                        \ Equipment sprite 31: Large cargo bay (1 of 2)

 EQUB %00000010         \ v = 0, h = 0, tile pattern = 2
 EQUB 153               \ x-coordinate = 153
 EQUB 184 + YPAL        \ y-coordinate = 184
 EQUB %01111000         \ sprite number = 30, sprite palette = 0

                        \ Equipment sprite 32: Large cargo bay (2 of 2)

 EQUB %01000010         \ v = 0, h = 1, tile pattern = 2
 EQUB 188               \ x-coordinate = 188
 EQUB 184 + YPAL        \ y-coordinate = 184
 EQUB %01111100         \ sprite number = 31, sprite palette = 0

                        \ Equipment sprite 33: Escape pod (1 of 1)

 EQUB %00011100         \ v = 0, h = 0, tile pattern = 28
 EQUB 79                \ x-coordinate = 79
 EQUB 178 + YPAL        \ y-coordinate = 178
 EQUB %10000000         \ sprite number = 32, sprite palette = 0

                        \ Equipment sprite 34: Docking computer (1 of 8)

 EQUB %00000011         \ v = 0, h = 0, tile pattern = 3
 EQUB 52                \ x-coordinate = 52
 EQUB 172 + YPAL        \ y-coordinate = 172
 EQUB %10000100         \ sprite number = 33, sprite palette = 0

                        \ Equipment sprite 35: Docking computer (2 of 8)

 EQUB %00000100         \ v = 0, h = 0, tile pattern = 4
 EQUB 60                \ x-coordinate = 60
 EQUB 172 + YPAL        \ y-coordinate = 172
 EQUB %10001000         \ sprite number = 34, sprite palette = 0

                        \ Equipment sprite 36: Docking computer (3 of 8)

 EQUB %00000101         \ v = 0, h = 0, tile pattern = 5
 EQUB 52                \ x-coordinate = 52
 EQUB 180 + YPAL        \ y-coordinate = 180
 EQUB %10001100         \ sprite number = 35, sprite palette = 0

                        \ Equipment sprite 37: Docking computer (4 of 8)

 EQUB %00000110         \ v = 0, h = 0, tile pattern = 6
 EQUB 60                \ x-coordinate = 60
 EQUB 180 + YPAL        \ y-coordinate = 180
 EQUB %10010000         \ sprite number = 36, sprite palette = 0

                        \ Equipment sprite 38: Docking computer (5 of 8)

 EQUB %01000100         \ v = 0, h = 1, tile pattern = 4
 EQUB 178               \ x-coordinate = 178
 EQUB 156 + YPAL        \ y-coordinate = 156
 EQUB %10010100         \ sprite number = 37, sprite palette = 0

                        \ Equipment sprite 39: Docking computer (6 of 8)

 EQUB %01000011         \ v = 0, h = 1, tile pattern = 3
 EQUB 186               \ x-coordinate = 186
 EQUB 156 + YPAL        \ y-coordinate = 156
 EQUB %10011000         \ sprite number = 38, sprite palette = 0

                        \ Equipment sprite 40: Docking computer (7 of 8)

 EQUB %01000110         \ v = 0, h = 1, tile pattern = 6
 EQUB 178               \ x-coordinate = 178
 EQUB 164 + YPAL        \ y-coordinate = 164
 EQUB %10011100         \ sprite number = 39, sprite palette = 0

                        \ Equipment sprite 41: Docking computer (8 of 8)

 EQUB %01000101         \ v = 0, h = 1, tile pattern = 5
 EQUB 186               \ x-coordinate = 186
 EQUB 164 + YPAL        \ y-coordinate = 164
 EQUB %10100000         \ sprite number = 40, sprite palette = 0

                        \ Equipment sprite 42: Galactic hyperdrive (1 of 2)

 EQUB %00011101         \ v = 0, h = 0, tile pattern = 29
 EQUB 64                \ x-coordinate = 64
 EQUB 190 + YPAL        \ y-coordinate = 190
 EQUB %10100110         \ sprite number = 41, sprite palette = 2

                        \ Equipment sprite 43: Galactic hyperdrive (1 of 2)

 EQUB %01011101         \ v = 0, h = 1, tile pattern = 29
 EQUB 74                \ x-coordinate = 74
 EQUB 190 + YPAL        \ y-coordinate = 190
 EQUB %10101010         \ sprite number = 42, sprite palette = 2

