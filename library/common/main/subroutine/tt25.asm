\ ******************************************************************************
\
\       Name: TT25
\       Type: Subroutine
\   Category: Universe
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Data on System screen (red key f6)
ELIF _ELECTRON_VERSION
\    Summary: Show the Data on System screen (FUNC-7)
ELIF _ELITE_A_VERSION
\    Summary: Show the Data on System screen (red key f6) or Encyclopedia screen
\             (CTRL-f6)
ELIF _NES_VERSION
\    Summary: Show the Data on System screen
ENDIF
\  Deep dive: Generating system data
\             Galaxy and system seeds
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TT72                Used by TT70 to re-enter the routine after displaying
\                       "MAINLY" for the economy type
\
\ ******************************************************************************

.TT25

IF _ELITE_A_DOCKED

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

 BPL not_cyclop         \ If CTRL is not being pressed, jump to not_cyclop to
                        \ skip the next instruction

 JMP encyclopedia       \ CTRL-f6 is being pressed, so jump to encyclopedia to
                        \ load and run the encyclopedia code

.not_cyclop

ELIF _ELITE_A_6502SP_PARA

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

 BPL not_cyclop         \ If CTRL is not being pressed, jump to not_cyclop to
                        \ skip the next instruction

 LDA dockedp            \ If dockedp is non-zero, then we are not docked and
 BNE not_cyclop         \ can't show the encyclopedia, so jump to not_cyclop to
                        \ skip the following instruction

 JMP encyclopedia       \ CTRL-f6 is being pressed, so jump to encyclopedia to
                        \ show the Encyclopedia screen

.not_cyclop

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ 6502SP: In the 6502SP version, you can send the Data on System screen to the printer by pressing CTRL-f6

 JSR TT66-2             \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 1

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 LDA #1                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 1

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #1                 \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 1

ELIF _NES_VERSION

 LDA #&96               \ Clear the screen and and set the view type in QQ11 to
 JSR SetNewViewType     \ &96 (Data on System)

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 LDA #9                 \ Move the text cursor to column 9
 STA XC

ELIF _6502SP_VERSION

 LDA #9                 \ Move the text cursor to column 9
 JSR DOXC

ELIF _NES_VERSION

 LDX languageIndex      \ Move the text cursor to the correct column for the
 LDA xDataOnSystem,X    \ Data on System title in the chosen language
 STA XC

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Minor

 LDA #163               \ Print recursive token 3 as a title in capitals at
 JSR TT27               \ the top ("DATA ON {selected system name}")

 JSR NLIN               \ Draw a horizontal line underneath the title

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 LDA #163               \ Print recursive token 3 ("DATA ON {selected system
 JSR NLIN3              \ name}" and draw a horizontal line at pixel row 19
                        \ to box in the title

ELIF _NES_VERSION

 LDA #163               \ Print recursive token 3 ("DATA ON {selected system
 JSR NLIN3              \ name}" on the top row

ENDIF

 JSR TTX69              \ Print a paragraph break and set Sentence Case

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Standard: The cassette version doesn't show extended system descriptions in the Data on System screen, and neither does the disc version when we are in flight, so both of these show the information one line lower on-screen than in the other versions

 INC YC                 \ Move the text cursor down one more line

ENDIF

 JSR TT146              \ If the distance to this system is non-zero, print
                        \ "DISTANCE", then the distance, "LIGHT YEARS" and a
                        \ paragraph break, otherwise just move the cursor down
                        \ a line

IF _NES_VERSION

 LDA languageNumber     \ If both bit 1 and bit 2 of languageNumber are clear
 AND #%00000110         \ then the chosen language is English, so jump to dsys1
 BEQ dsys1              \ to skip the following

                        \ If we get here then the chosen language is French or
                        \ German, so we need to print the system economy using
                        \ the PrintTokenAndColon routine to ensure the label is
                        \ in green

 LDA #194               \ Print recursive token 34 ("ECONOMY") followed by
 JSR PrintTokenAndColon \ colon, ensuring that the colon is printed in green
                        \ despite being in a 2x2 attribute block set for white
                        \ text

 JMP dsys2              \ Jump to dsys2 to print the economy type

.dsys1

ENDIF

 LDA #194               \ Print recursive token 34 ("ECONOMY") followed by
 JSR TT68               \ a colon

