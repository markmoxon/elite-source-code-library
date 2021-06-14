\ ******************************************************************************
\
\       Name: n_load
\       Type: Subroutine
\   Category: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.n_load

 LDY new_type
 LDX new_offsets,Y
 LDY #0

.n_lname

 CPY #9
 BCS n_linfo
 LDA new_ships,X
 EOR #&23
 STA new_name,Y

.n_linfo

 LDA new_details,X
 STA new_pulse,Y
 INX
 INY
 CPY #13
 BNE n_lname
 LDA new_max
 EOR #&FE
 STA new_min
 LDY #&0B

.count_lasers

 LDX count_offs,Y
 LDA LASER,X
 BEQ count_sys
 DEC new_hold

.count_sys

 DEY
 BPL count_lasers
 RTS

