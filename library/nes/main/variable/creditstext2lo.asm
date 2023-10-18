\ ******************************************************************************
\
\       Name: creditsText2Lo
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the low byte of the address of the creditsText2
\             text for each language
\
\ ******************************************************************************

.creditsText2Lo

 EQUB LO(creditsText2)  \ English

 EQUB LO(creditsText2)  \ German

 EQUB LO(creditsText2)  \ French

 EQUB LO(creditsText2)  \ There is no fourth language, so this byte is ignored

