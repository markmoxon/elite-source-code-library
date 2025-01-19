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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The amount to move the crosshairs in the x-axis
\
\   Y                   The amount to move the crosshairs in the y-axis
\
\ ******************************************************************************

IF _NES_VERSION

.cros1

 JMP SetSelectedSystem  \ Jump to SetSelectedSystem to update the message on
                        \ the chart that shows the current system, returning
                        \ from the subroutine using a tail call

ENDIF

.TT16

IF _NES_VERSION

 LDA controller1B       \ If the B button is being pressed, jump to cros1 to
 BMI cros1              \ return from the subroutine, as the arrow buttons have
                        \ a different meaning when the B button is held down

 LDA controller1Left03  \ If none of the directional buttons have been held down
 ORA controller1Right03 \ in the last four VBlanks, jump to cros1 to return from
 ORA controller1Up      \ the subroutine, as we don't need to move the
 ORA controller1Down    \ crosshairs
 AND #%11110000
 BEQ cros1

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
                        \ Hyperspace button wouldn't have been showing on the
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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION \ Electron: The Electron has its own unique video system that is controlled by the custom ULA, so unlike the other versions, we don't wait for the vertical sync to prevent flicker

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn and we can move the crosshairs with
                        \ no screen flicker

ELIF _APPLE_VERSION

 JSR WSCAN              \ Call WSCAN to wait for 15 * 256 loop iterations

ENDIF

IF NOT(_NES_VERSION)

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

ELIF _NES_VERSION

 LDA QQ11               \ If the view type in QQ11 is &9C (Short-range Chart),
 CMP #&9C               \ jump to hair1 to skip the following
 BEQ hair1

                        \ This is not the Short-range Chart, so it must be the
                        \ Long-range Chart, so we double the x-delta and y-delta
                        \ so the crosshairs move twice as fast

 PLA                    \ Set X to the y-delta from the top of the stack
 TAX

 PLA                    \ Fetch the x-delta from the top of the stack, double it
 ASL A                  \ and put it back
 PHA

 TXA                    \ Double the y-delta value in X and put it back on the
 ASL A                  \ stack
 PHA

.hair1

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

