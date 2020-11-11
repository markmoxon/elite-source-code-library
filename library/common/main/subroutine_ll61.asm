\ ******************************************************************************
\
\       Name: LL61
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (U R) = 256 * A / Q
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following, where A >= Q:
\
\   (U R) = 256 * A / Q
\
\ This is a sister routine to LL28, which does the division when A < Q.
\
\ ******************************************************************************

.LL61

 LDX Q                  \ If Q = 0, jump down to LL84 to return a division
 BEQ LL84               \ error

                        \ The LL28 routine returns A / Q, but only if A < Q. In
                        \ our case A >= Q, but we still want to use the LL28
                        \ routine, so we halve A until it's less than Q, call
                        \ the division routine, and then double A by the same
                        \ number of times

 LDX #0                 \ Set X = 0 to count the number of times we halve A

.LL63

 LSR A                  \ Halve A by shifting right

 INX                    \ Increment X

 CMP Q                  \ If A >= Q, loop back to LL63 to halve it again
 BCS LL63

 STX S                  \ Otherwise store the number of times we halved A in S

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \
                        \ which we can do now as A < Q

 LDX S                  \ Otherwise restore the number of times we halved A
                        \ above into X

 LDA R                  \ Set A = our division result

.LL64

 ASL A                  \ Double (U A) by shifting left
 ROL U

 BMI LL84               \ If bit 7 of U is set, the doubling has overflowed, so
                        \ jump to LL84 to return a division error

 DEX                    \ Decrement X

 BNE LL64               \ If X is not yet zero then we haven't done as many
                        \ doublings as we did halvings earlier, so loop back for
                        \ another doubling

 STA R                  \ Store the low byte of the division result in R

 RTS                    \ Return from the subroutine

.LL84

 LDA #50                \ If we get here then either we tried to divide by 0, or
 STA R                  \ the result overflowed, so we set U and R to 50
 STA U

 RTS                    \ Return from the subroutine


