\ ******************************************************************************
\
\       Name: PBFL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw the pixel in the pixel buffer by sending an OSWORD 241
\             command to the I/O processor
\
\ ******************************************************************************

.PBFL

 LDA PBUP               \ Set the first byte in pixbl (the number of bytes to
 STA pixbl              \ transmit with the OSWORD 241 command) to PBUP, the
                        \ size of the pixel buffer

 CMP #2                 \ If PBUP = 2 then jump to PBZE2 as there is no pixel
 BEQ PBZE2              \ data to transmit to the I/O processor

 LDA #2                 \ Set PBUP = 2 to reset the pixel buffer (as the size in
 STA PBUP               \ PBUP includes the two OSWORD size bytes)

 LDA #DUST              \ Send a #SETCOL DUST command to the I/O processor to
 JSR DOCOL              \ switch to stripe 3-2-3-2, which is cyan/red in the
                        \ space view

 LDA #241               \ Set A in preparation for sending an OSWORD 241 command

 LDX #LO(pixbl)         \ Set (Y X) to point to the pixbl parameter block
 LDY #HI(pixbl)

 JSR OSWORD             \ Send an OSWORD 241 command to the I/O processor to
                        \ draw the pixel described in the pixbl block

.PBZE2

 LDY T1                 \ Restore Y to the value in T1, so if we jump here from
                        \ the PIXEL or PIXEL3 routines, Y will be preserved from
                        \ the original call to that routine

 RTS                    \ Return from the subroutine

