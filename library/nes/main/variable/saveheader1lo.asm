\ ******************************************************************************
\
\       Name: saveHeader1Lo
\       Type: Variable
\   Category: Save and load
\    Summary: Lookup table for the low byte of the address of the saveHeader1
\             text for each language
\
\ ******************************************************************************

.saveHeader1Lo

 EQUB LO(saveHeader1_EN)    \ English

 EQUB LO(saveHeader1_DE)    \ German

 EQUB LO(saveHeader1_FR)    \ French

