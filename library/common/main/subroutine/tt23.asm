\ ******************************************************************************
\
\       Name: TT23
\       Type: Subroutine
\   Category: Charts
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Short-range Chart (red key f5)
ELIF _ELECTRON_VERSION
\    Summary: Show the Short-range Chart (FUNC-6)
ELIF _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
\    Summary: Show the Short-range Chart
ENDIF
\
\ ******************************************************************************

.TT23

IF NOT(_NES_VERSION OR _C64_VERSION)

 LDA #128               \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 128 (Short-
                        \ range Chart)

ELIF _NES_VERSION

 LDA #0                 \ Set systemsOnChart = 0 so we can use it to count the
 STA systemsOnChart     \ systems as we add them to the chart

 LDA #199               \ Set the number of pixel rows in the space view to 199,
 STA Yx2M1              \ to cover the size of the chart part of the Short-range
                        \ Chart view

 LDA #&9C               \ Clear the screen and set the view type in QQ11 to &9C
 JSR TT66               \ (Short-range Chart)

ELIF _C64_VERSION

 LDA #199               \ Set the number of pixel rows in the space view to 199,
 STA Yx2M1              \ to cover the size of the chart part of the Short-range
                        \ Chart view

 STA dontclip           \ Set dontclip to 199 (which has bit 7 set) to disable
                        \ line-clipping in the LL145 routine
                        \
                        \ This allows the Short-range Chart to take up the whole
                        \ of the screen, rather than being clipped to the
                        \ dimensions of the space view (which we don't want to
                        \ do as there is no dashboard in the chart view)

 LDA #128               \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 128 (Short-
                        \ range Chart)

 LDA #16                \ Switch to the palette for the trade view, though this
 JSR DOVDU19            \ doesn't actually do anything in this version of Elite

ENDIF

IF _6502SP_VERSION \ Minor

 LDA #16                \ Send a #SETVDU19 16 command to the I/O processor to
 JSR DOVDU19            \ switch to the mode 1 palette for the trade view, which
                        \ is yellow (colour 1), magenta (colour 2) and white
                        \ (colour 3)

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

ELIF _MASTER_VERSION

 LDA #16                \ Switch to the mode 1 palette for the trade view, which
 JSR DOVDU19            \ is yellow (colour 1), magenta (colour 2) and white
                        \ (colour 3)

 LDA #CYAN              \ Switch to colour 3, which is white in the chart view
 STA COL

ELIF _C64_VERSION

\LDA #CYAN              \ These instructions are commented out in the original
\JSR DOCOL              \ source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _APPLE_VERSION \ Tube

 LDA #7                 \ Move the text cursor to column 7
 STA XC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #7                 \ Move the text cursor to column 7
 JSR DOXC

ELIF _NES_VERSION

 LDX languageIndex      \ Move the text cursor to the correct column for the
 LDA xShortRange,X      \ Short-range Chart title in the chosen language
 STA XC

ENDIF

IF NOT(_NES_VERSION)

 LDA #190               \ Print recursive token 30 ("SHORT RANGE CHART") and
 JSR NLIN3              \ draw a horizontal line at pixel row 19 to box in the
                        \ title

ELIF _NES_VERSION

 LDA #190               \ Print recursive token 30 ("SHORT RANGE CHART") on the
 JSR NLIN3              \ top row

 JSR SetScreenForUpdate \ Get the screen ready for updating by hiding all
                        \ sprites, after fading the screen to black if we are
                        \ changing view

ENDIF

 JSR TT14               \ Call TT14 to draw a circle with crosshairs at the
                        \ current system's galactic coordinates

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ i.e. at the selected system

 JSR TT81               \ Set the seeds in QQ15 to those of system 0 in the
                        \ current galaxy (i.e. copy the seeds from QQ21 to QQ15)

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the chart view

ELIF _MASTER_VERSION

 LDA #CYAN              \ Switch to colour 3, which is white in the chart view
 STA COL

ELIF _C64_VERSION

\LDA #CYAN              \ These instructions are commented out in the original
\JSR DOCOL              \ source

