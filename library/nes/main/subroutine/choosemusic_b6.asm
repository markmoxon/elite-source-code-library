\ ******************************************************************************
\
\       Name: ChooseMusic_b6
\       Type: Subroutine
\   Category: Sound
\    Summary: Call the ChooseMusic routine in ROM bank 6
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the tune to choose
\
\ ******************************************************************************

.ChooseMusic_b6

 PHA                    \ Wait until the next NMI interrupt has passed (i.e. the
 JSR WaitForNMI         \ next VBlank), preserving the value in A via the stack
 PLA

 ORA #%10000000         \ Set bit 7 of the tune number and store in newTune to
 STA newTune            \ indicate that we are now in the process of changing to
                        \ this tune

 AND #%01111111         \ Clear bit 7 to set A to the tune number once again

 LDX disableMusic       \ If music is disabled then bit 7 of disableMusic will
 BMI RTS4               \ be set, so jump to RTS4 to return from the subroutine
                        \ as we can't choose a new tune if music is disabled

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 6 is already paged into memory, jump to
 CMP #6                 \ bank1
 BEQ bank1

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR ChooseMusic        \ Call ChooseMusic, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank1

 LDA ASAV               \ Restore the value of A that we stored above

 JMP ChooseMusic        \ Call ChooseMusic, which is already paged into memory,
                        \ and return from the subroutine using a tail call

