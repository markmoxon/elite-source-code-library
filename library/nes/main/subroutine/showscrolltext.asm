\ ******************************************************************************
\
\       Name: ShowScrollText
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Show a scroll text and start the combat demo
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The scroll text to show:
\
\                         * 0 = show the first scroll text and start combat
\                               practice
\
\                         * 1 = show the second scroll text, including the time
\                               taken for combat practice
\
\                         * 2 = show the credits scroll text
\
\ ******************************************************************************

.ShowScrollText

 PHA                    \ Store the value of A on the stack so we can retrieve
                        \ it later to check which scroll text to show

 LDA QQ11               \ If this is not the space view, then jump to scro1 to
 BNE scro1              \ set up the space view for the demo

 JSR ClearScanner       \ This is already the space view, so remove all ships
                        \ from the scanner and hide the scanner sprites

 JMP scro4              \ Jump to scro4 to move on to the scroll text part, as
                        \ the view is already set up

.scro1

                        \ If we get here then we need to set up the space view
                        \ for the demo

 JSR FadeToBlack_b3     \ Fade the screen to black over the next four VBlanks

 LDY #NOST              \ Set Y to the number of stardust particles in NOST
                        \ (which is 20 in the space view), so we can use it as a
                        \ counter as we set up the stardust below

 STY NOSTM              \ Set the number of stardust particles to NOST (which is
                        \ 20 for the normal space view)

 STY RAND+1             \ Set RAND+1 to NOST to seed the random number generator

 LDA nmiCounter         \ Set the random number seed to a fairly random state
 STA RAND               \ that's based on the NMI counter (which increments
                        \ every VBlank, so will be pretty random)

.scro2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We now set up the coordinates of stardust particle Y

 JSR DORND              \ Set A and X to random numbers

 ORA #8                 \ Set A so that it's at least 8

 STA SZ,Y               \ Store A in the Y-th particle's z_hi coordinate at
                        \ SZ+Y, so the particle appears in front of us

 STA ZZ                 \ Set ZZ to the particle's z_hi coordinate

 JSR DORND              \ Set A and X to random numbers

 STA SX,Y               \ Store A in the Y-th particle's x_hi coordinate at
                        \ SX+Y, so the particle appears in front of us

 JSR DORND              \ Set A and X to random numbers

 STA SY,Y               \ Store A in the Y-th particle's y_hi coordinate at
                        \ SY+Y, so the particle appears in front of us

 DEY                    \ Decrement the counter to point to the next particle of
                        \ stardust

 BNE scro2              \ Loop back to scro2 until we have randomised all the
                        \ stardust particles

 LDX #NOST              \ Set X to the maximum number of stardust particles, so
                        \ we loop through all the particles of stardust in the
                        \ following

 LDY #152               \ Set Y to the starting index in the sprite buffer, so
                        \ we start configuring from sprite 152 / 4 = 38 (as each
                        \ sprite in the buffer consists of four bytes)

.scro3

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We now set up the sprite for stardust particle Y

 LDA #210               \ Set the sprite to use pattern number 210 for the
 STA pattSprite0,Y      \ largest particle of stardust (the stardust particle
                        \ patterns run from pattern 210 to 214, decreasing in
                        \ size as the number increases)

 TXA                    \ Take the particle number, which is between 1 and 20
 LSR A                  \ (as NOST is 20), and rotate it around from %76543210
 ROR A                  \ to %10xxxxx3 (where x indicates a zero), storing the
 ROR A                  \ result as the sprite attribute
 AND #%11100001         \
 STA attrSprite0,Y      \ This sets the flip horizontally and flip vertically
                        \ attributes to bits 0 and 1 of the particle number, and
                        \ the palette to bit 3 of the particle number, so the
                        \ reset stardust particles have a variety of reflections
                        \ and palettes

 INY                    \ Add 4 to Y so it points to the next sprite's data in
 INY                    \ the sprite buffer
 INY
 INY

 DEX                    \ Decrement the loop counter in X

 BNE scro3              \ Loop back until we have configured 20 sprites

 JSR STARS_b1           \ Call STARS1 to process the stardust for the front view

