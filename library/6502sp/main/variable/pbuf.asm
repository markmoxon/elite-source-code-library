\ ******************************************************************************
\
\       Name: PBUF
\       Type: Variable
\   Category: Drawing pixels
\    Summary: The pixel buffer to send with the OSWORD 241 command
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   pixbl               Points to the first byte of the PBUF block, which is
\                       where the OSWORD transmission size goes
\
\ ******************************************************************************

.pixbl

.PBUF

 EQUB 0                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/extracted/sng45/workspaces/ELTB-PBUF.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/extracted/source-disc/workspaces/ELTB-PBUF.bin"
 ENDIF

ELSE

 SKIP 256               \ The pixel buffer to send with this command

ENDIF

