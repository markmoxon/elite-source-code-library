\ ******************************************************************************
\
\       Name: SOMEPROT
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Implement the OSWORD 249 command (some copy protection)
\
\ ******************************************************************************

.SOMEPROT

 LDY #2

.SMEPRTL

 LDA do65C02-2,Y
 STA (OSSC),Y
 INY
 CPY #protlen+2
 BCC SMEPRTL
 RTS

