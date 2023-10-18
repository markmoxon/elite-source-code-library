\ ******************************************************************************
\
\       Name: saveHeader1Hi
\       Type: Variable
\   Category: Save and load
\    Summary: Lookup table for the high byte of the address of the saveHeader1
\             text for each language
\
\ ******************************************************************************

.saveHeader1Hi

 EQUB HI(saveHeader1_EN)    \ English

 EQUB HI(saveHeader1_DE)    \ German

 EQUB HI(saveHeader1_FR)    \ French

