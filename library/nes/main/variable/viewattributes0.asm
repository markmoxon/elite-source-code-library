\ ******************************************************************************
\
\       Name: viewAttributes0
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 0
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
\   FF BF AF AF AF AB AB AE
\   77 99 AA AA AA AA AA 5A
\   07 09 0A 0A 0A 0A 0A 0F
\
\ ******************************************************************************

.viewAttributes0

 EQUB &31, &3F, &27, &0F, &21, &33, &07, &21
 EQUB &33, &07, &21, &33, &07, &21, &33, &07
 EQUB &FF, &BF, &23, &AF, &22, &AB, &AE, &77
 EQUB &99, &25, &AA, &5A, &32, &07, &09, &25
 EQUB &0A, &21, &0F, &3F

