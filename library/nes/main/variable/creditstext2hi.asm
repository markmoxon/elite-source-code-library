\ ******************************************************************************
\
\       Name: creditsText2Hi
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the high byte of the address of the creditsText2
\             text for each language
\
\ ******************************************************************************

.creditsText2Hi

 EQUB HI(creditsText2)  \ English

 EQUB HI(creditsText2)  \ German

 EQUB HI(creditsText2)  \ French

 EQUB HI(creditsText2)  \ There is no fourth language, so this byte is ignored

