\ ******************************************************************************
\
\       Name: PIXEL2
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a stardust particle relative to the screen centre
IF _NES_VERSION
\  Deep dive: Sprite usage in NES Elite
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ Draw a point (X1, Y1) from the middle of the screen with a size determined by
\ a distance value. Used to draw stardust particles.
ELIF _NES_VERSION
\ Draw a stardust particle sprite at point (X1, Y1) from the middle of the
\ screen with a size determined by a distance value.
ENDIF
\
\ Arguments:
\
\   X1                  The x-coordinate offset
\
\   Y1                  The y-coordinate offset (positive means up the screen
\                       from the centre, negative means down the screen)
\
\   ZZ                  The distance of the point (further away = smaller point)
\
IF _NES_VERSION
\   Y                   The number of the stardust particle (1 to 20)
\
ENDIF
\ ******************************************************************************

.PIXEL2

IF _NES_VERSION

 STY T1                 \ Store Y in T1 so we can retrieve it at the end of the
                        \ subroutine

 TYA                    \ Set Y = Y * 4
 ASL A                  \
 ASL A                  \ So Y can be used as an index into the sprite buffer,
 TAY                    \ starting with sprite 38 for stardust particle 1, up to
                        \ sprite 57 for stardust particle 20

 LDA #210               \ Set A = 210 to use as the pattern number for the
                        \ largest particle of stardust (the stardust particle
                        \ patterns run from pattern 210 to 214, decreasing in
                        \ size as the number increases)

 LDX ZZ                 \ If ZZ >= 24, increment A
 CPX #24
 ADC #0

 CPX #48                \ If ZZ >= 48, increment A
 ADC #0

 CPX #112               \ If ZZ >= 112, increment A
 ADC #0

 CPX #144               \ If ZZ >= 144, increment A
 ADC #0

                        \ So by this point A is 210 for the closest stardust,
                        \ then 211, 212, 213 or 214 for smaller and smaller
                        \ particles as they move further away

                        \ The C flag is clear at this point, which affects the
                        \ SBC #3 below

 STA pattSprite37,Y     \ By this point A is the correct pattern number for the
                        \ distance of the stardust particle, so set the tile
                        \ pattern number for sprite 37 + Y to this pattern

ENDIF

 LDA X1                 \ Fetch the x-coordinate offset into A

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELECTRON_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 BPL PX1                \ If the x-coordinate offset is positive, jump to PX1
                        \ to skip the following negation

 EOR #%01111111         \ The x-coordinate offset is negative, so flip all the
 CLC                    \ bits apart from the sign bit and add 1, to convert it
 ADC #1                 \ from a sign-magnitude number to a signed number

.PX1

ELIF _MASTER_VERSION OR _NES_VERSION

 BPL PX21               \ If the x-coordinate offset is positive, jump to PX21
                        \ to skip the following negation

 EOR #%01111111         \ The x-coordinate offset is negative, so flip all the
 CLC                    \ bits apart from the sign bit and add 1, to convert it
 ADC #1                 \ from a sign-magnitude number to a signed number

.PX21

ENDIF

IF NOT(_NES_VERSION)

 EOR #%10000000         \ Set X = X1 + 128
 TAX                    \
                        \ So X is now the offset converted to an x-coordinate,
                        \ centred on x-coordinate 128

 LDA Y1                 \ Fetch the y-coordinate offset into A and clear the
 AND #%01111111         \ sign bit, so A = |Y1|

ELIF _NES_VERSION

 EOR #%10000000         \ Set A = X1 + 128 - 4
 SBC #3                 \
                        \ So X is now the offset converted to an x-coordinate,
                        \ centred on x-coordinate 128, less a margin of 4
                        \
                        \ We know that the C flag is clear at this point, so the
                        \ SBC #3 actually subtracts 4

 CMP #244               \ If A >= 244 then the stardust particle is off-screen,
 BCS stpx1              \ so jump to stpx1 to hide the particle's sprite and
                        \ return from the subroutine

 STA xSprite37,Y        \ Set the stardust particle's sprite x-coordinate to A

 LDA Y1                 \ Fetch the y-coordinate offset into A and clear the
 AND #%01111111         \ sign bit, so A = |Y1|

 CMP halfScreenHeight   \ If A >= halfScreenHeight then the stardust particle
 BCS stpx1              \ is off the screen, so jump to stpx1 to hide the
                        \ particle's sprite and return from the subroutine

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELECTRON_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 CMP #96                \ If |Y1| >= 96 then it's off the screen (as 96 is half
 BCS PX4                \ the screen height), so return from the subroutine (as
                        \ PX4 contains an RTS)

ELIF _MASTER_VERSION

 CMP #96                \ If |Y1| >= 96 then it's off the screen (as 96 is half
 BCS PXR1               \ the screen height), so return from the subroutine (as
                        \ PXR1 contains an RTS)

ENDIF

 LDA Y1                 \ Fetch the y-coordinate offset into A

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELECTRON_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 BPL PX2                \ If the y-coordinate offset is positive, jump to PX2
                        \ to skip the following negation

 EOR #%01111111         \ The y-coordinate offset is negative, so flip all the
 ADC #1                 \ bits apart from the sign bit and subtract 1, to negate
                        \ it to a positive number, i.e. A is now |Y1|

.PX2

ELIF _MASTER_VERSION OR _NES_VERSION

 BPL PX22               \ If the y-coordinate offset is positive, jump to PX22
                        \ to skip the following negation

 EOR #%01111111         \ The y-coordinate offset is negative, so flip all the
 ADC #1                 \ bits apart from the sign bit and add 1, to convert it
                        \ from a sign-magnitude number to a signed number

.PX22

ENDIF

IF NOT(_NES_VERSION)

 STA T                  \ Set A = 97 - Y1
 LDA #97                \
 SBC T                  \ So if Y is positive we display the point up from the
                        \ centre at y-coordinate 97, while a negative Y means
                        \ down from the centre

ELIF _NES_VERSION

 STA T                  \ Set A = halfScreenHeight - Y1 + 10
 LDA halfScreenHeight   \
 SBC T                  \ So if Y is positive we display the point up from the
 ADC #10+YPAL           \ centre at y-coordinate halfScreenHeight, while a
                        \ negative Y means down from the centre

 STA ySprite37,Y        \ Set the stardust particle's sprite y-coordinate to A

 LDY T1                 \ Restore the value of Y from T1 so it is preserved

 RTS                    \ Return from the subroutine

.stpx1

                        \ If we get here then we do not want to show the
                        \ stardust particle on-screen

 LDA #240               \ Hide the stardust particle's sprite by setting its
 STA ySprite37,Y        \ y-coordinate to 240, which is off the bottom of the
                        \ screen

 LDY T1                 \ Restore the value of Y from T1 so it is preserved

 RTS                    \ Return from the subroutine

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _NES_VERSION)

                        \ Fall through into PIXEL to draw the stardust at the
                        \ screen coordinates in (X, A)

ELIF _ELITE_A_6502SP_PARA

 JMP PIXEL              \ Jump to PIXEL to draw the stardust at the screen
                        \ coordinates in (X, A), returning from the subroutine
                        \ using a tail call

.PX4

 RTS                    \ Return from the subroutine

ENDIF