IF _NES_VERSION

 JSR TT162              \ Print a space

.dsys2

ENDIF

 LDA QQ3                \ The system economy is determined by the value in QQ3,
                        \ so fetch it into A. First we work out the system's
                        \ prosperity as follows:
                        \
                        \   QQ3 = 0 or 5 = %000 or %101 = Rich
                        \   QQ3 = 1 or 6 = %001 or %110 = Average
                        \   QQ3 = 2 or 7 = %010 or %111 = Poor
                        \   QQ3 = 3 or 4 = %011 or %100 = Mainly

 CLC                    \ If (QQ3 + 1) >> 1 = %10, i.e. if QQ3 = %011 or %100
 ADC #1                 \ (3 or 4), then call TT70, which prints "MAINLY " and
 LSR A                  \ jumps down to TT72 to print the type of economy
 CMP #%00000010
 BEQ TT70

 LDA QQ3                \ If (QQ3 + 1) >> 1 < %10, i.e. if QQ3 = %000, %001 or
 BCC TT71               \ %010 (0, 1 or 2), then jump to TT71 with A set to the
                        \ original value of QQ3

 SBC #5                 \ Here QQ3 = %101, %110 or %111 (5, 6 or 7), so subtract
 CLC                    \ 5 to bring it down to 0, 1 or 2 (the C flag is already
                        \ set so the SBC will be correct)

.TT71

IF NOT(_NES_VERSION)

 ADC #170               \ A is now 0, 1 or 2, so print recursive token 10 + A.
 JSR TT27               \ This means that:
                        \
                        \   QQ3 = 0 or 5 prints token 10 ("RICH ")
                        \   QQ3 = 1 or 6 prints token 11 ("AVERAGE ")
                        \   QQ3 = 2 or 7 prints token 12 ("POOR ")

ELIF _NES_VERSION

 ADC #170               \ A is now 0, 1 or 2, so print recursive token 10 + A.
 JSR TT27_b2            \ This means that:
                        \
                        \   QQ3 = 0 or 5 prints token 10 ("RICH ")
                        \   QQ3 = 1 or 6 prints token 11 ("AVERAGE ")
                        \   QQ3 = 2 or 7 prints token 12 ("POOR ")

ENDIF

.TT72

 LDA QQ3                \ Now to work out the type of economy, which is
 LSR A                  \ determined by bit 2 of QQ3, as follows:
 LSR A                  \
                        \   QQ3 bit 2 = 0 = Industrial
                        \   QQ3 bit 2 = 1 = Agricultural
                        \
                        \ So we fetch QQ3 into A and set A = bit 2 of QQ3 using
                        \ two right shifts (which will work as QQ3 is only a
                        \ 3-bit number)

 CLC                    \ Print recursive token 8 + A, followed by a paragraph
 ADC #168               \ break and Sentence Case, so:
 JSR TT60               \
                        \   QQ3 bit 2 = 0 prints token 8 ("INDUSTRIAL")
                        \   QQ3 bit 2 = 1 prints token 9 ("AGRICULTURAL")

IF _NES_VERSION

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so jump to dsys3 skip the
 BEQ dsys3              \ following

                        \ If we get here then the chosen language is French, so
                        \ so we need to print the system government using the
                        \ PrintTokenAndColon routine to ensure the label is in
                        \ green

 LDA #162               \ Print recursive token 2 ("GOVERNMENT") followed by
 JSR PrintTokenAndColon \ colon, ensuring that the colon is printed in green
                        \ despite being in a 2x2 attribute block set for white
                        \ text

 JMP dsys4              \ Jump to dsys4 to print the government type

.dsys3

ENDIF

 LDA #162               \ Print recursive token 2 ("GOVERNMENT") followed by
 JSR TT68               \ a colon

IF _NES_VERSION

 JSR TT162              \ Print a space

.dsys4

