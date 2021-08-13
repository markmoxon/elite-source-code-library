\ ******************************************************************************
\
\       Name: cobra_3
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Cobra Mk III
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.cobra_3

 EQUB 1                 \ 1: Inservice date:  "3100 ({single cap}COWELL &
 EQUS "3100"            \                      MG{all caps}RATH, LAVE)"
 CTOK 85                \
 EQUS "Cowell & Mg"     \ Encoded as:         "3100[85]Cowell & Mg{single cap}
 EJMP 19                \                      <248><226>, <249><250>)"
 ETWO 'R', 'A'
 ETWO 'T', 'H'
 EQUS ", "
 ETWO 'L', 'A'
 ETWO 'V', 'E'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "7"
 EQUS "7"               \
 EQUB 0                 \ Encoded as:         "7"

 EQUB 3                 \ 3: Dimensions:      "65/30/130FT"
 EQUS "65/30/130"       \
 CTOK 42                \ Encoded as:         "65/30/130[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.28{all caps}LM{sentence case}"
 EQUS "0.28"            \
 CTOK 64                \ Encoded as:         "0.28[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1-3"
 EQUS "1-3"             \
 EQUB 0                 \ Encoded as:         "1-3"

 EQUB 6                 \ 6: Range:           "7{all caps}LY{sentence case}"
 EQUS "7"               \
 CTOK 63                \ Encoded as:         "7[63]"
 EQUB 0

 EQUB 7                 \ 7: Cargo space:     "35{all caps}TC{sentence case}"
 EQUS "35"              \
 CTOK 62                \ Encoded as:         "35[62]"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "INGRAM LASER SYSTEM{cr}
 CTOK 56                \                      LANCE & FERMAN MISSILES"
 CTOK 49                \
 CTOK 51                \ Encoded as:         "[56][49][51]{12}[57][46]"
 EJMP 12
 CTOK 57
 CTOK 46
 EQUB 0

 EQUB 9                 \ 9: Hull:            "G7-24{all caps}/4L{sentence
 EQUS "G7-24"           \                      case}"
 CTOK 84                \
 EQUB 0                 \ Encoded as:         "G7-24[84]"

 EQUB 10                \ 10: Drive motors:   "{single cap}KRUGER LIGHTFAST{cr}
 CTOK 58                \                      IRRIKAN THRUSPACE"
 CTOK 55                \
 EQUS "fa"              \ Encoded as:         "[58][55]fa<222>{12}Irrik<255> Thr
 ETWO 'S', 'T'          \                      u[77]"
 EJMP 12
 EQUS "Irrik"
 ETWO 'A', 'N'
 EQUS " Thru"
 CTOK 77
 EQUB 0

 EQUB 0

