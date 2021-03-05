\ ******************************************************************************
\
\       Name: STATUS
\       Type: Subroutine
\   Category: Status
\    Summary: Show the Status Mode screen (red key f8)
\  Deep dive: Combat rank
\
\ ******************************************************************************

IF _6502SP_VERSION \ Minor: The 6502SP version has to use an extended token for printing "DOCKED" because the standard token has been repurposed compared to the cassette version

.wearedocked

                        \ We call this from STATUS below if we are docked

 LDA #205               \ Print extended token 205 ("DOCKED") and return from
 JSR DETOK              \ the subroutine using a tail call

 JSR TT67               \ Print a newline

 JMP st6+3              \ Jump down to st6+3, to print recursive token 125 and
                        \ continue to the rest of the Status Mode screen

ENDIF

.st4

                        \ We call this from st5 below with the high byte of the
                        \ kill tally in A, which is non-zero, and want to return
                        \ with the following in X, depending on our rating:
                        \
                        \   Competent = 6
                        \   Dangerous = 7
                        \   Deadly    = 8
                        \   Elite     = 9
                        \
                        \ The high bytes of the top tier ratings are as follows,
                        \ so this a relatively simple calculation:
                        \
                        \   Competent       = 1 to 2
                        \   Dangerous       = 2 to 9
                        \   Deadly          = 10 to 24
                        \   Elite           = 25 and up

 LDX #9                 \ Set X to 9 for an Elite rating

 CMP #25                \ If A >= 25, jump to st3 to print out our rating, as we
 BCS st3                \ are Elite

 DEX                    \ Decrement X to 8 for a Deadly rating

 CMP #10                \ If A >= 10, jump to st3 to print out our rating, as we
 BCS st3                \ are Deadly

 DEX                    \ Decrement X to 7 for a Dangerous rating

 CMP #2                 \ If A >= 2, jump to st3 to print out our rating, as we
 BCS st3                \ are Dangerous

 DEX                    \ Decrement X to 6 for a Competent rating

 BNE st3                \ Jump to st3 to print out our rating, as we are
                        \ Competent (this BNE is effectively a JMP as A will
                        \ never be zero)

.STATUS

IF _CASSETTE_VERSION OR _DISC_VERSION \ Advanced: In the 6502SP version, you can send the Status Mode screen to the printer by pressing SHIFT-f8

 LDA #8                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 8 (Status
                        \ Mode screen)

ELIF _6502SP_VERSION

 LDA #8                 \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 8 (Status Mode screen)

ENDIF

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

IF _CASSETTE_VERSION OR _DISC_VERSION \ Tube

 LDA #7                 \ Move the text cursor to column 7
 STA XC

ELIF _6502SP_VERSION

 LDA #7                 \ Move the text cursor to column 7
 JSR DOXC

ENDIF

 LDA #126               \ Print recursive token 126, which prints the top
 JSR NLIN3              \ four lines of the Status Mode screen:
                        \
                        \         COMMANDER {commander name}
                        \
                        \
                        \   Present System      : {current system name}
                        \   Hyperspace System   : {selected system name}
                        \   Condition           :
                        \
                        \ and draw a horizontal line at pixel row 19 to box
                        \ in the title

IF _CASSETTE_VERSION \ Minor

 LDA #15                \ Set A to token 129 ("{sentence case}DOCKED")

 LDY QQ12               \ Fetch the docked status from QQ12, and if we are
 BNE st6                \ docked, jump to st6 to print "Docked" for our
                        \ ship's condition

ELIF _6502SP_VERSION

 LDA #15                \ Set A to token 129 ("{sentence case}DOCKED")

 LDY QQ12               \ Fetch the docked status from QQ12, and if we are
 BNE wearedocked        \ docked, jump to wearedocked

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

 LDA #230               \ Otherwise we are in space, so start off by setting A
                        \ to token 70 ("GREEN")

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDY MANY+AST           \ Set Y to the number of asteroids in our local bubble
                        \ of universe

ELIF _6502SP_VERSION OR _DISC_FLIGHT

 LDY JUNK               \ Set Y to the number of junk items in our local bubble
                        \ of universe (where junk is asteroids, canisters,
                        \ escape pods and so on)

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

 LDX FRIN+2,Y           \ The ship slots at FRIN are ordered with the first two
                        \ slots reserved for the planet and sun/space station,
                        \ and then any ships, so if the slot at FRIN+2+Y is not
                        \ empty (i.e is non-zero), then that means the number of
                        \ non-asteroids in the vicinity is at least 1

 BEQ st6                \ So if X = 0, there are no ships in the vicinity, so
                        \ jump to st6 to print "Green" for our ship's condition

 LDY ENERGY             \ Otherwise we have ships in the vicinity, so we load
                        \ our energy levels into Y

 CPY #128               \ Set the C flag if Y >= 128, so C is set if we have
                        \ more than half of our energy banks charged

 ADC #1                 \ Add 1 + C to A, so if C is not set (i.e. we have low
                        \ energy levels) then A is set to token 231 ("RED"),
                        \ and if C is set (i.e. we have healthy energy levels)
                        \ then A is set to token 232 ("YELLOW")

