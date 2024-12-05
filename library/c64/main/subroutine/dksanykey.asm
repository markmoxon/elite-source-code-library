\ ******************************************************************************
\
\       Name: DKSANYKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan a specific column in the keyboard matrix for a key press
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The value to pass to &DC00 (i.e. set all bits apart from
\                       one clear bit in the position of the column that we want
\                       to scan)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The result:
\
\                         * &FF if a key is being pressed in the specified
\                           column
\
\                         * 0 if no key is being pressed in the specified
\                           column
\
\   X                   Contains the same as A
\
\ ******************************************************************************

.DKSANYKEY

 LDA #%101              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ Programmer's Reference Guide

 SEI                    \ Disable interrupts while we read the keyboard matrix

 STX &DC00              \ Set &DC00 = X to select the column in the keyboard
                        \ matrix that corresponds to the clear bit in X

 LDX &DC01              \ Read &DC01 to see whether any keys are being pressed
                        \ in the column we specified in &DC00

 CLI                    \ Enable interrupts again

 INX                    \ If we read &FF from &DC01 then this indicates that no
 BEQ DKSL1              \ keys are being pressed in the specified column in the
                        \ keyboard matrix (as a pressed key is indicated by a
                        \ clear bit for that column, and incrementing &FF gives
                        \ us zero), so this jumps to DKSL1 with X = 0 if there
                        \ are no keys being pressed in that column

 LDX #&FF               \ If we get here then something is being pressed on the
                        \ keyboard in the specified column, so set X = &FF

.DKSL1

 LDA #%100              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

 TXA                    \ Copy the result from X into A

 RTS                    \ Return from the subroutine

 RTS                    \ This instruction has no effect, as we already returned
                        \ from the subroutine

