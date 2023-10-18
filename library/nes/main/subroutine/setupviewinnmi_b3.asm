\ ******************************************************************************
\
\       Name: SetupViewInNMI_b3
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Call the SetupViewInNMI routine in ROM bank 3
\
\ ******************************************************************************

.SetupViewInNMI_b3

 LDA #%11000000         \ Set A to the bitplane flags to set for the drawing
                        \ bitplane in the call to SetupViewInNMI below:
                        \
                        \   * Bit 2 clear = send tiles up to configured numbers
                        \   * Bit 3 clear = don't clear buffers after sending
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 set   = send both pattern and nametable data
                        \   * Bit 7 set   = send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank18
 BEQ bank18

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR SetupViewInNMI     \ Call SetupViewInNMI, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank18

 LDA ASAV               \ Restore the value of A that we stored above

 JMP SetupViewInNMI     \ Call SetupViewInNMI, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

