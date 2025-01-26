\ ******************************************************************************
\
\       Name: PrintCombatRank
\       Type: Subroutine
\   Category: Status
\    Summary: Print the current combat rank
\
\ ------------------------------------------------------------------------------
\
\ This routine is based on part of the STATUS routine from the original source,
\ so I have kept the original st3 and st4 labels.
\
\ ******************************************************************************

.PrintCombatRank

 LDA #16                \ Print recursive token 130 ("RATING:") followed by
 JSR TT68               \ a colon

 LDA languageNumber     \ If bit 0 of languageNumber is clear then the chosen
 AND #%00000001         \ language is not English, so skip the following
 BEQ P%+5               \ instruction (as the screen has a different layout in
                        \ the other languages)

 JSR TT162              \ Print a space

 LDA TALLY+1            \ Fetch the high byte of the kill tally, and if it is
 BNE st4                \ not zero, then we have more than 256 kills, so jump
                        \ to st4 to work out whether we are Competent,
                        \ Dangerous, Deadly or Elite

                        \ Otherwise we have fewer than 256 kills, so we are one
                        \ of Harmless, Mostly Harmless, Poor, Average or Above
                        \ Average

 TAX                    \ Set X to 0 (as A is 0)

 LDX TALLY              \ Set X to the low byte of the kill tally

 CPX #0                 \ Increment A if X >= 0
 ADC #0

 CPX #2                 \ Increment A if X >= 2
 ADC #0

 CPX #8                 \ Increment A if X >= 8
 ADC #0

 CPX #24                \ Increment A if X >= 24
 ADC #0

 CPX #44                \ Increment A if X >= 44
 ADC #0

 CPX #130               \ Increment A if X >= 130
 ADC #0

 TAX                    \ Set X to A, which will be as follows:
                        \
                        \   * 1 (Harmless)        when TALLY = 0 or 1
                        \
                        \   * 2 (Mostly Harmless) when TALLY = 2 to 7
                        \
                        \   * 3 (Poor)            when TALLY = 8 to 23
                        \
                        \   * 4 (Average)         when TALLY = 24 to 43
                        \
                        \   * 5 (Above Average)   when TALLY = 44 to 129
                        \
                        \   * 6 (Competent)       when TALLY = 130 to 255
                        \
                        \ Note that the Competent range also covers kill counts
                        \ from 256 to 511, but those are covered by st4 below

.st3

 TXA                    \ Store the combat rank in X on the stack
 PHA

 LDA languageNumber     \ If bits 0 and 2 of languageNumber are clear then the
 AND #%00000101         \ chosen language is not English or French, so skip
 BEQ P%+8               \ the following two instructions (as the screen has a
                        \ different layout in German)

 JSR TT162              \ Print two spaces
 JSR TT162

 PLA                    \ Set A to the combat rank we stored on the stack above

 CLC                    \ Print recursive token 135 + A, which will be in the
 ADC #21                \ range 136 ("HARMLESS") to 144 ("---- E L I T E ----")
 JMP plf                \ followed by a newline, returning from the subroutine
                        \ using a tail call

.st4

                        \ We call this from above with the high byte of the
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
                        \   Competent = 1
                        \   Dangerous = 2 to 9
                        \   Deadly    = 10 to 24
                        \   Elite     = 25 and up

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

