\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for the loading screen images
\
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 1 above.
\
\ This section is encrypted by EOR'ing with &A5. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as each block is moved to its correct location.
\
\ This part includes three files containing images, which are all moved into
\ screen memory by the loader:
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
\ There are three other binaries bundled into the loader, which are described in
\ part 2 above.
\
\ ******************************************************************************

.ELITE

 INCBIN "versions/disc/binaries/P.ELITE.bin"

.ASOFT

 INCBIN "versions/disc/binaries/P.A-SOFT.bin"

.CpASOFT

 INCBIN "versions/disc/binaries/P.(C)ASFT.bin"

