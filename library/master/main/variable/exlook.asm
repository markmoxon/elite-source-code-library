\ ******************************************************************************
\
\       Name: exlook
\       Type: Variable
\   Category: Drawing ships
\    Summary: A table to shift X left by one place when X is 0 or 1
\
\ ******************************************************************************

.exlook

IF _MASTER_VERSION OR _APPLE_VERSION

 EQUB %00               \ Looking up exlook,X will return X shifted left by one
 EQUB %10               \ place, where X is 0 or 1
                        \
                        \ This is not used in this version of Elite; it is left
                        \ over from the Commodore 64 version of Elite

ELIF _C64_VERSION

 EQUB %00               \ Looking up exlook,X will return X shifted left by one
 EQUB %10               \ place, where X is 0 or 1
                        \
                        \ This is used in the PTCLS2 routine to update the top
                        \ bit of the 9-bit x-coordinate for the explosion sprite

ENDIF

