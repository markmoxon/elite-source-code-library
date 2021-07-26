\ ******************************************************************************
\
\       Name: scan_xin
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Implement the scan_xin command (scan the keyboard for a specific
\             key press)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a scan_xin command. It scans the
\ keyboard to see if the specified key is being pressed and returns the result
\ to the parasite as follows. If the key is being pressed, the result contains
\ the original key number in but with bit 7 set (i.e. key number +128). If the
\ key is not being pressed, the result contains the unchanged key number.
\
\ ******************************************************************************

.scan_xin

 JSR tube_get           \ Get the parameter from the parasite for the command:
 TAX                    \
                        \ =scan_xin(key_number)
                        \
                        \ and store it as follows:
                        \
                        \   * X = the internal key number to scan for

 JSR DKS4               \ Scan the keyboard to see if the key in X is currently
                        \ being pressed, returning the result in A and X

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

