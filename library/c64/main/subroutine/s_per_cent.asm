\ ******************************************************************************
\
\       Name: S%
\       Type: Subroutine
\   Category: Loader
\    Summary: Checksum, decrypt and unscramble the main game code, and start the
\             game
\
\ ******************************************************************************

 RTS                    \ The checksum byte goes here, at S%-1. In the original
                        \ source this byte is set by the first call to ZP in the
                        \ Big Code File, though in the BeebAsm version this is
                        \ populated by elite-checksum.py

.S%

 CLD                    \ Clear the D flag to make sure we are in binary mode

 LDX #2                 \ We now copy the contents of zero page between &0002
                        \ and &00FF to the page at &CE00, so set an index in X
                        \ to start from byte &0002
                        \
                        \ We do this so we can use the SWAPPZERO routine to swap
                        \ zero page with the page at &CE00 when saving or
                        \ loading commander files

.ZONKPZERO

 LDA &0000,X            \ Copy the X-th byte of zero page to the X-th byte of
 STA &CE00,X            \ &CE00

 INX                    \ Increment the loop counter

 BNE ZONKPZERO          \ Loop back until we have copied all of zero page

 JSR DEEOR              \ Decrypt the main game code between &1300 and &9FFF

 JSR COLD               \ Configure memory, set up interrupt handlers and
                        \ configure the VIC-II, SID and CIA chips

\JSR Checksum           \ This instruction is commented out in the original
                        \ source

 JMP BEGIN              \ Jump to BEGIN to start the game

