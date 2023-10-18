\ ******************************************************************************
\
\       Name: viewAttributes5
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 5
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   3F 0F 0F 0F 0F 0F 0F 0F
\   33 00 00 00 00 00 00 00
\   33 00 00 00 00 00 00 00
\   33 00 00 00 00 00 00 00
\   33 00 00 00 00 00 00 00
\   33 00 00 00 00 00 00 00
\   33 00 00 00 00 00 00 00
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes5

 EQUB &31, &3F, &27, &0F, &21, &33, &07, &21
 EQUB &33, &07, &21, &33, &07, &21, &33, &07
 EQUB &21, &33, &07, &21, &33, &07, &28, &0F
 EQUB &3F

