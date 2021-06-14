\ ******************************************************************************
\
\       Name: MVEIT_FLIGHT
\       Type: Subroutine
\   Category: Moving
\    Summary: AJD
\
\ ******************************************************************************

.MVEIT_FLIGHT

 LDA &65
 AND #&A0
 BNE MV30
 LDA &8A
 EOR &84
 AND #&0F
 BNE P%+5
 JSR TIDY

