\ ******************************************************************************
\
\       Name: saveHeader2_FR
\       Type: Subroutine
\   Category: Save and load
\    Summary: The subheaders for the Save and Load screen title in French
\  Deep dive: Multi-language support in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ In the following, EQUB 12 is a newline and the text is terminated by EQUB 0.
\
\ ******************************************************************************

.saveHeader2_FR

 EQUS "                    POSITIONS"
 EQUB 12
 EQUS "                  SAUVEGARD<ES"
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUB 12
 EQUS "POSITION"
 EQUB 12
 EQUS "ACTUELLE"
 EQUB 0

