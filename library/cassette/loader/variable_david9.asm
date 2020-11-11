\ ******************************************************************************
\
\       Name: David9
\       Type: Variable
\   Category: Copy protection
\    Summary: Address used as part of the stack-based decryption loop
\
\ ------------------------------------------------------------------------------
\
\ This address is used in the decryption loop starting at David2 in part 4, and
\ is used to jump back into the loop at David5.
\
\ ******************************************************************************

.David9

 EQUW David5            \ The address of David5

 CLD                    \ This instruction is not used

