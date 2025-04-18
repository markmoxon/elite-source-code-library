\ ******************************************************************************
\
\       Name: TT17
\       Type: Subroutine
\   Category: Keyboard
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Scan the keyboard for cursor key or joystick movement
ELIF _ELECTRON_VERSION
\    Summary: Scan the keyboard for cursor key movement
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
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
ELIF _ELECTRON_VERSION
\ Scan the keyboard for cursor key movement, and return the result as deltas
\ (changes) in x- and y-coordinates as follows:
\
\   * X and Y are integers between -1 and +1 depending on which keys are pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The key pressed, if the arrow keys were used
\
\   X                   Change in the x-coordinate according to the cursor keys
\                       being pressed, as an integer (see above)
\
\   Y                   Change in the y-coordinate according to the cursor keys
\                       being pressed, as an integer (see above)
ENDIF
\
IF _ELITE_A_6502SP_PARA
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   chk_dirn            Do not scan the keyboard, instead just set the movement
\                       variables based on the current state of the key logger
\
ENDIF
IF _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TJ1                 Check for cursor key presses and return the combined
\                       deltas for the digital joystick and cursor keys (Master
\                       Compact only)
\
ENDIF
\ ******************************************************************************

.TT17

IF _MASTER_VERSION \ Master: The Master version doesn't check for SHIFT being held down in the space view, as it has no effect there (it's only used in the chart views for speeding up the crosshairs)

 LDA QQ11               \ If this not the space view, skip the following three
 BNE TT17afterall       \ instructions to move onto the cursor key logic

 JSR DOKEY              \ This is the space view, so scan the keyboard for
                        \ flight controls and pause keys, (or the equivalent on
                        \ joystick) and update the key logger, setting KL to the
                        \ key pressed

 TXA                    \ Transfer the value of the key pressed from X to A

 RTS                    \ Return from the subroutine

.TT17afterall

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 JSR DOKEY              \ Scan the keyboard for flight controls and pause keys,
                        \ (or the equivalent on joystick) and update the key
                        \ logger, setting KL to the key pressed

ELIF _ELECTRON_VERSION

 JSR DOKEY              \ Scan the keyboard for flight controls and pause keys,
                        \ and update the key logger, setting KL to the key
                        \ pressed

ENDIF

IF _ELITE_A_6502SP_PARA

.chk_dirn

ENDIF

IF _6502SP_VERSION \ Enhanced: Group A: In the enhanced versions, the cursor moves more quickly in the chart views if you hold down SHIFT

 LDX #0                 \ Call DKS4 to check whether the SHIFT key is being
 JSR DKS4               \ pressed

 STA newlocn            \ Store the result (which will have bit 7 set if SHIFT
                        \ is being pressed) in newlocn

ENDIF

IF _MASTER_VERSION \ Master: Group C: The Master Compact release allows you to move the chart crosshairs using the digital joystick, using the TT17X and DJOY routines

IF _COMPACT

 LDX #0                 \ Set the initial values for the results, X = Y = 0,
 LDY #0                 \ which we now increase or decrease appropriately

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: Despite never reading the joystick values from the ADC channels, the Electron version still lets the joystick control the crosshairs on the chart views, if joysticks are configured. The result is an uncontrollable crosshair that moves of its own accord, so presumably this is a bug

 LDA JSTK               \ If the joystick is not configured, jump down to TJ1,
 BEQ TJ1                \ otherwise we move the cursor with the joystick

ELIF _ELECTRON_VERSION

 LDX JSTK               \ If the joystick is not configured, jump down to TJ1,
 BEQ TJ1                \ otherwise keep going... though as the DOKEY routine
                        \ doesn't read the ADC channels in the Electron version,
                        \ this doesn't actually work, but instead moves the
                        \ crosshairs in an uncontrollable way, so this is
                        \ presumably a bug

ENDIF

IF _MASTER_VERSION \ Master: See group C

IF _COMPACT

 LDA MOS                \ If MOS = 0 then this is a Master Compact, so jump to
 BEQ DJOY               \ DJOY to read the digital joystick before rejoining the
                        \ routine below at TJ1

