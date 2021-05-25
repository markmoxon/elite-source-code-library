\ ******************************************************************************
\
\       Name: FMLTU2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate A = K * sin(A)
\  Deep dive: The sine, cosine and arctan tables
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   A = K * sin(A)
\
\ Because this routine uses the sine lookup table SNE, we can also call this
\ routine to calculate cosine multiplication. To calculate the following:
\
\   A = K * cos(B)
\
\ call this routine with B + 16 in the accumulator, as sin(B + 16) = cos(B).
\
\ ******************************************************************************

.FMLTU2

 AND #%00011111         \ Restrict A to bits 0-5 (so it's in the range 0-31)

 TAX                    \ Set Q = sin(A) * 256
 LDA SNE,X
 STA Q

 LDA K                  \ Set A to the radius in K

                        \ Fall through into FMLTU to do the following:
                        \
                        \   (A ?) = A * Q
                        \         = K * sin(A) * 256
                        \
                        \ which is equivalent to:
                        \
                        \   A = K * sin(A)

