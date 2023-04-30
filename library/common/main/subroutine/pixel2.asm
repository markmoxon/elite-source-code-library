\ ******************************************************************************
\
\       Name: PIXEL2
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a stardust particle relative to the screen centre
\
\ ------------------------------------------------------------------------------
\
\ Draw a point (X1, Y1) from the middle of the screen with a size determined by
\ a distance value. Used to draw stardust particles.
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
\ ******************************************************************************

.PIXEL2

IF _NES_VERSION

 STY T1                 \ ???
 TYA
 ASL A
 ASL A
 TAY
 LDA #&D2
 LDX ZZ
 CPX #&18
 ADC #0
 CPX #&30
 ADC #0
 CPX #&70
 ADC #0
 CPX #&90
 ADC #0
 STA SPR_37_TILE,Y

ENDIF

 LDA X1                 \ Fetch the x-coordinate offset into A

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELECTRON_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 BPL PX1                \ If the x-coordinate offset is positive, jump to PX1
                        \ to skip the following negation

 EOR #%01111111         \ The x-coordinate offset is negative, so flip all the
 CLC                    \ bits apart from the sign bit and add 1, to negate
 ADC #1                 \ it to a positive number, i.e. A is now |X1|

.PX1

ELIF _MASTER_VERSION OR _NES_VERSION

 BPL PX21               \ If the x-coordinate offset is positive, jump to PX21
                        \ to skip the following negation

 EOR #%01111111         \ The x-coordinate offset is negative, so flip all the
 CLC                    \ bits apart from the sign bit and add 1, to negate
 ADC #1                 \ it to a positive number, i.e. A is now |X1|

.PX21

ENDIF

IF NOT(_NES_VERSION)

 EOR #%10000000         \ Set X = -|A|
 TAX                    \       = -|X1|

 LDA Y1                 \ Fetch the y-coordinate offset into A and clear the
 AND #%01111111         \ sign bit, so A = |Y1|

ELIF _NES_VERSION

 EOR #&80               \ ???
 SBC #3
 CMP #&F4
 BCS CBC49
 STA SPR_37_X,Y
 LDA Y1
 AND #&7F
 CMP Yx1M2
 BCS CBC49

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
 ADC #1                 \ bits apart from the sign bit and subtract 1, to negate
                        \ it to a positive number, i.e. A is now |Y1|

.PX22

ENDIF

IF NOT(_NES_VERSION)

 STA T                  \ Set A = 97 - A
 LDA #97                \       = 97 - |Y1|
 SBC T                  \
                        \ so if Y is positive we display the point up from the
                        \ centre, while a negative Y means down from the centre

ELIF _NES_VERSION

 STA T                  \ ???
 LDA Yx1M2
 SBC T
 ADC #&0A
 STA SPR_37_Y,Y
 LDY T1
 RTS

.CBC49
 LDA #&F0
 STA SPR_37_Y,Y
 LDY T1
 RTS

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

