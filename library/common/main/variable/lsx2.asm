IF _CASSETTE_VERSION

.LSX2

 SKIP 78                \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _6502SP_VERSION

\ ******************************************************************************
\       Name: LSX2
\ ******************************************************************************

.LSX2

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "versions/6502sp/extracted/workspaces/ELTA-LSX2.bin"
ELSE
 SKIP &100
ENDIF

ENDIF
