\ ******************************************************************************
\
\       Name: viewAttributes12
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 12
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   0F 0F 0F 5F 5F 5F 5F 5F
\   33 00 04 45 55 55 55 55
\   33 00 50 50 55 99 AA AA
\   33 00 04 55 55 99 AA AA
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\
\ ******************************************************************************

.viewAttributes12

 EQUB &23, &0F, &25, &5F, &21, &33, &00, &21
 EQUB &04, &45, &24, &55, &21, &33, &00, &22
 EQUB &50, &55, &99, &22, &AA, &21, &33, &00
 EQUB &21, &04, &22, &55, &99, &22, &AA, &1F
 EQUB &1F, &12, &3F