ENDIF

 LDA QQ4                \ The system's government is determined by the value in
                        \ QQ4, so fetch it into A

 CLC                    \ Print recursive token 17 + A, followed by a paragraph
 ADC #177               \ break and Sentence Case, so:
 JSR TT60               \
                        \   QQ4 = 0 prints token 17 ("ANARCHY")
                        \   QQ4 = 1 prints token 18 ("FEUDAL")
                        \   QQ4 = 2 prints token 19 ("MULTI-GOVERNMENT")
                        \   QQ4 = 3 prints token 20 ("DICTATORSHIP")
                        \   QQ4 = 4 prints token 21 ("COMMUNIST")
                        \   QQ4 = 5 prints token 22 ("CONFEDERACY")
                        \   QQ4 = 6 prints token 23 ("DEMOCRACY")
                        \   QQ4 = 7 prints token 24 ("CORPORATE STATE")

 LDA #196               \ Print recursive token 36 ("TECH.LEVEL") followed by a
 JSR TT68               \ colon

 LDX QQ5                \ Fetch the tech level from QQ5 and increment it, as it
 INX                    \ is stored in the range 0-14 but the displayed range
                        \ should be 1-15

IF NOT(_ELITE_A_FLIGHT)

 CLC                    \ Call pr2 to print the technology level as a 3-digit
 JSR pr2                \ number without a decimal point (by clearing the C
                        \ flag)

ELIF _ELITE_A_FLIGHT

 JSR pr2-1              \ Call pr2-1 to print the technology level as a 3-digit
                        \ number without a decimal point

ENDIF

 JSR TTX69              \ Print a paragraph break and set Sentence Case

IF _NES_VERSION

 LDA #193               \ Print recursive token 33 ("TURNOVER"), followed
 JSR TT68               \ by a colon

 LDX QQ7                \ Fetch the 16-bit productivity value from QQ7 into
 LDY QQ7+1              \ (Y X)

 CLC                    \ Print (Y X) to 6 digits with no decimal point
 LDA #6
 JSR TT11

 JSR TT162              \ Print a space

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

 LDA #'M'               \ Print "MCR", followed by a paragraph break and
 JSR DASC_b2            \ Sentence Case
 LDA #'C'
 JSR TT27_b2
 LDA #'R'
 JSR TT60

 LDY #0                 \ We now print the string in radiusText ("RADIUS"), so
                        \ set a character counter in Y

.dsys5

 LDA radiusText,Y       \ Print the Y-th character from radiusText
 JSR TT27_b2

 INY                    \ Increment the counter

 CPY #5                 \ Loop back until we have printed the first five letters
 BCC dsys5              \ of the string

 LDA radiusText,Y       \ Print the last letter of the string, followed by a
 JSR TT68               \ colon

 LDA QQ15+5             \ Set A = QQ15+5

 LDX QQ15+3             \ Set X = QQ15+3

 AND #%00001111         \ Set Y = (A AND %1111) + 11
 CLC
 ADC #11
 TAY

 LDA #5                 \ Print (Y X) to 5 digits, not including a decimal
 JSR TT11               \ point, as the C flag will be clear (as the maximum
                        \ radius will always fit into 16 bits)

 JSR TT162              \ Print a space

 LDA #'k'               \ Print "km"
 JSR DASC_b2
 LDA #'m'
 JSR DASC_b2

 JSR TTX69              \ Print a paragraph break and set Sentence Case

 LDA languageNumber     \ If both bit 0 and bit 2 of languageNumber are clear
 AND #%00000101         \ then the chosen language is not English or German, so
 BEQ dsys6              \ jump to dsys6 skip the following

                        \ If we get here then the chosen language is Engligh or
                        \ German, so so we need to print the system population
                        \ using the PrintTokenAndColon routine to ensure the
                        \ label is in green

 LDA #192               \ Print recursive token 32 ("POPULATION") followed by a
 JSR PrintTokenAndColon \ colon, ensuring that the colon is printed in green
                        \ despite being in a 2x2 attribute block set for white
                        \ text

 JMP dsys7              \ Jump to dsys7 to print the population

.dsys6

ENDIF

 LDA #192               \ Print recursive token 32 ("POPULATION") followed by a
 JSR TT68               \ colon

IF NOT(_NES_VERSION)

 SEC                    \ Call pr2 to print the population as a 3-digit number
 LDX QQ6                \ with a decimal point (by setting the C flag), so the
 JSR pr2                \ number printed will be population / 10

ELIF _NES_VERSION

