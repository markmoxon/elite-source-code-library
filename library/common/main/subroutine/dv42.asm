\ ******************************************************************************
\
\       Name: DV42
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (P R) = 256 * DELTA / z_hi
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following division and remainder:
\
\   P = DELTA / (the Y-th stardust particle's z_hi coordinate)
\
\   R = remainder as a fraction of A, where 1.0 = 255
\
\ Another way of saying the above is this:
\
\   (P R) = 256 * DELTA / z_hi
\
\ DELTA is a value between 1 and 40, and the minimum z_hi is 16 (dust particles
\ are removed at lower values than this), so this means P is between 0 and 2
\ (as 40 / 16 = 2.5, so the maximum result is P = 2 and R = 128.
\
\ This uses the same shift-and-subtract algorithm as TIS2, but this time we
\ keep the remainder.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the stardust particle to process
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.DV42

 LDA SZ,Y               \ Fetch the Y-th dust particle's z_hi coordinate into A

                        \ Fall through into DV41 to do:
                        \
                        \   (P R) = 256 * DELTA / A
                        \         = 256 * DELTA / Y-th stardust particle's z_hi

