\ ******************************************************************************
\
\       Name: STATUS
\       Type: Subroutine
\   Category: Status
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Status Mode screen (red key f8)
ELIF _ELECTRON_VERSION
\    Summary: Show the Status Mode screen (FUNC-9)
ELIF _NES_VERSION
\    Summary: Show the Status Mode screen
ENDIF
\  Deep dive: Combat rank
\
IF _ELITE_A_VERSION
\
\ Other entry points:
\
\   sell_equip          Show the Sell Equipment screen, i.e. show a "Sell(Y/N)?"
\                       prompt as we print each item of equipment
\
ENDIF
\ ******************************************************************************

IF _6502SP_VERSION OR _MASTER_VERSION \ Minor: The advanced versions have to use an extended token for printing "DOCKED" because the standard token has been repurposed compared to the cassette version

.wearedocked

                        \ We call this from STATUS below if we are docked

 LDA #205               \ Print extended token 205 ("DOCKED") and return from
 JSR DETOK              \ the subroutine using a tail call

ELIF _NES_VERSION

.wearedocked

                        \ We call this from STATUS below if we are docked

 LDA #205               \ Print extended token 205 ("DOCKED") and return from
 JSR DETOK_b2           \ the subroutine using a tail call

ENDIF

IF _6502SP_VERSION OR _NES_VERSION \ Platform

 JSR TT67               \ Print a newline

ELIF _MASTER_VERSION

 JSR TT67X              \ Print a newline

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Minor

 JMP st6+3              \ Jump down to st6+3, to print recursive token 125 and
                        \ continue to the rest of the Status Mode screen

ENDIF

IF NOT(_NES_VERSION)

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

ENDIF

.STATUS

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ 6502SP: In the 6502SP version, you can send the Status Mode screen to the printer by pressing CTRL-f8

 LDA #8                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 8 (Status
                        \ Mode screen)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #8                 \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 8 (Status Mode screen)

ENDIF

IF NOT(_NES_VERSION)

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

ELIF _NES_VERSION

 LDA #&98               \ Set the current view type in QQ11 to &98 (Status Mode
 JSR ChangeView         \ screen) and move the text cursor to row 0

 JSR subm_9D09          \ ???

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA #15                \ Set A to token 129 ("{sentence case}DOCKED")

 LDY QQ12               \ Fetch the docked status from QQ12, and if we are
 BNE st6                \ docked, jump to st6 to print "Docked" for our
                        \ ship's condition

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #15                \ Set A to token 129 ("{sentence case}DOCKED")

 LDY QQ12               \ Fetch the docked status from QQ12, and if we are
 BNE wearedocked        \ docked, jump to wearedocked

ELIF _ELITE_A_6502SP_PARA

 BIT dockedp            \ If bit 7 of dockedp is clear, then we are docked, so
 BPL stat_dock          \ jump to stat_dock to print "Docked" for our ship's
                        \ condition

ELIF _NES_VERSION

 JSR GetStatusCondition \ Set X to our ship's status condition

 STX previousCondition  \ Store the status condition in previousCondition, so
                        \ we keep an eye on changes in our condition

 LDA #230               \ Start off by setting A to token 70 ("GREEN")

 DEX                    \ If the status condition in X is 0, then we are docked,
 BMI wearedocked        \ so jump to wearedocked

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 LDA #230               \ Otherwise we are in space, so start off by setting A
                        \ to token 70 ("GREEN")

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDY MANY+AST           \ Set Y to the number of asteroids in our local bubble
                        \ of universe

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 LDY JUNK               \ Set Y to the number of junk items in our local bubble
                        \ of universe (where junk is asteroids, canisters,
                        \ escape pods and so on)

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Comment

 LDX FRIN+2,Y           \ The ship slots at FRIN are ordered with the first two
                        \ slots reserved for the planet and sun/space station,
                        \ and then any ships, so if the slot at FRIN+2+Y is not
                        \ empty (i.e. is non-zero), then that means the number
                        \ of non-asteroids in the vicinity is at least 1

