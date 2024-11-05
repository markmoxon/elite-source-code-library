\ ******************************************************************************
\
\       Name: SPS2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
IF NOT(_NES_VERSION)
\    Summary: Calculate (Y X) = A / 10
ELIF _NES_VERSION
\    Summary: Calculate X = A / 16
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ Calculate the following, where A is a sign-magnitude 8-bit integer and the
\ result is a signed 16-bit integer:
\
\   (Y X) = A / 10
ELIF _NES_VERSION
\ Calculate the following, where A is a sign-magnitude 8-bit integer and the
\ result is a signed 8-bit integer:
\
\   X = A / 16
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is cleared
\
IF _APPLE_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   COR1                Contains an RTS
\
ENDIF
\ ******************************************************************************

.SPS2

IF NOT(_NES_VERSION)

 ASL A                  \ Set X = |A| * 2, and set the C flag to the sign bit of
 TAX                    \ A

 LDA #0                 \ Set Y to have the sign bit from A in bit 7, with the
 ROR A                  \ rest of its bits zeroed, so Y now contains the sign of
 TAY                    \ the original argument

 LDA #20                \ Set Q = 20
 STA Q

 TXA                    \ Copy X into A, so A now contains the argument A * 2

 JSR DVID4              \ Calculate the following:
                        \
                        \   P = A / Q
                        \     = |argument A| * 2 / 20
                        \     = |argument A| / 10

 LDX P                  \ Set X to the result

 TYA                    \ If the sign of the original argument A is negative,
 BMI LL163              \ jump to LL163 to flip the sign of the result

 LDY #0                 \ Set the high byte of the result to 0, as the result is
                        \ positive

 RTS                    \ Return from the subroutine

.LL163

 LDY #&FF               \ The result is negative, so set the high byte to &FF

 TXA                    \ Flip the low byte and add 1 to get the negated low
 EOR #&FF               \ byte, using two's complement
 TAX
 INX

ELIF _NES_VERSION

 TAY                    \ Copy the argument A to Y, so we can check its sign
                        \ below

 AND #%01111111         \ Clear the sign bit of the argument A

 LSR A                  \ Set A = A / 16
 LSR A
 LSR A
 LSR A

 ADC #0                 \ Round the result up to the nearest integer by adding
                        \ the bit we just shifted off the right (which went into
                        \ the C flag)

 CPY #%10000000         \ If Y is positive (i.e. the original argument was
 BCC LL163              \ positive), jump to LL163

 EOR #&FF               \ Negate A using two's complement
 ADC #0

.LL163

 TAX                    \ Copy the result in A to X

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Label

.COR1

ENDIF

 RTS                    \ Return from the subroutine

