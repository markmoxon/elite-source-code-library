\ ******************************************************************************
\
\       Name: MDIALS
\       Type: Variable
\   Category: Dashboard
\    Summary: The missile indicator bitmaps for the monochrome dashboard
\
\ ******************************************************************************

.MDIALS

 EQUB %00000000         \ No missile (black)
 EQUB %00000000
 EQUB %00000000
 EQUB %00000000
 EQUB %00000000

 EQUB %11111100         \ Disarmed (white square)
 EQUB %11111100         \
 EQUB %11111100         \ Shares the first row from the next indicator
 EQUB %11111100
\EQUB %11111100

 EQUB %11111100         \ Armed (black box in white square)
 EQUB %10000100         \
 EQUB %10110100         \ Shares the first row from the next indicator
 EQUB %10000100
\EQUB %11111100

 EQUB %11111100         \ Armed and locked (black "T" in white square)
 EQUB %11000100
 EQUB %11101100
 EQUB %11101100
 EQUB %11111100

