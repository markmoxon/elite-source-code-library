\ ******************************************************************************
\
\       Name: SCAN
\       Type: Subroutine
\   Category: Dashboard
IF NOT(_ELITE_A_6502SP_PARA)
\    Summary: Display the current ship on the scanner
ELIF _ELITE_A_6502SP_PARA
\    Summary: Display the current ship on the scanner by sending a draw_tail
\             command to the I/O processor
ENDIF
\  Deep dive: The 3D scanner
IF _ELITE_A_VERSION
\             The I.F.F. system
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This is used both to display a ship on the scanner, and to erase it again.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   INWK                The ship's data block
\
\ ******************************************************************************

IF _MASTER_VERSION \ Platform

.SCR1

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_6502SP_PARA

.SC5

 RTS                    \ Return from the subroutine

ENDIF

.SCAN

 LDA INWK+31            \ Fetch the ship's scanner flag from byte #31

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Minor

 AND #%00010000         \ If bit 4 is clear then the ship should not be shown
 BEQ SC5                \ on the scanner, so return from the subroutine (as SC5
                        \ contains an RTS)

 LDA TYPE               \ Fetch the ship's type from TYPE into A

ELIF _6502SP_VERSION

 AND #%00010000         \ If bit 4 is clear then the ship should not be shown
 BEQ SC5                \ on the scanner, so return from the subroutine (as SC5
                        \ contains an RTS)

 LDX TYPE               \ Fetch the ship's type from TYPE into X

ELIF _MASTER_VERSION

 AND #%00010000         \ If bit 4 is clear then the ship should not be shown
 BEQ SCR1               \ on the scanner, so return from the subroutine (as SCR1
                        \ contains an RTS)

 LDX TYPE               \ Fetch the ship's type from TYPE into X

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment

 BMI SC5                \ If this is the planet or the sun, then the type will
                        \ have bit 7 set and we don't want to display it on the
                        \ scanner, so return from the subroutine (as SC5
                        \ contains an RTS)

ELIF _MASTER_VERSION

 BMI SCR1               \ If this is the planet or the sun, then the type will
                        \ have bit 7 set and we don't want to display it on the
                        \ scanner, so return from the subroutine (as SCR1
                        \ contains an RTS)

ELIF _ELECTRON_VERSION

 BMI SC5                \ If this is the planet, then the type will have bit 7
                        \ set and we don't want to display it on the scanner,
                        \ so return from the subroutine (as SC5 contains an RTS)

ENDIF

IF _CASSETTE_VERSION \ Advanced: In the original versions, ships are shown on the scanner with a green stick, while missiles are shown in yellow (if an escape pod is fitted, they are shown in cyan and white respectively). In the advanced versions, each ship has its own colour for when it is shown on the scanner, as defined in the scacol table

 LDX #&FF               \ Set X to the default scanner colour of green/cyan
                        \ (a 4-pixel mode 5 byte in colour 3)

\CMP #TGL               \ These instructions are commented out in the original
\BEQ SC49               \ source. Along with the block just below, they would
                        \ set X to colour 1 (red) for asteroids, cargo canisters
                        \ and escape pods, rather than green/cyan. Presumably
                        \ they decided it didn't work that well against the red
                        \ ellipse and took this code out for release

 CMP #MSL               \ If this is not a missile, skip the following
 BNE P%+4               \ instruction

 LDX #&F0               \ This is a missile, so set X to colour 2 (yellow/white)

\CMP #AST               \ These instructions are commented out in the original
\BCC P%+4               \ source. See above for an explanation of what they do
\LDX #&0F
\.SC49

 STX COL                \ Store X, the colour of this ship on the scanner, in
                        \ COL

ELIF _DISC_FLIGHT

IF _STH_DISC OR _IB_DISC

 LDX #&FF               \ Set X to the default scanner colour of green/cyan
                        \ (a 4-pixel mode 5 byte in colour 3)

 CMP #MSL               \ If this is not a missile, skip the following
 BNE P%+4               \ instruction

 LDX #&F0               \ This is a missile, so set X to colour 2 (yellow/white)

