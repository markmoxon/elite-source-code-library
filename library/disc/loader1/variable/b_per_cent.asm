\ ******************************************************************************
\
\       Name: B%
\       Type: Variable
\   Category: Drawing the screen
\    Summary: VDU commands for switching to a mode 7 screen
\
\ ******************************************************************************

.B%

 EQUB 22, 7             \ Switch to screen mode 7

 EQUB 23, 0, 10, 32     \ Set 6845 register R10 = %00100000 = 32
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "cursor start" register, and bits 5 and 6
                        \ can be used to control the appearance of the cursor:
                        \
                        \   * Bit 5 = 0 for cursor on  (for steady cursors)
                        \               for fast blink (for blinking cursors)
                        \           = 1 for cursor off (for steady cursors)
                        \               for slow blink (for blinking cursors)
                        \
                        \   * Bit 6 = 0 for a steady cursor
                        \             1 for a blinking cursor
                        \
                        \ We can therefore turn off the cursor completely by
                        \ setting it to a steady cursor (bit 6 is clear) that
                        \ is turned off (bit 5 is set)

