\ ******************************************************************************
\
\       Name: S%
\       Type: Subroutine
\   Category: Loader
\    Summary: Checksum, decrypt and unscramble the main game code, and start the
\             game
\
\ ------------------------------------------------------------------------------
\
\ This routine reverses the three copy protection mechanisms that the Big Code
\ File puts in place: the checksum in Checksum, the encryption in DEEOR, and
\ the code reversal in do65c02. In the BeebAsm version here, these three
\ protections are applied by elite-checksum.py, and the original 6502 assembly
\ language versions of the three encryption routines can be found in the
\ elite-checksum.asm file.
\
\ It also adds in a bit of Tube-specific copy protection, by transmitting the
\ do65c02 routine over the Tube before it is run. It's very crafty stuff!
\
\ ******************************************************************************

 EQUD 0                 \ These bytes appear to be unused

 RTS                    \ The checksum byte goes here, at S%-1. In the original
                        \ source this byte is set by the first call to ZP in the
                        \ Big Code File, though in the BeebAsm version this is
                        \ populated by elite-checksum.py

.S%

 CLD                    \ Clear the D flag to make sure we are in binary mode

 SEC                    \ Set the C flag

 LDA #LO(G%)            \ Set (1 0) = SC(1 0) = G%
 STA 0
 STA SC
 LDA #HI(G%)
 STA 1
 STA SC+1

 LDA #LO(F%-1)          \ Set (3 2) = F% - 1
 STA 2
 LDA #HI(F%-1)
 STA 3

 LDX #LO(prtblock)      \ Set (Y X) to point to the prtblock parameter block
 LDY #HI(prtblock)

 LDA #249               \ Send an OSWORD 249 command to the I/O processor, which
 JSR OSWORD             \ copies the code of the do65c02 routine from the I/O
                        \ processor to prtblock+2

 LDX #SC                \ Set X = SC, and because SC is in zero page, this means
                        \ that X contains the whole value of SC, so jumping to
                        \ (X), for example, would jump to the address in SC(1 0)

 EQUB &AD               \ This is the opcode for an LDA absolute instruction, so
                        \ it converts the two OSWORD size bytes at prtblock into
                        \ a harmless LDA &2702 instruction

.prtblock

 EQUB 2                 \ The number of bytes to transmit with this command

 EQUB &27               \ The number of bytes to receive with this command

 JMP (SC,X)             \ This block, between here and G%, is overwritten by the
 PHP                    \ code of the do65c02 routine from the I/O processor, so
 PHY                    \ this code is never run and is presumably just here to
 LDA #&34               \ throw the crackers off the scent - it just needs to be
 PHA                    \ at least as long as the do65c02 routine, which ends
 LDX #0                 \ with a jump to G% below to start the game
 RTS
 BRK
 EQUS "ELITE - By Ian Bell & David Braben"
 EQUB 10
 EQUB 13
 BRK
 LDA SC
 ADC 2
 CMP F%-1
 BNE P%-2
 EQUD &7547534
 EQUD &452365
 EQUB &8D

.G%

 JSR DEEOR              \ Decrypt the main game code between &1300 and &9FFF

 JSR COLD               \ Copy the recursive tokens and ship blueprints to their
                        \ correct locations

 JSR Checksum           \ Checksum the code from &1000 to &9FFF and check it
                        \ against S%-1

 JMP BEGIN              \ Jump to BEGIN to start the game

 NOP                    \ This instruction is not used

