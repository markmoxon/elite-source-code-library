\ ******************************************************************************
\
\       Name: boa
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Boa
\
\ ******************************************************************************

.boa

 EQUB 1                 \ Inservice date: "3017 ({single cap}GEREGE FEDERATION)"
 EQUS "3017"            \
 CTOK 85                \ Encoded as:     "3017[85]<231><242><231> [76])"
 ETWO 'G', 'E'
 ETWO 'R', 'E'
 ETWO 'G', 'E'
 EQUS " "
 CTOK 76
 EQUS ")"
 EQUB 0

 EQUB 2                 \ Combat factor:  "4"
 EQUS "4"               \
 EQUB 0                 \ Encoded as:     "4"

 EQUB 3                 \ Dimensions:     "115/60/65FT"
 EQUS "115/60/65"       \
 CTOK 42                \ Encoded as:     "115/60/65[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.24{all caps}LM{sentence case}"
 EQUS "0.24"            \
 CTOK 64                \ Encoded as:     "0.24[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "2-6"
 EQUS "2-6"             \
 EQUB 0                 \ Encoded as:     "2-6"

 EQUB 6                 \ Range:          "9{all caps}LY{sentence case}"
 EQUS "9"               \
 CTOK 63                \ Encoded as:     "9[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "125{all caps}TC{sentence case}"
 EQUS "125"             \
 CTOK 62                \ Encoded as:     "125[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      "ERGON LASER SYSTEM{cr}
 CTOK 52                \                  {all caps}IFS{sentence case} SEEK &
 CTOK 49                \                  HUNT MISSILES"
 CTOK 51                \
 EJMP 12                \ Encoded as:     "[52][49][51]{12}[86][54] & [79][46]"
 CTOK 86
 CTOK 54
 EQUS " & "
 CTOK 79
 CTOK 46
 EQUB 0

 EQUB 9                 \ Hull:           "J7-24{all caps}/2L{sentence case}"
 EQUS "J7-24"           \
 CTOK 83                \ Encoded as:     "J7-24[83]"
 EQUB 0

 EQUB 10                \ Drive motors:   "{all caps}4*C40KV{sentence case} AMES
 CTOK 72                \                  DRIVE{cr}
 EJMP 12                \                  SEEKLIGHT THRUSTERS"
 CTOK 54                \
 CTOK 55                \ Encoded as:     "[72]{12}[54][55] [66]<244>s"
 EQUS " "
 CTOK 66
 ETWO 'E', 'R'
 EQUS "s"
 EQUB 0

 EQUB 0

