\ ******************************************************************************
\
\       Name: MULT1
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (A P) = Q * A
\  Deep dive: Shift-and-add multiplication
\
\ ------------------------------------------------------------------------------
\
\ Do the following multiplication of two 8-bit sign-magnitude numbers:
\
\   (A P) = Q * A
\
\ ******************************************************************************

.MULT1

 TAX                    \ Store A in X

 AND #%01111111         \ Set P = |A| >> 1
 LSR A                  \ and C flag = bit 0 of A
 STA P

 TXA                    \ Restore argument A

 EOR Q                  \ Set bit 7 of A and T if Q and A have different signs,
 AND #%10000000         \ clear bit 7 if they have the same signs, 0 all other
 STA T                  \ bits, i.e. T contains the sign bit of Q * A

 LDA Q                  \ Set A = |Q|
 AND #%01111111

 BEQ mu10               \ If |Q| = 0 jump to mu10 (with A set to 0)

 TAX                    \ Set T1 = |Q| - 1
 DEX                    \
 STX T1                 \ We subtract 1 as the C flag will be set when we want
                        \ to do an addition in the loop below

                        \ We are now going to work our way through the bits of
                        \ P, and do a shift-add for any bits that are set,
                        \ keeping the running total in A. We already set up
                        \ the first shift at the start of this routine, as
                        \ P = |A| >> 1 and C = bit 0 of A, so we now need to set
                        \ up a loop to sift through the other 7 bits in P

 LDA #0                 \ Set A = 0 so we can start building the answer in A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: Group A: The loop of the MULT1 routine in the advanced versions is unrolled to speed it up

 LDX #7                 \ Set up a counter in X to count the 7 bits remaining
                        \ in P

.MUL4

ELIF _6502SP_VERSION OR _MASTER_VERSION

 TAX                    \ Copy A into X. There is a comment in the original
                        \ source here that says "just in case", which refers to
                        \ the MULT1 routine in the cassette and disc versions,
                        \ which set X to 0 (as they use X as a loop counter).
                        \ The version here doesn't use a loop, but this
                        \ instruction makes sure the unrolled version returns
                        \ the same results as the loop versions, just in case
                        \ something out there relies on MULT1 returning X = 0

\MUL4                   \ These instructions are commented out in the original
\BCC P%+4               \ source. They contain the original loop version of the
\ADC T1                 \ code that's used in the disc and cassette versions
\ROR A
\ROR P
\DEX
\BNE MUL4
\LSR A
\ROR P
\ORA T
\RTS
\.mu10
\STA P
\RTS

                        \ We now repeat the following four instruction block
                        \ seven times, one for each remaining bit in P. In the
                        \ cassette and disc versions of Elite the following is
                        \ done with a loop, but it is marginally faster to
                        \ unroll the loop and have seven copies of the code,
                        \ though it does take up a bit more memory (though that
                        \ isn't a concern when you have a 6502 Second Processor)
ENDIF

 BCC P%+4               \ If C (i.e. the next bit from P) is set, do the
 ADC T1                 \ addition for this bit of P:
                        \
                        \   A = A + T1 + C
                        \     = A + |Q| - 1 + 1
                        \     = A + |Q|

 ROR A                  \ As mentioned above, this ROR shifts A right and
                        \ catches bit 0 in C - giving another digit for our
                        \ result - and the next ROR sticks that bit into the
                        \ left end of P while also extracting the next bit of P
                        \ for the next addition

 ROR P                  \ Add the overspill from shifting A to the right onto
                        \ the start of P, and shift P right to fetch the next
                        \ bit for the calculation

IF _6502SP_VERSION OR _MASTER_VERSION \ Other: See group A

 BCC P%+4               \ Repeat for the second time
 ADC T1
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the third time
 ADC T1
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the fourth time
 ADC T1
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the fifth time
 ADC T1
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the sixth time
 ADC T1
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the seventh time
 ADC T1
 ROR A
 ROR P

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: See group A

 DEX                    \ Decrement the loop counter

 BNE MUL4               \ Loop back for the next bit until P has been rotated
                        \ all the way

ENDIF

 LSR A                  \ Rotate (A P) once more to get the final result, as
 ROR P                  \ we only pushed 7 bits through the above process

 ORA T                  \ Set the sign bit of the result that we stored in T

 RTS                    \ Return from the subroutine

.mu10

 STA P                  \ If we get here, the result is 0 and A = 0, so set
                        \ P = 0 so (A P) = 0

 RTS                    \ Return from the subroutine

