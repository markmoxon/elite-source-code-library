\ ******************************************************************************
\
\       Name: Elite loader (Part 6 of 7)
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy colour data into colour RAM and configure more screen RAM
\  Deep dive: Colouring the Commodore 64 bitmap screen
\
\ ******************************************************************************

                        \ First we reset the contents of colour RAM, which we
                        \ use to determine the colour of the dashboard (along
                        \ with the space view's screen RAM, which we already
                        \ set up in part 5)

 LDA #0                 \ Set A = 0, so we can use this to zero the contents of
                        \ colour RAM

 STA ZP                 \ Zero the low byte of ZP(1 0)

 TAY                    \ Set Y = 0 to use as a byte counter in the following
                        \ loop

 LDX #HI(COLMEM)        \ Set ZP(1 0) = COLMEM
 STX ZP+1               \
                        \ So ZP(1 0) points to colour RAM at COLMEM (&D800)

 LDX #4                 \ Set X = 4 so we zero all four pages of colour RAM

.LOOP19

 STA (ZP),Y             \ Zero the Y-th byte of colour RAM at SC(1 0)

 INY                    \ Increment the byte counter

 BNE LOOP19             \ Loop back until we have zeroed a whole page of
                        \ colour RAM

 INC ZP+1               \ Increment the high byte of ZP(1 0) to point to the
                        \ next page to zero

 DEX                    \ Decrement the page counter in X

 BNE LOOP19             \ Loop back until we have zeroed all four pages from
                        \ COLMEM to COLMEM + &3FF (&D800 to &DBFF)

 LDA #LO(COLMEM+&2D0)   \ Set ZP(1 0) to the address within the space view's
 STA ZP                 \ colour RAM that corresponds to the dashboard (i.e.
 LDA #HI(COLMEM+&2D0)   \ offset &2D0 within the colour RAM at COLMEM, or &DAD0)
 STA ZP+1

 LDA #LO(cdump)         \ Set (A ZP2) = cdump
 STA ZP2
 LDA #HI(cdump)

 JSR mvsm               \ Call mvsm to copy 280 bytes of data from cdump to the
                        \ dashboard's colour RAM for the space view, so this
                        \ sets the correct colour data for the dashboard (along
                        \ with the data that we already copied into screen RAM
                        \ in part 5)

                        \ Finally, we set the top row of colour RAM to yellow,
                        \ so the top of the border box in the space view is
                        \ shown in the correct colour in the event of the raster
                        \ interrupt firing slightly late
                        \
                        \ To ensure we don't get a flicker effect on the top row
                        \ of the screen, we set colour RAM for the top row to
                        \ &07, which sets colour %11 in the multicolour bitmap
                        \ mode to colour 7 (yellow)
                        \
                        \ The top border is drawn with bytes of %11111111, which
                        \ maps to pixels of colour %11, so this ensures that if
                        \ the switch to standard bitmap mode at the top of the
                        \ screen is delayed (by non-maskable interrupts, for
                        \ example), the VIC will fetch the colour of the top
                        \ border box from colour RAM, so the colour will still
                        \ be correct

 LDY #34                \ Set Y to a character counter so we set colour RAM for
                        \ characters 3 to 36 on the top row

 LDA #&07               \ Set the low nibble of A to colour 7 (yellow), as this
                        \ is where multicolour bitmap mode gets the palette for
                        \ colour %11

.LOOP15

 STA COLMEM+2,Y         \ Set the palette to yellow for character Y

 DEY                    \ Decrement the counter in Y

 BNE LOOP15             \ Loop back until we have set the correct colour for the
                        \ whole top row of the space view

