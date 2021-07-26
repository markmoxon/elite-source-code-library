\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Implement the picture_h command (draw horizontal lines for the
\             ship hanger floor)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a picture_h command. It draws a
\ specified number of horizontal lines for the ship hanger's floor, making sure
\ it draws between the ships when there are multiple ships in the hanger.
\
\ ******************************************************************************

.HANGER

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA picture_1          \
 JSR tube_get           \   picture_h(line_count, multiple_ships)
 STA picture_2          \
                        \ and store them as follows:
                        \
                        \   * picture_1 = the number of horizontal lines to draw
                        \
                        \   * picture_2 = 0 if there is only one ship, non-zero
                        \                 otherwise

 LDA picture_1          \ AJD
 CLC
 ADC #&60
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA SC+&01
 LDA picture_1
 AND #&07
 STA SC
 LDY #&00
 JSR HAS2
 LDA #&04
 LDY #&F8
 JSR HAS3
 LDY picture_2
 BEQ l_2045
 JSR HAS2
 LDY #&80
 LDA #&40
 JSR HAS3

.l_2045

 RTS

