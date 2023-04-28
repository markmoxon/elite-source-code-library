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
 JMP CB75B                                        ; B624: 4C 5B B7    L[.

.CB627
 LDA #2                                           ; B627: A9 02       ..
 STA YC                                           ; B629: 85 3B       .;
 LDA K3                                           ; B62B: A5 3D       .=
 JMP CB652                                        ; B62D: 4C 52 B6    LR.

.RR4S
 JMP CB75B                                        ; B630: 4C 5B B7    L[.

.TT67X

 LDA #12                \ Set A to a carriage return character

                        \ Fall through into CHPR to print the newline

.CHPR

 STA K3                 \ Store the A register in K3 so we can retrieve it below

 SET_NAMETABLE_0        \ Switch the base nametable address to nametable 0

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
                        \ the subroutine using a tail call (this BNE is effectively a JMP as Y
                        \ will never be zero)

.RR1

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95

 LDX XC                                           ; B66A: A6 32       .2
 CPX #&1F                                         ; B66C: E0 1F       ..
 BCC CB676                                        ; B66E: 90 06       ..
 LDX #1                                           ; B670: A2 01       ..
 STX XC                                           ; B672: 86 32       .2
 INC YC                                           ; B674: E6 3B       .;

.CB676

 LDX YC                                           ; B676: A6 3B       .;
 CPX #&1B                                         ; B678: E0 1B       ..
 BCC CB67F                                        ; B67A: 90 03       ..
 JMP CB627                                        ; B67C: 4C 27 B6    L'.

.CB67F

 CMP #&7F                                         ; B67F: C9 7F       ..
 BNE CB686                                        ; B681: D0 03       ..
 JMP CB7BF                                        ; B683: 4C BF B7    L..

.CB686

 INC XC                                           ; B686: E6 32       .2
 LDA W                                            ; B688: A5 9E       ..
 AND #&30 ; '0'                                   ; B68A: 29 30       )0
 BEQ CB6A9                                        ; B68C: F0 1B       ..
 LDY L0037                                        ; B68E: A4 37       .7
 CPY #1                                           ; B690: C0 01       ..
 BEQ CB6A4                                        ; B692: F0 10       ..
 AND #&20 ; ' '                                   ; B694: 29 20       )
 BEQ CB6A9                                        ; B696: F0 11       ..
 CPY #2                                           ; B698: C0 02       ..
 BNE CB6A9                                        ; B69A: D0 0D       ..
 LDA K3                                           ; B69C: A5 3D       .=
 CLC                                              ; B69E: 18          .
 ADC #&5F ; '_'                                   ; B69F: 69 5F       i_
 JMP CB7CF                                        ; B6A1: 4C CF B7    L..

.CB6A4

 LDA K3                                           ; B6A4: A5 3D       .=
 JMP CB7CF                                        ; B6A6: 4C CF B7    L..

.CB6A9

 LDA K3                                           ; B6A9: A5 3D       .=
 CMP #&20 ; ' '                                   ; B6AB: C9 20       .
 BNE CB6B2                                        ; B6AD: D0 03       ..
 JMP CB75B                                        ; B6AF: 4C 5B B7    L[.

.CB6B2

 TAY                                              ; B6B2: A8          .
 CLC                                              ; B6B3: 18          .
 ADC #&FD                                         ; B6B4: 69 FD       i.
 LDX #0                                           ; B6B6: A2 00       ..
 STX P+2                                          ; B6B8: 86 31       .1
 ASL A                                            ; B6BA: 0A          .
 ROL P+2                                          ; B6BB: 26 31       &1
 ASL A                                            ; B6BD: 0A          .
 ROL P+2                                          ; B6BE: 26 31       &1
 ASL A                                            ; B6C0: 0A          .
 ROL P+2                                          ; B6C1: 26 31       &1
 ADC #0                                           ; B6C3: 69 00       i.
 STA P+1                                          ; B6C5: 85 30       .0
 LDA P+2                                          ; B6C7: A5 31       .1
 ADC #&FC                                         ; B6C9: 69 FC       i.
 STA P+2                                          ; B6CB: 85 31       .1
 LDA #0                                           ; B6CD: A9 00       ..
 STA SC+1                                         ; B6CF: 85 08       ..
 LDA YC                                           ; B6D1: A5 3B       .;
 BNE CB6D8                                        ; B6D3: D0 03       ..
 JMP CB8A6                                        ; B6D5: 4C A6 B8    L..

.CB6D8

 LDA W                                            ; B6D8: A5 9E       ..
 BNE CB6DF                                        ; B6DA: D0 03       ..
 JMP CB83E                                        ; B6DC: 4C 3E B8    L>.

.CB6DF

 JSR LDBD8                                        ; B6DF: 20 D8 DB     ..
 LDY XC                                           ; B6E2: A4 32       .2
 DEY                                              ; B6E4: 88          .
 LDA (SC),Y                                       ; B6E5: B1 07       ..
 BEQ CB6E9                                        ; B6E7: F0 00       ..

.CB6E9

 LDA L00B8                                        ; B6E9: A5 B8       ..
 BEQ CB75B                                        ; B6EB: F0 6E       .n
 CMP #&FF                                         ; B6ED: C9 FF       ..
 BEQ CB75B                                        ; B6EF: F0 6A       .j
 STA (SC),Y                                       ; B6F1: 91 07       ..
 STA (L00BA),Y                                    ; B6F3: 91 BA       ..
 INC L00B8                                        ; B6F5: E6 B8       ..
 LDY L0037                                        ; B6F7: A4 37       .7
 DEY                                              ; B6F9: 88          .
 BEQ CB772                                        ; B6FA: F0 76       .v
 DEY                                              ; B6FC: 88          .
 BNE CB702                                        ; B6FD: D0 03       ..
 JMP CB784                                        ; B6FF: 4C 84 B7    L..

.CB702

 TAY                                              ; B702: A8          .
 LDX #&0C                                         ; B703: A2 0C       ..
 STX L00BB                                        ; B705: 86 BB       ..
 ASL A                                            ; B707: 0A          .
 ROL L00BB                                        ; B708: 26 BB       &.
 ASL A                                            ; B70A: 0A          .
 ROL L00BB                                        ; B70B: 26 BB       &.
 ASL A                                            ; B70D: 0A          .
 ROL L00BB                                        ; B70E: 26 BB       &.
 STA L00BA                                        ; B710: 85 BA       ..
 TYA                                              ; B712: 98          .
 LDX #&0D                                         ; B713: A2 0D       ..
 STX SC+1                                         ; B715: 86 08       ..
 ASL A                                            ; B717: 0A          .
 ROL SC+1                                         ; B718: 26 08       &.
 ASL A                                            ; B71A: 0A          .
 ROL SC+1                                         ; B71B: 26 08       &.
 ASL A                                            ; B71D: 0A          .
 ROL SC+1                                         ; B71E: 26 08       &.
 STA SC                                           ; B720: 85 07       ..
 LDY #0                                           ; B722: A0 00       ..
 LDA (P+1),Y                                      ; B724: B1 30       .0
 STA (SC),Y                                       ; B726: 91 07       ..
 STA (L00BA),Y                                    ; B728: 91 BA       ..
 INY                                              ; B72A: C8          .
 LDA (P+1),Y                                      ; B72B: B1 30       .0
 STA (SC),Y                                       ; B72D: 91 07       ..
 STA (L00BA),Y                                    ; B72F: 91 BA       ..
 INY                                              ; B731: C8          .
 LDA (P+1),Y                                      ; B732: B1 30       .0
 STA (SC),Y                                       ; B734: 91 07       ..
 STA (L00BA),Y                                    ; B736: 91 BA       ..
 INY                                              ; B738: C8          .
 LDA (P+1),Y                                      ; B739: B1 30       .0
 STA (SC),Y                                       ; B73B: 91 07       ..
 STA (L00BA),Y                                    ; B73D: 91 BA       ..
 INY                                              ; B73F: C8          .
 LDA (P+1),Y                                      ; B740: B1 30       .0
 STA (SC),Y                                       ; B742: 91 07       ..
 STA (L00BA),Y                                    ; B744: 91 BA       ..
 INY                                              ; B746: C8          .
 LDA (P+1),Y                                      ; B747: B1 30       .0
 STA (SC),Y                                       ; B749: 91 07       ..
 STA (L00BA),Y                                    ; B74B: 91 BA       ..
 INY                                              ; B74D: C8          .
 LDA (P+1),Y                                      ; B74E: B1 30       .0
 STA (SC),Y                                       ; B750: 91 07       ..
 STA (L00BA),Y                                    ; B752: 91 BA       ..
 INY                                              ; B754: C8          .
 LDA (P+1),Y                                      ; B755: B1 30       .0
 STA (L00BA),Y                                    ; B757: 91 BA       ..
 STA (SC),Y                                       ; B759: 91 07       ..

.CB75B

 LDY YSAV2                                        ; B75B: AC 82 04    ...
 LDX XSAV2                                        ; B75E: AE 81 04    ...
 LDA L00E9                                        ; B761: A5 E9       ..
 BPL CB76E                                        ; B763: 10 09       ..
 LDA PPU_STATUS                                   ; B765: AD 02 20    ..
 ASL A                                            ; B768: 0A          .
 BPL CB76E                                        ; B769: 10 03       ..
 JSR NAMETABLE0                                   ; B76B: 20 6D D0     m.

.CB76E

 LDA K3                                           ; B76E: A5 3D       .=
 CLC                                              ; B770: 18          .
 RTS                                              ; B771: 60          `

.CB772

 LDX #&0C                                         ; B772: A2 0C       ..
 STX SC+1                                         ; B774: 86 08       ..
 ASL A                                            ; B776: 0A          .
 ROL SC+1                                         ; B777: 26 08       &.
 ASL A                                            ; B779: 0A          .
 ROL SC+1                                         ; B77A: 26 08       &.
 ASL A                                            ; B77C: 0A          .
 ROL SC+1                                         ; B77D: 26 08       &.
 STA SC                                           ; B77F: 85 07       ..
 JMP CB793                                        ; B781: 4C 93 B7    L..

.CB784

 LDX #&0D                                         ; B784: A2 0D       ..
 STX SC+1                                         ; B786: 86 08       ..
 ASL A                                            ; B788: 0A          .
 ROL SC+1                                         ; B789: 26 08       &.
 ASL A                                            ; B78B: 0A          .
 ROL SC+1                                         ; B78C: 26 08       &.
 ASL A                                            ; B78E: 0A          .
 ROL SC+1                                         ; B78F: 26 08       &.
 STA SC                                           ; B791: 85 07       ..

.CB793

 LDY #0                                           ; B793: A0 00       ..
 LDA (P+1),Y                                      ; B795: B1 30       .0
 STA (SC),Y                                       ; B797: 91 07       ..
 INY                                              ; B799: C8          .
 LDA (P+1),Y                                      ; B79A: B1 30       .0
 STA (SC),Y                                       ; B79C: 91 07       ..
 INY                                              ; B79E: C8          .
 LDA (P+1),Y                                      ; B79F: B1 30       .0
 STA (SC),Y                                       ; B7A1: 91 07       ..
 INY                                              ; B7A3: C8          .
 LDA (P+1),Y                                      ; B7A4: B1 30       .0
 STA (SC),Y                                       ; B7A6: 91 07       ..
 INY                                              ; B7A8: C8          .
 LDA (P+1),Y                                      ; B7A9: B1 30       .0
 STA (SC),Y                                       ; B7AB: 91 07       ..
 INY                                              ; B7AD: C8          .
 LDA (P+1),Y                                      ; B7AE: B1 30       .0
 STA (SC),Y                                       ; B7B0: 91 07       ..
 INY                                              ; B7B2: C8          .
 LDA (P+1),Y                                      ; B7B3: B1 30       .0
 STA (SC),Y                                       ; B7B5: 91 07       ..
 INY                                              ; B7B7: C8          .
 LDA (P+1),Y                                      ; B7B8: B1 30       .0
 STA (SC),Y                                       ; B7BA: 91 07       ..
 JMP CB75B                                        ; B7BC: 4C 5B B7    L[.

.CB7BF

 JSR LDBD8                                        ; B7BF: 20 D8 DB     ..
 LDY XC                                           ; B7C2: A4 32       .2
 DEC XC                                           ; B7C4: C6 32       .2
 LDA #0                                           ; B7C6: A9 00       ..
 STA (SC),Y                                       ; B7C8: 91 07       ..
 STA (L00BA),Y                                    ; B7CA: 91 BA       ..
 JMP CB75B                                        ; B7CC: 4C 5B B7    L[.

.CB7CF

 PHA                                              ; B7CF: 48          H
 JSR LDBD8                                        ; B7D0: 20 D8 DB     ..
 PLA                                              ; B7D3: 68          h
 CMP #&20 ; ' '                                   ; B7D4: C9 20       .
 BEQ CB7E5                                        ; B7D6: F0 0D       ..

.loop_CB7D8

 CLC                                              ; B7D8: 18          .
 ADC L00D9                                        ; B7D9: 65 D9       e.

.loop_CB7DB

 LDY XC                                           ; B7DB: A4 32       .2
 DEY                                              ; B7DD: 88          .
 STA (SC),Y                                       ; B7DE: 91 07       ..
 STA (L00BA),Y                                    ; B7E0: 91 BA       ..
 JMP CB75B                                        ; B7E2: 4C 5B B7    L[.

.CB7E5

 LDY W                                            ; B7E5: A4 9E       ..
 CPY #&9D                                         ; B7E7: C0 9D       ..
 BEQ CB7EF                                        ; B7E9: F0 04       ..
 CPY #&DF                                         ; B7EB: C0 DF       ..
 BNE loop_CB7D8                                   ; B7ED: D0 E9       ..

.CB7EF

 LDA #0                                           ; B7EF: A9 00       ..
 BEQ loop_CB7DB                                   ; B7F1: F0 E8       ..

.CB7F3

 LDX L00B9                                        ; B7F3: A6 B9       ..
 STX SC+1                                         ; B7F5: 86 08       ..
 ASL A                                            ; B7F7: 0A          .
 ROL SC+1                                         ; B7F8: 26 08       &.
 ASL A                                            ; B7FA: 0A          .
 ROL SC+1                                         ; B7FB: 26 08       &.
 ASL A                                            ; B7FD: 0A          .
 ROL SC+1                                         ; B7FE: 26 08       &.
 STA SC                                           ; B800: 85 07       ..
 LDY #0                                           ; B802: A0 00       ..
 LDA (P+1),Y                                      ; B804: B1 30       .0
 ORA (SC),Y                                       ; B806: 11 07       ..
 STA (SC),Y                                       ; B808: 91 07       ..
 INY                                              ; B80A: C8          .
 LDA (P+1),Y                                      ; B80B: B1 30       .0
 ORA (SC),Y                                       ; B80D: 11 07       ..
 STA (SC),Y                                       ; B80F: 91 07       ..
 INY                                              ; B811: C8          .
 LDA (P+1),Y                                      ; B812: B1 30       .0
 ORA (SC),Y                                       ; B814: 11 07       ..
 STA (SC),Y                                       ; B816: 91 07       ..
 INY                                              ; B818: C8          .
 LDA (P+1),Y                                      ; B819: B1 30       .0
 ORA (SC),Y                                       ; B81B: 11 07       ..
 STA (SC),Y                                       ; B81D: 91 07       ..
 INY                                              ; B81F: C8          .
 LDA (P+1),Y                                      ; B820: B1 30       .0
 ORA (SC),Y                                       ; B822: 11 07       ..
 STA (SC),Y                                       ; B824: 91 07       ..
 INY                                              ; B826: C8          .
 LDA (P+1),Y                                      ; B827: B1 30       .0
 ORA (SC),Y                                       ; B829: 11 07       ..
 STA (SC),Y                                       ; B82B: 91 07       ..
 INY                                              ; B82D: C8          .
 LDA (P+1),Y                                      ; B82E: B1 30       .0
 ORA (SC),Y                                       ; B830: 11 07       ..
 STA (SC),Y                                       ; B832: 91 07       ..
 INY                                              ; B834: C8          .
 LDA (P+1),Y                                      ; B835: B1 30       .0
 ORA (SC),Y                                       ; B837: 11 07       ..
 STA (SC),Y                                       ; B839: 91 07       ..
 JMP CB75B                                        ; B83B: 4C 5B B7    L[.

.CB83E

 LDA #0                                           ; B83E: A9 00       ..
 STA SC+1                                         ; B840: 85 08       ..
 LDA YC                                           ; B842: A5 3B       .;
 BNE CB848                                        ; B844: D0 02       ..
 LDA #&FF                                         ; B846: A9 FF       ..

.CB848

 CLC                                              ; B848: 18          .
 ADC #1                                           ; B849: 69 01       i.
 ASL A                                            ; B84B: 0A          .
 ASL A                                            ; B84C: 0A          .
 ASL A                                            ; B84D: 0A          .
 ASL A                                            ; B84E: 0A          .
 ROL SC+1                                         ; B84F: 26 08       &.
 SEC                                              ; B851: 38          8
 ROL A                                            ; B852: 2A          *
 STA SC                                           ; B853: 85 07       ..
 LDA SC+1                                         ; B855: A5 08       ..
 ROL A                                            ; B857: 2A          *
 ADC L00E6                                        ; B858: 65 E6       e.
 STA SC+1                                         ; B85A: 85 08       ..
 LDY XC                                           ; B85C: A4 32       .2
 DEY                                              ; B85E: 88          .
 LDA (SC),Y                                       ; B85F: B1 07       ..
 BNE CB7F3                                        ; B861: D0 90       ..
 LDA L00B8                                        ; B863: A5 B8       ..
 BEQ CB8A3                                        ; B865: F0 3C       .<
 STA (SC),Y                                       ; B867: 91 07       ..
 INC L00B8                                        ; B869: E6 B8       ..
 LDX L00B9                                        ; B86B: A6 B9       ..
 STX SC+1                                         ; B86D: 86 08       ..
 ASL A                                            ; B86F: 0A          .
 ROL SC+1                                         ; B870: 26 08       &.
 ASL A                                            ; B872: 0A          .
 ROL SC+1                                         ; B873: 26 08       &.
 ASL A                                            ; B875: 0A          .
 ROL SC+1                                         ; B876: 26 08       &.
 STA SC                                           ; B878: 85 07       ..
 LDY #0                                           ; B87A: A0 00       ..
 LDA (P+1),Y                                      ; B87C: B1 30       .0
 STA (SC),Y                                       ; B87E: 91 07       ..
 INY                                              ; B880: C8          .
 LDA (P+1),Y                                      ; B881: B1 30       .0
 STA (SC),Y                                       ; B883: 91 07       ..
 INY                                              ; B885: C8          .
 LDA (P+1),Y                                      ; B886: B1 30       .0
 STA (SC),Y                                       ; B888: 91 07       ..
 INY                                              ; B88A: C8          .
 LDA (P+1),Y                                      ; B88B: B1 30       .0
 STA (SC),Y                                       ; B88D: 91 07       ..
 INY                                              ; B88F: C8          .
 LDA (P+1),Y                                      ; B890: B1 30       .0
 STA (SC),Y                                       ; B892: 91 07       ..
 INY                                              ; B894: C8          .
 LDA (P+1),Y                                      ; B895: B1 30       .0
 STA (SC),Y                                       ; B897: 91 07       ..
 INY                                              ; B899: C8          .
 LDA (P+1),Y                                      ; B89A: B1 30       .0
 STA (SC),Y                                       ; B89C: 91 07       ..
 INY                                              ; B89E: C8          .
 LDA (P+1),Y                                      ; B89F: B1 30       .0
 STA (SC),Y                                       ; B8A1: 91 07       ..

.CB8A3

 JMP CB75B                                        ; B8A3: 4C 5B B7    L[.

.CB8A6

 LDA #&21 ; '!'                                   ; B8A6: A9 21       .!
 STA SC                                           ; B8A8: 85 07       ..
 LDA L00E6                                        ; B8AA: A5 E6       ..
 STA SC+1                                         ; B8AC: 85 08       ..
 LDY XC                                           ; B8AE: A4 32       .2
 DEY                                              ; B8B0: 88          .
 JMP CB6E9                                        ; B8B1: 4C E9 B6    L..

