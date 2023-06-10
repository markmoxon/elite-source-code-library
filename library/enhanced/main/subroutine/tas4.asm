\ ******************************************************************************
\
\       Name: TAS4
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate the dot product of XX15 and one of the space station's
\             orientation vectors
\
\ ------------------------------------------------------------------------------
\
\ Calculate the dot product of the vector in XX15 and one of the space station's
\ orientation vectors, as determined by the value of Y. If vect is the space
\ station orientation vector, we calculate this:
\
\   (A X) = vect . XX15
\         = vect_x * XX15 + vect_y * XX15+1 + vect_z * XX15+2
\
\ Technically speaking, this routine can also calculate the dot product between
\ XX15 and the sun's orientation vectors, as the sun and space station share the
\ same ship data slot (the second ship data block at K%). However, the sun
\ doesn't have orientation vectors, so this only gets called when that slot is
\ being used for the space station.
\
\ Arguments:
\
\   Y                   The space station's orientation vector:
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
\ ******************************************************************************

.TAS4

IF NOT(_NES_VERSION)

 LDX K%+NI%,Y           \ Set Q = the Y-th byte of K%+NI%, i.e. vect_x from the
 STX Q                  \ second ship data block at K%

ELIF _NES_VERSION

 LDX K%+NIK%,Y          \ Set Q = the Y-th byte of K%+NIK%, i.e. vect_x from the
 STX Q                  \ second ship data block at K%

ENDIF

 LDA XX15               \ Set A = XX15

 JSR MULT12             \ Set (S R) = Q * A
                        \           = vect_x * XX15

IF NOT(_NES_VERSION)

 LDX K%+NI%+2,Y         \ Set Q = the Y+2-th byte of K%+NI%, i.e. vect_y
 STX Q

ELIF _NES_VERSION

 LDX K%+NIK%+2,Y        \ Set Q = the Y+2-th byte of K%+NIK%, i.e. vect_y
 STX Q

ENDIF

 LDA XX15+1             \ Set A = XX15+1

 JSR MAD                \ Set (A X) = Q * A + (S R)
                        \           = vect_y * XX15+1 + vect_x * XX15

 STA S                  \ Set (S R) = (A X)
 STX R

IF NOT(_NES_VERSION)

 LDX K%+NI%+4,Y         \ Set Q = the Y+2-th byte of K%+NI%, i.e. vect_z
 STX Q

ELIF _NES_VERSION

 LDX K%+NIK%+4,Y        \ Set Q = the Y+2-th byte of K%+NIK%, i.e. vect_z
 STX Q

ENDIF

 LDA XX15+2             \ Set A = XX15+2

 JMP MAD                \ Set:
                        \
                        \   (A X) = Q * A + (S R)
                        \           = vect_z * XX15+2 + vect_y * XX15+1 +
                        \             vect_x * XX15
                        \
                        \ and return from the subroutine using a tail call

