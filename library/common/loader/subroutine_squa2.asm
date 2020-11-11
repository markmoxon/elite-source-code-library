\ ******************************************************************************
\
\       Name: SQUA2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (A P) = A * A
\
\ ------------------------------------------------------------------------------
\
\ Do the following multiplication of unsigned 8-bit numbers:
\
\   (A P) = A * A
\
\ This uses the same approach as routine SQUA2 in the main game code, which
\ itself uses the MU11 routine to do the multiplication. See those routines for
\ more details.
\
\ ******************************************************************************

.SQUA2

 BPL SQUA               \ If A > 0, jump to SQUA

 EOR #&FF               \ Otherwise we need to negate A for the SQUA algorithm
 CLC                    \ to work, so we do this using two's complement, by
 ADC #1                 \ setting A = ~A + 1

.SQUA

 STA Q                  \ Set Q = A and P = A

 STA P                  \ Set P = A

 LDA #0                 \ Set A = 0 so we can start building the answer in A

 LDY #8                 \ Set up a counter in Y to count the 8 bits in P

 LSR P                  \ Set P = P >> 1
                        \ and C flag = bit 0 of P

.SQL1

 BCC SQ1                \ If C (i.e. the next bit from P) is set, do the
 CLC                    \ addition for this bit of P:
 ADC Q                  \
                        \   A = A + Q

.SQ1

 ROR A                  \ Shift A right to catch the next digit of our result,
                        \ which the next ROR sticks into the left end of P while
                        \ also extracting the next bit of P

 ROR P                  \ Add the overspill from shifting A to the right onto
                        \ the start of P, and shift P right to fetch the next
                        \ bit for the calculation into the C flag

 DEY                    \ Decrement the loop counter

 BNE SQL1               \ Loop back for the next bit until P has been rotated
                        \ all the way

 RTS                    \ Return from the subroutine

