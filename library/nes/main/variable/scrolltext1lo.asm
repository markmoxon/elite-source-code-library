\ ******************************************************************************
\
\       Name: scrollText1Lo
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the low byte of the address of the scrollText1
\             text for each language
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.scrollText1Lo

 EQUB LO(scrollText1_EN)    \ English

 EQUB LO(scrollText1_DE)    \ German

 EQUB LO(scrollText1_FR)    \ French

 EQUB LO(scrollText1_EN)    \ There is no fourth language, so this byte is
                            \ ignored

