\ ******************************************************************************
\
\       Name: LL9 (Part 10 of 12)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the visibility of each of the ship's edges
IF _MASTER_VERSION \ Comment
\             and draw the visible ones using flicker-free animation
ENDIF
\  Deep dive: Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ This part calculates which edges are visible - in other words, which lines we
\ should draw - and clips them to fit on the screen.
\
IF _MASTER_VERSION \ Comment
\ Visible edges are drawn using flicker-free animation, which erases the
\ corresponding edge from the on-scren ship at the same time.
\
ENDIF
\ When we get here, the heap at XX3 contains all the visible vertex screen
\ coordinates.
\
\ ******************************************************************************

.LL170

 LDY #3                 \ Fetch byte #3 of the ship's blueprint, which contains
 CLC                    \ the low byte of the offset to the edges data
 LDA (XX0),Y

 ADC XX0                \ Set V = low byte edges offset + XX0
 STA V

 LDY #16                \ Fetch byte #16 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the high byte of the offset to the edges data

 ADC XX0+1              \ Set V+1 = high byte edges offset + XX0+1
 STA V+1                \
                        \ So V(1 0) now points to the start of the edges data
                        \ for this ship

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Minor

 LDY #5                 \ Fetch byte #5 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the maximum heap size for plotting the ship (which is
 STA T1                 \ 1 + 4 * the maximum number of visible edges) and store
                        \ it in T1

 LDY XX17               \ Set Y to the edge counter in XX17

ELIF _MASTER_VERSION

 LDY #5                 \ Fetch byte #5 of the ship's blueprint, which contains
 LDA (XX0),Y            \ the maximum heap size for plotting the ship (which is
 STA CNT                \ 1 + 4 * the maximum number of visible edges) and store
                        \ it in CNT

ENDIF

.LL75

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF _MASTER_VERSION \ Platform

 LDY #0                 \ Set Y = 0 so we start with byte #0

ENDIF

 LDA (V),Y              \ Fetch byte #0 for this edge, which contains the
                        \ visibility distance for this edge, beyond which the
                        \ edge is not shown

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 CMP XX4                \ If XX4 > the visibility distance, where XX4 contains
 BCC LL78               \ the ship's z-distance reduced to 0-31 (which we set in
                        \ part 2), then this edge is too far away to be visible,
                        \ so jump down to LL78 to move on to the next edge

ELIF _DISC_VERSION OR _ELITE_A_VERSION OR _NES_VERSION

 CMP XX4                \ If XX4 > the visibility distance, where XX4 contains
 BCC LL79-3             \ the ship's z-distance reduced to 0-31 (which we set in
                        \ part 2), then this edge is too far away to be visible,
                        \ so jump down to LL78 (via LL79-3) to move on to the
                        \ next edge

ENDIF

 INY                    \ Increment Y to point to byte #1

 LDA (V),Y              \ Fetch byte #1 for this edge into A, so:
                        \
                        \   A = %ffff ffff, where:
                        \
                        \     * Bits 0-3 = the number of face 1
                        \
                        \     * Bits 4-7 = the number of face 2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Platform

 INY                    \ Increment Y to point to byte #2

ENDIF

 STA P                  \ Store byte #1 into P

 AND #%00001111         \ Extract the number of face 1 into X
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL79               \ face 1 is visible, so jump to LL79

 LDA P                  \ Fetch byte #1 for this edge into A

 LSR A                  \ Shift right four times to extract the number of face 2
 LSR A                  \ from bits 4-7 into X
 LSR A
 LSR A
 TAX

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 LDA XX2,X              \ If XX2+X is zero then we decided in part 5 that
 BEQ LL78               \ face 2 is hidden, so jump to LL78

ELIF _DISC_VERSION OR _ELITE_A_VERSION OR _NES_VERSION

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL79               \ face 2 is visible, so skip the following instruction

 JMP LL78               \ Face 2 is hidden, so jump to LL78

ENDIF

.LL79

                        \ We now build the screen line for this edge, as
                        \ follows:
                        \
                        \   XX15(1 0) = start x-coordinate
                        \
                        \   XX15(3 2) = start y-coordinate
                        \
                        \   XX15(5 4) = end x-coordinate
                        \
                        \   XX12(1 0) = end y-coordinate
                        \
                        \ We can then pass this to the line clipping routine
                        \ before storing the resulting line in the ship line
                        \ heap

