\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\       Name: SPBLB
ELIF _6502SP_VERSION
\       Name: DOBULB
ENDIF
\       Type: Subroutine
\   Category: Dashboard
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Light up the space station indicator ("S") on the dashboard
ELIF _6502SP_VERSION
\    Summary: Implement the #DOBULB 0 command (draw the space station indicator
\             bulb)
ENDIF
\
IF _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   away                Switch main memory back into &3000-&7FFF and return from
\                       the subroutine
\
ELIF _6502SP_VERSION
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOBULB 0 command. It draws
\ (or erases) the space station indicator bulb ("S") on the dashboard.
\
ELIF _ELITE_A_6502SP_IO
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a draw_S command. It lights up the
\ space station indicator ("S") on the dashboard.
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

.SPBLB

 LDA #24*8              \ The space station bulb is in character block number 24
                        \ with each character taking 8 bytes, so this sets the
                        \ low byte of the screen address of the character block
                        \ we want to draw to

 LDX #LO(SPBT)          \ Set (Y X) to point to the character definition in SPBT
 LDY #HI(SPBT)

                        \ Fall through into BULB to draw the space station bulb

ELIF _ELECTRON_VERSION

.SPBLB

 LDA #&20               \ Set A to the low byte of the screen address of the
                        \ space station bulb (which is at &7D20)

 LDX #LO(SPBT)          \ Set X to the low byte of the address of the character
                        \ definition in SPBT

 LDY #&7D               \ Set Y to the high byte of the screen address of the
                        \ space station bulb (which is at &7D20)

                        \ Fall through into BULB to draw the space station bulb

ELIF _MASTER_VERSION

.SPBLB

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ELIF _6502SP_VERSION

.DOBULB

 TAX                    \ If the parameter to the #DOBULB command is non-zero,
 BNE ECBLB              \ i.e. this is a #DOBULB 255 command, jump to ECBLB to
                        \ draw the E.C.M. bulb instead

ELIF _C64_VERSION

.SPBLB

 LDA SCELL              \ EOR the colour byte at SCELL with the colour of the
 EOR #BULBCOL           \ space station indicator bulb, so this either zeroes
 STA SCELL              \ the character block for the top part of the space
                        \ station bulb, which will hide it, or it sets it to
                        \ BULBCOL, which will show it (so this toggles the top
                        \ part of the space station bulb)

 LDA SCELL+40           \ Do the same for the bottom part of the space station
 EOR #BULBCOL           \ bulb
 STA SCELL+40

 RTS                    \ Return from the subroutine

ELIF _APPLE_VERSION

.SPBLB

 LDA #LO(SPBT)          \ Set A to the low byte of the address of the character
                        \ definition in SPBT

 LDX #24*8              \ The space station bulb is in character block number 24
                        \ and each character is eight pixels wide, so this sets
                        \ X to the pixel x-coordinate of the bulb we want to
                        \ draw

ENDIF

IF _6502SP_VERSION \ Advanced: The advanced versions have wider "E" and "S" dashboard indicators than the original versions

 LDA #16*8              \ The space station bulb is in character block number 48
 STA SC                 \ (counting from the left edge of the screen), with the
                        \ first half of the row in one page, and the second half
                        \ in another. We want to set the screen address to point
                        \ to the second part of the row, as the bulb is in that
                        \ half, so that's character block number 16 within that
                        \ second half (as the first half takes up 32 character
                        \ blocks, so given that each character block takes up 8
                        \ bytes, this sets the low byte of the screen address
                        \ of the character block we want to draw to

 LDA #&7B               \ Set the high byte of SC(1 0) to &7B, as the bulbs are
 STA SC+1               \ both in the character row from &7A00 to &7BFF, and the
                        \ space station bulb is in the right half, which is from
                        \ &7B00 to &7BFF

 LDY #15                \ Now to poke the bulb bitmap into screen memory, and
                        \ there are two character blocks' worth, each with eight
                        \ lines of one byte, so set a counter in Y for 16 bytes

.BULL

 LDA SPBT,Y             \ Fetch the Y-th byte of the bulb bitmap

 EOR (SC),Y             \ EOR the byte with the current contents of screen
                        \ memory, so drawing the bulb when it is already
                        \ on-screen will erase it

 STA (SC),Y             \ Store the Y-th byte of the bulb bitmap in screen
                        \ memory

 DEY                    \ Decrement the loop counter

 BPL BULL               \ Loop back to poke the next byte until we have done
                        \ all 16 bytes across two character blocks

ELIF _MASTER_VERSION

 LDA #16*8              \ The space station bulb is in character block number 48
 STA SC                 \ (counting from the left edge of the screen), with the
                        \ first half of the row in one page, and the second half
                        \ in another. We want to set the screen address to point
                        \ to the second part of the row, as the bulb is in that
                        \ half, so that's character block number 16 within that
                        \ second half (as the first half takes up 32 character
                        \ blocks, so given that each character block takes up 8
                        \ bytes, this sets the low byte of the screen address
                        \ of the character block we want to draw to

 LDA #&7B               \ Set the high byte of SC(1 0) to &7B, as the bulbs are
 STA SC+1               \ both in the character row from &7A00 to &7BFF, and the
                        \ space station bulb is in the right half, which is from
                        \ &7B00 to &7BFF

 LDY #15                \ Now to poke the bulb bitmap into screen memory, and
                        \ there are two character blocks' worth, each with eight
                        \ lines of one byte, so set a counter in Y for 16 bytes

.BULL2

 LDA SPBT,Y             \ Fetch the Y-th byte of the bulb bitmap

 EOR (SC),Y             \ EOR the byte with the current contents of screen
                        \ memory, so drawing the bulb when it is already
                        \ on-screen will erase it

 STA (SC),Y             \ Store the Y-th byte of the bulb bitmap in screen
                        \ memory

 DEY                    \ Decrement the loop counter

 BPL BULL2              \ Loop back to poke the next byte until we have done
                        \ all 16 bytes across two character blocks

ENDIF

IF _6502SP_VERSION \ Platform

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ELIF _MASTER_VERSION

.away

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 RTS                    \ Return from the subroutine

ENDIF

