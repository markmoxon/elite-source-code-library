\ ******************************************************************************
\
\       Name: MLS2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (S R) = XX(1 0) and (A P) = A * ALP1
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   (S R) = XX(1 0)
\
\   (A P) = A * ALP1
\
\ where ALP1 is the magnitude of the current roll angle alpha, in the range
\ 0-31.
\
\ ******************************************************************************

.MLS2

 LDX XX                 \ Set (S R) = XX(1 0), starting with the low bytes
 STX R

 LDX XX+1               \ And then doing the high bytes
 STX S

IF _DISC_DOCKED \ Other: There's an extra bit of code in the disc version that has no effect

 LDX ALP1               \ This repeats the first two instructions of MLS1, which
 STX P                  \ is presumably unintentional (though it has no effect)

ENDIF

                        \ Fall through into MLS1 to calculate (A P) = A * ALP1

