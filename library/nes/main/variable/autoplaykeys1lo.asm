\ ******************************************************************************
\
\       Name: autoPlayKeys1Lo
\       Type: Variable
\   Category: Combat demo
\    Summary: Low byte of the address of the auto-play key table for each
\             language
\  Deep dive: Multi-language support in NES Elite
\             Auto-playing the combat demo
\
\ ******************************************************************************

.autoPlayKeys1Lo

 EQUB LO(autoPlayKeys1_EN)      \ English

 EQUB LO(autoPlayKeys1_DE)      \ German

 EQUB LO(autoPlayKeys1_FR)      \ French

 EQUB LO(autoPlayKeys1_EN)      \ There is no fourth language, so this byte is
                                \ ignored

