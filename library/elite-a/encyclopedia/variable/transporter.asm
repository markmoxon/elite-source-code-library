\ ******************************************************************************
\
\       Name: transporter
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Transporter
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.transporter

 EQUB 1                 \ 1: Inservice date:  "PRE-2500 ({single cap}SPACELINK
 EQUS "p"               \                      SHIPYARDS)"
 ETWO 'R', 'E'          \
 EQUS "-2500"           \ Encoded as:         "p<242>-2500[85][77]L<240>k[67]y
 CTOK 85                \                      <238>ds)"
 CTOK 77
 EQUS "L"
 ETWO 'I', 'N'
 EQUS "k"
 CTOK 67
 EQUS "y"
 ETWO 'A', 'R'
 EQUS "ds)"
 EQUB 0

 EQUB 3                 \ 3: Dimensions:      "35/10/30FT"
 EQUS "35/10/30"        \
 CTOK 42                \ Encoded as:         "35/10/30[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.10{all caps}LM{sentence case}"
 EQUS "0.10"            \
 CTOK 64                \ Encoded as:         "0.10[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "5"
 EQUS "5"               \
 EQUB 0                 \ Encoded as:         "5"

 EQUB 7                 \ 7: Cargo space:     "10{all caps}TC{sentence case}"
 EQUS "10"              \
 CTOK 62                \ Encoded as:         "10[62]"
 EQUB 0

 EQUB 0

