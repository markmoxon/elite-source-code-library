\ ******************************************************************************
\
\       Name: install_ship
\       Type: Subroutine
\   Category: Universe
\    Summary: AJD
\
\ ******************************************************************************

.install_ship

 \ install ship X in position Y with flags A
 TXA
 ASL A
 PHA
 ASL A
 TAX
 LDA ship_flags,Y
 AND #&7F
 ORA ship_bytes+1,X
 STA ship_flags,Y
 TYA
 ASL A
 TAY
 PLA
 TAX
 LDA ship_list,X
 STA XX21-2,Y
 LDA ship_list+1,X
 STA XX21-1,Y
 RTS

 \printer:
 \ TXA
 \ PHA
 \ LDA #&9C
 \ JSR tube_write
 \ JSR tube_read
 \ PLA
 \ TAX
 \ RTS

