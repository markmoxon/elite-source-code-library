\ ******************************************************************************
\
\       Name: ChooseLanguage
\       Type: Subroutine
\   Category: Start and end
\    Summary: Draw the Start screen and process the language choice
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K%                  The value of the second counter (we start the demo on
\                       auto-play once all three counters have run down without
\                       a choice being made)
\
\   K%+1                The value of the third counter (we start the demo on
\                       auto-play once all three counters have run down without
\                       a choice being made)
\
\ ******************************************************************************

.ChooseLanguage

 LDA #HI(iconBarImage0) \ Set iconBarImageHi to the high byte of the image data
 STA iconBarImageHi     \ for icon bar type 0 (Docked)

 LDY #0                 \ Clear bit 7 of autoPlayDemo so we do not play the demo
 STY autoPlayDemo       \ automatically (so the player plays the demo instead)

 JSR SetLanguage        \ Set the language-related variables to language 0
                        \ (English) as Y = 0, so English is the default language

 LDA #&CF               \ Clear the screen and set the view type in QQ11 to &CF
 JSR TT66_b0            \ (Start screen with no fonts loaded)

 LDA #HI(iconBarImage3) \ Set iconBarImageHi to the high byte of the image data
 STA iconBarImageHi     \ for icon bar type 3 (Pause)

 LDA #0                 \ Move the text cursor to row 0
 STA YC

 LDA #7                 \ Move the text cursor to column 7
 STA XC

 LDA #3                 \ Set A = 3 so the next instruction prints extended
                        \ token 3

IF _PAL

 JSR DETOK_b2           \ Print extended token 3 ("{sentence case}{single cap}
                        \ IMAGINEER {single cap}PRESENTS")

ENDIF

 LDA #&DF               \ Set the view type in QQ11 to &DF (Start screen with
 STA QQ11               \ the normal font loaded)

 JSR DrawBigLogo_b4     \ Set the pattern and nametable buffer entries for the
                        \ big Elite logo

 LDA #36                \ Set asciiToPattern = 36, so we add 36 to an ASCII code
 STA asciiToPattern     \ in the CHPR routine to get the pattern number in the
                        \ PPU of the corresponding character image (as the font
                        \ is at pattern 68 on the Start screen, and the font
                        \ starts with a space character, which is ASCII 32, and
                        \ 32 + 36 = 68)

 LDA #21                \ Move the text cursor to row 21
 STA YC

 LDA #10                \ Move the text cursor to column 10
 STA XC

 LDA #6                 \ Set A = 6 so the next instruction prints extended
                        \ token 6

IF _PAL

 JSR DETOK_b2           \ Print extended token 6 ("{single cap}LICENSED{cr} TO")

ENDIF

 INC YC                 \ Move the text cursor to row 22

 LDA #3                 \ Move the text cursor to column 3
 STA XC

 LDA #9                 \ Set A = 9 so the next instruction prints extended
                        \ token 9

IF _PAL

 JSR DETOK_b2           \ Print extended token 9 ("{single cap}IMAGINEER {single
                        \ cap}CO. {single cap}LTD., {single cap}JAPAN")

ENDIF

 LDA #25                \ Move the text cursor to row 25
 STA YC

 LDA #3                 \ Move the text cursor to column 3
 STA XC

 LDA #12                \ Print extended token 12 ("({single cap}C) {single cap}
 JSR DETOK_b2           \ D.{single cap}BRABEN & {sentence case}I.{single cap}
                        \ BELL 1991")

 LDA #26                \ Move the text cursor to row 26
 STA YC

 LDA #6                 \ Move the text cursor to column 6
 STA XC

 LDA #7                 \ Set A = 7 so the next instruction prints extended
                        \ token 7

