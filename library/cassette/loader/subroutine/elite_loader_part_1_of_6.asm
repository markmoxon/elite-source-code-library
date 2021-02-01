\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 6)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for recursive tokens, Python blueprint and images
\
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 3 below.
\
\ There are two files containing code:
\
\   * WORDS9.bin contains the recursive token table, which is moved to &0400
\     before the main game is loaded
\
\   * PYTHON.bin contains the Python ship blueprint, which gets moved to &7F00
\     before the main game is loaded
\
\ and four files containing images, which are all moved into screen memory by
\ the loader:
\
\   * P.A-SOFT.bin contains the "ACORNSOFT" title across the top of the loading
\     screen, which gets moved to screen address &6100, on the second character
\     row of the monochrome mode 4 screen
\
\   * P.ELITE.bin contains the "ELITE" title across the top of the loading
\     screen, which gets moved to screen address &6300, on the fourth character
\     row of the monochrome mode 4 screen
\
\   * P.(C)ASFT.bin contains the "(C) Acornsoft 1984" title across the bottom
\     of the loading screen, which gets moved to screen address &7600, the
\     penultimate character row of the monochrome mode 4 screen, just above the
\     dashboard
\
\   * P.DIALS.bin contains the dashboard, which gets moved to screen address
\     &7800, which is the starting point of the four-colour mode 5 portion at
\     the bottom of the split screen
\
\ The routine ends with a jump to the start of the loader code at ENTRY.
\
\ ******************************************************************************

ORG CODE%
PRINT "WORDS9 = ",~P%
INCBIN "versions/cassette/output/WORDS9.bin"

ORG CODE% + &400
PRINT "P.DIALS = ",~P%
INCBIN "versions/cassette/binaries/P.DIALS.bin"

ORG CODE% + &B00
PRINT "PYTHON = ",~P%
INCBIN "versions/cassette/output/PYTHON.bin"

ORG CODE% + &C00
PRINT "P.ELITE = ",~P%
INCBIN "versions/cassette/binaries/P.ELITE.bin"

ORG CODE% + &D00
PRINT "P.A-SOFT = ",~P%
INCBIN "versions/cassette/binaries/P.A-SOFT.bin"

ORG CODE% + &E00
PRINT "P.(C)ASFT = ",~P%
INCBIN "versions/cassette/binaries/P.(C)ASFT.bin"

O% = CODE% + &400 + &800 + &300
ORG O%

.run

 JMP ENTRY              \ Jump to ENTRY to start the loading process

