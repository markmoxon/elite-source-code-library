\ ******************************************************************************
\
\       Name: creditsText1Lo
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the low byte of the address of the creditsText1
\             text for each language
\
\ ******************************************************************************

.creditsText1Lo

 EQUB LO(creditsText1)  \ English

 EQUB LO(creditsText1)  \ German

 EQUB LO(creditsText1)  \ French

 EQUB LO(creditsText1)  \ There is no fourth language, so this byte is ignored

