\ ******************************************************************************
\
\       Name: scan_10in
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Implement the scan_10in command (scan the keyboard)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a scan_10in command. It scans the
\ keyboard for a key press and returns the internal key number of the key being
\ to the parasite (or it returns 0 if no keys are being pressed).
\
\ ******************************************************************************

.scan_10in

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

