\ ******************************************************************************
\
\       Name: LOIN (Part 1 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line: Calculate the line gradient in the form of deltas
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ This stage calculates the line deltas.
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
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
\ Returns:
\
\   Y                   Y is preserved
\
\ Other entry points:
\
\   LL30                LL30 is a synonym for LOIN and draws a line from
\                       (X1, Y1) to (X2, Y2)
\
\   HL6                 Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _MASTER_VERSION \ Minor

 JMP HLOIN3             \ This instruction doesn't appear to be used anywhere

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Label

.LL30

 SKIP 0                 \ LL30 is a synomym for LOIN
                        \
ENDIF
                        \ In the cassette and disc versions of Elite, LL30 and
                        \ LOIN are synonyms for the same routine, presumably
                        \ because the two developers each had their own line
                        \ routines to start with, and then chose one of them for
                        \ the final game
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
                        \ routines: LL30 draws a one-segment line, while LOIN
                        \ draws multi-segment lines

ENDIF

.LOIN

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Platform

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

ENDIF

 LDA #128               \ Set S = 128, which is the starting point for the
 STA S                  \ slope error (representing half a pixel)

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

 SEC                    \ Set the C flag, ready for the subtraction below

.LI1

 STA P                  \ Store A in P, so P = |X2 - X1|, or |delta_x|

 LDA Y2                 \ Set A = Y2 - Y1
 SBC Y1                 \       = delta_y
                        \
                        \ This subtraction works as we either set the C flag
                        \ above, or we skipped that SEC instruction with a BCS

IF _6502SP_VERSION \ Platform

 BEQ HLOIN2             \ If A = 0 then Y1 = Y2, which means the line is
                        \ horizontal, so jump to HLOIN2 to draw a horizontal
                        \ line instead of applying Bresenham's line algorithm

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

