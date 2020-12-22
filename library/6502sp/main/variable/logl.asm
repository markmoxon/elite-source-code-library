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
 INCBIN "versions/6502sp/extracted/workspaces/ELTG-logL.bin"
ELSE
 SKIP 1
 FOR I%, 1, 255
   B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)
   EQUB B% MOD 256
 NEXT
ENDIF

