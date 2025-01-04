\ ******************************************************************************
\
\       Name: FAROF
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Compare x_hi, y_hi and z_hi with 224
\  Deep dive: A sense of scale
\
\ ------------------------------------------------------------------------------
\
\ Compare x_hi, y_hi and z_hi with 224, and set the C flag if all three <= 224,
\ otherwise clear the C flag.
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if x_hi <= 224 and y_hi <= 224 and z_hi <= 224
\
\                       Clear otherwise (i.e. if any one of them are bigger than
\                       224)
\
\ ******************************************************************************

.FAROF

 LDA INWK+2             \ If any of x_sign, y_sign or z_sign are non-zero
 ORA INWK+5             \ (ignoring the sign in bit 7), then jump to faro2 to
 ORA INWK+8             \ return the C flag clear, to indicate that one of x, y
 ASL A                  \ and z is greater than 224
 BNE faro2

 LDA #224               \ If x_hi > 224, jump to faro1 to return the C flag
 CMP INWK+1             \ clear
 BCC faro1

 CMP INWK+4             \ If y_hi > 224, jump to faro1 to return the C flag
 BCC faro1              \ clear

 CMP INWK+7             \ If z_hi > 224, clear the C flag, otherwise set it

.faro1

                        \ By this point the C flag is clear if any of x_hi, y_hi
                        \ or z_hi are greater than 224, otherwise all three are
                        \ less than or equal to 224 and the C flag is set

 RTS                    \ Return from the subroutine

.faro2

 CLC                    \ Clear the C flag to indicate that at least one of the
                        \ axes is greater than 224

 RTS                    \ Return from the subroutine

