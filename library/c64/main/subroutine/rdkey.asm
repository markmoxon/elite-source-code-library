\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for key presses and the joystick, and update the
\             key logger
\  Deep dive: Reading the Commodore 64 keyboard matrix
\             Sprite usage in Commodore 64 Elite
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\   C flag              The status of the result:
\
\                         * Clear if no keys are being pressed
\
\                         * Set if either a key is being pressed or the joystick
\                           fire button is being pressed
\
\ ******************************************************************************

.RDKEY

 TYA                    \ Store Y on the stack so we can preserve it across
 PHA                    \ calls to this routine

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
                        \ "Commodore 64 Programmer's Reference Guide", published
                        \ by Commodore
 LDA VIC+&15            \ Clear bit 1 of VIC register &15 to disable sprite 1,
 AND #%11111101         \ so this removes the explosion sprite from the screen
 STA VIC+&15            \ if there is one (so that the explosion burst only
                        \ appears fleetingly at the point of explosion, and
                        \ doesn't linger too long)

 JSR ZEKTRAN            \ Call ZEKTRAN to clear the key logger

 LDX JSTK               \ IF JSTK = 0 then joysticks are not configured, so jump
 BEQ scanmatrix         \ to scanmatrix to start scanning the keyboard matrix

                        \ If joysticks are configured then JSTK = &FF, so X is
                        \ now set to this value

 LDA CIA                \ Set A to bits 0-4 of CIA1 register 0, which are set to
 AND #%00011111         \ the following:
                        \
                        \   * Bit 0 = port 2 joystick up pressed
                        \
                        \   * Bit 1 = port 2 joystick down pressed
                        \
                        \   * Bit 2 = port 2 joystick left pressed
                        \
                        \   * Bit 3 = port 2 joystick right pressed
                        \
                        \   * Bit 4 = port 2 joystick fire pressed
                        \
                        \ A clear bit indicates that the direction/button is
                        \ being pressed, while a set bit indicates that it isn't

IF _GMA_RELEASE

 EOR #%00011111         \ Flip the polarity of bits 0-4, so a set bit indicates
 BNE dojoystick         \ activity, and jump to dojoystick with X = &FF if any
                        \ of the bits are set

ELIF _SOURCE_DISK

 CMP #%00011111         \ If nothing is being pressed then A will be %00011111,
 BNE dojoystick         \ in which case keep going, otherwise something is being
                        \ pressed, so jump to dojoystick with X = &FF
                        \
                        \ This relies on the top three bits of CIA1 register 0
                        \ always being zero, which is probably why this test was
                        \ rewritten for the GMA releases

ENDIF

.scanmatrix

                        \ If we get here then we need to scan the keyboard
                        \ matrix

 CLC                    \ Clear the C flag, so we can return this if no keys are
                        \ being pressed

 LDX #0                 \ Set X = 0 so we select every column in the keyboard
                        \ matrix (so we can quickly check whether any keys are
                        \ being held down)

 SEI                    \ Disable interrupts while we read the keyboard matrix

 STX &DC00              \ Set &DC00 = 0 to select every column in the keyboard
                        \ matrix

 LDX &DC01              \ Read &DC01 to see whether any keys are being pressed
                        \ in the columns we specified in &DC00 (i.e. in any
                        \ columns)

 CLI                    \ Enable interrupts again

 INX                    \ If we read &FF from &DC01 then this indicates that no
 BEQ nokeys2            \ keys are being pressed in any columns in the keyboard
                        \ matrix (as a pressed key is indicated by a clear bit
                        \ for that column, and incrementing &FF gives us zero),
                        \ so this jumps to nokeys2 if there are no keys being
                        \ pressed, which will return from the subroutine with
                        \ the C flag clear

                        \ If we get here then something is being pressed on the
                        \ keyboard, so we now loop through the whole matrix and
                        \ populate the key logger

 LDX #&40               \ The key logger at KEYLOOK records key presses for each
                        \ of the keys on the keyboard, from KEYLOOK+&1 to
                        \ KEYLOOK+&40, so set a counter in X to work through the
                        \ whole keyboard matrix

 LDA #%11111110         \ We can check whether anything is being pressed in a
                        \ particular column in the keyboard matrix by clearing
                        \ the corresponding bit in &DC00, so set a byte in A
                        \ with one bit clear, so we can shift it along to work
                        \ through the keyboard matrix from column 0 to 7

.Rdi1

 SEI                    \ Disable interrupts while we read the keyboard matrix

 STA &DC00              \ Set &DC00 = A to select the column in the keyboard
                        \ matrix that corresponds to the clear bit in A (so we
                        \ start with column 0 and end with to column 7)

 PHA                    \ Store our column selector byte on the stack, so we can
                        \ retrieve it for the next iteration around the loop

 LDY #8                 \ Each column contains eight keys, one on each row of
                        \ the keyboard matrix, so we now need to work our way
                        \ through each row, checking to see if the key in that
                        \ row has been pressed, so set a row counter in Y

.Rdi0

 LDA &DC01              \ Read &DC01 to see whether any keys are being pressed
                        \ in the column we specified in &DC00

 CMP &DC01              \ Keep reading the value from &DC01 until it is stable
 BNE Rdi0               \ for the duration of the LDA and CMP instructions, so
                        \ we know we have a clean signal (this implements a
                        \ simple "debounce", which is the act of delaying the
                        \ effects of a button press to ensure that the action
                        \ is only performed once rather than repeatedly)

 CLI                    \ Enable interrupts again

                        \ We now have a result from the keyboard scan that will
                        \ have a 0 in bit x if the key in row x is being
                        \ pressed in the current column, so we need to loop
                        \ through all eight bits in A to determine which keys
                        \ are being pressed

.Rdi2

 LSR A                  \ Shift bit 0 of A into the C flag

 BCS Rdi3               \ If the bit is set then the key corresponding to this
                        \ row is not being pressed, so jump to Rdi3 to leave the
                        \ key logger entry for this key set to 0

 DEC KEYLOOK,X          \ Decrement the X-th entry in the key logger from 0 to
                        \ &FF to indicate that this key is being pressed

 STX thiskey            \ Store the value of X (which we're calling the internal
                        \ key number in this commentary) in thiskey, which
                        \ stores the number of the last key pressed

 SEC                    \ Set the C flag, so we can rotate it into the column
                        \ selector byte below

.Rdi3

 DEX                    \ Decrement the key logger counter in X, so we move on
                        \ to the next key

 BMI Rdiex              \ If we have just decremented X past zero then we have
                        \ processed all keys and have filled the whole key
                        \ logger, so jump to Rdiex to finish up and return from
                        \ the subroutine

 DEY                    \ Otherwise decrement the row counter in Y to check the
                        \ next row in the current column

 BNE Rdi2               \ Loop back to Rdi2 to check the next key, until we have
                        \ done all eight keys in this column

 PLA                    \ We now want to move on to the next column, so fetch
                        \ the column selector byte from the stack, so we can
                        \ move on to the next iteration around the loop

 ROL A                  \ Rotate the value in A to the left to move the clear
                        \ bit along by one place, so we can select the next
                        \ column
                        \
                        \ Note that the ROL instruction rotates the C flag into
                        \ bit 0 of A, and the C flag is set if we just detected
                        \ a key press in the last column, so this ensures we
                        \ don't select columns that we know contain key presses
                        \ (but it does allow scans of columns that we know are
                        \ not being pressed, though these won't affect the
                        \ result of other column scans, as the scan only detects
                        \ key presses that pull the matrix low)

 BNE Rdi1               \ Jump to Rdi1 to move on to the next column
                        \
                        \ This BNE is effectively a JMP as A will never be zero
                        \ by this point; the only way it could happen is if
                        \ eight zeroes were rotated into A, but we know that at
                        \ least one of those loops much have a key press as we
                        \ already scanned the whole matrix at the start, so this
                        \ can't happen

.Rdiex

 PLA                    \ We put the column selector byte on the stack in the
                        \ loop above, so make sure we remove it to prevent the
                        \ stack from filling up

 SEC                    \ Set the C flag to return from the subroutine, to
                        \ indicate that a key has been pressed

.nokeys2

 LDA #%01111111         \ Set bits 0 to 5 of &DC00 to deselect every column in
 STA &DC00              \ the keyboard matrix

 BNE nojoyst            \ Jump to nojoyst to skip the joystick code (this BNE is
                        \ effectively a JMP as A is never zero)

.dojoystick

                        \ If we get here then at least one of the joystick
                        \ controls has been pressed:
                        \
                        \   * Bit 0 = port 2 joystick up pressed
                        \
                        \   * Bit 1 = port 2 joystick down pressed
                        \
                        \   * Bit 2 = port 2 joystick left pressed
                        \
                        \   * Bit 3 = port 2 joystick right pressed
                        \
                        \   * Bit 4 = port 2 joystick fire pressed

IF _GMA_RELEASE

                        \ A set bit in A indicates that the direction/button
                        \ is being pressed, while a clear bit indicates that it
                        \ isn't
                        \
                        \ X has the value &FF at this point

 LSR A                  \ Shift bit 0 into the C flag, and if it is set, store
 BCC downj              \ &FF in KY6 to indicate the joystick is pointing up
 STX KY6

.downj

 LSR A                  \ Shift bit 1 into the C flag, and if it is set, store
 BCC upj                \ &FF in KY5 to indicate the joystick is pointing down
 STX KY5

.upj

 LSR A                  \ Shift bit 2 into the C flag, and if it is set, store
 BCC leftj              \ &FF in KY3 to indicate the joystick is pointing left
 STX KY3

.leftj

 LSR A                  \ Shift bit 3 into the C flag, and if it is set, store
 BCC rightj             \ &FF in KY4 to indicate the joystick is pointing right
 STX KY4

.rightj

 LSR A                  \ Shift bit 4 into the C flag, and if it is set, store
 BCC firej              \ &FF in KY7 to indicate the joystick fire button is
 STX KY7                \ being pressed

.firej

                        \ If we get here then the C flag is set if the joystick
                        \ fire button is being pressed, or clear otherwise

ELIF _SOURCE_DISK

                        \ A clear bit in A indicates that the direction/button
                        \ is being pressed, while a set bit indicates that it
                        \ isn't
                        \
                        \ X has the value &FF at this point

 LSR A                  \ Shift bit 0 into the C flag, and if it is clear, store
 BCS downj              \ &FF in KY6 to indicate the joystick is pointing up
 STX KY6

.downj

 LSR A                  \ Shift bit 1 into the C flag, and if it is clear, store
 BCS upj                \ &FF in KY5 to indicate the joystick is pointing down
 STX KY5

.upj

 LSR A                  \ Shift bit 2 into the C flag, and if it is clear, store
 BCS leftj              \ &FF in KY3 to indicate the joystick is pointing left
 STX KY3

.leftj

 LSR A                  \ Shift bit 3 into the C flag, and if it is clear, store
 BCS rightj             \ &FF in KY4 to indicate the joystick is pointing right
 STX KY4

.rightj

 LSR A                  \ Shift bit 4 into the C flag, and if it is clear, store
 BCS firej              \ &FF in KY7 to indicate the joystick fire button is
 STX KY7                \ being pressed

                        \ If we get here then the joystick fire button is being
                        \ pressed, so the C flag is clear

 EQUB &24               \ Skip the next instruction by turning it into &24 &18,
                        \ or BIT &0018, which does nothing apart from affect the
                        \ flags
                        \
                        \ This doesn't make a lot of sense as the next
                        \ instruction is a CLC, and the C flag is already clear,
                        \ so this has no effect; perhaps the next instruction is
                        \ supposed to be a SEC, but as this part of the code was
                        \ rewritten for the GMA release, it's all a bit moot

.firej

 CLC                    \ Clear the C flag to indicate that no buttons are being
                        \ pressed

ENDIF

 LDA JSTGY              \ If JSTGY is 0 then the game is not configured to
 BEQ noswapys           \ reverse the controller y-axis, so jump to noswapys to
                        \ skip the following and leave the joystick direction
                        \ alone

 LDA KY5                \ Swap the values of KY5 and KY6, which are the two
 LDX KY6                \ y-axis directions (i.e. up and down)
 STA KY6
 STX KY5

.noswapys

 LDA JSTE               \ JSTE contains &FF if both joystick channels are
 BEQ noswapxs           \ reversed and 0 otherwise, so skip to noswapxs if the
                        \ joystick channels are not reversed

 LDA KY5                \ Swap the values of KY5 and KY6, which are the two
 LDX KY6                \ y-axis directions (i.e. up and down)
 STA KY6
 STX KY5

 LDA KY3                \ Swap the values of KY3 and KY4, which are the two
 LDX KY4                \ x-axis directions (i.e. right and left)
 STA KY4
 STX KY3

.noswapxs

.nojoyst

 LDA QQ11               \ If QQ11 = 0 then this is the space view, so jump to
 BEQ allkeys            \ allkeys to skip resetting the secondary flight
                        \ controls in the key logger

 LDA #0                 \ This is not the space view, so reset the entries in
 STA KY12               \ the key logger for the secondary flight controls from
 STA KY13               \ KY12 to KY20, as these keys only have meaning in the
 STA KY14               \ space view
 STA KY15
 STA KY16
 STA KY17
 STA KY18
 STA KY19
 STA KY20

.allkeys

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
                        \ "Commodore 64 Programmer's Reference Guide", published
                        \ by Commodore
 PLA                    \ Retrieve the value of Y from the stack, which we
 TAY                    \ stored at the start of the subroutine, so the value of
                        \ Y is preserved

 LDA thiskey            \ Set A and X to the internal key number of the last key
 TAX                    \ that we scanned, so it is set as the last key pressed

 RTS                    \ Return from the subroutine

