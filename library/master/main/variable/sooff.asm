\ ******************************************************************************
\
\       Name: SOOFF
\       Type: Variable
\   Category: Sound
\    Summary: Sound chip data to turn the volume down on all channels and to act
\             as a mask for choosing a tone channel in the range 0-2
\
\ ******************************************************************************

.SOOFF

 EQUB %11111111         \            %1         %11               %1     %1111
                        \ Latch byte (1), channel 3, volume latch (1), data 15

 EQUB %10111111         \            %1         %01               %1     %1111
                        \ Latch byte (1), channel 1, volume latch (1), data 15

 EQUB %10011111         \            %1         %00               %1     %1111
                        \ Latch byte (1), channel 0, volume latch (1), data 15

 EQUB %11011111         \            %1         %10               %1     %1111
                        \ Latch byte (1), channel 2, volume latch (1), data 15

 EQUB %11101111         \            %1         %11             %0       %1111
                        \ Latch byte (1), channel 3,   tone latch (0), data 15

