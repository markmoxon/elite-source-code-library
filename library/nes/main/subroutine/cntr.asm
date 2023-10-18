\ ******************************************************************************
\
\       Name: cntr
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Apply damping to the pitch or roll dashboard indicator
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ Arguments:
\
\   A                   The amount to dampen by
\
\   X                   The value to dampen
\
\ Returns:
\
\   X                   The dampened value
\
\ ******************************************************************************

.cntr1

 LDX #128               \ Set X = 128 to return so we don't dampen past the
                        \ middle of the indicator

.cntr2

 RTS                    \ Return from the subroutine

.cntr

 STA T                  \ Store the argument A in T

 LDA auto               \ If the docking computer is currently activated, jump
 BNE cntr3              \ to cntr3 to skip the following as we always want to
                        \ enable damping for the docking computer

 LDA DAMP               \ If DAMP is zero, then damping is disabled, so jump to
 BEQ cntr2              \ cntr2 to return from the subroutine

.cntr3

 TXA                    \ If X >= 128, then it's in the right-hand side of the
 BMI cntr4              \ dashboard slider, so jump to cntr4 to decrement it by
                        \ T to move it closer to the centre

                        \ If we get here then the current value in X is in the
                        \ left-hand side of the dashboard slider, so now we
                        \ increment it by T to move it closer to the centre

 CLC                    \ Set A = A + T
 ADC T

 BMI cntr1              \ If the addition pushed A to 128 or higher, jump to
                        \ cntr1 to return a value of X = 128, so we don't dampen
                        \ past the middle of the indicator

 TAX                    \ Set X to the newly dampened value

 RTS                    \ Return from the subroutine

.cntr4

 SEC                    \ Set A = A - T
 SBC T

 BPL cntr1              \ If the subtraction reduced A to 127 or lower, jump to
                        \ cntr1 to return a value of X = 128, so we don't dampen
                        \ past the middle of the indicator

 TAX                    \ Set X to the newly dampened value

 RTS                    \ Return from the subroutine

