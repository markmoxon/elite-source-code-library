\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for recursive tokens and images
\
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 3 below.
\
\ There is one file containing code:
\
\   * WORDS9.bin contains the recursive token table, which is moved to &0400
\     before the main game is loaded
\
\ and four files containing images, which are all moved into screen memory by
\ the loader:
\
\   * P.A-SOFT.bin contains the "ACORNSOFT" title across the top of the loading
\     screen, which gets moved to screen address &5960, on the second character
\     row of the space view
\
\   * P.ELITE.bin contains the "ELITE" title across the top of the loading
\     screen, which gets moved to screen address &5B00, on the fourth character
\     row of the space view
\
\   * P.(C)ASFT.bin contains the "(C) Acornsoft 1984" title across the bottom
\     of the loading screen, which gets moved to screen address &73A0, the
\     penultimate character row of the space view, just above the dashboard
\
\   * P.DIALS.bin contains the dashboard, which gets moved to screen address
\     &7620, which is the starting point of the dashboard, just below the space
\     view
\
\ The routine ends with a jump to the start of the loader code at ENTRY.
\
\ ******************************************************************************

PRINT "WORDS9 = ",~P%
INCBIN "versions/electron/output/WORDS9.bin"

ALIGN 256

PRINT "P.DIALS = ",~P%
INCBIN "versions/electron/binaries/P.DIALS.bin"

PRINT "P.ELITE = ",~P%
INCBIN "versions/electron/binaries/P.ELITE.bin"

PRINT "P.A-SOFT = ",~P%
INCBIN "versions/electron/binaries/P.A-SOFT.bin"

PRINT "P.(C)ASFT = ",~P%
INCBIN "versions/electron/binaries/P.(C)ASFT.bin"

.run

 JMP ENTRY              \ Jump to ENTRY to start the loading process

