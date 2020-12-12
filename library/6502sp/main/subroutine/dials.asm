\ ******************************************************************************
\       Name: DIALS
\ by sending a #RDPARAMS command to the I/O processor
\ ******************************************************************************

.DIALS

 LDA #RDPARAMS
 JSR OSWRCH
 JSR OSWRCH
 LDA ENERGY
 JSR OSWRCH
 LDA ALP1
 JSR OSWRCH
 LDA ALP2
 JSR OSWRCH
 LDA BETA
 JSR OSWRCH
 LDA BET1
 JSR OSWRCH
 LDA DELTA
 JSR OSWRCH
 LDA ALTIT
 JSR OSWRCH
 LDA MCNT
 JSR OSWRCH
 LDA FSH
 JSR OSWRCH
 LDA ASH
 JSR OSWRCH
 LDA QQ14
 JSR OSWRCH
 LDA GNTMP
 JSR OSWRCH
 LDA CABTMP
 JSR OSWRCH
 LDA FLH
 JSR OSWRCH
 LDA ESCP
 JSR OSWRCH
 LDA MCNT
 AND #3
 BEQ P%+3
 RTS
 JMP COMPAS

