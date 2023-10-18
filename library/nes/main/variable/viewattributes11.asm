\ ******************************************************************************
\
\       Name: viewAttributes11
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 11
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   0F 0F 0F 4F 5F 5F 5F 5F
\   33 00 00 55 55 55 55 55
\   33 00 40 54 55 99 AA AA
\   33 00 04 45 55 99 AA AA
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes11

 EQUB &23, &0F, &4F, &24, &5F, &21, &33, &02
 EQUB &25, &55, &21, &33, &00, &40, &54, &55
 EQUB &99, &22, &AA, &21, &33, &00, &21, &04
 EQUB &45, &55, &99, &22, &AA, &1F, &19, &28
 EQUB &0F, &3F

