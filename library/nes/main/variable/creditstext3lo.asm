\ ******************************************************************************
\
\       Name: creditsText3Lo
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the low byte of the address of the creditsText3
\             text for each language
\
\ ******************************************************************************

.creditsText3Lo

 EQUB LO(creditsText3)  \ English

 EQUB LO(creditsText3)  \ German

 EQUB LO(creditsText3)  \ French

 EQUB LO(creditsText3)  \ There is no fourth language, so this byte is ignored

