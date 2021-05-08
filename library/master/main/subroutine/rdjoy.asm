\ ******************************************************************************
\
\       Name: RDJOY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Read from either the analogue or digital joystick
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Clear if we just read from the analogue joystick, set if
\                       we just read from the digital joystick
\
\ ******************************************************************************

IF _COMPACT

.RDJOY

 LDA MOS                \ If MOS = 0 then this is a Master Compact, so jump to
 BEQ DIGITAL            \ DIGITAL to read the digital joystick rather then the
                        \ analogue joystick, as the Compact doesn't have the
                        \ latter

 CLC                    \ Clear the C flag to indicate that we are reading from
                        \ the analogue joystick

 LDA ADCH1              \ Fetch the high byte of the joystick X value

 EOR JSTE               \ The high byte A is now EOR'd with the value in
                        \ location JSTE, which contains &FF if both joystick
                        \ channels are reversed and 0 otherwise (so A now
                        \ contains the high byte but inverted, if that's what
                        \ the current settings say)

 ORA #1                 \ Ensure the value is at least 1

 STA JSTX               \ Store the resulting joystick X value in JSTX

 LDA ADCH2              \ Fetch the high byte of the joystick Y value

 EOR #&FF               \ This EOR is used in conjunction with the EOR JSTGY
                        \ below, as having a value of 0 in JSTGY means we have
                        \ to invert the joystick Y value, and this EOR does
                        \ that part

 EOR JSTE               \ The high byte A is now EOR'd with the value in
                        \ location JSTE, which contains &FF if both joystick
                        \ channels are reversed and 0 otherwise (so A now
                        \ contains the high byte but inverted, if that's what
                        \ the current settings say)

 EOR JSTGY              \ JSTGY will be 0 if the game is configured to reverse
                        \ the joystick Y channel, so this EOR along with the
                        \ EOR #&FF above does exactly that

 STA JSTY               \ Store the resulting joystick Y value in JSTY

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

 BNE P%+6               \ If the joystick fire button is not being pressed,
                        \ jump to DK4 to scan for other keys

 LDA #&FF               \ Update the key logger at KY7 to "press" the "A" (fire)
 STA KY7                \ button

 RTS                    \ Return from the subroutine

.DIGITAL

 LDX #&FF               \ Set X = &FF so we can use it to "press" keys in the
                        \ key logger

 LDA VIA+&60            \ Read the User 6522 VIA, which is where the Master
                        \ Compact's digital joystick is mapped to. The pins go
                        \ low when the joystick connection is made, so we need
                        \ to check whether any of the following are zero:
                        \
                        \   PB0 = fire
                        \   PB1 = left
                        \   PB2 = down
                        \   PB3 = up
                        \   PB4 = right

 LSR A                  \ If PB0 from the User VIA is set (fire button), skip
 BCS P%+4               \ the following

 STX KY7                \ Update the key logger at KY7 to "press" the "A" (fire)
                        \ button

 LSR A                  \ If PB1 from the User VIA is set (left), skip the
 BCS P%+4               \ following

 STX KY3                \ Update the key logger at KY3 to "press" the "<" (roll
                        \ left) button

 LSR A                  \ If PB2 from the User VIA is set (down), skip the
 BCS P%+4               \ following

 STX KY6                \ Update the key logger at KY6 to "press" the "S" (pitch
                        \ forward) button

 LSR A                  \ If PB3 from the User VIA is set (up), skip the
 BCS P%+4               \ following

 STX KY5                \ Update the key logger at KY5 to "press" the "X" (pitch
                        \ back) button

 LSR A                  \ If PB4 from the User VIA is set (right), skip the
 BCS P%+4               \ following

 STX KY4                \ Update the key logger at KY4 to "press" the ">" (roll
                        \ right) button

 LDA JSTE               \ JSTE contains &FF if both joystick channels are
 BEQ DIG1               \ reversed and 0 otherwise, so skip to DIG1 if the
                        \ joystick channels are not reversed

 LDA KY3                \ Both the joystick channels are reversed, so swap the
 LDX KY4                \ values of KY3 and KY4 (to swap the roll)
 STX KY3
 STA KY4

.DIG1

 LDA JSTE               \ Set A to &FF if both joystick channels are reversed
                        \ and 0 otherwise

 EOR JSTGY              \ JSTGY will be 0 if the game is configured to reverse
                        \ the joystick Y channel, &FF otherwise, so A will be
                        \ 0 if one of these is true:
                        \
                        \  * Both channels are normal and Y is reversed
                        \  * Both channels are reversed and Y is not
                        \
                        \ i.e. it will be 0 if the Y channel is configured to be
                        \ reversed

 BEQ DIG2               \ If the result in A is 0, skip the following

                        \ If we get here, then the configuration settings are
                        \ not set to reverse the Y channel, so we now swap KY5
                        \ and KY6 around. This is because the right key (">")
                        \ actually rotates the ship to the left, and vice versa,
                        \ so the above mapping of left digital joystick to left
                        \ key is the wrong way around, so for the default
                        \ settings of the joystick reversal, we want to swap the
                        \ left and right key presses
                        \
                        \ This is seriously confusing...

 LDA KY5                \ The Y channel should be reversed, so swap the values
 LDX KY6                \ of KY5 and KY6 (to swap the pitch)
 STX KY5
 STA KY6

.DIG2

 SEC                    \ Set the C flag to indicate that we just read the
                        \ digital joystick

 RTS                    \ Return from the subroutine

ENDIF

