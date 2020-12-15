\ ******************************************************************************
\
\       Name: ADPARAMS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the OSWRCH 137 command (add a dashboard parameter and
\             update the dashboard when all parameters are received)
\
\ ******************************************************************************

.ADPARAMS

 INC PARANO             \ PARANO points to the last free byte in PARAMS, which
                        \ is where we're about to store the new byte in A, so
                        \ increment PARANO to point to the byte after this one

 LDX PARANO             \ Store the new byte in A at position PARANO-1 in TABLE
 STA PARAMS-1,X         \ (which was the last free byte before we incremented
                        \ PARANO above)

 CPX #PARMAX            \ If X >= #PARMAX, skip the following instruction, as we
 BCS P%+3               \ have now received all the parameters we need to update
                        \ the dashboard

 RTS                    \ Otherwise we still have more parameters to receive, so
                        \ return from the subroutine

 JSR DIALS              \ Call DIALS to update the dashboard with the parameters
                        \ in PARAMS

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

