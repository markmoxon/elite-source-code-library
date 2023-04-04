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

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ELTB-PBUF.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ELTB-PBUF.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ELTB-PBUF.bin"
 ENDIF

ELSE

 SKIP 256               \ The pixel buffer to send with this command

ENDIF

