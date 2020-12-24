\ ******************************************************************************
\
\       Name: HBUF
\       Type: Variable
\   Category: Drawing lines
\    Summary: The horizontal line buffer to send with the OSWORD 247 command
\
\ ******************************************************************************

.HBUF

 EQUB 0                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

IF _MATCH_EXTRACTED_BINARIES

 INCBIN "versions/6502sp/extracted/workspaces/ELTB-HBUF.bin"

ELSE

 SKIP &100

ENDIF

