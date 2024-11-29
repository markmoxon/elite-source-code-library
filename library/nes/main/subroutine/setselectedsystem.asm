\ ******************************************************************************
\
\       Name: SetSelectedSystem
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the selected system to the nearest system, if we don't already
\             have a selected system
\
\ ******************************************************************************

.SetSelectedSystem

 LDA selectedSystemFlag \ If bit 7 of selectedSystemFlag is set, then we already
 BMI SetCurrentSystem   \ have a selected system, so jump to SetCurrentSystem
                        \ to ensure we keep using this system as our selected
                        \ system, returning from the subroutine using a tail
                        \ call

                        \ If we get here then we do not already have a selected
                        \ system, so now we set it up

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 LDA QQ11               \ If the view in QQ11 is not %0000110x (i.e. 12 or 13,
 AND #%00001110         \ which are the Short-range Chart and Long-range Chart),
 CMP #%00001100         \ jump to pchm1 to skip the following as we don't need
 BNE pchm1              \ to update the message on the chart view

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 JSR cpl                \ Call cpl to print out the system name for the seeds
                        \ in QQ15

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

 LDA #12                \ Print a newline
 JSR DASC_b2

 JSR TT146              \ If the distance to this system is non-zero, print
                        \ "DISTANCE", then the distance, "LIGHT YEARS" and a
                        \ paragraph break, otherwise just move the cursor down
                        \ a line

 JSR DrawMessageInNMI   \ Configure the NMI to display the updated message that
                        \ we just printed, showing the current system name and
                        \ distance

.pchm1

                        \ Fall through into SetSelectionFlags to set the
                        \ selected system flags for the new system

