\ ******************************************************************************
\
\       Name: viewAttributes2
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 2
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   FF FF FF FF FF FF FF FF
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes2

 EQUB &18, &77, &27, &55, &77, &27, &55, &77
 EQUB &27, &55, &77, &27, &55, &77, &27, &55
 EQUB &18, &28, &0F, &3F

