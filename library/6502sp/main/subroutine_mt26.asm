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

 LDA #VIAE              \ Write a #VIAE character to the I/O processor
 JSR OSWRCH

 LDA #&81               \ Write a &81 character to the I/O processor
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

 LDA #VIAE              \ Write a #VIAE character to the I/O processor
 JSR OSWRCH

 LDA #1                 \ Write a #1 character to the I/O processor
 JSR OSWRCH

 JMP FEED               \ Jump to FEED to print a newline, returning from the
                        \ subroutine using a tail call

