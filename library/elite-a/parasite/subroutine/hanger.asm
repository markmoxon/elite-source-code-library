\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: AJD
\
\ ******************************************************************************

.HANGER

 LDX #2

.HAL1

 STX XSAV
 LDA #&82
 LDX XSAV
 STX Q
 JSR DVID4

 LDA #&9A               \ Send command &9A to the I/O processor:
 JSR tube_write         \
                        \   picture_h(line_count, multiple_ships)
                        \
                        \ which will draw the specified number of horizontal
                        \ lines as the hanger floor, drawing lines between
                        \ multiple ships if required

 LDA P                  \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * line_count = P

 LDA YSAV               \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * multiple_ships = YSAV

 LDX XSAV
 INX
 CPX #&0D
 BCC HAL1
 LDA #&10

.HAL6

 STA XSAV

 LDA #&9B               \ Send command &9B to the I/O processor:
 JSR tube_write         \
                        \   picture_v(line_count)
                        \
                        \ which will draw the specified number of vertical
                        \ lines as the back wall of the hanger

 LDA XSAV               \ Send the parameter to the I/O processor:
 JSR tube_write         \
                        \   * line_count = XSAV

 LDA XSAV
 CLC
 ADC #&10
 BNE HAL6
 RTS