.dsys7

 LDA QQ6                \ Set X = QQ6 / 8
 LSR A                  \
 LSR A                  \ We use this as the population figure, in billions
 LSR A
 TAX

 CLC                    \ Clear the C flag so we do not print a decimal point in
                        \ the call to pr2+2

 LDA #1                 \ Set the number of digits to 1 for the call to pr2+2

 JSR pr2+2              \ Print the population as a 1-digit number without a
                        \ decimal point

ENDIF

 LDA #198               \ Print recursive token 38 (" BILLION"), followed by a
 JSR TT60               \ paragraph break and Sentence Case

IF NOT(_NES_VERSION)

 LDA #'('               \ Print an opening bracket
 JSR TT27

 LDA QQ15+4             \ Now to calculate the species, so first check bit 7 of
 BMI TT75               \ s2_lo, and if it is set, jump to TT75 as this is an
                        \ alien species

 LDA #188               \ Bit 7 of s2_lo is clear, so print recursive token 28
 JSR TT27               \ ("HUMAN COLONIAL")

ELIF _NES_VERSION

 LDA languageNumber     \ If bit 1 of languageNumber is set then the chosen
 AND #%00000010         \ language is German, so jump to dsys8 skip the
 BNE dsys8              \ following

                        \ If we get here then the chosen language is French or
                        \ English, so we print the species in brackets

 LDA #'('               \ Print an opening bracket
 JSR TT27_b2

.dsys8

 LDA QQ15+4             \ Now to calculate the species, so first check bit 7 of
 BMI TT205              \ s2_lo, and if it is set, jump to TT205 as this is an
                        \ alien species

 LDA #188               \ Bit 7 of s2_lo is clear, so print recursive token 28
 JSR TT27_b2            \ ("HUMAN COLONIAL")

ENDIF

 JMP TT76               \ Jump to TT76 to print "S)" and a paragraph break, so
                        \ the whole species string is "(HUMAN COLONIALS)"

.TT75

IF NOT(_NES_VERSION)

 LDA QQ15+5             \ This is an alien species, and we start with the first
 LSR A                  \ adjective, so fetch bits 2-7 of s2_hi into A and push
 LSR A                  \ onto the stack so we can use this later
 PHA

 AND #%00000111         \ Set A = bits 0-2 of A (so that's bits 2-4 of s2_hi)

 CMP #3                 \ If A >= 3, jump to TT205 to skip the first adjective,
 BCS TT205

 ADC #227               \ Otherwise A = 0, 1 or 2, so print recursive token
 JSR spc                \ 67 + A, followed by a space, so:
                        \
                        \   A = 0 prints token 67 ("LARGE") and a space
                        \   A = 1 prints token 67 ("FIERCE") and a space
                        \   A = 2 prints token 67 ("SMALL") and a space

ELIF _NES_VERSION

 LDA QQ15+5             \ This is an alien species, so we take bits 0-1 of
 AND #%00000011         \ s2_hi, add this to the value of A that we used for
 CLC                    \ the third adjective, and take bits 0-2 of the result
 ADC QQ19
 AND #%00000111

 ADC #242               \ A = 0 to 7, so print recursive token 82 + A, so:
 JSR TT27_b2            \
                        \   A = 0 prints token 76 ("RODENT")
                        \   A = 1 prints token 76 ("FROG")
                        \   A = 2 prints token 76 ("LIZARD")
                        \   A = 3 prints token 76 ("LOBSTER")
                        \   A = 4 prints token 76 ("BIRD")
                        \   A = 5 prints token 76 ("HUMANOID")
                        \   A = 6 prints token 76 ("FELINE")
                        \   A = 7 prints token 76 ("INSECT")

 LDA QQ15+5             \ Now for the second adjective, so shift s2_hi so we get
 LSR A                  \ A = bits 5-7 of s2_hi
 LSR A
 LSR A
 LSR A
 LSR A

 CMP #6                 \ If A >= 6, jump to dsys9 to skip the second adjective
 BCS dsys9

 ADC #230               \ Otherwise A = 0 to 5, so print a space followed by
 JSR PrintSpaceAndToken \ recursive token 70 + A, so:
                        \
                        \   A = 0 prints token 70 ("GREEN") and a space
                        \   A = 1 prints token 71 ("RED") and a space
                        \   A = 2 prints token 72 ("YELLOW") and a space
                        \   A = 3 prints token 73 ("BLUE") and a space
                        \   A = 4 prints token 74 ("BLACK") and a space
                        \   A = 5 prints token 75 ("HARMLESS") and a space

