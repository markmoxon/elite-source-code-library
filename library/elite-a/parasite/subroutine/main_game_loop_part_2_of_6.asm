\ ******************************************************************************
\
\       Name: Main game loop (Part 2 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: AJD
\
\ ******************************************************************************

.d_3fc0

 JSR M%                 \ Like main game loop 2
 DEC DLY
 BEQ d_3f54
 BPL d_3fcd
 INC DLY

.d_3fcd

 DEC MCNT
 BEQ d_3fd4

.d_3fd1

 JMP MLOOP_FLIGHT

.d_3f54

 LDA MCH
 JSR MESS
 LDA #&00
 STA DLY
 JMP d_3fcd

.d_3fd4

 LDA MJ
 BNE d_3fd1
 JSR DORND
 CMP #&33 \ trader fraction
 BCS MTT1
 LDA JUNK
 CMP #&03
 BCS MTT1
 JSR rand_posn \ IN
 BVS MTT4
 ORA #&6F
 STA INWK+29
 LDA SSPR
 BNE MLOOPS
 TXA
 BCS d_401e
 AND #&0F
 STA INWK+27
 BCC d_4022

.d_401e

 ORA #&7F
 STA INWK+30

.d_4022

 JSR DORND
 CMP #&0A
 AND #&01
 ADC #&05
 BNE horde_plain

