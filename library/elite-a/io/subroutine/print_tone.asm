\ ******************************************************************************
\
\       Name: print_tone
\       Type: Variable
\   Category: Text
\    Summary: Lookup table for converting mode 5 colour pixel rows to monochrome
\             pixel pairs
\
\ ******************************************************************************

.print_tone

 EQUB %00000011         \ Bit 0 of the mode 5 pixel row (pixel 0) is set
 EQUB %00001100         \ Bit 1 of the mode 5 pixel row (pixel 1) is set
 EQUB %00110000         \ Bit 2 of the mode 5 pixel row (pixel 2) is set
 EQUB %11000000         \ Bit 3 of the mode 5 pixel row (pixel 3) is set

 EQUB %00000011         \ Bit 4 of the mode 5 pixel row (pixel 0) is set
 EQUB %00001100         \ Bit 5 of the mode 5 pixel row (pixel 1) is set
 EQUB %00110000         \ Bit 6 of the mode 5 pixel row (pixel 2) is set
 EQUB %11000000         \ Bit 7 of the mode 5 pixel row (pixel 3) is set

