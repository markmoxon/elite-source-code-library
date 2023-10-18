\ ******************************************************************************
\
\       Name: viewAttributes23
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 23
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
\   F3 F0 F0 F0 F0 F0 F0 F0
\   FB 5A 5A 5A 5A 5A 5A 5A
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes23

 EQUB &31, &3F, &27, &0F, &21, &33, &07, &21
 EQUB &33, &07, &21, &33, &07, &21, &33, &07
 EQUB &F3, &27, &F0, &FB, &27, &5A, &28, &0F
 EQUB &3F

