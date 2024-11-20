.KY7

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

 SKIP 1                 \ "A" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes
                        \
                        \ This is also set when the joystick fire button has
                        \ been pressed

ELIF _ELECTRON_VERSION

 SKIP 1                 \ "A" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "7"               \ "A" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes
                        \
                        \ This is also set when the joystick fire button has
                        \ been pressed

ELIF _NES_VERSION

 SKIP 1                 \ The A button is being pressed on controller 1
                        \
                        \   * 0 = no
                        \
                        \   * Bit 7 set = yes

ENDIF