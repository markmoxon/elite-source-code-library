\ ******************************************************************************
\
\       Name: HA2
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Implement the picture_v command (draw vertical lines for the ship
\             hanger background)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a picture_v command. It draws the
\ specified number of vertical lines for the ship hanger's background.
\
\ ******************************************************************************

.HA2

 JSR tube_get           \ Get the parameter from the parasite for the command:
                        \
                        \   picture_v(line_count)
                        \
                        \ and store it as follows:
                        \
                        \   * A = the number of vertical lines to draw

 AND #&F8               \ AJD
 STA SC
 LDX #&60
 STX SC+&01
 LDX #&80
 LDY #&01

.HAL7

 TXA
 AND (SC),Y
 BNE HA6
 TXA
 ORA (SC),Y
 STA (SC),Y
 INY
 CPY #&08
 BNE HAL7
 INC SC+&01
 LDY #&00
 BEQ HAL7

.HA6

 RTS

