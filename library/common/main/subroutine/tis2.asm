\ ******************************************************************************
\
\       Name: TIS2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate A = A / Q
\  Deep dive: Shift-and-subtract division
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following division, where A is a sign-magnitude number and Q is
\ a positive integer:
\
\   A = A / Q
\
\ The value of A is returned as a sign-magnitude number with 96 representing 1,
\ and the maximum value returned is 1 (i.e. 96). This routine is used when
\ normalising vectors, where we represent fractions using integers, so this
\ gives us an approximation to two decimal places.
\
\ ******************************************************************************

.TIS2

 TAY                    \ Store the argument A in Y

 AND #%01111111         \ Strip the sign bit from the argument, so A = |A|

 CMP Q                  \ If A >= Q then jump to TI4 to return a 1 with the
 BCS TI4                \ correct sign

 LDX #%11111110         \ Set T to have bits 1-7 set, so we can rotate through 7
 STX T                  \ loop iterations, getting a 1 each time, and then
                        \ getting a 0 on the 8th iteration... and we can also
                        \ use T to catch our result bits into bit 0 each time

.TIL2

 ASL A                  \ Shift A to the left

 CMP Q                  \ If A < Q skip the following subtraction
 BCC P%+4

 SBC Q                  \ A >= Q, so set A = A - Q
                        \
                        \ Going into this subtraction we know the C flag is
                        \ set as we passed through the BCC above, and we also
                        \ know that A >= Q, so the C flag will still be set once
                        \ we are done

 ROL T                  \ Rotate the counter in T to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCS TIL2               \ If we still have set bits in T, loop back to TIL2 to
                        \ do the next iteration of 7

                        \ We've done the division and now have a result in the
                        \ range 0-255 here, which we need to reduce to the range
                        \ 0-96. We can do that by multiplying the result by 3/8,
                        \ as 256 * 3/8 = 96

 LDA T                  \ Set T = T / 4
 LSR A
 LSR A
 STA T

 LSR A                  \ Set T = T / 8 + T / 4
 ADC T                  \       = 3T / 8
 STA T

 TYA                    \ Fetch the sign bit of the original argument A
 AND #%10000000

 ORA T                  \ Apply the sign bit to T

 RTS                    \ Return from the subroutine

.TI4

 TYA                    \ Fetch the sign bit of the original argument A
 AND #%10000000

 ORA #96                \ Apply the sign bit to 96 (which represents 1)

 RTS                    \ Return from the subroutine

