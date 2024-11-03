\ ******************************************************************************
\
\       Name: DVLOIN
\       Type: Subroutine
\   Category: Drawing lines
IF _APPLE_VERSION
\    Summary: Draw a vertical line from (A, GCYT) to (A, GCYB)
ELIF _MASTER_VERSION
\    Summary: Draw a vertical line from (A, 24) to (A, 152)
ENDIF
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

IF _APPLE_VERSION

 STA X1					\ Draw a vertical line from (A, GCYT) to (A, GCYB)
 LDA #GCYT
 STA Y1
 LDA #GCYB
 STA Y2
 JMP VLOIN

ELIF _MASTER_VERSION

 STA X1                 \ Draw a vertical line from (A, 24) to (A, 152)
 STA X2
 LDA #24
 STA Y1
 LDA #152
 STA Y2
 JMP LOIN

ENDIF

