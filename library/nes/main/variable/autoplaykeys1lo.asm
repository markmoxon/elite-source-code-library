\ ******************************************************************************
\
\       Name: autoplayKeys1Lo
\       Type: Variable
\   Category: Combat demo
\    Summary: Low byte of the address of the auto-play key table for each
\             language
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.autoplayKeys1Lo

 EQUB LO(autoplayKeys1_EN)      \ English

 EQUB LO(autoplayKeys1_DE)      \ German

 EQUB LO(autoplayKeys1_FR)      \ French

 EQUB LO(autoplayKeys1_EN)      \ There is no fourth language, so this byte is
                                \ ignored

