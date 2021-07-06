\ ******************************************************************************
\
\       Name: cour_buy
\       Type: Subroutine
\   Category: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.cour_buy

 LDA cmdr_cour          \ If there is no special cargo delivery mission in
 ORA cmdr_cour+1        \ progress, then the mission counter in cmdr_cour(1 0)
 BEQ cour_start         \ will be zero, so jump to cour_start to skip the next
                        \ instruction

 JMP jmp_start3         \ There is already a special cargo delivery mission in
                        \ progress, so jump to jmp_start3 to make a beep and
                        \ show the cargo bay

.cour_start

 LDA #&0A
 STA XC
 LDA #&6F
 JSR DETOK
 JSR NLIN4

IF _ELITE_A_DOCKED

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case

ELIF _ELITE_A_6502SP_PARA

 LDA #&80
 STA QQ17

ENDIF

 LDA QQ26
 EOR QQ0
 EOR QQ1
 EOR FIST
 EOR TALLY
 STA INWK
 SEC
 LDA FIST
 ADC GCNT
 ADC cmdr_type
 STA INWK+1
 ADC INWK
 SBC cmdr_courx
 SBC cmdr_coury
 AND #&0F
 STA QQ25
 BEQ cour_pres
 LDA #&00
 STA INWK+3
 STA INWK+6
 JSR TT81

.cour_loop

 LDA INWK+3
 CMP QQ25
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
 CPX INWK+3
 BCS cour_pres
 LDA #&02
 STA XC
 INC YC
 STX INWK
 LDY &0C50,X
 LDA &0C40,X
 TAX
 JSR LCASH
 BCS cour_cash
 JMP cash_query

.cour_cash

 LDX INWK
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
 INC INWK+6
 BEQ cour_menu
 DEC INWK
 BNE cour_count
 LDX INWK+3
 LDA QQ15+3
 CMP QQ0
 BNE cour_star
 LDA QQ15+1
 CMP QQ1
 BNE cour_star
 JMP cour_next

.cour_star

 LDA QQ15+3
 EOR QQ15+5
 EOR INWK+1
 CMP FIST
 BCC cour_legal
 LDA #0

.cour_legal

 STA &0C20,X
 LDA QQ15+3
 STA &0C00,X
 SEC
 SBC QQ0
 BCS cour_negx
 EOR #&FF
 ADC #&01

.cour_negx

 JSR SQUA2
 STA K+1
 LDA P
 STA K
 LDX INWK+3
 LDA QQ15+1
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
 LDA P
 CLC
 ADC K
 STA Q
 PLA
 ADC K+1
 STA R
 JSR LL5
 LDX INWK+3
 LDA QQ15+1
 EOR QQ15+5
 EOR INWK+1
 LSR A
 LSR A
 LSR A
 CMP Q
 BCS cour_dist
 LDA Q

.cour_dist

 ORA &0C20,X
 STA &0C30,X
 STA INWK+4
 LSR A
 ROR INWK+4
 LSR A
 ROR INWK+4
 LSR A
 ROR INWK+4
 STA INWK+5
 STA &0C50,X
 LDA INWK+4
 STA &0C40,X
 LDA #&01
 STA XC
 CLC
 LDA INWK+3
 ADC #&03
 STA YC
 LDX INWK+3
 INX
 CLC
 JSR pr2
 JSR TT162
 JSR cpl
 LDX INWK+4
 LDY INWK+5
 SEC
 LDA #&19
 STA XC
 LDA #&06
 JSR TT11
 INC INWK+3

.cour_next

 LDA INWK+1
 STA INWK
 JMP cour_loop

