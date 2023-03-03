\ ******************************************************************************
\
\       Name: ACT
\       Type: Variable
\   Category: Maths (Geometry)
\    Summary: Arctan table
\  Deep dive: The sine, cosine and arctan tables
\
\ ------------------------------------------------------------------------------
\
\ This table contains lookup values for arctangent calculations involving angles
\ in the range 0 to 45 degrees (or 0 to PI / 4 radians).
\
\ To calculate the value of theta in the following:
\
\   theta = arctan(t)
\
\ where 0 <= t < 1, we look up the value in:
\
\   ACT + (t * 32)
\
\ The result will be an integer representing the angle in radians, where 256
\ represents a full circle of 360 degrees (2 * PI radians). The result of the
\ lookup will therefore be an integer in the range 0 to 31, as this represents
\ 0 to 45 degrees (0 to PI / 4 radians).
\
\ The table does not support values of t >= 1 or t < 0 directly, so if we need
\ to calculate the arctangent for an angle greater than 45 degrees, we can apply
\ the following calculation to the result from the table:
\
\   * For t > 1, arctan(t) = 64 - arctan(1 / t)
\
\ For negative values of t where -1 < t < 0, we can apply the following
\ calculation to the result from the table:
\
\   * For t < 0, arctan(-t) = 128 - arctan(t)
\
\ Finally, if t < -1, we can do the first calculation to get arctan(|t|), and
\ the second to get arctan(-|t|).
\
\ ******************************************************************************

.ACT

FOR I%, 0, 31

 EQUB INT((128 / PI) * ATN(I% / 32) + 0.5)

NEXT

