.KY7

 SKIP 1                 \ "A" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \
                        \ This is also set when the joystick fire button has
                        \ been pressed
ENDIF

