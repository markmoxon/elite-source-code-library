\ ******************************************************************************
\
\       Name: MT26
\       Type: Subroutine
\   Category: Text
\    Summary: Fetch a line of text from the keyboard
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ If ESCAPE is pressed or a blank name is entered, then an empty string is
\ returned.
\
\ Returns:
\
\   Y                   The size of the entered text, or 0 if ESCAPE was pressed
\
\   INWK+5              The entered text, terminated by a carriage return
\
\ ******************************************************************************

.MT26

IF _DISC_DOCKED \ Tube

 LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

ELIF _6502SP_VERSION

 LDA #VIAE              \ Send a #VIAE %10000001 command to the I/O processor to
 JSR OSWRCH             \ clear 6522 System VIA interrupt enable register IER
 LDA #%10000001         \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
 JSR OSWRCH             \ which comes from the keyboard)

 LDY #8                 \ Wait for 8/50 of a second (0.16 seconds)
 JSR DELAY

ENDIF

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

 LDX #LO(RLINE)         \ Set (Y X) to point to the RLINE parameter block
 LDY #HI(RLINE)

 LDA #0                 \ Call OSWORD with A = 0 to read a line from the current
 JSR OSWORD             \ input stream (i.e. the keyboard)

 BCC P%+4               \ The C flag will be set if we pressed ESCAPE when
                        \ entering the name, otherwise it will be clear, so
                        \ skip the next instruction is ESCAPE is not pressed

 LDY #0                 \ ESCAPE was pressed, so set Y = 0 (as the OSWORD call
                        \ returns the length of the entered string in Y)

IF _DISC_DOCKED \ Tube

 LDA #%00000001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

ELIF _6502SP_VERSION

 LDA #VIAE              \ Send a #VIAE %00000001 command to the I/O processor to
 JSR OSWRCH             \ set 6522 System VIA interrupt enable register IER
 LDA #%00000001         \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
 JSR OSWRCH             \ which comes from the keyboard)

ENDIF

 JMP FEED               \ Jump to FEED to print a newline, returning from the
                        \ subroutine using a tail call

