\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for recursive tokens, Missile blueprint and
\             images
\
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 1 above.
\
IF NOT(_ELITE_A_VERSION)
\ This section is encrypted by EOR'ing with &A5. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as each block is moved to its correct location.
\
ENDIF
\ There are two files containing code:
\
\   * WORDS.bin contains the recursive token table, which is moved to &0400
\     before the main game is loaded
\
\   * MISSILE.bin contains the missile ship blueprint, which gets moved to &7F00
\     before the main game is loaded
\
\ and one file containing an image, which is moved into screen memory by the
\ loader:
\
\   * P.DIALS.bin contains the dashboard, which gets moved to screen address
\     &7800, which is the starting point of the four-colour mode 5 portion at
\     the bottom of the split screen
\
\ There are three other image binaries bundled into the loader, which are
\ described in part 3 below.
\
\ ******************************************************************************

IF NOT(_ELITE_A_VERSION)

.DIALS

 INCBIN "versions/disc/binaries/P.DIALS.bin"

.SHIP_MISSILE

 INCBIN "versions/disc/output/MISSILE.bin"

.WORDS

 INCBIN "versions/disc/output/WORDS.bin"

ELIF _ELITE_A_VERSION

.DIALS

 INCBIN "versions/elite-a/binaries/P.DIALS.bin"

.SHIP_MISSILE

 INCBIN "versions/elite-a/output/MISSILE.bin"

.WORDS

 INCBIN "versions/elite-a/output/WORDS.bin"

ENDIF
