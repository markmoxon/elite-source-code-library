\ ******************************************************************************
\
\       Name: ReadControllers
\       Type: Subroutine
\   Category: Controllers
\    Summary: Read the buttons on the controllers and update the control
\             variables
\
\ ******************************************************************************

.ReadControllers

 LDA #1                 \ Write 1 then 0 to the controller port at JOY1 to tell
 STA JOY1               \ the controllers to latch the button positions, so we
 LSR A                  \ can then read them in the ScanButtons routine
 STA JOY1

 TAX                    \ Call ScanButtons with X = 0 to scan controller 1 and
 JSR ScanButtons        \ update the controller variables

 LDX numberOfPilots     \ Set X to numberOfPilots, which will be 0 if only one
                        \ pilot is configured in the pause options, or 1 if two
                        \ pilots are configured

 BEQ RTS3               \ If X = 0 then only one pilot is configured, so jump to
                        \ RTS3 to return from the subroutine, as we do not need
                        \ to scan controller 2

                        \ Otherwise X = 1 and two pilots are configured, so fall
                        \ through into ScanButtons with X = 1 to scan controller
                        \ 2 and update the control variables

