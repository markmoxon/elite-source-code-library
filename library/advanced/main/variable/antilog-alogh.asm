\ ******************************************************************************
\
IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Comment
\       Name: antilog
ELIF _MASTER_VERSION OR _APPLE_VERSION
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

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Label

.antilog

ELIF _MASTER_VERSION OR _APPLE_VERSION

.alogh

ENDIF

 FOR I%, 0, 255

  EQUB HI(INT(2^((I% / 2 + 128) / 16) + 0.5))

 NEXT

