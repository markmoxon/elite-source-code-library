\ ******************************************************************************
\
\       Name: viewAttributes3
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 3
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
\   FF FF FF FF FF BF BF EF
\   0F 0F 0F 0F 0F 0B 0B 0E
\
\ ******************************************************************************

.viewAttributes3

 EQUB &18, &77, &27, &55, &77, &27, &55, &77
 EQUB &27, &55, &77, &27, &55, &77, &27, &55
 EQUB &15, &22, &BF, &EF, &25, &0F, &22, &0B
 EQUB &21, &0E, &3F

