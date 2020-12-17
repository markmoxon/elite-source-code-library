
 EQUD 0

 RTS  \ checksum byte goes here, set by first call to ZP in BCFS

.S%

 CLD
 SEC
 LDA #LO(G%)
 STA 0
 STA SC
 LDA #HI(G%)
 STA 1
 STA SC+1
 LDA #LO(F%-1)
 STA 2
 LDA #HI(F%-1)
 STA 3

 LDX #LO(prtblock)      \ Set (Y X) to point to the prtblock parameter block
 LDY #HI(prtblock)

 LDA #249               \ Send an OSWORD 249 command to the I/O processor
 JSR OSWORD

 LDX #SC
 EQUB &AD  \&8D

.prtblock

 EQUB 2
 EQUB &27
 JMP (SC,X)
 PHP
 PHY
 LDA #&34
 PHA
 LDX #0
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

 JSR DEEOR
 JSR COLD
 JSR Checksum
 JMP BEGIN
 NOP

