\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for a specific key
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard, starting with internal key number 16 (Q) and working
\ through the set of internal key numbers (see p.142 of the Advanced User Guide
\ for a list of internal key numbers).
\
\ This routine is effectively the same as OSBYTE &7A, though the OSBYTE call
\ preserves A, unlike this routine.
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
\
\   A                   Contains the same as X
\
\ ******************************************************************************

.RDKEY

 LDX #16                \ Start the scan with internal key number 16 (Q)

.Rd1

 JSR DKS4               \ Scan the keyboard to see if the key in X is currently
                        \ being pressed

 BMI Rd2                \ Jump to Rd2 if this key is being pressed (in which
                        \ case DKS4 will have returned a negative value,
                        \ specifically 128 + X)

 INX                    \ Increment the key number

 BPL Rd1                \ Loop back to test the next key, ending the loop when
                        \ X is negative (i.e. 128)

 TXA                    \ If we get here, nothing is being pressed, so copy X
                        \ into A so that X = A = 128

.Rd2

 EOR #128               \ EOR A with 128, to switch off bit 7, so A now
                        \ contains 0 if no key has been pressed, or the
                        \ internal key number if it has been pressed

 TAX                    \ Copy A into X

 RTS                    \ Return from the subroutine

