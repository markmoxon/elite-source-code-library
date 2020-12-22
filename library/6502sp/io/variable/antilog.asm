\ ******************************************************************************
\
\       Name: antilog
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary antilogarithm table
\
\ ------------------------------------------------------------------------------
\
\ At byte n, the table contains:
\
\   2^((n / 2 + 128) / 16) / 256
\
\ which equals:
\
\   2^(n / 32 + 8) / 256
\
\ ******************************************************************************

.antilog

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "versions/6502sp/extracted/workspaces/ICODE-antilog.bin"
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

