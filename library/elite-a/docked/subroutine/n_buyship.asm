\ ******************************************************************************
\
\       Name: n_buyship
\       Type: Subroutine
\   Category: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.n_buyship

 LDX #&00
 SEC
 LDA #&0F   \LDA #&0D
 SBC QQ28
 SBC QQ28   \++
 STA QQ25

.n_bloop

 STX XX13
 JSR TT67
 LDX XX13
 INX
 CLC
 JSR pr2
 JSR TT162
 LDY XX13
 JSR n_name
 LDY XX13
 JSR n_price
 LDA #&16
 STA XC
 LDA #&09
 STA U
 SEC
 JSR BPRNT
 LDX XX13
 INX
 CPX QQ25
 BCC n_bloop
 JSR CLYNS
 LDA #&B9
 JSR prq
 JSR gnum
 BEQ jmp_start3
 BCS jmp_start3
 SBC #&00
 CMP QQ25
 BCS jmp_start3
 LDX #&02
 STX XC
 INC YC
 STA Q
 LDY cmdr_type
 JSR n_price
 CLC
 LDX #3

.n_addl

 LDA CASH,X
 ADC K,X
 STA XX16,X
 DEX
 BPL n_addl
 LDY Q
 JSR n_price
 SEC
 LDX #3

.n_subl

 LDA XX16,X
 SBC K,X
 STA K,X
 DEX
 BPL n_subl
 LDA Q
 BCS n_buy

.cash_query

 LDA #&C5
 JSR prq

.jmp_start3

 JSR dn2
 JMP BAY

.n_buy

 TAX
 LDY #3

.n_cpyl

 LDA K,Y
 STA CASH,Y
 DEY
 BPL n_cpyl
 LDA #&00
 LDY #&24

.n_wipe

 STA LASER,Y
 DEY
 BPL n_wipe

 STX cmdr_type          \ Set the current ship type in cmdr_type to X

 JSR n_load             \ Call n_load to load the details block for the new ship
                        \ type

 LDA new_range
 STA QQ14
 JSR msblob

IF _ELITE_A_6502SP_PARA

 JSR update_pod         \ Update the dashboard colours to reflect whether we
                        \ have an escape pod

ENDIF

 JMP BAY

