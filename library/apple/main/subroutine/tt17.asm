\ ******************************************************************************
\
\       Name: TT17
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for cursor key or joystick movement
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard and joystick for cursor key or stick movement, and return
\ the result as deltas (changes) in x- and y-coordinates as follows:
\
\   * For joystick, X and Y are integers between -2 and +2 depending on how far
\     the stick has moved
\
\   * For keyboard, X and Y are integers between -1 and +1 depending on which
\     keys are pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The key pressed, if the arrow keys were used
\
\   X                   Change in the x-coordinate according to the cursor keys
\                       being pressed or joystick movement, as an integer (see
\                       above)
\
\   Y                   Change in the y-coordinate according to the cursor keys
\                       being pressed or joystick movement, as an integer (see
\                       above)
\
\ ******************************************************************************

.TT17

 LDA QQ11               \ If this not the space view, skip the following three
 BNE TT17afterall       \ instructions to move onto the cursor key logic

 JSR DOKEY              \ This is the space view, so scan the keyboard for
                        \ flight controls and pause keys, (or the equivalent on
                        \ joystick) and update the key logger, setting KL to the
                        \ key pressed

 TXA                    \ Transfer the value of the key pressed from X to A

 RTS                    \ Return from the subroutine

.TT17afterall

 JSR DOKEY              \ Scan the keyboard for flight controls and pause keys,
                        \ (or the equivalent on joystick) and update the key
                        \ logger, setting KL to the key pressed

 LDA JSTK               \ If the joystick is not configured, jump down to TJ1,
 BEQ TJ1                \ otherwise we move the cursor with the joystick

 LDA JSTY               \ Fetch the joystick pitch, ranging from 1 to 255 with
                        \ 128 as the centre point

 JSR TJS1               \ Call TJS1 just below to set A to a value between -4
                        \ and +4 depending on the joystick pitch value (moving
                        \ the stick up and down)

 TAY                    \ Copy the result into Y

 LDA JSTX               \ Fetch the joystick roll, ranging from 1 to 255 with
                        \ 128 as the centre point

 EOR #&FF               \ Flip the sign so A = -JSTX, because the joystick roll
                        \ works in the opposite way to moving a cursor on-screen
                        \ in terms of left and right

 JSR TJS1               \ Call TJS1 just below to set A to a value between -4
                        \ and +4 depending on the joystick roll value (moving
                        \ the stick sideways)

 TAX                    \ Copy A to X, so X contains the joystick roll value

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger

 RTS                    \ Return from the subroutine

IF _SOURCE_DISK_CODE_FILES

                        \ This code, which is only present in the CODE* binary
                        \ files already on the source disk, is never called, but
                        \ it would allow faster movement of the crosshairs on
                        \ the system charts if fire was also pressed
                        \
                        \ It sets Y as follows:
                        \
                        \   * -1 if the ship is being pulled up
                        \
                        \   * -4 if the ship is being pulled up while the fire
                        \        key is being pressed
                        \
                        \   * +1 if the ship is being pitched down
                        \
                        \   * +4 if the ship is being pitched down while the
                        \        firekey is being pressed
                        \
                        \   * 0 otherwise

 LDA KY5                \ Set A to the state of the "X" key (pull up), which
                        \ will be &FF (i.e. -1) if the key is being pressed

 BIT KY6                \ If the "S" key (pitch down) is being pressed, set
 BPL P%+4               \ A = 1
 LDA #1

 BIT KY7                \ If the "A" key (fire lasers) is being pressed, double
 BPL P%+4               \ the value in A
 ASL A
 ASL A

 TAY                    \ Copy the value of A into Y

 LDA #0                 \ Clear the key logger entries for the primary flight
 STA KY3                \ controls
 STA KY4
 STA KY5
 STA KY6
 STA KY7

ENDIF

.TJ1

IF _IB_DISK

 LDA #0                 \ Clear the key logger entries for "M" (fire missile)
 STA KY16               \ and "J" (in-system jump)
 STA KY18

ENDIF

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger

 LDX #0                 \ Set the initial values for the results, X = Y = 0,
 LDY #0                 \ which we now increase or decrease appropriately

IF _IB_DISK

 CMP #8                 \ If left arrow (CTRL-H) was pressed, skip the next two
 BEQ P%+6               \ instructions to set X = X - 1

 CMP #'J'               \ If "J" was not pressed, skip the next instruction
 BNE P%+3

 DEX                    \ Either left arrow (CTRL-H) or "J" was pressed, so set
                        \ X = X - 1

 CMP #21                \ If right arrow (CTRL-U) was pressed, skip the next two
 BEQ P%+6               \ instructions to set X = X + 1

 CMP #'K'               \ If "K" was not pressed, skip the next instruction
 BNE P%+3

 INX                    \ Either right arrow (CTRL-U) or "K" was pressed, so set
                        \ X = X + 1

 CMP #10                \ If down arrow (CTRL-J) was pressed, skip the next two
 BEQ P%+6               \ instructions to set Y = Y - 1

 CMP #'M'               \ If "M" was not pressed, skip the next instruction
 BNE P%+3

 DEY                    \ Either down arrow (CTRL-J) or "M" was pressed, so set
                        \ Y = Y - 1

 CMP #11                \ If up arrow (CTRL-K) was pressed, skip the next two
 BEQ P%+6               \ instructions to set Y = Y + 1

 CMP #'I'               \ If "I" was not pressed, skip the next instruction
 BNE P%+3

 INY                    \ Either up arrow (CTRL-K) or "I" was pressed, so set
                        \ Y = Y + 1

ELIF _SOURCE_DISK

 CMP #8                 \ If left arrow (CTRL-H) was pressed, set X = X - 1
 BNE P%+3
 DEX

 CMP #21                \ If right arrow (CTRL-U) was pressed, set X = X + 1
 BNE P%+3
 INX

 CMP #10                \ If down arrow (CTRL-J) was pressed, set Y = Y - 1
 BNE P%+3
 DEY

 CMP #11                \ If up arrow (CTRL-K) was pressed, set Y = Y + 1
 BNE P%+3
 INY

ENDIF

 RTS                    \ Return from the subroutine

.TJS1

                        \ This routine calculates the following:
                        \
                        \   A = round(A / 16) - 4
                        \
                        \ This sets A to a value between -4 and +4, given an
                        \ initial value ranging from 1 to 255 with 128 as
                        \ the centre point

 LSR A                  \ Set A = A / 16
 LSR A                  \
 LSR A                  \ and C contains the last bit to be shifted out
 LSR A
 LSR A

 ADC #0                 \ If that last bit was a 1, this increments A, so
                        \ this effectively implements a rounding function,
                        \ where 0.5 and above get rounded up

 SBC #3                 \ The addition will not overflow, so the C flag is
                        \ clear at this point, so this performs:
                        \
                        \   A = A - 3 - (1 - C)
                        \     = A - 3 - (1 - 0)
                        \     = A - 3 - 1
                        \     = A - 4

 RTS                    \ Return from the subroutine

