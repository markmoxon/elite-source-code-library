\ ******************************************************************************
\
\       Name: viewAttributes20
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 20
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   AF AF AF 5F 5F 5F 5F 5F
\   FB FA FA F5 F5 F5 F5 F5
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   FF FF FF FF FF FF FF FF
\   0F 0F 0F 0F 0F 0F 0F 0F
\
\ ******************************************************************************

.viewAttributes20

 EQUB &23, &AF, &25, &5F, &FB, &22, &FA, &25
 EQUB &F5, &1F, &1F, &1A, &28, &0F, &3F

