\ ******************************************************************************
\
\       Name: M2
\       Type: Variable
\   Category: Utility routines
\    Summary: Used for testing the 6522 System VIA status byte in IRQ1
\
\ ------------------------------------------------------------------------------
\
\ Used for testing bit 1 of the 6522 System VIA status byte in the IRQ1 routine,
\ as well as bit 1 of the block flag.
\
\ ******************************************************************************

.M2

 EQUB %00000010         \ Bit 1 is set

