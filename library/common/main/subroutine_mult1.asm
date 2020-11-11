\ ******************************************************************************
\
\       Name: MULT1
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (A P) = Q * A
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

IF _CASSETTE_VERSION

 LDX #7                 \ Set up a counter in X to count the 7 bits remaining
                        \ in P

.MUL4

ELIF _6502SP_VERSION

 TAX \just in case
\MUL4 BCCP%+4\ADCT1\RORA\RORP\DEX\BNEMUL4\LSRA\RORP\ORAT\RTS\.mu10 STAP\RTS
 BCC P%+4
 ADC T1
 ROR A
 ROR P\6
 BCC P%+4
 ADC T1
 ROR A
 ROR P\5
 BCC P%+4
 ADC T1
 ROR A
 ROR P\4
 BCC P%+4
 ADC T1
 ROR A
 ROR P\3
 BCC P%+4
 ADC T1
 ROR A
 ROR P\2
 BCC P%+4
 ADC T1
 ROR A
 ROR P\1

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

IF _CASSETTE_VERSION

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

