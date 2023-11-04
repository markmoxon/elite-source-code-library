\ ******************************************************************************
\
\       Name: saveHeader1_EN
\       Type: Subroutine
\   Category: Save and load
\    Summary: The Save and Load screen title in English
\  Deep dive: Multi-language support in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ In the following, EQUB 12 is a newline and EQUB 6 switches to Sentence Case.
\ The text is terminated by EQUB 0.
\
\ ******************************************************************************

.saveHeader1_EN

 EQUS "STORED COMMANDERS"
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 6
 EQUB 0

