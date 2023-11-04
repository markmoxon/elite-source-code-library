\ ******************************************************************************
\
\       Name: viewAttributesLo
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The low byte of the view attributes lookup table for each language
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.viewAttributesLo

 EQUB LO(viewAttributes_EN)     \ English

 EQUB LO(viewAttributes_DE)     \ German

 EQUB LO(viewAttributes_FR)     \ French

 EQUB LO(viewAttributes_EN)     \ There is no fourth language, so this byte is
                                \ ignored

