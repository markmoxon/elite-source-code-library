\ ******************************************************************************
\
\       Name: GetShipBlueprint
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Fetch a specified byte from the current ship blueprint
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The offset of the byte to return from the blueprint
\
\ Returns:
\
\   A                   The Y-th byte of the current ship blueprint
\
\ ******************************************************************************

.GetShipBlueprint

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 LDA (XX0),Y            \ Set A to the Y-th byte of the current ship blueprint

                        \ Fall through into ResetBankA to retrieve the bank
                        \ number we stored above and page it back into memory

