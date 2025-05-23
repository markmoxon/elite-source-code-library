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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   QQ19                The pixel x-coordinate of the centre of the crosshairs
\
\   QQ19+1              The pixel y-coordinate of the centre of the crosshairs
\
\   QQ19+2              The size of the crosshairs
\
IF _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
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

ELIF _C64_VERSION

\LDA #CYAN              \ These instructions are commented out in the original
\JSR DOCOL              \ source

.TT15b

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: The Master version uses variables to define the size of the Long-range Chart

 LDA #24                \ Set A to 24, which we will use as the minimum
                        \ screen indent for the crosshairs (i.e. the minimum
                        \ distance from the top-left corner of the screen)

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA #GCYT              \ Set A to GCYT, which we will use as the minimum
                        \ screen indent for the crosshairs (i.e. the minimum
                        \ distance from the top-left corner of the screen)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

 LDX QQ11               \ If the current view is not the Short-range Chart,
 BPL P%+4               \ which is the only view with bit 7 set, then skip the
                        \ following instruction

 LDA #0                 \ This is the Short-range Chart, so set A to 0, so the
                        \ crosshairs can go right up against the screen edges

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDX QQ11               \ If the current view is not the Short-range Chart,
 BPL TT178              \ which is the only view with bit 7 set, then jump to
                        \ TT178 to skip the following instruction

 LDA #0                 \ This is the Short-range Chart, so set A to 0, so the
                        \ crosshairs can go right up against the screen edges

.TT178

ELIF _NES_VERSION

 LDX QQ11               \ If the current view is not the Short-range Chart,
 CPX #&9C               \ which is view type &9C, then jump to TT178 to skip the
 BNE TT178              \ following instruction

 LDA #0                 \ This is the Short-range Chart, so set A to 0, so the
                        \ crosshairs can go right up against the screen edges

.TT178

ENDIF

 STA QQ19+5             \ Set QQ19+5 to A, which now contains the correct indent
                        \ for this view

 LDA QQ19               \ Set A = crosshairs x-coordinate - crosshairs size
 SEC                    \ to get the x-coordinate of the left edge of the
 SBC QQ19+2             \ crosshairs

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: In the Master version, the horizontal crosshair doesn't overlap the left border of the Short-range Chart, while it does in the other versions

 BCS TT84               \ If the above subtraction didn't underflow, then A is
                        \ positive, so skip the next instruction

 LDA #0                 \ The subtraction underflowed, so set A to 0 so the
                        \ crosshairs don't spill out of the left of the screen

ELIF _APPLE_VERSION

 BIT QQ11               \ If bit 7 of QQ11 is set, then this this is the
 BMI TT84               \ Short-range Chart, so jump to TT84 to skip the
                        \ following

 CMP #34                \ This is the Long-range Chart, so clip the x-coordinate
 BCS TT84               \ of the left edge of the crosshairs so that it is at
 LDA #34                \ least 34 (so it doesn't go off the left edge of the
                        \ chart)

ELIF _MASTER_VERSION

 BIT QQ11               \ If bit 7 of QQ11 is set, then this this is the
 BMI TT84               \ Short-range Chart, so jump to TT84

 BCC botchfix13         \ If the above subtraction underflowed, then A is
                        \ positive, so skip the next two instructions

 CMP #2                 \ If A >= 2, skip the next instruction
 BCS TT84

.botchfix13

 LDA #2                 \ The subtraction underflowed or A < 2, so set A to 2
                        \ so the crosshairs don't spill out of the left of the
                        \ screen

ENDIF

.TT84

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Label

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

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 STA X1                 \ Set X1 = A (the x-coordinate of the left edge of the
                        \ crosshairs)

ENDIF

IF NOT(_APPLE_VERSION)

 LDA QQ19               \ Set A = crosshairs x-coordinate + crosshairs size
 CLC                    \ to get the x-coordinate of the right edge of the
 ADC QQ19+2             \ crosshairs