ENDIF

 LDA JSTY               \ Fetch the joystick pitch, ranging from 1 to 255 with
                        \ 128 as the centre point

 JSR TJS1               \ Call TJS1 just below to set A to a value between -4
                        \ and +4 depending on the joystick pitch value (moving
                        \ the stick up and down)

 TAY                    \ Copy the result into Y

ENDIF

 LDA JSTX               \ Fetch the joystick roll, ranging from 1 to 255 with
                        \ 128 as the centre point

 EOR #&FF               \ Flip the sign so A = -JSTX, because the joystick roll
                        \ works in the opposite way to moving a cursor on-screen
                        \ in terms of left and right

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 JSR TJS1               \ Call TJS1 just below to set A to a value between -2
                        \ and +2 depending on the joystick roll value (moving
                        \ the stick sideways)

ELIF _MASTER_VERSION

 JSR TJS1               \ Call TJS1 just below to set A to a value between -4
                        \ and +4 depending on the joystick roll value (moving
                        \ the stick sideways)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: Group B: The Master has different logic around moving the crosshairs on the chart views, though the results appear to be the same

 TYA                    \ Copy Y to A

ENDIF

IF _6502SP_VERSION \ Enhanced: See group A

 BIT newlocn            \ If bit 7 of newlocn is clear - in other words, if
 BPL P%+3               \ SHIFT is not being pressed - then skip the following
                        \ instruction

 ASL A                  \ SHIFT is being held down, so double the value of A
                        \ (i.e. SHIFT moves the cursor at double the speed
                        \ when using the joystick)

ENDIF

IF _CASSETTE_VERSION \ Master: See group B

 TAX                    \ Copy A to X, so X contains the joystick roll value

 LDA JSTY               \ Fetch the joystick pitch, ranging from 1 to 255 with
                        \ 128 as the centre point, and fall through into TJS1 to
                        \ set Y to the joystick pitch value (moving the stick up
                        \ and down)

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

ELIF _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION

 TAX                    \ Copy A to X, so X contains the joystick roll value

 LDA JSTY               \ Fetch the joystick pitch, ranging from 1 to 255 with
                        \ 128 as the centre point, and fall through into TJS1 to
                        \ set Y to the joystick pitch value (moving the stick up
                        \ and down)

.TJS1

 TAY                    \ Store A in Y

 LDA #0                 \ Set the result, A = 0

 CPY #16                \ If Y >= 16 set the C flag, so A = A - 1
 SBC #0

 CPY #64                \ If Y >= 64 set the C flag, so A = A - 1
 SBC #0

 CPY #192               \ If Y >= 192 set the C flag, so A = A + 1
 ADC #0

 CPY #224               \ If Y >= 224 set the C flag, so A = A + 1
 ADC #0

ENDIF

IF _6502SP_VERSION \ Enhanced: See group A

 BIT newlocn            \ If bit 7 of newlocn is clear - in other words, if
 BPL P%+3               \ SHIFT is not being pressed - then skip the following
                        \ instruction

 ASL A                  \ SHIFT is being held down, so double the value of A
                        \ (i.e. SHIFT moves the cursor at double the speed
                        \ when using the joystick

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group B

 TAY                    \ Copy the value of A into Y

 LDA KL                 \ Set A to the value of KL (the key pressed)

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

 TAX                    \ Copy the value of A into X

IF _SNG47

 LDA KL                 \ Set A to the value of KL (the key pressed)

 RTS                    \ Return from the subroutine

ENDIF

ENDIF

IF _6502SP_VERSION \ Enhanced: See group A

.newlocn

 EQUB 0                 \ The current key press is stored here in the above code
                        \ when we check whether SHIFT is being held down

ENDIF

.TJ1

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA KL                 \ Set A to the value of KL (the key pressed)

 LDX #0                 \ Set the initial values for the results, X = Y = 0,
 LDY #0                 \ which we now increase or decrease appropriately

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

ELIF _ELECTRON_VERSION

 LDA KL                 \ Set A to the value of KL (the key pressed)

 LDY #0                 \ Set the result, Y = 0 (and we know that X is 0 as well
                        \ as we jumped to TJ1 from above following a LDX and a
                        \ BEQ)

 CMP #&18               \ If left arrow was pressed, set X = X - 1
 BNE P%+3
 DEX

 CMP #&78               \ If right arrow was pressed, set X = X + 1
 BNE P%+3
 INX

 CMP #&39               \ If up arrow was pressed, set Y = Y + 1
 BNE P%+3
 INY

 CMP #&28               \ If down arrow was pressed, set Y = Y - 1
 BNE P%+3
 DEY

