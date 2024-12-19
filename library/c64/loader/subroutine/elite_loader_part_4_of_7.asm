\ ******************************************************************************
\
\       Name: Elite loader (Part 4 of 7)
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure the VIC-II for screen memory and sprites
\  Deep dive: The split-screen mode in Commodore 64 Elite
\             Sprite usage in Commodore 64 Elite
\
\ ******************************************************************************

 LDA #&81               \ Set VIC register &18 to set the address of screen RAM
 STA VIC+&18            \ to offset &2000 within the VIC-II bank at &4000 (so
                        \ the screen's colour data is at &6000)

 LDA #0                 \ Set VIC register &20 to set the border colour to the
 STA VIC+&20            \ colour number in bits 0-3 (i.e. colour 0, black)

 LDA #0                 \ Set VIC register &21 to set the background colour to
 STA VIC+&21            \ the colour number in bits 0-3 (i.e. colour 0, black)

 LDA #%00111011         \ Set VIC register &11 to configure the screen control
 STA VIC+&11            \ register as follows:
                        \
                        \   * Bits 0-2 = vertical raster scroll of 3
                        \
                        \   * Bit 3 set = screen height of 25 rows
                        \
                        \   * Bit 4 set = enable screen
                        \
                        \   * Bit 5 set = bitmap mode
                        \
                        \   * Bit 6 clear = extended background mode off
                        \
                        \   * Bit 7 = bit 9 of raster line for interrupt

 LDA #%11000000         \ Set VIC register &11 to configure the screen control
 STA VIC+&16            \ register as follows:
                        \
                        \   * Bits 0-2 = horizontal raster scroll of 0
                        \
                        \   * Bit 3 clear = screen width of 38 columns
                        \
                        \   * Bit 4 clear = standard bitmap mode
                        \
                        \ Bits 6 and 7 don't appear to have any effect, so I'm
                        \ not sure why they are being set

 LDA #%00000000         \ Clear bits 0 to 7 of VIC register &15 to disable all
 STA VIC+&15            \ eight sprites

 LDA #9                 \ Set VIC register &29 to set the colour of sprite 2 to
 STA VIC+&29            \ the colour number in bits 0-3 (i.e. colour 9, brown),
                        \ so this makes Trumble 0 brown

 LDA #12                \ Set VIC register &2A to set the colour of sprite 3 to
 STA VIC+&2A            \ the colour number in bits 0-3 (i.e. colour 12, grey),
                        \ so this makes Trumble 1 grey

 LDA #6                 \ Set VIC register &2B to set the colour of sprite 4 to
 STA VIC+&2B            \ the colour number in bits 0-3 (i.e. colour 6, blue),
                        \ so this makes Trumble 2 blue

 LDA #1                 \ Set VIC register &2C to set the colour of sprite 5 to
 STA VIC+&2C            \ the colour number in bits 0-3 (i.e. colour 1, white),
                        \ so this makes Trumble 3 white

 LDA #5                 \ Set VIC register &2D to set the colour of sprite 6 to
 STA VIC+&2D            \ the colour number in bits 0-3 (i.e. colour 5, green),
                        \ so this makes Trumble 4 green

 LDA #9                 \ Set VIC register &2E to set the colour of sprite 7 to
 STA VIC+&2E            \ the colour number in bits 0-3 (i.e. colour 9, brown),
                        \ so this makes Trumble 5 brown

 LDA #8                 \ Set VIC register &25 to set sprite extra colour 1 to
 STA VIC+&25            \ the colour number in bits 0-3 (i.e. colour 8, orange),
                        \ for the explosion sprite

 LDA #7                 \ Set VIC register &26 to set sprite extra colour 2 to
 STA VIC+&26            \ the colour number in bits 0-3 (i.e. colour 7, yellow),
                        \ for the explosion sprite

 LDA #%00000000         \ Clear bits 0 to 7 of VIC register &1C to set all seven
 STA VIC+&1C            \ sprites to single colour

 LDA #%11111111         \ Set bits 0 to 7 of VIC register &17 to set all seven
 STA VIC+&17            \ sprites to double height

 STA VIC+&1D            \ Set bits 0 to 7 of VIC register &1D to set all seven
                        \ sprites to double width

 LDA #0                 \ Clear bits 0 to 7 of VIC register &10 to zero bit 9 of
 STA VIC+&10            \ the x-coordinate for all seven sprite

 LDX #161               \ Position sprite 0 (the laser sights) at pixel
 LDY #101               \ coordinates (161, 101), in the centre of the space
 STX VIC+0              \ view
 STY VIC+1

 LDA #18                \ Position sprite 1 (the explosion sprite) at pixel
 LDY #12                \ coordinates (18, 12)
 STA VIC+2
 STY VIC+3

 ASL A                  \ Position sprite 2 (Trumble 0) at pixel coordinates
 STA VIC+4              \ (36, 12)
 STY VIC+5

 ASL A                  \ Position sprite 3 (Trumble 1) at pixel coordinates
 STA VIC+6              \ (72, 12)
 STY VIC+7

 ASL A                  \ Position sprite 4 (Trumble 2) at pixel coordinates
 STA VIC+8              \ (144, 12)
 STY VIC+9

 LDA #14                \ Position sprite 5 (Trumble 3) at pixel coordinates
 STA VIC+10             \ (14, 12)
 STY VIC+11

 ASL A                  \ Position sprite 6 (Trumble 4) at pixel coordinates
 STA VIC+12             \ (28, 12)
 STY VIC+13

 ASL A                  \ Position sprite 7 (Trumble 5) at pixel coordinates
 STA VIC+14             \ (56, 12)
 STY VIC+15

 LDA #%00000010         \ Set VIC register &1B to all clear bits apart from bit
 STA VIC+&1B            \ 1, so that:
                        \
                        \   * Sprite 0 (the laser sights) are drawn in front of
                        \     the screen contents
                        \
                        \   * Sprite 1 (the explosion sprite) is drawn in behind
                        \     the screen contents
                        \
                        \   * Sprites 2 to 7 (the Trumble sprites) are drawn in
                        \     front of the screen contents
                        \
                        \ This ensures that when we change views in-game, the
                        \ BLUEBAND routine will hide any part of the explosion
                        \ sprite that's in the screen border area, as it fills
                        \ the border with colour 1

