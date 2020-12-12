\ ******************************************************************************
\       Name: log
\ ******************************************************************************

.log

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "versions/6502sp/extracted/workspaces/ELTG-log.bin"
ELSE
 SKIP 1
 FOR I%, 1, 255
   B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)
   EQUB B% DIV 256
 NEXT
ENDIF

