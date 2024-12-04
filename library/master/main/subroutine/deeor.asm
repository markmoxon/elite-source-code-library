\ ******************************************************************************
\
\       Name: DEEOR
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Unscramble the main code
\
\ ------------------------------------------------------------------------------
\
IF _MASTER_VERSION
\ The main game code and data are encrypted. This routine decrypts the game code
\ in two parts: the main game code between G% and F%, and the game data between
\ XX21 and the end of the game data at &B1FF.
\
ELIF _C64_VERSION
\ The main game code and data are encrypted. This routine decrypts the game code
\ in two parts: between G% and R%, and between C% and F%.
\
ELIF _APPLE_VERSION
\ The main game code and data are encrypted. This routine decrypts the game code
\ in two parts: between G% and R%, and between QQ18 and &1FFF.
\
ENDIF
\ In the BeebAsm version, the encryption is done by elite-checksum.py, but in
\ the original this would have been done by the BBC BASIC build scripts.
\
\ ******************************************************************************

.DEEOR

 LDA #LO(G%-1)          \ Set FRIN(1 0) = G%-1 as the low address of the
 STA FRIN               \ decryption block, so we decrypt from the start of the
 LDA #HI(G%-1)          \ DOENTRY routine
 STA FRIN+1

IF _MASTER_VERSION

 LDA #HI(F%-1)          \ Set (A Y) to F% as the high address of the decryption
 LDY #LO(F%-1)          \ block, so we decrypt to the end of the main game code
                        \ at F%

ELIF _C64_VERSION OR _APPLE_VERSION

 LDA #HI(R%-1)          \ Set (A Y) to R% as the high address of the decryption
 LDY #LO(R%-1)          \ block, so we decrypt to the end of the first block of
                        \ game code at R% (so we decrypt from DOENTRY to the end
                        \ of the ELITE C section)

ENDIF

 LDX #KEY1              \ Set X = KEY1 as the decryption seed (the value used to
                        \ encrypt the code, which is done in elite-checksum.py)

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, skip the call to DEEORS
 NOP                    \ and return from the subroutine to skip the second call
 RTS                    \ below

ELSE

 JSR DEEORS             \ Call DEEORS to decrypt between DOENTRY and F%

ENDIF

IF _MASTER_VERSION

 LDA #LO(XX21-1)        \ Set FRIN(1 0) = XX21-1 as the low address of the
 STA FRIN               \ decryption block
 LDA #HI(XX21-1)
 STA FRIN+1

 LDA #&B1               \ Set (A Y) = &B1FF as the high address of the
 LDY #&FF               \ decryption block

ELIF _C64_VERSION

 LDA #LO(C%-1)          \ Set FRIN(1 0) = C%-1 and  as the low address of the
 STA FRIN               \ decryption block, so we decrypt from the start of the
 LDA #HI(C%-1)          \ ELITE D section
 STA FRIN+1

 LDA #HI(F%-1)          \ Set (A Y) to F% as the high address of the decryption
 LDY #LO(F%-1)          \ block, so we decrypt to the end of the second block of
                        \ game code at F% (so we decrypt sections ELITE D to
                        \ ELITE K)

ELIF _APPLE_VERSION

 LDA #LO(QQ18-1)        \ Set FRIN(1 0) = QQ18-1 as the low address of the
 STA FRIN               \ decryption block
 LDA #HI(QQ18-1)
 STA FRIN+1

 LDA #&1F               \ Set (A Y) = &1FFF as the high address of the
 LDY #&FF               \ decryption block

ENDIF

 LDX #KEY2              \ Set X = KEY2 as the decryption seed (the value used to
                        \ encrypt the code, which is done in elite-checksum.py)

                        \ Fall through into DEEORS to decrypt between XX21 and
                        \ &B1FF

