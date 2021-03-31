\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION
\    Summary: Make the sound whose number is in A
ELIF _MASTER_VERSION
\    Summary: Make the sound whose number is in Y
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION
\ Arguments:
\
\   A                   The number of the sound to be made. See the
\                       documentation for variable SFX for a list of sound
\                       numbers
ELIF _MASTER_VERSION
\ The following sounds can be made by this routine. Two-part noises are made by
\ consecutive calls to this routine woth different values of Y.
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

 LDA DNOIZ              \ ???
 BNE SRTS

 LDA SFX2,Y
 LSR A
 CLV
 LDX #0
 BCS NS1

 INX
 LDA SBUF+13
 CMP SBUF+14
 BCC NS1

 INX

.NS1

 LDA SFX1,Y
 CMP SBUF+12,X
 BCC SRTS

 SEI
 STA SBUF+12,X
 LSR A
 AND #&07
 STA SBUF+6,X
 LDA SFX4,Y
 STA SBUF+9,X
 LDA SFX2,Y
 STA SBUF+3,X
 AND #&0F
 LSR A
 STA SBUF+15,X
 LDA SFX3,Y
 BVC P%+3

 ASL A

 STA SBUF+18,X
 LDA #&80
 STA SBUF,X
 CLI

 SEC

 RTS

ENDIF

