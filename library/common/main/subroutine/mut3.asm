\ ******************************************************************************
\
\       Name: MUT3
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: An unused routine that does the same as MUT2
\
\ ------------------------------------------------------------------------------
\
\ This routine is never actually called, but it is identical to MUT2, as the
\ extra instructions have no effect.
\
\ ******************************************************************************

.MUT3

 LDX ALP1               \ Set P = ALP1, though this gets overwritten by the
 STX P                  \ following, so this has no effect

                        \ Fall through into MUT2 to do the following:
                        \
                        \   (S R) = XX(1 0)
                        \   (A P) = Q * A

