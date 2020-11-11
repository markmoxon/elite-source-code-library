
 EQUD 0

 RTS  \ checksum byte goes here, set by first call to ZP in BCFS

.S%

 CLD
 SEC
 LDA #G%MOD256
 STA 0
 STA SC
 LDA #G%DIV256
 STA 1
 STA SC+1
 LDA #(F%-1)MOD256
 STA 2
 LDA #(F%-1)DIV256
 STA 3
 LDX #prtblock MOD256
 LDY #prtblock DIV256
 LDA #249
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
