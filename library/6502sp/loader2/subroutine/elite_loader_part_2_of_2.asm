\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 2)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for loading screen and dashboard images
\
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 1 above.
\
\ There are five files, all containing images, which are all moved into screen
\ memory by the loader:
\
\   * Z.ACSOFT.bin contains the "ACORNSOFT" title across the top of the loading
\     screen, which gets moved to screen address &4200, on the second character
\     row of the mode 1 part of the screen (the top part)
\
\   * Z.ELITE.bin contains the "ELITE" title across the top of the loading
\     screen, which gets moved to screen address &4600, on the fourth character
\     row of the mode 1 part of the screen (the top part)
\
\   * Z.(C)ASFT.bin contains the "(C) Acornsoft 1984" title across the bottom
\     of the loading screen, which gets moved to screen address &6C00, the
\     penultimate character row of the top part of the screen, just above the
\     dashboard
\
\   * P.DIALS2P.bin contains the dashboard, which gets moved to screen address
\     &7000, which is the starting point of the eight-colour mode 2 portion at
\     the bottom of the split screen
\
\   * P.DATE2P.bin contains the version text "2nd Pro ELITE -Finished 13/12/84",
\     though the code to show this on-screen in part 1 is commented out, as this
\     was presumably used to identify versions of the game during development.
\     If the MVE macro instruction in part 1 is uncommented, then this binary
\     gets moved to screen address &6000, which displays the version message in
\     the middle of the top part of the screen
\
\ ******************************************************************************

.DIALS

INCBIN "versions/6502sp/binaries/P.DIALS2P.bin"

.DATE

INCBIN "versions/6502sp/binaries/P.DATE2P.bin"

.ASOFT

INCBIN "versions/6502sp/binaries/Z.ACSOFT.bin"

.ELITE

INCBIN "versions/6502sp/binaries/Z.ELITE.bin"

.CpASOFT

INCBIN "versions/6502sp/binaries/Z.(C)ASFT.bin"

