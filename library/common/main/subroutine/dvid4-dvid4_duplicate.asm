\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\       Name: DVID4
ELIF _MASTER_VERSION
\       Name: DVID4K
ENDIF
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (P R) = 256 * A / Q
\  Deep dive: Shift-and-subtract division
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following division and remainder:
\
\   P = A / Q
\
\   R = remainder as a fraction of Q, where 1.0 = 255
\
\ Another way of saying the above is this:
\
\   (P R) = 256 * A / Q
\
\ This uses the same shift-and-subtract algorithm as TIS2, but this time we
\ keep the remainder.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

.DVID4

ELIF _MASTER_VERSION

.DVID4K

                        \ This is an exact duplicate of the DVID4 routine, which
                        \ is also present in this source, so it isn't clear why
                        \ this duplicate exists (especially as the other version
                        \ is slightly faster, as it unrolls the loop)

ENDIF

 LDX #8                 \ Set a counter in X to count the 8 bits in A

 ASL A                  \ Shift A left and store in P (we will build the result
 STA P                  \ in P)

 LDA #0                 \ Set A = 0 for us to build a remainder

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

.DVL4

ELIF _MASTER_VERSION

.DVL4K

ENDIF

 ROL A                  \ Shift A to the left

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 BCS DV8                \ If the C flag is set (i.e. bit 7 of A was set) then
                        \ skip straight to the subtraction

 CMP Q                  \ If A < Q skip the following subtraction
 BCC DV5

.DV8

ELIF _MASTER_VERSION

 BCS DV8K               \ If the C flag is set (i.e. bit 7 of A was set) then
                        \ skip straight to the subtraction

 CMP Q                  \ If A < Q skip the following subtraction
 BCC DV5K

.DV8K

ENDIF

 SBC Q                  \ A >= Q, so set A = A - Q

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: Group A: There are two differences in the DVID4 routine between the original versions and the advanced versions that look like they would affect the result of the division; I haven't yet worked out what this is all about

 SEC                    \ Set the C flag, so that P gets a 1 shifted into bit 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

.DV5

ELIF _MASTER_VERSION

.DV5K

ENDIF

 ROL P                  \ Shift P to the left, pulling the C flag into bit 0

 DEX                    \ Decrement the loop counter

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

 BNE DVL4               \ Loop back for the next bit until we have done all 8
                        \ bits of P

ELIF _MASTER_VERSION

 BNE DVL4K              \ Loop back for the next bit until we have done all 8
                        \ bits of P

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: See group A

 JMP LL28+4             \ Jump to LL28+4 to convert the remainder in A into an
                        \ integer representation of the fractional value A / Q,
                        \ in R, where 1.0 = 255. LL28+4 always returns with the
                        \ C flag cleared, and we return from the subroutine
                        \ using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION

 RTS                    \ Return from the subroutine

ENDIF

