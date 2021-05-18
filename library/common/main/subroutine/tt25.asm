\ ******************************************************************************
\
\       Name: TT25
\       Type: Subroutine
\   Category: Universe
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Data on System screen (red key f6)
ELIF _ELECTRON_VERSION
\    Summary: Show the Data on System screen (FUNC-7)
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

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 LDA #9                 \ Move the text cursor to column 9
 STA XC

ELIF _6502SP_VERSION

 LDA #9                 \ Move the text cursor to column 9
 JSR DOXC

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Minor

 LDA #163               \ Print recursive token 3 as a title in capitals at
 JSR TT27               \ the top ("DATA ON {selected system name}")

 JSR NLIN               \ Draw a horizontal line underneath the title

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION

 LDA #163               \ Print recursive token 3 ("DATA ON {selected system
 JSR NLIN3              \ name}" and draw a horizontal line at pixel row 19
                        \ to box in the title

ENDIF

 JSR TTX69              \ Print a paragraph break and set Sentence Case

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Standard: The cassette version doesn't show extended system descriptions in the Data on System screen, and neither does the disc version when we are in flight, so both of these show the information one line lower on-screen than in the other versions

 INC YC                 \ Move the text cursor down one more line

ENDIF

 JSR TT146              \ If the distance to this system is non-zero, print
                        \ "DISTANCE", then the distance, "LIGHT YEARS" and a
                        \ paragraph break, otherwise just move the cursor down
                        \ a line

 LDA #194               \ Print recursive token 34 ("ECONOMY") followed by
 JSR TT68               \ a colon

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

 LDA QQ3                \ The LSR A above shifted bit 0 of QQ3 into the C flag,
 BCC TT71               \ so this jumps to TT71 if bit 0 of QQ3 is 0, in other
                        \ words if QQ3 = %000, %001 or %010 (0, 1 or 2)

 SBC #5                 \ Here QQ3 = %101, %110 or %111 (5, 6 or 7), so subtract
 CLC                    \ 5 to bring it down to 0, 1 or 2 (the C flag is already
                        \ set so the SBC will be correct)

.TT71

 ADC #170               \ A is now 0, 1 or 2, so print recursive token 10 + A.
 JSR TT27               \ This means that:
                        \
                        \   QQ3 = 0 or 5 prints token 10 ("RICH ")
                        \   QQ3 = 1 or 6 prints token 11 ("AVERAGE ")
                        \   QQ3 = 2 or 7 prints token 12 ("POOR ")

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

 LDA #162               \ Print recursive token 2 ("GOVERNMENT") followed by
 JSR TT68               \ a colon

 LDA QQ4                \ The system economy is determined by the value in QQ4,
                        \ so fetch it into A

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

 CLC                    \ Call pr2 to print the technology level as a 3-digit
 JSR pr2                \ number without a decimal point (by clearing the C
                        \ flag)

 JSR TTX69              \ Print a paragraph break and set Sentence Case

 LDA #192               \ Print recursive token 32 ("POPULATION") followed by a
 JSR TT68               \ colon

 SEC                    \ Call pr2 to print the population as a 3-digit number
 LDX QQ6                \ with a decimal point (by setting the C flag), so the
 JSR pr2                \ number printed will be population / 10

 LDA #198               \ Print recursive token 38 (" BILLION"), followed by a
 JSR TT60               \ paragraph break and Sentence Case

 LDA #'('               \ Print an opening bracket
 JSR TT27

 LDA QQ15+4             \ Now to calculate the species, so first check bit 7 of
 BMI TT75               \ s2_lo, and if it is set, jump to TT75 as this is an
                        \ alien species

 LDA #188               \ Bit 7 of s2_lo is clear, so print recursive token 28
 JSR TT27               \ ("HUMAN COLONIAL")

 JMP TT76               \ Jump to TT76 to print "S)" and a paragraph break, so
                        \ the whole species string is "(HUMAN COLONIALS)"

.TT75

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

.TT205

 PLA                    \ Now for the second adjective, so restore A to bits
 LSR A                  \ 2-7 of s2_hi, and throw away bits 2-4 to leave
 LSR A                  \ A = bits 5-7 of s2_hi
 LSR A

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

 LDA QQ15+3             \ Now for the third adjective, so EOR the high bytes of
 EOR QQ15+1             \ s0 and s1 and extract bits 0-2 of the result:
 AND #%00000111         \
 STA QQ19               \   A = (s0_hi EOR s1_hi) AND %111
                        \
                        \ storing the result in QQ19 so we can use it later

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

.TT76

 LDA #'S'               \ Print an "S" to pluralise the species
 JSR TT27

 LDA #')'               \ And finally, print a closing bracket, followed by a
 JSR TT60               \ paragraph break and Sentence Case, to end the species
                        \ section

 LDA #193               \ Print recursive token 33 ("GROSS PRODUCTIVITY"),
 JSR TT68               \ followed by colon

 LDX QQ7                \ Fetch the 16-bit productivity value from QQ7 into
 LDY QQ7+1              \ (Y X)

 JSR pr6                \ Print (Y X) to 5 digits with no decimal point

 JSR TT162              \ Print a space

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

ELIF _MASTER_VERSION

 STZ QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Minor

 LDA #'k'               \ Print "km", returning from the subroutine using a
 JSR TT26               \ tail call
 LDA #'m'
 JMP TT26

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION

 LDA #'k'               \ Print "km"
 JSR TT26
 LDA #'m'
 JSR TT26

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION \ Disc: Extended system descriptions are shown in the enhanced versions, though in the disc version they are only shown when docked, as the PDESC routine isn't present in the flight code due to memory restrictions

 JSR TTX69              \ Print a paragraph break and set Sentence Case

                        \ By this point, ZZ contains the current system number
                        \ which PDESC requires. It gets put there in the TT102
                        \ routine, which calls TT111 to populate ZZ before
                        \ calling TT25 (this routine)

 JMP PDESC              \ Jump to PDESC to print the system's extended
                        \ description, returning from the subroutine using a
                        \ tail call

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED \ Minor

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

ENDIF

