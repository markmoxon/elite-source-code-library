\ ******************************************************************************
\
\       Name: viewAttributes13
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 13
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   AF AF AF 5F 5F 5F 5F 5F
\   BB AA AA 5A 5A 55 55 55
\   BB AA A5 A5 55 55 00 00
\   FB FA FA FA FA FF 00 00
\   FF FF FF FF FF FF F0 F0
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\
\ ******************************************************************************

.viewAttributes13

 EQUB &23, &AF, &25, &5F, &BB, &22, &AA, &22
 EQUB &5A, &23, &55, &BB, &AA, &22, &A5, &22
 EQUB &55, &02, &FB, &24, &FA, &FF, &02, &16
 EQUB &22, &F0, &1F, &19, &3F

