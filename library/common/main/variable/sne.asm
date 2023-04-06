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
\ This lookup table contains sine values for the first half of a circle, from 0
\ to 180 degrees (0 to PI radians). In terms of circle or ellipse line segments,
\ there are 64 segments in a circle, so this contains sine values for segments
\ 0 to 31.
\
\ In terms of segments, to calculate the sine of the angle at segment x, we look
\ up the value in SNE + x, and to calculate the cosine of the angle we look up
\ the value in SNE + ((x + 16) mod 32).
\
\ In terms of radians, to calculate the following:
\
\   sin(theta) * 256
\
\ where theta is in radians, we look up the value in:
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
   B% = 255
  ELSE
   B% = INT(256 * N + 0.5)
  ENDIF

  EQUB B%

 NEXT

