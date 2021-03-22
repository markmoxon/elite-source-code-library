\ ******************************************************************************
\
\       Name: TT22
\       Type: Subroutine
\   Category: Charts
\    Summary: Show the Long-range Chart (red key f4)
\
\ ******************************************************************************

.TT22

 LDA #64                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 32 (Long-
                        \ range Chart)

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

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Tube

 LDA #7                 \ Move the text cursor to column 7
 STA XC

ELIF _6502SP_VERSION

 LDA #7                 \ Move the text cursor to column 7
 JSR DOXC

ENDIF

 JSR TT81               \ Set the seeds in QQ15 to those of system 0 in the
                        \ current galaxy (i.e. copy the seeds from QQ21 to QQ15)

 LDA #199               \ Print recursive token 39 ("GALACTIC CHART{galaxy
 JSR TT27               \ number right-aligned to width 3}")

 JSR NLIN               \ Draw a horizontal line at pixel row 23 to box in the
                        \ title and act as the top frame of the chart, and move
                        \ the text cursor down one line

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 LDA #152               \ Draw a screen-wide horizontal line at pixel row 152
 JSR NLIN2              \ for the bottom edge of the chart, so the chart itself
                        \ is 128 pixels high, starting on row 24 and ending on
                        \ row 151

ELIF _MASTER_VERSION

 LDA #153               \ Draw a screen-wide horizontal line at pixel row 152
 JSR NLIN2-2            \ for the bottom edge of the chart, so the chart itself
                        \ is 128 pixels high, starting on row 24 and ending on
                        \ row 151 ???

ENDIF

 JSR TT14               \ Call TT14 to draw a circle with crosshairs at the
                        \ current system's galactic coordinates

 LDX #0                 \ We're now going to plot each of the galaxy's systems,
                        \ so set up a counter in X for each system, starting at
                        \ 0 and looping through to 255

.TT83

 STX XSAV               \ Store the counter in XSAV

 LDX QQ15+3             \ Fetch the s1_hi seed into X, which gives us the
                        \ galactic x-coordinate of this system

 LDY QQ15+4             \ Fetch the s2_lo seed and clear all the bits apart
 TYA                    \ from bits 4 and 6, storing the result in ZZ to give a
 ORA #%01010000         \ random number out of 0, &10, &40 or &50 (but which
 STA ZZ                 \ will always be the same for this system). We use this
                        \ value to determine the size of the point for this
                        \ system on the chart by passing it as the distance
                        \ argument to the PIXEL routine below

IF _MASTER_VERSION

 LDA #&0F               \ ???
 STA COL

ENDIF

 LDA QQ15+1             \ Fetch the s0_hi seed into A, which gives us the
                        \ galactic y-coordinate of this system

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

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

 JSR L4A42              \ ???

 CLC                    \ Add 24 to the halved y-coordinate ???
 ADC #24                \ (as the top of the chart is on pixel row 24, just
                        \ below the line we drew on row 23 above)

 JSR PIXEL              \ Call PIXEL to draw a point at (X, A), with the size of
                        \ the point dependent on the distance specified in ZZ
                        \ (so a high value of ZZ will produce a 1-pixel point,
                        \ a medium value will produce a 2-pixel dash, and a
                        \ small value will produce a 4-pixel square)

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
ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 LDA QQ9                \ Set QQ19 to the selected system's x-coordinate
 STA QQ19

 LDA QQ10               \ Set QQ19+1 to the selected system's y-coordinate,
 LSR A                  \ halved to fit it into the chart
 STA QQ19+1

 LDA #4                 \ Set QQ19+2 to size 4 for the crosshairs size
 STA QQ19+2

ELIF _MASTER_VERSION

 LDA QQ9                \ ???
 JSR L4A44

 STA QQ19
 LDA QQ10
 JSR L4A42

 STA QQ19+1

 LDA #4                 \ Set QQ19+2 to size 4 for the crosshairs size
 STA QQ19+2

 LDA #&AF               \ ???
 STA COL

ENDIF

                        \ Fall through into TT15 to draw crosshairs of size 4 at
                        \ the selected system's coordinates

