\ ******************************************************************************
\
\       Name: GTNME
\       Type: Subroutine
\   Category: Save and load
\    Summary: Get the commander's name
\
\ ------------------------------------------------------------------------------
\
\ Get the commander's name for loading or saving a commander file. The name is
\ stored at INWK, terminated by a return character (13).
\
\ If Escape is pressed or a blank name is entered, then INWK is set to the name
\ from the last saved commander block.
\
\ ******************************************************************************

.GTNME

 LDA #1                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 1

 LDA #123               \ Print recursive token 123 ("{crlf}COMMANDER'S NAME? ")
 JSR TT27

 JSR DEL8               \ Wait for 8/50 of a second (0.16 seconds)

 LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
 STA SHEILA+&4E         \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

 LDA #15                \ Perform a *FX 15,0 command (flush all buffers)
 TAX
 JSR OSBYTE

 LDX #LO(RLINE)         \ Call OSWORD with A = 0 and (Y X) pointing to the
 LDY #HI(RLINE)         \ configuration block below, which reads a line from
 LDA #0                 \ the current input stream (i.e. the keyboard)
 JSR OSWORD

\LDA #%00000001         \ These instructions are commented out in the original
\STA SHEILA+&4E         \ source, but they would set 6522 System VIA interrupt
                        \ enable register IER (SHEILA &4E) bit 1 (i.e. disable
                        \ the CA2 interrupt, which comes from the keyboard)

 BCS TR1                \ The C flag will be set if we pressed Escape when
                        \ entering the name, in which case jump to TR1 to copy
                        \ the last saved commander's name from NA% to INWK
                        \ and return from the subroutine there

 TYA                    \ The OSWORD call returns the length of the commander's
 BEQ TR1                \ name in Y, so transfer this to A, and if it is zero
                        \ (a blank name was entered), jump to TR1 to copy
                        \ the last saved commander's name from NA% to INWK
                        \ and return from the subroutine there

 JMP TT67               \ We have a name, so jump to TT67 to print a newline
                        \ and return from the subroutine using a tail call

.RLINE

                        \ This is the OSWORD configuration block used above

 EQUW INWK              \ The address to store the input, so the commander's
                        \ name will be stored in INWK as it is typed

 EQUB 7                 \ Maximum line length = 7, as that's the maximum size
                        \ for a commander's name

 EQUB '!'               \ Allow ASCII characters from "!" through to "z" in
 EQUB 'z'               \ the name

