\ ******************************************************************************
\
\       Name: GetDefaultNEWB
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Fetch the default NEWB flags for a specified ship type
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The ship type
\
\ Returns:
\
\   A                   The default NEWB flags for ship type Y
\
\ ******************************************************************************

.GetDefaultNEWB

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 LDA E%-1,Y             \ Set A to the default NEWB flags for ship type Y

 JMP ResetBankA         \ Jump to ResetBankA to retrieve the bank number we
                        \ stored above and page it back into memory, returning
                        \ from the subroutine using a tail call

