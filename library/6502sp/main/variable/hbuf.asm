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

 IF _SNG45 OR _EXECUTIVE
  INCBIN "versions/6502sp/extracted/sng45/workspaces/ELTB-HBUF.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/extracted/source-disc/workspaces/ELTB-HBUF.bin"
 ENDIF

ELSE

 SKIP 256

ENDIF

