\ ******************************************************************************
\
\       Name: JMPTAB
\       Type: Variable
\   Category: Text
\    Summary: The lookup table for OSWRCH jump commands (128-147)
\
\ ------------------------------------------------------------------------------
\
\ Once they have finished, routines in this table should reset WRCHV to point
\ back to USOSWRCH again by calling the PUTBACK routine with a JMP as their last
\ instruction.
\
\ ******************************************************************************

.JMPTAB

 EQUW USOSWRCH          \              128 (&80)     0 = Put back to USOSWRCH
 EQUW BEGINLIN          \              129 (&81)     1 = Begin drawing a line
 EQUW ADDBYT            \              130 (&82)     2 = Add line byte/draw line
 EQUW DOFE21            \ #DOFE21    = 131 (&83)     3 = Show energy bomb effect
 EQUW DOHFX             \ #DOhfx     = 132 (&84)     4 = Show hyperspace colours
 EQUW SETXC             \ #SETXC     = 133 (&85)     5 = Set text cursor column
 EQUW SETYC             \ #SETYC     = 134 (&86)     6 = Set text cursor row
 EQUW CLYNS             \ #clyns     = 135 (&87)     7 = Clear bottom of screen
 EQUW RDPARAMS          \ #RDPARAMS  = 136 (&88)     8 = Reset dashboard params
 EQUW ADPARAMS          \              137 (&89)     9 = Add dashboard parameter
 EQUW DODIALS           \ #DODIALS   = 138 (&8A)    10 = Hide dials on death
 EQUW DOVIAE            \ #VIAE      = 139 (&8B)    11 = Set 6522 System VIA IER
 EQUW DOBULB            \ #DOBULB    = 140 (&8C)    12 = Toggle dashboard bulb
 EQUW DOCATF            \ #DOCATF    = 141 (&8D)    13 = Set disc catalogue flag
 EQUW DOCOL             \ #SETCOL    = 142 (&8E)    14 = Set the current colour
 EQUW SETVDU19          \ #SETVDU19  = 143 (&8F)    15 = Change mode 1 palette
 EQUW DOSVN             \ #DOsvn     = 144 (&90)    16 = Set file saving flag
 EQUW DOBRK             \              145 (&91)    17 = Execute BRK instruction
 EQUW printer           \ #printcode = 146 (&92)    18 = Write to printer/screen
 EQUW prilf             \ #prilf     = 147 (&93)    19 = Blank line on printer

