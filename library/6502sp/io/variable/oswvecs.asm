\ ******************************************************************************
\
\       Name: OSWVECS
\       Type: Variable
\   Category: Text
\    Summary: The lookup table for OSWORD jump commands (240-255)
\
\ ------------------------------------------------------------------------------
\
\ On entry into these routines, OSSC(1 0) points to the parameter block passed
\ to the OSWORD call in (Y X). OSSC must not be changed by the routines, as it
\ is used by NWOSWD to preserve the values of X and Y through the revectored
\ OSWORD call. OSSC(1 0) can be copied into SC(1 0) to avoid changing it.
\
\ ******************************************************************************

.OSWVECS

 EQUW KEYBOARD          \            240 (&F0)     0 = Scan the keyboard
 EQUW PIXEL             \            241 (&F1)     1 = Draw a pixel
 EQUW MSBAR             \ #DOmsbar = 242 (&F2)     2 = Update missile indicators
 EQUW WSCAN             \ #wscn    = 243 (&F3)     3 = Wait for vertical sync
 EQUW SC48              \ #onescan = 244 (&F4)     4 = Update the 3D scanner
 EQUW DOT               \ #DOdot   = 245 (&F5)     5 = Draw a dot
 EQUW DODKS4            \ #DODKS4  = 246 (&F6)     6 = Scan for a specific key
 EQUW HLOIN             \            247 (&F7)     7 = Draw a horizontal line
 EQUW HANGER            \            248 (&F8)     8 = Display the hanger
 EQUW SOMEPROT          \            249 (&F9)     9 = Copy protection
 EQUW SAFE              \            250 (&FA)    10 = Do nothing
 EQUW SAFE              \            251 (&FB)    11 = Do nothing
 EQUW SAFE              \            252 (&FC)    12 = Do nothing
 EQUW SAFE              \            253 (&FD)    13 = Do nothing
 EQUW SAFE              \            254 (&FE)    14 = Do nothing
 EQUW SAFE              \            255 (&FF)    15 = Do nothing

 EQUW SAFE              \ These addresses are never used and have no effect, as
 EQUW SAFE              \ they are out of range for one-byte OSWORD numbers
 EQUW SAFE

