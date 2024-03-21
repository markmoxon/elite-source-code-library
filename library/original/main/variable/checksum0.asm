\ ******************************************************************************
\
\       Name: checksum0
\       Type: Variable
\   Category: Copy protection
\    Summary: Checksum for the entire main game code
\
\ ------------------------------------------------------------------------------
\
\ This byte contains a checksum for the entire main game code. It is populated
\ by elite-checksum.py and is used by the encryption checks in elite-loader.asm
\ (see the CHK routine in the loader for more details).
\
\ ******************************************************************************

.checksum0

IF _CASSETTE_VERSION \ Comment

 SKIP 1                 \ This value is checked against the calculated checksum
                        \ in part 6 of the loader in elite-loader.asm

ELIF _ELECTRON_VERSION

 SKIP 1                 \ This value is checked against the calculated checksum
                        \ in part 5 of the loader in elite-loader.asm (or it
                        \ would be if this weren't an unprotected version)

IF _IB_DISC

 SKIP 1                 \ This byte appears to be unused

ENDIF

ENDIF

