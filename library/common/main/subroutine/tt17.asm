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

 JSR DOKEY              \ Scan the keyboard for flight controls and pause keys,
                        \ (or the equivalent on joystick) and update the key
                        \ logger, setting KL to the key pressed

IF _6502SP_VERSION

 LDX #0                 \ Call DKS4 to check whether the SHIFT key is being
 JSR DKS4               \ pressed

 STA newlocn            \ Store the result (which will have bit 7 set if SHIFT
                        \ is being pressed) in newlocn

ENDIF

 LDA JSTK               \ If the joystick was not used, jump down to TJ1,
 BEQ TJ1                \ otherwise we move the cursor with the joystick

 LDA JSTX               \ Fetch the joystick roll, ranging from 1 to 255 with
                        \ 128 as the centre point

 EOR #&FF               \ Flip the sign so A = -JSTX, because the joystick roll
                        \ works in the opposite way to moving a cursor on-screen
                        \ in terms of left and right

 JSR TJS1               \ Call TJS1 just below to set Y to a value between -2
                        \ and +2 depending on the joystick roll value (moving
                        \ the stick sideways)

 TYA                    \ Copy Y to A

IF _6502SP_VERSION

 BIT newlocn            \ If bit 7 of newlocn is clear - in other words, if
 BPL P%+3               \ SHIFT is not being pressed - then skip the following
                        \ instruction

 ASL A                  \ SHIFT is being held down, so double the value of A
                        \ (i.e. SHIFT moves the cursor at double the speed
                        \ when using the joystick)

ENDIF

 TAX                    \ Copy A to X

 LDA JSTY               \ Fetch the joystick pitch, ranging from 1 to 255 with
                        \ 128 as the centre point, and fall through into TJS1 to
                        \ joystick pitch value (moving the stick up and down)

.TJS1

 TAY                    \ Store A in Y

 LDA #0                 \ Set the result, A = 0

 CPY #16                \ If Y >= 16 set the C flag, so A = A - 1
 SBC #0

\CPY #&20               \ These instructions are commented out in the original
\SBC #0                 \ source, but they would make the joystick move the
                        \ cursor faster by increasing the range of Y by -1 to +1

 CPY #64                \ If Y >= 64 set the C flag, so A = A - 1
 SBC #0

 CPY #192               \ If Y >= 192 set the C flag, so A = A + 1
 ADC #0

 CPY #224               \ If Y >= 224 set the C flag, so A = A + 1
 ADC #0

\CPY #&F0               \ These instructions are commented out in the original
\ADC #0                 \ source, but they would make the joystick move the
                        \ cursor faster by increasing the range of Y by -1 to +1

IF _6502SP_VERSION

 BIT newlocn            \ If bit 7 of newlocn is clear - in other words, if
 BPL P%+3               \ SHIFT is not being pressed - then skip the following
                        \ instruction

 ASL A                  \ SHIFT is being held down, so double the value of A
                        \ (i.e. SHIFT moves the cursor at double the speed
                        \ when using the joystick

ENDIF

 TAY                    \ Copy the value of A into Y

 LDA KL                 \ Set A to the value of KL (the key pressed)

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION

.newlocn

 EQUB 0                 \ The current key press is stored here in the above code
                        \ when we check whether SHIFT is being held down

ENDIF

.TJ1

 LDA KL                 \ Set A to the value of KL (the key pressed)

 LDX #0                 \ Set the results, X = Y = 0
 LDY #0

 CMP #&19               \ If left arrow was pressed, set X = X - 1
 BNE P%+3
 DEX

 CMP #&79               \ If right arrow was pressed, set X = X + 1
 BNE P%+3
 INX

 CMP #&39               \ If up arrow was pressed, set Y = Y + 1
 BNE P%+3
 INY

 CMP #&29               \ If down arrow was pressed, set Y = Y - 1
 BNE P%+3
 DEY

IF _DISC_DOCKED

 STX T                  \ ????

 LDX #0
 JSR DKS4
 BPL TJe

 ASL T
 ASL T
 TYA

 ASL A                  \ SHIFT is being held down, so quadruple the value of A
 ASL A                  \ (i.e. SHIFT moves the cursor at four times the speed
                        \ when using the keyboard)

 TAY                    \ Transfer the amended value of A back into Y

.TJe

 LDX T

 LDA KL                 \ Set A to the value of KL (the key pressed)

ELIF _6502SP_VERSION

 TXA                    \ Transfer the value of X into A

 BIT newlocn            \ If bit 7 of newlocn is clear - in other words, if
 BPL P%+4               \ SHIFT is not being pressed - then skip the following
                        \ two instructions

 ASL A                  \ SHIFT is being held down, so quadruple the value of A
 ASL A                  \ (i.e. SHIFT moves the cursor at four times the speed
                        \ when using the keyboard)

 TAX                    \ Transfer the amended value of A back into X

 TYA                    \ Transfer the value of Y into A

 BIT newlocn            \ If bit 7 of newlocn is clear - in other words, if
 BPL P%+4               \ SHIFT is not being pressed - then skip the following
                        \ two instructions

 ASL A                  \ SHIFT is being held down, so quadruple the value of A
 ASL A                  \ (i.e. SHIFT moves the cursor at four times the speed
                        \ when using the keyboard)

 TAY                    \ Transfer the amended value of A back into Y

 LDA KL                 \ Set A to the value of KL (the key pressed)

ENDIF

 RTS                    \ Return from the subroutine