ELIF _ELECTRON_VERSION

 LDX FRIN+2,Y           \ The ship slots at FRIN are ordered with the first two
                        \ slots reserved for the planet and space station, and
                        \ then any ships, so if the slot at FRIN+2+Y is not
                        \ empty (i.e. is non-zero), then that means the number
                        \ of non-asteroids in the vicinity is at least 1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION OR _NES_VERSION \ Platform

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

ENDIF

IF _ELITE_A_6502SP_PARA

 JMP stat_legal         \ Jump to stat_legal to skip the following, as we are
                        \ not docked and have already printed the correct
                        \ in-flight status

.stat_dock

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Platform

 LDA #205               \ Print extended token 205 ("DOCKED")
 JSR DETOK

 JSR TT67               \ Print a newline

ENDIF

IF _ELITE_A_6502SP_PARA

.stat_legal

ENDIF

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 LDA languageNumber     \ ???
 AND #4
 BEQ stat1

 JSR PrintLegalStatus   \ Print the current legal status

 JSR PrintCombatRank    \ Print the current combat rank

 LDA #5                 \ Print control code 5, which prints the next
 JSR plf                \ two lines of the Status Mode screen:
                        \
                        \   Fuel: {fuel level} Light Years
                        \   Cash: {cash} Cr
                        \
                        \ followed by a newline

 JMP stat2              \ Jump to stat2 to skip the following

.stat1

 JSR PrintCombatRank    \ Print the current combat rank

 LDA #5                 \ Print control code 5, which prints the next
 JSR plf                \ two lines of the Status Mode screen:
                        \
                        \   Fuel: {fuel level} Light Years
                        \   Cash: {cash} Cr
                        \
                        \ followed by a newline

 JSR PrintLegalStatus   \ Print the current legal status

.stat2

ENDIF

IF NOT(_NES_VERSION)

 LDA #16                \ Print recursive token 130 ("RATING:") followed by a
 JSR spc                \ space

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

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

.st5L

ENDIF

IF NOT(_NES_VERSION)

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

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

 BNE st5L               \ Keep looping around until A = 0, which means there are
                        \ no set bits left in A

ELIF _6502SP_VERSION OR _MASTER_VERSION

 BNE P%-2               \ Keep looping back two instructions (i.e. to the INX
                        \ instruction) until A = 0, which means there are no set
                        \ bits left in A

ENDIF

IF NOT(_NES_VERSION)

.st3

 TXA                    \ A now contains our rating as a value of 1 to 9, so
                        \ transfer X to A, so we can print it out

 CLC                    \ Print recursive token 135 + A, which will be in the
 ADC #21                \ range 136 ("HARMLESS") to 144 ("---- E L I T E ----")
 JSR plf                \ followed by a newline

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _NES_VERSION)

 LDA #18                \ Print recursive token 132, which prints the next bit
 JSR plf2               \ of the Status Mode screen:
                        \
                        \   EQUIPMENT:
                        \
                        \ followed by a newline and an indent of 6 characters

ELIF _NES_VERSION

 LDA #18                \ Print recursive token 132, which prints the next bit
 JSR PrintTokenCrTab    \ of the Status Mode screen:
                        \
                        \   EQUIPMENT:
                        \
                        \ followed by a newline and the correct indent for
                        \ Status Mode entries in the chosen language

 INC YC                 \ Move the text cursor down one row

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 LDA #18                \ Call status_equip with A set to recursive token 132
 JSR status_equip       \ to print the next bit of the Status Mode screen:
                        \
                        \   {current ship type}:
                        \
                        \ followed by a newline and an indent of 8 characters

ENDIF

IF _DISC_VERSION OR _6502SP_VERSION \ Master: The Master version shows the escape pod by name in the Status Mode screen but doesn't show the large cargo bay; the Electron version is similar (though it shows it as "Escape Capsule), while the other versions do show the large cargo bay but don't show the escape pod

 LDA CRGO               \ If our ship's cargo capacity is < 26 (i.e. we do not
 CMP #26                \ have a cargo bay extension), skip the following two
 BCC P%+7               \ instructions

 LDA #107               \ We do have a cargo bay extension, so print recursive
 JSR plf2               \ token 107 ("LARGE CARGO{sentence case} BAY"), followed
                        \ by a newline and an indent of 6 characters

