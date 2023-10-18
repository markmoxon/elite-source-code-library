\ ******************************************************************************
\
\       Name: saveHeader2Lo
\       Type: Variable
\   Category: Save and load
\    Summary: Lookup table for the low byte of the address of the saveHeader2
\             text for each language
\
\ ******************************************************************************

.saveHeader2Lo

 EQUB LO(saveHeader2_EN)    \ English

 EQUB LO(saveHeader2_DE)    \ German

 EQUB LO(saveHeader2_FR)    \ French

