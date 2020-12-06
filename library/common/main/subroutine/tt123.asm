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
\ Arguments:
\
\   A                   The galactic coordinate to update
\
\   QQ19+3              The delta (can be positive or negative)
\
\ Returns:
\
\   QQ19+4              The updated coordinate after moving by the delta (this
\                       will be the same as A if moving by the delta overflows)
\
\ Other entry points:
\
\   TT180               Contains an RTS
\
\ ******************************************************************************

.TT123

 STA QQ19+4             \ Store the original coordinate in temporary storage at
                        \ QQ19+4

 CLC                    \ Set A = A + QQ19+3, so A now contains the original
 ADC QQ19+3             \ coordinate, moved by the delta

 LDX QQ19+3             \ If the delta is negative, jump to TT124
 BMI TT124

 BCC TT125              \ If the C flag is clear, then the above addition didn't
                        \ overflow, so jump to TT125 to return the updated value

 RTS                    \ Otherwise the C flag is set and the above addition
                        \ overflowed, so do not update the return value

.TT124

 BCC TT180              \ If the C flag is clear, then because the delta is
                        \ negative, this indicates the addition (which is
                        \ effectively a subtraction) underflowed, so jump to
                        \ TT180 to return from the subroutine without updating
                        \ the return value

.TT125

 STA QQ19+4             \ Store the updated coordinate in QQ19+4

.TT180

 RTS                    \ Return from the subroutine

