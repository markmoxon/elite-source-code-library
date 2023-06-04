.X1TB

IF NOT(_NES_VERSION)

 SKIP 256               \ The x-coordinates of the start points for character
                        \ lines in the scroll text (as space coordinates)

ELIF _NES_VERSION

 SKIP 240               \ The x-coordinates of the start points for character
                        \ lines in the scroll text

ENDIF

