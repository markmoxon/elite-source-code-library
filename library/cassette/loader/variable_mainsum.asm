\ ******************************************************************************
\
\       Name: MAINSUM
\       Type: Variable
\   Category: Copy protection
\    Summary: Two checksums for the decryption header and text token table
\
\ ------------------------------------------------------------------------------
\
\ Contains two checksum values, one for the header code at LBL, and the other
\ for the recursive token table from &0400 to &07FF.
\
\ ******************************************************************************

.MAINSUM

 EQUB &CB               \ This is the checksum value of the decryption header
                        \ code (from LBL to elitea) that gets prepended to the
                        \ main game code by elite-bcfs.asm and saved as
                        \ ELThead.bin

 EQUB 0                 \ This is the checksum value for the recursive token
                        \ table from &0400 to &07FF. We calculate the value in
                        \ elite-checksum.py, so this just reserves a byte

