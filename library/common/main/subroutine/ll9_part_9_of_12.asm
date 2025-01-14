\ ******************************************************************************
\
\       Name: LL9 (Part 9 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Draw laser beams if the ship is firing its laser at us
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ This part sets things up so we can loop through the edges in the next part. It
\ also adds a line to the ship line heap, if the ship is firing at us.
ELIF _NES_VERSION
\ This part sets things up so we can loop through the edges in the next part. It
\ also draws a laser line if the ship is firing at us.
ENDIF
\
\ When we get here, the heap at XX3 contains all the visible vertex screen
\ coordinates.
\
\ ******************************************************************************

.LL72

 LDA XX1+31             \ If bit 5 of the ship's byte #31 is clear, then the
 AND #%00100000         \ ship is not currently exploding, so jump down to EE31
 BEQ EE31

 LDA XX1+31             \ The ship is exploding, so set bit 3 of the ship's byte
 ORA #%00001000         \ #31 to denote that we are drawing something on-screen
 STA XX1+31             \ for this ship

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA)

 JMP DOEXP              \ Jump to DOEXP to display the explosion cloud,
                        \ returning from the subroutine using a tail call

ELIF _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 JMP TT48               \ Jump to TT48 to return from the subroutine using a
                        \ tail call, as TT48 just contains an RTS (it replaces
                        \ a call to DOEXP in the flight code, which we don't
                        \ need to do here as we are docked)

ENDIF

.EE31

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: When drawing a ship, the cassette, disc and 6502SP versions erase the entire on-screen ship before redrawing it, while the Master version erases and redraws each ship one line at a time

 LDA #%00001000         \ If bit 3 of the ship's byte #31 is clear, then there
 BIT XX1+31             \ is nothing already being shown for this ship, so skip
 BEQ LL74               \ to LL74 as we don't need to erase anything from the
                        \ screen

 JSR LL155              \ Otherwise call LL155 to draw the existing ship, which
                        \ removes it from the screen

ELIF _NES_VERSION

 LDA #%00001000         \ If bit 3 of the ship's byte #31 is clear, then there
 BIT XX1+31             \ is nothing already being shown for this ship, so skip
 BEQ LL74               \ to LL74 as we don't need to erase anything from the
                        \ screen

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

 LDY #9                 \ Fetch byte #9 of the ship's blueprint, which is the
 LDA (XX0),Y            \ number of edges, and store it in XX20
 STA XX20

ENDIF

 LDA #%00001000         \ Set bit 3 of A so the next instruction sets bit 3 of
                        \ the ship's byte #31 to denote that we are drawing
                        \ something on-screen for this ship

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Label

.LL74

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Minor

 ORA XX1+31             \ Apply bit 3 of A to the ship's byte #31, so if there
 STA XX1+31             \ was no ship already on screen, the bit is clear,
                        \ otherwise it is set

ELIF _6502SP_VERSION

 TSB XX1+31             \ Apply bit 3 of A to the ship's byte #31, so if there
                        \ was no ship already on screen, the bit is clear,
                        \ otherwise it is set (the TSB instruction applies the
                        \ accumulator to the memory location using an OR)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Platform

 LDY #9                 \ Fetch byte #9 of the ship's blueprint, which is the
 LDA (XX0),Y            \ number of edges, and store it in XX20
 STA XX20

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _NES_VERSION \ Minor

 LDY #0                 \ We are about to step through all the edges, using Y
                        \ as a counter

 STY U                  \ Set U = 0 (though we increment it to 1 below)

 STY XX17               \ Set XX17 = 0, which we are going to use as a counter
                        \ for stepping through the ship's edges

ELIF _6502SP_VERSION

 STZ U                  \ Set U = 0 (though we increment it to 1 below)

 STZ XX17               \ Set XX17 = 0, which we are going to use as a counter
                        \ for stepping through the ship's edges

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDY #0                 \ Set XX17 = 0, which we are going to use as a counter
\STY LSNUM              \ for stepping through the ship's edges
 STY XX17               \
                        \ The STY is commented out in the original source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Platform

 INC U                  \ We are going to start calculating the lines we need to
                        \ draw for this ship, and will store them in the ship
                        \ line heap, using U to point to the end of the heap, so
                        \ we start by setting U = 1

ENDIF

 BIT XX1+31             \ If bit 6 of the ship's byte #31 is clear, then the
 BVC LL170              \ ship is not firing its lasers, so jump to LL170 to
                        \ skip the drawing of laser lines

                        \ The ship is firing its laser at us, so we need to draw
                        \ the laser lines

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Minor

 LDA XX1+31             \ Clear bit 6 of the ship's byte #31 so the ship doesn't
 AND #%10111111         \ keep firing endlessly
 STA XX1+31

ELIF _6502SP_VERSION

 LDA #%01000000         \ Clear bit 6 of the ship's byte #31 so the ship doesn't
 TRB XX1+31             \ keep firing endlessly (the TRB instruction applies the
                        \ inverse of the accumulator, %10111111, to the memory
                        \ location using an AND)

