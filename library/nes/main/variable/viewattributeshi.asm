\ ******************************************************************************
\
\       Name: viewAttributesHi
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The high byte of the view attributes lookup table for each
\             language
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.viewAttributesHi

 EQUB HI(viewAttributes_EN)     \ English

 EQUB HI(viewAttributes_DE)     \ German

 EQUB HI(viewAttributes_FR)     \ French

 EQUB HI(viewAttributes_EN)     \ There is no fourth language, so this byte is
                                \ ignored