IF _PAL

 JSR DETOK_b2           \ Print extended token 7 ("{single cap}LICENSED BY
                        \  {single cap}NINTENDO")

ENDIF

                        \ We now draw the bottom of the box that goes around the
                        \ edge of the title screen, with the bottom line on tile
                        \ row 28 and an edge on either side of row 27

 LDY #2                 \ First we draw the horizontal line from tile 2 to 31 on
                        \ row 28, so set a tile index in Y

 LDA #229               \ Set A to the pattern to use for the bottom of the box,
                        \ which is in pattern 229

.clan1

 STA nameBuffer0+28*32,Y    \ Set tile Y on row 28 to pattern 229

 INY                    \ Increment the tile index

 CPY #32                \ Loop back until we have drawn from tile index 2 to 31
 BNE clan1

                        \ Next we draw the corners and the tiles above the
                        \ corners

 LDA #2                 \ Draw the bottom-right box corner and the tile above
 STA nameBuffer0+27*32
 STA nameBuffer0+28*32

 LDA #1                 \ Draw the bottom-left box corner and the tile above
 STA nameBuffer0+27*32+1
 STA nameBuffer0+28*32+1

                        \ We now display the language names so the player can
                        \ make their choice

 LDY #0                 \ We now work our way through the available languages,
                        \ starting with language 0, so set a language counter
                        \ in Y

.clan2

 JSR SetLanguage        \ Set the language-related variables to language Y

 LDA xLanguage,Y        \ Move the text cursor to the correct column for the
 STA XC                 \ language Y button, taken from the xLanguage table

 LDA yLanguage,Y        \ Move the text cursor to the correct row for the
 STA YC                 \ language Y button, taken from the yLanguage table

 LDA #%00000000         \ Set DTW8 = %00000000 (capitalise the next letter)
 STA DTW8

 LDA #4                 \ Print extended token 4, which is the language name,
 JSR DETOK_b2           \ so when Y = 0 it will be "{single cap}ENGLISH", for
                        \ example

 INC XC                 \ Move the text cursor two characters to the right
 INC XC

 INY                    \ Increment the language counter in Y

 LDA languageIndexes,Y  \ If the language index for language Y has bit 7 clear
 BPL clan2              \ then this is a valid language, so loop back to clan2
                        \ to print this language's name (language 3 has a value
                        \ of &FF in the languageIndexes table, so we only print
                        \ names for languages 0, 1 and 2)

 STY systemNumber       \ Set the current system number in systemNumber to 3,
                        \ though this doesn't appear to be used anywhere (this
                        \ normally stores the current system number for use in
                        \ the PDESC routine for printing extended system
                        \ descriptions, but it gets reset before we get that
                        \ far, so this appears to have no effect)

 LDA #HI(iconBarImage3) \ Set iconBarImageHi to the high byte of the image data
 STA iconBarImageHi     \ for icon bar type 3 (Pause)

 JSR UpdateView_b0      \ Update the view

 LDA controller1Left    \ If any of the left button, up button, Select or B are
 AND controller1Up      \ not being pressed on the controller, jump to clan3
 AND controller1Select
 AND controller1B
 BPL clan3

 LDA controller1Right   \ If any of the right button, down button, Start or A
 ORA controller1Down    \ are being pressed on the controller, jump to clan3
 ORA controller1Start
 ORA controller1A
 BMI clan3

                        \ If we get here then we are pressing the right button,
                        \ down button, Start and A, and we are not pressing any
                        \ of the other keys

 JSR ResetSaveSlots     \ Reset all eight save slots so they fail their
                        \ checksums, so the following call to CheckSaveSlots
                        \ resets then all to the default commander

.clan3

 JSR CheckSaveSlots_b6  \ Load the commanders for all eight save slots, one
                        \ after the other, to check their integrity and reset
                        \ any that fail their checksums

                        \ We now highlight the currently selected language name
                        \ on-screen

 LDA #%10000000         \ Set bit 7 of S to indicate that the choice has not yet
 STA S                  \ been made (we will clear bit 7 when Start is pressed
                        \ and release, which makes the choice)

IF _NTSC

 LDA #25                \ Set T = 25
 STA T                  \
                        \ This is the value of the first counter (we start the
                        \ demo on auto-play once all three counters have run
                        \ down without a choice being made)

ELIF _PAL

 LDA #250               \ Set T = 250
 STA T                  \
                        \ This is the value of the first counter (we start the
                        \ demo on auto-play once all three counters have run
                        \ down without a choice being made)

