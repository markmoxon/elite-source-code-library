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
                        \   " to $      so that maps À to à in the game font
                        \   # to /      so that maps Ô to ô in the game font
                        \   < to %      so that maps É to é in the game font
                        \   = to *      so that maps È to è in the game font
                        \   @ to `      so that maps Ç to ç in the game font

 EQUS "abcdefghijklm"   \ Capital letters map to their lower case equivalents
 EQUS "nopqrstuvwxyz"

 EQUS "{|};+`"          \ These punctuation characters map to themselves apart
                        \ from the following (ASCII on left, NES on right):
                        \
                        \   [ to {      so that maps Ä to ä in the game font
                        \   \ to |      so that maps Ö to ö in the game font
                        \   ] to }      so that maps Ü to ü in the game font
                        \   ^ to ;      so that maps ß to ß in the game font
                        \   _ to +      so that maps Ê to ê in the game font

 EQUS "abcdefghijklm"   \ Lower case characters map to themselves
 EQUS "nopqrstuvwxyz"

 EQUS "{|}~"            \ These punctuation characters map to themselves

 EQUB 127               \ Control codes map to themselves

