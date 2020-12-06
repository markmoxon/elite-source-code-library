\ ******************************************************************************
\
\       Name: MT26
\       Type: Subroutine
\   Category: Text
\    Summary: Fetch a line of text from keyboard
\
\ ------------------------------------------------------------------------------
\
\ If Escape is pressed or a blank name is entered, then an empty string is
\ returned.
\
\ Returns:
\
\   Y                   The size of the entered text, or 0 if Escape was pressed
\
\   INWK+5              The entered text, terminated by a carriage return
\
\ ******************************************************************************

.MT26

 LDA #VIAE              \ Send a #VIAE %10000001 command to the I/O processor to
 JSR OSWRCH             \ clear 6522 System VIA interrupt enable register IER
 LDA #%10000001         \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)
 JSR OSWRCH

 LDY #8                 \ Wait for 8/50 of a second (0.16 seconds)
 JSR DELAY

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

 LDX #LO(RLINE)         \ Call OSWORD with A = 0 and (Y X) pointing to the
 LDY #HI(RLINE)         \ configuration block in RLINE, which reads a line from
 LDA #0                 \ the current input stream (i.e. the keyboard)
 JSR OSWORD

 BCC P%+4               \ The C flag will be set if we pressed Escape when
                        \ entering the name, otherwise it will be clear, so
                        \ skip the next instruction is Escape is not pressed

 LDY #0                 \ Escape was pressed, so set Y = 0 (as the OSWORD call
                        \ returns the length of the entered string in Y)

 LDA #VIAE              \ Send a #VIAE %00000001 command to the I/O processor to
 JSR OSWRCH             \ set 6522 System VIA interrupt enable register IER
 LDA #%00000001         \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
 JSR OSWRCH             \ which comes from the keyboard)

 JMP FEED               \ Jump to FEED to print a newline, returning from the
                        \ subroutine using a tail call

