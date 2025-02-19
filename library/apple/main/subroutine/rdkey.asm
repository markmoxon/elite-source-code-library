\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for key presses and the joystick, and update the
\             key logger
\  Deep dive: Working with the Apple II keyboard
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
\                         * Set if a key is being pressed
\
\ ******************************************************************************

.RDKEY

 TYA                    \ Store Y on the stack so we can retrieve it later
 PHA

 JSR ZEKTRAN            \ Call ZEKTRAN to clear the key logger

.scanmatrix

 CLC                    \ Clear the C flag, so we can return this if no keys are
                        \ being pressed

 LDA &C000              \ Set A to the value of the KBD soft switch, which
                        \ contains the keyboard data and strobe

 BPL nokeys2            \ If bit 7 of the KBD soft switch is clear then there is
                        \ no key press data to be read, so jump to nokeys2 to
                        \ move on to the joystick

 BIT &C010              \ Clear the keyboard strobe by reading the KBDSTRB soft
                        \ switch, which tells the system to drop any current key
                        \ press data and start waiting for the next key press

 AND #%01111111         \ Extract the key press data from the value of the KBD
                        \ soft switch, which is in bits 0 to 6, so A contains
                        \ the ASCII code of the key press

 STA thiskey            \ Store the result in thiskey, so it contains the ASCII
                        \ code of the last key pressed

 LDX #16                \ We now want to update the key logger, so set a counter
                        \ in X to work through the 16 entries in the keyboard
                        \ table at KYTB, to see whether this is a flight key (as
                        \ we only record flight key presses in the key logger)

.RDL1

 CMP KYTB,X             \ If the key press in A does not match the X-th entry in
 BNE RD1                \ the KYTB table, jump to RD1

 DEC KEYLOOK,X          \ The key press matches the X-th entry in the KYTB
                        \ table, so decrement the corresponding entry in the key
                        \ logger from 0 to &FF to register this flight key press

.RD1

 DEX                    \ Decrement the counter in X

 BNE RDL1               \ Loop back until we have checked the key press against
                        \ the whole KYTB table

 SEC                    \ Set the C flag to return from the subroutine, to
                        \ indicate that a key has been pressed

.nokeys2

IF _IB_DISK

 LDA JSTK               \ If bit 7 of JSTK is clear, then we are configured to
 BPL nofast+2           \ use the keyboard rather than the joystick, so jump to
                        \ nojoyst to skip the joystick scan
                        \
                        \ Note that the destination for this instruction is
                        \ modified by S% to point to nofast+2
                        \
                        \ In the game disk on Ian Ball's site, this modification
                        \ is already baked into the code, as the game was
                        \ cracked by extracting it from memory while running, by
                        \ which point this modification had already been applied

ELIF _SOURCE_DISK OR _4AM_CRACK

 LDA JSTK               \ If bit 7 of JSTK is clear, then we are configured to
 BPL nojoyst            \ use the keyboard rather than the joystick, so jump to
                        \ nojoyst to skip the joystick position scan and move on
                        \ to the joystick fire button scan
                        \
                        \ Note that the destination for this instruction is
                        \ modified by S% to point to nofast+2
                        \
                        \ This ensures that when we are configured to use the
                        \ keyboard rather than the joystick, we skip all the
                        \ joystick scanning code in RDKEY
                        \
                        \ If this modification is not applied, the original code
                        \ will still scan the joystick fire button, even if
                        \ joysticks are not configured, so this fix stops this
                        \ from happening

ENDIF

                        \ If we get here then joysticks are configured, so we
                        \ now read the joystick's position and fire button,
                        \ starting with the position in both axes

IF _IB_DISK OR _4AM_CRACK OR _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES

 LDX auto               \ If the docking computer is currently activated, jump
 BNE nojoyst            \ to nojoyst to skip the following, so we disable the
                        \ joystick while the docking computer is activated

\LDX #0                 \ This instruction is commented out in the original
                        \ source

ELIF _SOURCE_DISK_CODE_FILES

 LDX #0                 \ Set X = 0 so the call to RDS1 returns the x-axis
                        \ position of the joystick

ENDIF

 JSR RDS1               \ Call RDS1 with X = 0 to set A to the x-axis position
                        \ of the joystick

 EOR #&FF               \ Negate X and store it in JSTX
 STA JSTX

 INX                    \ Set X = 1 so the call to RDS1 returns the y-axis
                        \ position of the joystick

 JSR RDS1               \ Call RDS1 with X = 1 to set A to the y-axis position
                        \ of the joystick

 EOR JSTGY              \ JSTGY will be 0 if the game is configured to reverse
                        \ the joystick Y channel, so this EOR along with the
                        \ EOR #&FF above does exactly that

 STA JSTY               \ Store the resulting joystick Y value in JSTY

.nojoyst

                        \ We now read the joystick fire buttons, as follows:
                        \
                        \   * Button 1 on its own = fire lasers
                        \
                        \   * Button 2 on its own = increase speed
                        \
                        \   * Button 1 and button 2 = decrease speed

 LDA #&FF               \ Set A = &FF to use as the value to store in the key
                        \ logger if a valid fire button combination is being
                        \ pressed

 BIT &C061              \ If bit 7 of the soft switch at PB0 is clear, then
 BPL nofire             \ button 1 is not being pressed, so jump to nofire

                        \ If we get here then button 1 is being pressed

 BIT &C062              \ If bit 7 of the soft switch at PB1 is clear, then
 BPL noslow             \ button 2 is not being pressed, so jump to noslow

                        \ If we get here then both buttons are being pressed,
                        \ so we need to decrease speed by "pressing" the "?" key
                        \ in the key logger at KY1

 STA KY1                \ Set KY1 = &FF to indicate that the "slow down" button
                        \ is being pressed

 BMI nofast             \ Jump to nofast to move on to the next stage

.noslow

                        \ If we get here then button 1 is being pressed and
                        \ button 2 is not being pressed, so we need to fire the
                        \ lasers by "pressing" the "A" key in the key logger at
                        \ KY7

 STA KY7                \ Set KY7 = &FF to indicate that the fire button is
                        \ being pressed

                        \ When we fall into nofire, we will take the BPL to
                        \ nofast as button 2 is not being pressed

.nofire

 BIT &C062              \ If bit 7 of the soft switch at PB1 is clear, then
 BPL nofast             \ button 2 is not being pressed, so jump to noslow

                        \ If we get here then button 2 is being pressed on its
                        \ own, so we need to increase speed by "pressing" the
                        \ Space key in the key logger at KY2

 STA KY2                \ Set KY2 = &FF to indicate that the "speed up" button
                        \ is being pressed

.nofast

 LDA QQ11               \ If QQ11 = 0 then this is the space view, so jump to
 BEQ allkeys            \ allkeys to keep the status of the secondary flight
                        \ keys in the key logger

 LDA #0                 \ This is not the space view, so clear the key logger
 STA KY12               \ entries for the secondary flight controls
 STA KY13               \
 STA KY14               \ This prevents key presses from setting off weapons
 STA KY15               \ like missiles and energy bombs when we are perusing
 STA KY16               \ screens like the system charts while flying
 STA KY17
 STA KY18
 STA KY19
 STA KY20

.allkeys

 PLA                    \ Retrieve the value of Y we stored above so it is
 TAY                    \ unchanged by the subroutine

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger

 TAX                    \ Copy the key value into X

 RTS                    \ Return from the subroutine

