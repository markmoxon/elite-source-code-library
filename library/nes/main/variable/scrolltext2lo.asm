\ ******************************************************************************
\
\       Name: scrollText2Lo
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the low byte of the address of the scrollText2
\             text for each language
\
\ ******************************************************************************

.scrollText2Lo

 EQUB LO(scrollText2_EN)    \ English

 EQUB LO(scrollText2_DE)    \ German

 EQUB LO(scrollText2_FR)    \ French

 EQUB LO(scrollText2_EN)    \ There is no fourth language, so this byte is
                            \ ignored

