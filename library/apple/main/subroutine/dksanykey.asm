
\ ******************************************************************************
\
\       Name: DKSANYKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: An unused routine that scans the keyboard to detect whether any
\             key is being pressed
\  Deep dive: Working with the Apple II keyboard
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed then X = &FF, otherwise X = 0
\
\   A                   Contains the same as X
\
\ ******************************************************************************

.DKSANYKEY

 LDX #0                 \ Set X = 0 as the value to return if no key is being
                        \ pressed

 BIT &C000              \ If bit 7 of the KBD soft switch is clear then there is
 BPL P%+6               \ no key press data to be read, so skip the next two
                        \ instructions to return a value of 0 in A and X

 DEX                    \ Otherwise bit 7 of the KBD soft switch is set, which
                        \ means there is a key bring pressed, so decrement X to
                        \ &FF so we can return this in A and X

 BIT &C010              \ Clear the keyboard strobe by reading the KBDSTRB soft
                        \ switch, which tells the system to drop any current key
                        \ press data and start waiting for the next key press

 TXA                    \ Copy the result into A

 RTS                    \ Return from the subroutine

