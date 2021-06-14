\ ******************************************************************************
\
\       Name: confirm
\       Type: Subroutine
\   Category: Save and load
\    Summary: AJD
\
\ ******************************************************************************

.confirm

 CMP save_lock
 BEQ confirmed
 LDA #&03
 JSR DETOK
 JSR t
 JSR CHPR
 ORA #&20
 PHA
 JSR TT67
 JSR FEED
 PLA
 CMP #&79

.confirmed

 RTS

