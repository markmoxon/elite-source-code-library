\ ******************************************************************************
\
\       Name: DVLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a vertical line from (A, GCYT) to (A, GCYB)
\
IF _MASTER_VERSION
\ ------------------------------------------------------------------------------
\
\ This routine is from the Apple II version of Elite and is not used in the BBC
\ Master version.
\
ENDIF
\ ******************************************************************************

.DVLOIN

IF _MASTER_VERSION

 STA X1                 \ Draw a vertical line from (A, GCYT) to (A, GCYB)
 STA X2
 LDA #GCYT
 STA Y1
 LDA #GCYB
 STA Y2
 JMP LOIN

ELIF _APPLE_VERSION

 STA X1                 \ Draw a vertical line from (A, GCYT) to (A, GCYB)
 LDA #GCYT
 STA Y1
 LDA #GCYB
 STA Y2
 JMP VLOIN

ENDIF

