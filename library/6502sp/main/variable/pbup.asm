IF _6502SP_VERSION

.PBUP

 SKIP 1                 \ The size of the pixel buffer at PBUF (including the
                        \ two OSWORD size bytes)

ELIF _C64_VERSION OR _APPLE_VERSION

\.PBUP                  \ These instructions are commented out in the original
\                       \ source
\SKIP 1

ENDIF

