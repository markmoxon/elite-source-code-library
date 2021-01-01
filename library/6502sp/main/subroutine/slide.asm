\ ******************************************************************************
\
\       Name: SLIDE
\       Type: Subroutine
\   Category: Demo
\    Summary: Display a Star Wars scroll text
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (Y X)               The contents of the scroll text to display
\
\ ******************************************************************************

.SLIDE

 JSR GRIDSET

 JSR ZEVB               \ Call ZEVB to zero-fill the Y1VB variable

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is yellow

 LDA #254               \ Set BALI = 254 to act as a counter from 254 to 2,
 STA BALI               \ decreasing by 2 each iteration

.SLL2

 JSR GRID               \ Call GRID

 DEC BALI               \ Set BALI = BALI - 2
 DEC BALI

 BNE SLL2               \ Loop back to SLL2 until the loop counter is 0 (so GRID
                        \ was last called with BALI = 2)

.SL1

 JSR ZEVB               \ Call ZEVB to zero-fill the Y1VB variable

 LDA #2                 \ Set BALI = 2 and fall into GRID below
 STA BALI

.GRID

 LDY #0                 \ Set UPO = 0
 STY UPO

 STY INWK+8             \ Set z_sign = 0

 STY INWK+1             \ Set x_hi = 0

 STY INWK+4             \ Set y_hi = 0

 DEY                    \ Decrement Y to 255, so the following loop starts with
                        \ the first byte from Y1TB

.GRIDL

 INY                    \ Increment Y

 STZ INWK+7             \ Set z_hi = 0

 LDA Y1TB,Y             \ Set A = the Y-th byte from Y1TB

 BNE P%+5               \ If A = 0, jump to GREX
 JMP GREX

 SEC
 SBC BALI

 BCC GRIDL

 STA R

 ASL A
 ROL INWK+7
 ASL A
 ROL INWK+7
 ADC #D
 STA INWK+6
 LDA INWK+7
 ADC #0
 STA INWK+7

 STZ S                  \ Set S = 0

 LDA #128
 STA P

 JSR ADD                \ Set (A X) = (A P) + (S R)

 STA INWK+5
 STX INWK+3
 LDA X1TB,Y
 EOR #128
 BPL GR2
 EOR #&FF
 INA

.GR2

 STA INWK
 LDA X1TB,Y
 EOR #128
 AND #128
 STA INWK+2
 STY YS
 JSR PROJ
 LDY YS
 LDA K3
 STA XX15
 LDA K3+1
 STA XX15+1
 LDA K4
 STA XX15+2
 LDA K4+1
 STA XX15+3
 STZ INWK+7 \++
 LDA Y2TB,Y
 SEC
 SBC BALI
 BCC GR6
 STA R
 ASL A
 ROL INWK+7
 ASL A
 ROL INWK+7
 ADC #D
 STA INWK+6
 LDA INWK+7
 ADC #0
 STA INWK+7
 STZ S
 LDA #128
 STA P
 JSR ADD
 STA INWK+5
 STX INWK+3
 LDA X2TB,Y
 EOR #128
 BPL GR3
 EOR #&FF
 INA \++

.GR3

 STA INWK
 LDA X2TB,Y
 EOR #128
 AND #128
 STA INWK+2
 JSR PROJ
 LDA K3
 STA XX15+4
 LDA K3+1
 STA XX15+5
 LDA K4
 STA XX12
 LDA K4+1
 STA XX12+1
 JSR LL145
 LDY YS
 BCS GR6
 INC UPO
 LDX UPO
 LDA X1
 STA X1UB,X
 LDA Y1
 STA Y1UB,X
 LDA X2
 STA X2UB,X
 LDA Y2
 STA Y2UB,X

.GR6

 JMP GRIDL

.GREX

 LDY UPO
 BEQ GREX2

.GRL2

 LDA Y1VB,Y
 BEQ GR4
 STA Y1
 LDA X1VB,Y
 STA X1
 LDA X2VB,Y
 STA X2
 LDA Y2VB,Y
 STA Y2

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2)

.GR4

 LDA X1UB,Y
 STA X1
 STA X1VB,Y
 LDA Y1UB,Y
 STA Y1
 STA Y1VB,Y
 LDA X2UB,Y
 STA X2
 STA X2VB,Y
 LDA Y2UB,Y
 STA Y2
 STA Y2VB,Y

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2)

 DEY
 BNE GRL2
 JSR LBFL

.GREX2

 RTS

