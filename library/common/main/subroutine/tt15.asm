\ ******************************************************************************
\
\       Name: TT15
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a set of crosshairs
\
\ ------------------------------------------------------------------------------
\
\ For all views except the Short-range Chart, the centre is drawn 24 pixels to
\ the right of the y-coordinate given.
\
IF _6502SP_VERSION \ Comment
\ The crosshairs are drawn in colour 3, which is white in the chart view and
\ cyan elsewhere. We can draw them in the current colour by calling the TT15b
\ entry point.
\
ENDIF
\ Arguments:
\
\   QQ19                The pixel x-coordinate of the centre of the crosshairs
\
\   QQ19+1              The pixel y-coordinate of the centre of the crosshairs
\
\   QQ19+2              The size of the crosshairs
\
IF _6502SP_VERSION \ Comment
\ Other entry points:
\
\   TT15b               Draw the crosshairs in the current colour
\
ENDIF
\ ******************************************************************************

.TT15

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view
                        \ and cyan elsewhere

.TT15b

ENDIF

 LDA #24                \ Set A to 24, which we will use as the minimum
                        \ screen indent for the crosshairs (i.e. the minimum
                        \ distance from the top-left corner of the screen)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

 LDX QQ11               \ If the current view is not the Short-range Chart,
 BPL P%+4               \ which is the only view with bit 7 set, then skip the
                        \ following instruction

 LDA #0                 \ This is the Short-range Chart, so set A to 0, so the
                        \ crosshairs can go right up against the screen edges

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX QQ11               \ If the current view is not the Short-range Chart,
 BPL TT178              \ which is the only view with bit 7 set, then jump to
                        \ TT178 to skip the following instruction

 LDA #0                 \ This is the Short-range Chart, so set A to 0, so the
                        \ crosshairs can go right up against the screen edges

.TT178

ENDIF

 STA QQ19+5             \ Set QQ19+5 to A, which now contains the correct indent
                        \ for this view

 LDA QQ19               \ Set A = crosshairs x-coordinate - crosshairs size
 SEC                    \ to get the x-coordinate of the left edge of the
 SBC QQ19+2             \ crosshairs

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: In the Master version, the horizontal crosshair doesn't overlap the left border of the Short-range Chart, while it does in the other versions

 BCS TT84               \ If the above subtraction didn't underflow, then A is
                        \ positive, so skip the next instruction

 LDA #0                 \ The subtraction underflowed, so set A to 0 so the
                        \ crosshairs don't spill out of the left of the screen

ELIF _MASTER_VERSION

 BIT QQ11               \ If bit 7 of QQ11 is set, then this this is the
 BMI TT84               \ Short-range Chart, so jump to TT84

 BCC P%+6               \ If the above subtraction underflowed, then A is
                        \ positive, so skip the next two instructions

 CMP #2                 \ If A >= 2, skip the next instruction
 BCS TT84

 LDA #2                 \ The subtraction underflowed or A < 2, so set A to 2
                        \ so the crosshairs don't spill out of the left of the
                        \ screen

ENDIF

.TT84

                        \ In the following, the authors have used XX15 for
                        \ temporary storage. XX15 shares location with X1, Y1,
                        \ X2 and Y2, so in the following, you can consider
                        \ the variables like this:
                        \
                        \   XX15   is the same as X1
                        \   XX15+1 is the same as Y1
                        \   XX15+2 is the same as X2
                        \   XX15+3 is the same as Y2
                        \
                        \ Presumably this routine was written at a different
                        \ time to the line-drawing routine, before the two
                        \ workspaces were merged to save space

 STA XX15               \ Set XX15 (X1) = A (the x-coordinate of the left edge
                        \ of the crosshairs)

 LDA QQ19               \ Set A = crosshairs x-coordinate + crosshairs size
 CLC                    \ to get the x-coordinate of the right edge of the
 ADC QQ19+2             \ crosshairs

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

 BCC P%+4               \ If the above addition didn't overflow, then A is
                        \ correct, so skip the next instruction

 LDA #255               \ The addition overflowed, so set A to 255 so the
                        \ crosshairs don't spill out of the right of the screen
                        \ (as 255 is the x-coordinate of the rightmost pixel
                        \ on-screen)