ENDIF

 LDA K%+1               \ Set V+1 = K%+1
 STA V+1                \
                        \ We set K%+1 to 60 in the BEGIN routine when the game
                        \ first started
                        \
                        \ We set K%+1 to 5 if we get here after waiting at the
                        \ title screen for too long
                        \
                        \ This is the value of the third counter (we start the
                        \ demo on auto-play once all three counters have run
                        \ down without a choice being made)

 LDA #0                 \ Set V = 0
 STA V                  \
                        \ This is the value of the second counter (we start the
                        \ demo on auto-play once all three counters have run
                        \ down without a choice being made)
                        \
                        \ As the counter is decremented before checking whether
                        \ it is zero, this means the second counter counts down
                        \ 256 times


 STA Q                  \ Set Q = 0 (though this value is not read, so this has
                        \ no effect)

 LDA K%                 \ Set LASCT = K%
 STA LASCT              \
                        \ We set K% to 0 in the BEGIN routine when the game
                        \ first started
                        \
                        \ We set K% to languageIndex if we get here after
                        \ waiting at the title screen for too long
                        \
                        \ We use LASCT to keep a track of the currently
                        \ highlighted language, so this sets the default
                        \ highlight to English (language 0)

.clan4

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

                        \ We now highlight the currently selected language name
                        \ on-screen by creating eight sprites containing a white
                        \ block, initially creating them off-screen, before
                        \ moving the correct number of sprites behind the
                        \ currently selected name, so each letter in the name
                        \ is highlighted

 LDY LASCT              \ Set Y to the currently highlighted language in LASCT

 LDA xLanguage,Y        \ Set A to the column number of the button for language
                        \ Y, taken from the xLanguage table

 ASL A                  \ Set X = A * 8
 ASL A                  \
 ASL A                  \ So X contains the pixel x-coordinate of the language
 ADC #0                 \ button, as each tile is eight pixels wide
 TAX

 CLC                    \ Clear the C flag so the addition below will work

 LDY #0                 \ We are about to set up the eight sprites that we use
                        \ to highlight the current language choice, using
                        \ sprites 5 to 12, so set an index counter in Y that we
                        \ can use to point to each sprite in the sprite buffer

.clan5

                        \ We now set the coordinates, tile and attributes for
                        \ the Y-th sprite, starting from sprite 5

 LDA #240               \ Set the sprite's y-coordinate to 240 to move it off
 STA ySprite5,Y         \ the bottom of the screen (which hides it)

 LDA #255               \ Set the sprite to pattern 255, which is a full white
 STA tileSprite5,Y      \ block

 LDA #%00100000         \ Set the attributes for this sprite as follows:
 STA attrSprite5,Y      \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 TXA                    \ Set the sprite's x-coordinate to X, which is the
 STA xSprite5,Y         \ x-coordinate for the current letter in the
                        \ language's button

 ADC #8                 \ Set X = X + 8
 TAX                    \
                        \ So X now contains the pixel x-coordinate of the next
                        \ letter in the language's button

 INY                    \ Set Y = Y + 4
 INY                    \
 INY                    \ So Y now points to the next sprite in the sprite
 INY                    \ buffer, as each sprite has four bytes in the buffer

 CPY #32                \ Loop back until we have set up all eight sprites for
 BNE clan5              \ the currently highlighted language

                        \ Now that we have created the eight sprites off-screen,
                        \ we move the correct number of then on-screen so they
                        \ display behind each letter of the currently
                        \ highlighted language name

 LDX LASCT              \ Set X to the currently highlighted language in LASCT

 LDA languageLength,X   \ Set Y to the number of characters in the currently
                        \ highlighted language's name, from the languageLength
                        \ table

 ASL A                  \ Set Y = A * 4
 ASL A                  \
 TAY                    \ So Y contains an index into the sprite buffer for the
                        \ last sprite that we need from the eight available (as
                        \ we need one sprite for each character in the name)

 LDA yLanguage,X        \ Set A to the row number of the button for language Y,
                        \ taken from the yLanguage table

 ASL A                  \ Set A = A * 8 + 6
 ASL A                  \
 ASL A                  \ So A contains the pixel y-coordinate of the language
 ADC #6+YPAL            \ button, as each tile row is eight pixels high, plus a
                        \ margin of 6

