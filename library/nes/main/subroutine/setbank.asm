\ ******************************************************************************
\
\       Name: SetBank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page a specified ROM bank into memory at &8000
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the ROM bank to page into memory at &8000
\
\ ******************************************************************************

.SetBank

 DEC runningSetBank     \ Decrement runningSetBank from 0 to &FF to denote that
                        \ we are in the process of switching ROM banks
                        \
                        \ This will disable the call to MakeSounds in the NMI
                        \ handler, which instead will increment runningSetBank
                        \ each time it is called

 STA currentBank        \ Store the number of the new ROM bank in currentBank

 STA &FFFF              \ Set the MMC1 PRG bank register (which is mapped to
 LSR A                  \ &C000-&DFFF) to the ROM bank number in A, to map the
 STA &FFFF              \ specified ROM bank into memory at &8000
 LSR A                  \
 STA &FFFF              \ Bit 4 of the ROM bank number will be zero, as A is in
 LSR A                  \ the range 0 to 7, which also ensures that PRG-RAM is
 STA &FFFF              \ enabled and mapped to $6000-$7FFF
 LSR A
 STA &FFFF

 INC runningSetBank     \ Increment runningSetBank again

 BNE sban1              \ If runningSetBank is non-zero, then this means the NMI
                        \ handler was called while we were switching the ROM
                        \ bank, in which case MakeSounds won't have been called
                        \ in the NMI handler, so jump to sban1 to call the
                        \ MakeSounds routine now instead

 RTS                    \ Return from the subroutine

.sban1

 LDA #0                 \ Set runningSetBank = 0 so the NMI handler knows we are
 STA runningSetBank     \ no longer switching ROM banks

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 TXA                    \ Store X and Y on the stack
 PHA
 TYA
 PHA

 JSR MakeSounds_b6      \ Call the MakeSounds routine to make the current sounds
                        \ (music and sound effects)

 PLA                    \ Retrieve X and Y from the stack
 TAY
 PLA
 TAX

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

