\ ******************************************************************************
\
\       Name: iff_index
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ------------------------------------------------------------------------------
\
\ This routine is copied to &0D7A in part 1 above.
\
\ ******************************************************************************

.iff_index

 LDX cmdr_iff           \ iff code
 BEQ iff_not
 LDY #&24
 LDA (INF),Y
 ASL A
 ASL A
 BCS iff_cop
 ASL A
 BCS iff_trade
 LDY TYPE
 DEY
 BEQ iff_missle
 CPY #&08
 BCC iff_aster
 INX \ X=4

.iff_missle

 INX \ X=3

.iff_aster

 INX \ X=2

.iff_cop

 INX \ X=1

.iff_trade

 INX \ X=0

.iff_not

 RTS \ X=0

