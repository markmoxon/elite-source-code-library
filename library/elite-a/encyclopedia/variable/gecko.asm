\ ******************************************************************************
\
\       Name: gecko
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Gecko
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.gecko

 EQUB 1                 \ 1: Inservice date:  "2852 ({single cap}ACE & FABER,
 EQUS "2852"            \                      LERELACE)"
 CTOK 85                \
 EQUS "A"               \ Encoded as:         "2852[85]A<233> & F[88]<244>,
 ETWO 'C', 'E'          \                       <229><242><249><233>)"
 EQUS " & F"
 ETWO 'A', 'B'
 ETWO 'E', 'R'
 EQUS ", "
 ETWO 'L', 'E'
 ETWO 'R', 'E'
 ETWO 'L', 'A'
 ETWO 'C', 'E'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "7"
 EQUS "7"               \
 EQUB 0                 \ Encoded as:         "7"

 EQUB 3                 \ 3: Dimensions:      "40/12/65FT"
 EQUS "40/12/65"        \
 CTOK 42                \ Encoded as:         "40/12/65[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.30{all caps}LM{sentence case}"
 EQUS "0.30"            \
 CTOK 64                \ Encoded as:         "0.30[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1-2"
 EQUS "1-2"             \
 EQUB 0                 \ Encoded as:         "1-2"

 EQUB 6                 \ 6: Range:           "7{all caps}LY{sentence case}"
 EQUS "7"               \
 CTOK 63                \ Encoded as:         "7[63]"
 EQUB 0

 EQUB 7                 \ 7: Cargo space:     "3{all caps}TC{sentence case}"
 EQUS "3"               \
 CTOK 62                \ Encoded as:         "3[62]"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "INGRAM 1919 A4 LASER{cr}
 CTOK 56                \                      {all caps}LM{sentence case}
 EQUS " 1919 A4"        \                      HOMING MISSILES"
 CTOK 49                \
 EJMP 12                \ Encoded as:         "[56] 1919 A4[49]{12}[64] Hom<240>
 CTOK 64                \                      g[46]"
 EQUS " Hom"
 ETWO 'I', 'N'
 EQUS "g"
 CTOK 46
 EQUB 0

 EQUB 9                 \ 9: Hull:            "E6-19{all caps}/2L{sentence
 EQUS "E6-19"           \                      case}"
 CTOK 83                \
 EQUB 0                 \ Encoded as:         "E6-19[83]"

 EQUB 10                \ 10: Drive motors:   "BREAM PULSELIGHT {all caps}XL
 EQUS "B"               \                      {sentence case}"
 ETWO 'R', 'E'          \
 EQUS "am"              \ Encoded as:         "B<242>am[50][55] {all caps}XL
 CTOK 50                \                      {sentence case}"
 CTOK 55
 EQUS " "
 EJMP 1
 EQUS "XL"
 EJMP 2
 EQUB 0

 EQUB 0

