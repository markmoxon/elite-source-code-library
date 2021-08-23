\ ******************************************************************************
\
\       Name: log
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary logarithm table (high byte)
\
\ ------------------------------------------------------------------------------
\
\ At byte n, the table contains the high byte of:
\
\   &2000 * log10(n) / log10(2) = 32 * 256 * log10(n) / log10(2)
\
\ where log10 is the logarithm to base 10. The change-of-base formula says that:
\
\   log2(n) = log10(n) / log10(2)
\
\ so byte n contains the high byte of:
\
\   32 * log2(n) * 256
\
\ ******************************************************************************

.log

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ICODE-log.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ICODE-log.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ICODE-log.bin"
 ENDIF

ELSE

 SKIP 1

 FOR I%, 1, 255
   B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)
   EQUB B% DIV 256
 NEXT

ENDIF

