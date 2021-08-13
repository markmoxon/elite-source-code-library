\ ******************************************************************************
\
\       Name: mix_bits
\       Type: Variable
\   Category: Loader
\    Summary: Lookup table for locating a specific bit in the 32-bit word for a
\             given ship blueprint position
\  Deep dive: Ship blueprints in Elite-A
\
\ ******************************************************************************

.mix_bits

 EQUB %00000001         \ Positions 0,  8, 16, 24
 EQUB %00000010         \ Positions 1,  9, 17, 25
 EQUB %00000100         \ Positions 2, 10, 18, 26
 EQUB %00001000         \ Positions 3, 11, 19, 27
 EQUB %00010000         \ Positions 4, 12, 20, 28
 EQUB %00100000         \ Positions 5, 13, 21, 29
 EQUB %01000000         \ Positions 6, 14, 22, 30
 EQUB %10000000         \ Positions 7, 15, 23, 31

