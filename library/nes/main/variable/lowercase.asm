\ ******************************************************************************
\
\       Name: lowerCase
\       Type: Variable
\   Category: Text
\    Summary: Lookup table for converting ASCII characters to lower case
\             characters in the game's text font
\
\ ******************************************************************************

.lowerCase

 EQUB  0,  1,  2,  3    \ Control codes map to themselves
 EQUB  4,  5,  6,  7
 EQUB  8,  9, 10, 11
 EQUB 12, 13, 14, 15
 EQUB 16, 17, 18, 19
 EQUB 20, 21, 22, 23
 EQUB 24, 25, 26, 27
 EQUB 28, 29, 30, 31

 EQUS " !$/$%&'()*+,"   \ These punctuation characters map to themselves apart
 EQUS "-./0123456789"   \ from the following (ASCII on left, NES on right):
 EQUS ":;%*>?`"         \
                        \   " to $
                        \   # to /
                        \   < to %
                        \   = to *
                        \   @ to `

 EQUS "abcdefghijklm"   \ Capital letters map to their lower case equivalents
 EQUS "nopqrstuvwxyz"

 EQUS "{|};+`"          \ These punctuation characters map to themselves apart
                        \ from the following (ASCII on left, NES on right):
                        \
                        \   [ to {
                        \   \ to |
                        \   ] to }
                        \   ^ to ;
                        \   _ to +

 EQUS "abcdefghijklm"   \ Lower case characters map to themselves
 EQUS "nopqrstuvwxyz"

 EQUS "{|}~"            \ These punctuation characters map to themselves

 EQUB 127               \ Control codes map to themselves

