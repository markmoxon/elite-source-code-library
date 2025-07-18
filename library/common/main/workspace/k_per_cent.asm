\ ******************************************************************************
\
\       Name: K%
\       Type: Workspace
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\    Address: &0900 to &0AAF
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\    Address: &0900 to &0ABB
ELIF _6502SP_VERSION
\    Address: &8200 to &84E3 (&8500 to &87E3 in the Executive version)
ELIF _MASTER_VERSION
\    Address: &0400 to &05BB
ELIF _NES_VERSION
\    Address: &0600 to &074F
ELIF _C64_VERSION
\    Address: &F900 to &FA71 (&F000 to &F171 in the source disk variant)
ELIF _APPLE_VERSION
\    Address: &0800 to &0927
ENDIF
\   Category: Workspaces
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _ELITE_A_VERSION \ Comment
\    Summary: Ship data blocks and ship line heaps
ELIF _6502SP_VERSION OR _NES_VERSION
\    Summary: Ship data blocks
ENDIF
\  Deep dive: Ship data blocks
\             The local bubble of universe
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Contains ship data for all the ships, planets, suns and space stations in our
\ local bubble of universe, along with their corresponding ship line heaps.
\
ELIF _ELECTRON_VERSION
\ Contains ship data for all the ships, planets and space stations in our local
\ bubble of universe, along with their corresponding ship line heaps.
\
ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION
\ Contains ship data for all the ships, planets, suns and space stations in our
\ local bubble of universe.
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\ The blocks are pointed to by the lookup table at location UNIV. The first 432
\ bytes of the K% workspace hold ship data on up to 12 ships, with 36 (NI%)
\ bytes per ship, and the ship line heap grows downwards from WP at the end of
\ the K% workspace.
\
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\ The blocks are pointed to by the lookup table at location UNIV. The first 444
\ bytes of the K% workspace hold ship data on up to 12 ships, with 37 (NI%)
\ bytes per ship, and the ship line heap grows downwards from WP at the end of
\ the K% workspace.
\
ELIF _6502SP_VERSION
\ The blocks are pointed to by the lookup table at location UNIV. The first 720
\ bytes of the K% workspace hold ship data on up to 20 ships, with 37 (NI%)
\ bytes per ship.
\
ELIF _MASTER_VERSION
\ The blocks are pointed to by the lookup table at location UNIV. The first 444
\ bytes of the K% workspace hold ship data on up to 12 ships, with 37 (NI%)
\ bytes per ship.
\
ELIF _C64_VERSION
\ The blocks are pointed to by the lookup table at location UNIV. The first 370
\ bytes of the K% workspace hold ship data on up to 10 ships, with 37 (NI%)
\ bytes per ship.
\
ELIF _APPLE_VERSION
\ The blocks are pointed to by the lookup table at location UNIV. The first 296
\ bytes of the K% workspace hold ship data on up to 8 ships, with 37 (NI%)
\ bytes per ship.
\
ELIF _NES_VERSION
\ The blocks are pointed to by the lookup table at location UNIV. The first 336
\ bytes of the K% workspace hold ship data on up to 8 ships, with 42 (NIK%)
\ bytes per ship.
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ 6502SP: The Executive version has a different memory map to the other 6502SP versions, with the K% workspace at &8500 instead of &8200

 ORG &0900              \ Set the assembly address to &0900

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 ORG &8200              \ Set the assembly address to &8200

ELIF _EXECUTIVE

 ORG &8500              \ Set the assembly address to &8500

ENDIF

ELIF _MASTER_VERSION

 ORG &0400              \ Set the assembly address to &0400

ELIF _NES_VERSION

 ORG &0600              \ Set the assembly address to &0600

ELIF _C64_VERSION

IF _GMA_RELEASE

 ORG &F900              \ Set the assembly address to &F900

ELIF _SOURCE_DISK

 ORG &F000              \ Set the assembly address to &F000

ENDIF

ELIF _APPLE_VERSION

 ORG &0800              \ Set the assembly address to &0800

ENDIF

.K%

IF NOT(_NES_VERSION)

 SKIP NOSH * NI%        \ Ship data blocks and ship line heap

ELIF _NES_VERSION

 CLEAR K%, &0800        \ The ship data blocks share memory with the X1TB, Y1TB
                        \ and X2TB variables (for use in the scroll text), so we
                        \ need to clear this block of memory to prevent BeebAsm
                        \ from complaining

 SKIP NOSH * NIK%       \ Ship data blocks

ENDIF

 PRINT "K% workspace from ", ~K%, "to ", ~P%-1, "inclusive"

