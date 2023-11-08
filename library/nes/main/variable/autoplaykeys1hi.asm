\ ******************************************************************************
\
\       Name: autoPlayKeys1Hi
\       Type: Variable
\   Category: Combat demo
\    Summary: High byte of the address of the auto-play key table for each
\             language
\
\ ******************************************************************************

.autoPlayKeys1Hi

 EQUB HI(autoPlayKeys1_EN)      \ English

 EQUB HI(autoPlayKeys1_DE)      \ German

 EQUB HI(autoPlayKeys1_FR)      \ French

 EQUB HI(autoPlayKeys1_EN)      \ There is no fourth language, so this byte is
                                \ ignored

