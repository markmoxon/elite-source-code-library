\ ******************************************************************************
\
\       Name: PBUF
\       Type: Variable
\   Category: Drawing pixels
\    Summary: The pixel buffer to send with the OSWORD 241 command
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

 INCBIN "versions/6502sp/extracted/workspaces/ELTB-PBUF.bin"

ELSE

 SKIP &100              \ The pixel buffer to send with this command

ENDIF

