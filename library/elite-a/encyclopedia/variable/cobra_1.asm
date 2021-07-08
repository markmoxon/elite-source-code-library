\ ******************************************************************************
\
\       Name: cobra_1
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Cobra Mk I
\
\ ******************************************************************************

.cobra_1

 EQUB 1                 \ Inservice date: "2855 ({single cap}PAYNOU, PROSSET &
 EQUS "2855"            \                  SALEM)"
 CTOK 85                \
 EQUS "Payn"            \ Encoded as:     "2855[85]Payn[89], [80]& S<228>em)"
 ETWO 'O', 'U'
 EQUS ", "
 CTOK 80
 EQUS "& S"
 ETWO 'A', 'L'
 EQUS "em)"
 EQUB 0

 EQUB 2                 \ Combat factor:  "5"
 EQUS "5"               \
 EQUB 0                 \ Encoded as:     "5"

 EQUB 3                 \ Dimensions:     "55/15/70FT"
 EQUS "55/15/70"        \
 CTOK 42                \ Encoded as:     "55/15/70[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.26{all caps}LM{sentence case}"
 EQUS "0.26"            \
 CTOK 64                \ Encoded as:     "0.26[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1"
 EQUS "1"               \
 EQUB 0                 \ Encoded as:     "1"

 EQUB 6                 \ Range:          "6{all caps}LY{sentence case}"
 EQUS "6"               \
 CTOK 63                \ Encoded as:     "6[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "10{all caps}TC{sentence case}"
 EQUS "10"              \
 CTOK 62                \ Encoded as:     "10[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      "HASSONI VARISCAN LASER{cr}
 CTOK 59                \                  LANCE & FERMAN MISSILES"
 EQUS " V"              \
 ETWO 'A', 'R'          \ Encoded as:     "[59] V<238>isc<255>[49]{12}[57][46]"
 EQUS "isc"
 ETWO 'A', 'N'
 CTOK 49
 EJMP 12
 CTOK 57
 CTOK 46
 EQUB 0

 EQUB 9                 \ Hull:           "E4-20{all caps}/4L{sentence case}"
 EQUS "E4-20"           \
 CTOK 84                \ Encoded as:     "E4-20[84]"
 EQUB 0

 EQUB 10                \ Drive motors:   "PROSSET DRIVE"
 CTOK 80                \
 CTOK 53                \ Encoded as:     "[80][53]"
 EQUB 0

 EQUB 0

