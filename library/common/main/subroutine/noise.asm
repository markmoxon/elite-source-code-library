\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Comment
\    Summary: Make the sound whose number is in A
ELIF _MASTER_VERSION
\    Summary: Make the sound whose number is in Y by populating the sound buffer
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Comment
\ Arguments:
\
\   A                   The number of the sound to be made. See the
\                       documentation for variable SFX for a list of sound
\                       numbers
ELIF _MASTER_VERSION
\ The following sounds can be made by this routine. Two-part noises are made by
\ consecutive calls to this routine with different values of Y. The routine
\ doesn't make any sounds itself; instead, it populates the sound buffer at
\ SBUF with the relevant sound data, and the interrupt handler at IRQ1 calls
\ the NOISE2 routine to process the data in the sound buffer and send it to the
\ 76489 sound chip.
\
\ This routine can make the following sounds depending on the value of Y:
\
\   0       Long, low beep
\   1       Short, high beep
\   3, 5    Lasers fired by us
\   4       We died / Collision / Our depleted shields being hit by lasers
\   6       We made a hit or kill / Energy bomb / Other ship exploding
\   7       E.C.M. on
\   8       Missile launched / Ship launched from station
\   9, 5    We're being hit by lasers
\   10, 11  Hyperspace drive engaged
\
\ Arguments:
\
\   Y                   The number of the sound to be made from the above table
ENDIF
\
\ ******************************************************************************

.NOISE

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 JSR NOS1               \ Set up the sound block in XX16 for the sound in A and
                        \ fall through into NO3 to make the sound

ELIF _MASTER_VERSION

                        \ This routine appears to set up the contents of the
                        \ SBUF sound buffer, so the NOISE2 routine can then send
                        \ the results to the 76489 sound chip. How this all
                        \ works is a bit of a mystery, so this part needs more
                        \ investigation

 LDA DNOIZ              \ If DNOIZ is non-zero, then sound is disabled, so
 BNE SRTS               \ return from the subroutine (as SRTS contains an RTS)

 LDA SFX2,Y             \ Fetch SFX2+Y and shift bit 0 into the C flag
 LSR A

 CLV                    \ Clear the V flag

 LDX #0                 \ If bit 0 of SFX2+Y is set, set X = 0 and jump to NS1
 BCS NS1

 INX                    \ Increment X to 1

 LDA SBUF+13            \ If SBUF+13 < SBUF+14, set X = 1 and jump to NS1
 CMP SBUF+14
 BCC NS1

 INX                    \ SBUF+13 >= SBUF+14, so increment X to 2

.NS1

                        \ By the time we get here, X is set as follows:
                        \
                        \   * X = 0 if bit 0 of SFX2+Y is set
                        \   * X = 1 if SBUF+13 < SBUF+14
                        \   * X = 2 if SBUF+13 >= SBUF+14

 LDA SFX1,Y             \ Set A = SFX1+Y

 CMP SBUF+12,X          \ If SFX1+Y < SBUF+12+X, return from the subroutine
 BCC SRTS

 SEI                    \ Disable interrupts while we update the sound buffer

                        \ If we get here then SFX1+Y >= SBUF+12+X

 STA SBUF+12,X          \ SBUF+12+X = A = SFX1+Y

 LSR A                  \ Store bits 1-3 of SFX1+Y in bits 0-2 of SBUF+6+X
 AND #%00000111
 STA SBUF+6,X

 LDA SFX4,Y             \ Store SFX4+Y in SBUF+9+X
 STA SBUF+9,X

 LDA SFX2,Y             \ Store SFX2+Y in SBUF+3+X
 STA SBUF+3,X

 AND #%00001111         \ Store bits 1-3 of SFX2+Y in bits 0-2 of SBUF+15+X
 LSR A
 STA SBUF+15,X

 LDA SFX3,Y             \ Set A = SFX3+Y

 BVC P%+3               \ If the V flag is set, double the value in A
 ASL A

 STA SBUF+18,X          \ Store A in SBUF+18+X

 LDA #%10000000         \ Set bit 7 of SBUF+X
 STA SBUF,X

 CLI                    \ Enable interrupts again

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

ENDIF