ELIF _MASTER_VERSION

 LDA ESCP               \ If we don't have an escape pod fitted (i.e. ESCP is
 BEQ P%+7               \ zero), skip the following two instructions

 LDA #112               \ We do have an escape pod fitted, so print recursive
 JSR plf2               \ token 112 ("ESCAPE POD"), followed by a newline and an
                        \ indent of 6 characters

ELIF _NES_VERSION

 LDA ESCP               \ If we don't have an escape pod fitted (i.e. ESCP is
 BEQ P%+7               \ zero), skip the following two instructions

 LDA #112               \ We do have an escape pod fitted, so print recursive
 JSR PrintTokenCrTab    \ token 112 ("ESCAPE POD"), followed by a newline and
                        \ the correct indent for Status Mode entries in the
                        \ chosen language

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

.sell_equip

 LDA CRGO               \ If we don't have an I.F.F. system fitted (i.e. CRGO is
 BEQ P%+9               \ zero), skip the following three instructions

 LDA #107               \ We do have an I.F.F. system fitted, so print recursive
 LDX #6                 \ token 107 ("I.F.F.SYSTEM"). If this is the Status Mode
 JSR status_equip       \ or Inventory screen, print a newline and an indent of
                        \ 8 characters, or if this is the Sell Equipment screen,
                        \ show and process a sell prompt for the piece of
                        \ equipment at LASER+X = LASER+6 = CRGO before printing
                        \ a newline

ELIF _ELITE_A_FLIGHT

.sell_equip

 LDA CRGO               \ If we don't have an I.F.F. system fitted (i.e. CRGO is
 BEQ P%+7               \ zero), skip the following two instructions

 LDA #107               \ We do have an I.F.F. system fitted, so print recursive
 JSR plf2               \ token 107 ("I.F.F.SYSTEM"), followed by a newline and
                        \ an indent of 6 characters

ENDIF

IF _CASSETTE_VERSION \ Electron: The Electron version shows the escape pod by name in the Status Mode screen (where it is shown as "Escape Capsule") but it doesn't show the large cargo bay; the Master version is similar (though it shows it as "Escape Pod"), while the other versions show the large cargo bay but don't show the escape pod at all

 LDA CRGO               \ If our ship's cargo capacity is < 26 (i.e. we do not
 CMP #26                \ have a cargo bay extension), skip the following two
 BCC P%+7               \ instructions

 LDA #107               \ We do have a cargo bay extension, so print recursive
 JSR plf2               \ token 107 ("LARGE CARGO{sentence case} BAY"), followed
                        \ by a newline and an indent of 6 characters

ELIF _ELECTRON_VERSION

 LDA ESCP               \ If we don't have an escape pod fitted (i.e. ESCP is
 BEQ P%+7               \ zero), skip the following two instructions

 LDA #112               \ We do have an escape pod fitted, so print recursive
 JSR plf2               \ token 112 ("ESCAPE CAPSULE"), followed by a newline
                        \ and an indent of 6 characters

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _NES_VERSION)

 LDA BST                \ If we don't have fuel scoops fitted, skip the
 BEQ P%+7               \ following two instructions

 LDA #111               \ We do have fuel scoops fitted, so print recursive
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

