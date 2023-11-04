\ ******************************************************************************
\
\       Name: xSaveHeader
\       Type: Variable
\   Category: Save and load
\    Summary: The text column for the Save and Load screen headers for each
\             language
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.xSaveHeader

 EQUB 8                 \ English

 EQUB 4                 \ German

 EQUB 4                 \ French

 EQUB 5                 \ There is no fourth language, so this byte is ignored

