\ ******************************************************************************
\
\       Name: viewAttributes21
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 21
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   AF AF 6F 5F 5F 5F 5F 5F
\   FB FA F6 F5 F5 F5 F5 F5
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes21

 EQUB &22, &AF, &6F, &25, &5F, &FB, &FA, &F6
 EQUB &25, &F5, &1F, &1F, &1A, &28, &0F, &3F

