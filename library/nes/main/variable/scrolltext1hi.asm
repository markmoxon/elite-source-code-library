\ ******************************************************************************
\
\       Name: scrollText1Hi
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the high byte of the address of the scrollText1
\             text for each language
\
\ ******************************************************************************

.scrollText1Hi

 EQUB HI(scrollText1_EN)    \ English

 EQUB HI(scrollText1_DE)    \ German

 EQUB HI(scrollText1_FR)    \ French

 EQUB HI(scrollText1_EN)    \ There is no fourth language, so this byte is
                            \ ignored

