\ ******************************************************************************
\
\       Name: viewAttributes6
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 6
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   AF AF AF AF AF AF AF AF
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   77 55 55 55 55 55 55 55
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes6

 EQUB &28, &AF, &77, &27, &55, &77, &27, &55
 EQUB &77, &27, &55, &77, &27, &55, &77, &27
 EQUB &55, &18, &28, &0F, &3F

