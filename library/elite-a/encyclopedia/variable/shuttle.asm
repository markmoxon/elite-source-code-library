\ ******************************************************************************
\
\       Name: shuttle
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Shuttle
\
\ ******************************************************************************

.shuttle

 EQUB 1                 \ 1: Inservice date:  "2856 ({single cap}SAUD-{single
 EQUS "2856"            \                      cap}KRUGER ASTRO)"
 CTOK 85                \
 EQUS "Saud-"           \ Encoded as:         "2856[85]Saud-[58]A<222>ro)"
 CTOK 58
 EQUS "A"
 ETWO 'S', 'T'
 EQUS "ro)"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "4"
 EQUS "4"               \
 EQUB 0                 \ Encoded as:         "4"

 EQUB 3                 \ 3: Dimensions:      "35/20/20FT"
 EQUS "35/20/20"        \
 CTOK 42                \ Encoded as:         "35/20/20[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.08{all caps}LM{sentence case}"
 EQUS "0.08"            \
 CTOK 64                \ Encoded as:         "0.08[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "2"
 EQUS "2"               \
 EQUB 0                 \ Encoded as:         "2"

 EQUB 7                 \ 7: Cargo space:     "60{all caps}TC{sentence case}"
 EQUS "60"              \
 CTOK 62                \ Encoded as:         "60[62]"
 EQUB 0

 EQUB 10                \ 10: Drive motors:   "V & K 20.20{cr}
 CTOK 73                \                      STARMAT DRIVE"
 EQUS "20.20"           \
 EJMP 12                \ Encoded as:         "[73]20.20{12}<222><238><239>t
 ETWO 'S', 'T'          \                       [53]"
 ETWO 'A', 'R'
 ETWO 'M', 'A'
 EQUS "t "
 CTOK 53
 EQUB 0

 EQUB 0

