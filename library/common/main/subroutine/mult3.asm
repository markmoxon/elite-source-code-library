\ ******************************************************************************
\
\       Name: MULT3
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate K(3 2 1 0) = (A P+1 P) * Q
\  Deep dive: Shift-and-add multiplication
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following multiplication between a signed 24-bit number and a
\ signed 8-bit number, returning the result as a signed 32-bit number:
\
\   K(3 2 1 0) = (A P+1 P) * Q
\
\ The algorithm is the same shift-and-add algorithm as in routine MULT1, but
\ extended to cope with more bits.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.MULT3

 STA R                  \ Store the high byte of (A P+1 P) in R

 AND #%01111111         \ Set K+2 to |A|, the high byte of K(2 1 0)
 STA K+2

 LDA Q                  \ Set A to bits 0-6 of Q, so A = |Q|
 AND #%01111111

 BEQ MU5                \ If |Q| = 0, jump to MU5 to set K(3 2 1 0) to 0,
                        \ returning from the subroutine using a tail call

 SEC                    \ Set T = |Q| - 1
 SBC #1
 STA T

                        \ We now use the same shift-and-add algorithm as MULT1
                        \ to calculate the following:
                        \
                        \ K(2 1 0) = K(2 1 0) * |Q|
                        \
                        \ so we start with the first shift right, in which we
                        \ take (K+2 P+1 P) and shift it right, storing the
                        \ result in K(2 1 0), ready for the multiplication loop
                        \ (so the multiplication loop actually calculates
                        \ (|A| P+1 P) * |Q|, as the following sets K(2 1 0) to
                        \ (|A| P+1 P) shifted right)

 LDA P+1                \ Set A = P+1

 LSR K+2                \ Shift the high byte in K+2 to the right

 ROR A                  \ Shift the middle byte in A to the right and store in
 STA K+1                \ K+1 (so K+1 contains P+1 shifted right)

 LDA P                  \ Shift the middle byte in P to the right and store in
 ROR A                  \ K, so K(2 1 0) now contains (|A| P+1 P) shifted right
 STA K

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

                        \ We now use the same shift-and-add algorithm as MULT1
                        \ to calculate the following:
                        \
                        \ K(2 1 0) = K(2 1 0) * |Q|

 LDA #0                 \ Set A = 0 so we can start building the answer in A

 LDX #24                \ Set up a counter in X to count the 24 bits in K(2 1 0)

.MUL2

 BCC P%+4               \ If C (i.e. the next bit from K) is set, do the
 ADC T                  \ addition for this bit of K:
                        \
                        \   A = A + T + C
                        \     = A + |Q| - 1 + 1
                        \     = A + |Q|

 ROR A                  \ Shift A right by one place to catch the next digit
 ROR K+2                \ next digit of our result in the left end of K(2 1 0),
 ROR K+1                \ while also shifting K(2 1 0) right to fetch the next
 ROR K                  \ bit for the calculation into the C flag
                        \
                        \ On the last iteration of this loop, the bit falling
                        \ off the end of K will be bit 0 of the original A, as
                        \ we did one shift before the loop and we are doing 24
                        \ iterations. We set A to 0 before looping, so this
                        \ means the loop exits with the C flag clear

 DEX                    \ Decrement the loop counter

 BNE MUL2               \ Loop back for the next bit until K(2 1 0) has been
                        \ rotated all the way

                        \ The result (|A| P+1 P) * |Q| is now in (A K+2 K+1 K),
                        \ but it is positive and doesn't have the correct sign
                        \ of the final result yet

 STA T                  \ Save the high byte of the result into T

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA R                  \ Fetch the sign byte from the original (A P+1 P)
                        \ argument that we stored in R

 EOR Q                  \ EOR with Q so the sign bit is the same as that of
                        \ (A P+1 P) * Q

 AND #%10000000         \ Extract the sign bit

 ORA T                  \ Apply this to the high byte of the result in T, so
                        \ that A now has the correct sign for the result, and
                        \ (A K+2 K+1 K) therefore contains the correctly signed
                        \ result

 STA K+3                \ Store A in K+3, so K(3 2 1 0) now contains the result

 RTS                    \ Return from the subroutine