ENDIF

 LDA #0                 \ Set A = 0, which we'll use below to zero out the INWK
                        \ workspace

 STA XX20               \ We're about to start working our way through each of
                        \ the galaxy's systems, so set up a counter in XX20 for
                        \ each system, starting at 0 and looping through to 255

 LDX #24                \ First, though, we need to zero out the 25 bytes at
                        \ INWK so we can use them to work out which systems have
                        \ room for a label, so set a counter in X for 25 bytes

.EE3

 STA INWK,X             \ Set the X-th byte of INWK to zero

 DEX                    \ Decrement the counter

 BPL EE3                \ Loop back to EE3 for the next byte until we've zeroed
                        \ all 25 bytes

                        \ We now loop through every single system in the galaxy
                        \ and check the distance from the current system whose
                        \ coordinates are in (QQ0, QQ1). We get the galactic
                        \ coordinates of each system from the system's seeds,
                        \ like this:
                        \
                        \   x = s1_hi (which is stored in QQ15+3)
                        \   y = s0_hi (which is stored in QQ15+1)
                        \
                        \ so the following loops through each system in the
                        \ galaxy in turn and calculates the distance between
                        \ (QQ0, QQ1) and (s1_hi, s0_hi) to find the closest one

.TT182

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA QQ15+3             \ Set A = s1_hi - QQ0, the horizontal distance between
 SEC                    \ (s1_hi, s0_hi) and (QQ0, QQ1)
 SBC QQ0

IF _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 STA XX12               \ Store the horizontal distance in XX12, so we can
                        \ retrieve it later

ENDIF

 BCS TT184              \ If a borrow didn't occur, i.e. s1_hi >= QQ0, then the
                        \ result is positive, so jump to TT184 and skip the
                        \ following two instructions

 EOR #&FF               \ Otherwise negate the result in A, so A is always
 ADC #1                 \ positive (i.e. A = |s1_hi - QQ0|)

.TT184

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: The Master version includes systems on the Short-range Chart if they are in the horizontal range 0-29, while the other versions include systems in the range 0-20, so the Master version can show systems that are further to the right. You can see an example of this difference in the Short-range Chart at Lave, which contains a lone system (Qutiri) out to the far right. This system isn't shown in the other versions because of their stricter horizontal distance check

 CMP #20                \ If the horizontal distance in A is >= 20, then this
 BCS TT187              \ system is too far away from the current system to
                        \ appear in the Short-range Chart, so jump to TT187 to
                        \ move on to the next system

ELIF _MASTER_VERSION OR _APPLE_VERSION

 CMP #29                \ If the horizontal distance in A is >= 29, then this
 BCS TT187s             \ system is too far away from the current system to
                        \ appear in the Short-range Chart, so jump to TT187 via
                        \ TT187s to move on to the next system

ENDIF

 LDA QQ15+1             \ Set A = s0_hi - QQ1, the vertical distance between
 SEC                    \ (s1_hi, s0_hi) and (QQ0, QQ1)
 SBC QQ1

IF _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 STA K4                 \ Store the vertical distance in K4, so we can retrieve
                        \ it later

ENDIF

 BCS TT186              \ If a borrow didn't occur, i.e. s0_hi >= QQ1, then the
                        \ result is positive, so jump to TT186 and skip the
                        \ following two instructions

 EOR #&FF               \ Otherwise negate the result in A, so A is always
 ADC #1                 \ positive (i.e. A = |s0_hi - QQ1|)

.TT186

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: The Master version includes systems on the Short-range Chart if they are in the vertical range 0-40, while the other versions include systems in the range 0-38, so the Master version version can show systems that are further down the chart

 CMP #38                \ If the vertical distance in A is >= 38, then this
 BCS TT187              \ system is too far away from the current system to
                        \ appear in the Short-range Chart, so jump to TT187 to
                        \ move on to the next system

ELIF _MASTER_VERSION OR _APPLE_VERSION

 CMP #40                \ If the vertical distance in A is >= 40, then this
 BCS TT187s             \ system is too far away from the current system to
                        \ appear in the Short-range Chart, so jump to TT187 via
                        \ TT187s to move on to the next system

ENDIF

                        \ This system should be shown on the Short-range Chart,
                        \ so now we need to work out where the label should go,
                        \ and set up the various variables we need to draw the
                        \ system's filled circle on the chart

