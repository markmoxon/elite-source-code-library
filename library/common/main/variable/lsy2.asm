IF _CASSETTE_VERSION

.LSY2

 SKIP 78                \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _6502SP_VERSION

\ ******************************************************************************
\
\       Name: LSY2
\       Type: Variable
\   Category: Drawing lines
\    Summary: The ball line heap for storing y-coordinates
\  Deep dive: The ball line heap
\
\ ******************************************************************************

.LSY2

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/extracted/sng45/workspaces/ELTA-LSY2.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/extracted/source-disc/workspaces/ELTA-LSY2.bin"
 ENDIF

ELSE

 SKIP &100

ENDIF

ENDIF

