\ ******************************************************************************
\       Name: refund
\ ******************************************************************************

\ref2 LDY#187\JMPpres\Belgium

.refund

 STA T1
 LDA LASER,X
 BEQ ref3\CMPT1\BEQref2
 LDY #4
 CMP #POW
 BEQ ref1
 LDY #5
 CMP #POW+128
 BEQ ref1
 LDY #12\11
 CMP #Armlas
 BEQ ref1
\Mlas
 LDY #13\12

.ref1

 STX ZZ
 TYA
 JSR prx
 JSR MCASH
 LDX ZZ

.ref3

 LDA T1
 STA LASER,X
 RTS

