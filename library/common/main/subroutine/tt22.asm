\ ******************************************************************************
\
\       Name: TT22
\       Type: Subroutine
\   Category: Charts
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Long-range Chart (red key f4)
ELIF _ELECTRON_VERSION
\    Summary: Show the Long-range Chart (FUNC-5)
ELIF _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
\    Summary: Show the Long-range Chart
ENDIF
\
\ ******************************************************************************

.TT22

IF NOT(_NES_VERSION)

 LDA #64                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 32 (Long-
                        \ range Chart)

ELIF _NES_VERSION

 LDA #&8D               \ Clear the screen and set the view type in QQ11 to &8D
 JSR TT66               \ (Long-range Chart)

 LDA #77                \ Set the screen height variables for a screen height of
 JSR SetScreenHeight    \ 154 (i.e. 2 * 77)

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

 LDA #16                \ Send a #SETVDU19 16 command to the I/O processor to
 JSR DOVDU19            \ switch to the mode 1 palette for the trade view, which
                        \ is yellow (colour 1), magenta (colour 2) and white
                        \ (colour 3)

ELIF _MASTER_VERSION

 LDA #16                \ Switch to the mode 1 palette for the trade view, which
 JSR DOVDU19            \ is yellow (colour 1), magenta (colour 2) and white
                        \ (colour 3)

 LDA #CYAN              \ Switch to colour 3, which is white in the chart view
 STA COL

ELIF _C64_VERSION

\LDA #CYAN              \ These instructions are commented out in the original
\JSR DOCOL              \ source (they are left over from the 6502 Second
                        \ Processor version of Elite and would change the text
                        \ colour to white)

 LDA #16                \ Switch to the mode 1 palette for the trade view, which
 JSR DOVDU19            \ is yellow (colour 1), magenta (colour 2) and white
                        \ (colour 3)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 LDA #7                 \ Move the text cursor to column 7
 STA XC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #7                 \ Move the text cursor to column 7
 JSR DOXC

ENDIF

 JSR TT81               \ Set the seeds in QQ15 to those of system 0 in the
                        \ current galaxy (i.e. copy the seeds from QQ21 to QQ15)

IF NOT(_NES_VERSION OR _APPLE_VERSION)

 LDA #199               \ Print recursive token 39 ("GALACTIC CHART{galaxy
 JSR TT27               \ number right-aligned to width 3}")

 JSR NLIN               \ Draw a horizontal line at pixel row 23 to box in the
                        \ title and act as the top frame of the chart, and move
                        \ the text cursor down one line

ELIF _APPLE_VERSION

 LDA #199               \ Print recursive token 39 ("GALACTIC CHART{galaxy
 JSR TT27               \ number right-aligned to width 3}")

ELIF _NES_VERSION

 LDA #199               \ Print recursive token 39 ("GALACTIC CHART{galaxy
 JSR NLIN3              \ number right-aligned to width 3}") on the top row

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: The bottom border of the Long-range Chart is one pixel lower down the screen in the Master version than in the other versions, and its position is defined using a variable

 LDA #152               \ Draw a screen-wide horizontal line at pixel row 152
 JSR NLIN2              \ for the bottom edge of the chart, so the chart itself
                        \ is 128 pixels high, starting on row 24 and ending on
                        \ row 151

ELIF _MASTER_VERSION

 LDA #GCYB+1            \ Move the text cursor down one line and draw a
 JSR NLIN5              \ screen-wide horizontal line at pixel row GCYB+1 (153)
                        \ for the bottom edge of the chart, so the chart itself
                        \ is 128 pixels high, starting on row 24 and ending on
                        \ row 153

ELIF _APPLE_VERSION

 LDA #GCYT-1            \ ???
 JSR NLIN5
 LDA #GCYB+1
 STA Y1
 LDA #31
 STA X1
 LDA #228
 STA X2
 JSR HLOIN
 LDA #30
 JSR DVLOIN
 LDA #226
 JSR DVLOIN

ENDIF

IF _NES_VERSION

 JSR FadeAndHideSprites \ Fade the screen to black and hide all sprites, so we
                        \ can update the screen while it's blacked-out

ENDIF

 JSR TT14               \ Call TT14 to draw a circle with crosshairs at the
                        \ current system's galactic coordinates

 LDX #0                 \ We're now going to plot each of the galaxy's systems,
                        \ so set up a counter in X for each system, starting at
                        \ 0 and looping through to 255

.TT83

 STX XSAV               \ Store the counter in XSAV

