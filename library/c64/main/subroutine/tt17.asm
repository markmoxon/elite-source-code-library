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
\   * For joystick, X and Y are integers between -1 and +1 depending on the
\     stick direction and if the fire button is not being pressed, or -4 and +4
\     if the fire button is being pressed
\
\   * For keyboard, X and Y are integers between -1 and +1 depending on which
\     keys are pressed and if RETURN is not being pressed, or -4 and +4 if
\     RETURN is being pressed
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

                        \ We now move the cursor according to the joystick's
                        \ position, moving the cursor much faster if the fire
                        \ button is held down

 LDA KY3                \ Set A to the status of the roll left joystick axis in
                        \ KY4, so A is 0 if it not being "pressed" or &FF if it
                        \ is (where &FF is -1 as a signed integer)

 BIT KY4                \ If bit 7 of KY4 is set then the roll right joystick
 BPL P%+4               \ axis is being "pressed", so set A = 1
 LDA #1

                        \ By this point A is:
                        \
                        \   * 1 if the joystick is moving right
                        \
                        \   * -1 if the joystick is moving left
                        \
                        \   * 0 if neither are being pressed

 BIT KY7                \ If bit 7 of KY7 is set then the joystick fire button
 BPL P%+4               \ is being pressed, so shift A to the left by two places
 ASL A                  \ so it is now 4, -4 or 0
 ASL A

 TAX                    \ Store the result in X, so X contains the joystick
                        \ x-direction as a signed and scaled number

 LDA KY5                \ Set A to the status of the pull up joystick axis in
                        \ KY5, so A is 0 if it not being "pressed" or &FF if it
                        \ is (where &FF is -1 as a signed integer)

 BIT KY6                \ If bit 7 of KY4 is set then the pitch down joystick
 BPL P%+4               \ axis is being "pressed", so set A = 1
 LDA #1

                        \ By this point A is:
                        \
                        \   * 1 if the joystick is moving up
                        \
                        \   * -1 if the joystick is moving down
                        \
                        \   * 0 if neither are being pressed

 BIT KY7                \ If bit 7 of KY7 is set then the joystick fire button
 BPL P%+4               \ is being pressed, so shift A to the left by two places
 ASL A                  \ so it is now 4, -4 or 0
 ASL A

 TAY                    \ Store the result in Y, so Y contains the joystick
                        \ y-direction as a signed and scaled number

 LDA #0                 \ Zero the pitch, roll and fire keys in the key logger
 STA KY3                \ so they don't get processed again in this iteration of
 STA KY4                \ the main loop
 STA KY5
 STA KY6
 STA KY7

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger,
                        \ so the routine returns with the key pressed in A

 RTS                    \ Return from the subroutine

.TJ1

 LDA KLO+&3E            \ If the key logger entry for cursor left/right in
 BEQ noxmove            \ KLO+&3E is zero, then the left/right cursor key is not
                        \ being pressed, so jump to noxmove with A = 0

 LDA #1                 \ Set A = 1 to indicate movement in the x-direction

 ORA KLO+&31            \ If either left SHIFT (KLO+&31) or right SHIFT (KLO+&C)
 ORA KLO+&C             \ are being pressed, then their key logger entries will
                        \ be &FF, so this sets A to &FF (i.e. -1) if a SHIFT key
                        \ is being pressed

.noxmove

                        \ By this point A is:
                        \
                        \   * 1 if cursor left/right is being pressed
                        \
                        \   * -1 if SHIFT-cursor left/right is being pressed
                        \
                        \   * 0 if neither are being pressed

 BIT KLO+&3F            \ If bit 7 of KLO+&3F is set then the RETURN button is
 BPL P%+4               \ being pressed, so shift A to the left by two places
 ASL A                  \ so it is now 4, -4 or 0
 ASL A

 TAX                    \ Store the result in X, so X contains the cursor key
                        \ x-direction as a signed and scaled number

 LDA KLO+&39            \ If the key logger entry for cursor up/down in KLO+&39
 BEQ noymove            \ is zero, then the up/down cursor key is not being
                        \ pressed, so jump to noymove with A = 0

 LDA #1                 \ Set A = 1 to indicate movement in the y-direction

 ORA KLO+&31            \ If either left SHIFT (KLO+&31) or right SHIFT (KLO+&C)
 ORA KLO+&C             \ are being pressed, then their key logger entries will
                        \ be &FF, so this sets A to &FF (i.e. -1) if a SHIFT key
                        \ is being pressed

 EOR #%11111110         \ Flip the sign of A using a simple two's complement,
                        \ which works because A is either 1 or -1

.noymove

                        \ By this point A is:
                        \
                        \   * -1 if cursor up/down is being pressed
                        \
                        \   * 1 if SHIFT-cursor up/down is being pressed
                        \
                        \   * 0 if neither are being pressed

 BIT KLO+&3F            \ If bit 7 of KLO+&3F is set then the RETURN button is
 BPL P%+4               \ being pressed, so shift A to the left by two places
 ASL A                  \ so it is now 4, -4 or 0
 ASL A

 TAY                    \ Store the result in Y, so Y contains the cursor key
                        \ y-direction as a signed and scaled number

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger,
                        \ so the routine returns with the key pressed in A

 RTS                    \ Return from the subroutine
