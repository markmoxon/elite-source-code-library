\ ******************************************************************************
\
\       Name: SetupIconBarDocked
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set up the Docked icon bar
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   dock2                Process the second button on the Docked or Flight icon
\                        bars
\
\ ******************************************************************************

.SetupIconBarDocked

                        \ By default the icon bar shows all possible icons, so
                        \ now we work our way through the buttons, hiding any
                        \ icons that do not apply

 LDA COK                \ If COK is non-zero then cheat mode has been applied,
 BNE dock1              \ so jump to dock1 to hide the button to change the
                        \ commander name (as cheats can't change their commander
                        \ name away from "CHEATER")

 LDA QQ11               \ If the view type in QQ11 is &BB (Save and load with
 CMP #&BB               \ the normal and highlight fonts loaded), jump to ifon1
 BEQ dock2              \ to leave the seventh button showing the icon to change
                        \ the commander name

.dock1

 LDY #17                \ If we get here then either cheat mode has been applied
 JSR DrawBlankButton2x2 \ or this is not the save screen, so blank the seventh
                        \ button on the icon bar to hide the change commander
                        \ name icon

.dock2

 LDA QQ11               \ If the view type in QQ11 is not &BA (Market Price),
 CMP #&BA               \ then jump to SetIconBarButtons to skip the following
 BNE SetIconBarButtons  \ two instructions

 LDY #4                 \ This is the Market Price screen, so blank the second
 JSR DrawBlankButton3x2 \ button on the icon bar (though as we are going to draw
                        \ the Inventory button over the top, this isn't strictly
                        \ necessary)

                        \ Fall through into SetIconBarButtons to set the correct
                        \ list of button numbers for the icon bar

