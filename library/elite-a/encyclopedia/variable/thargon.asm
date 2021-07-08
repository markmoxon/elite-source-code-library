\ ******************************************************************************
\
\       Name: thargon
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Thargon
\
\ ******************************************************************************

.thargon

 EQUB 2                 \ Combat factor:  "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:     "6"

 EQUB 3                 \ Dimensions:     "40/10/35FT"
 EQUS "40/10/35"        \
 CTOK 42                \ Encoded as:     "40/10/35[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.30{all caps}LM{sentence case}"
 EQUS "0.30"            \
 CTOK 64                \ Encoded as:     "0.30[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "NONE"
 ETWO 'N', 'O'          \
 EQUS "ne"              \ Encoded as:     "<227>ne"
 EQUB 0

 EQUB 8                 \ Armaments:      "THARGOID LASER"
 CTOK 30                \
 CTOK 49                \ Encoded as:     "[30][49]"
 EQUB 0

\EQUB 9                 \ This data is commented out in the original source
\TWOK 'N', 'O'          \
\EQUS "ne"              \ It would show the hull as "NONE"
\EQUB 0

 EQUB 10                \ Drive motors:   "THARGOID INVENTION"
 CTOK 30                \
 EQUS " "               \ Encoded as:     "[30] [68]"
 CTOK 68
 EQUB 0

 EQUB 0

