\ ******************************************************************************
\
\       Name: NWDAV4
\       Type: Subroutine
\   Category: Market
\    Summary: Print an "ITEM?" error, make a beep and rejoin the TT210 routine
\
\ ******************************************************************************

.NWDAV4

 JSR TT67               \ Print a newline

 LDA #176               \ Print recursive token 127 ("ITEM") followed by a
 JSR prq                \ question mark

 JSR dn2                \ Call dn2 to make a short, high beep and delay for 1
                        \ second

 LDY QQ29               \ Fetch the item number we are selling from QQ29

 JMP NWDAVxx            \ Jump back into the TT210 routine that called NWDAV4

