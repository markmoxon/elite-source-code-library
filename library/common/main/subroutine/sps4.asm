\ ******************************************************************************
\
\       Name: SPS4
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate the vector to the space station
\
\ ------------------------------------------------------------------------------
\
\ Calculate the vector between our ship and the space station and store it in
\ XX15.
\
\ ******************************************************************************

.SPS4

 LDX #8                 \ First we need to copy the space station's coordinates
                        \ into K3, so set a counter to copy the first 9 bytes
                        \ (the 3-byte x, y and z coordinates) from the station's
                        \ data block at K% + NI% into K3

.SPL1

IF NOT(_NES_VERSION)

 LDA K%+NI%,X           \ Copy the X-th byte from the station's data block at
 STA K3,X               \ K% + NI% to the X-th byte of K3

ELIF _NES_VERSION

 LDA K%+NIK%,X          \ Copy the X-th byte from the station's data block at
 STA K3,X               \ K% + NIK% to the X-th byte of K3

ENDIF

 DEX                    \ Decrement the loop counter

 BPL SPL1               \ Loop back to SPL1 until we have copied all 9 bytes

 JMP TAS2               \ Call TAS2 to build XX15 from K3, returning from the
                        \ subroutine using a tail call

