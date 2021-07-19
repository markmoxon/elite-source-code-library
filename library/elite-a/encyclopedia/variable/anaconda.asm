\ ******************************************************************************
\
\       Name: anaconda
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Anaconda
\
\ ******************************************************************************

.anaconda

 EQUB 1                 \ 1: Inservice date:  "2856 ({single cap}RIMLINER
 EQUS "2856"            \                      GALACTIC)"
 CTOK 85                \
 EQUS "Riml"            \ Encoded as:         "2856[85]Riml<240><244> G<228>ac
 ETWO 'I', 'N'          \                      <251>c)"
 ETWO 'E', 'R'
 EQUS " G"
 ETWO 'A', 'L'
 EQUS "ac"
 ETWO 'T', 'I'
 EQUS "c)"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "3"
 EQUS "3"               \
 EQUB 0                 \ Encoded as:         "3"

 EQUB 3                 \ 3: Dimensions:      "170/60/75FT"
 EQUS "170/60/75"       \
 CTOK 42                \ Encoded as:         "170/60/75[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.14{all caps}LM{sentence case}"
 EQUS "0.14"            \
 CTOK 64                \ Encoded as:         "0.14[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "2-10"
 EQUS "2-10"            \
 EQUB 0                 \ Encoded as:         "2-10"

 EQUB 6                 \ 6: Range:           "10{all caps}LY{sentence case}"
 EQUS "10"              \
 CTOK 63                \ Encoded as:         "10[63]"
 EQUB 0

 EQUB 7                 \ 7: Cargo space:     "245{all caps}TC{sentence case}"
 EQUS "245"             \
 CTOK 62                \ Encoded as:         "245[62]"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "HASSONI HI-RAD PULSE LASER{cr}
 CTOK 59                \                      GERET STARSEEKER MISSILES"
 EQUS " Hi-"            \
 ETWO 'R', 'A'          \ Encoded as:         "[59] Hi-<248>d[50][49]{12}[48]
 EQUS "d"               \                      [46]"
 CTOK 50
 CTOK 49
 EJMP 12
 CTOK 48
 CTOK 46
 EQUB 0

 EQUB 9                 \ 9: Hull:            "M8-**{all caps}/4L{sentence
 EQUS "M8-**"           \                      case}"
 CTOK 84                \
 EQUB 0                 \ Encoded as:         "M8-**[84]"

 EQUB 10                \ 10: Drive motors:   "V & K 32.24{cr}
 CTOK 73                \                      ERGMASTERS"
 EQUS "32.24"           \
 EJMP 12                \ Encoded as:         "[73]32.24{12}<244>g<239><222>
 ETWO 'E', 'R'          \                      <244>s"
 EQUS "g"
 ETWO 'M', 'A'
 ETWO 'S', 'T'
 ETWO 'E', 'R'
 EQUS "s"
 EQUB 0

 EQUB 0