ELIF _MASTER_VERSION

 LDA KL                 \ Set A to the value of KL (the key pressed)

IF _SNG47

 LDX #0                 \ Set the results, X = Y = 0
 LDY #0

ENDIF

 CMP #&8C               \ If left arrow was pressed, set X = X - 1
 BNE P%+3
 DEX

 CMP #&8D               \ If right arrow was pressed, set X = X + 1
 BNE P%+3
 INX

 CMP #&8E               \ If down arrow was pressed, set Y = Y - 1
 BNE P%+3
 DEY

 CMP #&8F               \ If up arrow was pressed, set Y = Y + 1
 BNE P%+3
 INY

ENDIF

IF _DISC_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Enhanced: See group A

 STX T                  \ Set T to the value of X, which contains the joystick
                        \ roll value

 LDX #0                 \ Scan the keyboard to see if the SHIFT key is currently
 JSR DKS4               \ being pressed, returning the result in A and X

 BPL TJe                \ If SHIFT is not being pressed, skip to TJe

 ASL T                  \ SHIFT is being held down, so quadruple the value of T
 ASL T                  \ (i.e. SHIFT moves the cursor at four times the speed
                        \ when using the joystick)

 TYA                    \ Fetch the joystick pitch value from Y into A

 ASL A                  \ SHIFT is being held down, so quadruple the value of A
 ASL A                  \ (i.e. SHIFT moves the cursor at four times the speed
                        \ when using the joystick)

 TAY                    \ Transfer the amended value of A back into Y

.TJe

 LDX T                  \ Fetch the amended value of T back into X

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

ELIF _MASTER_VERSION

 PHX                    \ Store X (which contains the change in the
                        \ x-coordinate) on the stack so we can retrieve it later

IF _SNG47

 LDA #0                 \ Call DKS5 to check whether the SHIFT key is being
 JSR DKS5               \ pressed

ELIF _COMPACT

 LDA #0                 \ Call DKS4mc to check whether the SHIFT key is being
 JSR DKS4mc             \ pressed

ENDIF

 BMI speedup            \ If SHIFT is being pressed, skip the next three
                        \ instructions

 PLX                    \ SHIFT is not being pressed, so retrieve the value of X
                        \ we stored above so we can return it

 LDA KL                 \ Set A to the value of KL (the key pressed)

 RTS                    \ Return from the subroutine

.speedup

 PLA                    \ Pull the value of X from the stack into A, so A now
                        \ contains the change in the x-coordinate

 ASL A                  \ SHIFT is being held down, so quadruple the value of A
 ASL A                  \ (i.e. SHIFT moves the cursor at four times the speed
                        \ when using the joystick)

 TAX                    \ Put the amended value of A back into X

 TYA                    \ Now to do the same with the change in y-coordinate, so
                        \ fetch the value of Y into A

 ASL A                  \ SHIFT is being held down, so quadruple the value of A
 ASL A                  \ (i.e. SHIFT moves the cursor at four times the speed
                        \ when using the joystick)

 TAY                    \ Put the amended value of A back into Y

IF _COMPACT

 STZ KY7                \ Clear the key logger at KY7 to reset the "A" (fire)
                        \ button to "not pressed"

ENDIF

 LDA KL                 \ Set A to the value of KL (the key pressed)

ENDIF

 RTS                    \ Return from the subroutine

IF _MASTER_VERSION \ Master: See group B

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

ENDIF

