\ ******************************************************************************
\
\       Name: LIJT8
\       Type: Variable
\   Category: Drawing lines
\    Summary: Addresses for modifying the high byte of the JMP instruction at
\             LI92 to support the unrolled algorithm in part 4 of LOIN
\
\ ******************************************************************************

.LIJT8

 EQUB HI(LI21+6)
 EQUB HI(LI22+6)
 EQUB HI(LI23+6)
 EQUB HI(LI24+6)
 EQUB HI(LI25+6)
 EQUB HI(LI26+6)
 EQUB HI(LI27+6)
 EQUB HI(LI28+6)

