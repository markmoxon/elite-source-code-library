\ ******************************************************************************
\
IF _6502SP_VERSION OR _NES_VERSION \ Comment
\       Name: antilog
ELIF _MASTER_VERSION
\       Name: alogh
ENDIF
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

IF _6502SP_VERSION OR _NES_VERSION \ Label

.antilog

ELIF _MASTER_VERSION

.alogh

ENDIF

IF _MATCH_ORIGINAL_BINARIES

IF _6502SP_VERSION \ Platform
 IF _SNG45
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ELTG-antilog.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ELTG-antilog.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ELTG-antilog.bin"
 ENDIF
ELIF _MASTER_VERSION
 IF _SNG47
  INCBIN "versions/master/4-reference-binaries/sng47/workspaces/ELTA-antilog.bin"
 ELIF _COMPACT
  INCBIN "versions/master/4-reference-binaries/compact/workspaces/ELTA-antilog.bin"
 ENDIF
ELIF _NES_VERSION
 INCBIN "versions/nes/4-reference-binaries/workspaces/BANK7-antilog.bin"
ENDIF

ELSE

 FOR I%, 0, 255

  EQUB INT(2^((I% / 2 + 128) / 16) + 0.5) DIV 256

 NEXT

ENDIF

