\ ******************************************************************************
\
\       Name: HBUF
\       Type: Variable
\   Category: Drawing lines
\    Summary: 
\
\ ******************************************************************************

.HBUF

 EQUB 0
 EQUB 0

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "versions/6502sp/extracted/workspaces/ELTB-HBUF.bin"
ELSE
 SKIP &100
ENDIF

