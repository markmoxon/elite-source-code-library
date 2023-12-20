\ ******************************************************************************
\
\       Name: LOIN (Part 1 of 7)
\       Type: Subroutine
\   Category: Drawing lines
IF NOT(_ELITE_A_6502SP_IO)
\    Summary: Draw a line: Calculate the line gradient in the form of deltas
ELIF _ELITE_A_6502SP_IO
\    Summary: Implement the draw_line command (draw a line)
ENDIF
\  Deep dive: Bresenham's line algorithm
IF _NES_VERSION
\             Drawing lines in the NES version
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF NOT(_ELITE_A_6502SP_IO)
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ This stage calculates the line deltas.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the line
\
\   Y1                  The screen y-coordinate of the start of the line
\
\   X2                  The screen x-coordinate of the end of the line
\
\   Y2                  The screen y-coordinate of the end of the line
\
ELIF _ELITE_A_6502SP_IO
\ This routine is run when the parasite sends a draw_line command. It draws a
\ line from (X1, Y1) to (X2, Y2). It has multiple stages.
\
\ This stage calculates the line deltas.
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LL30                LL30 is a synonym for LOIN and draws a line from
\                       (X1, Y1) to (X2, Y2)
\
ELIF _MASTER_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   LOINQ               Draw a one-segment line from (X1, Y1) to (X2, Y2)
\
ENDIF
\ ******************************************************************************

IF _MASTER_VERSION \ Minor

.HLOIN22

 JMP HLOIN3             \ This instruction doesn't appear to be used anywhere

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

.LL30

 SKIP 0                 \ LL30 is a synonym for LOIN
                        \
ENDIF
IF NOT(_NES_VERSION)
                        \ In the cassette and disc versions of Elite, LL30 and
                        \ LOIN are synonyms for the same routine, presumably
                        \ because the two developers each had their own line
                        \ routines to start with, and then chose one of them for
                        \ the final game
ENDIF
IF _6502SP_VERSION \ Comment
                        \
                        \ In the 6502 Second Processor version, there are three
                        \ different routines. In the parasite, LL30 draws a
                        \ one-segment line, while LOIN draws multi-segment
                        \ lines. Both of these ask the I/O processor to do the
                        \ actual drawing, and it uses a routine called... wait
                        \ for it... LOIN
                        \
                        \ This, then, is the I/O processor's LOIN routine, which
                        \ is not the same as LL30, or the other LOIN. Got that?

ELIF _MASTER_VERSION
                        \
                        \ In the BBC Master version, there are two different
                        \ routines: LOINQ draws a one-segment line, while LOIN
                        \ draws individual segments of multi-segment lines (the
                        \ distinction being that we switch to screen memory at
                        \ the start of LOINQ and back out again after drawing
                        \ the line, while LOIN just draws the line)

ENDIF

IF _ELITE_A_6502SP_IO

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA X1                 \
 JSR tube_get           \   draw_line(x1, y1, x2, y2)
 STA Y1                 \
 JSR tube_get           \ and store them as follows:
 STA X2                 \
 JSR tube_get           \   * X1 = the start point's x-coordinate
 STA Y2                 \
                        \   * Y1 = the start point's y-coordinate
                        \
                        \   * X2 = the end point's x-coordinate
                        \
                        \   * Y2 = the end point's y-coordinate

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _ELITE_A_VERSION OR _NES_VERSION \ Label

.LOIN

ELIF _MASTER_VERSION

.LOINQ

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _NES_VERSION \ Platform

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

ENDIF

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA #128               \ Set S = 128, which is the starting point for the
 STA S                  \ slope error (representing half a pixel)

IF _ELECTRON_VERSION \ Screen

 STA SC                 \ Set SC = 128 for use in the pixel calculations below

ENDIF

 ASL A                  \ Set SWAP = 0, as %10000000 << 1 = 0
 STA SWAP

 LDA X2                 \ Set A = X2 - X1
 SBC X1                 \       = delta_x
                        \
                        \ This subtraction works as the ASL A above sets the C
                        \ flag

 BCS LI1                \ If X2 > X1 then A is already positive and we can skip
                        \ the next three instructions

 EOR #%11111111         \ Negate the result in A by flipping all the bits and
 ADC #1                 \ adding 1, i.e. using two's complement to make it
                        \ positive

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 SEC                    \ Set the C flag, ready for the subtraction below

ENDIF

.LI1

 STA P                  \ Store A in P, so P = |X2 - X1|, or |delta_x|

IF _ELECTRON_VERSION OR _NES_VERSION \ Minor

 SEC                    \ Set the C flag, ready for the subtraction below

ENDIF

 LDA Y2                 \ Set A = Y2 - Y1
 SBC Y1                 \       = delta_y
                        \
                        \ This subtraction works as we either set the C flag
                        \ above, or we skipped that SEC instruction with a BCS

IF _6502SP_VERSION \ Platform

 BEQ HLOIN2             \ If A = 0 then Y1 = Y2, which means the line is
                        \ horizontal, so jump to HLOIN2 to draw a horizontal
                        \ line instead of applying Bresenham's line algorithm

ELIF _MASTER_VERSION

\BEQ HLOIN22            \ This instruction is commented out in the original
                        \ source

ENDIF

 BCS LI2                \ If Y2 > Y1 then A is already positive and we can skip
                        \ the next two instructions

 EOR #%11111111         \ Negate the result in A by flipping all the bits and
 ADC #1                 \ adding 1, i.e. using two's complement to make it
                        \ positive

.LI2

 STA Q                  \ Store A in Q, so Q = |Y2 - Y1|, or |delta_y|

 CMP P                  \ If Q < P, jump to STPX to step along the x-axis, as
 BCC STPX               \ the line is closer to being horizontal than vertical

 JMP STPY               \ Otherwise Q >= P so jump to STPY to step along the
                        \ y-axis, as the line is closer to being vertical than
                        \ horizontal

