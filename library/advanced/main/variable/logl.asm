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

IF _MATCH_ORIGINAL_BINARIES

IF _6502SP_VERSION \ Platform
 IF _SNG45
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ELTG-logL.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ELTG-logL.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ELTG-logL.bin"
 ENDIF
ELIF _MASTER_VERSION
 IF _SNG47
  INCBIN "versions/master/4-reference-binaries/sng47/workspaces/ELTA-logL.bin"
 ELIF _COMPACT
  INCBIN "versions/master/4-reference-binaries/compact/workspaces/ELTA-logL.bin"
 ENDIF
ENDIF

ELSE

 SKIP 1

 FOR I%, 1, 255

  B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)

  EQUB B% MOD 256

 NEXT

ENDIF