ELIF _NES_VERSION

 LDA BST                \ If we don't have fuel scoops fitted, skip the
 BEQ P%+7               \ following two instructions

 LDA #111               \ We do have fuel scoops fitted, so print recursive
 JSR PrintTokenCrTab    \ token 111 ("FUEL SCOOPS"), followed by a newline and
                        \ the correct indent for Status Mode entries in the
                        \ chosen language

 LDA ECM                \ If we don't have an E.C.M. fitted, skip the following
 BEQ P%+7               \ two instructions

 LDA #108               \ We do have an E.C.M. fitted, so print recursive token
 JSR PrintTokenCrTab    \ 108 ("E.C.M.SYSTEM"), followed by a newline and the
                        \ correct indent for Status Mode entries in the chosen
                        \ language

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

 JSR PrintTokenCrTab    \ Print the recursive token in A from 113 ("ENERGY
                        \ BOMB") through 116 ("GALACTIC HYPERSPACE "), followed
                        \ by a newline and the correct indent for Status Mode
                        \ entries in the chosen language

 INC XX4                \ Increment the counter (and A as well)
 LDA XX4

 CMP #117               \ If A < 117, loop back up to stqv to print the next
 BCC stqv               \ piece of equipment

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 LDA BST                \ If we don't have fuel scoops fitted, skip the
 BEQ P%+9               \ following three instructions

 LDA #111               \ We do have fuel scoops fitted, so print recursive
 LDX #25                \ token 111 ("FUEL SCOOPS"). If this is the Status Mode
 JSR status_equip       \ or Inventory screen, print a newline and an indent of
                        \ 8 characters, or if this is the Sell Equipment screen,
                        \ show and process a sell prompt for the piece of
                        \ equipment at LASER+X = LASER+25 = BST before printing
                        \ a newline

 LDA ECM                \ If we don't have an E.C.M. fitted, skip the following
 BEQ P%+9               \ three instructions

 LDA #108               \ We do have an E.C.M. fitted, so print recursive token
 LDX #24                \ 108 ("E.C.M.SYSTEM"). If this is the Status Mode or
 JSR status_equip       \ Inventory screen, print a newline and an indent of 8
                        \ characters, or if this is the Sell Equipment screen,
                        \ show and process a sell prompt for the piece of
                        \ equipment at LASER+X = LASER+24 = ECM before printing
                        \ a newline

\LDA #113               \ These instructions are commented out in the original
\STA XX4                \ source

 LDX #26                \ Set X = 26 so we now process equipment from LASER+26
                        \ onwards (i.e. BOMB onwards), using X as a counter
                        \ going from LASER+26 (BOMB) to LASER+29 (GHYP)

.stqv

 STX CNT                \ Store the X counter in CNT so we can retrieve it below

\TAY                    \ These instructions are commented out in the original
\LDX FRIN,Y             \ source

 LDY LASER,X            \ Fetch the equipment flag from LASER+X, and if we do
 BEQ P%+9               \ not have that equipment fitted, skip the following
                        \ four instructions to move onto the next piece of
                        \ equipment

 TXA                    \ Set A = X + 87
 CLC                    \
 ADC #87                \ so A is now a token number between 113 ("HYPERSPACE
                        \ UNIT") and 116 ("GALACTIC HYPERSPACE ")

 JSR status_equip       \ Print the recursive token in A. If this is the Status
                        \ Mode or Inventory screen, print a newline and an
                        \ indent of 8 characters, or if this is the Sell
                        \ Equipment screen, show and process a sell prompt for
                        \ the piece of equipment at LASER+X before printing a
                        \ newline

\INC XX4                \ These instructions are commented out in the original
\LDA XX4                \ source
\CMP #117

 LDX CNT                \ Retrieve the X counter from CNT that we stored above

 INX                    \ Increment the loop counter

 CPX #30                \ Loop back to print the next piece of equipment until
 BCC stqv               \ we have done LASER+26 (BOMB) to LASER+29 (GHYP)

ENDIF

 LDX #0                 \ Now to print our ship's lasers, so set a counter in X
                        \ to count through the four views (0 = front, 1 = rear,
                        \ 2 = left, 3 = right)

.st

 STX CNT                \ Store the view number in CNT

 LDY LASER,X            \ Fetch the laser power for view X, and if we do not
 BEQ st1                \ have a laser fitted to that view, jump to st1 to move
                        \ on to the next one

IF _NES_VERSION

 LDA languageNumber     \ ???
 AND #4
 BNE C88D0

ENDIF

IF NOT(_ELITE_A_VERSION)

 TXA                    \ Print recursive token 96 + X, which will print from 96
 CLC                    \ ("FRONT") through to 99 ("RIGHT"), followed by a space
 ADC #96
 JSR spc

ELIF _ELITE_A_VERSION

 TXA                    \ Print recursive token 96 + X, which will print from 96
 ORA #96                \ ("FRONT") through to 99 ("RIGHT"), followed by a space
 JSR spc                \ (the ORA acts like an addition as 96 = %01100000)

ENDIF

IF _NES_VERSION

.C88D0

ENDIF

 LDA #103               \ Set A to token 103 ("PULSE LASER")

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: The Status Mode screen in the enhanced versions supports the new types of laser (military and mining)

 LDX CNT                \ If the laser power for view X has bit 7 clear, then it
 LDY LASER,X            \ is a pulse laser, so skip the following instruction
 BPL P%+4

 LDA #104               \ Set A to token 104 ("BEAM LASER")

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDX CNT                \ Retrieve the view number from CNT that we stored above

 LDY LASER,X            \ Set Y = the laser power for view X

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

ELIF _ELITE_A_VERSION

 LDX CNT                \ Retrieve the view number from CNT that we stored above

 LDY LASER,X            \ Set Y = the laser power for view X

 CPY new_beam           \ If the laser power for view X is not that of a beam
 BNE P%+4               \ laser when fitted to our current ship type, skip the
                        \ next LDA instruction

 LDA #104               \ This sets A = 104 if the laser in view X is a beam
                        \ laser (token 104 is "BEAM LASER")

 CPY new_military       \ If the laser power for view X is not that of a
 BNE P%+4               \ military laser when fitted to our current ship type,
                        \ skip the next LDA instruction

 LDA #117               \ This sets A = 117 if the laser in view X is a military
                        \ laser (token 117 is "MILITARY  LASER")

 CPY new_mining         \ If the laser power for view X is not that of a mining
 BNE P%+4               \ laser when fitted to our current ship type, skip the
                        \ next LDA instruction

 LDA #118               \ This sets A = 118 if the laser in view X is a mining
                        \ laser (token 118 is "MINING  LASER")

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _NES_VERSION)

 JSR plf2               \ Print the text token in A (which contains our legal
                        \ status) followed by a newline and an indent of 6
                        \ characters

