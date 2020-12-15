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

 INCBIN "versions/6502sp/extracted/workspaces/ELTA-LSY2.bin"

ELSE

 SKIP &100

ENDIF

ENDIF
