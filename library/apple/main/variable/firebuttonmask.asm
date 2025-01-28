IF _IB_DISK OR _4AM_CRACK

.fireButtonMask

 EQUB %00001011         \ This value is applied to the joystick fire button soft
                        \ switches in the TITLE routine, where it disables the
                        \ ability to configure joysticks by pressing a fire
                        \ button
                        \
                        \ There is some code in the game loader that changes
                        \ this value, but that code is never called so this
                        \ value is never changed
                        \
                        \ This means the joystick fire button does not select
                        \ joysticks from the title screen - it's all a bit odd

ENDIF

