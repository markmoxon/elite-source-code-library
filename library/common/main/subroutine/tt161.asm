\ ******************************************************************************
\
\       Name: TT161
\       Type: Subroutine
\   Category: Market
\    Summary: Print "kg" (for kilograms)
\
\ ******************************************************************************

.TT161

 LDA #'k'               \ Load a "k" character into A

IF NOT(_NES_VERSION)

 JSR TT26               \ Print the character, using TT216 so that it doesn't
                        \ change the character case, and fall through into
                        \ TT16a to print a "g" character

ELIF _NES_VERSION

 JSR DASC_b2            \ Print the character and fall through into TT16a to
                        \ print a "g" character

ENDIF

