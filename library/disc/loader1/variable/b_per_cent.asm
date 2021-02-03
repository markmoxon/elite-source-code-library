\ ******************************************************************************
\
\       Name: B%
\       Type: Variable
\   Category: Screen mode
\    Summary: VDU commands for switching to a mode 7 screen
\
\ ******************************************************************************

.B%

 EQUB 22, 7             \ Switch to screen mode 7

 EQUB 23, 0, 10, 32     \ Set 6845 register R10 = 32
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "cursor start" register, which sets the
                        \ cursor start line at 0, so it turns the cursor off

