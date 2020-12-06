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

 SKIP 1                 \ This value is checked against the calculated checksum
                        \ in part 6 of the loader in elite-loader.asm

