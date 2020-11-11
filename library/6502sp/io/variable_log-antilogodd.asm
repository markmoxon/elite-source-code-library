\ ******************************************************************************
\       Name: log
\ ******************************************************************************

.log

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "6502sp/extracted/workspaces/ICODE-log.bin"
ELSE
 SKIP 1
 FOR I%, 1, 255
   B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)
   EQUB B% DIV 256
 NEXT
ENDIF

\ ******************************************************************************
\       Name: logL
\ ******************************************************************************

.logL

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "6502sp/extracted/workspaces/ICODE-logL.bin"
ELSE
 SKIP 1
 FOR I%, 1, 255
   B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)
   EQUB B% MOD 256
 NEXT
ENDIF

\ ******************************************************************************
\       Name: antilog
\ ******************************************************************************

.antilog

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "6502sp/extracted/workspaces/ICODE-antilog.bin"
ELSE
 FOR I%, 0, 255
   B% = INT(2^((I% / 2 + 128) / 16) + 0.5) DIV 256
   IF B% = 256
     EQUB B%+1
   ELSE
     EQUB B%
   ENDIF
 NEXT
ENDIF

\ ******************************************************************************
\       Name: antilogODD
\ ******************************************************************************

.antilogODD

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "6502sp/extracted/workspaces/ICODE-antilogODD.bin"
ELSE
 FOR I%, 0, 255
   B% = INT(2^((I% / 2 + 128.25) / 16) + 0.5) DIV 256
   IF B% = 256
     EQUB B%+1
   ELSE
     EQUB B%
   ENDIF
 NEXT
ENDIF

