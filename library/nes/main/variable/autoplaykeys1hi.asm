\ ******************************************************************************
\
\       Name: autoplayKeys1Hi
\       Type: Variable
\   Category: Combat demo
\    Summary: High byte of the address of the auto-play key table for each
\             language
\
\ ******************************************************************************

.autoplayKeys1Hi

 EQUB HI(autoplayKeys1_EN)      \ English

 EQUB HI(autoplayKeys1_DE)      \ German

 EQUB HI(autoplayKeys1_FR)      \ French

 EQUB HI(autoplayKeys1_EN)      \ There is no fourth language, so this byte is
                                \ ignored

