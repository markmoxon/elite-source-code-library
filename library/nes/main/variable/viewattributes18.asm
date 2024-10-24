\ ******************************************************************************
\
\       Name: viewAttributes18
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Packed view attribute data for attribute set 18
\
\ ------------------------------------------------------------------------------
\
\ When unpacked, the PPU attributes for this view's screen are as follows:
\
\   FF FF FF FF FF FF FF FF
\   73 50 50 A0 A0 60 50 50
\   77 00 99 AA AA 66 55 55
\   73 50 50 AA AA 66 55 55
\   77 55 99 AA AA 66 55 55
\   37 05 09 8A AA A6 A5 A5
\   F3 F0 F0 F8 FA FA FA FF
\   FF FF FF FF FF FF FF FF
\
\ ******************************************************************************

.viewAttributes18

 EQUB &18, &73, &22, &50, &22, &A0, &60, &22
 EQUB &50, &77, &00, &99, &22, &AA, &66, &22
 EQUB &55, &73, &22, &50, &22, &AA, &66, &22
 EQUB &55, &77, &55, &99, &22, &AA, &66, &22
 EQUB &55, &33, &37, &05, &09, &8A, &AA, &A6
 EQUB &22, &A5, &F3, &22, &F0, &F8, &23, &FA
 EQUB &19, &3F