IF _MASTER_VERSION \ Platform

 INY                    \ Increment Y to point to byte #2

ENDIF

 LDA (V),Y              \ Fetch byte #2 for this edge into X, which contains
 TAX                    \ the number of the vertex at the start of the edge

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Platform

 INY                    \ Increment Y to point to byte #3

 LDA (V),Y              \ Fetch byte #3 for this edge into Q, which contains
 STA Q                  \ the number of the vertex at the end of the edge

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Minor

 LDA XX3+1,X            \ Fetch the x_hi coordinate of the edge's start vertex
 STA XX15+1             \ from the XX3 heap into XX15+1

 LDA XX3,X              \ Fetch the x_lo coordinate of the edge's start vertex
 STA XX15               \ from the XX3 heap into XX15

ELIF _MASTER_VERSION

 LDA XX3,X              \ Fetch the x_lo coordinate of the edge's start vertex
 STA XX15               \ from the XX3 heap into XX15

 LDA XX3+1,X            \ Fetch the x_hi coordinate of the edge's start vertex
 STA XX15+1             \ from the XX3 heap into XX15+1

ENDIF

 LDA XX3+2,X            \ Fetch the y_lo coordinate of the edge's start vertex
 STA XX15+2             \ from the XX3 heap into XX15+2

 LDA XX3+3,X            \ Fetch the y_hi coordinate of the edge's start vertex
 STA XX15+3             \ from the XX3 heap into XX15+3

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Platform

 LDX Q                  \ Set X to the number of the vertex at the end of the
                        \ edge, which we stored in Q

ELIF _MASTER_VERSION

 INY                    \ Increment Y to point to byte #3

 LDA (V),Y              \ Fetch byte #3 for this edge into X, which contains
 TAX                    \ the number of the vertex at the end of the edge

ENDIF

 LDA XX3,X              \ Fetch the x_lo coordinate of the edge's end vertex
 STA XX15+4             \ from the XX3 heap into XX15+4

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Minor

 LDA XX3+3,X            \ Fetch the y_hi coordinate of the edge's end vertex
 STA XX12+1             \ from the XX3 heap into XX11+1

 LDA XX3+2,X            \ Fetch the y_lo coordinate of the edge's end vertex
 STA XX12               \ from the XX3 heap into XX12

ELIF _MASTER_VERSION

 LDA XX3+2,X            \ Fetch the y_lo coordinate of the edge's end vertex
 STA XX12               \ from the XX3 heap into XX12

 LDA XX3+3,X            \ Fetch the y_hi coordinate of the edge's end vertex
 STA XX12+1             \ from the XX3 heap into XX11+1

ENDIF

 LDA XX3+1,X            \ Fetch the x_hi coordinate of the edge's end vertex
 STA XX15+5             \ from the XX3 heap into XX15+5

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

 JSR LL147              \ Call LL147 to see if the new line segment needs to be
                        \ clipped to fit on-screen, returning the clipped line's
                        \ end-points in (X1, Y1) and (X2, Y2)

ELIF _MASTER_VERSION OR _NES_VERSION

 JSR CLIP2              \ Call CLIP2 to see if the new line segment needs to be
                        \ clipped to fit on-screen, returning the clipped line's
                        \ end-points in (X1, Y1) and (X2, Y2)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 BCS LL78               \ If the C flag is set then the line is not visible on
                        \ screen, so jump to LL78 so we don't store this line
                        \ in the ship line heap

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 BCS LL79-3             \ If the C flag is set then the line is not visible on
                        \ screen, so jump to LL78 (via LL79-3) so we don't store
                        \ this line in the ship line heap

 JMP LL80               \ Jump down to part 11 to draw this edge

ELIF _NES_VERSION

 BCS LL79-3             \ If the C flag is set then the line is not visible on
                        \ screen, so jump to LL78 (via LL79-3) so we don't store
                        \ this line in the ship line heap

 JSR LOIN               \ Draw this edge

 JMP LL78               \ Jump down to part 11 to skip to the next edge

ENDIF

IF _MASTER_VERSION \ Master: The Master implements flicker-free ship drawing using the LSPUT routine, which manages the erasing and drawing of individual lines

 JSR LSPUT              \ Draw this edge using flicker-free animation, by first
                        \ drawing the ship's new line and then erasing the
                        \ corresponding old line from the screen

ENDIF

