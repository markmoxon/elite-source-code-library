.X2TB

IF NOT(_NES_VERSION)

 SKIP 256               \ The x-coordinates of the end points for character
                        \ lines in the scroll text

ELIF _NES_VERSION

 SKIP 240               \ The x-coordinates of the end points for character
                        \ lines in the scroll text

ENDIF