.scro4

 LDA #0                 \ Remove the laser from our ship, so we can't fire it
 STA LASER              \ during the scroll text

 STA QQ12               \ Set QQ12 = 0 to indicate that we are not docked

 LDA #&10               \ Clear the screen and set the view type in QQ11 to &10
 JSR ChangeToView_b0    \ (Space view with the normal font loaded)

 LDA #&FF               \ Set showIconBarPointer = &FF to indicate that we
 STA showIconBarPointer \ should show the icon bar pointer

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the sight sprites by
                        \ moving them off-screen

 STA ySprite5           \ Set the y-coordinates for the five laser sight sprites
 STA ySprite6           \ to 240, to move them off-screen
 STA ySprite7
 STA ySprite8
 STA ySprite9

                        \ We are going to draw the scroll text into the pattern
                        \ buffers, so now we calculate the addresses of the
                        \ first available tiles in the buffers

 LDA #0                 \ Set the high byte of SC(1 0) to 0
 STA SC+1

 LDA firstFreePattern   \ Set SC(1 0) = firstFreePattern * 8
 ASL A
 ROL SC+1               \ We use this to calculate the address of the pattern
 ASL A                  \ for the first free pattern in the pattern buffers
 ROL SC+1               \ below
 ASL A
 ROL SC+1
 STA SC

 STA SC2                \ Set SC2(1 0) = pattBuffer1 + SC(1 0)
 LDA SC+1               \              = pattBuffer1 + firstFreePattern * 8
 ADC #HI(pattBuffer1)   \
 STA SC2+1              \ So SC2(1 0) contains the address of the pattern of the
                        \ first free tile in pattern buffer 1, as each pattern
                        \ in the buffer contains eight bytes

 LDA SC+1               \ Set SC(1 0) = pattBuffer0 + SC(1 0)
 ADC #HI(pattBuffer0)   \             = pattBuffer0 + firstFreePattern * 8
 STA SC+1               \
                        \ So SC2(1 0) contains the address of the pattern of the
                        \ first free tile in pattern buffer 0

                        \ We now clear the patterns in both pattern buffers for
                        \ the free tile and all the other tiles to the end of
                        \ the buffers

 LDX firstFreePattern   \ Set X to the number of the first free pattern so we
                        \ start clearing patterns from this point onwards

 LDY #0                 \ Set Y to use as a byte index for zeroing the pattern
                        \ bytes in the pattern buffers

.scro5

 LDA #0                 \ Set A = 0 so we zero the pattern

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 STA (SC),Y             \ Zero the Y-th pixel row of pattern X in both of the
 STA (SC2),Y            \ pattern buffers and increment the index in Y
 INY

 BNE scro6              \ If Y just incremented to 0, increment the high bytes
 INC SC+1               \ of SC(1 0) and SC2(1 0) so they point to the next page
 INC SC2+1              \ in memory

.scro6

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 INX                    \ Increment the pattern number in X

 BNE scro5              \ Loop back until we have cleared all patterns up to and
                        \ including pattern 255

 LDA #0                 \ Set ALPHA and ALP1 to 0, so our roll angle is 0
 STA ALPHA
 STA ALP1

 STA DELTA              \ Set our ship's speed to zero so the scroll text stays
                        \ where it is

 LDA nmiCounter         \ Set the random number seed to a fairly random state
 CLC                    \ that's based on the NMI counter (which increments
 ADC RAND+1             \ every VBlank, so will be pretty random)
 STA RAND+1

 JSR DrawScrollInNMI    \ Configure the NMI handler to draw the scroll text
                        \ screen, which will clear the screen as we just blanked
                        \ out all the patterns in the pattern buffers

 PLA                    \ Retrieve the argument that we stored on the stack at
 BNE scro7              \ the start of the routine, which contains the scroll
                        \ text that we should be showing and if it is non-zero,
                        \ jump to scro7 to skip playing the combat part of the
                        \ demo, as we are either showing the results of combat
                        \ practice, or we are showing the credits

                        \ If we get here then A = 0 and we are show the first
                        \ scroll text before starting the combat demo

 LDX languageIndex      \ Set (Y X) to the address of the text for the first
 LDA scrollText1Lo,X    \ scroll text for the chosen language
 LDY scrollText1Hi,X
 TAX

 LDA #2                 \ Draw the first scroll text at scrollText1, which has
 JSR DrawScrollText     \ six lines (so we set A = 2, as it needs to contain
                        \ the number of lines minus 4)

                        \ We are now ready to start the combat part of the
                        \ combat demo

 LDA #&00               \ Set the view type in QQ11 to &00 (Space view with
 STA QQ11               \ no fonts loaded)

 JSR SetLinePatterns_b3 \ Load the line patterns for the new view into the
                        \ pattern buffers

 LDA #37                \ Tell the NMI handler to send pattern entries from
 STA firstPattern       \ pattern 37 in the buffer

 JSR DrawScrollInNMI    \ Configure the NMI handler to draw the scroll text
                        \ screen, which will draw the scroll text on-screen

 LDA #60                \ Tell the NMI handler to send pattern entries from
 STA firstPattern       \ pattern 60 in the buffer

 JMP PlayDemo_b0        \ Play the combat demo, returning from the subroutine
                        \ using a tail call

