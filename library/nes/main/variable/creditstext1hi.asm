\ ******************************************************************************
\
\       Name: creditsText1Hi
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the high byte of the address of the creditsText1
\             text for each language
\
\ ******************************************************************************

.creditsText1Hi

 EQUB HI(creditsText1)  \ English

 EQUB HI(creditsText1)  \ German

 EQUB HI(creditsText1)  \ French

 EQUB HI(creditsText1)  \ There is no fourth language, so this byte is ignored

