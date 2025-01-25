\ ******************************************************************************
\
\       Name: dialc1
\       Type: Variable
\   Category: Dashboard
\    Summary: The colour for each indicator for values that are below the
\             threshold in dialle
\
\ ------------------------------------------------------------------------------
\
\ A colour value of &FF represents the colour red, or flashing red-and-white if
\ flashing colours are configured.
\
\ ******************************************************************************

.dialc1

 EQUB WHITE             \  0 = Speed indicator
 EQUB WHITE             \  1 = Roll indicator
 EQUB WHITE             \  2 = Pitch indicator
 EQUB &FF               \  3 = Energy bank 4 (bottom)
 EQUB VIOLET            \  4 = Energy bank 3
 EQUB VIOLET            \  5 = Energy bank 2
 EQUB VIOLET            \  6 = Energy bank 1 (top)
 EQUB &FF               \  7 = Forward shield indicator
 EQUB &FF               \  8 = Aft shield indicator
 EQUB GREEN             \  9 = Fuel level indicator
 EQUB &FF               \ 10 = Altitude indicator
 EQUB BLUE              \ 11 = Cabin temperature indicator
 EQUB BLUE              \ 12 = Laser temperature indicator

