\ ******************************************************************************
\
\       Name: saveHeader2_DE
\       Type: Subroutine
\   Category: Save and load
\    Summary: The subheaders for the Save and Load screen title in German
\  Deep dive: Multi-language support in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ In the following, EQUB 12 is a newline and the text is terminated by EQUB 0.
\
\ ******************************************************************************

.saveHeader2_DE

 EQUS "                    GESP."
 EQUB 12
 EQUS "                   POSITIONEN"
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUS "GEGENW."
 EQUB 12
 EQUS "POSITION"
 EQUB 0

