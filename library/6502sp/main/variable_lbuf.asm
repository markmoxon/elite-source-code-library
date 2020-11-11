\ ******************************************************************************
\       Name: LBUF
\ ******************************************************************************

.LBUF

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "6502sp/extracted/workspaces/ELTB-LBUF.bin"
ELSE
 SKIP &100
ENDIF