IF NOT(_ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)

 LDA QQ15+3             \ Set A = s1_hi - QQ0, the horizontal distance between
 SEC                    \ this system and the current system, where |A| < 20.
 SBC QQ0                \ Let's call this the x-delta, as it's the horizontal
                        \ difference between the current system at the centre of
                        \ the chart, and this system (and this time we keep the
                        \ sign of A, so it can be negative if it's to the left
                        \ of the chart's centre, or positive if it's to the
                        \ right)

ELIF _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 LDA XX12               \ Retrieve the horizontal distance from XX12, so A now
                        \ contains the horizontal distance between this system
                        \ and the current system
                        \
                        \ Let's call this the x-delta, as it's the horizontal
                        \ difference between the current system at the centre of
                        \ the chart, and this system (so A is negative if it's
                        \ to the left of the chart's centre, or positive if it's
                        \ to the right)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: Group A: The Master version contains code to scale the chart views, though it has no effect in this version. The code is left over from the Apple II version, which uses a different scale

 ASL A                  \ Set XX12 = 104 + x-delta * 4
 ASL A                  \
 ADC #104               \ 104 is the x-coordinate of the centre of the chart,
 STA XX12               \ so this sets XX12 to the centre 104 +/- 76, the pixel
                        \ x-coordinate of this system

ELIF _MASTER_VERSION

 ASL A                  \ Set XX12 = 104 + x-delta * 4
 ASL A                  \
 ADC #104               \ 104 is the x-coordinate of the centre of the chart,
 JSR SCALEY2            \ so this sets XX12 to the centre 104 +/- 76, the pixel
 STA XX12               \ x-coordinate of this system
                        \
                        \ The call to SCALEY2 has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

ELIF _APPLE_VERSION

 ASL A                  \ Set XX12 = 105 + x-delta * 4
 ASL A                  \
 ADC #105*4/3           \ 105 is the x-coordinate of the centre of the chart,
 JSR SCALEY2            \ so this sets XX12 to the centre 104 +/- 76, to give
 STA XX12               \ the scaled pixel x-coordinate of this system

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LSR A                  \ Move the text cursor to column x-delta / 2 + 1
 LSR A                  \ which will be in the range 1-10
 LSR A
 STA XC
 INC XC

ELIF _6502SP_VERSION

 LSR A                  \ Move the text cursor to column x-delta / 2 + 1
 LSR A                  \ which will be in the range 1-10
 LSR A
 INA
 JSR DOXC

ELIF _MASTER_VERSION

 LSR A                  \ Move the text cursor to column x-delta / 2 + 1
 LSR A                  \ which will be in the range 1-10
 LSR A
 INC A
 STA XC

ELIF _C64_VERSION

 LSR A                  \ Move the text cursor to column x-delta / 2 + 1
 LSR A                  \ which will be in the range 1-10
 LSR A
 CLC
 ADC #1
 JSR DOXC

ELIF _NES_VERSION OR _APPLE_VERSION

 LSR A                  \ Move the text cursor to column x-delta / 2 + 1
 LSR A                  \ which will be in the range 1-10
 LSR A
 CLC
 ADC #1
 STA XC

ENDIF

IF NOT(_ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)

 LDA QQ15+1             \ Set A = s0_hi - QQ1, the vertical distance between
 SEC                    \ this system and the current system, where |A| < 38.
 SBC QQ1                \ Let's call this the y-delta, as it's the vertical
                        \ difference between the current system at the centre of
                        \ the chart, and this system (and this time we keep the
                        \ sign of A, so it can be negative if it's above the
                        \ chart's centre, or positive if it's below)

ELIF _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 LDA K4                 \ Retrieve the vertical distance from XX12, so A now
                        \ contains the vertical distance between this system
                        \ and the current system
                        \
                        \ Let's call this the y-delta, as it's the vertical
                        \ difference between the current system at the centre of
                        \ the chart, and this system (so A is negative if it's
                        \ above the chart's centre, or positive if it's below)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: See group A

 ASL A                  \ Set K4 = 90 + y-delta * 2
 ADC #90                \
 STA K4                 \ 90 is the y-coordinate of the centre of the chart,
                        \ so this sets K4 to the centre 90 +/- 74, the pixel
                        \ y-coordinate of this system

