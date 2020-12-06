\ ******************************************************************************
\
\       Name: osprint
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Print a character
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print
\
\ ******************************************************************************

.TUT

.osprint

 JMP (OSPRNT)           \ Jump to the address in OSPRNT and return using a
                        \ tail call

 EQUB &6C

