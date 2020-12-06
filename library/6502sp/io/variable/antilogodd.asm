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

