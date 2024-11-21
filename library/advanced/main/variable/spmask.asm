\ ******************************************************************************
\
\       Name: SPMASK
\       Type: Variable
\   Category: Missions
\    Summary: Masks for 
\
\ ******************************************************************************

.SPMASK

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

 EQUW &04FB             \ These bytes are unused and are left over from the
 EQUW &08F7             \ Commodore 64 version
 EQUW &10EF
 EQUW &20DF
 EQUW &40BF
 EQUW &807F

ELIF _C64_VERSION

 EQUB %11111011         \ Mask for clearing the VIC+&10 bit for sprite 2
                        \ (Trumble 0)

 EQUB %00000100         \ Mask for setting the VIC+&10 bit for sprite 2
                        \ (Trumble 0)

 EQUB %11110111         \ Mask for clearing the VIC+&10 bit for sprite 3
                        \ (Trumble 1)

 EQUB %00001000         \ Mask for setting the VIC+&10 bit for sprite 3
                        \ (Trumble 1)

 EQUB %11101111         \ Mask for clearing the VIC+&10 bit for sprite 4
                        \ (Trumble 2)

 EQUB %00010000         \ Mask for setting the VIC+&10 bit for sprite 4
                        \ (Trumble 2)

 EQUB %11011111         \ Mask for clearing the VIC+&10 bit for sprite 5
                        \ (Trumble 3)

 EQUB %00100000         \ Mask for setting the VIC+&10 bit for sprite 5
                        \ (Trumble 3)

 EQUB %10111111         \ Mask for clearing the VIC+&10 bit for sprite 6
                        \ (Trumble 4)

 EQUB %01000000         \ Mask for setting the VIC+&10 bit for sprite 6
                        \ (Trumble 4)

 EQUB %01111111         \ Mask for clearing the VIC+&10 bit for sprite 7
                        \ (Trumble 5)

 EQUB %10000000         \ Mask for setting the VIC+&10 bit for sprite 7
                        \ (Trumble 5)

ENDIF

