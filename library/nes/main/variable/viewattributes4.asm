\ ******************************************************************************
\
\       Name: viewAttributes4
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 4
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   3F 0F 0F 0F 0F 0F 0F 0F
\   33 00 00 00 00 00 00 00
\   73 50 50 50 50 50 50 50
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   F7 FD FF FF FF FF FE F5
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes4

 EQUB &31, &3F, &27, &0F, &21, &33, &07, &73
 EQUB &27, &50, &77, &27, &55, &77, &27, &55
 EQUB &77, &27, &55, &F7, &FD, &14, &FE, &F5
 EQUB &28, &0F, &3F

