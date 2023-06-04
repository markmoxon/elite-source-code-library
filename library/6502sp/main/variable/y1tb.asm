.Y1TB

IF NOT(_NES_VERSION)

 SKIP 256               \ The y-coordinates of the start points for character
                        \ lines in the scroll text

ELIF _NES_VERSION

 SKIP 240               \ The y-coordinates of the start points for character
                        \ lines in the scroll text

ENDIF

