\ ******************************************************************************
\
\       Name: GCASH
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (Y X) = P * Q * 4
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following multiplication of unsigned 8-bit numbers:
\
\   (Y X) = P * Q * 4
\
\ ******************************************************************************

.GCASH

 JSR MULTU              \ Call MULTU to calculate (A P) = P * Q

