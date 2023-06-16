\ ******************************************************************************
\
\       Name: TT16a
\       Type: Subroutine
\   Category: Market
\    Summary: Print "g" (for grams)
\
\ ******************************************************************************

.TT16a

 LDA #'g'               \ Load a "g" character into A

IF NOT(_NES_VERSION)

 JMP TT26               \ Print the character, using TT216 so that it doesn't
                        \ change the character case, and return from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

 JMP DASC_b2            \ Print the character and return from the subroutine
                        \ using a tail call

ENDIF

