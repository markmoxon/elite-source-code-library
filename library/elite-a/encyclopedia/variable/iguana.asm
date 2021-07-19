\ ******************************************************************************
\
\       Name: iguana
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Iguana
\
\ ******************************************************************************

.iguana

 EQUB 1                 \ 1: Inservice date:  "3095 ({single cap}FAULCON
 EQUS "3095"            \                      MANSPACE)"
 CTOK 85                \
 EQUS "Faulc"           \ Encoded as:         "3095[85]Faulc<223> <239>n[77])"
 ETWO 'O', 'N'
 EQUS " "
 ETWO 'M', 'A'
 EQUS "n"
 CTOK 77
 EQUS ")"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:         "6"

 EQUB 3                 \ 3: Dimensions:      "65/20/40FT"
 EQUS "65/20/40"        \
 CTOK 42                \ Encoded as:         "65/20/40[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.33{all caps}LM{sentence case}"
 EQUS "0.33"            \
 CTOK 64                \ Encoded as:         "0.33[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1-3"
 EQUS "1-3"             \
 EQUB 0                 \ Encoded as:         "1-3"

 EQUB 6                 \ 6: Range:           "7.5{all caps}LY{sentence case}"
 EQUS "7.5"             \
 CTOK 63                \ Encoded as:         "7.5[63]"
 EQUB 0

 EQUB 7                 \ 7: Cargo space:     "15{all caps}TC{sentence case}"
 EQUS "15"              \
 CTOK 62                \ Encoded as:         "15[62]"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "LANCE & FERMAN LASER{cr}
 CTOK 57                \                      SEEKER X1 MISSILES"
 CTOK 49                \
 EJMP 12                \ Encoded as:         "[57][49]{12}[54]<244> X1[46]"
 CTOK 54
 ETWO 'E', 'R'
 EQUS " X1"
 CTOK 46
 EQUB 0

 EQUB 9                 \ 9: Hull:            "G6-20{all caps}/4L{sentence
 EQUS "G6-20"           \                      case}"
 CTOK 84                \
 EQUB 0                 \ Encoded as:         "G6-20[84]"

 EQUB 10                \ 10: Drive motors:   "DE{single cap}LACY SUPER
 CTOK 71                \                       THRUST{cr}
 EQUS " Sup"            \                      {all caps}VC{sentence case}9"
 ETWO 'E', 'R'          \
 EQUS " "               \ Encoded as:         "[71] Sup<244> [66]{12}{all caps}V
 CTOK 66                \                      C{sentence case}9"
 EJMP 12
 EJMP 1
 EQUS "VC"
 EJMP 2
 EQUS "9"
 EQUB 0

 EQUB 0

