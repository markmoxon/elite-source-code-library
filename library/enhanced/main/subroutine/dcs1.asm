\ ******************************************************************************
\
\       Name: DCS1
\       Type: Subroutine
\   Category: Flight
\    Summary: Calculate the vector from the ideal docking position to the ship
\
\ ------------------------------------------------------------------------------
\
\ This routine is called by the docking computer routine in DOCKIT. It works out
\ the vector between the ship and the ideal docking position, which is straight
\ in front of the docking slot, but some distance away.
\
\ Specifically, it calculates the following:
\
\   * K3(2 1 0) = K3(2 1 0) - nosev_x_hi * 4
\
\   * K3(5 4 3) = K3(5 4 3) - nosev_y_hi * 4
\
\   * K3(8 7 6) = K3(8 7 6) - nosev_x_hi * 4
\
\ where K3 is the vector from the station to the ship, and nosev is the nose
\ vector for the space station.
\
\ The nose vector points from the centre of the station through the slot, so
\ -nosev * 4 is the vector from a point in front of the docking slot, but some
\ way from the station, back to the centre of the station. Adding this to the
\ vector from the station to the ship gives the vector from the point in front
\ of the station to the ship.
\
\ In practice, this routine is called twice, so the ideal docking position is
\ actually at a distance of 8 unit vectors from the centre of the station.
\
\ Back in DOCKIT, we flip this vector round to get the vector from the ship to
\ the point in front of the station slot.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K3                  The vector from the station to the ship
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   K3                  The vector from the ship to the ideal docking position
\                       (4 unit vectors from the centre of the station for each
\                       call to DCS1, so two calls will return the vector to a
\                       point that's 8 unit vectors from the centre of the
\                       station)
\
\ ******************************************************************************

.DCS1

 JSR P%+3               \ Run the following routine twice, so the subtractions
                        \ are all * 4

IF NOT(_NES_VERSION)

 LDA K%+NI%+10          \ Set A to the space station's byte #10, nosev_x_hi

ELIF _NES_VERSION

 LDA K%+NIK%+10         \ Set A to the space station's byte #10, nosev_x_hi

ENDIF

 LDX #0                 \ Set K3(2 1 0) = K3(2 1 0) - A * 2
 JSR TAS7               \               = K3(2 1 0) - nosev_x_hi * 2

IF NOT(_NES_VERSION)

 LDA K%+NI%+12          \ Set A to the space station's byte #12, nosev_y_hi

ELIF _NES_VERSION

 LDA K%+NIK%+12         \ Set A to the space station's byte #12, nosev_y_hi

ENDIF

 LDX #3                 \ Set K3(5 4 3) = K3(5 4 3) - A * 2
 JSR TAS7               \               = K3(5 4 3) - nosev_y_hi * 2

IF NOT(_NES_VERSION)

 LDA K%+NI%+14          \ Set A to the space station's byte #14, nosev_z_hi

ELIF _NES_VERSION

 LDA K%+NIK%+14         \ Set A to the space station's byte #14, nosev_z_hi

ENDIF

 LDX #6                 \ Set K3(8 7 6) = K3(8 7 6) - A * 2
                        \               = K3(8 7 6) - nosev_x_hi * 2

.TAS7

                        \ This routine subtracts A * 2 from one of the K3
                        \ coordinates, as determined by the value of X:
                        \
                        \   * X = 0, set K3(2 1 0) = K3(2 1 0) - A * 2
                        \
                        \   * X = 3, set K3(5 4 3) = K3(5 4 3) - A * 2
                        \
                        \   * X = 6, set K3(8 7 6) = K3(8 7 6) - A * 2
                        \
                        \ Let's document it for X = 0, i.e. K3(2 1 0)

 ASL A                  \ Shift A left one place and move the sign bit into the
                        \ C flag, so A = |A * 2|

 STA R                  \ Set R = |A * 2|

 LDA #0                 \ Rotate the sign bit of A from the C flag into the sign
 ROR A                  \ bit of A, so A is now just the sign bit from the
                        \ original value of A. This also clears the C flag

 EOR #%10000000         \ Flip the sign bit of A, so it has the sign of -A

 EOR K3+2,X             \ Give A the correct sign of K3(2 1 0) * -A

 BMI TS71               \ If the sign of K3(2 1 0) * -A is negative, jump to
                        \ TS71, as K3(2 1 0) and A have the same sign

                        \ If we get here then K3(2 1 0) and A have different
                        \ signs, so we can add them to do the subtraction

 LDA R                  \ Set K3(2 1 0) = K3(2 1 0) + R
 ADC K3,X               \               = K3(2 1 0) + |A * 2|
 STA K3,X               \
                        \ starting with the low bytes

 BCC TS72               \ If the above addition didn't overflow, we have the
                        \ result we want, so jump to TS72 to return from the
                        \ subroutine

 INC K3+1,X             \ The above addition overflowed, so increment the high
                        \ byte of K3(2 1 0)

.TS72

 RTS                    \ Return from the subroutine

.TS71

                        \ If we get here, then K3(2 1 0) and A have the same
                        \ sign

 LDA K3,X               \ Set K3(2 1 0) = K3(2 1 0) - R
 SEC                    \               = K3(2 1 0) - |A * 2|
 SBC R                  \
 STA K3,X               \ starting with the low bytes

 LDA K3+1,X             \ And then the high bytes
 SBC #0
 STA K3+1,X

 BCS TS72               \ If the subtraction didn't underflow, we have the
                        \ result we want, so jump to TS72 to return from the
                        \ subroutine

 LDA K3,X               \ Negate the result in K3(2 1 0) by flipping all the
 EOR #%11111111         \ bits and adding 1, i.e. using two's complement to
 ADC #1                 \ give it the opposite sign, starting with the low
 STA K3,X               \ bytes

 LDA K3+1,X             \ Then doing the high bytes
 EOR #%11111111
 ADC #0
 STA K3+1,X

 LDA K3+2,X             \ And finally, flipping the sign bit
 EOR #%10000000
 STA K3+2,X

 JMP TS72               \ Jump to TS72 to return from the subroutine

