\ ******************************************************************************
\
\       Name: cour_buy
\       Type: Subroutine
\   Category: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.cour_buy

 LDA cmdr_cour
 ORA cmdr_cour+1
 BEQ cour_start
 JMP jmp_start3

.cour_start

 LDA #&0A
 STA XC
 LDA #&6F
 JSR DETOK
 JSR NLIN4

IF _ELITE_A_DOCKED

 JSR vdu_80

ELIF _ELITE_A_6502SP_PARA

 LDA #&80
 STA QQ17

ENDIF

 LDA QQ26
 EOR QQ0
 EOR QQ1
 EOR FIST
 EOR TALLY
 STA &46
 SEC
 LDA FIST
 ADC GCNT
 ADC cmdr_ship
 STA &47
 ADC &46
 SBC cmdr_courx
 SBC cmdr_coury
 AND #&0F
 STA &03AB
 BEQ cour_pres
 LDA #&00
 STA &49
 STA &4C
 JSR TT81

.cour_loop

 LDA &49
 CMP &03AB
 BCC cour_count

.cour_menu

 JSR CLYNS
 LDA #&CE
 JSR prq
 JSR gnum
 BEQ cour_pres
 BCS cour_pres
 TAX
 DEX
 CPX &49
 BCS cour_pres
 LDA #&02
 STA XC
 INC YC
 STX &46
 LDY &0C50,X
 LDA &0C40,X
 TAX
 JSR LCASH
 BCS cour_cash
 JMP cash_query

.cour_cash

 LDX &46
 LDA &0C00,X
 STA cmdr_courx
 LDA &0C10,X
 STA cmdr_coury
 CLC
 LDA &0C20,X
 ADC FIST
 STA FIST
 LDA &0C30,X
 STA cmdr_cour+1
 LDA &0C40,X
 STA cmdr_cour

.cour_pres

 JMP jmp_start3

.cour_count

 JSR TT20
 INC &4C
 BEQ cour_menu
 DEC &46
 BNE cour_count
 LDX &49
 LDA &6F
 CMP QQ0
 BNE cour_star
 LDA &6D
 CMP QQ1
 BNE cour_star
 JMP cour_next

.cour_star

 LDA &6F
 EOR &71
 EOR &47
 CMP FIST
 BCC cour_legal
 LDA #0

.cour_legal

 STA &0C20,X
 LDA &6F
 STA &0C00,X
 SEC
 SBC QQ0
 BCS cour_negx
 EOR #&FF
 ADC #&01

.cour_negx

 JSR SQUA2
 STA &41
 LDA &1B
 STA &40
 LDX &49
 LDA &6D
 STA &0C10,X
 SEC
 SBC QQ1
 BCS cour_negy
 EOR #&FF
 ADC #&01

.cour_negy

 LSR A
 JSR SQUA2
 PHA
 LDA &1B
 CLC
 ADC &40
 STA &81
 PLA
 ADC &41
 STA &82
 JSR LL5
 LDX &49
 LDA &6D
 EOR &71
 EOR &47
 LSR A
 LSR A
 LSR A
 CMP &81
 BCS cour_dist
 LDA &81

.cour_dist

 ORA &0C20,X
 STA &0C30,X
 STA &4A
 LSR A
 ROR &4A
 LSR A
 ROR &4A
 LSR A
 ROR &4A
 STA &4B
 STA &0C50,X
 LDA &4A
 STA &0C40,X
 LDA #&01
 STA XC
 CLC
 LDA &49
 ADC #&03
 STA YC
 LDX &49
 INX
 CLC
 JSR pr2
 JSR TT162
 JSR cpl
 LDX &4A
 LDY &4B
 SEC
 LDA #&19
 STA XC
 LDA #&06
 JSR TT11
 INC &49

.cour_next

 LDA &47
 STA &46
 JMP cour_loop

