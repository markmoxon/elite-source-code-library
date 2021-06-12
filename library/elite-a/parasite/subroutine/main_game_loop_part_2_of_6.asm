\ ******************************************************************************
\
\       Name: Main game loop (Part 2 of 6)
\       Type: Subroutine
\   Category: Elite-A: Main loop
\    Summary: AJD
\
\ ******************************************************************************

.d_3fc0

 JSR M%                 \ Like main game loop 2
 DEC &034A
 BEQ d_3f54
 BPL d_3fcd
 INC &034A

.d_3fcd

 DEC &8A
 BEQ d_3fd4

.d_3fd1

 JMP MLOOP_FLIGHT

.d_3f54

 LDA &03A4
 JSR MESS
 LDA #&00
 STA &034A
 JMP d_3fcd

.d_3fd4

 LDA &0341
 BNE d_3fd1
 JSR DORND
 CMP #&33 \ trader fraction
 BCS MTT1
 LDA &033E
 CMP #&03
 BCS MTT1
 JSR rand_posn \ IN
 BVS MTT4
 ORA #&6F
 STA &63
 LDA &0320
 BNE MLOOPS
 TXA
 BCS d_401e
 AND #&0F
 STA &61
 BCC d_4022

.d_401e

 ORA #&7F
 STA &64

.d_4022

 JSR DORND
 CMP #&0A
 AND #&01
 ADC #&05
 BNE horde_plain

