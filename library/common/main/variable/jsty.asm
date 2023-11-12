.JSTY

 SKIP 1                 \ Our current pitch rate
                        \
                        \ This value is shown in the dashboard's DC indicator,
                        \ and determines the rate at which we are pitching
                        \
                        \ The value ranges from 1 to 255 with 128 as the centre
                        \ point, so 1 means pitch is decreasing at the maximum
                        \ rate, 128 means pitch is not changing, and 255 means
                        \ pitch is increasing at the maximum rate
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \
                        \ This value is updated by "S" and "X" key presses, or
                        \ if joysticks are enabled, from the joystick. If
                        \ keyboard damping is enabled (which it is by default),
                        \ the value is slowly moved towards the centre value of
                        \ 128 (no pitch) if there are no key presses or joystick
                        \ movement
ELIF _ELECTRON_VERSION
                        \
                        \ This value is updated by "S" and "X" key presses. If
                        \ keyboard damping is enabled (which it is by default),
                        \ the value is slowly moved towards the centre value of
                        \ 128 (no pitch) if there are no key presses
ENDIF

