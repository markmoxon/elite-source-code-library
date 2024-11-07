IF _6502SP_VERSION

.HBUP

 SKIP 1                 \ The size of the horizontal line buffer at HBUF
                        \ (including the two OSWORD size bytes)

ELIF _C64_VERSION OR _APPLE_VERSION

\.HBUP                  \ These instructions are commented out in the original
\                       \ source
\SKIP 1

ENDIF

