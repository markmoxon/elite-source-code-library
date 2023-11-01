\ ******************************************************************************
\
\       Name: SendBitplaneToPPU_b3
\       Type: Subroutine
\   Category: PPU
\    Summary: Call the SendBitplaneToPPU routine in ROM bank 3
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.SendBitplaneToPPU_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank19
 BEQ bank19

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR SendBitplaneToPPU  \ Call SendBitplaneToPPU, now that it is paged into
                        \ memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank19

 JMP SendBitplaneToPPU  \ Call SendBitplaneToPPU, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