ELIF _APPLE_VERSION

 LDA QQ19               \ Set A = crosshairs x-coordinate + crosshairs size + 2
 CLC                    \ to get the x-coordinate of the right edge of the
 ADC #2                 \ crosshairs
 ADC QQ19+2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _NES_VERSION \ Label

 BCC P%+4               \ If the above addition didn't overflow, then A is
                        \ correct, so skip the next instruction

 LDA #255               \ The addition overflowed, so set A to 255 so the
                        \ crosshairs don't spill out of the right of the screen
                        \ (as 255 is the x-coordinate of the rightmost pixel
                        \ on-screen)

ELIF _6502SP_VERSION OR _C64_VERSION

 BCC TT85               \ If the above addition didn't overflow, then A is
                        \ correct, so jump to TT85 to skip the next instruction

 LDA #255               \ The addition overflowed, so set A to 255 so the
                        \ crosshairs don't spill out of the right of the screen
                        \ (as 255 is the x-coordinate of the rightmost pixel
                        \ on-screen)

.TT85

ELIF _APPLE_VERSION

 BIT QQ11               \ If bit 7 of QQ11 is set, then this this is the
 BMI TT85               \ Short-range Chart, so jump to TT85 to skip the
                        \ following

 CMP #224               \ This is the Long-range Chart, so clip the x-coordinate
 BCC TT85               \ of the right edge of the crosshairs so that it is no
 LDA #224               \ more than 224 (so it doesn't go off the right edge of
                        \ the chart)

.TT85

ELIF _MASTER_VERSION

\BIT QQ11               \ These instructions are commented out in the original
\BMI TT85               \ source

 BCS botchfix12         \ If the above addition overflowed, skip the following
                        \ two instructions to set A = 254

 CMP #254               \ The addition didn't overflow, so if A < 254, jump to
 BCC TT85               \ TT85

.botchfix12

 LDA #254               \ Set A = 254, so the crosshairs don't spill out of the
                        \ right of the screen

.TT85

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Label

 STA XX15+2             \ Set XX15+2 (X2) = A (the x-coordinate of the right
                        \ edge of the crosshairs)

 LDA QQ19+1             \ Set XX15+1 (Y1) = crosshairs y-coordinate + indent
 CLC                    \ to get the y-coordinate of the centre of the
 ADC QQ19+5             \ crosshairs
 STA XX15+1

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 STA X2                 \ Set X2 = A (the x-coordinate of the right edge of the
                        \ crosshairs)

 LDA QQ19+1             \ Set Y1 = crosshairs y-coordinate + indent to get the
 CLC                    \ y-coordinate of the centre of the crosshairs
 ADC QQ19+5
 STA Y1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _APPLE_VERSION \ Tube

 JSR HLOIN              \ Draw a horizontal line from (X1, Y1) to (X2, Y1),
                        \ which will draw from the left edge of the crosshairs
                        \ to the right edge, through the centre of the
                        \ crosshairs

ELIF _6502SP_VERSION OR _C64_VERSION

 STA XX15+3             \ Set XX15+3 (Y2) = crosshairs y-coordinate + indent

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2), where Y1 = Y2,
                        \ which will draw from the left edge of the crosshairs
                        \ to the right edge, through the centre of the
                        \ crosshairs

ELIF _MASTER_VERSION

 JSR HLOIN3             \ Call HLOIN3 to draw a line from (X1, Y1) to (X2, Y1)

ELIF _NES_VERSION

 STA XX15+3             \ Set XX15+3 (Y2) = crosshairs y-coordinate + indent

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2), where Y1 = Y2,
                        \ which will draw from the left edge of the crosshairs
                        \ to the right edge, through the centre of the
                        \ crosshairs

ENDIF

 LDA QQ19+1             \ Set A = crosshairs y-coordinate - crosshairs size
 SEC                    \ to get the y-coordinate of the top edge of the
 SBC QQ19+2             \ crosshairs

 BCS TT86               \ If the above subtraction didn't underflow, then A is
                        \ correct, so skip the next instruction

 LDA #0                 \ The subtraction underflowed, so set A to 0 so the
                        \ crosshairs don't spill out of the top of the screen

