\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor by poking into screen memory
\
\ ------------------------------------------------------------------------------
\
\ Print a character at the text cursor (XC, YC), do a beep, print a newline,
\ or delete left (backspace).
\
\ Arguments:
\
\   A                   The character to be printed. Can be one of the
\                       following:
\
\                         * 7 (beep)
\
\                         * 10-13 (line feeds and carriage returns)
\
\                         * 32-95 (ASCII capital letters, numbers and
\                           punctuation)
\
\                         * 127 (delete the character to the left of the text
\                           cursor and move the cursor to the left)
\
\   XC                  Contains the text column to print at (the x-coordinate)
\
\   YC                  Contains the line number to print on (the y-coordinate)
\
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.R5

 JMP CB75B

.CB627

 LDA #2
 STA YC
 LDA K3
 JMP CB652

.RR4S

 JMP CB75B

.TT67X

 LDA #12                \ Set A to a carriage return character

                        \ Fall through into CHPR to print the newline

.CHPR

 STA K3                 \ Store the A register in K3 so we can retrieve it below

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3                 \ Store the A, X and Y registers, so we can restore
 STY YSAV2              \ them at the end (so they don't get changed by this
 STX XSAV2              \ routine)

 LDY QQ17               \ Load the QQ17 flag, which contains the text printing
                        \ flags

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ RR4S               \ RR4S (via the JMP in RR4S) to restore the registers
                        \ and return from the subroutine using a tail call

.CB652

 CMP #7                 \ If this is a beep character (A = 7), jump to R5,
 BEQ R5                 \ which will emit the beep, restore the registers and
                        \ return from the subroutine

 CMP #32                \ If this is an ASCII character (A >= 32), jump to RR1
 BCS RR1                \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #10                \ If this is control code 10 (line feed) then jump to
 BEQ RRX1               \ RRX1, which will move down a line, restore the
                        \ registers and return from the subroutine

 LDX #1                 \ If we get here, then this is control code 11-13, of
 STX XC                 \ which only 13 is used. This code prints a newline,
                        \ which we can achieve by moving the text cursor
                        \ to the start of the line (carriage return) and down
                        \ one line (line feed). These two lines do the first
                        \ bit by setting XC = 1, and we then fall through into
                        \ the line feed routine that's used by control code 10

.RRX1

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ RR4S               \ to RR4 (via the JMP in RR4S) to restore the registers
                        \ and return from the subroutine using a tail call

 INC YC                 \ Increment the text cursor y-coordinate to move it
                        \ down one row

 BNE RR4S               \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call (this BNE is
                        \ effectively a JMP as Y will never be zero)

.RR1

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95

 LDX XC
 CPX #&1F
 BCC CB676
 LDX #1
 STX XC
 INC YC

.CB676

 LDX YC
 CPX #&1B
 BCC CB67F
 JMP CB627

.CB67F

 CMP #&7F
 BNE CB686
 JMP CB7BF

.CB686

 INC XC

 LDA QQ11               \ If bits 5 and 6 of the view number are clear, jump to
 AND #%00110000         \ CB6A9
 BEQ CB6A9

 LDY fontBitPlane       \ If we are drawing in bit plane 1 only, jump to CB6A4
 CPY #1
 BEQ CB6A4

 AND #%00100000         \ If bit 5 of the view number is clear, jump to CB6A9
 BEQ CB6A9

 CPY #2                 \ If we are drawing in both bit planes (as Y is neither
 BNE CB6A9              \ 1 or 2), jump to CB6A9

 LDA K3
 CLC
 ADC #&5F

 JMP CB7CF

.CB6A4

                        \ If we get here then we are drawing in bit plane 1 only

 LDA K3
 JMP CB7CF

.CB6A9

                        \ If we get here then either bit 5 or bit 6 of the view
                        \ number are clear, or we are drawing in both bit planes

 LDA K3                 \ If the character to print in K3 is not a space, jump
 CMP #' '               \ to CB6B2 with the character in A
 BNE CB6B2

 JMP CB75B              \ We are printing a space, so jump to CB75B to return
                        \ from the subroutine

.CB6B2

 TAY                    \ Set Y to the character to print

 CLC
 ADC #&FD

 LDX #0
 STX P+2
 ASL A
 ROL P+2
 ASL A
 ROL P+2
 ASL A
 ROL P+2
 ADC #0
 STA P+1
 LDA P+2
 ADC #&FC
 STA P+2

 LDA #0
 STA SC+1

 LDA YC
 BNE CB6D8

 JMP CB8A6

.CB6D8

 LDA QQ11
 BNE CB6DF
 JMP CB83E

.CB6DF

 JSR subm_DBD8
 LDY XC
 DEY
 LDA (SC),Y
 BEQ CB6E9

.CB6E9

 LDA tileNumber
 BEQ CB75B
 CMP #&FF
 BEQ CB75B
 STA (SC),Y
 STA (SC2),Y
 INC tileNumber
 LDY fontBitPlane
 DEY
 BEQ CB772
 DEY
 BNE CB702
 JMP CB784

.CB702

 TAY
 LDX #&0C
 STX SC2+1
 ASL A
 ROL SC2+1
 ASL A
 ROL SC2+1
 ASL A
 ROL SC2+1
 STA SC2
 TYA
 LDX #&0D
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDY #0
 LDA (P+1),Y
 STA (SC),Y
 STA (SC2),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 STA (SC2),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 STA (SC2),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 STA (SC2),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 STA (SC2),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 STA (SC2),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 STA (SC2),Y
 INY
 LDA (P+1),Y
 STA (SC2),Y
 STA (SC),Y

.CB75B

 LDY YSAV2
 LDX XSAV2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3
 CLC
 RTS

.CB772

 LDX #&0C
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 JMP CB793

.CB784

 LDX #&0D
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC

.CB793

 LDY #0
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 JMP CB75B

.CB7BF

 JSR subm_DBD8
 LDY XC
 DEC XC
 LDA #0
 STA (SC),Y
 STA (SC2),Y
 JMP CB75B

.CB7CF

 PHA
 JSR subm_DBD8
 PLA
 CMP #&20
 BEQ CB7E5

.loop_CB7D8

 CLC
 ADC L00D9

.loop_CB7DB

 LDY XC
 DEY
 STA (SC),Y
 STA (SC2),Y
 JMP CB75B

.CB7E5

 LDY QQ11
 CPY #&9D
 BEQ CB7EF
 CPY #&DF
 BNE loop_CB7D8

.CB7EF

 LDA #0
 BEQ loop_CB7DB

.CB7F3

 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDY #0
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 ORA (SC),Y
 STA (SC),Y
 JMP CB75B

.CB83E

 LDA #0
 STA SC+1
 LDA YC
 BNE CB848
 LDA #&FF

.CB848

 CLC
 ADC #1
 ASL A
 ASL A
 ASL A
 ASL A
 ROL SC+1
 SEC
 ROL A
 STA SC
 LDA SC+1
 ROL A
 ADC nameBufferHi
 STA SC+1
 LDY XC
 DEY
 LDA (SC),Y
 BNE CB7F3
 LDA tileNumber
 BEQ CB8A3
 STA (SC),Y
 INC tileNumber
 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDY #0
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y
 INY
 LDA (P+1),Y
 STA (SC),Y

.CB8A3

 JMP CB75B

.CB8A6

 LDA #&21
 STA SC
 LDA nameBufferHi
 STA SC+1
 LDY XC
 DEY
 JMP CB6E9

