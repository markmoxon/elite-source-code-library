\ ******************************************************************************
\
\       Name: asp_2
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Asp Mk II
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.asp_2

 EQUB 1                 \ 1: Inservice date:  "2878 ({single cap}GALCOP
 EQUS "2878"            \                      WORKSHOPS)"
 CTOK 85                \
 EQUS "G"               \ Encoded as:         "2878[85]G<228>cop[81]"
 ETWO 'A', 'L'
 EQUS "cop"
 CTOK 81
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:         "6"

 EQUB 3                 \ 3: Dimensions:      "70/20/65FT"
 EQUS "70/20/65"        \
 CTOK 42                \ Encoded as:         "70/20/65[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.40{all caps}LM{sentence case}"
 EQUS "0.40"            \
 CTOK 64                \ Encoded as:         "0.40[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1"
 EQUS "1"               \
 EQUB 0                 \ Encoded as:         "1"

 EQUB 6                 \ 6: Range:           "12.5{all caps}LY{sentence case}"
 EQUS "12.5"            \
 CTOK 63                \ Encoded as:         "12.5[63]"
 EQUB 0

 EQUB 7                 \ 7: Cargo space:     "0{all caps}TC{sentence case}"
 EQUS "0"               \
 CTOK 62                \ Encoded as:         "0[62]"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "HASSONI-{single cap}KRUGER BURST
 CTOK 59                \                      LASER{cr}
 EQUS "-"               \                      GERET STARSEEKER MISSILES"
 CTOK 58                \
 EQUS "Bur"             \ Encoded as:         "[59]-[58]Bur<222>[49]{12}[48]
 ETWO 'S', 'T'          \                      [46]"
 CTOK 49
 EJMP 12
 CTOK 48
 CTOK 46
 EQUB 0

 EQUB 9                 \ 9: Hull:            "J6-31{all caps}/1L{sentence
 EQUS "J6-31"           \                      case}"
 CTOK 82                \
 EQUB 0                 \ Encoded as:         "J6-31[82]"

 EQUB 10                \ 10: Drive motors:   "VOLTAIRE WHIPLASH{cr}
 CTOK 60                \                      {all caps}HK{sentence case}
 EQUS " Whip"           \                      PULSEDRIVE"
 ETWO 'L', 'A'          \
 EQUS "sh"              \ Encoded as:         "[60] Whip<249>sh{12}{all caps}HK
 EJMP 12                \                      {sentence case} [50][53]"
 EJMP 1
 EQUS "HK"
 EJMP 2
 EQUS " "
 CTOK 50
 CTOK 53
 EQUB 0

 EQUB 0

