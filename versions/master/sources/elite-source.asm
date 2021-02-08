CPU 1




\ ******************************************************************************
\
\ Save output/BCODE.bin
\
\ ******************************************************************************

CODE% = &1300
LOAD% = &1300
PRINT "S.BCODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/master/output/BCODE.bin", CODE%, P%, LOAD%

