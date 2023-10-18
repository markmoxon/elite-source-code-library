\ ******************************************************************************
\
\       Name: viewAttributes14
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 14
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   AF AF AF AF AF 5F 5F 5F
\   BB AA 6A 5A 5A 5A 55 55
\   BB AA AA 65 55 55 00 00
\   FB FA FA FA FA FF 00 00
\   FF FF FF FF FF FF F0 F0
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes14

 EQUB &25, &AF, &23, &5F, &BB, &AA, &6A, &23
 EQUB &5A, &22, &55, &BB, &22, &AA, &65, &22
 EQUB &55, &02, &FB, &24, &FA, &FF, &02, &16
 EQUB &22, &F0, &1F, &11, &28, &0F, &3F

