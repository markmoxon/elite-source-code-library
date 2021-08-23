IF _6502SP_VERSION \ Comment
\ ******************************************************************************
\
\       Name: LSY2
\       Type: Variable
\   Category: Drawing lines
\    Summary: The ball line heap for storing y-coordinates
\  Deep dive: The ball line heap
\
\ ******************************************************************************

ENDIF

.LSY2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 SKIP 78                \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _ELECTRON_VERSION

 SKIP 40                \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _6502SP_VERSION

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ELTA-LSY2.bin"
 ELIF _EXECUTIVE
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ELTA-LSY2.bin"
 ELIF _SOURCE_DISC
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ELTA-LSY2.bin"
 ENDIF

ELSE

 SKIP 256               \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

ELIF _MASTER_VERSION

 SKIP 256               \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

