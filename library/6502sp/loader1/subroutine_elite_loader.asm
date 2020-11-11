\ ******************************************************************************
\       Name: Elite loader
\ ******************************************************************************

.ENTRY

 CLD 
 LDA #&81
 LDX #0
 LDY #&FF
 JSR OSBYTE
 TXA 
 BNE not0
 TYA 
 BNE not0
 JMP happy

.not0

 INX 
 BNE blap1
 INY 
 BEQ blap2

.blap1

 JMP happy

\JSRZZZAP\BRK\BRK\EQUS" This program only runs on a BBC Micro with 6502 Second Processor\EQUW&0C0A\BRK

.blap2

 LDA #&EA
 DEY 
 JSR OSBYTE
 TXA 
 BNE happy
 JSR ZZZAP
 BRK 
 BRK 
 EQUS "This program needs a 6502 Second Processor"
 EQUW &D0A
 BRK 

.ZZZAP

 LDA #(happy MOD256)
 STA ZP
 LDX #(happy DIV256)
 LDY #0

.ZZZAPL

 STX ZP+1
 STA (ZP),Y
 INY 
 BNE ZZZAPL
 INX 
 CPX #((MESS2 DIV256)+1)
 BNE ZZZAPL
 RTS 

.happy

\  Only run if OSBYTE&81,0,&FF returns X and Y zero OR if (OSBYTE&81,0,&FF         returns XY = &FFFF AND OSBYTE&EA,0,&FF returns X nonzero)
\.....
 LDA #16
 LDX #3
 JSR OSBYTE \ADC
 LDA #190
 LDX #8
 JSR OSB \8bitADC
 LDA #200
 LDX #3
 JSR OSB \break,escape
\LDA#144\LDX#255\JSROSB \TV
 LDA #225
 LDX #128
 JSR OSB \fn keys
 LDA #13
 LDX #2
 JSR OSB \kybrd buffer
 LDA #(B% MOD256)
 STA ZP
 LDA #(B% DIV256)
 STA ZP+1
 LDY #0

.LOOP

 LDA (ZP),Y
 JSR OSWRCH
 INY 
 CPY #N%
 BNE LOOP \set up mode

 LDA #20
 LDX #0
 JSR OSB \Implode character definitions
 LDA #4
 LDX #1
 JSR OSB \cursor
 LDA #9
 LDX #0
 JSR OSB \flashing
 JSR PLL1 \Draw Saturn

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

 LDX #(MESS1 MOD256)
 LDY #(MESS1 DIV256)
 JSR SCLI \*DIR E

 LDX #(MESS2 MOD256)
 LDY #(MESS2 DIV256)
 JMP SCLI \*RUN ELITEa

