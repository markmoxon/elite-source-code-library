\ ******************************************************************************
\
\       Name: SetupIconBarFlight
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set up the Flight icon bar
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   fbar8                Process the escape pod, fast-forward and Market Price
\                        buttons
\
\   fbar11               Process the fast-forward and Market Price buttons
\
\ ******************************************************************************

.SetupIconBarFlight

                        \ By default the icon bar shows all possible icons, so
                        \ now we work our way through the buttons, hiding any
                        \ icons that do not apply

 LDA SSPR               \ If we are inside the space station safe zone then SSPR
 BNE fbar1              \ is non-zero, so jump to fbar1 to leave the first
                        \ button showing the docking computer icon

 LDY #2                 \ Otherwise blank the first button on the icon bar to
 JSR DrawBlankButton2x2 \ hide the docking computer icon as we can't activate
                        \ the docking computer outside of the safe zone

.fbar1

 LDA ECM                \ If we have an E.C.M. fitted, jump to fbar2 to leave
 BNE fbar2              \ the seventh button showing the E.C.M. icon

 LDY #17                \ Otherwise blank the seventh button on the icon bar to
 JSR DrawBlankButton2x2 \ hide the E.C.M. icon we don't have an E.C.M. fitted

.fbar2

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

 BNE fbar3              \ If it is non-zero then there is a hyperspace countdown
                        \ in progress, so jump to fbar3 to blank the sixth
                        \ button on the icon bar, as otherwise it would show the
                        \ hyperspace icon (which we can't choose as we are
                        \ already counting down)

 LDA selectedSystemFlag \ If bit 6 of selectedSystemFlag is set, then we can
 ASL A                  \ hyperspace to the currently selected system, so jump
 BMI fbar4              \ to fbar4 to leave the sixth button showing the
                        \ hyperspace icon

.fbar3

 LDY #14                \ If we get here then there is either a hyperspace
 JSR DrawBlankButton3x2 \ countdown already in progress, or we can't hyperspace
                        \ to the selected system, so blank the sixth button on
                        \ the icon bar to hide the hyperspace icon

.fbar4

 LDA QQ11               \ If this is the space view, jump to fbar5 to process
 BEQ fbar5              \ the weapon buttons

 JSR BlankButtons8To11  \ Otherwise this is not a space view and we don't want
                        \ to show the weapon buttons, so blank from the eighth
                        \ to the eleventh button on the icon bar

 JMP fbar10             \ Jump to fbar10 to process the eleventh button on the
                        \ icon bar

.fbar5

 LDA NOMSL              \ If we have at least one missile fitted then NOMSL will
 BNE fbar6              \ be non-zero, so jump to fbar6 to leave the eighth
                        \ button showing the target missile icon

 LDY #19                \ Otherwise we have no missiles fitted so blank the
 JSR DrawBlankButton3x2 \ eighth button on the icon bar to hide the target
                        \ missile icon

.fbar6

 LDA MSTG               \ If MSTG is positive (i.e. it does not have bit 7 set),
 BPL fbar7              \ then it indicates we already have a missile locked on
                        \ a target (in which case MSTG contains the ship number
                        \ of the target), so jump to fbar7 to leave the ninth
                        \ button showing the fire missile icon

 LDY #22                \ Otherwise the missile is not targeted, so blank the
 JSR DrawBlankButton2x2 \ ninth button on the icon bar to hide the fire missile
                        \ icon

.fbar7

 LDA BOMB               \ If we do have an energy bomb fitted, jump to fbar8 to
 BNE fbar8              \ leave the tenth button showing the energy bomb icon

 LDY #24                \ Otherwise we do not have an energy bomb fitted, so
 JSR DrawBlankButton3x2 \ blank the tenth button on the icon bar to hide the
                        \ energy bomb icon

.fbar8

 LDA MJ                 \ If we are in witchspace (i.e. MJ is non-zero), jump to
 BNE fbar9              \ fbar9 to hide the escape pod icon, as we can't use the
                        \ escape pod in witchspace

 LDA ESCP               \ If we have an escape pod fitted, jump to fbar10 to
 BNE fbar10             \ leave the eleventh button showing the escape pod icon

.fbar9

 LDY #27                \ If we get here then we are either in space or don't
 JSR DrawBlankButton2x2 \ have an escape pod fitted, so blank the eleventh
                        \ button on the icon bar to hide the escape pod icon

.fbar10

 LDA allowInSystemJump  \ If bits 6 and 7 of allowInSystemJump are clear then we
 AND #%11000000         \ are allowed to do an in-system jump, so jump to dock2
 BEQ dock2              \ in SetupIconBarDocked to leave the twelfth button
                        \ showing the fast-forward icon and move on to
                        \ processing the second button on the icon bar

.fbar11

 LDY #29                \ Otherwise we can't do an in-system jump, so blank the
 JSR DrawBlankButton3x2 \ twelfth button on the icon bar to hide the
                        \ fast-forward icon

 JMP dock2              \ Jump to dock2 in SetupIconBarDocked to move on to
                        \ processing the second button on the icon bar

