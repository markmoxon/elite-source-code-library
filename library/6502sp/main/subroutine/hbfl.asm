\ ******************************************************************************
\
\       Name: HBFL
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the sun lines in the horizontal line buffer in orange by
\             sending an OSWORD 247 command to the I/O processor
\
\ ******************************************************************************

.HBFL

 LDA HBUP               \ Set the first byte in HBUF (the number of bytes to
 STA HBUF               \ transmit with the OSWORD 247 command) to HBUP, the
                        \ size of the horizontal line buffer

 CMP #2                 \ If HBUP = 2 then jump to HBZE2 as there is no line
 BEQ HBZE2              \ data to transmit to the I/O processor

 LDA #2                 \ Set HBUP = 2 to reset the line buffer (as the size in
 STA HBUP               \ HBUP includes the two OSWORD size bytes)

 LDA #247               \ Set A in preparation for sending an OSWORD 247 command

 LDX #LO(HBUF)          \ Set (Y X) to point to the HBUF parameter block
 LDY #HI(HBUF)

 JSR OSWORD             \ Send an OSWORD 247 command to the I/O processor to
                        \ draw the horizontal lines described in the HBUF block,
                        \ in orange

.HBZE2

 LDY T1                 \ Restore Y to the value in T1, so if we jump here from
                        \ the HLOIN routine, Y will be preserved from the
                        \ original call to that routine

 RTS                    \ Return from the subroutine

