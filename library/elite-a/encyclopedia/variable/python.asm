\ ******************************************************************************
\
\       Name: python
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Python
\
\ ******************************************************************************

.python

 EQUB 1                 \ Inservice date: "2700 ({single cap}WHATT & PRITNEY
 EQUS "2700"            \                  SC)"
 CTOK 85                \
 EQUS "Wh"              \ Encoded as:     "2700[85]Wh<245>t & Pr<219>ney SC)"
 ETWO 'A', 'T'
 EQUS "t & Pr"
 ETWO 'I', 'T'
 EQUS "ney SC)"
 EQUB 0

 EQUB 2                 \ Combat factor:  "3"
 EQUS "3"               \
 EQUB 0                 \ Encoded as:     "3"

 EQUB 3                 \ Dimensions:     "130/40/80FT"
 EQUS "130/40/80"       \
 CTOK 42                \ Encoded as:     "130/40/80[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.20{all caps}LM{sentence case}"
 EQUS "0.20"            \
 CTOK 64                \ Encoded as:     "0.20[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "2-9"
 EQUS "2-9"             \
 EQUB 0                 \ Encoded as:     "2-9"

 EQUB 6                 \ Range:          "8{all caps}LY{sentence case}"
 EQUS "8"               \
 CTOK 63                \ Encoded as:     "8[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "100{all caps}TC{sentence case}"
 EQUS "100"             \
 CTOK 62                \ Encoded as:     "100[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      "VOLT-{all caps}VARISCAN PULSE LASER"
 EQUS "Volt-"           \
 EJMP 19                \ Encoded as:     "Volt-{single cap}V<238>isc<255>[50]
 EQUS "V"               \                  [49]"
 ETWO 'A', 'R'
 EQUS "isc"
 ETWO 'A', 'N'
 CTOK 50
 CTOK 49
 EQUB 0

 EQUB 9                 \ Hull:           "K6-27{all caps}/4L{sentence case}"
 EQUS "K6-27"           \
 CTOK 84                \ Encoded as:     "K6-27[84]"
 EQUB 0

 EQUB 10                \ Drive motors:   "{all caps}4*C40KV{sentence case} AMES
 CTOK 72                \                  DRIVE{cr}
 EJMP 12                \                  EXLON 76NN MODEL"
 EQUS "Exl"             \
 ETWO 'O', 'N'          \ Encoded as:     "[72]{12}Exl<223> 76NN Model"
 EQUS " 76NN Model"
 EQUB 0

 EQUB 0

