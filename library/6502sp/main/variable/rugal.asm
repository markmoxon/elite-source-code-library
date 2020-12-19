\ ******************************************************************************
\
\       Name: RUGAL
\       Type: Variable
\   Category: Text
\    Summary: The tokens to show for systems with special extended descriptions
\
\ ------------------------------------------------------------------------------
\
\ Contains the conditions for printing a special extended description.
\
\ Bits 0-6 have to match the current galaxy, then the corresponding entry in the
\ RUTOK table is shown
\
\ &0x means only print second extended token if mission 1 is in progress
\
\ &8x means print second extended token x anyway
\
\ ******************************************************************************

.RUGAL

 EQUB &80
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB &82
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 1
 EQUB 2
 EQUB 1
 EQUB &82
 EQUB &80

