\ ******************************************************************************
\
\       Name: viewAttributes9
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 9
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   5F 5F 5F 5F 5F 5F 5F 5F
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   BB AA AA AA AA AA AA AA
\   FB FA FA FA FA FA FA FA
\   FF FF FF FF FF FF FF FF
\
\ ******************************************************************************

.viewAttributes9

 EQUB &28, &5F, &77, &27, &55, &77, &27, &55
 EQUB &77, &27, &55, &77, &27, &55, &BB, &27
 EQUB &AA, &FB, &27, &FA, &18, &3F

