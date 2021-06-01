\ ******************************************************************************
\
\       Name: n_name
\       Type: Subroutine
\   Category: Elite-A
\    Summary: AJD
\
\ ******************************************************************************

.n_name

 \ name ship in 0 <= Y <= &C
 LDX new_offsets,Y
 LDA #9
 STA &41

.n_lprint

 LDA new_ships,X
 STX &40
 JSR TT27
 LDX &40
 INX
 DEC &41
 BNE n_lprint
 RTS

