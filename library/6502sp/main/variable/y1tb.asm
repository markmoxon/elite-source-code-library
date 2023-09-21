.Y1TB

IF NOT(_NES_VERSION)

 SKIP 256               \ The y-coordinates of the start points for character
                        \ lines in the scroll text

ELIF _NES_VERSION

 SKIP 240               \ The y-coordinates of the start and end points for
                        \ character lines in the scroll text, with the start
                        \ point (Y1) in the low nibble and the end point (Y2)
                        \ in the high nibble

ENDIF

