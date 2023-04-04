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

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ELTB-HBUF.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ELTB-HBUF.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ELTB-HBUF.bin"
 ENDIF

ELSE

 SKIP 256

ENDIF