ENDIF

 LDY #6                 \ Fetch byte #6 of the ship's blueprint, which is the
 LDA (XX0),Y            \ number * 4 of the vertex where the ship has its lasers

 TAY                    \ Put the vertex number into Y, where it can act as an
                        \ index into list of vertex screen coordinates we added
                        \ to the XX3 heap

 LDX XX3,Y              \ Fetch the x_lo coordinate of the laser vertex from the
 STX XX15               \ XX3 heap into XX15

 INX                    \ If X = 255 then the laser vertex is not visible, as
 BEQ LL170              \ the value we stored in part 2 wasn't overwritten by
                        \ the vertex calculation in part 6 and 7, so jump to
                        \ LL170 to skip drawing the laser lines

                        \ We now build a laser beam from the ship's laser vertex
                        \ towards our ship, as follows:
                        \
                        \   XX15(1 0) = laser vertex x-coordinate
                        \
                        \   XX15(3 2) = laser vertex y-coordinate
                        \
                        \   XX15(5 4) = x-coordinate of the end of the beam
                        \
                        \   XX12(1 0) = y-coordinate of the end of the beam
                        \
                        \ The end of the laser beam will be positioned to look
                        \ good, rather than being directly aimed at us, as
                        \ otherwise we would only see a flashing point of light
                        \ as they unleashed their attack

 LDX XX3+1,Y            \ Fetch the x_hi coordinate of the laser vertex from the
 STX XX15+1             \ XX3 heap into XX15+1

 INX                    \ If X = 255 then the laser vertex is not visible, as
 BEQ LL170              \ the value we stored in part 2 wasn't overwritten by
                        \ a vertex calculation in part 6 and 7, so jump to LL170
                        \ to skip drawing the laser beam

 LDX XX3+2,Y            \ Fetch the y_lo coordinate of the laser vertex from the
 STX XX15+2             \ XX3 heap into XX15+2

 LDX XX3+3,Y            \ Fetch the y_hi coordinate of the laser vertex from the
 STX XX15+3             \ XX3 heap into XX15+3

 LDA #0                 \ Set XX15(5 4) = 0, so their laser beam fires to the
 STA XX15+4             \ left edge of the screen
 STA XX15+5

 STA XX12+1             \ Set XX12(1 0) = the ship's z_lo coordinate, which will
 LDA XX1+6              \ effectively make the vertical position of the end of
 STA XX12               \ the laser beam move around as the ship moves in space

 LDA XX1+2              \ If the ship's x_sign is positive, skip the next
 BPL P%+4               \ instruction

 DEC XX15+4             \ The ship's x_sign is negative (i.e. it's on the left
                        \ side of the screen), so switch the laser beam so it
                        \ goes to the right edge of the screen by decrementing
                        \ XX15(5 4) to 255

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION \ Label

 JSR LL145              \ Call LL145 to see if the laser beam needs to be
                        \ clipped to fit on-screen, returning the clipped line's
                        \ end-points in (X1, Y1) and (X2, Y2)

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 JSR CLIP               \ Call CLIP to see if the laser beam needs to be
                        \ clipped to fit on-screen, returning the clipped line's
                        \ end-points in (X1, Y1) and (X2, Y2)

ENDIF

IF NOT(_NES_VERSION)

 BCS LL170              \ If the C flag is set then the line is not visible on
                        \ screen, so jump to LL170 so we don't store this line
                        \ in the ship line heap

ELIF _NES_VERSION

 BCS LL170              \ If the C flag is set then the line is not visible on
                        \ screen, so jump to LL170 so we don't draw this line

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION \ Tube

 LDY U                  \ Fetch the ship line heap pointer, which points to the
                        \ next free byte on the heap, into Y

ELIF _NES_VERSION

 LDY U                  \ This instruction is left over from the other versions
                        \ of Elite and has no effect
                        \
                        \ It would fetch the ship line heap pointer from U, but
                        \ the NES version does not have a ship line heap as the
                        \ screen is redrawn for every frame

ELIF _6502SP_VERSION

 LDA U                  \ Fetch the ship line heap pointer, which points to the
                        \ next free byte on the heap, into A

 ADC #3                 \ Set Y = A + 3, so Y now points to the fourth byte in
 TAY                    \ this coordinate

 LDA #255               \ Set the fourth byte to 255 to act as a flag to the I/O
 STA (XX19),Y           \ processor to draw the following line in red, as it is
                        \ a laser (this flag is read and acted on in the ADDBYT
                        \ routine in the I/O processor

 INY                    \ Increment Y to point to the next coordinate block

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: The cassette, disc and 6502SP versions draw the laser lines along with the ships, whereas the Master version erases and draws lines individually, including the laser lines

 LDA XX15               \ Add X1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+1             \ Add Y1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+2             \ Add X2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+3             \ Add Y2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 STY U                  \ Store the updated ship line heap pointer in U

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JSR LSPUT              \ Draw the laser line using flicker-free animation, by
                        \ first drawing the new laser line and then erasing the
                        \ corresponding old line from the screen

ELIF _NES_VERSION

 JSR LOIN               \ Draw the laser line

ENDIF

