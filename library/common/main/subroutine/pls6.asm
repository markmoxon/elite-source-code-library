\ ******************************************************************************
\
\       Name: PLS6
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Calculate (X K) = (A P) / (z_sign z_hi z_lo)
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   (X K) = (A P) / (z_sign z_hi z_lo)
\
\ returning an overflow in the C flag if the result is >= 1024.
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   INWK                The planet or sun's ship data block
ELIF _ELECTRON_VERSION
\   INWK                The planet's ship data block
ENDIF
\
\ Returns:
\
\   C flag              Set if the result >= 1024, clear otherwise
\
\ Other entry points:
\
\   PL44                Clear the C flag and return from the subroutine
\
\ ******************************************************************************

.PLS6

 JSR DVID3B2            \ Call DVID3B2 to calculate:
                        \
                        \   K(3 2 1 0) = (A P+1 P) / (z_sign z_hi z_lo)

 LDA K+3                \ Set A = |K+3| OR K+2
 AND #%01111111
 ORA K+2

 BNE PL21               \ If A is non-zero then the two high bytes of K(3 2 1 0)
                        \ are non-zero, so jump to PL21 to set the C flag and
                        \ return from the subroutine

                        \ We can now just consider K(1 0), as we know the top
                        \ two bytes of K(3 2 1 0) are both 0

 LDX K+1                \ Set X = K+1, so now (X K) contains the result in
                        \ K(1 0), which is the format we want to return the
                        \ result in

 CPX #4                 \ If the high byte of K(1 0) >= 4 then the result is
 BCS PL6                \ >= 1024, so return from the subroutine with the C flag
                        \ set to indicate an overflow (as PL6 contains an RTS)

 LDA K+3                \ Fetch the sign of the result from K+3 (which we know
                        \ has zeroes in bits 0-6, so this just fetches the sign)

\CLC                    \ This instruction is commented out in the original
                        \ source. It would have no effect as we know the C flag
                        \ is already clear, as we skipped past the BCS above

 BPL PL6                \ If the sign bit is clear and the result is positive,
                        \ then the result is already correct, so return from
                        \ the subroutine with the C flag clear to indicate
                        \ success (as PL6 contains an RTS)

 LDA K                  \ Otherwise we need to negate the result, which we do
 EOR #%11111111         \ using two's complement, starting with the low byte:
 ADC #1                 \
 STA K                  \   K = ~K + 1

 TXA                    \ And then the high byte:
 EOR #%11111111         \
 ADC #0                 \   X = ~X
 TAX

.PL44

 CLC                    \ Clear the C flag to indicate success

.PL6

 RTS                    \ Return from the subroutine

