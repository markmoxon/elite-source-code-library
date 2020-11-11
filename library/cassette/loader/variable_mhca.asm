\ ******************************************************************************
\
\       Name: MHCA
\       Type: Variable
\   Category: Copy protection
\    Summary: Used to set one of the vectors in the copy protection code
\
\ ------------------------------------------------------------------------------
\
\ This value is used to set the low byte of BLPTR(1 0), when it's set in PLL1
\ as part of the copy protection.
\
\ ******************************************************************************

.MHCA

 EQUB &CA               \ The low byte of BLPTR(1 0)

