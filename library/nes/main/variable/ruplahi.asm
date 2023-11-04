\ ******************************************************************************
\
\       Name: ruplaHi
\       Type: Variable
\   Category: Text
\    Summary: Address lookup table for the RUPLA text token table in three
\             different languages (high byte)
\
\ ******************************************************************************

.ruplaHi

 EQUB HI(RUPLA - 1)     \ English

 EQUB HI(RUPLA_DE - 1)  \ German

 EQUB HI(RUPLA_FR - 1)  \ French

 EQUB &AB               \ There is no fourth language, so this byte is ignored

