\ ******************************************************************************
\
\       Name: languageIndexes
\       Type: Variable
\   Category: Text
\    Summary: The index of the chosen language for looking up values from
\             language-indexed tables
\
\ ******************************************************************************

.languageIndexes

 EQUB 0                 \ English

 EQUB 1                 \ German

 EQUB 2                 \ French

 EQUB &FF               \ There is no fourth language, so this byte is ignored