.clan6

 STA ySprite5,Y         \ Set the sprite's y-coordinate to A

 DEY                    \ Decrement the sprite number by 4 to point to the
 DEY                    \ sprite for the previous letter in the language name
 DEY
 DEY

 BPL clan6              \ Loop back until we have moved the sprite on-screen for
                        \ the first letter of the currently highlighted
                        \ language's name

 LDA controller1Start   \ If the Start button on controller 1 was being held
 AND #%11000000         \ down (bit 6 is set) but is no longer being held down
 CMP #%01000000         \ (bit 7 is clear) then keep going, otherwise jump to
 BNE clan7              \ clan7

 LSR S                  \ The Start button has been pressed and release, so
                        \ shift S right to clear bit 7

.clan7

 LDX LASCT              \ Set X to the currently highlighted language in LASCT

 LDA controller1Left    \ If the left button on controller 1 was being held
 AND #%11000000         \ down (bit 6 is set) but is no longer being held down
 CMP #%01000000         \ (bit 7 is clear) then keep going, otherwise jump to
 BNE clan8              \ clan8

 DEX                    \ Decrement the currently highlighted language to point
                        \ to the next language to the left

 LDA K%+1               \ Set V+1 = K%+1
 STA V+1                \
                        \ We already did this above, so this has no effect

.clan8

 LDA controller1Right   \ If the right button on controller 1 was being held
 AND #%11000000         \ down (bit 6 is set) but is no longer being held down
 CMP #%01000000         \ (bit 7 is clear) then keep going, otherwise jump to
 BNE clan9              \ clan9

 INX                    \ Increment the currently highlighted language to point
                        \ to the next language to the right

 LDA K%+1               \ Set V+1 = K%+1
 STA V+1                \
                        \ We already did this above, so this has no effect

.clan9

 TXA                    \ Set A to the currently selected language, which may or
                        \ may not have changed

 BPL clan10             \ If A is positive, jump to clan10 to skip the following
                        \ instruction

 LDA #0                 \ Set A = 0, so the minimum value of A is 0

.clan10

 CMP #3                 \ If A < 3, then jump to clan11 to skip the following
 BCC clan11             \ instruction

 LDA #2                 \ Set A = 2, so the maximum value of A is 2

.clan11

 STA LASCT              \ Set LASCT to the currently selected language

 DEC T                  \ Decrement the first counter in T

 BEQ clan13             \ If the counter in T has reached zero, jump to clan13
                        \ to check whether a choice has been made, and if not,
                        \ to count down the second and third counters

.clan12

 JMP clan4              \ Loop back to clan4 keep checking for the selection and
                        \ moving the highlight as required, until a choice is
                        \ made

.clan13

 INC T                  \ Increment the first counter in T so we jump here again
                        \ on the next run through the clan4 loop

 LDA S                  \ If bit 7 of S is clear then Start has been pressed and
 BPL SetChosenLanguage  \ released, so jump to SetChosenLanguage to set the
                        \ language-related variables according to the chosen
                        \ language, returning from the subroutine using a tail
                        \ call

 DEC V                  \ Decrement the second counter in V, and loop back to
 BNE clan12             \ repeat the clan4 loop until it is zero

 DEC V+1                \ Decrement the third counter in V+1, and loop back to
 BNE clan12             \ repeat the clan4 loop until it is zero

                        \ If we get here then no choice has been made and we
                        \ have run down the first, second and third counters, so
                        \ we now start the demo, with the computer auto-playing
                        \ it

 JSR SetChosenLanguage  \ Call SetChosenLanguage to set the language-related
                        \ variables according to the currently selected language
                        \ on-screen

 JMP SetDemoAutoPlay_b5 \ Start the demo and auto-play it by "pressing" keys
                        \ from the relevant key table (which will be different,
                        \ depending on which language is currently highlighted)
                        \ and return from the subroutine using a tail call

