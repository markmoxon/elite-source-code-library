\ ******************************************************************************
\
\       Name: MUT1
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate R = XX and (A P) = Q * A
\
\ ------------------------------------------------------------------------------
\
\ Do the following assignment, and multiplication of two signed 8-bit numbers:
\
\   R = XX
\   (A P) = Q * A
\
\ ******************************************************************************

.MUT1

 LDX XX                 \ Set R = XX
 STX R

                        \ Fall through into MULT1 to do the following:
                        \
                        \   (A P) = Q * A

