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

IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Other: There's an extra bit of code in the disc version of the MLS2 routine that has no effect

 LDX ALP1               \ This repeats the first two instructions of MLS1, which
 STX P                  \ is presumably unintentional (though it has no effect)

                        \ Fall through into SQUA to calculate (A P) = A * ALP1

ELIF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

                        \ Fall through into MLS1 to calculate (A P) = A * ALP1

ENDIF