IF NOT(_APPLE_VERSION OR _NES_VERSION)

 LDX QQ15+3             \ Fetch the s1_hi seed into X, which gives us the
                        \ galactic x-coordinate of this system

ELIF _NES_VERSION

 LDA QQ15+3             \ Fetch the s1_hi seed into A, which gives us the
                        \ galactic x-coordinate of this system

 LSR A                  \ Set X = s1_hi - (A / 4) + 31
 LSR A                  \       = s1_hi - (s1_hi / 4) + 31
 STA T1                 \       = 31 + 0.75 * s1_hi
 LDA QQ15+3             \
 SEC                    \ So this scales the x-coordinate from a range of 0 to
 SBC T1                 \ 255 into a range from 31 to 222, so it fits nicely
 CLC                    \ into the Long-range Chart
 ADC #31
 TAX

ELIF _APPLE_VERSION

 LDA QQ15+3             \ ???
 JSR SCALEX
 TAX

ENDIF

IF NOT(_APPLE_VERSION)

 LDY QQ15+4             \ Fetch the s2_lo seed and set bits 4 and 6, storing the
 TYA                    \ result in ZZ to give a random number between 80 and
 ORA #%01010000         \ (but which will always be the same for this system).
 STA ZZ                 \ We use this value to determine the size of the point
                        \ for this system on the chart by passing it as the
                        \ distance argument to the PIXEL routine below

ELIF _APPLE_VERSION

 LDA #&FF               \ ???
 STA ZZ

ENDIF

IF _MASTER_VERSION \ Advanced: Group A: The Master version shows systems in the Long-range Chart in yellow, while the 650SP version shows them in "white" (cyan/red)

 LDA #YELLOW            \ Switch to colour 1, which is yellow
 STA COL

ENDIF

 LDA QQ15+1             \ Fetch the s0_hi seed into A, which gives us the
                        \ galactic y-coordinate of this system

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: Group B: The Master version contains code to scale the chart views, though it has no effect in this version. It also uses variables to define the size of the Lond-range Chart. The code is left over from the Apple II version, which uses a different scale

 LSR A                  \ We halve the y-coordinate because the galaxy in
                        \ in Elite is rectangular rather than square, and is
                        \ twice as wide (x-axis) as it is high (y-axis), so the
                        \ chart is 256 pixels wide and 128 high

 CLC                    \ Add 24 to the halved y-coordinate and store in XX15+1
 ADC #24                \ (as the top of the chart is on pixel row 24, just
 STA XX15+1             \ below the line we drew on row 23 above)

 JSR PIXEL              \ Call PIXEL to draw a point at (X, A), with the size of
                        \ the point dependent on the distance specified in ZZ
                        \ (so a high value of ZZ will produce a 1-pixel point,
                        \ a medium value will produce a 2-pixel dash, and a
                        \ small value will produce a 4-pixel square)

ELIF _MASTER_VERSION

 JSR SCALEY             \ We halve the y-coordinate because the galaxy in
                        \ in Elite is rectangular rather than square, and is
                        \ twice as wide (x-axis) as it is high (y-axis), so the
                        \ chart is 256 pixels wide and 128 high
                        \
                        \ The call to SCALEY simply does an LSR A, but having
                        \ this call instruction here would enable different
                        \ scaling to be applied by altering the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

 CLC                    \ Add GCYT to the halved y-coordinate in A (so the top
 ADC #GCYT              \ of the chart is on pixel row GCYT, just below the line
                        \ we drew on row 23 above)

 JSR PIXEL              \ Call PIXEL to draw a point at (X, A), with the size of
                        \ the point dependent on the distance specified in ZZ
                        \ (so a high value of ZZ will produce a 1-pixel point,
                        \ a medium value will produce a 2-pixel dash, and a
                        \ small value will produce a 4-pixel square)

