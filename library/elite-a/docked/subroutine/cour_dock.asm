\ ******************************************************************************
\
\       Name: cour_dock
\       Type: Subroutine
\   Category: Missions
\    Summary: Update the current special cargo delivery mission on docking
\  Deep dive: Special cargo missions
\
\ ******************************************************************************

.cour_dock

 LDA cmdr_cour          \ If there is no special cargo delivery mission in
 ORA cmdr_cour+1        \ progress, then the mission reward in cmdr_cour(1 0)
 BEQ cour_quit          \ will be zero, so jump to cour_quit to return from the
                        \ subroutine

 LDA QQ0                \ Set A = the current system's galactic x-coordinate

 CMP cmdr_courx         \ If A does not match the x-coordinate of the cargo
 BNE cour_half          \ mission's destination in cmdr_courx then we aren't at
                        \ the destination station, so jump to cour_half to
                        \ halve the mission reward

 LDA QQ1                \ Set A = the current system's galactic y-coordinate

 CMP cmdr_coury         \ If A does not match the y-coordinate of the cargo
 BNE cour_half          \ mission's destination in cmdr_coury then we aren't at
                        \ the destination station, so jump to cour_half to
                        \ halve the mission reward

 LDA #2                 \ We have arrived at the destination for the special
 JSR TT66               \ cargo mission, so clear the top part of the screen,
                        \ draw a white border, and set the current view type
                        \ in QQ11 to 2 (for the Buy Cargo screen)

 LDA #6                 \ Move the text cursor to column 6
 STA XC

 LDA #10                \ Move the text cursor to row 10
 STA YC

 LDA #113               \ Print extended token 113 ("CARGO VALUE:")
 JSR DETOK

 LDX cmdr_cour          \ Set (Y X) to the mission reward in cmdr_cour(1 0)
 LDY cmdr_cour+1

 SEC                    \ Set the C flag so the call to TT11 includes a decimal
                        \ point

 LDA #6                 \ Set A = 6, for the call to TT11 below, so we pad out
                        \ the number to 6 digits

 JSR TT11               \ Call TT11 to print the mission reward in (Y X), padded
                        \ to six digits and with a decimal point

 LDA #226               \ Print recursive text token 66 (" CR")
 JSR TT27

 LDX cmdr_cour          \ Set (Y X) to the mission reward in cmdr_cour(1 0)
 LDY cmdr_cour+1

 JSR MCASH              \ Call MCASH to add (Y X) to the cash pot

 LDA #0                 \ Reset the mission reward by doing cmdr_cour(1 0) = 0
 STA cmdr_cour
 STA cmdr_cour+1

 LDY #96                \ Wait for 96 vertical syncs (96/50 = 1.92 seconds)
 JSR DELAY

.cour_half

 LSR cmdr_cour+1        \ Halve the value of the mission reward in
 ROR cmdr_cour          \ cmdr_cour(1 0)

.cour_quit

 RTS                    \ Return from the subroutine

