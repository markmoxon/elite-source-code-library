\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\    Summary: Make the sound whose number is in A
ELIF _MASTER_VERSION
\    Summary: Make the sound whose number is in Y by populating the sound buffer
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ Arguments:
\
\   A                   The number of the sound to be made. See the
\                       documentation for variable SFX for a list of sound
\                       numbers
ELIF _MASTER_VERSION
\ The following sounds can be made by this routine. Two-part noises are made by
\ consecutive calls to this routine with different values of Y. The routine
\ doesn't make any sounds itself; instead, it populates the sound buffer at
\ SOFLG with the relevant sound data, and the interrupt handler at IRQ1 calls
\ the SOINT routine to process the data in the sound buffer and send it to the
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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the sound to be made from the above table
ENDIF
\
\ ******************************************************************************

.NOISE

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: The Master supports a much more sophisticated interrupt-driven sound system rather than the standard sound envelope system that the other versions use

 JSR NOS1               \ Set up the sound block in XX16 for the sound in A and
                        \ fall through into NO3 to make the sound

ELIF _MASTER_VERSION

                        \ This routine appears to set up the contents of the
                        \ SOFLG sound buffer, so the SOINT routine can then send
                        \ the results to the 76489 sound chip. How this all
                        \ works is a bit of a mystery, so this part needs more
                        \ investigation

 LDA DNOIZ              \ If DNOIZ is non-zero, then sound is disabled, so
 BNE SOUR1              \ return from the subroutine (as SOUR1 contains an RTS)

 LDA SFXBT,Y            \ Fetch SFXBT+Y and shift bit 0 into the C flag
 LSR A

 CLV                    \ Clear the V flag

 LDX #0                 \ If bit 0 of SFXBT+Y is set, set X = 0 and jump to
 BCS SOUS4              \ SOUS4

 INX                    \ Increment X to 1

 LDA SOPR+1             \ If SOPR+1 < SOPR+2, set X = 1 and jump to SOUS4
 CMP SOPR+2
 BCC SOUS4

 INX                    \ SOPR+1 >= SOPR+2, so increment X to 2

\JSR SOUS4              \ These instructions are commented out in the original
\BCC SOUR1              \ source
\DEX
\BIT SOUR1 \SEV!!
\LDA SFXPR,Y
\AND #&10
\BEQ SOUS9
\RTS
\fall into SOUS4 since this facility not needed

.SOUS4

                        \ By the time we get here, X is set as follows:
                        \
                        \   * X = 0 if bit 0 of SFXBT+Y is set
                        \   * X = 1 if SOPR+1 < SOPR+2
                        \   * X = 2 if SOPR+1 >= SOPR+2

 LDA SFXPR,Y            \ Set A = SFXPR+Y

.SOUS9

 CMP SOPR,X             \ If SFXPR+Y < SOPR+X, return from the subroutine
 BCC SOUR1              \ (as SOUR1 contains an RTS)

 SEI                    \ Disable interrupts while we update the sound buffer

                        \ If we get here then SFXPR+Y >= SOPR+X

 STA SOPR,X             \ SOPR+X = A = SFXPR+Y

 LSR A                  \ Store bits 1-3 of SFXPR+Y in bits 0-2 of SOVOL+X
 AND #%00000111
 STA SOVOL,X

 LDA SFXVC,Y            \ Store SFXVC+Y in SOVCH+X
 STA SOVCH,X

 LDA SFXBT,Y            \ Store SFXBT+Y in SOCNT+X
 STA SOCNT,X

 AND #%00001111         \ Store bits 1-3 of SFXBT+Y in bits 0-2 of SOFRCH+X
 LSR A
 STA SOFRCH,X

 LDA SFXFQ,Y            \ Set A = SFXFQ+Y

 BVC P%+3               \ If the V flag is set, double the value in A
 ASL A

 STA SOFRQ,X            \ Store A in SOFRQ+X

 LDA #%10000000         \ Set bit 7 of SOFLG+X
 STA SOFLG,X

 CLI                    \ Enable interrupts again

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

ENDIF

