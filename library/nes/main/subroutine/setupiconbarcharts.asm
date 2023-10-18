\ ******************************************************************************
\
\       Name: SetupIconBarCharts
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set up the Charts icon bar
\
\ ******************************************************************************

.SetupIconBarCharts

                        \ By default the icon bar shows all possible icons, so
                        \ now we work our way through the buttons, hiding any
                        \ icons that do not apply

 LDX #4                 \ Set X = 4 (though this appears to be unused)

 LDA QQ12               \ If we are in space (QQ12 = 0) then jump to char1 to
 BEQ char1              \ leave the fifth button showing the laser view icon
                        \ and process the rest of the icon bar

                        \ If we get here then we setting up the Charts icon bar
                        \ when are docked

 LDY #12                \ Blank the fifth button on the icon bar to hide the
 JSR DrawBlankButton2x2 \ laser view button, as this doesn't apply when we are
                        \ docked

 JSR BlankButtons8To11  \ Blank from the eighth to the eleventh button on the
                        \ icon bar as none of these icons apply when we are
                        \ docked

 JMP fbar11             \ Jump to fbar11 in SetupIconBarFlight to process the
                        \ fast-forward and Market Price buttons, returning from
                        \ the subroutine using a tail call

.char1

                        \ If we get here then we setting up the Charts icon bar
                        \ when we are in space

 LDY #2                 \ Blank the first button on the icon bar to hide the
 JSR DrawBlankButton2x2 \ docking computer icon so we can't activate it while
                        \ looking at the charts while in space

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

 BEQ char2              \ If the counter is zero then there is no countdown in
                        \ progress, so jump to char2 to leave the "Return
                        \ pointer to current system" and "Search for system"
                        \ icons visible

 LDY #14                \ Blank the sixth button on the icon bar to hide the
 JSR DrawBlankButton3x2 \ "Return pointer to current system" icon, as this
                        \ can't be done during a hyperspace countdown

 LDY #17                \ Blank the seventh button on the icon bar to hide the
 JSR DrawBlankButton2x2 \ "Search for system" icon, as this can't be done during
                        \ a hyperspace countdown

 JMP char3              \ Jump to char3 to move on to the eighth button on the
                        \ icon bar

.char2

                        \ If we get here then there is no hyperspace countdown

 LDA selectedSystemFlag \ If bit 6 of selectedSystemFlag is set, then we can
 ASL A                  \ hyperspace to the currently selected system, so jump
 BMI char4              \ to char4 to leave the eighth button showing the
                        \ hyperspace icon

.char3

 LDY #19                \ Blank the eighth button on the icon bar to hide the
 JSR DrawBlankButton3x2 \ hyperspace icon, as we can't hyperspace to the
                        \ currently selected system

.char4

 LDA GHYP               \ If we have a galactic hyperdrive fitted, jump to char5
 BNE char5              \ to leave the ninth button showing the galactic
                        \ hyperspace icon

 LDY #22                \ Blank the ninth button on the icon bar to hide the
 JSR DrawBlankButton2x2 \ galactic hyperspace icon, as we don't have a galactic
                        \ hyperdrive fitted

.char5

 LDA ECM                \ If we have an E.C.M. fitted, jump to char6 to leave
 BNE char6              \ the seventh tenth showing the E.C.M. icon

 LDY #24                \ Otherwise blank the tenth button on the icon bar to
 JSR DrawBlankButton3x2 \ hide the E.C.M. icon we don't have an E.C.M. fitted

.char6

 JMP fbar8              \ Jump to fbar8 in SetupIconBarFlight to process the
                        \ escape pod, fast-forward and Market Price buttons,
                        \ returning from the subroutine using a tail call

