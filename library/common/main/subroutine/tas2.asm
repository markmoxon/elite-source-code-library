\ ******************************************************************************
\
\       Name: TAS2
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Normalise the three-coordinate vector in K3
\
\ ------------------------------------------------------------------------------
\
\ Normalise the vector in K3, which has 16-bit values and separate sign bits,
\ and store the normalised version in XX15 as a signed 8-bit vector.
\
\ A normalised vector (also known as a unit vector) has length 1, so this
\ routine takes an existing vector in K3 and scales it so the length of the
\ new vector is 1. This is used in two places: when drawing the compass, and
\ when applying AI tactics to ships.
\
\ We do this in two stages. This stage shifts the 16-bit vector coordinates in
\ K3 to the left as far as they will go without losing any bits off the end, so
\ we can then take the high bytes and use them as the most accurate 8-bit vector
\ to normalise. Then the next stage (in routine NORM) does the normalisation.
\
\ Arguments:
\
\   K3(2 1 0)           The 16-bit x-coordinate as (x_sign x_hi x_lo), where
\                       x_sign is just bit 7
\
\   K3(5 4 3)           The 16-bit y-coordinate as (y_sign y_hi y_lo), where
\                       y_sign is just bit 7
\
\   K3(8 7 6)           The 16-bit z-coordinate as (z_sign z_hi z_lo), where
\                       z_sign is just bit 7
\
\ Returns:
\
\   XX15                The normalised vector, with:
\
\                         * The x-coordinate in XX15
\
\                         * The y-coordinate in XX15+1
\
\                         * The z-coordinate in XX15+2
\
\ Other entry points:
\
\   TA2                 Calculate the length of the vector in XX15 (ignoring the
\                       low coordinates), returning it in Q
\
\ ******************************************************************************

.TAS2

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA K3                 \ OR the three low bytes and 1 to get a byte that has
 ORA K3+3               \ a 1 wherever any of the three low bytes has a 1
 ORA K3+6               \ (as well as always having bit 0 set), and store in
 ORA #1                 \ K3+9
 STA K3+9

 LDA K3+1               \ OR the three high bytes to get a byte in A that has a
 ORA K3+4               \ 1 wherever any of the three high bytes has a 1
 ORA K3+7

                        \ (A K3+9) now has a 1 wherever any of the 16-bit
                        \ values in K3 has a 1
.TAL2

 ASL K3+9               \ Shift (A K3+9) to the left, so bit 7 of the high byte
 ROL A                  \ goes into the C flag

IF NOT(_NES_VERSION)

 BCS TA2                \ If the left shift pushed a 1 out of the end, then we
                        \ know that at least one of the coordinates has a 1 in
                        \ this position, so jump to TA2 as we can't shift the
                        \ values in K3 any further to the left

ELIF _NES_VERSION

 BCS CB596              \ If the left shift pushed a 1 out of the end, then we
                        \ know that at least one of the coordinates has a 1 in
                        \ this position, so jump to TA2 as we can't shift the
                        \ values in K3 any further to the left

ENDIF

 ASL K3                 \ Shift K3(1 0), the x-coordinate, to the left
 ROL K3+1

 ASL K3+3               \ Shift K3(4 3), the y-coordinate, to the left
 ROL K3+4

 ASL K3+6               \ Shift K3(6 7), the z-coordinate, to the left
 ROL K3+7

 BCC TAL2               \ Jump back to TAL2 to do another shift left (this BCC
                        \ is effectively a JMP as we know bit 7 of K3+7 is not a
                        \ 1, as otherwise bit 7 of A would have been a 1 and we
                        \ would have taken the BCS above)

IF _NES_VERSION

.CB596

 LSR K3+1              \ ???
 LSR K3+4
 LSR K3+7

ENDIF

.TA2

 LDA K3+1               \ Fetch the high byte of the x-coordinate from our left-
 LSR A                  \ shifted K3, shift it right to clear bit 7, stick the
 ORA K3+2               \ sign bit in there from the x_sign part of K3, and
 STA XX15               \ store the resulting signed 8-bit x-coordinate in XX15

 LDA K3+4               \ Fetch the high byte of the y-coordinate from our left-
 LSR A                  \ shifted K3, shift it right to clear bit 7, stick the
 ORA K3+5               \ sign bit in there from the y_sign part of K3, and
 STA XX15+1             \ store the resulting signed 8-bit y-coordinate in
                        \ XX15+1

 LDA K3+7               \ Fetch the high byte of the z-coordinate from our left-
 LSR A                  \ shifted K3, shift it right to clear bit 7, stick the
 ORA K3+8               \ sign bit in there from the z_sign part of K3, and
 STA XX15+2             \ store the resulting signed 8-bit  z-coordinate in
                        \ XX15+2

IF NOT(_ELITE_A_6502SP_PARA OR _NES_VERSION)

                        \ Now we have a signed 8-bit version of the vector K3 in
                        \ XX15, so fall through into NORM to normalise it

ELIF _ELITE_A_6502SP_PARA OR _NES_VERSION

 JMP NORM               \ Now we have a signed 8-bit version of the vector K3 in
                        \ XX15, so jump to NORM to normalise it, returning from
                        \ the subroutine using a tail call

ENDIF

