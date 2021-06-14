\ ******************************************************************************
\
\       Name: do_FSCV
\       Type: Subroutine
\   Category: Loader
\    Summary: AJD
\
\ ******************************************************************************

 \ trap FSCV

.do_FSCV

 JSR restorews \ restore workspace

.old_FSCV

 JSR &100 \ address modified by master setup
 JMP savews \ save workspace, restore characters

 \ restore ROM workspace

.restorews

 PHA
 PHX
 LDX #0

.getws

 \ restore absolute workspace

.get0

 LDA &C000,X \ address modified by master set-up
 STA &C000,X

.get1

 LDA &C100,X \ address modified by master set-up
 STA &C100,X

.get2

 LDA &C200,X \ address modified by master set-up
 STA &C200,X
 INX
 BNE getws
 PLX
 PLA
 RTS

