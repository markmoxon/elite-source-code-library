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

IF _SOURCE_DISK_CODE_FILES

 LDA &80                \ ???
 RTS
 LDA &85
 BIT &86
 BPL L794B
 LDA #&01

.L794B

 BIT &87

 BPL L7951
 ASL A
 ASL A

.L7951

 TAY

 LDA #&00
 STA &83
 STA &84
 STA &85
 STA &86
 STA &87

ENDIF

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger

 RTS                    \ Return from the subroutine

.TJ1

IF _IB_DISK

 LDA #0
 STA &8C
 STA &8E

ENDIF

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger

 LDX #0                 \ Set the initial values for the results, X = Y = 0,
 LDY #0                 \ which we now increase or decrease appropriately

 CMP #8                 \ ???

IF _IB_DISK

 BEQ &794B
 CMP #&4A

ENDIF

 BNE P%+3
 DEX
 CMP #21

IF _IB_DISK

 BEQ P%+6
 CMP #&4B

ENDIF

 BNE P%+3
 INX
 CMP #10

IF _IB_DISK

 BEQ P%+6
 CMP #&4D

ENDIF

 BNE P%+3
 DEY
 CMP #11

IF _IB_DISK

 BEQ P%+6
 CMP #&49

ENDIF

 BNE P%+3
 INY
 RTS

.TJS1

                        \ This routine calculates the following:
                        \
                        \   A = round(A / 16) - 4
                        \
                        \ This set A to a value between -4 and +4, given an
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

