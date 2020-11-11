\ ******************************************************************************
\
\       Name: MCASH
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Add an amount of cash to the cash pot
\
\ ------------------------------------------------------------------------------
\
\ Add (Y X) cash to the cash pot in CASH. As CASH is a four-byte number, this
\ calculates:
\
\   CASH(0 1 2 3) = CASH(0 1 2 3) + (Y X)
\
\ Other entry points:
\
\   TT113               Contains an RTS
\
\ ******************************************************************************

.MCASH

 TXA                    \ Add the least significant bytes:
 CLC                    \
 ADC CASH+3             \   CASH+3 = CASH+3 + X
 STA CASH+3

 TYA                    \ Then the second most significant bytes:
 ADC CASH+2             \
 STA CASH+2             \   CASH+2 = CASH+2 + Y

 LDA CASH+1             \ Then the third most significant bytes (which are 0):
 ADC #0                 \
 STA CASH+1             \   CASH+1 = CASH+1 + 0

 LDA CASH               \ And finally the most significant bytes (which are 0):
 ADC #0                 \
 STA CASH               \   CASH = CASH + 0

 CLC                    \ Clear the C flag, so if the above was done following
                        \ a failed LCASH call, the C flag correctly indicates
                        \ failure

.^TT113

 RTS                    \ Return from the subroutine

