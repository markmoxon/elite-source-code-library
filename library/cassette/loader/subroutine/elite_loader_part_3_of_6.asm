\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 6)
\       Type: Subroutine
\   Category: Loader
\    Summary: Move and decrypt recursive tokens, Python blueprint and images
\
\ ------------------------------------------------------------------------------
\
\ Move and decrypt the following memory blocks:
\
\   * WORDS9: move 4 pages (1024 bytes) from CODE% to &0400
\
\   * P.ELITE: move 1 page (256 bytes) from CODE% + &0C00 to &6300
\
\   * P.A-SOFT: move 1 page (256 bytes) from CODE% + &0D00 to &6100
\
\   * P.(C)ASFT: move 1 page (256 bytes) from CODE% + &0E00 to &7600
\
\   * P.DIALS and PYTHON: move 8 pages (2048 bytes) from CODE% + &0400 to &7800
\
\   * Move 2 pages (512 bytes) from UU% to &0B00-&0CFF
\
\ and call the routine to draw Saturn between P.(C)ASFT and P.DIALS.
\
\ See part 1 above for more details on the above files and the locations that
\ they are moved to.
\
\ The code at UU% (see below) forms part of the loader code and is moved before
\ being run, so it's tucked away safely while the main game code is loaded and
\ decrypted.
\
\ ******************************************************************************

 LDX #4                 \ Set the following:
 STX P+1                \
 LDA #HI(CODE%)         \   P(1 0) = &0400
 STA ZP+1               \   ZP(1 0) = CODE%
 LDY #0                 \   (X Y) = &400 = 1024
 LDA #256-LEN1          \
 STA (V219-4,X)         \ In doPROT1 above we set V219(1 0) = &0218, so this
 STY ZP                 \ also sets the contents of &0218 (the low byte of
 STY P                  \ BPUTV) to 256 - LEN1, or &F1. We set the low byte to
                        \ 1 above, so BPUTV now contains &01F1, which we will
                        \ use at the start of part 4

 JSR crunchit           \ Call crunchit, which has now been modified to call the
                        \ MVDL routine on the stack, to move and decrypt &400
                        \ bytes from CODE% to &0400. We loaded WORDS9.bin to
                        \ CODE% in part 1, so this moves WORDS9

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&C)    \
 STA ZP+1               \   P(1 0) = &6300
 LDA #&63               \   ZP(1 0) = CODE% + &C
 STA P+1                \   (X Y) = &100 = 256
 LDY #0

 JSR crunchit           \ Call crunchit to move and decrypt &100 bytes from
                        \ CODE% + &C to &6300, so this moves P.ELITE

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&D)    \
 STA ZP+1               \   P(1 0) = &6100
 LDA #&61               \   ZP(1 0) = CODE% + &D
 STA P+1                \   (X Y) = &100 = 256
 LDY #0

 JSR crunchit           \ Call crunchit to move and decrypt &100 bytes from
                        \ CODE% + &D to &6100, so this moves P.A-SOFT

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&E)    \
 STA ZP+1               \   P(1 0) = &7600
 LDA #&76               \   ZP(1 0) = CODE% + &E
 STA P+1                \   (X Y) = &100 = 256
 LDY #0

 JSR crunchit           \ Call crunchit to move and decrypt &100 bytes from
                        \ CODE% + &E to &7600, so this moves P.(C)ASFT

 JSR PLL1               \ Call PLL1 to draw Saturn

 LDX #8                 \ Set the following:
 LDA #(HI(CODE%)+4)     \
 STA ZP+1               \   P(1 0) = &7800
 LDA #&78               \   ZP(1 0) = CODE% + &4
 STA P+1                \   (X Y) = &800 = 2048
 LDY #0                 \
 STY ZP                 \ Also set BLCNT = 0
 STY BLCNT
 STY P

 JSR crunchit           \ Call crunchit to move and decrypt &800 bytes from
                        \ CODE% + &4 to &7800, so this moves P.DIALS and PYTHON

 LDX #(3-(DISC AND 1))  \ Set the following:
 LDA #HI(UU%)           \
 STA ZP+1               \   P(1 0) = LE%
 LDA #LO(UU%)           \   ZP(1 0) = UU%
 STA ZP                 \   (X Y) = &300 = 768 (if we are building for tape)
 LDA #HI(LE%)           \        or &200 = 512 (if we are building for disc)
 STA P+1
 LDY #0
 STY P

 JSR crunchit           \ Call crunchit to move and decrypt either &200 or &300
                        \ bytes from UU% to LE%, leaving X = 0