.dsys9

 LDA QQ19               \ Fetch the value that we calculated for the third
                        \ adjective

 CMP #6                 \ If A >= 6, jump to TT76 to skip the third adjective
 BCS TT76

 ADC #236               \ Otherwise A = 0 to 5, so print a space followed by
 JSR PrintSpaceAndToken \ recursive token 76 + A, so:
                        \
                        \   A = 0 prints token 76 ("SLIMY") and a space
                        \   A = 1 prints token 77 ("BUG-EYED") and a space
                        \   A = 2 prints token 78 ("HORNED") and a space
                        \   A = 3 prints token 79 ("BONY") and a space
                        \   A = 4 prints token 80 ("FAT") and a space
                        \   A = 5 prints token 81 ("FURRY") and a space

 JMP TT76               \ Jump to TT76 as we have finished printing the
                        \ species string

ENDIF

.TT205

IF NOT(_NES_VERSION)

 PLA                    \ Now for the second adjective, so restore A to bits
 LSR A                  \ 2-7 of s2_hi, and throw away bits 2-4 to leave
 LSR A                  \ A = bits 5-7 of s2_hi
 LSR A

ELIF _NES_VERSION

                        \ In NES Elite, there is no first adjective (in the
                        \ other versions, the first adjective can be "Large",
                        \ "Fierce" or "Small", but this is omitted in NES Elite
                        \ as there isn't space on-screen)

 LDA QQ15+3             \ In preparation for the third adjective, EOR the high
 EOR QQ15+1             \ bytes of s0 and s1 and extract bits 0-2 of the result:
 AND #%00000111         \
 STA QQ19               \   A = (s0_hi EOR s1_hi) AND %111
                        \
                        \ storing the result in QQ19 so we can use it later

 LDA languageNumber     \ If bit 2 of languageNumber is set, then the chosen
 AND #%00000100         \ language is French, so jump to TT75 to print the
 BNE TT75               \ species and then the third adjective, e.g. "Rodents
                        \ Furry"

 LDA QQ15+5             \ Now for the second adjective, so shift s2_hi so we get
 LSR A                  \ A = bits 5-7 of s2_hi
 LSR A
 LSR A
 LSR A
 LSR A

ENDIF

 CMP #6                 \ If A >= 6, jump to TT206 to skip the second adjective
 BCS TT206

 ADC #230               \ Otherwise A = 0 to 5, so print recursive token
 JSR spc                \ 70 + A, followed by a space, so:
                        \
                        \   A = 0 prints token 70 ("GREEN") and a space
                        \   A = 1 prints token 71 ("RED") and a space
                        \   A = 2 prints token 72 ("YELLOW") and a space
                        \   A = 3 prints token 73 ("BLUE") and a space
                        \   A = 4 prints token 74 ("BLACK") and a space
                        \   A = 5 prints token 75 ("HARMLESS") and a space

.TT206

IF NOT(_NES_VERSION)

 LDA QQ15+3             \ Now for the third adjective, so EOR the high bytes of
 EOR QQ15+1             \ s0 and s1 and extract bits 0-2 of the result:
 AND #%00000111         \
 STA QQ19               \   A = (s0_hi EOR s1_hi) AND %111
                        \
                        \ storing the result in QQ19 so we can use it later

ELIF _NES_VERSION

 LDA QQ19               \ Fetch the value that we calculated for the third
                        \ adjective

ENDIF

 CMP #6                 \ If A >= 6, jump to TT207 to skip the third adjective
 BCS TT207

 ADC #236               \ Otherwise A = 0 to 5, so print recursive token
 JSR spc                \ 76 + A, followed by a space, so:
                        \
                        \   A = 0 prints token 76 ("SLIMY") and a space
                        \   A = 1 prints token 77 ("BUG-EYED") and a space
                        \   A = 2 prints token 78 ("HORNED") and a space
                        \   A = 3 prints token 79 ("BONY") and a space
                        \   A = 4 prints token 80 ("FAT") and a space
                        \   A = 5 prints token 81 ("FURRY") and a space

.TT207

 LDA QQ15+5             \ Now for the actual species, so take bits 0-1 of
 AND #%00000011         \ s2_hi, add this to the value of A that we used for
 CLC                    \ the third adjective, and take bits 0-2 of the result
 ADC QQ19
 AND #%00000111

IF NOT(_NES_VERSION)

 ADC #242               \ A = 0 to 7, so print recursive token 82 + A, so:
 JSR TT27               \
                        \   A = 0 prints token 76 ("RODENT")
                        \   A = 1 prints token 76 ("FROG")
                        \   A = 2 prints token 76 ("LIZARD")
                        \   A = 3 prints token 76 ("LOBSTER")
                        \   A = 4 prints token 76 ("BIRD")
                        \   A = 5 prints token 76 ("HUMANOID")
                        \   A = 6 prints token 76 ("FELINE")
                        \   A = 7 prints token 76 ("INSECT")

ELIF _NES_VERSION

 ADC #242               \ A = 0 to 7, so print recursive token 82 + A, so:
 JSR TT27_b2            \
                        \   A = 0 prints token 76 ("RODENT")
                        \   A = 1 prints token 76 ("FROG")
                        \   A = 2 prints token 76 ("LIZARD")
                        \   A = 3 prints token 76 ("LOBSTER")
                        \   A = 4 prints token 76 ("BIRD")
                        \   A = 5 prints token 76 ("HUMANOID")
                        \   A = 6 prints token 76 ("FELINE")
                        \   A = 7 prints token 76 ("INSECT")

ENDIF

.TT76

IF NOT(_NES_VERSION)

 LDA #'S'               \ Print an "S" to pluralise the species
 JSR TT27

 LDA #')'               \ And finally, print a closing bracket, followed by a
 JSR TT60               \ paragraph break and Sentence Case, to end the species
                        \ section

ELIF _NES_VERSION

 LDA languageNumber     \ If bit 1 of languageNumber is set then the chosen
 AND #%00000010         \ language is German, so jump to dsys10 skip the
 BNE dsys10             \ following

                        \ If we get here then the chosen language is French or
                        \ English, so we print the species in brackets

 LDA #')'               \ Print a closing bracket
 JSR TT27_b2

ENDIF

IF NOT(_NES_VERSION)

 LDA #193               \ Print recursive token 33 ("GROSS PRODUCTIVITY"),
 JSR TT68               \ followed by a colon

 LDX QQ7                \ Fetch the 16-bit productivity value from QQ7 into
 LDY QQ7+1              \ (Y X)

 JSR pr6                \ Print (Y X) to 5 digits with no decimal point

 JSR TT162              \ Print a space

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION \ Minor

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

ELIF _MASTER_VERSION

 STZ QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

ELIF _ELITE_A_FLIGHT

 JSR vdu_00             \ Call vdu_00 to switch to ALL CAPS

ENDIF

IF NOT(_NES_VERSION)

 LDA #'M'               \ Print "M"
 JSR TT27

 LDA #226               \ Print recursive token 66 (" CR"), followed by a
 JSR TT60               \ paragraph break and Sentence Case

 LDA #250               \ Print recursive token 90 ("AVERAGE RADIUS"), followed
 JSR TT68               \ by a colon

                        \ The average radius is calculated like this:
                        \
                        \   ((s2_hi AND %1111) + 11) * 256 + s1_hi
                        \
                        \ or, in terms of memory locations:
                        \
                        \   ((QQ15+5 AND %1111) + 11) * 256 + QQ15+3
                        \
                        \ Because the multiplication is by 256, this is the
                        \ same as saying a 16-bit number, with high byte:
                        \
                        \   (QQ15+5 AND %1111) + 11
                        \
                        \ and low byte:
                        \
                        \   QQ15+3
                        \
                        \ so we can set this up in (Y X) and call the pr5
                        \ routine to print it out

 LDA QQ15+5             \ Set A = QQ15+5
 LDX QQ15+3             \ Set X = QQ15+3

 AND #%00001111         \ Set Y = (A AND %1111) + 11
 CLC
 ADC #11
 TAY

 JSR pr5                \ Print (Y X) to 5 digits, not including a decimal
                        \ point, as the C flag will be clear (as the maximum
                        \ radius will always fit into 16 bits)

 JSR TT162              \ Print a space

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Minor

 LDA #'k'               \ Print "km", returning from the subroutine using a
 JSR TT26               \ tail call
 LDA #'m'
 JMP TT26

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 LDA #'k'               \ Print "km"
 JSR TT26
 LDA #'m'
 JSR TT26

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Disc: Extended system descriptions are shown in the enhanced versions, though in the disc version they are only shown when docked, as the PDESC routine isn't present in the flight code due to memory restrictions

 JSR TTX69              \ Print a paragraph break and set Sentence Case

                        \ By this point, ZZ contains the current system number
                        \ which PDESC requires. It gets put there in the TT102
                        \ routine, which calls TT111 to populate ZZ before
                        \ calling TT25 (this routine)

 JMP PDESC              \ Jump to PDESC to print the system's extended
                        \ description, returning from the subroutine using a
                        \ tail call

ELIF _ELITE_A_ENCYCLOPEDIA

 JSR TTX69              \ Print a paragraph break and set Sentence Case

                        \ By this point, ZZ contains the current system number
                        \ which PDESC requires. It gets put there in the TT102
                        \ routine, which calls TT111 to populate ZZ before
                        \ calling TT25 (this routine)

 JMP PD1                \ Jump to PD1 to print the standard "goat soup" system
                        \ description without checking for overrides, returning
                        \ from the subroutine using a tail call

ELIF _NES_VERSION

.dsys10

 JSR TTX69              \ Print a paragraph break and set Sentence Case

                        \ By this point, ZZ contains the current system number
                        \ which PDESC requires. It gets put there in the TT102
                        \ routine, which calls TT111 to populate ZZ before
                        \ calling TT25 (this routine)

 JSR PDESC_b2           \ Call PDESC to print the system's extended description

 JSR FadeAndHideSprites \ Fade the screen to black and hide all sprites, so we
                        \ can update the screen while it's blacked-out

 LDA #22                \ Move the text cursor to column 22
 STA XC

 LDA #8                 \ Move the text cursor to row 8
 STA YC

 LDA #1                 \ Thess instructions have no effect as the values of K+2
 STA K+2                \ and K+3 get overwritten by the call to DrawSystemImage
 LDA #8
 STA K+3

 LDX #8                 \ Set X = 8 to pass to the call to DrawSystemImage as
                        \ the number of tile columns to draw in the system image

 LDY #7                 \ Set Y = 7 to pass to the call to DrawSystemImage as
                        \ the number of tile rows to draw in the system image

 JSR DrawSystemImage_b3 \ Call DrawSystemImage to draw the system image

 JMP UpdateView         \ Update the view, returning from the subroutine using
                        \ a tail call

ENDIF

IF _6502SP_VERSION \ Minor

                        \ The following code doesn't appear to be called from
                        \ anywhere, so it's presumably a remnant of code from
                        \ an earlier version of the extended description code

 LDX ZZ                 \ Fetch the system number from ZZ into X

\LDY #LO(PTEXT)         \ These instructions are commented out in the original
\STY INWK               \ source. The variable PTEXT doesn't exist, so it isn't
\LDY #HI(PTEXT)-1       \ entirely obvious what this code does, though it looks
\STY INWK+1             \ like it loops through a table of text tokens in PTEXT
\LDY #&FF               \ until we get to the entry for the current system,
\.PDT1                  \ which it prints out as text tokens (so perhaps PTEXT
\INY                    \ used to be a token table for the system's extended
\BNE P%+4               \ descriptions before PDESC took over)
\INC INWK+1
\LDA (INWK),Y
\BNE PDT1
\DEX
\BNE PDT1
\.PDT2
\INY
\BNE P%+4
\INC INWK+1
\STY INWK+2
\LDA (INWK),Y
\BEQ TT24-1
\JSR TT27
\LDY INWK+2
\JMP PDT2

 RTS                    \ Return from the subroutine

ELIF _DISC_DOCKED

                        \ The following code doesn't appear to be called from
                        \ anywhere, so it's presumably a remnant of code from
                        \ an earlier version of the extended description code

 LDX ZZ                 \ Fetch the system number from ZZ into X

 RTS                    \ Return from the subroutine

ENDIF

