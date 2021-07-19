\ ******************************************************************************
\
\       Name: worm
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Worm
\
\ ******************************************************************************

.worm

 EQUB 1                 \ 1: Inservice date:  "3101"
 EQUS "3101"            \
 EQUB 0                 \ Encoded as:         "3101"

 EQUB 2                 \ 2: Combat factor:   "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:         "6"

 EQUB 3                 \ 3: Dimensions:      "35/12/35FT"
 EQUS "35/12/35"        \
 CTOK 42                \ Encoded as:         "35/12/35[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.23{all caps}LM{sentence case}"
 EQUS "0.23"            \
 CTOK 64                \ Encoded as:         "0.23[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1"
 EQUS "1"               \
 EQUB 0                 \ Encoded as:         "1"

 EQUB 8                 \ 8: Armaments:       "INGRAM PULSE LASER"
 CTOK 56                \
 CTOK 50                \ Encoded as:         "[56][50][49]"
 CTOK 49
 EQUB 0

\EQUB 9                 \ This data is commented out in the original source
\EQUS "3"               \
\CTOK 82                \ It would show the hull as "3{all caps}/1L{sentence
\EQUB 0                 \ case}"

 EQUB 10                \ 10: Drive motors:   "SEEKLIGHT {all caps}HV{sentence
 CTOK 54                \                      case} THRUST"
 CTOK 55                \
 EQUS " "               \ Encoded as:         "[54][55] {all caps}HV{sentence
 EJMP 1                 \                      case} [66]"
 EQUS "HV"
 EJMP 2
 EQUS " "
 CTOK 66
 EQUB 0

 EQUB 0

