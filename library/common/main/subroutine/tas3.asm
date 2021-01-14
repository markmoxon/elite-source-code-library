\ ******************************************************************************
\
\       Name: TAS3
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate the dot product of XX15 and an orientation vector
\
\ ------------------------------------------------------------------------------
\
\ Calculate the dot product of the vector in XX15 and one of the orientation
\ vectors, as determined by the value of Y. If vect is the orientation vector,
\ we calculate this:
\
\   (A X) = vect . XX15
\         = vect_x * XX15 + vect_y * XX15+1 + vect_z * XX15+2
\
\ Arguments:
\
\   Y                   The orientation vector:
\
\                         * If Y = 10, calculate nosev . XX15
\
\                         * If Y = 16, calculate roofv . XX15
\
\                         * If Y = 22, calculate sidev . XX15
\
\ Returns:
\
\   (A X)               The result of the dot product
\
IF _DISC_VERSION
\ Other entry points:
\
\   TAS3-2              Calculate nosev . XX15
\
ENDIF
\ ******************************************************************************

IF _DISC_VERSION

 LDY #10                \ Set Y = 10 so we calculate nosev . XX15

ENDIF

.TAS3

 LDX INWK,Y             \ Set Q = the Y-th byte of INWK, i.e. vect_x
 STX Q

 LDA XX15               \ Set A = XX15

 JSR MULT12             \ Set (S R) = Q * A
                        \           = vect_x * XX15

 LDX INWK+2,Y           \ Set Q = the Y+2-th byte of INWK, i.e. vect_y
 STX Q

 LDA XX15+1             \ Set A = XX15+1

 JSR MAD                \ Set (A X) = Q * A + (S R)
                        \           = vect_y * XX15+1 + vect_x * XX15

 STA S                  \ Set (S R) = (A X)
 STX R

 LDX INWK+4,Y           \ Set Q = the Y+2-th byte of INWK, i.e. vect_z
 STX Q

 LDA XX15+2             \ Set A = XX15+2

                        \ Fall through into MAD to set:
                        \
                        \   (A X) = Q * A + (S R)
                        \           = vect_z * XX15+2 + vect_y * XX15+1 +
                        \             vect_x * XX15

