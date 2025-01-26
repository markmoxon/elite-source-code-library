IF _IB_DISK OR _4AM_CRACK

.fireButtonMask

 EQUB %00001011         \ This value is applied to the joystick fire button soft
                        \ switches in the TITLE routine, where it disables the
                        \ ability to configure joysticks by pressing a fire
                        \ button
                        \
                        \ This value is never changed, so this is a rather odd
                        \ bit of code

ENDIF

