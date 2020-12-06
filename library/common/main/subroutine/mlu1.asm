\ ******************************************************************************
\
\       Name: MLU1
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate Y1 = y_hi and (A P) = |y_hi| * Q for Y-th stardust
\
\ ------------------------------------------------------------------------------
\
\ Do the following assignment, and multiply the Y-th stardust particle's
\ y-coordinate with an unsigned number Q:
\
\   Y1 = y_hi
\
\   (A P) = |y_hi| * Q
\
\ ******************************************************************************

.MLU1

 LDA SY,Y               \ Set Y1 the Y-th byte of SY
 STA Y1

                        \ Fall through into MLU2 to calculate:
                        \
                        \   (A P) = |A| * Q

