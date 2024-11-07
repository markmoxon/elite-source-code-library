\ ******************************************************************************
\
\       Name: KTRAN
\       Type: Variable
\   Category: Keyboard
IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\    Summary: An unused key logger buffer that's left over from the 6502 Second
\             Procsessor version of Elite
ELIF _6502SP_VERSION
\    Summary: The key logger buffer that gets updated by the OSWORD 240 command
\
\ ------------------------------------------------------------------------------
\
\ KTRAN is a buffer that is filled with key logger information by the KEYBOARD
\ routine in the I/O processor, which is run when the parasite sends an OSWORD
\ &F0 command to the I/O processor. The buffer contains details of keys being
\ pressed, with KTRAN being filled with bytes #2 to #14 from the KEYBOARD
\ routine (because KEYBOARD is called with OSSC pointing to buf, and buf is
\ equal to KTRAN - 2).
\
\ The key logger buffer is filled as follows:
\
\   KTRAN + 0           Internal key number of any non-primary flight control
\                       key that is being pressed
\
\   KTRAN + 1           "?" is being pressed (0 = no, &FF = yes)
\
\   KTRAN + 2           Space is being pressed (0 = no, &FF = yes)
\
\   KTRAN + 3           "<" is being pressed (0 = no, &FF = yes)
\
\   KTRAN + 4           ">" is being pressed (0 = no, &FF = yes)
\
\   KTRAN + 5           "X" is being pressed (0 = no, &FF = yes)
\
\   KTRAN + 6           "S" is being pressed (0 = no, &FF = yes)
\
\   KTRAN + 7           "A" is being pressed (0 = no, &FF = yes)
\
\   KTRAN + 8           Joystick X value (high byte)
\
\   KTRAN + 9           Joystick Y value (high byte)
\
\   KTRAN + 10          Bitstik rotation value (high byte)
\
\   KTRAN + 12          Joystick 1 fire button is being pressed (Bit 4 set = no,
\                       Bit 4 clear = yes)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   buf                 The two OSWORD size bytes for transmitting the key
\                       logger from the I/O processor to the parasite
ENDIF
\
\ ******************************************************************************

.buf

 EQUB 2                 \ Transmit 2 bytes as part of this command

 EQUB 15                \ Receive 15 bytes as part of this command

.KTRAN

 EQUS "1234567890"      \ A 17-byte buffer to hold the key logger data from the
 EQUS "1234567"         \ KEYBOARD routine in the I/O processor (note that only
                        \ 12 of these bytes are actually updated by the KEYBOARD
                        \ routine)

