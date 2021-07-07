\ ******************************************************************************
\
\       Name: worm
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Worm
\
\ ******************************************************************************

.worm

 EQUB 1                 \ Inservice date: "3101"
 EQUS "3101"            \
 EQUB 0                 \ Encoded as:     ""

 EQUB 2                 \ Combat factor:  "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:     "6"

 EQUB 3                 \ Dimensions:     "35/12/35FT"
 EQUS "35/12/35"        \
 CTOK 42                \ Encoded as:     "35/12/35[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.23LM"
 EQUS "0.23"            \
 CTOK 64                \ Encoded as:     "0.23[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1"
 EQUS "1"               \
 EQUB 0                 \ Encoded as:     "1"

 EQUB 8                 \ Armaments:      ""
 CTOK 56                \
 CTOK 50                \ Encoded as:     ""
 CTOK 49
 EQUB 0

\EQUB 0, 9              \ This data is commented out in the original source
\EQUA "3|!R"

 EQUB 10                \ Drive motors:   ""
 CTOK 54                \
 CTOK 55                \ Encoded as:     ""
 EQUS " "
 EQUB &01
 EQUS "HV"
 EQUB &02
 EQUS " "
 CTOK 66
 EQUB 0

 EQUB 0