.TT86

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Label

 CLC                    \ Set XX15+1 (Y1) = A + indent to get the y-coordinate
 ADC QQ19+5             \ of the top edge of the indented crosshairs
 STA XX15+1

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CLC                    \ Set Y1 = A + indent to get the y-coordinate of the top
 ADC QQ19+5             \ edge of the indented crosshairs
 STA Y1

ENDIF

 LDA QQ19+1             \ Set A = crosshairs y-coordinate + crosshairs size
 CLC                    \ + indent to get the y-coordinate of the bottom edge
 ADC QQ19+2             \ of the indented crosshairs
 ADC QQ19+5

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: The Master version uses variables to define the size of the Long-range Chart

 CMP #152               \ If A < 152 then skip the following, as the crosshairs
 BCC TT87               \ won't spill out of the bottom of the screen

ELIF _MASTER_VERSION OR _APPLE_VERSION

 CMP #GCYB              \ If A < GCYB then skip the following, as the crosshairs
 BCC TT87               \ won't spill out of the bottom of the screen

ENDIF

 LDX QQ11               \ A >= 152, so we need to check whether this will fit in
                        \ this view, so fetch the view type

IF NOT(_NES_VERSION)

 BMI TT87               \ If this is the Short-range Chart then the y-coordinate
                        \ is fine, so skip to TT87

ELIF _NES_VERSION

 CPX #&9C               \ If this is the Short-range Chart then the y-coordinate
 BEQ TT87               \ is fine, so skip to TT87

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: The bottom border of the Long-range Chart is one pixel lower down the screen in the Master version than in the other versions, and it uses variables to define the chart size, so the crosshair-clipping code is slightly different too

 LDA #151               \ Otherwise this is the Long-range Chart, so we need to
                        \ clip the crosshairs at a maximum y-coordinate of 151

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA #GCYB              \ Otherwise this is the Long-range Chart, so we need to
                        \ clip the crosshairs at a maximum y-coordinate of GCYB

ENDIF

.TT87

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Label

 STA XX15+3             \ Set XX15+3 (Y2) = A (the y-coordinate of the bottom
                        \ edge of the crosshairs)

 LDA QQ19               \ Set XX15 (X1) = the x-coordinate of the centre of the
 STA XX15               \ crosshairs

 STA XX15+2             \ Set XX15+2 (X2) = the x-coordinate of the centre of
                        \ the crosshairs

ELIF _APPLE_VERSION

 STA Y2                 \ Set Y2 = A (the y-coordinate of the bottom edge of the
                        \ crosshairs)

 LDA QQ19               \ Set X1 = the x-coordinate of the centre of the
 STA X1                 \ crosshairs

ELIF _MASTER_VERSION OR _NES_VERSION

 STA Y2                 \ Set Y2 = A (the y-coordinate of the bottom edge of the
                        \ crosshairs)

 LDA QQ19               \ Set X1 = the x-coordinate of the centre of the
 STA X1                 \ crosshairs

 STA X2                 \ Set X2 = the x-coordinate of the centre of the
                        \ crosshairs

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Label

 JMP LL30               \ Draw a vertical line from (X1, Y1) to (X2, Y2), which
                        \ will draw from the top edge of the crosshairs to the
                        \ bottom edge, through the centre of the crosshairs,
                        \ and returning from the subroutine using a tail call

ELIF _APPLE_VERSION

 JMP VLOIN              \ Draw a vertical line from (X1, Y1) to (X1, Y2), which
                        \ will draw from the top edge of the crosshairs to the
                        \ bottom edge, through the centre of the crosshairs,
                        \ and returning from the subroutine using a tail call

ELIF _MASTER_VERSION OR _NES_VERSION

 JMP LOIN               \ Draw a vertical line from (X1, Y1) to (X2, Y2), which
                        \ will draw from the top edge of the crosshairs to the
                        \ bottom edge, through the centre of the crosshairs,
                        \ and returning from the subroutine using a tail call

ENDIF

