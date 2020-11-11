\ ******************************************************************************
\
\       Name: ACT
\       Type: Variable
\   Category: Maths (Geometry)
\    Summary: Arctan table
\
\ ------------------------------------------------------------------------------
\
\ To calculate the following:
\
\   theta = arctan(t)
\
\ where 0 <= t < 1, look up the value in:
\
\   ACT + (t * 32)
\
\ The result will be an integer representing the angle in radians, with 256
\ representing a full circle of 2 * PI radians.
\
\ The table does not support values of t >= 1 or t < 0 directly, but we can use
\ the following calculations instead:
\
\   * For t > 1, arctan(t) = 64 - arctan(1 / t)
\
\   * For t < 0, arctan(-t) = 128 - arctan(t)
\
\ If t < -1, we can do the first one to get arctan(|t|), then the second to get
\ arctan(-|t|).
\
\ ******************************************************************************

.ACT

FOR I%, 0, 31
  EQUB INT((128 / PI) * ATN(I% / 32) + 0.5)
NEXT

