\ ******************************************************************************
\
\       Name: antilogODD
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary antilogarithm table
\
\ ------------------------------------------------------------------------------
\
\ At byte n, the table contains:
\
\   2^((n / 2 + 128.25) / 16) / 256
\
\ which equals:
\
\   2^(n / 32 + 8.015625) / 256 = 2^(n / 32 + 8) * 2^(.015625) / 256
\                               = (2^(n / 32 + 8) + 1) / 256
\
\ ******************************************************************************

.antilogODD

IF _MATCH_ORIGINAL_BINARIES

IF _6502SP_VERSION \ Platform
 IF _SNG45
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ELTG-antilogODD.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ELTG-antilogODD.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ELTG-antilogODD.bin"
 ENDIF
ELIF _NES_VERSION
 INCBIN "versions/nes/4-reference-binaries/workspaces/BANK7-antilogODD.bin"
ENDIF

ELSE

 FOR I%, 0, 255

  EQUB INT(2^((I% / 2 + 128.25) / 16) + 0.5) DIV 256

 NEXT

ENDIF

