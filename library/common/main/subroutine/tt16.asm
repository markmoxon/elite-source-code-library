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

 JMP subm_9D09          \ ???

ENDIF

.TT16

IF _NES_VERSION

 LDA controller1B       \ ???
 BMI TT16-3

 LDA controller1Leftx8
 ORA controller1Rightx8
 ORA controller1Up
 ORA controller1Down
 AND #&F0
 BEQ TT16-3

ENDIF

 TXA                    \ Push the change in X onto the stack (let's call this
 PHA                    \ the x-delta)

IF _NES_VERSION

 BNE C9B03              \ ???
 TYA
 BEQ C9B15

.C9B03

 LDX #0
 LDA L0395
 STX L0395
 ASL A
 BPL C9B15
 TYA
 PHA
 JSR subm_AC5C_b3
 PLA
 TAY

.C9B15

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

 LDA QQ11               \ ???
 CMP #&9C
 BEQ C9B28

 PLA
 TAX
 PLA
 ASL A
 PHA
 TXA
 ASL A
 PHA

.C9B28

 JSR WaitForNMI

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

