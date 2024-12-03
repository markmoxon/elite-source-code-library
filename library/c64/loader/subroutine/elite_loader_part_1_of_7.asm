\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 7)
\       Type: Subroutine
\   Category: Loader
\    Summary: Unscramble the loader code and game data
\
\ ******************************************************************************

.ENTRY

 CLD                    \ Clear the decimal flag, so we're not in decimal mode

 LDA #LO(U%-1)          \ Set FRIN(1 0) = U%-1 as the low address of the
 STA FRIN               \ decryption block, so we decrypt the loader routine
 LDA #HI(U%-1)          \ at U% below
 STA FRIN+1

 LDA #HI(V%-1)          \ Set (A Y) to V% as the high address of the decryption
 LDY #LO(V%-1)          \ block, so we decrypt to V% at the end of the loader
                        \ routine

 LDX #KEY3              \ Set X = KEY3 as the decryption seed (the value used to
                        \ encrypt the code, which is done in elite-checksum.py)

 JSR DEEORS             \ Call DEEORS to decrypt between U% and V%

 LDA #LO(W%-1)          \ Set FRIN(1 0) = W%-1 as the low address of the
 STA FRIN               \ decryption block, so we decrypt the game data at
 LDA #HI(W%-1)          \ at W% above
 STA FRIN+1

 LDA #HI(X%-1)          \ Set (A Y) to X% as the high address of the decryption
 LDY #LO(X%-1)          \ block, so we decrypt to X% at the end of the game data

 LDX #KEY4              \ Set X = KEY4 as the decryption seed (the value used to
                        \ encrypt the code, which is done in elite-checksum.py)

 JSR DEEORS             \ Call DEEORS to decrypt between W% and X%

 JMP U%                 \ Now that both the game data and the loader routine
                        \ have been decrypted, jump to the loader routine at U%
                        \ to load the game

