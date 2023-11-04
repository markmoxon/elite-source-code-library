\ ******************************************************************************
\
\       Name: scrollText2Hi
\       Type: Variable
\   Category: Combat demo
\    Summary: Lookup table for the high byte of the address of the scrollText2
\             text for each language
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.scrollText2Hi

 EQUB HI(scrollText2_EN)    \ English

 EQUB HI(scrollText2_DE)    \ German

 EQUB HI(scrollText2_FR)    \ French

 EQUB HI(scrollText2_EN)    \ There is no fourth language, so this byte is
                            \ ignored

