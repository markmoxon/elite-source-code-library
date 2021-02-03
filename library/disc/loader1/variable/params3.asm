\ ******************************************************************************
\
\       Name: PARAMS3
\       Type: Variable
\   Category: Copy protection
\    Summary: OSWORD parameter block for loading the ELITE3 loader file (not
\             used in this version as disc protection is disabled)
\
\ ******************************************************************************

.PARAMS3
 
 EQUB &FF               \ 0 = Drive = &FF (previously used drive and density)
 EQUD &FFFF5700         \ 1 = Data address (&FFFF5700)
 EQUB 3                 \ 5 = Number of parameters = 3
 EQUB &53               \ 6 = Command = &53 (read data)
 EQUB 38                \ 7 = Track = 38
 EQUB 246               \ 8 = Sector = 246
 EQUB %00101001         \ 9 = Load 9 sectors of 256 bytes
 EQUB 0                 \ 10 = The result of the OSWORD call is returned here

