\ ******************************************************************************
\
\       Name: PARAMS2
\       Type: Variable
\   Category: Copy protection
\    Summary: OSWORD parameter block for accessing a specific track on the disc
\             (not used in this version as disc protection is disabled)
\
\ ******************************************************************************

.PARAMS2

 EQUB &FF               \ 0 = Drive = &FF (previously used drive and density)
 EQUD &FFFFFFFF         \ 1 = Data address (not required)
 EQUB 1                 \ 5 = Number of parameters = 1
 EQUB &69               \ 6 = Command = &69 (seek track)
 EQUB 2                 \ 7 = Parameter = 2 (track number)
 EQUB 0                 \ 8 = The result of the OSWORD call is returned here

