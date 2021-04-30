\ ******************************************************************************
\
\       Name: logL
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary logarithm table (low byte)
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
\ so byte n contains the low byte of:
\
\   32 * log2(n) * 256
\
\ ******************************************************************************

.logL

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/extracted/sng45/workspaces/ICODE-logL.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/extracted/executive/workspaces/ICODE-logL.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/extracted/source-disc/workspaces/ICODE-logL.bin"
 ENDIF

ELSE

 SKIP 1

 FOR I%, 1, 255
   B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)
   EQUB B% MOD 256
 NEXT

ENDIF