.st6

 JSR plf                \ Print the text token in A (which contains our ship's
                        \ condition) followed by a newline

ELIF _DISC_DOCKED

 LDA #205               \ Print extended token 205 ("DOCKED")
 JSR DETOK

 JSR TT67               \ Print a newline

ENDIF

 LDA #125               \ Print recursive token 125, which prints the next
 JSR spc                \ three lines of the Status Mode screen:
                        \
                        \   Fuel: {fuel level} Light Years
                        \   Cash: {cash} Cr
                        \   Legal Status:
                        \
                        \ followed by a space

 LDA #19                \ Set A to token 133 ("CLEAN")

 LDY FIST               \ Fetch our legal status, and if it is 0, we are clean,
 BEQ st5                \ so jump to st5 to print "Clean"

 CPY #50                \ Set the C flag if Y >= 50, so C is set if we have
                        \ a legal status of 50+ (i.e. we are a fugitive)

 ADC #1                 \ Add 1 + C to A, so if C is not set (i.e. we have a
                        \ legal status between 1 and 49) then A is set to token
                        \ 134 ("OFFENDER"), and if C is set (i.e. we have a
                        \ legal status of 50+) then A is set to token 135
                        \ ("FUGITIVE")

.st5

 JSR plf                \ Print the text token in A (which contains our legal
                        \ status) followed by a newline

 LDA #16                \ Print recursive token 130 ("RATING:")
 JSR spc

 LDA TALLY+1            \ Fetch the high byte of the kill tally, and if it is
 BNE st4                \ not zero, then we have more than 256 kills, so jump
                        \ to st4 to work out whether we are Competent,
                        \ Dangerous, Deadly or Elite

                        \ Otherwise we have fewer than 256 kills, so we are one
                        \ of Harmless, Mostly Harmless, Poor, Average or Above
                        \ Average

 TAX                    \ Set X to 0 (as A is 0)

 LDA TALLY              \ Set A = lower byte of tally / 4
 LSR A
 LSR A

IF _CASSETTE_VERSION OR _DISC_VERSION \ Label

.st5L

ENDIF

                        \ We now loop through bits 2 to 7, shifting each of them
                        \ off the end of A until there are no set bits left, and
                        \ incrementing X for each shift, so at the end of the
                        \ process, X contains the position of the leftmost 1 in
                        \ A. Looking at the rank values in TALLY:
                        \
                        \   Harmless        = %00000000 to %00000011
                        \   Mostly Harmless = %00000100 to %00000111
                        \   Poor            = %00001000 to %00001111
                        \   Average         = %00010000 to %00011111
                        \   Above Average   = %00100000 to %11111111
                        \
                        \ we can see that the values returned by this process
                        \ are:
                        \
                        \   Harmless        = 1
                        \   Mostly Harmless = 2
                        \   Poor            = 3
                        \   Average         = 4
                        \   Above Average   = 5

 INX                    \ Increment X for each shift

 LSR A                  \ Shift A to the right

IF _CASSETTE_VERSION OR _DISC_VERSION \ Label

 BNE st5L               \ Keep looping around until A = 0, which means there are
                        \ no set bits left in A

ELIF _6502SP_VERSION

 BNE P%-2               \ Keep looping back two instructions (i.e. to the INX
                        \ instruction) until A = 0, which means there are no set
                        \ bits left in A

ENDIF

