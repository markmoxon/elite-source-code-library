.JSTX

 SKIP 1                 \ Our current roll rate
                        \
                        \ This value is shown in the dashboard's RL indicator,
                        \ and determines the rate at which we are rolling
                        \
                        \ The value ranges from from 1 to 255 with 128 as the
                        \ centre point, so 1 means roll is decreasing at the
                        \ maximum rate, 128 means roll is not changing, and
                        \ 255 means roll is increasing at the maximum rate
                        \
                        \ This value is updated by "<" and ">" key presses, or
                        \ if joysticks are enabled, from the joystick. If
                        \ keyboard damping is enabled (which it is by default),
                        \ the value is slowly moved towards the centre value of
                        \ 128 (no roll) if there are no key presses or joystick
                        \ movement

.JSTY

 SKIP 1                 \ Our current pitch rate
                        \
                        \ This value is shown in the dashboard's DC indicator,
                        \ and determines the rate at which we are pitching
                        \
                        \ The value ranges from from 1 to 255 with 128 as the
                        \ centre point, so 1 means pitch is decreasing at the
                        \ maximum rate, 128 means pitch is not changing, and
                        \ 255 means pitch is increasing at the maximum rate
                        \
                        \ This value is updated by "S" and "X" key presses, or
                        \ if joysticks are enabled, from the joystick. If
                        \ keyboard damping is enabled (which it is by default),
                        \ the value is slowly moved towards the centre value of
                        \ 128 (no pitch) if there are no key presses or joystick
                        \ movement
