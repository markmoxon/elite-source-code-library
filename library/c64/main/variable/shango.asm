\ ******************************************************************************
\
\       Name: shango
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The raster lines that fire the raster interrupt, so it fires at
\             the top of the screen (51) and the top of the dashboard (51 + 143)
\  Deep dive: The split-screen mode in Commodore 64 Elite
\
\ ******************************************************************************

.shango

 EQUB 51 + 143          \ The raster line at the top of the dashboard

 EQUB 51                \ The raster line at the top of the visible screen

