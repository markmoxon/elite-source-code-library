\ ******************************************************************************
\
\       Name: K%
\       Type: Workspace
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\    Address: &0900 to &0D3F
ELIF _6502SP_VERSION
\    Address: &8200 to &85FF
ENDIF
\   Category: Workspaces
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\    Summary: Ship data blocks and ship line heaps
ELIF _6502SP_VERSION
\    Summary: Ship data blocks
ENDIF
\  Deep dive: Ship data blocks
\             The local bubble of universe
\
\ ------------------------------------------------------------------------------
\
\ Contains ship data for all the ships, planets, suns and space stations in our
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\ local bubble of universe, along with their corresponding ship line heaps.
ELIF _6502SP_VERSION
\ local bubble of universe.
ENDIF
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\ The blocks are pointed to by the lookup table at location UNIV. The first 432
\ bytes of the K% workspace hold ship data on up to 12 ships, with 36 (NI%)
\ bytes per ship, and the ship line heap grows downwards from WP at the end of
\ the K% workspace.
ELIF _6502SP_VERSION
\ The blocks are pointed to by the lookup table at location UNIV. The first 720
\ bytes of the K% workspace hold ship data on up to 20 ships, with 37 (NI%)
\ bytes per ship.
ENDIF
\
\ See the deep dive on "Ship data blocks" for details on ship data blocks, and
\ the deep dive on "The local bubble of universe" for details of how Elite
\ stores the local universe in K%, FRIN and UNIV.
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION \ Platform

ORG &0900

ELIF _6502SP_VERSION

ORG &8200

ENDIF

.K%

 SKIP 0                 \ Ship data blocks and ship line heap

