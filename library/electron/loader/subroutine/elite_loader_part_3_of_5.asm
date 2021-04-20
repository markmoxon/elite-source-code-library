\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Move recursive tokens and images
\
\ ------------------------------------------------------------------------------
\
\ Move the following memory blocks:
\
\   * WORDS9: move 4 pages (1024 bytes) from &4400 (CODE%) to &0400
\
\   * P.ELITE: move 1 page (256 bytes) from &4F00 (CODE% + &B00) to &5BE0
\
\   * P.A-SOFT: move 1 page (256 bytes) from &5000 (CODE% + &C00) to &5960
\
\   * P.(C)ASFT: move 1 page (256 bytes) from &5100 (CODE% + &D00) to &73A0
\
\   * P.DIALS: move 7 pages (1792 bytes) from &4800 (CODE% + &400) to &7620
\
\   * Move 1 page (256 bytes) from &5615 (UU%) to &0B00-&0BFF
\
\ and call the routine to draw Saturn between P.(C)ASFT and P.DIALS.
\
\ The dashboard image (P.DIALS) is moved into screen memory one page at a time,
\ but not in a contiguous manner - it has to take into account the &20 bytes of
\ blank margin at each edge of the screen (see the description of the screen
\ mode in B% above). So the seven rows of the dashboard are actually moved into
\ screen memory like this:
\
\     1 page from &4800 to &7620           = &7620
\     1 page from &4900 to &7720 + &40     = &7760
\     1 page from &4A00 to &7820 + 2 * &40 = &78A0
\     1 page from &4B00 to &7920 + 3 * &40 = &79E0
\     1 page from &4C00 to &7A20 + 4 * &40 = &7B20
\     1 page from &4D00 to &7B20 + 5 * &40 = &7C60
\     1 page from &4E00 to &7C20 + 6 * &40 = &7DA0
\
\ See part 1 above for more details on the above files and the locations that
\ they are moved to.
\
\ The code at UU% (see below) forms part of the loader code and is moved before
\ being run, so it's tucked away safely while the main game code is loaded and
\ decrypted.
\
\ In the unprotected version of the loader, the images are encrypted and this
\ part also decrypts them, but this is an unprotected version of the game, so
\ the encryption part of the crunchit routine is disabled.
\
\ ******************************************************************************

 LDX #4                 \ Set the following:
 STX P+1                \
 LDA #HI(CODE%)         \   P(1 0) = &0400
 STA ZP+1               \   ZP(1 0) = CODE%
 LDY #0                 \   (X Y) = &400 = 1024
 LDA #256-232           \
 CMP (V219-4,X)         \ The CMP instruction is an STA instruction in the
 STY ZP                 \ protected version of the loader, but this version has
 STY P                  \ been hacked to remove the protection, and the crackers
                        \ just switched the STA to a CMP to disable this bit of
                        \ the protection code

 JSR crunchit           \ Call crunchit to move &400 bytes from CODE% to &0400.
                        \ We loaded WORDS9.bin to CODE% in part 1, so this moves
                        \ WORDS9

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&B)    \
 STA ZP+1               \   P(1 0) = &5BE0
 LDA #&5B               \   ZP(1 0) = CODE% + &B
 STA P+1                \   (X Y) = &100 = 256
 LDA #&E0
 STA P
 LDY #0

 JSR crunchit           \ Call crunchit to move &100 bytes from CODE% + &B to
                        \ &5BE0, so this moves P.ELITE

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&C)    \
 STA ZP+1               \   P(1 0) = &5960
 LDA #&59               \   ZP(1 0) = CODE% + &C
 STA P+1                \   (X Y) = &100 = 256
 LDA #&60
 STA P
 LDY #0

 JSR crunchit           \ Call crunchit to move &100 bytes from CODE% + &C to
                        \ &5960, so this moves P.A-SOFT

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&D)    \
 STA ZP+1               \   P(1 0) = &73A0
 LDA #&73               \   ZP(1 0) = CODE% + &D
 STA P+1                \   (X Y) = &100 = 256
 LDA #&A0
 STA P
 LDY #0

 JSR crunchit           \ Call crunchit to move &100 bytes from CODE% + &D to
                        \ &73A0, so this moves P.(C)ASFT

 JSR PLL1               \ Call PLL1 to draw Saturn

 LDA #(HI(CODE%)+4)     \ Set the following:
 STA ZP+1               \
 LDA #&76               \   P(1 0) = &7620
 STA P+1                \   ZP(1 0) = CODE% + &4
 LDY #0                 \   Y = 0
 STY ZP                 \
 LDX #&20               \ Also set BLCNT = 0
 STY BLCNT
 STX P

.dialsL

 LDX #1                 \ Set (X Y) = &100 = 256

 JSR crunchit           \ Call crunchit to move &100 bytes from ZP(1 0) to
                        \ P(1 0), so this moves P.DIALS one row at a time

 CLC                    \ Set P(1 0) = P(1 0) + &40 to skip the screen margins
 LDA P
 ADC #&40
 STA P
 LDA P+1
 ADC #0
 STA P+1

 CMP #&7E               \ Loop back to copy the next row of the dashboard until
 BCC dialsL             \ we have poked the last one into screen memory

 LDX #1                 \ Set the following:
 LDA #HI(UU%)           \
 STA ZP+1               \   P(1 0) = LE%
 LDA #LO(UU%)           \   ZP(1 0) = UU%
 STA ZP                 \   (X Y) = &100 = 256
 LDA #HI(LE%)
 STA P+1
 LDY #0
 STY P

 JSR crunchit           \ Call crunchit to move &100 bytes from UU% to LE%

