\ ******************************************************************************
\
\       Name: thargoid
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Thargoid
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.thargoid

 EQUB 2                 \ 2: Combat factor:   "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:         "6"

 EQUB 3                 \ 3: Dimensions:      "180/40/180FT"
 EQUS "180/40/180"      \
 CTOK 42                \ Encoded as:         "180/40/180[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.39{all caps}LM{sentence case}"
 EQUS "0.39"            \
 CTOK 64                \ Encoded as:         "0.39[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "50"
 EQUS "50"              \
 EQUB 0                 \ Encoded as:         "50"

 EQUB 6                 \ 6: Range:           "UNKNOWN"
 EQUS "Unk"             \
 ETWO 'N', 'O'          \ Encoded as:         "Unk<227>wn"
 EQUS "wn"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "WIDELY VARYING"
 EQUS "Widely v"        \
 ETWO 'A', 'R'          \ Encoded as:         "Widely v<238>y<240>g"
 EQUS "y"
 ETWO 'I', 'N'
 EQUS "g"
 EQUB 0

\EQUB 9                 \ This data is commented out in the original source
\EQUS "Unk"             \
\TWOK 'N', 'O'          \ It would show the hull as "UNKNOWN"
\EQUS "wn"
\EQUB 0

 EQUB 10                \ 10: Drive motors:   "THARGOID INVENTION"
 CTOK 30                \
 EQUS " "               \ Encoded as:         "[30] [68]"
 CTOK 68
 EQUB 0

 EQUB 0

