\ ******************************************************************************
\
\       Name: LOAD
\       Type: Subroutine
\   Category: Copy protection
\    Summary: This code accesses the disc directly (not used in this version as
\             disc protection is disabled)
\
\ ******************************************************************************

.LOAD

 JSR LOAD10

 PLA
 STA L0509
 PLA
 STA L050A
 PLA
 CLC
 ADC L0551
 STA L0557
 PLA
 STA L0559
 PLA
 STA L0558
 BEQ LOAD2

.LOAD1

 JSR LOAD7

 DEC L0558
 BNE LOAD1

.LOAD2

 LDA L0559
 BEQ LOAD3

 ORA #&20
 STA L0511
 JSR LOAD7

.LOAD3

 LDA L051A
 BEQ LOAD5

 LDY #&00

.LOAD4

 LDA &0700,Y
 STA &1000,Y
 INY
 BNE LOAD4

.LOAD5

 LDX L055B
 BEQ LOAD6

 LDX #&52
 LDY #&05
 JSR OSCLI

 LDX #&02

.LOAD6

 STX &76                \ Store the drive number in &76 for retrieval in ELITE4
 LDA #&15
 LDX #&00
 JSR OSBYTE

 LDA #&C9
 LDX #&01
 LDY #&01
 JMP OSBYTE

.LOAD7

 JSR LOAD11

 LDA #&28
 SEC
 SBC L0557
 STA L0545
 STA L050F
 LDA #&01
 JSR LOAD13

 LDA L050A
 CMP #&0E
 BNE LOAD8

 LDA L050F
 STA L051A
 STA L0525
 STA L0530
 LDA #&04
 JSR LOAD13

 LDA #&05
 JSR LOAD13

 LDA #&06
 JSR LOAD13

 JMP LOAD9

.LOAD8

 LDA #&03
 JSR LOAD13

.LOAD9

 LDA L053B
 STA L0545
 LDA #&01
 JSR LOAD13

 LDA L050A
 CLC
 ADC #&0A
 STA L050A
 INC L0557
 RTS

.LOAD10

 JSR LOAD11

 LDA L053B
 STA L054E
 LDA #&02
 JSR LOAD13

 RTS

.LOAD11

 LDA L0557
 LDX L055B
 BEQ LOAD12

 ASL A

.LOAD12

 STA L053B
 LDA #&00

.LOAD13

 STA R

.LOAD14

 LDA R
 ASL A
 TAX
 LDA L04FA,X
 LDY L04FA+1,X
 TAX
 STX P
 STY P+1
 LDA #127
 JSR OSWORD

 LDA R
 CMP #&03
 BCC LOAD15

 LDY #&0A
 LDA (P),Y
 AND #&DF
 BNE LOAD14

.LOAD15

 RTS

.L04FA

 EQUB &34

 EQUB &05, &3D, &05, &47, &05, &08, &05, &13
 EQUB &05, &1E, &05, &29, &05, &FF

.L0509

 EQUB &00

.L050A

 EQUB &0A

 EQUB &FF, &FF, &03, &57

.L050F

 EQUB &00, &F6

.L0511

 EQUB &2A, &00
 EQUB &FF, &00, &0E, &FF, &FF, &03, &57

.L051A
 
 EQUB &00
 EQUB &F6, &22, &00, &FF, &00, &07, &FF, &FF
 EQUB &03, &57

.L0525

 EQUB &00, &F8, &21, &00, &FF, &00
 EQUB &11, &FF, &FF, &03, &57

.L0530

 EQUB &00, &F9, &27
 EQUB &00, &FF, &FF, &FF, &FF, &FF, &01, &69

.L053B

 EQUB &00, &00, &FF, &FF, &FF, &FF, &FF, &02
 EQUB &7A, &12

.L0545

 EQUB &00, &00, &FF, &00, &07, &FF
 EQUB &FF, &03, &5B

.L054E

 EQUB &00, &00, &0A

.L0551

 EQUB &00, &44
 EQUB &52, &2E, &32, &0D

.L0557

 EQUB &03

.L0558

 EQUB &00

.L0559

 EQUB &00

 EQUB &80               \ This is location &5973, as referenced by part 1

.L055B

 EQUB &FF, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00

 EQUB &00               \ This is location &5A00, as referenced by part 1

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00

