\ ******************************************************************************
\
\       Name: BDJMPTBH
\       Type: Variable
\   Category: Sound
\    Summary: A jump table containing addresses for processing music commands 1
\             through 15 (high bytes)
\  Deep dive: Music in Commodore 64 Elite
\
\ ******************************************************************************

.BDJMPTBH

 EQUB HI(BDRO1)
 EQUB HI(BDRO2)
 EQUB HI(BDRO3)
 EQUB HI(BDRO4)
 EQUB HI(BDRO5)
 EQUB HI(BDRO6)
 EQUB HI(BDRO7)
 EQUB HI(BDRO8)
 EQUB HI(BDRO9)
 EQUB HI(BDRO10)
 EQUB HI(BDRO11)
 EQUB HI(BDRO12)
 EQUB HI(BDRO13)
 EQUB HI(BDRO14)

.musicstart

 EQUB HI(BDRO15)

