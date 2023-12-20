\ ******************************************************************************
\
\       Name: GC2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (Y X) = (A P) * 4
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following multiplication of unsigned 16-bit numbers:
\
\   (Y X) = (A P) * 4
\
IF _ELITE_A_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   price_xy            Set (Y X) = (A P)
\
ENDIF
\ ******************************************************************************

.GC2

 ASL P                  \ Set (A P) = (A P) * 4
 ROL A
 ASL P
 ROL A

IF _ELITE_A_VERSION

.price_xy

ENDIF

 TAY                    \ Set (Y X) = (A P)
 LDX P

 RTS                    \ Return from the subroutine

