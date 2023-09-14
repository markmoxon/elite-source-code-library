\ ******************************************************************************
\
\       Name: TT16
\       Type: Subroutine
\   Category: Charts
\    Summary: Move the crosshairs on a chart
\
\ ------------------------------------------------------------------------------
\
\ Move the chart crosshairs by the amount in X and Y.
\
\ Arguments:
\
\   X                   The amount to move the crosshairs in the x-axis
\
\   Y                   The amount to move the crosshairs in the y-axis
\
\ ******************************************************************************

IF _NES_VERSION

 JMP SetSelectedSystem  \ This doesn't appear to be used

ENDIF

.TT16

IF _NES_VERSION

 LDA controller1B       \ ???
 BMI TT16-3

 LDA controller1Left03
 ORA controller1Right03
 ORA controller1Up
 ORA controller1Down
 AND #&F0
 BEQ TT16-3

ENDIF

 TXA                    \ Push the change in X onto the stack (let's call this
 PHA                    \ the x-delta)

IF _NES_VERSION

 BNE mvcr1              \ If the x-delta is non-zero, jump to mvcr1 to update
                        \ the icon bar if required

 TYA                    \ If the y-delta is zero, then the crosshairs are not
 BEQ mvcr2              \ moving, so jump to mvcr2 to skip the following,
                        \ otherwise keep going to update the icon bar if
                        \ required

.mvcr1

                        \ If we get here then the crosshairs are on the move

 LDX #%00000000         \ Set X to use as the new value of selectedSystemFlag
                        \ below

 LDA selectedSystemFlag \ Set A to the value of selectedSystemFlag

 STX selectedSystemFlag \ Clear bits 6 and 7 of selectedSystemFlag to indicate
                        \ that there is no currently selected system

 ASL A                  \ If bit 6 of selectedSystemFlag was previously clear,
 BPL mvcr2              \ then before the crosshairs moved we weren't locked
                        \ onto a system that we could hyperspace to, so the
                        \ hyperspace button wouldn't have been showing on the
                        \ icon bar, so jump to mvcr2 to skip the following as
                        \ we don't need to update the icon bar

 TYA                    \ Update the icon bar to remove the hyperspace button
 PHA                    \ now that the crosshairs are no longer pointing to
 JSR UpdateIconBar_b3   \ that system, preserving Y across the subroutine call
 PLA
 TAY

.mvcr2

ENDIF

 DEY                    \ Negate the change in Y and push it onto the stack
 TYA                    \ (let's call this the y-delta)
 EOR #&FF
 PHA

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: The Electron has its own unique video system that is controlled by the custom ULA, so unlike the other versions, we don't wait for the vertical sync to prevent flicker

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn and we can move the crosshairs with
                        \ no screen flicker

ENDIF

IF NOT(_NES_VERSION)

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there


ELIF _NES_VERSION

 LDA QQ11               \ If the view type in QQ11 is &9C (Short-range Chart),
 CMP #&9C               \ jump up to C9B28 to ???
 BEQ C9B28

 PLA                    \ ???
 TAX
 PLA
 ASL A
 PHA
 TXA
 ASL A
 PHA

.C9B28

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

ENDIF

 PLA                    \ Store the y-delta in QQ19+3 and fetch the current
 STA QQ19+3             \ y-coordinate of the crosshairs from QQ10 into A, ready
 LDA QQ10               \ for the call to TT123

 JSR TT123              \ Call TT123 to move the selected system's galactic
                        \ y-coordinate by the y-delta, putting the new value in
                        \ QQ19+4

 LDA QQ19+4             \ Store the updated y-coordinate in QQ10 (the current
 STA QQ10               \ y-coordinate of the crosshairs)

 STA QQ19+1             \ This instruction has no effect, as QQ19+1 is
                        \ overwritten below, both in TT103 and TT105

 PLA                    \ Store the x-delta in QQ19+3 and fetch the current
 STA QQ19+3             \ x-coordinate of the crosshairs from QQ10 into A, ready
 LDA QQ9                \ for the call to TT123

 JSR TT123              \ Call TT123 to move the selected system's galactic
                        \ x-coordinate by the x-delta, putting the new value in
                        \ QQ19+4

 LDA QQ19+4             \ Store the updated x-coordinate in QQ9 (the current
 STA QQ9                \ x-coordinate of the crosshairs)

 STA QQ19               \ This instruction has no effect, as QQ19 is overwritten
                        \ below, both in TT103 and TT105

                        \ Now we've updated the coordinates of the crosshairs,
                        \ fall through into TT103 to redraw them at their new
                        \ location

