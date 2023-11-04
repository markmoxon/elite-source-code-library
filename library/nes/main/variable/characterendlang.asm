\ ******************************************************************************
\
\       Name: characterEndLang
\       Type: Variable
\   Category: Text
\    Summary: The number of the character beyond the end of the printable
\             character set in each language
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.characterEndLang

 EQUB 91                \ English

 EQUB 96                \ German

 EQUB 96                \ French

 EQUB 96                \ There is no fourth language, so this byte is ignored

