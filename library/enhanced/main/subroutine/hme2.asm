\ ******************************************************************************
\
\       Name: HME2
\       Type: Subroutine
\   Category: Charts
\    Summary: Search the galaxy for a system
\
\ ******************************************************************************

.HME2

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

IF NOT(_NES_VERSION)

 LDA #14                \ Print extended token 14 ("{clear bottom of screen}
 JSR DETOK              \ PLANET NAME?{fetch line input from keyboard}"). The
                        \ last token calls MT26, which puts the entered search
                        \ term in INWK+5 and the term length in Y

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

ELIF _NES_VERSION

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 LDA #14                \ Print extended token 14 ("{clear bottom of screen}
 JSR DETOK_b2           \ PLANET NAME?{fetch line input from keyboard}"). The
                        \ last token calls MT26, which puts the entered search
                        \ term in INWK+5 and the term length in Y

 LDY #9                 \ We start by setting the default name to all A's in the
                        \ buffer at INWK+5, which is where the InputName routine
                        \ expects to find the default name to show, so set a
                        \ counter in Y for ten characters

 STY inputNameSize      \ Set inputNameSize = 9 so we fetch a system name with a
                        \ maximum size of 10 characters in the call to InputName
                        \ below

 LDA #'A'               \ Set A to ASCII "A" so we can fill the name buffer with
                        \ "A" characters

.sear1

 STA INWK+5,Y           \ Set the Y-th character of the name at INWK+5 with "A"

 DEY                    \ Decrement the loop counter

 BPL sear1              \ Loop back until we have filled all ten characters
                        \ of the name

 JSR InputName_b6       \ Get a system name from the controller into INWK+5,
                        \ where the name will be terminated by ASCII 13

 LDA INWK+5             \ If the first character of the entered name is ASCII 13
 CMP #13                \ then no name was entered, so jump to sear2 to return
 BEQ sear2              \ from the subroutine

ENDIF

 JSR TT81               \ Set the seeds in QQ15 (the selected system) to those
                        \ of system 0 in the current galaxy (i.e. copy the seeds
                        \ from QQ21 to QQ15)

 LDA #0                 \ We now loop through the galaxy's systems in order,
 STA XX20               \ until we find a match, so set XX20 to act as a system
                        \ counter, starting with system 0

.HME3

IF NOT(_NES_VERSION)

 JSR MT14               \ Switch to justified text when printing extended
                        \ tokens, so the call to cpl prints into the justified
                        \ text buffer at BUF instead of the screen, and DTW5
                        \ gets set to the length of the system name

ELIF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #%10000000         \ Set the DTW4 flag to %10000000 (justify text, print
 STA DTW4               \ the contents of the buffer whenever a carriage return
                        \ appears in the token)

 ASL A                  \ Set DTW5 = 0, which sets the size of the justified
 STA DTW5               \ text buffer at BUF to zero

ENDIF

 JSR cpl                \ Print the selected system name into the justified text
                        \ buffer

 LDX DTW5               \ Fetch DTW5 into X, so X is now equal to the length of
                        \ the selected system name

 LDA INWK+5,X           \ Fetch the X-th character from the entered search term

 CMP #13                \ If the X-th character is not a carriage return, then
 BNE HME6               \ the selected system name and the entered search term
                        \ are different lengths, so jump to HME6 to move on to
                        \ the next system

.HME4

 DEX                    \ Decrement X so it points to the last letter of the
                        \ selected system name (and, when we loop back here, it
                        \ points to the next letter to the left)

 LDA INWK+5,X           \ Set A to the X-th character of the entered search term

 ORA #%00100000         \ Set bit 5 of the character to make it lower case

 CMP BUF,X              \ If the character in A matches the X-th character of
 BEQ HME4               \ the selected system name in BUF, loop back to HME4 to
                        \ check the next letter to the left

 TXA                    \ The last comparison didn't match, so copy the letter
 BMI HME5               \ number into A, and if it's negative, that means we
                        \ managed to go past the first letters of each term
                        \ before we failed to get a match, so the terms are the
                        \ same, so jump to HME5 to process a successful search

.HME6

                        \ If we get here then the selected system name and the
                        \ entered search term did not match

IF _NES_VERSION

 JSR DisableJustifyText \ Turn off justified text

ENDIF

 JSR TT20               \ We want to move on to the next system, so call TT20
                        \ to twist the three 16-bit seeds in QQ15

 INC XX20               \ Increment the system counter in XX20

 BNE HME3               \ If we haven't yet checked all 256 systems in the
                        \ current galaxy, loop back to HME3 to check the next
                        \ system

                        \ If we get here then the entered search term did not
                        \ match any systems in the current galaxy

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10), so we can put the crosshairs back where
                        \ they were before the search

IF NOT(_NES_VERSION)

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10)

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 LDA #40                \ Call the NOISE routine with A = 40 to make a low,
 JSR NOISE              \ long beep to indicate a failed search

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 JSR BOOP               \ Call the BOOP routine to make a low, long beep to
                        \ indicate a failed search

ELIF _C64_VERSION

 LDY #sfxboop           \ Call the NOISE routine with Y = sfxboop to make a low,
 JSR NOISE              \ long beep to indicate a failed search

ENDIF

IF NOT(_NES_VERSION)

 LDA #215               \ Print extended token 215 ("{left align} UNKNOWN
 JMP DETOK              \ PLANET"), which will print on-screen as the left align
                        \ code disables justified text, and return from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

 LDA #215               \ Print extended token 215 ("{left align} UNKNOWN
 JSR DETOK_b2           \ PLANET"), which will print on-screen as the left align
                        \ code disables justified text

 JMP DrawScreenInNMI    \ Configure the NMI handler to draw the screen,
                        \ returning from the subroutine using a tail call

ENDIF

.HME5

                        \ If we get here then we have found a match for the
                        \ entered search

IF _NES_VERSION

 JSR DisableJustifyText \ Turn off justified text

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 LDA #%00000000         \ Set DTW8 = %00000000 (capitalise the next letter)
 STA DTW8

ENDIF

 LDA QQ15+3             \ The x-coordinate of the system described by the seeds
 STA QQ9                \ in QQ15 is in QQ15+3 (s1_hi), so we copy this to QQ9
                        \ as the x-coordinate of the search result

 LDA QQ15+1             \ The y-coordinate of the system described by the seeds
 STA QQ10               \ in QQ15 is in QQ15+1 (s0_hi), so we copy this to QQ10
                        \ as the y-coordinate of the search result

IF NOT(_NES_VERSION)

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10)

 JSR MT15               \ Switch to left-aligned text when printing extended
                        \ tokens so future tokens will print to the screen (as
                        \ this disables justified text)

 JMP T95                \ Jump to T95 to print the distance to the selected
                        \ system and return from the subroutine using a tail
                        \ call

ELIF _NES_VERSION

 JMP ReturnFromSearch   \ Jump back into TT102 to select the found system and
                        \ return from the subroutine using a tail call

.sear2

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 JMP DrawScreenInNMI    \ Configure the NMI handler to draw the screen,
                        \ returning from the subroutine using a tail call

ENDIF

