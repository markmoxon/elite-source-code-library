\ ******************************************************************************
\
\       Name: Main game loop (Part 5 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: AJD
\
\ ******************************************************************************

.MLOOP_FLIGHT

 LDX #&FF               \ Like main game loop 5
 TXS
 LDX GNTMP
 BEQ d_40e6
 DEC GNTMP

.d_40e6

 JSR DIALS
 JSR COMPAS
 LDA QQ11
 BEQ d_40f8
 \ AND PATG
 \ LSR A
 \ BCS d_40f8
 LDY #&02
 JSR DELAY
 \ JSR WSCAN

.d_40f8

 JSR DOKEY_FLIGHT
 JSR chk_dirn

