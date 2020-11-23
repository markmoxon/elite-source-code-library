.YC

IF _CASSETTE_VERSION
 SKIP 1                 \ The y-coordinate of the text cursor (i.e. the text
                        \ row), which can be from 0 to 23
ELIF _6502SP_VERSION
 EQUB 1                 \ The y-coordinate of the text cursor (i.e. the text
                        \ row), which can be from 0 to 23
ENDIF
                        \
                        \ The screen actually has 31 character rows if you
                        \ include the mode 5 dashboard, but the text printing
                        \ routines only work on the mode 4 part (the space
                        \ view), so the text cursor only goes up to a maximum of
                        \ 23, the row just before the screen split
                        \
                        \ A value of 0 denotes the top row, but because the
                        \ top part of the screen has a white border that clashes
                        \ with row 0, text is always shown at row 1 or greater

