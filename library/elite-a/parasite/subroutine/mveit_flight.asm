\ ******************************************************************************
\
\       Name: MVEIT_FLIGHT
\       Type: Subroutine
\   Category: Moving
\    Summary: AJD
\
\ ******************************************************************************

.MVEIT_FLIGHT

 LDA INWK+31
 AND #&A0
 BNE MV30
 LDA MCNT
 EOR XSAV
 AND #&0F
 BNE P%+5
 JSR TIDY

