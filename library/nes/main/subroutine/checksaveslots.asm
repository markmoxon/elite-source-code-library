\ ******************************************************************************
\
\       Name: CheckSaveSlots
\       Type: Subroutine
\   Category: Save and load
\    Summary: Load the commanders for all eight save slots, one after the other,
\             to check their integrity and reset any that fail their checksums
\
\ ******************************************************************************

.CheckSaveSlots

 LDA #7                 \ There are eight save slots, so set a slot counter in
                        \ A to loop through them all

.sabf1

 PHA                    \ Wait until the next NMI interrupt has passed (i.e. the
 JSR WaitForNMI         \ next VBlank), preserving the value in A via the stack
 PLA

 JSR CopyCommanderToBuf \ Copy the commander file from save slot A into the
                        \ buffer at BUF, resetting the save slot if the file
                        \ fails its checksums

 SEC                    \ Decrement A to move on to the next save slot
 SBC #1

 BPL sabf1              \ Loop back until we have loaded all eight save slots

 RTS                    \ Return from the subroutine

