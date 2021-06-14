\ ******************************************************************************
\
\       Name: LL9_FLIGHT
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: AJD
\
\ ******************************************************************************

.d_4889

 JMP PLANET

.LL9_FLIGHT

 LDA &8C
 BMI d_4889
 JMP LL9

