\ ******************************************************************************
\
\       Name: viewAttributes10
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 10
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   0F 0F 0F 5F 5F 5F 5F 5F
\   33 00 04 45 55 55 55 55
\   33 00 00 54 55 99 AA AA
\   33 00 04 55 55 99 AA AA
\   F7 F5 F5 F5 F5 F5 F5 F5
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes10

 EQUB &23, &0F, &25, &5F, &21, &33, &00, &21
 EQUB &04, &45, &24, &55, &21, &33, &02, &54
 EQUB &55, &99, &22, &AA, &21, &33, &00, &21
 EQUB &04, &22, &55, &99, &22, &AA, &F7, &27
 EQUB &F5, &1F, &11, &28, &0F, &3F

