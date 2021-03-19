\ ******************************************************************************
\
\       Name: MU11
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (A P) = P * X
\  Deep dive: Shift-and-add multiplication
\
\ ------------------------------------------------------------------------------
\
\ Do the following multiplication of two unsigned 8-bit numbers:
\
\   (A P) = P * X
\
\ This uses the same shift-and-add approach as MULT1, but it's simpler as we
\ are dealing with unsigned numbers in P and X. See the deep dive on
\ "Shift-and-add multiplication" for a discussion of how this algorithm works.
\
\ ******************************************************************************

.MU11

 DEX                    \ Set T = X - 1
 STX T                  \
                        \ We subtract 1 as the C flag will be set when we want
                        \ to do an addition in the loop below

 LDA #0                 \ Set A = 0 so we can start building the answer in A

IF _CASSETTE_VERSION OR _DISC_VERSION \ Other: The loop in the the MU11 routine in the advanced versions is unrolled to speed it up

 LDX #8                 \ Set up a counter in X to count the 8 bits in P

 LSR P                  \ Set P = P >> 1
                        \ and C flag = bit 0 of P

                        \ We are now going to work our way through the bits of
                        \ P, and do a shift-add for any bits that are set,
                        \ keeping the running total in A. We just did the first
                        \ shift right, so we now need to do the first add and
                        \ loop through the other bits in P

.MUL6

 BCC P%+4               \ If C (i.e. the next bit from P) is set, do the
 ADC T                  \ addition for this bit of P:
                        \
                        \   A = A + T + C
                        \     = A + X - 1 + 1
                        \     = A + X

 ROR A                  \ Shift A right to catch the next digit of our result,
                        \ which the next ROR sticks into the left end of P while
                        \ also extracting the next bit of P

 ROR P                  \ Add the overspill from shifting A to the right onto
                        \ the start of P, and shift P right to fetch the next
                        \ bit for the calculation into the C flag

 DEX                    \ Decrement the loop counter

 BNE MUL6               \ Loop back for the next bit until P has been rotated
                        \ all the way

ELIF _6502SP_VERSION OR _MASTER_VERSION

 TAX                    \ Copy A into X. There is a comment in the original
                        \ source here that says "just in case", which refers to
                        \ the MU11 routine in the cassette and disc versions,
                        \ which set X to 0 (as they use X as a loop counter).
                        \ The version here doesn't use a loop, but this
                        \ instruction makes sure the unrolled version returns
                        \ the same results as the loop versions, just in case
                        \ something out there relies on MU11 returning X = 0

 LSR P                  \ Set P = P >> 1
                        \ and C flag = bit 0 of P

                        \ We now repeat the following four instruction block
                        \ eight times, one for each bit in P. In the cassette
                        \ and disc versions of Elite the following is done with
                        \ a loop, but it is marginally faster to unroll the loop
                        \ and have eight copies of the code, though it does take
                        \ up a bit more memory (though that isn't a concern when
                        \ you have a 6502 Second Processor)

 BCC P%+4               \ If C (i.e. bit 0 of P) is set, do the
 ADC T                  \ addition for this bit of P:
                        \
                        \   A = A + T + C
                        \     = A + X - 1 + 1
                        \     = A + X

 ROR A                  \ Shift A right to catch the next digit of our result,
                        \ which the next ROR sticks into the left end of P while
                        \ also extracting the next bit of P

 ROR P                  \ Add the overspill from shifting A to the right onto
                        \ the start of P, and shift P right to fetch the next
                        \ bit for the calculation into the C flag

 BCC P%+4               \ Repeat for the second time
 ADC T
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the third time
 ADC T
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the fourth time
 ADC T
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the fifth time
 ADC T
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the sixth time
 ADC T
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the seventh time
 ADC T
 ROR A
 ROR P

 BCC P%+4               \ Repeat for the eighth time
 ADC T
 ROR A
 ROR P

ENDIF

 RTS                    \ Return from the subroutine