.st3

 TXA                    \ A now contains our rating as a value of 1 to 9, so
                        \ transfer X to A, so we can print it out

 CLC                    \ Print recursive token 135 + A, which will be in the
 ADC #21                \ range 136 ("HARMLESS") to 144 ("---- E L I T E ----")
 JSR plf                \ followed by a newline

 LDA #18                \ Print recursive token 132, which prints the next bit
 JSR plf2               \ of the Status Mode screen:
                        \
                        \   EQUIPMENT:
                        \
                        \ followed by a newline and an indent of 6 characters

 LDA CRGO               \ If our ship's cargo capacity is < 26 (i.e. we do not
 CMP #26                \ have a cargo bay extension), skip the following two
 BCC P%+7               \ instructions

 LDA #107               \ We do have a cargo bay extension, so print recursive
 JSR plf2               \ token 107 ("LARGE CARGO{sentence case} BAY"), followed
                        \ by a newline and an indent of 6 characters

 LDA BST                \ If we don't have fuel scoops fitted, skip the
 BEQ P%+7               \ following two instructions

 LDA #111               \ We do have a fuel scoops fitted, so print recursive
 JSR plf2               \ token 111 ("FUEL SCOOPS"), followed by a newline and
                        \ an indent of 6 characters

 LDA ECM                \ If we don't have an E.C.M. fitted, skip the following
 BEQ P%+7               \ two instructions

 LDA #108               \ We do have an E.C.M. fitted, so print recursive token
 JSR plf2               \ 108 ("E.C.M.SYSTEM"), followed by a newline and an
                        \ indent of 6 characters

 LDA #113               \ We now cover the four pieces of equipment whose flags
 STA XX4                \ are stored in BOMB through BOMB+3, and whose names
                        \ correspond with text tokens 113 through 116:
                        \
                        \   BOMB+0 = BOMB  = token 113 = Energy bomb
                        \   BOMB+1 = ENGY  = token 114 = Energy unit
                        \   BOMB+2 = DKCMP = token 115 = Docking computer
                        \   BOMB+3 = GHYP  = token 116 = Galactic hyperdrive
                        \
                        \ We can print these out using a loop, so we set XX4 to
                        \ 113 as a counter (and we also set A as well, to pass
                        \ through to plf2)

.stqv

 TAY                    \ Fetch byte BOMB+0 through BOMB+4 for values of XX4
 LDX BOMB-113,Y         \ from 113 through 117

 BEQ P%+5               \ If it is zero then we do not own that piece of
                        \ equipment, so skip the next instruction

 JSR plf2               \ Print the recursive token in A from 113 ("ENERGY
                        \ BOMB") through 116 ("GALACTIC HYPERSPACE "), followed
                        \ by a newline and an indent of 6 characters

 INC XX4                \ Increment the counter (and A as well)
 LDA XX4

 CMP #117               \ If A < 117, loop back up to stqv to print the next
 BCC stqv               \ piece of equipment

 LDX #0                 \ Now to print our ship's lasers, so set a counter in X
                        \ to count through the four views (0 = front, 1 = rear,
                        \ 2 = left, 3 = right)

.st

 STX CNT                \ Store the view number in CNT

 LDY LASER,X            \ Fetch the laser power for view X, and if we do not
 BEQ st1                \ have a laser fitted to that view, jump to st1 to move
                        \ on to the next one

 TXA                    \ Print recursive token 96 + X, which will print from 96
 CLC                    \ ("FRONT") through to 99 ("RIGHT"), followed by a space
 ADC #96
 JSR spc

 LDA #103               \ Set A to token 103 ("PULSE LASER")

IF _CASSETTE_VERSION \ Enhanced: The Status Mode screen supports the new types of laser (military and mining)

 LDX CNT                \ If the laser power for view X has bit 7 clear, then it
 LDY LASER,X            \ is a pulse laser, so skip the following instruction
 BPL P%+4

 LDA #104               \ Set A to token 104 ("BEAM LASER")

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDX CNT                \ Set Y = the laser power for view X
 LDY LASER,X

 CPY #128+POW           \ If the laser power for view X is not #POW+128 (beam
 BNE P%+4               \ laser), skip the next LDA instruction

 LDA #104               \ This sets A = 104 if the laser in view X is a beam
                        \ laser (token 104 is "BEAM LASER")

 CPY #Armlas            \ If the laser power for view X is not #Armlas (military
 BNE P%+4               \ laser), skip the next LDA instruction

 LDA #117               \ This sets A = 117 if the laser in view X is a military
                        \ laser (token 117 is "MILITARY  LASER")

 CPY #Mlas              \ If the laser power for view X is not #Mlas (mining
 BNE P%+4               \ laser), skip the next LDA instruction

 LDA #118               \ This sets A = 118 if the laser in view X is a mining
                        \ laser (token 118 is "MINING  LASER")

ENDIF

 JSR plf2               \ Print the text token in A (which contains our legal
                        \ status) followed by a newline and an indent of 6
                        \ characters

.st1

 LDX CNT                \ Increment the counter in X and CNT to point to the
 INX                    \ next view

 CPX #4                 \ If this isn't the last of the four views, jump back up
 BCC st                 \ to st to print out the next one

 RTS                    \ Return from the subroutine

