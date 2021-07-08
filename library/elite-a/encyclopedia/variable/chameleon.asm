\ ******************************************************************************
\
\       Name: chameleon
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Chameleon
\
\ ******************************************************************************

.chameleon

 EQUB 1                 \ Inservice date: "3122 ({single cap}ARDEN
 EQUS "3122"            \                  CO-OPERATIVE)"
 CTOK 85                \
 ETWO 'A', 'R'          \ Encoded as:     "3122[85]<238>d<246> Co-op<244>a<251>
 EQUS "d"               \                  <250>)"
 ETWO 'E', 'N'
 EQUS " Co-op"
 ETWO 'E', 'R'
 EQUS "a"
 ETWO 'T', 'I'
 ETWO 'V', 'E'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ Combat factor:  "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:     "6"

 EQUB 3                 \ Dimensions:     "75/24/40FT"
 EQUS "75/24/40"        \
 CTOK 42                \ Encoded as:     "75/24/40[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.29{all caps}LM{sentence case}"
 EQUS "0.29"            \
 CTOK 64                \ Encoded as:     "0.29[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1-4"
 EQUS "1-4"             \
 EQUB 0                 \ Encoded as:     "1-4"

 EQUB 6                 \ Range:          "8{all caps}LY{sentence case}"
 EQUS "8"               \
 CTOK 63                \ Encoded as:     "8[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "30{all caps}TC{sentence case}"
 EQUS "30"              \
 CTOK 62                \ Encoded as:     "30[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      "INGRAM MEGABLAST PULSE LASER{cr}
 CTOK 56                \                  SEEKER X3 MISSILES"
 EQUS " Mega"           \
 CTOK 74                \ Encoded as:     "[56] Mega[74][50][49]{12}[54]<244> X3
 CTOK 50                \                  [46]"
 CTOK 49
 EJMP 12
 CTOK 54
 ETWO 'E', 'R'
 EQUS " X3"
 CTOK 46
 EQUB 0

 EQUB 9                 \ Hull:           "H5-23{all caps}/2L{sentence case}"
 EQUS "H5-23"           \
 CTOK 83                \ Encoded as:     "H5-23[83]"
 EQUB 0

 EQUB 10                \ Drive motors:   "VOLTAIRE STINGER{cr}
 CTOK 60                \                  PULSEDRIVE"
 EQUS " "               \
 ETWO 'S', 'T'          \ Encoded as:     "[60] <222><240>g<244>{12}Pul<218>
 ETWO 'I', 'N'          \                  [53]"
 EQUS "g"
 ETWO 'E', 'R'
 EJMP 12
 EQUS "Pul"
 ETWO 'S', 'E'
 CTOK 53
 EQUB 0

 EQUB 0

