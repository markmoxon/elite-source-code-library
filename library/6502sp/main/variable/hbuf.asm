\ ******************************************************************************
\       Name: HBUF
\ ******************************************************************************

.HBUF

 EQUB 0
 EQUB 0

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "6502sp/extracted/workspaces/ELTB-HBUF.bin"
ELSE
 SKIP &100
ENDIF

