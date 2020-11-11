\ ******************************************************************************
\
\       Name: K%
\       Type: Workspace
IF _CASSETTE_VERSION
\    Address: &0900 to &0D40
ELIF _6502SP_VERSION
\    Address: &8200
ENDIF
\   Category: Workspaces
\    Summary: Ship data blocks and ship line heaps
\  Deep dive: Ship data blocks
\
\ ------------------------------------------------------------------------------
\
\ Contains ship data for all the ships, planets, suns and space stations in our
\ local bubble of universe, along with their corresponding ship line heaps.
\
\ The blocks are pointed to by the lookup table at location UNIV. The first 468
\ bytes of the K% workspace hold ship data on up to 13 ships, with 36 (NI%)
\ bytes per ship, and the ship line heap grows downwards from WP at the end of
\ the K% workspace.
\
\ See the deep dive on "Ship data blocks" for details on ship data blocks, and
\ the deep dive on "The local bubble of universe" for details of how Elite
\ stores the local universe in K%, FRIN and UNIV.
\
\ ******************************************************************************

IF _CASSETTE_VERSION

ORG &0900

ELIF _6502SP_VERSION

ORG &8200

ENDIF

.K%

 SKIP 0                 \ Ship data blocks and ship line heap

