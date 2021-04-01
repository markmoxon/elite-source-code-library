\ ******************************************************************************
\
\       Name: DIALS (Part 2 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: pitch and roll indicators
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Minor

 LDA #0                 \ Set R = P = 0 for the low bytes in the call to the ADD
 STA R                  \ routine below
 STA P

ELIF _MASTER_VERSION

 STZ R                  \ Set R = P = 0 for the low bytes in the call to the ADD
 STZ P                  \ routine below

ENDIF

 LDA #8                 \ Set S = 8, which is the value of the centre of the
 STA S                  \ roll indicator

 LDA ALP1               \ Fetch the roll angle alpha as a value between 0 and
 LSR A                  \ 31, and divide by 4 to get a value of 0 to 7
 LSR A

 ORA ALP2               \ Apply the roll sign to the value, and flip the sign,
 EOR #%10000000         \ so it's now in the range -7 to +7, with a positive
                        \ roll angle alpha giving a negative value in A

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Label

 JSR ADD                \ We now add A to S to give us a value in the range 1 to
ELIF _MASTER_VERSION

 JSR ADD_DUPLICATE      \ We now add A to S to give us a value in the range 1 to
ENDIF
                        \ 15, which we can pass to DIL2 to draw the vertical
                        \ bar on the indicator at this position. We use the ADD
                        \ routine like this:
                        \
                        \ (A X) = (A 0) + (S 0)
                        \
                        \ and just take the high byte of the result. We use ADD
                        \ rather than a normal ADC because ADD separates out the
                        \ sign bit and does the arithmetic using absolute values
                        \ and separate sign bits, which we want here rather than
                        \ the two's complement that ADC uses

 JSR DIL2               \ Draw a vertical bar on the roll indicator at offset A
                        \ and increment SC to point to the next indicator (the
                        \ pitch indicator)

 LDA BETA               \ Fetch the pitch angle beta as a value between -8 and
                        \ +8

 LDX BET1               \ Fetch the magnitude of the pitch angle beta, and if it
 BEQ P%+4               \ is 0 (i.e. we are not pitching), skip the next
                        \ instruction

 SBC #1                 \ The pitch angle beta is non-zero, so set A = A - 1
                        \ (the C flag is set by the call to DIL2 above, so we
                        \ don't need to do a SEC). This gives us a value of A
                        \ from -7 to +7 because these are magnitude-based
                        \ numbers with sign bits, rather than two's complement
                        \ numbers

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Label

 JSR ADD                \ We now add A to S to give us a value in the range 1 to
ELIF _MASTER_VERSION

 JSR ADD_DUPLICATE      \ We now add A to S to give us a value in the range 1 to
ENDIF
                        \ 15, which we can pass to DIL2 to draw the vertical
                        \ bar on the indicator at this position (see the JSR ADD
                        \ above for more on this)

 JSR DIL2               \ Draw a vertical bar on the pitch indicator at offset A
                        \ and increment SC to point to the next indicator (the
                        \ four energy banks)

