\ ******************************************************************************
\
\       Name: PARAMS1
\       Type: Variable
\   Category: Copy protection
\    Summary: OSWORD parameter block for accessing a specific track on the disc
\             (not used in this version as disc protection is disabled)
\
\ ******************************************************************************

.PARAMS1

 EQUB &FF               \ 0 = Drive = &FF (previously used drive and density)
 EQUD &FFFFFFFF         \ 1 = Data address (not required)
 EQUB 2                 \ 5 = Number of parameters = 2
 EQUB &7A               \ 6 = Command = &7A (write special register)
 EQUB &12               \ 7 = Parameter = &12 (register = track number)
 EQUB 38                \ 8 = Parameter = &26 (track number)
 EQUB &00               \ 9 = The result of the OSWORD call is returned here

