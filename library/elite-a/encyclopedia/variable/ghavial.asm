\ ******************************************************************************
\
\       Name: ghavial
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Ghavial
\
\ ******************************************************************************

.ghavial

 EQUB 1                 \ Inservice date: "3077 ({single cap}ARDEN
 EQUS "3077"            \                  CO-OPERATIVE)"
 CTOK 85                \
 ETWO 'A', 'R'          \ Encoded as:     "3077[85]<238>d<246> Co-op<244>a<251>
 EQUS "d"               \                  <250>)"
 ETWO 'E', 'N'
 EQUS " Co-op"
 ETWO 'E', 'R'
 EQUS "a"
 ETWO 'T', 'I'
 ETWO 'V', 'E'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ Combat factor:  "5"
 EQUS "5"               \
 EQUB 0                 \ Encoded as:     "5"

 EQUB 3                 \ Dimensions:     "80/30/60FT"
 EQUS "80/30/60"        \
 CTOK 42                \ Encoded as:     "80/30/60[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.25{all caps}LM{sentence case}"
 EQUS "0.25"            \
 CTOK 64                \ Encoded as:     "0.25[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "2-7"
 EQUS "2-7"             \
 EQUB 0                 \ Encoded as:     "2-7"

 EQUB 6                 \ Range:          "8{all caps}LY{sentence case}"
 EQUS "8"               \
 CTOK 63                \ Encoded as:     "8[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "50{all caps}TC{sentence case}"
 EQUS "50"              \
 CTOK 62                \ Encoded as:     "50[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      "FAIREY PULSE LASER{cr}
 EQUS "Fai"             \                  LANCE & FERMAN MISSILES"
 ETWO 'R', 'E'          \
 EQUS "y"               \ Encoded as:     "Fai<242>y[50][49]{12}[57][46]"
 CTOK 50
 CTOK 49
 EJMP 12
 CTOK 57
 CTOK 46
 EQUB 0

 EQUB 9                 \ Hull:           "I5-25{all caps}/4L{sentence case}"
 EQUS "I5-25"           \
 CTOK 84                \ Encoded as:     "I5-25[84]"
 EQUB 0

 EQUB 10                \ Drive motors:   "SPALDER & PRIME {all caps}TT1
 EQUS "Sp"              \                  {sentence case}"
 ETWO 'A', 'L'          \
 EQUS "d"               \ Encoded as:     "Sp<228>d<244> & Prime {all caps}TT1
 ETWO 'E', 'R'          \                  {sentence case}"
 EQUS " & Prime "
 EJMP 1
 EQUS "TT1"
 EJMP 2
 EQUB 0

 EQUB 0