ELIF _ELECTRON_VERSION

 ASL A                  \ Set Y1 = 90 + y-delta * 2
 ADC #90                \
 STA Y1                 \ 90 is the y-coordinate of the centre of the chart,
                        \ so this sets Y1 to the centre 90 +/- 74, the pixel
                        \ y-coordinate of this system

ELIF _MASTER_VERSION

 ASL A                  \ Set K4 = 90 + y-delta * 2
 ADC #90                \
 JSR SCALEY2            \ 90 is the y-coordinate of the centre of the chart,
 STA K4                 \ so this sets K4 to the centre 90 +/- 74, the pixel
                        \ y-coordinate of this system
                        \
                        \ The call to SCALEY2 has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

ELIF _APPLE_VERSION

 ASL A                  \ Set K4 = 99 + y-delta * 2
 ADC #99                \
 JSR SCALEY2            \ 99 is the y-coordinate of the centre of the chart,
 STA K4                 \ so this sets K4 to the centre 99 +/- 74, to give the
                        \ scaled pixel y-coordinate of this system

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment

 LSR A                  \ Set Y = K4 / 8, so Y contains the number of the text
 LSR A                  \ row that contains this system
 LSR A
 TAY

ELIF _ELECTRON_VERSION

 LSR A                  \ Set Y = Y1 / 8, so Y contains the number of the text
 LSR A                  \ row that contains this system
 LSR A
 TAY