ELIF _6502SP_VERSION

 BCC TT85               \ If the above addition didn't overflow, then A is
                        \ correct, so jump to TT85 to skip the next instruction

 LDA #255               \ The addition overflowed, so set A to 255 so the
                        \ crosshairs don't spill out of the right of the screen
                        \ (as 255 is the x-coordinate of the rightmost pixel
                        \ on-screen)

.TT85

ELIF _MASTER_VERSION

 BCS P%+6               \ If the above addition overflowed, skip the following
                        \ two instructions to set A = 254

 CMP #254               \ The addition didn't overflow, so if A < 254, jump to
 BCC TT85               \ TT85

 LDA #254               \ Set A = 254, so the crosshairs don't spill out of the
                        \ right of the screen

.TT85

ENDIF

 STA XX15+2             \ Set XX15+2 (X2) = A (the x-coordinate of the right
                        \ edge of the crosshairs)

 LDA QQ19+1             \ Set XX15+1 (Y1) = crosshairs y-coordinate + indent
 CLC                    \ to get the y-coordinate of the centre of the
 ADC QQ19+5             \ crosshairs
 STA XX15+1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 JSR HLOIN              \ Draw a horizontal line from (X1, Y1) to (X2, Y1),
                        \ which will draw from the left edge of the crosshairs
                        \ to the right edge, through the centre of the
                        \ crosshairs

ELIF _6502SP_VERSION

 STA XX15+3             \ Set XX15+3 (Y2) = crosshairs y-coordinate + indent

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2), where Y1 = Y2,
                        \ which will draw from the left edge of the crosshairs
                        \ to the right edge, through the centre of the
                        \ crosshairs

ELIF _MASTER_VERSION

 JSR HLOIN3             \ Call HLOIN3 to draw a line from (X1, Y1) to (X2, Y1)

ENDIF

 LDA QQ19+1             \ Set A = crosshairs y-coordinate - crosshairs size
 SEC                    \ to get the y-coordinate of the top edge of the
 SBC QQ19+2             \ crosshairs

 BCS TT86               \ If the above subtraction didn't underflow, then A is
                        \ correct, so skip the next instruction

 LDA #0                 \ The subtraction underflowed, so set A to 0 so the
                        \ crosshairs don't spill out of the top of the screen

.TT86

 CLC                    \ Set XX15+1 (Y1) = A + indent to get the y-coordinate
 ADC QQ19+5             \ of the top edge of the indented crosshairs
 STA XX15+1

 LDA QQ19+1             \ Set A = crosshairs y-coordinate + crosshairs size
 CLC                    \ + indent to get the y-coordinate of the bottom edge
 ADC QQ19+2             \ of the indented crosshairs
 ADC QQ19+5

 CMP #152               \ If A < 152 then skip the following, as the crosshairs
 BCC TT87               \ won't spill out of the bottom of the screen

 LDX QQ11               \ A >= 152, so we need to check whether this will fit in
                        \ this view, so fetch the view number

 BMI TT87               \ If this is the Short-range Chart then the y-coordinate
                        \ is fine, so skip to TT87

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: The bottom border of the Long-range Chart is one pixel lower down the screen in the Master version than in the other versions, so crosshair-clipping code is slightly different too

 LDA #151               \ Otherwise this is the Long-range Chart, so we need to
                        \ clip the crosshairs at a maximum y-coordinate of 151

ELIF _MASTER_VERSION

 LDA #152               \ Otherwise this is the Long-range Chart, so we need to
                        \ clip the crosshairs at a maximum y-coordinate of 152

ENDIF

.TT87

 STA XX15+3             \ Set XX15+3 (Y2) = A (the y-coordinate of the bottom
                        \ edge of the crosshairs)

 LDA QQ19               \ Set XX15 (X1) = the x-coordinate of the centre of the
 STA XX15               \ crosshairs

 STA XX15+2             \ Set XX15+2 (X2) = the x-coordinate of the centre of
                        \ the crosshairs

 JMP LL30               \ Draw a vertical line (X1, Y1) to (X2, Y2), which will
                        \ draw from the top edge of the crosshairs to the bottom
                        \ edge, through the centre of the crosshairs, returning
                        \ from the subroutine using a tail call

