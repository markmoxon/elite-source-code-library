\ ******************************************************************************
\
\       Name: GetHeadshotType
\       Type: Subroutine
\   Category: Status
\    Summary: Get the correct headshot number for the current combat rank and
\             status condition
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   S                   The headshot number for the current combat rank and
\                       status condition, in the range 0 to headCount - 1 (13)
\
\ ******************************************************************************

.GetHeadshotType

 LDA TALLY+1            \ Fetch the high byte of the kill tally, and if it is
 BNE rank1              \ not zero, then we have more than 256 kills, so jump
                        \ to rank1 to work out whether we are Competent,
                        \ Dangerous, Deadly or Elite

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
                        \ from 256 to 511, but those are covered by rank1 below

 JMP rank2              \ Jump to rank2

.rank1

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
                        \   Competent       = 1 to 2
                        \   Dangerous       = 2 to 9
                        \   Deadly          = 10 to 24
                        \   Elite           = 25 and up

 LDX #9                 \ Set X to 9 for an Elite rating

 CMP #25                \ If A >= 25, jump to rank2 to get the headshot, as we
 BCS rank2              \ are Elite

 DEX                    \ Decrement X to 8 for a Deadly rating

 CMP #10                \ If A >= 10, jump to rank2 to get the headshot, as we
 BCS rank2              \ are Deadly

 DEX                    \ Decrement X to 7 for a Dangerous rating

 CMP #2                 \ If A >= 2, jump to rank2 to get the headshot, as we
 BCS rank2              \ are Dangerous

 DEX                    \ Decrement X to 6 for a Competent rating

.rank2

                        \ By the time we get here, X contains our combat rank,
                        \ from 1 for Harmless to 9 for Elite

 DEX                    \ Decrement our rank in X into the range 0 to 8

 TXA                    \ Set S = X + X * 2
 STA S                  \       = 3 * X
 ASL A                  \       = 3 * rank
 ADC S                  \
 STA S                  \ The addition works because the ASL A clears the C flag
                        \ as we know bit 7 of A is clear (as A <= 8)

 LDX previousCondition  \ Set X to our ship's condition (0 to 3)

 BEQ rank3              \ If our ship's status condition is non-zero, then we
 DEX                    \ are in space, so decrement X, so we get a value of X
                        \ as follows:
                        \
                        \   * 0 for docked and green conditions
                        \
                        \   * 1 for yellow
                        \
                        \   * 2 for red

.rank3

 TXA                    \ Set X = S + X
 CLC                    \       = 3 * rank + condition
 ADC S                  \
 TAX                    \ where rank is in the range 0 to 8, and condition is
                        \ in the range 0 to 2

 LDA headShotsByRank,X  \ Set A to the correct headshot for this rank and this
                        \ condition

 CMP headCount          \ If A = headCount or more, which is hard-coded to 14,
 BCC rank4              \ then set A = headCount - 1 (i.e. 13)
 LDA headCount          \
 SBC #1                 \ The subtraction works because we know the C flag is
                        \ set as we pass through a CSS to get to the SBC

.rank4

 STA S                  \ Store the headshot number in S

 RTS                    \ Return from the subroutine

