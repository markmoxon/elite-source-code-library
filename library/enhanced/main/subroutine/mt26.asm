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
IF _DISC_DOCKED OR _6502SP_VERSION \ Comment
\ If ESCAPE is pressed or a blank name is entered, then an empty string is
\ returned.
\
ENDIF
\ Returns:
\
\   Y                   The size of the entered text, or 0 if none was entered
IF _DISC_DOCKED OR _6502SP_VERSION \ Comment
\                       or if ESCAPE was pressed
ENDIF
\
\   INWK+5              The entered text, terminated by a carriage return
\
\   C flag              Set if ESCAPE was pressed
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

ELIF _MASTER_VERSION

 LDA COL                \ Store the current colour on the stack
 PHA

 LDA #RED               \ Switch to colour 2, which is magenta in the trade view
 STA COL                \ or red in the chart view

 LDY #8                 \ Wait for 8/50 of a second (0.16 seconds)
 JSR DELAY

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

ENDIF

IF _DISC_DOCKED OR _6502SP_VERSION

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

 LDX #LO(RLINE)         \ Set (Y X) to point to the RLINE parameter block
 LDY #HI(RLINE)

 LDA #0                 \ Call OSWORD with A = 0 to read a line from the current
 JSR OSWORD             \ input stream (i.e. the keyboard)

 BCC P%+4               \ The C flag will be set if we pressed ESCAPE when
                        \ entering the name, otherwise it will be clear, so
                        \ skip the next instruction if ESCAPE is not pressed

 LDY #0                 \ ESCAPE was pressed, so set Y = 0 (as the OSWORD call
                        \ returns the length of the entered string in Y)

ELIF _MASTER_VERSION

 LDY #0                 \ Set Y = 0 to hold the length of the text entered

.MT26L

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A (and X)

 CMP #13                \ If RETURN was pressed, jump to MT26ret
 BEQ MT26ret

 CMP #27                \ If ESCAPE was pressed, jump to MT26esc
 BEQ MT26esc

 CMP #127               \ If DELETE was pressed, jump to MT26ret
 BEQ MT26del

 CPY RLINE+2            \ If Y >= RLINE+2 (the maximum line length from the
 BCS MT26err            \ OSWORD configuration block at RLINE), then jump to
                        \ MT26err to give an error beep as we have reached the
                        \ character limit

 CMP RLINE+3            \ If the key pressed is less than the character in
 BCC MT26err            \ RLINE+3 (the lowest allowed character from the OSWORD
                        \ configuration block at RLINE), then jump to MT26err
                        \ to give an error beep as the key pressed is out of
                        \ range

 CMP RLINE+4            \ If the key pressed is geater than or equal to the
 BCS MT26err            \ character in RLINE+4 (the highest allowed character
                        \ from the OSWORD configuration block at RLINE), then
                        \ jump to MT26err to give an error beep as the key
                        \ pressed is out of range

 STA INWK+5,Y           \ Store the key's ASCII code in the Y-th byte of INWK+5

 INY                    \ Increment Y to point to the next free byte in INWK+5

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &07, or BIT &07A9, which does nothing apart
                        \ from affect the flags

.MT26err

 LDA #7                 \ Set A to the beep character, so the next instruction
                        \ makes a system beep

.MT26LS

 JSR CHPR               \ Print the character in A (and clear the C flag)

 BCC MT26L              \ Loop back to MT26L to fetch another key press (this
                        \ BCC is effectively a JMP as CHPR clears the C flag)

.MT26ret

 STA INWK+5,Y           \ Store the return character in the Y-th byte of INWK+5

 LDA #12                \ Print a newline
 JSR CHPR

 EQUB &24               \ Skip the next instruction by turning it into &24 &38,
                        \ or BIT &0038, which does nothing apart from affect the
                        \ flags

.MT26esc

 SEC                    \ Set the C flag as ESCAPE was pressed

 PLA                    \ Restore the original colour from the stack and set it
 STA COL                \ as the current colour

 RTS                    \ Return from the subroutine

.MT26del

 TYA                    \ If the length of the line so far in Y is 0, then we
 BEQ MT26err            \ just pressed DELETE on an empty line, so jump to
                        \ MT26err give an error beep

 DEY                    \ Otherwise we want to delete a character, so decrement
                        \ the length of the line so far in Y

 LDA #127               \ Set A = 127 and jump back to MT26LS to print the
 BNE MT26LS             \ character in A (i.e. the DELETE character) and listen
                        \ for the next key press

ENDIF

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

IF _DISC_DOCKED OR _6502SP_VERSION

 JMP FEED               \ Jump to FEED to print a newline, returning from the
                        \ subroutine using a tail call

ENDIF
