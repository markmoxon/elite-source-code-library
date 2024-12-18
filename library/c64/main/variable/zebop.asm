\ ******************************************************************************
\
\       Name: zebop
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The value for VIC register &18 to set the screen RAM address for a
\             raster count of 0 in the interrupt routine (i.e. the space view)
\  Deep dive: The split-screen mode in Commodore 64 Elite
\
\ ******************************************************************************

.zebop

 EQUB &81               \ Determines the address of screen RAM to use for colour
                        \ data in the upper portion of the screen (this sets the
                        \ address of screen RAM to &6000 and does not change)

