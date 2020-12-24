\ ******************************************************************************
\
\       Name: LBUF
\       Type: Variable
\   Category: Drawing lines
\    Summary: The multi-segment line buffer used by LOIN
\
\ ******************************************************************************

.LBUF

IF _MATCH_EXTRACTED_BINARIES

 INCBIN "versions/6502sp/extracted/workspaces/ELTB-LBUF.bin"

ELSE

 SKIP &100

ENDIF

