\ ******************************************************************************
\
\       Name: LL9 (Part 1 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Check if ship is exploding, check if ship is in front
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This routine draws the current ship on the screen. This part checks to see if
\ the ship is exploding, or if it should start exploding, and if it does it sets
\ things up accordingly.
\
IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_VERSION\ Comment
\ It also does some basic checks to see if we can see the ship, and if not it
\ removes it from the screen.
\
ENDIF
\ In this code, XX1 is used to point to the current ship's data block at INWK
\ (the two labels are interchangeable).
\
\ Arguments:
\
\   XX1                 XX1 shares its location with INWK, which contains the
\                       zero-page copy of the data block for this ship from the
\                       K% workspace
\
\   INF                 The address of the data block for this ship in workspace
\                       K%
\
\   XX19(1 0)           XX19(1 0) shares its location with INWK(34 33), which
\                       contains the ship line heap address pointer
\
\   XX0                 The address of the blueprint for this ship
\
IF _6502SP_VERSION \ Comment
\ Returns:
\
\   X                   If NEEDKEY is non-zero, scan the keyboard for a key
\                       press and return the internal key number in X (or 0 for
\                       no key press)
\
ENDIF
\ Other entry points:
\
\   EE51                Remove the current ship from the screen, called from
\                       SHPPT before drawing the ship as a point
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Platform

.LL25

 JMP PLANET             \ Jump to the PLANET routine, returning from the
                        \ subroutine using a tail call

ENDIF

.LL9

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Minor

 LDA TYPE               \ If the ship type is negative then this indicates a
 BMI LL25               \ planet or sun, so jump to PLANET via LL25 above

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX TYPE               \ If the ship type is negative then this indicates a
 BMI LL25               \ planet or sun, so jump to PLANET via LL25 above

ENDIF

IF _6502SP_VERSION \ Screen

 LDA shpcol,X           \ Set A to the ship colour for this type, from the X-th
                        \ entry in the shpcol table

 JSR DOCOL              \ Send a #SETCOL command to the I/O processor to switch
                        \ to this colour

ELIF _MASTER_VERSION

 LDA shpcol,X           \ Set A to the ship colour for this type, from the X-th
                        \ entry in the shpcol table

 STA COL                \ Switch to this colour

ENDIF

 LDA #31                \ Set XX4 = 31 to store the ship's distance for later
 STA XX4                \ comparison with the visibility distance. We will
                        \ update this value below with the actual ship's
                        \ distance if it turns out to be visible on-screen

IF _MASTER_VERSION

                        \ We now set things up for smooth ship plotting, by
                        \ setting the following:
                        \
                        \   XX14 = offset to the first coordinate in the ship's
                        \          line heap
                        \
                        \   XX14+1 = the number of bytes in the heap for the
                        \            ship that's currently on-screen (or 0 if
                        \            there is no ship currently on-screen)

 LDY #1                 \ Set XX14 = 1, the offset of the first set of line
 STY XX14               \ coordinates in the ship line heap

 DEY                    \ Decrement Y to 0

 LDA #%00001000         \ If bit 3 of the ship's byte #31 is set, then the ship
 BIT INWK+31            \ is currently being drawn on-screen, so skip the
 BNE P%+5               \ following two instructions

 LDA #0                 \ The ship is not being drawn on screen, so set A = 0
                        \ so that XX14+1 gets set to 0 below (as there are no
                        \ existing coordinates on the ship line heap for this
                        \ ship)
 
 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C ??? ???, or BIT ???, which does nothing apart
                        \ from affect the flags

 LDA (XX19),Y           \ Set XX14+1 to the first byte of the ship's line heap,
 STA XX14+1             \ which contains the number of bytes in the heap

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Enhanced: The enhanced versions have an extra bit (bit 7 of the NEWB flags) that determines whether a ship has been scooped or has finished docking, at which point they are removed from the screen

 LDA NEWB               \ If bit 7 of the ship's NEWB flags is set, then the
 BMI EE51               \ ship has been scooped or has docked, so jump down to
                        \ EE51 to redraw its wireframe, to remove it from the
                        \ screen

