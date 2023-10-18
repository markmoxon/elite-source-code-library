\ ******************************************************************************
\
\       Name: creditsText3Hi
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the high byte of the address of the creditsText3
\             text for each language
\
\ ******************************************************************************

.creditsText3Hi

 EQUB HI(creditsText3)  \ English

 EQUB HI(creditsText3)  \ German

 EQUB HI(creditsText3)  \ French

 EQUB HI(creditsText3)  \ There is no fourth language, so this byte is ignored

