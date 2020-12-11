\ ******************************************************************************
\
\       Name: backtonormal
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Disable the keyboard, set the SVN flag to 0, and return with A = 0
\
\ ******************************************************************************

.backtonormal

 LDA #VIAE              \ Send a #VIAE %00000001 command to the I/O processor to
 JSR OSWRCH             \ set 6522 System VIA interrupt enable register IER
 LDA #%00000001         \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
 JSR OSWRCH             \ which comes from the keyboard)

 LDA #0                 \ Set the SVN flag to 0 and return from the subroutine
 BEQ DODOSVN            \ using a tail call (this BEQ is effectively a JMP as A
                        \ is always zero)