ELIF _SRAM_DISC

 JSR SCANCOL            \ Call SCANCOL to set the correct colour on the scanner
                        \ for the current ship type

 NOP                    \ Pad out the code so it takes up the same amount of
 NOP                    \ space as in the original version
 NOP
 NOP
 NOP

ENDIF

 STX COL                \ Store X, the colour of this ship on the scanner, in
                        \ COL

ELIF _6502SP_VERSION

 LDA scacol,X           \ Set A to the scanner colour for this ship type from
                        \ the X-th entry in the scacol table

 STA SCANcol            \ Store the scanner colour in SCANcol so it can be sent
                        \ to the I/O processor with the #onescan command

ELIF _MASTER_VERSION

 LDA scacol,X           \ Set A to the scanner colour for this ship type from
                        \ the X-th entry in the scacol table

 STA COL                \ Store the scanner colour in COL so it can be used to
                        \ draw this ship in the correct colour

ELIF _ELITE_A_FLIGHT

 JSR iff_index          \ Call iff_index to work out the index of the colour we
                        \ should use for the dot and stick for this ship,
                        \ according to whether we have an I.F.F. system fitted

 LDA iff_base,X         \ Set COL to the base colour for this ship, given the
 STA COL                \ I.F.F. colour index in X (this colour is used for both
                        \ the dot and stick)

 LDA iff_xor,X          \ Set Y2 to the alternating colour for this ship, given
 STA Y2                 \ the I.F.F. colour index in X (this colour is used for
                        \ making the stick striped, where appropriate)

ELIF _ELITE_A_6502SP_PARA

 LDX CRGO               \ If we do not have an I.F.F. system fitted (i.e. CRGO
 BEQ iff_not            \ is zero), jump to iff_not to fetch the default
                        \ colours, which are those for a trader or innocent
                        \ bystander (i.e. X = 0)

                        \ If we get here then X = &FF (as CRGO is &FF if we have
                        \ an I.F.F. system fitted)

 LDY #36                \ Set A to byte #36 of the ship's blueprint, i.e. the
 LDA (INF),Y            \ NEWB flags

 ASL A                  \ If bit 6 is set, i.e. this is a cop, a space station
 ASL A                  \ or an escape pod, jump to iff_cop to set X = 1
 BCS iff_cop

 ASL A                  \ If bit 5 is set, i.e. this is an innocent bystander
 BCS iff_trade          \ (which applies to traders and some bounty hunters),
                        \ jump to iff_trade to set X = 0

 LDY TYPE               \ Set Y to the ship's type - 1
 DEY

 BEQ iff_missle         \ If Y = 0, i.e. this is a missile, then jump to
                        \ iff_missle to set X = 3

 CPY #8                 \ If Y < 8, i.e. this is a cargo canister, alloy plate,
 BCC iff_aster          \ boulder, asteroid or splinter, then jump to iff_aster
                        \ to set X = 2

                        \ If we get here then the ship is not the following:
                        \
                        \   * A cop/station/escape pod
                        \   * An innocent bystander/trader/good bounty hunter
                        \   * A missile
                        \   * Cargo or an asteroid
                        \
                        \ So it must be a pirate or a non-innocent bounty hunter

 INX                    \ X is &FF at this point, so this INX sets X = 0, and we
                        \ then fall through into the four INX instructions below
                        \ to set X = 4

.iff_missle

 INX                    \ If we jump to this point, then set X = 3

.iff_aster

 INX                    \ If we jump to this point, then set X = 2

.iff_cop

 INX                    \ If we jump to this point, then set X = 1

.iff_trade

 INX                    \ If we jump to this point, then set X = 0

