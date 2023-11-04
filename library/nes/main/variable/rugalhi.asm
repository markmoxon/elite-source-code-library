\ ******************************************************************************
\
\       Name: rugalHi
\       Type: Variable
\   Category: Text
\    Summary: Address lookup table for the RUGAL text token table in three
\             different languages (high byte)
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.rugalHi

 EQUB HI(RUGAL - 1)     \ English

 EQUB HI(RUGAL_DE - 1)  \ German

 EQUB HI(RUGAL_FR - 1)  \ French

 EQUB &AB               \ There is no fourth language, so this byte is ignored

