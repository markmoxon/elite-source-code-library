\ ******************************************************************************
\
\       Name: TRIBMA
\       Type: Variable
\   Category: Missions
\    Summary: A table for converting the number of Trumbles in the hold into a
\             sprite-enable flag to use with VIC register &15
\
\ ******************************************************************************

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\.TRIBMA                \ These instructions are commented out in the original
\                       \ source
\EQUB 0
\EQUB 4
\EQUB &C
\EQUB &1C
\EQUB &3C
\EQUB &7C
\EQUB &FC
\EQUB &FC

ELIF _C64_VERSION

.TRIBMA

 EQUB %00000000         \ Disable sprites 2 to 7

 EQUB %00000100         \ Enable sprite 2

 EQUB %00001100         \ Enable sprites 2 to 3

 EQUB %00011100         \ Enable sprites 2 to 4

 EQUB %00111100         \ Enable sprites 2 to 5

 EQUB %01111100         \ Enable sprites 2 to 6

 EQUB %11111100         \ Enable sprites 2 to 7

 EQUB %11111100         \ Enable sprites 2 to 7

ENDIF

