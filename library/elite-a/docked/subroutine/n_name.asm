\ ******************************************************************************
\
\       Name: n_name
\       Type: Subroutine
\   Category: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.n_name

 \ name ship in 0 <= Y <= &C
 LDX new_offsets,Y
 LDA #9
 STA K+1

.n_lprint

 LDA new_ships,X
 STX K
 JSR TT27
 LDX K
 INX
 DEC K+1
 BNE n_lprint
 RTS

