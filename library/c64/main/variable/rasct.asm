\ ******************************************************************************
\
\       Name: RASTCT
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The current raster count, which flips between 0 and 1 on each call
\             to the COMIRQ1 interrupt handler (0 = space view, 1 = dashboard)
\  Deep dive: The split-screen mode in Commodore 64 Elite
\
\ ******************************************************************************

.RASTCT

 EQUB 0

