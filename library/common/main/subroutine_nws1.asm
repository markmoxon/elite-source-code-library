\ ******************************************************************************
\
\       Name: NwS1
\       Type: Subroutine
\   Category: Universe
\    Summary: Flip the sign and double an INWK byte
\
\ ------------------------------------------------------------------------------
\
\ Flip the sign of the INWK byte at offset X, and increment X by 2. This is
\ used by the space station creation routine at NWSPS.
\
\ Arguments:
\
\   X                   The offset of the INWK byte to be flipped
\
\ Returns:
\
\   X                   X is incremented by 2
\
\ ******************************************************************************

.NwS1

 LDA INWK,X             \ Load the X-th byte of INWK into A and flip bit 7,
 EOR #%10000000         \ storing the result back in the X-th byte of INWK
 STA INWK,X

 INX                    \ Add 2 to X
 INX

 RTS                    \ Return from the subroutine

