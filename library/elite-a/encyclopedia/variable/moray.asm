\ ******************************************************************************
\
\       Name: moray
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Moray
\
\ ******************************************************************************

.moray

 EQUB 1                 \ Inservice date: "3028 ({single cap}MARINE TRENCH CO.)"
 EQUS "3028"            \
 CTOK 85                \ Encoded as:     "3028[85]M<238><240>e T<242>nch Co.)"
 EQUS "M"
 ETWO 'A', 'R'
 ETWO 'I', 'N'
 EQUS "e T"
 ETWO 'R', 'E'
 EQUS "nch Co.)"
 EQUB 0

 EQUB 2                 \ Combat factor:  "7"
 EQUS "7"               \
 EQUB 0                 \ Encoded as:     "7"

 EQUB 3                 \ Dimensions:     "60/25/60FT"
 EQUS "60/25/60"        \
 CTOK 42                \ Encoded as:     "60/25/60[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.25{all caps}LM{sentence case}"
 EQUS "0.25"            \
 CTOK 64                \ Encoded as:     "0.25[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1-4"
 EQUS "1-4"             \
 EQUB 0                 \ Encoded as:     "1-4"

 EQUB 6                 \ Range:          "8{all caps}LY{sentence case}"
 EQUS "8"               \
 CTOK 63                \ Encoded as:     "8[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "7{all caps}TC{sentence case}"
 EQUS "7"               \
 CTOK 62                \ Encoded as:     "7[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      "INGRAM LASER SYSTEM{cr}
 CTOK 56                \                  GERET STARSEEKER MISSILES"
 CTOK 49                \
 CTOK 51                \ Encoded as:     "[56][49][51]{12}[48][46]"
 EJMP 12
 CTOK 48
 CTOK 46
 EQUB 0

 EQUB 9                 \ Hull:           "F4-22{all caps}/4L{sentence case}"
 EQUS "F4-22"           \
 CTOK 84                \ Encoded as:     "F4-22[84]"
 EQUB 0

 EQUB 10                \ Drive motors:   "TURBULEN QUARK{cr}RE-CHARGER 1287"
 EQUS "Turbul"          \
 ETWO 'E', 'N'          \ Encoded as:     "Turbul<246> <254><238>k{12}<242>-ch
 EQUS " "               \                  <238>g<244> 1287"
 ETWO 'Q', 'U'
 ETWO 'A', 'R'
 EQUS "k"
 EJMP 12
 ETWO 'R', 'E'
 EQUS "-ch"
 ETWO 'A', 'R'
 EQUS "g"
 ETWO 'E', 'R'
 EQUS " 1287"
 EQUB 0

 EQUB 0

