\ ******************************************************************************
\
\       Name: viewAttributes22
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 22
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
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes22

 EQUB &31, &3F, &27, &0F, &21, &33, &07, &21
 EQUB &33, &07, &21, &33, &07, &21, &33, &07
 EQUB &21, &33, &07, &18, &28, &0F, &3F

