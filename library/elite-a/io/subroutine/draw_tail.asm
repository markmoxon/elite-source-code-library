\ ******************************************************************************
\
\       Name: draw_tail
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the draw_tail command (draw a ship on the 3D scanner)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a draw_tail command. It draws a
\ ship on the 3D scanner, as a dot and (if applicable) a tail, using the base
\ and alternating colours specified (so it can draw a striped tail for when an
\ I.F.F. system is fitted).
\
\ ******************************************************************************

.draw_tail

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA X1                 \
 JSR tube_get           \   draw_tail(x, y, base_colour, alt_colour, height)
 STA Y1                 \
 JSR tube_get           \ and store them as follows:
 STA COL                \
 JSR tube_get           \   * X1 = ship's screen x-coordinate on the scanner
 STA Y2                 \
 JSR tube_get           \   * Y1 = ship's screen y-coordinate on the scanner
 STA P                  \
                        \   * COL = base colour
                        \
                        \   * Y2 = alternating (EOR) colour
                        \
                        \   * P = stick height

.SC48

 JSR CPIX2              \ Like SC48 in SCAN AJD
 DEC Y1
 JSR CPIX2

 LDA CTWOS+1,X
 AND COL \ iff
 STA COL

 LDA CTWOS+1,X
 AND Y2 \ COL2?
 STA Y2
 LDX P
 BEQ RTS
 BMI d_55db

.VLL1

 DEY
 BPL VL1
 LDY #&07
 DEC SC+&01

.VL1

 LDA COL
 EOR Y2 \ iff drawpix_4
 STA COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BNE VLL1

.RTS

 RTS

.d_55db

 INY
 CPY #&08
 BNE VLL2
 LDY #&00
 INC SC+&01

.VLL2

 INY
 CPY #&08
 BNE VL2
 LDY #&00
 INC SC+&01

.VL2

 LDA COL
 EOR Y2 \ iff drawpix_4
 STA COL
 EOR (SC),Y
 STA (SC),Y
 INX
 BNE VLL2
 RTS

