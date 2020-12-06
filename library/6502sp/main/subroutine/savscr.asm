\ ******************************************************************************
\       Name: savscr
\ ******************************************************************************

.savscr

 JSR CTRL
 BPL FREEZE
 LDX #&11

.savscl

 LDA oscobl2,X
 STA oscobl,X
 DEX
 BPL savscl
 LDX #(oscobl MOD256)
 LDY #(oscobl DIV256)
 LDA #0
 JSR OSFILE
 INC scname+11
 JMP FREEZE

