\ ******************************************************************************
\
\       Name: ECBLB
\       Type: Subroutine
\   Category: Dashboard
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Light up the E.C.M. indicator bulb ("E") on the dashboard
ELIF _6502SP_VERSION
\    Summary: Implement the #DOBULB 255 command (draw the E.C.M. indicator bulb)
ENDIF
\
IF _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOBULB 255 command. It draws
\ (or erases) the E.C.M. indicator bulb ("E") on the dashboard.
\
ELIF _ELITE_A_6502SP_IO
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a draw_E command. It lights up the
\ E.C.M. indicator bulb ("E") on the dashboard.
\
ENDIF
\ ******************************************************************************

.ECBLB

IF _MASTER_VERSION \ Platform

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ENDIF

IF _CASSETTE_VERSION \ Screen

 LDA #7*8               \ The E.C.M. bulb is in character block number 7
                        \ with each character taking 8 bytes, so this sets the
                        \ low byte of the screen address of the character block
                        \ we want to draw to

 LDX #LO(ECBT)          \ Set (Y X) to point to the character definition in
 LDY #HI(ECBT)          \ ECBT. The LDY has no effect, as we overwrite Y with
                        \ the jump to BULB-2, which writes the high byte of SPBT
                        \ into Y. This works as long as ECBT and SPBT are in
                        \ the same page of memory, so perhaps the BNE below got
                        \ changed from BULB to BULB-2 so they could remove the
                        \ LDY, but for some reason it didn't get culled? Who
                        \ knows...

 BNE BULB-2             \ Jump down to BULB-2 (this BNE is effectively a JMP as
                        \ A will never be zero)

ELIF _ELECTRON_VERSION

 LDA #&98               \ Set A to the low byte of the screen address of the
                        \ E.C.M. bulb (which is at &7C98)

 LDX #LO(ECBT)          \ Set X to the low byte of the address of the character
                        \ definition in ECBT

 LDY #&7C               \ Set Y to the high byte of the screen address of the
                        \ E.C.M. bulb (which is at &7C98)

 BNE BULB               \ Jump down to BULB (this BNE is effectively a JMP as
                        \ A will never be zero)

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 LDA #7*8               \ The E.C.M. bulb is in character block number 7
                        \ with each character taking 8 bytes, so this sets the
                        \ low byte of the screen address of the character block
                        \ we want to draw to

 LDX #LO(ECBT)          \ Set (Y X) to point to the character definition in
                        \ ECBT (we set Y below with the jump to BULB-2, which
                        \ writes the high byte of SPBT into Y

 BNE BULB-2             \ Jump down to BULB-2 (this BNE is effectively a JMP as
                        \ A will never be zero)

ELIF _6502SP_VERSION

 LDA #8*14              \ The E.C.M. bulb is in character block number 14 with
 STA SC                 \ each character taking 8 bytes, so this sets the low
                        \ byte of the screen address of the character block we
                        \ want to draw to

 LDA #&7A               \ Set the high byte of SC(1 0) to &7A, as the bulbs are
 STA SC+1               \ both in the character row from &7A00 to &7BFF, and the
                        \ E.C.M. bulb is in the left half, which is from &7A00
                        \ to &7AFF

 LDY #15                \ Now to poke the bulb bitmap into screen memory, and
                        \ there are two character blocks' worth, each with eight
                        \ lines of one byte, so set a counter in Y for 16 bytes

.BULL2

 LDA ECBT,Y             \ Fetch the Y-th byte of the bulb bitmap

 EOR (SC),Y             \ EOR the byte with the current contents of screen
                        \ memory, so drawing the bulb when it is already
                        \ on-screen will erase it

 STA (SC),Y             \ Store the Y-th byte of the bulb bitmap in screen
                        \ memory

 DEY                    \ Decrement the loop counter

 BPL BULL2              \ Loop back to poke the next byte until we have done
                        \ all 16 bytes across two character blocks

ELIF _MASTER_VERSION

 LDA #8*14              \ The E.C.M. bulb is in character block number 14 with
 STA SC                 \ each character taking 8 bytes, so this sets the low
                        \ byte of the screen address of the character block we
                        \ want to draw to

 LDA #&7A               \ Set the high byte of SC(1 0) to &7A, as the bulbs are
 STA SC+1               \ both in the character row from &7A00 to &7BFF, and the
                        \ E.C.M. bulb is in the left half, which is from &7A00
                        \ to &7AFF

 LDY #15                \ Now to poke the bulb bitmap into screen memory, and
                        \ there are two character blocks' worth, each with eight
                        \ lines of one byte, so set a counter in Y for 16 bytes

.BULL1

 LDA ECBT,Y             \ Fetch the Y-th byte of the bulb bitmap

 EOR (SC),Y             \ EOR the byte with the current contents of screen
                        \ memory, so drawing the bulb when it is already
                        \ on-screen will erase it

 STA (SC),Y             \ Store the Y-th byte of the bulb bitmap in screen
                        \ memory

 DEY                    \ Decrement the loop counter

 BPL BULL1              \ Loop back to poke the next byte until we have done
                        \ all 16 bytes across two character blocks

ELIF _APPLE_VERSION

 LDA #LO(ECBT)          \ Set A to the low byte of the character definition in
                        \ ECBT, to pass to BULB

 LDX #7*8               \ The E.C.M. bulb is in character block number 7
                        \ with each character taking 8 bytes, so this sets X to
                        \ the size of the character block we want to draw ???

 BNE BULB               \ Jump down to BULB (this BNE is effectively a JMP as
                        \ A will never be zero)

ELIF _C64_VERSION

 LDA ECELL              \ EOR the colour byte at ECELL with the colour of the
 EOR #BULBCOL           \ E.C.M. indicator bulb, so this either zeroes the
 STA ECELL              \ character block for the top part of the E.C.M. bulb,
                        \ which will hide it, or it sets it to BULBCOL, which
                        \ will show it (so this toggles the top part of the
                        \ E.C.M. bulb)

 LDA ECELL+40           \ Do the same for the bottom part of the E.C.M. bulb
 EOR #BULBCOL
 STA ECELL+40

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_6502SP_IO

 LDA #7*8               \ The E.C.M. bulb is in character block number 7
                        \ with each character taking 8 bytes, so this sets the
                        \ low byte of the screen address of the character block
                        \ we want to draw to

 LDX #LO(ECBT)          \ Set (Y X) to point to the character definition in
 LDY #HI(ECBT)          \ ECBT

 JMP BULB               \ Jump down to BULB

ENDIF

IF _6502SP_VERSION \ Platform

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ELIF _MASTER_VERSION

 BMI away               \ Jump to away to switch main memory back into
                        \ &3000-&7FFF and return from the subroutine (this BMI
                        \ is effectively a JMP as we just passed through the BPL
                        \ above)

ENDIF

