\ ******************************************************************************
\       Name: DEMON
\ ******************************************************************************

.DEMON

 LDA #1
 JSR TT66
 JSR RESET
 LDA #0
 STA ALPHA
 STA ALP1
 STA DELTA
 STA scacol+CYL
 JSR DOVDU19
 JSR nWq
 LDX #(acorn MOD256)
 LDY #(acorn DIV256)
 JSR SLIDE

 JSR ZINF2              \ Call ZINF2 to reset INWK and the orientation vectors,
                        \ with nosev pointing out of the screen

 LDA #128
 STA INWK+5
 LDA #100
 STA INWK+3
 LDA #LGO
 STA TYPE
 JSR NWSHP
 LDA #150
 STA MCNT

.FLYL1

 LDA INWK+6
 CLC
 ADC #3
 STA INWK+6
 LDA INWK+7
 ADC #0
 STA INWK+7
 JSR LL9
 DEC MCNT
 BNE FLYL1

.FLYL2

 LDA INWK+6
 CLC
 ADC #2
 STA INWK+6
 LDA INWK+7
 ADC #0
 STA INWK+7
 LDA #128
 JSR TWIST2
\DECINWK+3
 JSR LL9
 LDA INWK+14
 BPL FLYL2

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace

 JSR ZINF2              \ Call ZINF2 to reset INWK and the orientation vectors,
                        \ with nosev pointing out of the screen

 LDA #108
 STA INWK+3
 LDA #40
 STA INWK+6
 LDA #128
 STA INWK+8
 LDA #CYL
 STA TYPE
 JSR NWSHP
 LDA #1
 STA INWK+27
 STA HIMCNT
 LDA #90
 STA MCNT
 JSR TWIST
 JSR TWIST
 JSR TWIST

.FLYL4

 JSR LL9
 JSR MVEIT
 DEC MCNT
 BNE FLYL4
 DEC HIMCNT
 BPL FLYL4
 JSR ZZAAP
 LDA #0
 JSR NOISE
 LDY #10
 JSR DELAY
 LDA #44
 STA INWK+29
 LDA #8
 STA INWK+27
 LDA #&87
 STA INWK+30

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace

 LDA #128
 TSB K%+31 \++
 JSR EXNO3
 JSR ZZAAP

.FLYL5

 LDX #NI%-1

.DML3

 LDA K%,X
 STA INWK,X
 DEX
 BPL DML3
 INX
 JSR GINF
 LDA XX21-2+2*LGO
 STA XX0
 LDA XX21-1+2*LGO
 STA XX0+1
 LDA #LGO
 STA TYPE
 INC INWK
 JSR LL9

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace

 JSR PBFL               \ Call PBFL to send the contents of the pixel buffer to
                        \ the I/O processor for plotting on-screen

 LDA INWK+31
 AND #&A0
 CMP #&A0
 PHP
 LDX #NI%-1

.DML4

 LDA K%+NI%,X
 STA INWK,X
 DEX
 BPL DML4
 LDX #1
 JSR GINF
 LDA XX21-2+2*CYL
 STA XX0
 LDA XX21-1+2*CYL
 STA XX0+1
 LDA #CYL
 STA TYPE
 JSR MVEIT
 JSR LL9

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace

 PLP
 BNE FLYL5
 LDA #14
 STA DELTA
 STZ DELT4 \++
 LSR A
 ROR DELT4
 LSR A
 ROR DELT4
 STA DELT4+1
 LDX #(byian MOD256)
 LDY #(byian DIV256)
 JSR SLIDE
 LDX #NI%-1

.DML5

 LDA K%+NI%,X
 STA INWK,X
 DEX
 BPL DML5

.FLYL6

 JSR STARS1
 JSR MVEIT
 JSR LL9
 LDA INWK+8
 BPL FLYL6
 LDX #(true3 MOD256)
 LDY #(true3 DIV256)
 JSR SLIDE
 JSR RES2
 LDA #&E0
 STA INWK+14
 STZ DELTA
 STZ ALPHA
 STZ ALP1 \++
 LDX #15
 STX INWK+27
 LDX #5
 STX INWK+7
 LDA #ADA
 STA TYPE
 JSR NWSHP

.FLYL7

 JSR MVEIT
 JSR LL9
 LDA INWK+7
 BNE FLYL7
 LDA #3
 STA INWK+29
 STA INWK+30
 LDA INWK+8
 BPL FLYL7
 JSR SCAN
 JSR RES2
 LDA #CYAN2
 STA scacol+CYL
 JMP DEATH2 \More Demo stuff here

