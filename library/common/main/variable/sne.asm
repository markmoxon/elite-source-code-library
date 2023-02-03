\ ******************************************************************************
\
\       Name: SNE
\       Type: Variable
\   Category: Maths (Geometry)
\    Summary: Sine/cosine table
\  Deep dive: The sine, cosine and arctan tables
\             Drawing circles
\             Drawing ellipses
\
\ ------------------------------------------------------------------------------
\
\ To calculate the following:
\
\   sin(theta) * 256
\
\ where theta is in radians, look up the value in:
\
\   SNE + (theta * 10)
\
\ To calculate the following:
\
\   cos(theta) * 256
\
\ where theta is in radians, look up the value in:
\
\   SNE + ((theta * 10) + 16) mod 32
\
\ Theta must be between 0 and 3.1 radians, so theta * 10 is between 0 and 31.
\
\ ******************************************************************************

.SNE

FOR I%, 0, 31

 N = ABS(SIN((I% / 64) * 2 * PI))

 IF N >= 1
  EQUB 255
 ELSE
  EQUB INT(256 * N + 0.5)
 ENDIF

NEXT

