\ ******************************************************************************
\
\       Name: ResetSaveSlots
\       Type: Subroutine
\   Category: Save and load
\    Summary: Reset the save slots for all eight save slots, so they will fail
\             their checksums and get reset when they are next checked
\
\ ******************************************************************************

.ResetSaveSlots

 LDX #7                 \ There are eight save slots, so set a slot counter in X
                        \ to loop through them all

.rsav1

 TXA                    \ Store the slot counter on the stack, copying the slot
 PHA                    \ number into A in the process

 JSR GetSaveAddresses   \ Set the following for save slot A:
                        \
                        \   SC(1 0) = address of the first saved part
                        \
                        \   Q(1 0) = address of the second saved part
                        \
                        \   S(1 0) = address of the third saved part

                        \ We reset the save slot by writing to byte #10 in each
                        \ of the three saved parts, so that this byte fails its
                        \ checksum, meaning the save slot will be reset the next
                        \ time it is checked in the CheckSaveSlots routine

 LDY #10                \ Set Y to use as an index to byte #10

 LDA #1                 \ Set byte #10 of the first saved part to 1
 STA (SC),Y

 LDA #3                 \ Set byte #10 of the second saved part to 3
 STA (Q),Y

 LDA #7                 \ Set byte #10 of the third saved part to 7
 STA (S),Y

 PLA                    \ Retrieve the slot counter from the stack into X
 TAX

 DEX                    \ Decrement the slot counter

 BPL rsav1              \ Loop back until we have reset the three parts for all
                        \ eight save slots

 RTS                    \ Return from the subroutine

