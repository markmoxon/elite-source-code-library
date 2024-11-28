\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Wait for the vertical sync
\
\ ------------------------------------------------------------------------------
\
\ Wait for vertical sync to occur on the video system - in other words, wait
\ for the screen to start its refresh cycle, which it does 50 times a second
\ (50Hz) on PAL systems, or 60 times a second (60Hz) on NTSC systems.
\
\ We do this by monitoring the value of RASTCT, which is updated by the
\ interrupt routine at COMIRQ1 as it draws the two different parts of the screen
\ (the upper part containing the space view, and the lower part containing the
\ dashboard).
\
\ ******************************************************************************

.WSCAN

 PHA                    \ Store A on the stack so we can preserve it

.WSC1

 LDA RASTCT             \ Wait until RASTCT is non-zero, which indicates that
 BEQ WSC1               \ the VIC-II is now drawing the dashboard

.WSC2

 LDA RASTCT             \ Wait until RASTCT is zero, which indicates that the
 BNE WSC2               \ VIC-II is now drawing the top line of the visible
                        \ screen

 PLA                    \ Restore A from the stack so it is unchanged

 RTS                    \ Return from the subroutine

