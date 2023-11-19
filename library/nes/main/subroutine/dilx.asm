\ ******************************************************************************
\
\       Name: DILX
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update a bar-based indicator on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ The range of values shown on the indicator depends on which entry point is
\ called. For the default entry point of DILX, the range is 0-255 (as the value
\ passed in A is one byte). The other entry points are shown below.
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ Arguments:
\
\   A                   The value to be shown on the indicator (so the larger
\                       the value, the longer the bar)
\
\   SC(1 0)             The address of the tile at the left end of the indicator
\                       in nametable buffer 0
\
\   K                   The lower end of the safe range, so safe values are in
\                       the range K <= A < K+1 (and other values are dangerous)
\
\   K+1                 The upper end of the safe range, so safe values are in
\                       the range K <= A < K+1 (and other values are dangerous)
\
\ Returns:
\
\   SC(1 0)             The address of the tile at the left end of the next
\                       indicator down
\
\ Other entry points:
\
\   DILX+2              The range of the indicator is 0-64 (for the fuel and
\                       speed indicators)
\
\ ******************************************************************************

.DILX

 LSR A                  \ If we call DILX, we set A = A / 16, so A is 0-31
 LSR A

 LSR A                  \ If we call DILX+2, we set A = A / 4, so A is 0-31

 CMP #31                \ If A < 31 then jump to dilx1 to skip the following
 BCC dilx1              \ instruction

 LDA #30                \ Set A = 30, so the maximum value of the value to show
                        \ on the indicator in A is 30

.dilx1

 LDY #0                 \ We are going to draw the indicator as a row of tiles,
                        \ so set an index in Y to count the tiles as we work
                        \ from left to right

 CMP K                  \ If A < K then this value is lower than the lower end
 BCC dilx8              \ of the safe range, so jump to dilx8 to flash the
                        \ indicator bar between colour 4 and colour 2, to
                        \ indicate a dangerous value

 CMP K+1                \ If A >= K+1 then this value is higher than the upper
 BCS dilx8              \ end of the safe range, so jump to dilx8 to draw the
                        \ indicator bar between colour 4 and colour 2, to
                        \ indicate a dangerous value

 STA Q                  \ Store the value we want to draw on the indicator in Q

.dilx2

 LSR A                  \ Set A = A / 8
 LSR A                  \
 LSR A                  \ Each indicator consists of four tiles that we use to
                        \ show a value from 0 to 30, so this gives us the number
                        \ of sections we need to fill with a full bar (in the
                        \ range 0 to 3, as A is in the range 0 to 30)

 BEQ dilx4              \ If the result is 0 then the value is too low to need
                        \ any full bars, so jump to dilx4 to draw the end cap of
                        \ the indicator bar and any blank space to the right

 TAX                    \ Set X to the number of sections that we need to fill
                        \ with a full bar, so we can use it as a loop counter to
                        \ draw the correct number of full bars

 LDA #236               \ Set A = 236, which is the pattern number of the fully
                        \ filled bar in colour 4 (for a safe value)

.dilx3

 STA (SC),Y             \ Set the Y-th tile of the indicator to A to show a full
                        \ bar

 INY                    \ Increment the tile number in Y to move to the next
                        \ tile in the indicator

 DEX                    \ Decrement the loop counter in X

 BNE dilx3              \ Loop back until we have drawn the correct number of
                        \ full bars

.dilx4

                        \ We now draw the correct end cap on the right end of
                        \ the indicator bar

 LDA Q                  \ Set A to the value we want to draw on the indicator,
                        \ which we stored in Q above

 AND #7                 \ Set A = A mod 8, which gives us the remaining value
                        \ once we've taken off any fully filled tiles (as each
                        \ of the four tiles that make up the indicator
                        \ represents a value of 8)

 CLC                    \ Set A = A + 237
 ADC #237               \
                        \ The eight patterns from 237 to 244 contain the end cap
                        \ patterns in colour 4 (for a safe value), ranging
                        \ from the smallest cap to the largest, so this sets A
                        \ to the correct pattern number to use as the end cap
                        \ for displaying the remainder in A

 STA (SC),Y             \ Set the Y-th tile of the indicator to A to show the
                        \ end cap

 INY                    \ Increment the tile number in Y to move to the next
                        \ tile in the indicator

                        \ We now fill the rest of the four tiles with a blank
                        \ indicator tile, if required

 LDA #85                \ Set A = 85, which is the pattern number of an empty
                        \ tile in an indicator

