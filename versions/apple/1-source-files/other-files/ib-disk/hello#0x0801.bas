10  TEXT : HOME
20  PRINT  CHR$ (4);"BLOAD ELITEPIC,A$2000"
30  POKE 49234,0: POKE 49232,0: POKE 49239,0
40  POKE  - 16255,0: POKE  - 16255,0
50  PRINT  CHR$ (4);"BLOAD NINE,A$D000"
60  POKE  - 16254,0
70  PRINT  CHR$ (4);"BLOAD FOUR,A$4000"
80  PRINT  CHR$ (4);"BLOAD BEE,A$B00"
90  PRINT  CHR$ (4);"BRUN MOVER,A$300"
