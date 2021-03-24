IF _6502SP_VERSION \ Comment
\ ******************************************************************************
\
\       Name: LSX2
\       Type: Variable
\   Category: Drawing lines
\    Summary: The ball line heap for storing x-coordinates
\  Deep dive: The ball line heap
\
\ ******************************************************************************

ENDIF

.LSX2

IF _CASSETTE_VERSION OR _DISC_VERSION \ Minor

 SKIP 78                \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _6502SP_VERSION

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/extracted/sng45/workspaces/ELTA-LSX2.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/extracted/source-disc/workspaces/ELTA-LSX2.bin"
 ENDIF

ELSE

 SKIP 256               \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

ELIF _MASTER_VERSION

 SKIP 256               \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

