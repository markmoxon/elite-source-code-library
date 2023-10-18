\ ******************************************************************************
\
\       Name: JAMESON
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the default "JAMESON" commander to the buffer at currentSlot
\
\ ******************************************************************************

.JAMESON

 LDY #94                \ We want to copy 94 bytes from the default commander
                        \ at NA2% to the buffer at currentSlot, so set a byte
                        \ counter in Y

.jame1

 LDA NA2%,Y             \ Copy the Y-th byte of NA2% to the Y-th byte of
 STA currentSlot,Y      \ currentSlot

 DEY                    \ Decrement the byte counter

 BPL jame1              \ Loop back until we have copied all 94 bytes

 RTS                    \ Return from the subroutine

