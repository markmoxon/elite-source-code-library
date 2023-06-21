\ ******************************************************************************
\
\       Name: FAROF
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Compare x_hi, y_hi and z_hi with 224
\
\ ------------------------------------------------------------------------------
\
\ Compare x_hi, y_hi and z_hi with 224, and set the C flag if all three <= 224,
\ otherwise clear the C flag.
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

IF NOT(_NES_VERSION)

 LDA #224               \ Set A = 224 and fall through into FAROF2 to do the
                        \ comparison

ELIF _NES_VERSION

 LDA INWK+2             \ ???
 ORA INWK+5
 ORA INWK+8
 ASL A
 BNE faro2

 LDA #224

 CMP INWK+1
 BCC faro1
 CMP INWK+4
 BCC faro1
 CMP INWK+7

.faro1

 RTS

.faro2

 CLC

 RTS

ENDIF

