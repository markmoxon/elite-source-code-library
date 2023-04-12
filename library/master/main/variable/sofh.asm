\ ******************************************************************************
\
\       Name: SOFH
\       Type: Variable
\   Category: Sound
\    Summary: Sound chip data mask for choosing a tone channel in the range 0-2
\
\ ******************************************************************************

.SOFH

 EQUB %11000000         \ Mask for a latch byte for channel 2
 EQUB %10100000         \ Mask for a latch byte for channel 1
 EQUB %10000000         \ Mask for a latch byte for channel 0

