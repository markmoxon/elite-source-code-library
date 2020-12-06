\ ******************************************************************************
\
\       Name: PLS1
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Calculate (Y A) = nosev_x / z
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following division of a specified value from one of the
\ orientation vectors (in this example, nosev_x):
\
\   (Y A) = nosev_x / z
\
\ where z is the z-coordinate of the planet from INWK. The result is an 8-bit
\ magnitude in A, with maximum value 254, and just a sign bit (bit 7) in Y.
\
\ Arguments:
\
\   X                   Determines which of the INWK orientation vectors to
\                       divide:
\
\                         * X = 9, 11, 13: divides nosev_x, nosev_y, nosev_z
\
\                         * X = 15, 17, 19: divides roofv_x, roofv_y, roofv_z
\
\                         * X = 21, 23, 25: divides sidev_x, sidev_y, sidev_z
\
\   INWK                The planet's ship data block
\
\ Returns:
\
\   A                   The result as an 8-bit magnitude with maximum value 254
\
\   Y                   The sign of the result in bit 7
\
\   K+3                 Also the sign of the result in bit 7
\
\   X                   X gets incremented by 2 so it points to the next
\                       coordinate in this orientation vector (so consecutive
\                       calls to the routine will start with x, then move onto y
\                       and then z)
\
\ ******************************************************************************

.PLS1

 LDA INWK,X             \ Set P = nosev_x_lo
 STA P

 LDA INWK+1,X           \ Set P+1 = |nosev_x_hi|
 AND #%01111111
 STA P+1

 LDA INWK+1,X           \ Set A = sign bit of nosev_x_lo
 AND #%10000000

 JSR DVID3B2            \ Call DVID3B2 to calculate:
                        \
                        \   K(3 2 1 0) = (A P+1 P) / (z_sign z_hi z_lo)

 LDA K                  \ Fetch the lowest byte of the result into A

 LDY K+1                \ Fetch the second byte of the result into Y

 BEQ P%+4               \ If the second byte is 0, skip the next instruction

 LDA #254               \ The second byte is non-zero, so the result won't fit
                        \ into one byte, so set A = 254 as our maximum one-byte
                        \ value to return

 LDY K+3                \ Fetch the sign of the result from K+3 into Y

 INX                    \ Add 2 to X so the index points to the next coordinate
 INX                    \ in this orientation vector (so consecutive calls to
                        \ the routine will start with x, then move onto y and z)

 RTS                    \ Return from the subroutine

