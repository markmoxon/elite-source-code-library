\ ******************************************************************************
\
\       Name: CHECKbyt
\       Type: Variable
\   Category: Copy protection
\    Summary: Checksum for the validity of the UU% workspace
\
\ ------------------------------------------------------------------------------
\
\ We calculate the value of the CHECKbyt checksum in elite-checksum.py, so this
\ just reserves a byte. It checks the validity of the first two pages of the UU%
\ workspace, which gets copied to LE%.
\
\ ******************************************************************************

.CHECKbyt

 BRK                    \ This could be an EQUB 0 directive instead of a BRK,
                        \ but this is what's in the source code