ENDIF

 LDA #%00100000         \ If bit 5 of the ship's byte #31 is set, then the ship
 BIT XX1+31             \ is currently exploding, so jump down to EE28
 BNE EE28

 BPL EE28               \ If bit 7 of the ship's byte #31 is clear then the ship
                        \ has not just been killed, so jump down to EE28

                        \ Otherwise bit 5 is clear and bit 7 is set, so the ship
                        \ is not yet exploding but it has been killed, so we
                        \ need to start an explosion

 ORA XX1+31             \ Clear bits 6 and 7 of the ship's byte #31, to stop the
 AND #%00111111         \ ship from firing its laser and to mark it as no longer
 STA XX1+31             \ having just been killed

 LDA #0                 \ Set the ship's acceleration in byte #31 to 0, updating
 LDY #28                \ the byte in the workspace K% data block so we don't
 STA (INF),Y            \ have to copy it back from INWK later

 LDY #30                \ Set the ship's pitch counter in byte #30 to 0, to stop
 STA (INF),Y            \ the ship from pitching

 JSR EE51               \ Call EE51 to remove the ship from the screen

                        \ We now need to set up a new explosion cloud. We
                        \ initialise it with a size of 18 (which gets increased
                        \ by 4 every time the cloud gets redrawn), and the
                        \ explosion count (i.e. the number of particles in the
                        \ explosion), which go into bytes 1 and 2 of the ship
                        \ line heap. See DOEXP for more details of explosion
                        \ clouds

 LDY #1                 \ Set byte #1 of the ship line heap to 18, the initial
 LDA #18                \ size of the explosion cloud
 STA (XX19),Y

 LDY #7                 \ Fetch byte #7 from the ship's blueprint, which
 LDA (XX0),Y            \ determines the explosion count (i.e. the number of
 LDY #2                 \ vertices used as origins for explosion clouds), and
 STA (XX19),Y           \ store it in byte #2 of the ship line heap

\LDA XX1+32             \ These instructions are commented out in the original
\AND #&7F               \ source

                        \ The following loop sets bytes 3-6 of the of the ship
                        \ line heap to random numbers

.EE55

 INY                    \ Increment Y (so the loop starts at 3)

 JSR DORND              \ Set A and X to random numbers

 STA (XX19),Y           \ Store A in the Y-th byte of the ship line heap

 CPY #6                 \ Loop back until we have randomised the 6th byte
 BNE EE55

.EE28

 LDA XX1+8              \ Set A = z_sign

.EE49

 BPL LL10               \ If A is positive, i.e. the ship is in front of us,
                        \ jump down to LL10

.LL14

                        \ The following removes the ship from the screen by
                        \ redrawing it (or, if it is exploding, by redrawing the
                        \ explosion cloud). We call it when the ship is no
                        \ longer on-screen, is too far away to be fully drawn,
                        \ and so on

 LDA XX1+31             \ If bit 5 of the ship's byte #31 is clear, then the
 AND #%00100000         \ ship is not currently exploding, so jump down to EE51
 BEQ EE51               \ to redraw its wireframe

 LDA XX1+31             \ The ship is exploding, so clear bit 3 of the ship's
 AND #%11110111         \ byte #31 to denote that the ship is no longer being
 STA XX1+31             \ drawn on-screen

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Comment

 JMP DOEXP              \ Jump to DOEXP to display the explosion cloud, which
                        \ will remove it from the screen, returning from the
                        \ subroutine using a tail call

ELIF _DISC_DOCKED

 JMP DOEXP              \ Jump to DOEXP to return from the subroutine using a
                        \ tail call, as in the docked code DOEXP just contains
                        \ an RTS

ENDIF

.EE51

 LDA #%00001000         \ If bit 3 of the ship's byte #31 is clear, then there
 BIT XX1+31             \ is already nothing being shown for this ship, so
 BEQ LL10-1             \ return from the subroutine (as LL10-1 contains an RTS)

 EOR XX1+31             \ Otherwise flip bit 3 of byte #31 and store it (which
 STA XX1+31             \ clears bit 3 as we know it was set before the EOR), so
                        \ this sets this ship as no longer being drawn on-screen

 JMP LL155              \ Jump to LL155 to draw the ship, which removes it from
                        \ the screen, returning from the subroutine using a
                        \ tail call

\LL24                   \ This label is commented out in the original source,
                        \ and was presumably used to label the RTS which is
                        \ actually called by LL10-1 above, not LL24

 RTS                    \ Return from the subroutine

