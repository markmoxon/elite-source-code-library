\ ******************************************************************************
\
\       Name: TT105
\       Type: Subroutine
\   Category: Charts
\    Summary: Draw crosshairs on the Short-range Chart, with clipping
\
\ ------------------------------------------------------------------------------
\
\ Check whether the crosshairs are close enough to the current system to appear
\ on the Short-range Chart, and if so, draw them.
\
\ ******************************************************************************

.TT105

 LDA QQ9                \ Set A = QQ9 - QQ0, the horizontal distance between the
 SEC                    \ crosshairs (QQ9) and the current system (QQ0)
 SBC QQ0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: In most versions the Short-range Chart crosshairs can be moved to the right edge of the screen, but in the Master version they disappear before they get to the edge

 CMP #38                \ If the horizontal distance in A < 38, then the
 BCC TT179              \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so jump to TT179 to
                        \ check the vertical distance

 CMP #230               \ If the horizontal distance in A < -26, then the
 BCC TT180              \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

ELIF _MASTER_VERSION

 BCS P%+6               \ If the subtraction didn't underflow, skip the next two
                        \ instructions

 EOR #&FF               \ The subtraction underflowed, so negate the result
 ADC #1                 \ using two's complement so that it is positive, i.e.
                        \ A = |QQ9 - QQ0|, the absolute horizontal distance

 CMP #29                \ If the absolute horizontal distance in A >= 29, then
 BCS TT180              \ the crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

 LDA QQ9                \ Set A = QQ9 - QQ0, the horizontal distance between the
 SEC                    \ crosshairs (QQ9) and the current system (QQ0)
 SBC QQ0

 BPL TT179              \ If the horizontal distance in A is positive, then skip
                        \ the next two instructions

 CMP #233               \ If the horizontal distance in A < -23, then the
 BCC TT180              \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

ELIF _APPLE_VERSION

 CMP #29                \ If the horizontal distance in A < 29, then the
 BCC TT179              \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so jump to TT179 to
                        \ check the vertical distance

 CMP #227               \ If the horizontal distance in A < -29, then the
 BCC TT180              \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

ELIF _NES_VERSION

 CMP #36                \ If the horizontal distance in A < 36, then the
 BCC TT179              \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so jump to TT179 to
                        \ check the vertical distance

 CMP #233               \ If the horizontal distance in A < -23, then the
 BCC HideCrosshairs     \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to
                        \ HideCrosshairs to hide the crosshairs and return from
                        \ the subroutine using a tail call

ENDIF

.TT179

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: Group A: The Master version contains code to scale the chart views, though it has no effect in this version. The code is left over from the Apple II version, which uses a different scale

 ASL A                  \ Set QQ19 = 104 + A * 4
 ASL A                  \
 CLC                    \ 104 is the x-coordinate of the centre of the chart,
 ADC #104               \ so this sets QQ19 to the screen pixel x-coordinate
 STA QQ19               \ of the crosshairs

ELIF _MASTER_VERSION

 ASL A                  \ Set QQ19 = 104 + A * 4
 ASL A                  \
 CLC                    \ 104 is the x-coordinate of the centre of the chart,
 ADC #104               \ so this sets QQ19 to the screen pixel x-coordinate
 JSR SCALEY2            \
 STA QQ19               \ The call to SCALEY2 has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

ELIF _APPLE_VERSION

 ASL A                  \ Set QQ19 = 105 + A * 4
 ASL A                  \
 CLC                    \ 105 is the x-coordinate of the centre of the chart,
 ADC #105*4/3           \ so this sets QQ19 to the scaled screen pixel
 JSR SCALEY2            \ x-coordinate ???
 STA QQ19

ENDIF

 LDA QQ10               \ Set A = QQ10 - QQ1, the vertical distance between the
 SEC                    \ crosshairs (QQ10) and the current system (QQ1)
 SBC QQ1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: In most versions the Short-range Chart crosshairs can be moved close to the bottom edge of the screen, but in the Master version they disappear before they get quite as far

 CMP #38                \ If the vertical distance in A is < 38, then the
 BCC P%+6               \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so skip the next two
                        \ instructions

 CMP #220               \ If the horizontal distance in A is < -36, then the
 BCC TT180              \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

ELIF _MASTER_VERSION

 BCS P%+6               \ If the subtraction didn't underflow, skip the next two
                        \ instructions

 EOR #&FF               \ The subtraction underflowed, so negate the result
 ADC #1                 \ using two's complement so that it is positive, i.e.
                        \ A = |QQ10 - QQ0|, the absolute vertical distance

 CMP #35                \ If the absolute vertical distance in A >= 35, then
 BCS TT180              \ the crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

 LDA QQ10               \ Set A = QQ10 - QQ1, the vertical distance between the
 SEC                    \ crosshairs (QQ10) and the current system (QQ1)
 SBC QQ1

ELIF _APPLE_VERSION

 CMP #35                \ If the vertical distance in A is < 35, then the
 BCC P%+6               \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so skip the next two
                        \ instructions

 CMP #230               \ If the horizontal distance in A is < -26, then the
 BCC TT180              \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

ELIF _NES_VERSION

 CMP #38                \ If the vertical distance in A is < 38, then the
 BCC P%+6               \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so skip the next two
                        \ instructions

 CMP #220               \ If the horizontal distance in A is < -36, then the
 BCC HideCrosshairs     \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to
                        \ HideCrosshairs to hide the crosshairs and return from
                        \ the subroutine using a tail call

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Master: See group A

 ASL A                  \ Set QQ19+1 = 90 + A * 2
 CLC                    \
 ADC #90                \ 90 is the y-coordinate of the centre of the chart,
 STA QQ19+1             \ so this sets QQ19+1 to the screen pixel x-coordinate
                        \ of the crosshairs

ELIF _MASTER_VERSION

 ASL A                  \ Set QQ19+1 = 90 + A * 2
 CLC                    \
 ADC #90                \ 90 is the y-coordinate of the centre of the chart,
 JSR SCALEY2            \ so this sets QQ19+1 to the screen pixel x-coordinate
 STA QQ19+1             \ of the crosshairs
                        \
                        \ The call to SCALEY2 has no effect as it only contains
                        \ an RTS, but having this call instruction here would
                        \ enable different scaling to be applied by altering
                        \ the SCALE routines
                        \
                        \ This code is left over from the Apple II version,
                        \ where the scale factor is different

ELIF _APPLE_VERSION

 ASL A                  \ Set QQ19+1 = 99 + A * 2
 CLC                    \
 ADC #99                \ 90 is the y-coordinate of the centre of the chart,
 JSR SCALEY2            \ so this sets QQ19+1 to the scaled screen pixel
 STA QQ19+1             \ x-coordinate of the crosshairs

ENDIF

 LDA #8                 \ Set QQ19+2 to 8 denote crosshairs of size 8
 STA QQ19+2

IF _MASTER_VERSION OR _APPLE_VERSION \ Master: The moveable chart crosshairs in the Master version are drawn with white/yellow vertical stripes (with the exception of the static crosshairs on the Long-range Chart, which are white). All crosshairs are white in the other versions

 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is white/yellow in the
 STA COL                \ chart view

ENDIF

IF NOT(_NES_VERSION)

 JMP TT15               \ Jump to TT15 to draw crosshairs of size 8 at the
                        \ crosshairs coordinates, returning from the subroutine
                        \ using a tail call

ELIF _NES_VERSION

                        \ Fall through into DrawCrosshairs to draw crosshairs of
                        \ size 8 at the crosshairs coordinates

ENDIF

