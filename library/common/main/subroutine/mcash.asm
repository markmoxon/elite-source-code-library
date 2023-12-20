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
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TT113               Contains an RTS
\
\ ******************************************************************************

.MCASH

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 TXA                    \ Add the least significant bytes:
 CLC                    \
 ADC CASH+3             \   CASH+3 = CASH+3 + X
 STA CASH+3

 TYA                    \ Then the second most significant bytes:
 ADC CASH+2             \
 STA CASH+2             \   CASH+2 = CASH+2 + Y

IF NOT(_ELITE_A_FLIGHT)

 LDA CASH+1             \ Then the third most significant bytes (which are 0):
 ADC #0                 \
 STA CASH+1             \   CASH+1 = CASH+1 + 0

 LDA CASH               \ And finally the most significant bytes (which are 0):
 ADC #0                 \
 STA CASH               \   CASH = CASH + 0

ELIF _ELITE_A_FLIGHT

 BCC TT113              \ If the above addition didn't overflow, then the
                        \ addition is done, so jump to TT113 to return from the
                        \ subroutine with the C flag clear

 INC CASH+1             \ Otherwise we need to add the C flag to the third most
                        \ significant byte of CASH, which we can do with an
                        \ increment

 BNE n_addmny           \ If the result of the above increment is non-zero, then
                        \ we have nothing further to carry and the addition is
                        \ complete, so skip the following instruction

 INC CASH               \ Otherwise we need to add the C flag to the most
                        \ significant byte of CASH, which we can do with an
                        \ increment

.n_addmny

ENDIF

 CLC                    \ Clear the C flag, so if the above was done following
                        \ a failed LCASH call, the C flag correctly indicates
                        \ failure

.TT113

 RTS                    \ Return from the subroutine

