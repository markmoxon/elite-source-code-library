\ ******************************************************************************
\
\       Name: rugalLo
\       Type: Variable
\   Category: Text
\    Summary: Address lookup table for the RUGAL text token table in three
\             different languages (low byte)
\
\ ******************************************************************************

.rugalLo

 EQUB LO(RUGAL - 1)     \ English

 EQUB LO(RUGAL_DE - 1)  \ German

 EQUB LO(RUGAL_FR - 1)  \ French

 EQUB &5A               \ There is no fourth language, so this byte is ignored

