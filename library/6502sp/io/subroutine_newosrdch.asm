\ ******************************************************************************
\       Name: newosrdch
\ ******************************************************************************

.newosrdch

 JSR &FFFF
 CMP #128
 BCC P%+6

.badkey

 LDA #7
 CLC
 RTS
 CMP #32
 BCS coolkey
 CMP #13
 BEQ coolkey
 CMP #21
 BNE badkey

.coolkey

 CLC
 RTS

