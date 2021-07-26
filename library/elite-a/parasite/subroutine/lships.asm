\ ******************************************************************************
\
\       Name: LSHIPS
\       Type: Subroutine
\   Category: Loader
\    Summary: AJD
\
\ ******************************************************************************

.LSHIPS

 LDA #0
 STA finder

.SHIPinA

 LDX #&00
 LDA tek
 CMP #&0A
 BCS mix_station
 INX

.mix_station

 LDY #&02
 JSR install_ship
 LDY #9

.mix_retry

 LDA #0
 STA X1

.mix_match

 JSR DORND

 CMP #ship_total        \ The number of different ship blueprints in Elite-A

 BCS mix_match
 ASL A
 ASL A
 STA Y1
 TYA
 AND #&07
 TAX
 LDA mix_bits,X
 LDX Y1
 CPY #16
 BCC mix_byte2
 CPY #24
 BCC mix_byte3
 INX \24-28

.mix_byte3

 INX \16-23

.mix_byte2

 INX \8-15
 AND ship_bits,X
 BEQ mix_fail

.mix_try

 JSR DORND
 LDX Y1
 CMP ship_bytes,X
 BCC mix_ok

.mix_fail

 DEC X1
 BNE mix_match
 LDX #ship_total*4

.mix_ok

 STY X2
 CPX #52  \ ANACONDA?
 BEQ mix_anaconda
 CPX #116 \ DRAGON?
 BEQ mix_dragon
 TXA
 LSR A
 LSR A
 TAX

.mix_install

 JSR install_ship
 LDY X2

.mix_next

 INY
 CPY #15
 BNE mix_skip
 INY
 INY

.mix_skip

 CPY #29
 BNE mix_retry
 RTS

.mix_anaconda

 LDX #13
 LDY #14
 JSR install_ship
 LDX #14
 LDY #15
 JMP mix_install

.mix_dragon

 LDX #29
 LDY #14
 JSR install_ship
 LDX #17
 LDY #15
 JMP mix_install

