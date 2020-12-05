\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Ask the I/O processor to scan the keyboard for key presses
\
\ ------------------------------------------------------------------------------
\
\ This routine sends an OSWORD &F0 command to the I/O processor to ask it to
\ scan the keyboard, starting with internal key number 16 ("Q") and working
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

 LDA #&F0               \ Send an OSWORD &F0 command to the I/O processor to
 LDY #HI(buf)           \ scan the keyboard and joysticks, and populate the key
 LDX #LO(buf)           \ buffer in KTRAN, which is the buffer just after the
 JSR OSWORD             \ size configuration bytes in buf

 LDX KTRAN              \ Fetch the internal key number of the key being pressed
                        \ into X

 TXA                    \ Copy X into A

 RTS                    \ Return from the subroutine

