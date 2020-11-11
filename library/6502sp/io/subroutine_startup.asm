\ ******************************************************************************
\       Name: STARTUP
\ ******************************************************************************

.STARTUP

 LDA RDCHV
 STA newosrdch+1
 LDA RDCHV+1
 STA newosrdch+2
 LDA #(newosrdch MOD256)
 SEI
 STA RDCHV
 LDA #(newosrdch DIV256)
 STA RDCHV+1 \~~
 LDA #&39
 STA VIA+&E
 LDA #&7F
 STA &FE6E
 LDA IRQ1V
 STA VEC
 LDA IRQ1V+1
 STA VEC+1
 LDA #IRQ1 MOD256
 STA IRQ1V
 LDA #IRQ1 DIV256
 STA IRQ1V+1
 LDA #VSCAN
 STA USVIA+5
 CLI

.NOINT

 LDA WORDV
 STA notours+1
 LDA WORDV+1
 STA notours+2
 LDA #NWOSWD MOD256
 SEI
 STA WORDV
 LDA #NWOSWD DIV256
 STA WORDV+1
 CLI
 LDA #FF
 STA COL
 LDA Tina
 CMP #'T'
 BNE PUTBACK
 LDA Tina+1
 CMP #'I'
 BNE PUTBACK
 LDA Tina+2
 CMP #'N'
 BNE PUTBACK
 LDA Tina+3
 CMP #'A'
 BNE PUTBACK
 JSR Tina+4

