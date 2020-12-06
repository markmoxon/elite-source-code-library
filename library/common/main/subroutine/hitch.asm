\ ******************************************************************************
\
\       Name: HITCH
\       Type: Subroutine
\   Category: Tactics
\    Summary: Work out if the ship in INWK is in our crosshairs
\  Deep dive: In the crosshairs
\
\ ------------------------------------------------------------------------------
\
\ This is called by the main flight loop to see if we have laser or missile lock
\ on an enemy ship.
\
\ Returns:
\
\   C flag              Set if the ship is in our crosshairs, clear if it isn't
\
\ Other entry points:
\
\   HI1                 Contains an RTS
\
\ ******************************************************************************

.HITCH

 CLC                    \ Clear the C flag so we can return with it cleared if
                        \ our checks fail

 LDA INWK+8             \ Set A = z_sign

 BNE HI1                \ If A is non-zero then the ship is behind us and can't
                        \ be in our crosshairs, so return from the subroutine
                        \ with the C flag clear (as HI1 contains an RTS)

 LDA TYPE               \ If the ship type has bit 7 set then it is the planet
 BMI HI1                \ or sun, which we can't target or hit with lasers, so
                        \ return from the subroutine with the C flag clear (as
                        \ HI1 contains an RTS)

 LDA INWK+31            \ Fetch bit 5 of byte #31 (the exploding flag) and OR
 AND #%00100000         \ with x_hi and y_hi
 ORA INWK+1
 ORA INWK+4

 BNE HI1                \ If this value is non-zero then either the ship is
                        \ exploding (so we can't target it), or the ship is too
                        \ far away from our line of fire to be targeted, so
                        \ return from the subroutine with the C flag clear (as
                        \ HI1 contains an RTS)

 LDA INWK               \ Set A = x_lo

 JSR SQUA2              \ Set (A P) = A * A = x_lo^2

 STA S                  \ Set (S R) = (A P) = x_lo^2
 LDA P
 STA R

 LDA INWK+3             \ Set A = y_lo

 JSR SQUA2              \ Set (A P) = A * A = y_lo^2

 TAX                    \ Store the high byte in X

 LDA P                  \ Add the two low bytes, so:
 ADC R                  \
 STA R                  \   R = P + R

 TXA                    \ Restore the high byte into A and add S to give the
 ADC S                  \ following:
                        \
                        \   (A R) = (S R) + (A P) = x_lo^2 + y_lo^2

IF _CASSETTE_VERSION

 BCS FR1-2              \ If the addition just overflowed then there is no way
                        \ our crosshairs are within the ship's targetable area,
                        \ so return from the subroutine with the C flag clear
                        \ (as FR1-2 contains a CLC then an RTS)

ELIF _6502SP_VERSION

 BCS TN10               \ If the addition just overflowed then there is no way
                        \ our crosshairs are within the ship's targetable area,
                        \ so return from the subroutine with the C flag clear
                        \ (as TN10 contains a CLC then an RTS)

ENDIF

 STA S                  \ Set (S R) = (A P) = x_lo^2 + y_lo^2

 LDY #2                 \ Fetch the ship's blueprint and set A to the high byte
 LDA (XX0),Y            \ of the targetable area of the ship

 CMP S                  \ We now compare the high bytes of the targetable area
                        \ and the calculation in (S R):
                        \
                        \   * If A >= S then then the C flag will be set
                        \
                        \   * If A < S then the C flag will be C clear

 BNE HI1                \ If A <> S we have just set the C flag correctly, so
                        \ return from the subroutine (as HI1 contains an RTS)

 DEY                    \ The high bytes were identical, so now we fetch the
 LDA (XX0),Y            \ low byte of the targetable area into A

 CMP R                  \ We now compare the low bytes of the targetable area
                        \ and the calculation in (S R):
                        \
                        \   * If A >= R then the C flag will be set
                        \
                        \   * If A < R then the C flag will be C clear

.HI1

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION

.TN10

 CLC
 RTS

ENDIF

