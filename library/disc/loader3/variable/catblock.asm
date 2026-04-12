\ ******************************************************************************
\
\       Name: CATBLOCK
\       Type: Subroutine
\   Category: Save and load
\    Summary: OSWORD block for loading  disc sectors 0 and 1
\  Deep dive: Swapping between the docked and flight code
\
\ ******************************************************************************

.CATBLOCK

 EQUB 0                 \ 0 = Drive = 0
 EQUD &00000F00         \ 1 = Data address = &0F00
 EQUB 3                 \ 5 = Number of parameters = 3
 EQUB &53               \ 6 = Command = &53 (read data)
 EQUB 0                 \ 7 = Track = 0
 EQUB 1                 \ 8 = Sector = 1
 EQUB %00100001         \ 9 = Load 1 sector of 256 bytes
 EQUB 0                 \ 10 = The result of the OSWORD call is returned here

