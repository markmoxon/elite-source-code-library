\ ******************************************************************************
\
\       Name: scan_fire
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Check whether the joystick's fire button is being pressed and send
\             the result back to the parasite
\
\ ******************************************************************************

.scan_fire

 LDA #&51               \ Set 6522 User VIA output register ORB (SHEILA &60) to
 STA VIA+&60            \ the Delta 14b joystick button in the middle column
                        \ (upper nibble &5) and top row (lower nibble &1), which
                        \ corresponds to the fire button

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

