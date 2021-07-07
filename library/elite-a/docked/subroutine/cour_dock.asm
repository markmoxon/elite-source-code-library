\ ******************************************************************************
\
\       Name: cour_dock
\       Type: Subroutine
\   Category: Missions
\    Summary: AJD
\
\ ******************************************************************************

.cour_dock

 LDA cmdr_cour          \ If there is no special cargo delivery mission in
 ORA cmdr_cour+1        \ progress, then the mission counter in cmdr_cour(1 0)
 BEQ cour_quit          \ will be zero, so jump to cour_quit to return from the
                        \ subroutine

 LDA QQ0
 CMP cmdr_courx
 BNE cour_half
 LDA QQ1
 CMP cmdr_coury
 BNE cour_half
 LDA #&02
 JSR TT66
 LDA #&06
 STA XC
 LDA #&0A
 STA YC
 LDA #&71
 JSR DETOK
 LDX cmdr_cour
 LDY cmdr_cour+1
 SEC
 LDA #&06
 JSR TT11
 LDA #&E2
 JSR TT27
 LDX cmdr_cour
 LDY cmdr_cour+1
 JSR MCASH
 LDA #0
 STA cmdr_cour
 STA cmdr_cour+1
 LDY #&60
 JSR DELAY

.cour_half

 LSR cmdr_cour+1
 ROR cmdr_cour

.cour_quit

 RTS

