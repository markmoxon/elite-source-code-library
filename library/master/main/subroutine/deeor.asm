\ ******************************************************************************
\
\       Name: DEEOR
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Unscramble the main code
\
\ ------------------------------------------------------------------------------
\
\ The main game code and data are encrypted. This routine decrypts the game code
\ in two parts: the main game code between DOENTRY and F%, and the game data
\ between XX21 and the end of the game data at &BFFF.
\
\ In the BeebAsm version, the encryption is done by elite-checksum.py, but in
\ the original this would have been done by the BBC BASIC build scripts.
\
\ ******************************************************************************

.DEEOR

 LDA #LO(DOENTRY-1)     \ Set FRIN(1 0) = DEEORS-1 as the low address of the
 STA FRIN               \ decryption block, so we decrypt from just after the
 LDA #HI(DOENTRY-1)     \ DEEORS routine
 STA FRIN+1

 LDA #HI(F%-1)          \ Set (A Y) to F% as the high address of the decryption
 LDY #LO(F%-1)          \ block, so we decrypt to the end of the main game code
                        \ at F%

 LDX #&19               \ Set X = &19 as the decryption seed (the value used to
                        \ encrypt the code, which is done in elite-checksum.py)

 JSR DEEORS             \ Call DEEORS to decrypt between DOENTRY and F%

 LDA #LO(XX21-1)        \ Set FRIN(1 0) = XX21-1 as the low address of the
 STA FRIN               \ decryption block
 LDA #HI(XX21-1)
 STA FRIN+1

 LDA #&B1               \ Set (A Y) = &B1FF as the high address of the
 LDY #&FF               \ decryption block

 LDX #&62               \ Set X = &62 as the decryption seed (the value used to
                        \ encrypt the code, which is done in elite-checksum.py)

                        \ Fall through into DEEORS to decrypt between XX21 and
                        \ &B1FF

