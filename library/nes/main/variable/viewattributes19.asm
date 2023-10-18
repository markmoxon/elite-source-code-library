\ ******************************************************************************
\
\       Name: viewAttributes19
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 19
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   AF 5F 5F 5F 5F 5F 5F 5F
\   FB FA F5 F5 F5 F5 F5 F5
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes19

 EQUB &AF, &27, &5F, &FB, &FA, &26, &F5, &1F
 EQUB &1F, &1A, &28, &0F, &3F

