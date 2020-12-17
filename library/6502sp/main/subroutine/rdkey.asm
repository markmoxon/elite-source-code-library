\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for key presses by sending an OSWORD 240 command
\             to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ This routine sends an OSWORD 240 command to the I/O processor to ask it to
\ scan the keyboard, starting with internal key number 16 ("Q") and working
\ through the set of internal key numbers (see p.142 of the Advanced User Guide
\ for a list of internal key numbers). The results are copied from the I/O
\ processor into the key logger buffer at KTRAN.
\
\ This routine is effectively the same as OSBYTE 122, though the OSBYTE call
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

 LDA #240               \ Set A in preparation for sending an OSWORD 240 command

 LDY #HI(buf)           \ Set (Y X) to point to the parameter block at buf
 LDX #LO(buf)

 JSR OSWORD             \ Send an OSWORD 240 command to the I/O processor to
                        \ scan the keyboard and joysticks, and populate the key
                        \ logger buffer in KTRAN, which is the part of the buf
                        \ buffer just after the two OSWORD size bytes

 LDX KTRAN              \ Set X to the first byte of the updated KTRAN, which
                        \ contains the internal key number of the key being
                        \ pressed, or 0 if there is no keypress

 TXA                    \ Copy X into A

 RTS                    \ Return from the subroutine

