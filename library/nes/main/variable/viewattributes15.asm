\ ******************************************************************************
\
\       Name: viewAttributes15
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 15
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   AF AF AF 6F 5F 5F 5F 5F
\   BB AA AA AA 5A 56 55 55
\   BB AA 6A 56 55 55 05 05
\   FB FA FA FA FA FF 00 00
\   FF FF FF FF FF FF 00 00
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\
\ ******************************************************************************

.viewAttributes15

 EQUB &23, &AF, &6F, &24, &5F, &BB, &23, &AA
 EQUB &5A, &56, &22, &55, &BB, &AA, &6A, &56
 EQUB &22, &55, &22, &05, &FB, &24, &FA, &FF
 EQUB &02, &16, &02, &1F, &19, &3F