.scro7

 CMP #2                 \ If we called this routine with A = 2 then jump to
 BEQ scro14             \ scro14 to show the credits scroll text

                        \ Otherwise A = 1, so we show the second scroll text,
                        \ including the time taken for combat practice, so we
                        \ start by calculating the time taken and storing the
                        \ results in K5, so the GRIDSET routine can draw the
                        \ correct characters for the time taken
                        \
                        \ Specifically, the second scroll text in scrollText2
                        \ expects the characters to be set as follows:
                        \
                        \   * &83 is the first digit of the minutes
                        \
                        \   * &82 is the second digit of the minutes
                        \
                        \   * &81 is the first digit of the seconds
                        \
                        \   * &80 is the second digit of the seconds
                        \
                        \ while GRIDSET expect to find these values at the
                        \ following locations:
                        \
                        \   * Character &83 refers to location K5+3
                        \
                        \   * Character &82 refers to location K5+2
                        \
                        \   * Character &81 refers to location K5+1
                        \
                        \   * Character &80 refers to location K5
                        \
                        \ Finally, the number of seconds that we need to display
                        \ is in (nmiTimerHi nmiTimerLo), so we need to convert
                        \ this into minutes and seconds, and then set the values
                        \ in K5 to the correct ASCII characters that represent
                        \ the digits of this time

 LDA #'0'               \ Set all the digits to 0 except the second digit of the
 STA K5+1               \ seconds (as we will set this later)
 STA K5+2
 STA K5+3

 LDA #100               \ Set nmiTimer = 100 so (nmiTimerHi nmiTimerLo) will not
 STA nmiTimer           \ change during the following calculation (as nmiTimer
                        \ has to tick down to zero for that to happen, so this
                        \ gives us 100 VBlanks to complete the calculation
                        \ before (nmiTimerHi nmiTimerLo) changes)

                        \ We start with the first digit of the minute count (the
                        \ "tens" digit)

 SEC                    \ Set the C flag for the following subtraction

.scro8

 LDA nmiTimerLo         \ Set (A X) = (nmiTimerHi nmiTimerLo) - &0258
 SBC #&58               \           = (nmiTimerHi nmiTimerLo) - 600
 TAX
 LDA nmiTimerHi
 SBC #&02

 BCC scro9              \ If the subtraction underflowed then we know that
                        \ (nmiTimerHi nmiTimerLo) < 600, so jump to scro9 to
                        \ move on to the next digit

                        \ If we get here then (nmiTimerHi nmiTimerLo) >= 600,
                        \ so the time in (nmiTimerHi nmiTimerLo) is at least
                        \ ten minutes, so we increment the first digit of the
                        \ minute count in K5+3, update the time in
                        \ (nmiTimerHi nmiTimerLo) to (A X), and loop back to
                        \ try subtracting another 10 minutes

 STA nmiTimerHi         \ Set (nmiTimerHi nmiTimerLo) = (A X)
 STX nmiTimerLo         \
                        \ So this updates (nmiTimerHi nmiTimerLo) with the new
                        \ value, which is ten minutes less than the original
                        \ value

 INC K5+3               \ Increment the first digit of the minute count in K5+3
                        \ to bump it up from, say, "0" to "1"

 BCS scro8              \ Loop back to scro8 to try subtracting another ten
                        \ minutes (this BCS is effectively a JMP as we just
                        \ passed through a BCC)

.scro9

                        \ Now for the second digit of the minute count (the
                        \ "ones" digit)

 SEC                    \ Set the C flag for the following subtraction

 LDA nmiTimerLo         \ Set (A X) = (nmiTimerHi nmiTimerLo) - &003C
 SBC #&3C               \           = (nmiTimerHi nmiTimerLo) - 60
 TAX
 LDA nmiTimerHi
 SBC #&00

 BCC scro10             \ If the subtraction underflowed then we know that
                        \ (nmiTimerHi nmiTimerLo) < 60, so jump to scro10 to
                        \ move on to the next digit

                        \ If we get here then (nmiTimerHi nmiTimerLo) >= 60,
                        \ so the time in (nmiTimerHi nmiTimerLo) is at least
                        \ one minute, so we increment the second digit of the
                        \ minute count in K5+2, update the time in
                        \ (nmiTimerHi nmiTimerLo) to (A X), and loop back to
                        \ try subtracting another minute

 STA nmiTimerHi         \ Set (nmiTimerHi nmiTimerLo) = (A X)
 STX nmiTimerLo         \
                        \ So this updates (nmiTimerHi nmiTimerLo) with the new
                        \ value, which is one minute less than the original
                        \ value

 INC K5+2               \ Increment the second digit of the minute count in K5+2
                        \ to bump it up from, say, "0" to "1"

 BCS scro9              \ Loop back to scro8 to try subtracting another minute
                        \ (this BCS is effectively a JMP as we just passed
                        \ through a BCC)

