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

 LDA #224               \ Set A = 224 and fall through into FAROF2 to do the
                        \ comparison

