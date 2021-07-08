\ ******************************************************************************
\
\       Name: sidewinder
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Sidewinder
\
\ ******************************************************************************

.sidewinder

 EQUB 1                 \ Inservice date: "2982 ({single cap}ONRIRA ORBITAL)"
 EQUS "2982"            \
 CTOK 85                \ Encoded as:     "2982[85]<223>ri<248> <253>b<219>
 ETWO 'O', 'N'          \                  <228>)"
 EQUS "ri"
 ETWO 'R', 'A'
 EQUS " "
 ETWO 'O', 'R'
 EQUS "b"
 ETWO 'I', 'T'
 ETWO 'A', 'L'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ Combat factor:  "9"
 EQUS "9"               \
 EQUB 0                 \ Encoded as:     "9"

 EQUB 3                 \ Dimensions:     "35/15/65FT"
 EQUS "35/15/65"        \
 CTOK 42                \ Encoded as:     "35/15/65[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.37{all caps}LM{sentence case}"
 EQUS "0.37"            \
 CTOK 64                \ Encoded as:     "0.37[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1"
 EQUS "1"               \
 EQUB 0                 \ Encoded as:     "1"

 EQUB 8                 \ Armaments:      "DUAL 22-18 LASER"
 EQUS "Du"              \
 ETWO 'A', 'L'          \ Encoded as:     "Du<228> 22-18[49]"
 EQUS " 22-18"
 CTOK 49
 EQUB 0

\EQUB 0, 9              \ This data is commented out in the orginal source
\EQUA "3|!R"

 EQUB 10                \ Drive motors:   "DE{single cap}LACY SPIN{single cap}
 CTOK 71                \                  IONIC {all caps}MV{sentence case}"
 EQUS " Sp"             \
 ETWO 'I', 'N'          \ Encoded as:     "[71] Sp<240>[78] {all caps}MV
 CTOK 78                \                  {sentence case}"
 EQUS " "
 EJMP 1
 EQUS "MV"
 EJMP 2
 EQUB 0

 EQUB 0

