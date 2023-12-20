\ ******************************************************************************
\
\       Name: TT123
\       Type: Subroutine
\   Category: Charts
\    Summary: Move galactic coordinates by a signed delta
\
\ ------------------------------------------------------------------------------
\
\ Move an 8-bit galactic coordinate by a certain distance in either direction
\ (i.e. a signed 8-bit delta), but only if it doesn't cause the coordinate to
\ overflow. The coordinate is in a single axis, so it's either an x-coordinate
\ or a y-coordinate.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The galactic coordinate to update
\
\   QQ19+3              The delta (can be positive or negative)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
IF NOT(_NES_VERSION)
\   QQ19+4              The updated coordinate after moving by the delta (this
\                       will be the same as A if moving by the delta overflows)
ELIF _NES_VERSION
\   QQ19+4              The updated coordinate after moving by the delta (this
\                       will be 1 or 255 if moving by the delta underflows or
\                       overflows)
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TT180               Contains an RTS
\
\ ******************************************************************************

.TT123

IF NOT(_NES_VERSION)

 STA QQ19+4             \ Store the original coordinate in temporary storage at
                        \ QQ19+4

ENDIF

 CLC                    \ Set A = A + QQ19+3, so A now contains the original
 ADC QQ19+3             \ coordinate, moved by the delta

 LDX QQ19+3             \ If the delta is negative, jump to TT124
 BMI TT124

 BCC TT125              \ If the C flag is clear, then the above addition didn't
                        \ overflow, so jump to TT125 to return the updated value

IF NOT(_NES_VERSION)

 RTS                    \ Otherwise the C flag is set and the above addition
                        \ overflowed, so do not update the return value

ELIF _NES_VERSION

 LDA #255               \ Otherwise set A to 255 and jump to TT125 to return
 BNE TT125              \ this as the updated value

ENDIF

.TT124

IF NOT(_NES_VERSION)

 BCC TT180              \ If the C flag is clear, then because the delta is
                        \ negative, this indicates the addition (which is
                        \ effectively a subtraction) underflowed, so jump to
                        \ TT180 to return from the subroutine without updating
                        \ the return value

ELIF _NES_VERSION

 BCS TT125              \ If the C flag is set, then because the delta is
                        \ negative, this indicates the addition (which is
                        \ effectively a subtraction) didn't underflow, so jump
                        \ to TT125 to return this as the updated value

 LDA #1                 \ The subtraction underflowed, so set A to 1 to return
                        \ as the updated value

ENDIF

.TT125

 STA QQ19+4             \ Store the updated coordinate in QQ19+4

.TT180

 RTS                    \ Return from the subroutine

