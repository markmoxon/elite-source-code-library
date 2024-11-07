IF _6502SP_VERSION

.LBUP

 SKIP 1                 \ The size of the multi-segment line buffer at LBUF

ELIF _C64_VERSION OR _APPLE_VERSION

\.LBUP                  \ These instructions are commented out in the original
\                       \ source
\SKIP 1

ENDIF