ELIF _NES_VERSION

 JSR TT27_b2            \ Print the text token in A (which contains our legal
                        \ status)

 LDA languageNumber     \ ???
 AND #4
 BEQ C88FB

 LDA CNT                \ Retrieve the view number from CNT that we stored above

 CLC                    \ Print recursive token 96 + A, which will print from 96
 ADC #96                \ ("FRONT") through to 99 ("RIGHT"), followed by a space
 JSR PrintSpaceAndToken

.C88FB

 JSR PrintCrTab         \ Print a newline and the correct indent for Status Mode
                        \ entries in the chosen language

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 JSR status_equip       \ Print the recursive token in A. If this is the Status
                        \ Mode or Inventory screen, print a newline and an
                        \ indent of 8 characters, or if this is the Sell
                        \ Equipment screen, show and process a sell prompt for
                        \ the piece of equipment at LASER+X before printing a
                        \ newline

ENDIF

.st1

 LDX CNT                \ Increment the counter in X and CNT to point to the
 INX                    \ next view

 CPX #4                 \ If this isn't the last of the four views, jump back up
 BCC st                 \ to st to print out the next one

IF NOT(_NES_VERSION)

 RTS                    \ Return from the subroutine

ELIF _NES_VERSION

 LDA #24                \ ???
 STA XC

 LDX languageIndex
 LDA rowHeadshot,X
 STA YC

 JSR GetRankHeadshot_b4

 LDA S
 ORA #&80
 CMP imageFlags
 STA imageFlags

 BEQ C8923

 JSR subm_EB8C

.C8923

 JSR subm_A082_b6

ENDIF