.dilx5

 CPY #4                 \ If Y = 4 then we have just drawn the last tile in
 BEQ dilx6              \ the indicator, so jump to dilx6 to finish off, as we
                        \ have now drawn the entire indicator

 STA (SC),Y             \ Otherwise set the Y-th tile of the indicator to A to
                        \ fill the space to the right of the indicator bar with
                        \ the blank indicator pattern

 INY                    \ Increment the tile number in Y to move to the next
                        \ tile in the indicator

 BNE dilx5              \ Loop back to dilx5 to draw the next tile (this BNE is
                        \ effectively a JMP as Y won't ever wrap around to 0)

.dilx6

 LDA SC                 \ Set SC(1 0) = SC(1 0) + 32
 CLC                    \
 ADC #32                \ Starting with the low bytes
 STA SC

 BCC dilx7              \ And then the high bytes
 INC SC+1               \
                        \ This points SC(1 0) to the nametable entry for the
                        \ next indicator on the row below, as there are 32 tiles
                        \ in each row

.dilx7

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS                    \ Return from the subroutine

.dilx8

 STA Q                  \ Store the value we want to draw on the indicator in Q

 LDA MCNT               \ Fetch the main loop counter and jump to dilx10 if bit
 AND #%00001000         \ 3 is set, which will be true half of the time, with
 BNE dilx10             \ the bit being 0 for eight iterations around the main
                        \ loop, and 1 for the next eight iterations
                        \
                        \ If we jump to dilx10 then the indicator is shown in
                        \ red, and if we don't jump it is shown in the normal
                        \ colour, so this flashes the indicator bar between red
                        \ and the normal colour, changing the colour every eight
                        \ iterations of the main loop

 LDA Q                  \ Set A to the value we want to draw on the indicator,
                        \ which we stored in Q above

 JMP dilx2              \ Jump back to dilx2 to draw the indicator in the normal
                        \ colour scheme

 LDY #0                 \ These instructions are never run and have no effect
 BEQ dilx13

.dilx10

                        \ If we get here then we show the indicator in red

 LDA Q                  \ Set A to the value we want to draw on the indicator,
                        \ which we stored in Q above

 LSR A                  \ Set A = A / 8
 LSR A                  \
 LSR A                  \ Each indicator consists of four tiles that we use to
                        \ show a value from 0 to 30, so this gives us the number
                        \ of sections we need to fill with a full bar (in the
                        \ range 0 to 3, as A is in the range 0 to 30)

 BEQ dilx12             \ If the result is 0 then the value is too low to need
                        \ any full bars, so jump to dilx12 to draw the end cap
                        \ of the indicator bar and any blank space to the right

 TAX                    \ Set X to the number of sections that we need to fill
                        \ with a full bar, so we can use it as a loop counter to
                        \ draw the correct number of full bars

 LDA #227               \ Set A = 237, which is the pattern number of the fully
                        \ filled bar in colour 2 (for a dangerous value)

.dilx11

 STA (SC),Y             \ Set the Y-th tile of the indicator to A to show a full
                        \ bar

 INY                    \ Increment the tile number in Y to move to the next
                        \ tile in the indicator

 DEX                    \ Decrement the loop counter in X

 BNE dilx11             \ Loop back until we have drawn the correct number of
                        \ full bars

.dilx12

                        \ We now draw the correct end cap on the right end of
                        \ the indicator bar

 LDA Q                  \ Set A to the value we want to draw on the indicator,
                        \ which we stored in Q above

 AND #7                 \ Set A = A mod 8, which gives us the remaining value
                        \ once we've taken off any fully filled tiles (as each
                        \ of the four tiles that make up the indicator
                        \ represents a value of 8)

 CLC                    \ Set A = A + 228
 ADC #228               \
                        \ The eight patterns from 228 to 235 contain the end cap
                        \ patterns in colour 2 (for a dangerous value), ranging
                        \ from the smallest cap to the largest, so this sets A
                        \ to the correct pattern number to use as the end cap
                        \ for displaying the remainder in A

 STA (SC),Y             \ Set the Y-th tile of the indicator to A to show the
                        \ end cap

 INY                    \ Increment the tile number in Y to move to the next
                        \ tile in the indicator

.dilx13

                        \ We now fill the rest of the four tiles with a blank
                        \ indicator tile, if required

 LDA #85                \ Set A = 85, which is the pattern number of an empty
                        \ tile in an indicator

.dilx14

 CPY #4                 \ If Y = 4 then we have just drawn the last tile in
 BEQ dilx15             \ the indicator, so jump to dilx6 to finish off, as we
                        \ have now drawn the entire indicator

 STA (SC),Y             \ Otherwise set the Y-th tile of the indicator to A to
                        \ fill the space to the right of the indicator bar with
                        \ the blank indicator pattern

 INY                    \ Increment the tile number in Y to move to the next
                        \ tile in the indicator

 BNE dilx14             \ Loop back to dilx14 to draw the next tile (this BNE is
                        \ effectively a JMP as Y won't ever wrap around to 0)

.dilx15

 LDA SC                 \ Set SC(1 0) = SC(1 0) + 32
 CLC                    \
 ADC #32                \ Starting with the low bytes
 STA SC

 BCC dilx16             \ And then the high bytes
 INC SC+1               \
                        \ This points SC(1 0) to the nametable entry for the
                        \ next indicator on the row below, as there are 32 tiles
                        \ in each row

.dilx16

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS                    \ Return from the subroutine