.scro10

                        \ Now for the first digit of the second count (the
                        \ "tens" digit)
                        \
                        \ By this point we know that (nmiTimerHi nmiTimerLo) is
                        \ less than 60, so we can ignore the high byte as it is
                        \ zero by now

 SEC                    \ Set the C flag for the following subtraction

 LDA nmiTimerLo         \ Set A to the number of seconds we want to display

.scro11

 SBC #10                \ Set A = nmiTimerLo - 10

 BCC scro12             \ If the subtraction underflowed then we know that
                        \ nmiTimerLo < 10, so jump to scro12 to move on to the
                        \ final digit

                        \ If we get here then nmiTimerLo >= 10, so the time in
                        \ nmiTimerLo is at least ten seconds, so we increment
                        \ the first digit of the seconds count in K5+1 and loop
                        \ back to try subtracting another ten seconds

 INC K5+1               \ Increment the first digit of the seconds count in K5+1
                        \ to bump it up from, say, "0" to "1"

 BCS scro11             \ Loop back to scro8 to try subtracting another ten
                        \ seconds (this BCS is effectively a JMP as we just
                        \ passed through a BCC)

.scro12

                        \ By this point A contains the number of seconds left
                        \ after subtracting the final ten seconds, so it is
                        \ ten less than the value we want to display

 ADC #'0'+10            \ Set the character for the second digit of the seconds
 STA K5                 \ count in K5 to the value in A, plus the ten that we
                        \ subtracted before we jumped here, plus ASCII "0" to
                        \ convert it into a character

                        \ Now that the practice time is set up, we can show the
                        \ second scroll text to report the results

 LDX languageIndex      \ Set (Y X) to the address of the text for the second
 LDA scrollText2Lo,X    \ scroll text for the chosen language
 LDY scrollText2Hi,X
 TAX

 LDA #6                 \ We are now going to draw the second scroll text
                        \ at scrollText2, which has ten lines, so we set
                        \ A = 6 to pass to DrawScrollText, as it needs to
                        \ contain the number of lines minus 4

.scro13

 JSR DrawScrollText     \ Draw the scroll text at (Y X), which will either be
                        \ the second scroll text at scrollText2 or the third
                        \ credits scroll text at creditsText3, depending on how
                        \ we get here

 JSR FadeToBlack_b3     \ Fade the screen to black over the next four VBlanks

 JMP StartGame_b0       \ Jump to StartGame to reset the stack and go to the
                        \ docking bay (i.e. show the Status Mode screen)

.scro14

                        \ If we get here then we show the credits scroll text,
                        \ which is in three parts

 LDX languageIndex      \ Set (Y X) to the address of the text for the first
 LDA creditsText1Lo,X   \ credits scroll text for the chosen language
 LDY creditsText1Hi,X
 TAX

 LDA #6                 \ Draw the first credits scroll text at creditsText1,
 JSR DrawScrollText     \ which has ten lines (so we set A = 6, as it needs to
                        \ contain the number of lines minus 4)

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDX languageIndex      \ Set (Y X) to the address of the text for the second
 LDA creditsText2Lo,X   \ credits scroll text for the chosen language
 LDY creditsText2Hi,X
 TAX

 LDA #5                 \ Draw the second credits scroll text at creditsText2,
 JSR DrawScrollText     \ which has nine lines (so we set A = 5, as it needs to
                        \ contain the number of lines minus 4)

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDX languageIndex      \ Set (Y X) to the address of the text for the third
 LDA creditsText3Lo,X   \ credits scroll text for the chosen language
 LDY creditsText3Hi,X
 TAX

 LDA #3                 \ We are now going to draw the third credits scroll text
                        \ at creditsText3, which has seven lines, so we set
                        \ A = 3 to pass to DrawScrollText, as it needs to
                        \ contain the number of lines minus 4

 BNE scro13             \ Jump to scro13 to draw the third credits scroll text
                        \ at creditsText3 (this BNE is effectively a JMP as A is
                        \ never zero

