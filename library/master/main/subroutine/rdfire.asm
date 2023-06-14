\ ******************************************************************************
\
\       Name: RDFIRE
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Read the fire button on either the analogue or digital joystick
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if the joystick fire button is being pressed, clear
\                       if it isn't
\
\ ******************************************************************************

IF _COMPACT

.RDFIRE

 LDA MOS                \ If MOS = 0 then this is a Master Compact, so jump to
 BEQ DFIRE              \ DFIRE to read the digital joystick rather than the
                        \ analogue joystick, as the Compact doesn't have the
                        \ latter

 CLC                    \ Clear the C flag

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

 BNE P%+3               \ If the joystick fire button is not being pressed,
                        \ jump skip the following to leave the C flag clear

 SEC                    \ Set the C flag to indicate the joystick fire button
                        \ is being pressed

 RTS                    \ Return from the subroutine

.DFIRE

 LDA VIA+&60            \ Read the 6522 User VIA, which is where the Master
                        \ Compact's digital joystick is mapped to. The pins go
                        \ low when the joystick connection is made, and PB0 is
                        \ connected to the joystick fire button, so when PB0
                        \ is low, fire is being pressed

 EOR #%00000001         \ Flip PB0 so that it's 1 if fire is being pressed and
                        \ 0 if it isn't

 LSR A                  \ Shift PB0 into the C flag, so it's set if the fire
                        \ button is being pressed

 RTS                    \ Return from the subroutine

ENDIF

