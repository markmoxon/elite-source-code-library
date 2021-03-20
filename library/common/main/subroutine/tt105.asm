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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 CMP #38                \ If the horizontal distance in A is < 38, then the
 BCC TT179              \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so jump to TT179 to
                        \ check the vertical distance

 CMP #230               \ If the horizontal distance in A is < -26, then the
 BCC TT180              \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

ELIF _MASTER_VERSION

 BCS L5017              \ ???

 EOR #&FF
 ADC #&01

.L5017

 CMP #&1D
 BCS TT180

 LDA QQ9
 SEC
 SBC QQ0
 BPL TT179

 CMP #&E9
 BCC TT180

ENDIF

.TT179

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 ASL A                  \ Set QQ19 = 104 + A * 4
 ASL A                  \
 CLC                    \ 104 is the x-coordinate of the centre of the chart,
 ADC #104               \ so this sets QQ19 to the screen pixel x-coordinate
 STA QQ19               \ of the crosshairs

ELIF _MASTER_VERSION

 ASL A                  \ ???
 ASL A
 CLC
 ADC #&68
 JSR L4A43
 STA QQ19

ENDIF

 LDA QQ10               \ Set A = QQ10 - QQ1, the vertical distance between the
 SEC                    \ crosshairs (QQ10) and the current system (QQ1)
 SBC QQ1

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 CMP #38                \ If the vertical distance in A is < 38, then the
 BCC P%+6               \ crosshairs are close enough to the current system to
                        \ appear in the Short-range Chart, so skip the next two
                        \ instructions

 CMP #220               \ If the horizontal distance in A is < -36, then the
 BCC TT180              \ crosshairs are too far from the current system to
                        \ appear in the Short-range Chart, so jump to TT180 to
                        \ return from the subroutine (as TT180 contains an RTS)

ELIF _MASTER_VERSION

 BCS L503D              \ ???

 EOR #&FF
 ADC #&01

.L503D

 CMP #&23
 BCS TT180

 LDA QQ10
 SEC
 SBC QQ1

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 ASL A                  \ Set QQ19+1 = 90 + A * 2
 CLC                    \
 ADC #90                \ 90 is the y-coordinate of the centre of the chart,
 STA QQ19+1             \ so this sets QQ19+1 to the screen pixel x-coordinate
                        \ of the crosshairs

ELIF _MASTER_VERSION

 ASL A                  \ ???
 CLC
 ADC #&5A
 JSR L4A43
 STA QQ19+1

ENDIF

 LDA #8                 \ Set QQ19+2 to 8 denote crosshairs of size 8
 STA QQ19+2

IF _MASTER_VERSION

 LDA #&AF               \ ???
 STA COL

ENDIF

 JMP TT15               \ Jump to TT15 to draw crosshairs of size 8 at the
                        \ crosshairs coordinates, returning from the subroutine
                        \ using a tail call