ENDIF

                        \ Now to see if there is room for this system's label.
                        \ Ideally we would print the system name on the same
                        \ text row as the system, but we only want to print one
                        \ label per row, to prevent overlap, so now we check
                        \ this system's row, and if that's already occupied,
                        \ the row above, and if that's already occupied, the
                        \ row below... and if that's already occupied, we give
                        \ up and don't print a label for this system

 LDX INWK,Y             \ If the value in INWK+Y is 0 (i.e. the text row
 BEQ EE4                \ containing this system does not already have another
                        \ system's label on it), jump to EE4 to store this
                        \ system's label on this row

 INY                    \ If the value in INWK+Y+1 is 0 (i.e. the text row below
 LDX INWK,Y             \ the one containing this system does not already have
 BEQ EE4                \ another system's label on it), jump to EE4 to store
                        \ this system's label on this row

 DEY                    \ If the value in INWK+Y-1 is 0 (i.e. the text row above
 DEY                    \ the one containing this system does not already have
 LDX INWK,Y             \ another system's label on it), fall through into to
 BNE ee1                \ EE4 to store this system's label on this row,
                        \ otherwise jump to ee1 to skip printing a label for
                        \ this system (as there simply isn't room)

.EE4

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Tube

 STY YC                 \ Now to print the label, so move the text cursor to row
                        \ Y (which contains the row where we can print this
                        \ system's label)

ELIF _6502SP_VERSION OR _C64_VERSION

 TYA                    \ Now to print the label, so move the text cursor to row
 JSR DOYC               \ Y (which contains the row where we can print this
                        \ system's label)

ELIF _NES_VERSION

 TYA                    \ Now to print the label, so move the text cursor to row
 STA YC                 \ Y (which contains the row where we can print this
                        \ system's label)

ENDIF

 CPY #3                 \ If Y < 3, then the system would clash with the chart
 BCC TT187              \ title, so jump to TT187 to skip showing the system

IF _MASTER_VERSION \ Master: The Master version only shows systems on the Short-range Chart that are within 7 light years of the current system, whereas the other versions show all systems in the vicinity, irrespective of the distance. You can see this on the Short-range Chart at Lave, where Orrere, Uszaa and Tionisla are all missing from the Master version's chart, but are present in the other versions. Interestingly, the unlabelled system on the far right (Qutiri) that slipped through the Master's more generous horizontal distance check is still shown, even though it's more than 7 light years away. This is a bug, and it's caused by the label-printing logic; because there is no room for a label for this system, the code skips label-printing by jumping to ee1 rather than TT187, inadvertently jumping to the system-drawing routine rather than moving on to the next system

 CPY #21                \ If Y > 21, then the label will be off the bottom of
 BCS TT187              \ the chart, so jump to TT187 to skip showing the system

 TYA                    \ Store Y on the stack so it can be preserved across the
 PHA                    \ call to readdistnce

 LDA QQ15+3             \ Set A = s1_hi, so A contains the galactic x-coordinate
                        \ of the system we are displaying on the chart

 JSR readdistnce        \ Call readdistnce to calculate the distance between the
                        \ system with galactic coordinates (A, QQ15+1) - i.e.
                        \ the system we are displaying - and the current system
                        \ at (QQ0, QQ1), returning the result in QQ8(1 0)

 PLA                    \ Restore Y from the stack
 TAY

 LDA QQ8+1              \ If the high byte of the distance in QQ8(1 0) is
 BNE TT187              \ non-zero, jump to TT187 to skip showing the system as
                        \ it is too far away from the current system

 LDA QQ8                \ If the low byte of the distance in QQ8(1 0) is >= 70,
 CMP #70                \ jump to TT187 to skip showing the system as it is too
                        \ far away from the current system

.TT187s

 BCS TT187              \ If we get here from the instruction above, we jump to
                        \ TT187 if QQ8(1 0) >= 70, so we only show systems that
                        \ are within distance 70 (i.e. 7 light years) of the
                        \ current system
                        \
                        \ If we jump here from elsewhere with a BCS TT187s, we
                        \ jump straight on to TT187

ELIF _APPLE_VERSION


 CPY #17                \ If Y > 17, then the label will be off the bottom of
 BCS TT187              \ the chart, so jump to TT187 to skip showing the system

 TYA                    \ Store Y on the stack so it can be preserved across the
 PHA                    \ call to readdistnce

 LDA QQ15+3             \ Set A = s1_hi, so A contains the galactic x-coordinate
                        \ of the system we are displaying on the chart

 JSR readdistnce        \ Call readdistnce to calculate the distance between the
                        \ system with galactic coordinates (A, QQ15+1) - i.e.
                        \ the system we are displaying - and the current system
                        \ at (QQ0, QQ1), returning the result in QQ8(1 0)

 PLA                    \ Restore Y from the stack
 TAY

 LDA QQ8+1              \ If the high byte of the distance in QQ8(1 0) is
 BNE TT187              \ non-zero, jump to TT187 to skip showing the system as
                        \ it is too far away from the current system

 LDA QQ8                \ If the low byte of the distance in QQ8(1 0) is >= 70,
 CMP #70                \ jump to TT187 to skip showing the system as it is too
                        \ far away from the current system

.TT187s

 BCS TT187              \ If we get here from the instruction above, we jump to
                        \ TT187 if QQ8(1 0) >= 70, so we only show systems that
                        \ are within distance 70 (i.e. 7 light years) of the
                        \ current system
                        \
                        \ If we jump here from elsewhere with a BCS TT187s, we
                        \ jump straight on to TT187

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 DEX                    \ We entered the EE4 routine with X = 0, so this stores
 STX INWK,Y             \ &FF in INWK+Y, to denote that this row is now occupied
                        \ so we don't try to print another system's label on
                        \ this row

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 LDA #&FF               \ Store &FF in INWK+Y, to denote that this row is now
 STA INWK,Y             \ occupied so we don't try to print another system's
                        \ label on this row

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_FLIGHT)

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

ELIF _ELITE_A_DOCKED OR _ELITE_A_FLIGHT

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case

ENDIF

 JSR cpl                \ Call cpl to print out the system name for the seeds
                        \ in QQ15 (which now contains the seeds for the current
                        \ system)

.ee1

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Electron: In the non-Electron versions, the same code is used to draw both the sun and the systems on the Short-range Chart. The Electron version doesn't include suns, so systems on the chart are drawn as dots rather than filled circles

 LDA #0                 \ Now to plot the star, so set the high bytes of K, K3
 STA K3+1               \ and K4 to 0
 STA K4+1
 STA K+1

 LDA XX12               \ Set the low byte of K3 to XX12, the pixel x-coordinate
 STA K3                 \ of this system

 LDA QQ15+5             \ Fetch s2_hi for this system from QQ15+5, extract bit 0
 AND #1                 \ and add 2 to get the size of the star, which we store
 ADC #2                 \ in K. This will be either 2, 3 or 4, depending on the
 STA K                  \ value of bit 0, and whether the C flag is set (which
                        \ will vary depending on what happens in the above call
                        \ to cpl). Incidentally, the planet's average radius
                        \ also uses s2_hi, bits 0-3 to be precise, but that
                        \ doesn't mean the two sizes affect each other

                        \ We now have the following:
                        \
                        \   K(1 0)  = radius of star (2, 3 or 4)
                        \
                        \   K3(1 0) = pixel x-coordinate of system
                        \
                        \   K4(1 0) = pixel y-coordinate of system
                        \
                        \ which we can now pass to the SUN routine to draw a
                        \ small "sun" on the Short-range Chart for this system

 JSR FLFLLS             \ Call FLFLLS to reset the LSO block

 JSR SUN                \ Call SUN to plot a sun with radius K at pixel
                        \ coordinate (K3, K4)

 JSR FLFLLS             \ Call FLFLLS to reset the LSO block

ELIF _NES_VERSION

 LDA #0                 \ Now to plot the star, so set the high bytes of K, K3
 STA K3+1               \ and K4 to 0
 STA K4+1
 STA K+1

 LDA XX12               \ Set the low byte of K3 to XX12, the pixel x-coordinate
 STA K3                 \ of this system

 LDA QQ15+5             \ Fetch s2_hi for this system from QQ15+5, extract bit 0
 AND #1                 \ and add 2 to get the size of the star, which we store
 ADC #2                 \ in K. This will be either 2, 3 or 4, depending on the
 STA K                  \ value of bit 0, and whether the C flag is set (which
                        \ will vary depending on what happens in the above call
                        \ to cpl). Incidentally, the planet's average radius
                        \ also uses s2_hi, bits 0-3 to be precise, but that
                        \ doesn't mean the two sizes affect each other

                        \ We now have the following:
                        \
                        \   K(1 0)  = radius of star (2, 3 or 4)
                        \
                        \   K3(1 0) = pixel x-coordinate of system
                        \
                        \   K4(1 0) = pixel y-coordinate of system
                        \
                        \ which we can now pass to the DrawChartSystem routine
                        \ to draw a system on the Short-range Chart

 JSR DrawChartSystem    \ Draw the system on the chart

ELIF _ELECTRON_VERSION

 LDA XX12               \ Set X1 to the pixel x-coordinate of this system
 STA X1

 JSR CPIX4              \ Draw a double-height mode 4 dot at (X1, Y1)

ENDIF

IF _MASTER_VERSION \ Screen

 LDA #CYAN              \ Switch to colour 3, which is white in the chart view
 STA COL

ENDIF

.TT187

 JSR TT20               \ We want to move on to the next system, so call TT20
                        \ to twist the three 16-bit seeds in QQ15

 INC XX20               \ Increment the counter

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 BEQ TT111-1            \ If X = 0 then we have done all 256 systems, so return
                        \ from the subroutine (as TT111-1 contains an RTS)

ELIF _6502SP_VERSION

 BNE P%+5               \ If X = 0 then we have done all 256 systems, so jump
 JMP HBFL               \ to HBFL to send the contents of the horizontal line
                        \ buffer to the I/O processor for drawing on-screen,
                        \ returning from the subroutine using a tail call

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 BEQ P%+5               \ If X = 0 then we have done all 256 systems, so skip
                        \ the next instruction to return from the subroutine

ENDIF

 JMP TT182              \ Otherwise jump back up to TT182 to process the next
                        \ system

IF _MASTER_VERSION OR _APPLE_VERSION \ Label

\LDA #0                 \ These instructions are commented out in the original
\STA dontclip           \ source
\LDA #2*Y-1
\STA Yx2M1

 RTS                    \ Return from the subroutine

ELIF _C64_VERSION

 LDA #0                 \ Set dontclip to 0 to enable line-clipping in the LL145
 STA dontclip           \ routine, as we only disable this for the Short-range
                        \ Chart

 LDA #2*Y-1             \ Set Yx2M1 to the number of pixel lines in the space
 STA Yx2M1              \ view

 RTS                    \ Return from the subroutine

ELIF _NES_VERSION

 LDA #143               \ Set the number of pixel rows in the space view to 143,
 STA Yx2M1              \ so the screen height is correctly set for the
                        \ Long-range Chart in case we switch to it using the
                        \ icon in the icon bar (which toggles between the two
                        \ charts)

 JMP UpdateView         \ Update the view, returning from the subroutine using
                        \ a tail call

ENDIF