.iff_not

 LDA iff_base,X         \ Set COL to the base colour for this ship, given the
 STA COL                \ I.F.F. colour index in X (this colour is used for both
                        \ the dot and stick)

 LDA iff_xor,X          \ Set Y2 to the alternating colour for this ship, given
 STA Y2                 \ the I.F.F. colour index in X (this colour is used for
                        \ making the stick striped, where appropriate)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 LDA INWK+1             \ If any of x_hi, y_hi and z_hi have a 1 in bit 6 or 7,
 ORA INWK+4             \ then the ship is too far away to be shown on the
 ORA INWK+7             \ scanner, so return from the subroutine (as SC5
 AND #%11000000         \ contains an RTS)
 BNE SC5

ELIF _MASTER_VERSION

 LDA INWK+1             \ If any of x_hi, y_hi and z_hi have a 1 in bit 6 or 7,
 ORA INWK+4             \ then the ship is too far away to be shown on the
 ORA INWK+7             \ scanner, so return from the subroutine (as SCR1
 AND #%11000000         \ contains an RTS)
 BNE SCR1

ENDIF

                        \ If we get here, we know x_hi, y_hi and z_hi are all
                        \ 63 (%00111111) or less

                        \ Now, we convert the x_hi coordinate of the ship into
                        \ the screen x-coordinate of the dot on the scanner,
                        \ using the following (see the deep dive on "The 3D
                        \ scanner" for an explanation):
                        \
                        \   X1 = 123 + (x_sign x_hi)

 LDA INWK+1             \ Set A = x_hi

 CLC                    \ Clear the C flag so we can do addition below

 LDX INWK+2             \ Set X = x_sign

 BPL SC2                \ If x_sign is positive, skip the following

 EOR #%11111111         \ x_sign is negative, so flip the bits in A and add 1
 ADC #1                 \ to make it a negative number (bit 7 will now be set
                        \ as we confirmed above that bits 6 and 7 are clear). So
                        \ this gives A the sign of x_sign and gives it a value
                        \ range of -63 (%11000001) to 0

IF _MASTER_VERSION \ Platform

 CLC                    \ Clear the C flag so we can do addition below

ENDIF

.SC2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Master: In most versions, ships that are exactly ahead of us or behind us are shown on the 3D scanner so the stick goes from the dot onto the centre line of the ellipse, but in the Master version the dot is moved over to the right so the stick goes from the dot just to the right of the centre line

 ADC #123               \ Set X1 = 123 + (x_sign x_hi)
 STA X1

ELIF _6502SP_VERSION

 ADC #123               \ Set A = 123 + (x_sign x_hi)

 STA SCANx1             \ Store the x-coordinate in SCANx1 so it can be sent
                        \ to the I/O processor with the #onescan command

ELIF _MASTER_VERSION

 ADC #125               \ Set X1 = 125 + (x_sign x_hi)
 AND #%11111110         \
 STA X1                 \ and if the result is odd, subtract 1 to make it even

 TAX                    \ Set X = X1 - 2
 DEX
 DEX

ENDIF

                        \ Next, we convert the z_hi coordinate of the ship into
                        \ the y-coordinate of the base of the ship's stick,
                        \ like this (see the deep dive on "The 3D scanner" for
                        \ an explanation):
                        \
                        \   SC = 220 - (z_sign z_hi) / 4
                        \
                        \ though the following code actually does it like this:
                        \
                        \   SC = 255 - (35 + z_hi / 4)

 LDA INWK+7             \ Set A = z_hi / 4
 LSR A                  \
 LSR A                  \ So A is in the range 0-15

 CLC                    \ Clear the C flag for the addition below

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 LDX INWK+8             \ Set X = z_sign

ELIF _MASTER_VERSION

 LDY INWK+8             \ Set Y = z_sign

ENDIF

 BPL SC3                \ If z_sign is positive, skip the following

 EOR #%11111111         \ z_sign is negative, so flip the bits in A and set the
 SEC                    \ C flag. As above, this makes A negative, this time
                        \ with a range of -16 (%11110000) to -1 (%11111111). And
                        \ as we are about to do an ADC, the SEC effectively adds
                        \ another 1 to that value, giving a range of -15 to 0

.SC3

 ADC #35                \ Set A = 35 + A to give a number in the range 20 to 50

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 EOR #%11111111         \ Flip all the bits and store in SC, so SC is in the
 STA SC                 \ range 205 to 235, with a higher z_hi giving a lower SC

ELIF _MASTER_VERSION

 EOR #%11111111         \ Flip all the bits and store in Y2, so Y2 is in the
 STA Y2                 \ range 205 to 235, with a higher z_hi giving a lower Y2

ENDIF

                        \ Now for the stick height, which we calculate using the
                        \ following (see the deep dive on "The 3D scanner" for
                        \ an explanation):
                        \
                        \ A = - (y_sign y_hi) / 2

 LDA INWK+4             \ Set A = y_hi / 2
 LSR A

 CLC                    \ Clear the C flag

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 LDX INWK+5             \ Set X = y_sign

ELIF _MASTER_VERSION

 LDY INWK+5             \ Set Y = y_sign

ENDIF

 BMI SCD6               \ If y_sign is negative, skip the following, as we
                        \ already have a positive value in A

 EOR #%11111111         \ y_sign is positive, so flip the bits in A and set the
 SEC                    \ C flag. This makes A negative, and as we are about to
                        \ do an ADC below, the SEC effectively adds another 1 to
                        \ that value to implement two's complement negation, so
                        \ we don't need to add another 1 here

.SCD6

                        \ We now have all the information we need to draw this
                        \ ship on the scanner, namely:
                        \
                        \   X1 = the screen x-coordinate of the ship's dot
                        \
                        \   SC = the screen y-coordinate of the base of the
                        \        stick
                        \
                        \   A = the screen height of the ship's stick, with the
                        \       correct sign for adding to the base of the stick
                        \       to get the dot's y-coordinate
                        \
                        \ First, though, we have to make sure the dot is inside
                        \ the dashboard, by moving it if necessary

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 ADC SC                 \ Set A = SC + A, so A now contains the y-coordinate of
                        \ the end of the stick, plus the length of the stick, to
                        \ give us the screen y-coordinate of the dot

ELIF _MASTER_VERSION

 ADC Y2                 \ Set A = Y2 + A, so A now contains the y-coordinate of
                        \ the end of the stick, plus the length of the stick, to
                        \ give us the screen y-coordinate of the dot

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Label

 BPL ld246              \ If the result has bit 0 clear, then the result has
                        \ overflowed and is bigger than 256, so jump to ld246 to
                        \ set A to the maximum allowed value of 246 (this
                        \ instruction isn't required as we test both the maximum
                        \ and minimum below, but it might save a few cycles)

ELIF _6502SP_VERSION

 BPL FIXIT              \ If the result has bit 0 clear, then the result has
                        \ overflowed and is bigger than 256, so jump to FIXIT to
                        \ set A to the maximum allowed value of 246 (this
                        \ instruction isn't required as we test both the maximum
                        \ and minimum below, but it might save a few cycles)

ENDIF

 CMP #194               \ If A >= 194, skip the following instruction, as 194 is
 BCS P%+4               \ the minimum allowed value of A

 LDA #194               \ A < 194, so set A to 194, the minimum allowed value
                        \ for the y-coordinate of our ship's dot

 CMP #247               \ If A < 247, skip the following instruction, as 246 is
 BCC P%+4               \ the maximum allowed value of A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Label

.ld246

ELIF _6502SP_VERSION

.FIXIT

ENDIF

 LDA #246               \ A >= 247, so set A to 246, the maximum allowed value
                        \ for the y-coordinate of our ship's dot

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Master: Group A: The Master version's 3D scanner draws a dash at the end of each stick (i.e. one pixel high, two pixels wide), while the other versions draw a full dot (i.e. two pixels high, two pixels wide)

 STA Y1                 \ Store A in Y1, as it now contains the screen
                        \ y-coordinate for the ship's dot, clipped so that it
                        \ fits within the dashboard

ELIF _6502SP_VERSION

 STA SCANy1             \ Store the y-coordinate in SCANy1 so it can be sent
                        \ to the I/O processor with the #onescan command

ELIF _MASTER_VERSION

 LDY #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STY VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 JSR CPIXK              \ Call CPIXK to draw a single-height dash at the
                        \ y-coordinate in A, and return the dash's right pixel
                        \ byte in R, which we use below

 LDA Y1                 \ Fetch the y-coordinate back into A, which was stored
                        \ in Y1 by the call to CPIX2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor
 SEC                    \ Set A = A - SC to get the stick length, by reversing
 SBC SC                 \ the ADC SC we did above. This clears the C flag if the
ELIF _MASTER_VERSION
 SEC                    \ Set A = A - Y2 to get the stick length, by reversing
 SBC Y2                 \ the ADC Y2 we did above. This clears the C flag if the
ENDIF
                        \ result is negative (i.e. the stick length is negative)
                        \ and sets it if the result is positive (i.e. the stick
                        \ length is negative)

                        \ So now we have the following:
                        \
                        \   X1 = the screen x-coordinate of the ship's dot,
                        \        clipped to fit into the dashboard
                        \
                        \   Y1 = the screen y-coordinate of the ship's dot,
                        \        clipped to fit into the dashboard
                        \
                        \   SC = the screen y-coordinate of the base of the
                        \        stick
                        \
                        \   A = the screen height of the ship's stick, with the
                        \       correct sign for adding to the base of the stick
                        \       to get the dot's y-coordinate
                        \
                        \   C = 0 if A is negative, 1 if A is positive
                        \
                        \ and we can get on with drawing the dot and stick

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Master: See group A

 PHP                    \ Store the flags (specifically the C flag) from the
                        \ above subtraction

ENDIF

IF _CASSETTE_VERSION \ Comment

\BCS SC48               \ These instructions are commented out in the original
\EOR #&FF               \ source. They would negate A if the C flag were set,
\ADC #1                 \ which would reverse the direction of all the sticks,
                        \ so you could turn your joystick around. Perhaps one of
                        \ the authors' test sticks were easier to use upside
                        \ down? Who knows...

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Master: See group A

.SC48

 PHA                    \ Store the stick height in A on the stack

 JSR CPIX4              \ Draw a double-height dot at (X1, Y1). This also leaves
                        \ the following variables set up for the dot's top-right
                        \ pixel, the last pixel to be drawn (as the dot gets
                        \ drawn from the bottom up):
                        \
                        \   SC(1 0) = screen address of the pixel's character
                        \             block
                        \
                        \   Y = number of the character row containing the pixel
                        \
                        \   X = the pixel's number (0-3) in that row
                        \
                        \ We can use there as the starting point for drawing the
                        \ stick, if there is one

ELIF _ELITE_A_6502SP_PARA

 TAX                    \ Copy the stick height in A into X

 LDA #&91               \ Send command &91 to the I/O processor:
 JSR tube_write         \
                        \   draw_tail(x, y, base_colour, alt_colour, height)
                        \
                        \ which will draw a ship on the 3D scanner with a dot
                        \ and stick of the specified height and colour, possibly
                        \ with stripes

 LDA X1                 \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * x1 = X1

 LDA Y1                 \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * y1 = Y1

 LDA COL                \ Send the third parameter to the I/O processor:
 JSR tube_write         \
                        \   * base_colour = COL

 LDA Y2                 \ Send the fourth parameter to the I/O processor:
 JSR tube_write         \
                        \   * alt_colour = Y2

 TXA                    \ Send the fifth parameter to the I/O processor:
 JSR tube_write         \
                        \   * height = the stick height that we stored in X

 LDX #0                 \ Set X = 0 to ensure we return the same value as the
                        \ SCAN routine in the non-Tube version

 RTS                    \ Return from the subroutine

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Master: See group A

 LDA CTWOS+1,X          \ Load the same mode 5 1-pixel byte that we just used
 AND COL                \ for the top-right pixel, and mask it with the same
 STA X1                 \ colour, storing the result in X1, so we can use it as
                        \ the character row byte for the stick

 PLA                    \ Restore the stick height from the stack into A

ELIF _ELECTRON_VERSION

 LDA TWOS,X             \ Load the same mode 4 1-pixel byte that we just used
 STA X1                 \ for the top-right pixel and store it in X1, so we can
                        \ use it as the character row byte for the stick

 PLA                    \ Restore the stick height from the stack into A

ELIF _ELITE_A_FLIGHT

 LDA CTWOS+1,X          \ Load the same mode 5 1-pixel byte that we just used
 TAX                    \ and make a copy in X

 AND COL                \ Mask the 1-pixel byte with the same colour, storing
 STA X1                 \ the result in X1, so we can use it as the character
                        \ rowbyte for the stick

 TXA                    \ Mask the 1-pixel byte with the colour in Y2, which
 AND Y2                 \ we set to the alternating colour for the stick, and
 STA Y1                 \ store the result in Y1

 PLA                    \ Restore the stick height from the stack into A

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Tube

 PLP                    \ Restore the flags from above, so the C flag once again
                        \ reflects the sign of the stick height

 TAX                    \ Copy the stick height into X

 BEQ RTS                \ If the stick height is zero, then there is no stick to
                        \ draw, so return from the subroutine (as RTS contains
                        \ an RTS)

 BCC RTS+1              \ If the C flag is clear then the stick height in A is
                        \ negative, so jump down to RTS+1

.VLL1

                        \ If we get here then the stick length is positive (so
                        \ the dot is below the ellipse and the stick is above
                        \ the dot, and we need to draw the stick upwards from
                        \ the dot)

 DEY                    \ We want to draw the stick upwards, so decrement the
                        \ pixel row in Y

 BPL VL1                \ If Y is still positive then it correctly points at the
                        \ line above, so jump to VL1 to skip the following

 LDY #7                 \ We just decremented Y up through the top of the
                        \ character block, so we need to move it to the last row
                        \ in the character above, so set Y to 7, the number of
                        \ the last row

ELIF _ELITE_A_FLIGHT

 TAX                    \ Copy the stick height into X

 BEQ RTS                \ If the stick height is zero, then there is no stick to
                        \ draw, so return from the subroutine (as RTS contains
                        \ an RTS)

 BMI RTS+1              \ If the stick height in A is negative, jump down to
                        \ RTS+1

.VLL1

                        \ If we get here then the stick length is positive (so
                        \ the dot is below the ellipse and the stick is above
                        \ the dot, and we need to draw the stick upwards from
                        \ the dot)

 DEY                    \ We want to draw the stick upwards, so decrement the
                        \ pixel row in Y

 BPL VL1                \ If Y is still positive then it correctly points at the
                        \ line above, so jump to VL1 to skip the following

 LDY #7                 \ We just decremented Y up through the top of the
                        \ character block, so we need to move it to the last row
                        \ in the character above, so set Y to 7, the number of
                        \ the last row

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Screen

 DEC SC+1               \ Decrement the high byte of the screen address to move
                        \ to the character block above

ELIF _ELECTRON_VERSION

                        \ We now need to move up into the character block above,
                        \ and each character row in screen memory takes up &140
                        \ bytes (&100 for the visible part and &20 for each of
                        \ the blank borders on the side of the screen), so
                        \ that's what we need to subtract from SC(1 0)

 LDA SC                 \ Set SC(1 0) = SC(1 0) - &140
 SEC                    \
 SBC #&40               \ Starting with the low bytes
 STA SC

 LDA SC+1               \ And then subtracting the high bytes
 SBC #&01
 STA SC+1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Tube

.VL1

 LDA X1                 \ Set A to the character row byte for the stick, which
                        \ we stored in X1 above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

ENDIF

IF _ELITE_A_FLIGHT

 EOR Y1                 \ Apply the alternating colour in Y1 to the stick

 STA X1                 \ Update the value in X1 so the alternating colour is
                        \ applied every other row (as doing an EOR twice
                        \ reverses it)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Tube

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y             \ EOR logic

 DEX                    \ Decrement the (positive) stick height in X

 BNE VLL1               \ If we still have more stick to draw, jump up to VLL1
                        \ to draw the next pixel

.RTS

 RTS                    \ Return from the subroutine

                        \ If we get here then the stick length is negative (so
                        \ the dot is above the ellipse and the stick is below
                        \ the dot, and we need to draw the stick downwards from
                        \ the dot)

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Electron: The dashboard in the Electron version might be monochrome, but it has a higher resolution than the colour versions, so the code to draw ships on the scanner varies accordingly

 INY                    \ We want to draw the stick downwards, so we first
                        \ increment the row counter so that it's pointing to the
                        \ bottom-right pixel in the dot (as opposed to the top-
                        \ right pixel that the call to CPIX4 finished on)

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE P%+6               \ correctly points at the next line down, so jump to
                        \ VLL2 to skip the following

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

 INC SC+1               \ Increment the high byte of the screen address to move
                        \ to the character block above

.VLL2

 INY                    \ We want to draw the stick itself, heading downwards,
                        \ so increment the pixel row in Y

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE VL2                \ correctly points at the next line down, so jump to
                        \ VL2 to skip the following

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

 INC SC+1               \ Increment the high byte of the screen address to move
                        \ to the character block above

.VL2

 LDA X1                 \ Set A to the character row byte for the stick, which
                        \ we stored in X1 above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y             \ EOR logic

 INX                    \ Increment the (negative) stick height in X

 BNE VLL2               \ If we still have more stick to draw, jump up to VLL2
                        \ to draw the next pixel

 RTS                    \ Return from the subroutine

ELIF _ELECTRON_VERSION

 JSR VL2                \ Call VL2 below to increment Y, moving to the next row
                        \ if necessary

.VLL2

 JSR VL2                \ Call VL2 below to increment Y, moving to the next row
                        \ if necessary

 LDA X1                 \ Set A to the character row byte for the stick, which
                        \ we stored in X1 above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y             \ EOR logic

 INX                    \ Increment the (negative) stick height in X

 BNE VLL2               \ If we still have more stick to draw, jump up to VLL2
                        \ to draw the next pixel

 RTS                    \ Return from the subroutine

.VL2

 INY                    \ We want to draw the stick itself, heading downwards,
                        \ so increment the pixel row in Y

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE RTS                \ correctly points at the next line down, so return from
                        \ the subroutine (as RTS contains an RTS)

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

                        \ Fall through into NEXTR to move the address in SC(1 0)
                        \ to the next row and return from the subroutine using a
                        \ tail call

ELIF _6502SP_VERSION

 STA SCANlen            \ Store the stick height in SCANlen so it can be sent
                        \ to the I/O processor with the #onescan command

 ROR SCANflg            \ Rotate the C flag into bit 7 of SCANflg, so bit 7 is
                        \ the sign bit of the stick length

.SC48

 LDX #LO(SCANpars)      \ Set (Y X) to point to the SCANpars parameter block
 LDY #HI(SCANpars)

 LDA #onescan           \ Send a #onescan command to the I/O processor to draw
 JMP OSWORD             \ the ship on the scanner, returning from the subroutine
                        \ using a tail call

ELIF _MASTER_VERSION

 BEQ VLO5               \ If the stick height is zero, then there is no stick to
                        \ draw, so return from the subroutine (as VLO5 contains
                        \ an RTS)

 BCC VLO1               \ If the C flag is clear then the stick height in A is
                        \ negative, so jump down to RTS+1

 TAX                    \ Copy the (positive) stick height into X

 INX                    \ Increment the (positive) stick height in X

 JMP VLO4               \ Jump into the middle of the VLOL1 loop, skipping the
                        \ drawing of first pixel in the stick

.VLOL1

 LDA R                  \ The call to CPIX2 above saved the dash's right pixel
                        \ byte in R, so we load this into A (so the stick comes
                        \ out of the right side of the dot)

 EOR (SC),Y             \ Draw the bottom row of the double-height dot using the
 STA (SC),Y             \ same byte as the top row, plotted using EOR logic

.VLO4

                        \ If we get here then the stick length is positive (so
                        \ the dot is below the ellipse and the stick is above
                        \ the dot, and we need to draw the stick upwards from
                        \ the dot)

 DEY                    \ We want to draw the stick upwards, so decrement the
                        \ pixel row in Y

 BPL VLO3               \ If Y is still positive then it correctly points at the
                        \ line above, so jump to VLO3 to skip the following

 LDA SC+1               \ Subtract 2 from the high byte of the screen address to
 SBC #2                 \ move to the character block above
 STA SC+1

 LDY #7                 \ We just decremented Y up through the top of the
                        \ character block, so we need to move it to the last row
                        \ in the character above, so set Y to 7, the number of
                        \ the last row

.VLO3

 DEX                    \ Decrement the (positive) stick height in X

 BNE VLOL1              \ If we still have more stick to draw, jump up to VLOL1
                        \ to draw the next pixel

.VLO5

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 RTS                    \ Return from the subroutine

.VLO1

                        \ If we get here then the stick length is negative (so
                        \ the dot is above the ellipse and the stick is below
                        \ the dot, and we need to draw the stick downwards from
                        \ the dot)

 LDA Y2                 \ Set A = Y2 - Y1 to get the positive stick height
 SEC
 SBC Y1

 TAX                    \ Copy the (positive) stick height into X

 INX                    \ Increment the (positive) stick height in X

 JMP VLO6               \ Jump into the middle of the VLOL2 loop, skipping the
                        \ drawing of first pixel in the stick

.VLOL2

 LDA R                  \ The call to CPIX2 above saved the dash's right pixel
                        \ byte in R, so we load this into A (so the stick comes
                        \ out of the right side of the dot)

 EOR (SC),Y             \ Draw the bottom row of the double-height dot using the
 STA (SC),Y             \ same byte as the top row, plotted using EOR logic

.VLO6

 INY                    \ We want to draw the stick itself, heading downwards,
                        \ so increment the pixel row in Y

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE VLO7               \ correctly points at the next line down, so jump to
                        \ VLO7 to skip the following

 LDA SC+1               \ We just incremented Y down through the bottom of the
 ADC #1                 \ character block, so increment the high byte of the
 STA SC+1               \ screen address to move to the character block above

 LDY #0                 \ We need to move to the first row in the character
                        \ below, so set Y to 0, the number of the first row

.VLO7

 DEX                    \ Decrement the (positive) stick height in X

 BNE VLOL2              \ If we still have more stick to draw, jump up to VLOL2
                        \ to draw the next pixel

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_FLIGHT

 INY                    \ We want to draw the stick downwards, so we first
                        \ increment the row counter so that it's pointing to the
                        \ bottom-right pixel in the dot (as opposed to the top-
                        \ right pixel that the call to CPIX4 finished on)

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE P%+6               \ correctly points at the next line down, so jump to
                        \ VLL2 to skip the following

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

 INC SC+1               \ Increment the high byte of the screen address to move
                        \ to the character block above

.VLL2

 INY                    \ We want to draw the stick itself, heading downwards,
                        \ so increment the pixel row in Y

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE VL2                \ correctly points at the next line down, so jump to
                        \ VL2 to skip the following

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

 INC SC+1               \ Increment the high byte of the screen address to move
                        \ to the character block above

.VL2

 LDA X1                 \ Set A to the character row byte for the stick, which
                        \ we stored in X1 above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

 EOR Y1                 \ Apply the alternating colour in Y1 to the stick

 STA X1                 \ Update the value in X1 so the alternating colour is
                        \ applied every other row (as doing an EOR twice
                        \ reverses it)

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y             \ EOR logic

 INX                    \ Increment the (negative) stick height in X

 BNE VLL2               \ If we still have more stick to draw, jump up to VLL2
                        \ to draw the next pixel

 RTS                    \ Return from the subroutine

ENDIF