ELIF _APPLE_VERSION

 JSR SCALEY             \ Scale the y-coordinate ???

 CLC                    \ Add GCYT to the scaled y-coordinate in A (so the top
 ADC #GCYT              \ of the chart is on pixel row GCYT)

 JSR PIXEL              \ Call PIXEL to draw a point at (X, A), with the size of
                        \ the point dependent on the distance specified in ZZ
                        \ (so a high value of ZZ will produce a 1-pixel point,
                        \ a medium value will produce a 2-pixel dash, and a
                        \ small value will produce a 4-pixel square)

ELIF _NES_VERSION

 LSR A                  \ Set A = (s0_hi - (A / 4)) / 2 + 32
 LSR A                  \       = (s0_hi - (s0_hi / 4)) / 2 + 32
 STA T1                 \       = 32 + 0.375 * s1_hi
 LDA QQ15+1             \
 SEC                    \ So this scales the y-coordinate from a range of 0 to
 SBC T1                 \ 255 into a range from 32 to 127, so it fits nicely
 LSR A                  \ into the Long-range Chart
 CLC
 ADC #32

 STA Y1                 \ Store the y-coordinate in Y1 (though this gets
                        \ overwritten by the call to DrawDash, so this has no
                        \ effect)

 JSR DrawDash           \ Draw a 2-pixel dash at pixel coordinate (X, A)

ENDIF

 JSR TT20               \ We want to move on to the next system, so call TT20
                        \ to twist the three 16-bit seeds in QQ15

 LDX XSAV               \ Restore the loop counter from XSAV

 INX                    \ Increment the counter

 BNE TT83               \ If X > 0 then we haven't done all 256 systems yet, so
                        \ loop back up to TT83

IF _6502SP_VERSION \ Tube

 JSR PBFL               \ Call PBFL to send the contents of the pixel buffer to
                        \ the I/O processor for plotting on-screen

ELIF _C64_VERSION

\JSR PBFL               \ This instruction is commented out in the original
\                       \ source (it would call PBFL to send the contents of the
\                       \ pixel buffer to the I/O processor for plotting
\                       \ on-screen

ENDIF

IF _NES_VERSION

 LDA #3                 \ Set K+2 = 3 to pass to DrawSmallBox as the text row
 STA K+2                \ on which to draw the top-left corner of the small box

 LDA #4                 \ Set K+3 = 4 to pass to DrawSmallBox as the text column
 STA K+3                \ on which to draw the top-left corner of the small box

 LDA #25                \ Set K = 25 to pass to DrawSmallBox as the width of the
 STA K                  \ small box

 LDA #14                \ Set K+1 = 14 to pass to DrawSmallBox as the height of
 STA K+1                \ the small box

 JSR DrawSmallBox_b3    \ Draw a box around the chart, with the top-left corner
                        \ at (3, 4), a height of 14 rows, and a width of 25 rows

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: See group B

 LDA QQ9                \ Set QQ19 to the selected system's x-coordinate
 STA QQ19

 LDA QQ10               \ Set QQ19+1 to the selected system's y-coordinate,
 LSR A                  \ halved to fit it into the chart
 STA QQ19+1

 LDA #4                 \ Set QQ19+2 to size 4 for the crosshairs size
 STA QQ19+2

ELIF _APPLE_VERSION

 LDA QQ9                \ Set QQ19 to the selected system's x-coordinate, scaled
 JSR SCALEX             \ accordingly ???
 STA QQ19

 LDA QQ10               \ Set QQ19+1 to the selected system's y-coordinate,
 JSR SCALEY             \ scaled accordingly ???
 STA QQ19+1

 LDA #4                 \ Set QQ19+2 to size 4 for the crosshairs size
 STA QQ19+2

ELIF _MASTER_VERSION

 LDA QQ9                \ Set QQ19 to the selected system's x-coordinate
 JSR SCALEX             \
 STA QQ19               \ The call to SCALEX has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

 LDA QQ10               \ Set QQ19+1 to the selected system's y-coordinate,
 JSR SCALEY             \ halved to fit it into the chart
 STA QQ19+1             \
                        \ The call to SCALEY simply does an LSR A, but having
                        \ this call instruction here would enable different
                        \ scaling to be applied by altering the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

 LDA #4                 \ Set QQ19+2 to size 4 for the crosshairs size
 STA QQ19+2

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Advanced: See group A

 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is white/yellow in the
 STA COL                \ chart view

ENDIF

IF NOT(_NES_VERSION)

                        \ Fall through into TT15 to draw crosshairs of size 4 at
                        \ the selected system's coordinates

ELIF _NES_VERSION

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

 LDA #&9D               \ Set the view type in QQ11 to &00 (Long-range Chart
 STA QQ11               \ with the normal font loaded)

 LDA #143               \ Set the number of pixel rows in the space view to 143,
 STA Yx2M1              \ so the screen height is correctly set for the
                        \ Short-range Chart in case we switch to it using the
                        \ icon in the icon bar (which toggles between the two
                        \ charts)

 JMP UpdateView         \ Update the view, returning from the subroutine using
                        \ a tail call

ENDIF

