\ ******************************************************************************
\
\       Name: JAMESON
\       Type: Subroutine
\   Category: Save and load
\    Summary: Restore the default JAMESON commander
\
\ ******************************************************************************

.JAMESON

 LDY #(NAEND%-NA2%)     \ We are going to copy the default commander at NA2%
                        \ over the top of the last saved commander at NA%, so
                        \ set a counter to copy all the bytes between NA2% and
                        \ NAEND%

.JAMEL1

 LDA NA2%,Y             \ Copy the Y-th byte of NA2% to the Y-th byte of NA%
 STA NA%,Y

 DEY                    \ Decrement the loop counter

 BPL JAMEL1             \ Loop back until we have copied the whole commander

 LDY #7                 \ Set oldlong to 7, the length of the commander name
 STY oldlong            \ "JAMESON"

 RTS                    \ Return from the subroutine

