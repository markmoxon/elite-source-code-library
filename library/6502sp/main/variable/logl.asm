\ ******************************************************************************
\
\       Name: logL
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary logarithm table (low byte)
\
\ ------------------------------------------------------------------------------
\
\ Byte n contains the low byte of:
\
\   32 * log2(n) * 256
\
\ ******************************************************************************

.logL

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/extracted/workspaces-SNG45/ELTG-logL.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/extracted/workspaces/ELTG-logL.bin"
 ENDIF

ELSE
 SKIP 1
 FOR I%, 1, 255
   B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)
   EQUB B% MOD 256
 NEXT
ENDIF

