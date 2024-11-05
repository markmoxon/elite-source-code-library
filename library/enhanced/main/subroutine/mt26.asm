\ ******************************************************************************
\
\       Name: MT26
\       Type: Subroutine
\   Category: Text
IF NOT(_NES_VERSION)
\    Summary: Fetch a line of text from the keyboard
ELIF _NES_VERSION
\    Summary: Print a space and capitalise the next letter
ENDIF
\  Deep dive: Extended text tokens
\
IF NOT(_NES_VERSION)
\ ------------------------------------------------------------------------------
\
ENDIF
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ If ESCAPE is pressed or a blank name is entered, then an empty string is
\ returned.
\
ENDIF
IF NOT(_NES_VERSION)
\ Returns:
\
\   Y                   The size of the entered text, or 0 if none was entered
ENDIF
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\                       or if ESCAPE was pressed
ENDIF
IF NOT(_NES_VERSION)
\
\   INWK+5              The entered text, terminated by a carriage return
\
\   C flag              Set if ESCAPE was pressed
\
ENDIF
\ ******************************************************************************

.MT26

IF _MASTER_VERSION \ Master: When entering text in the Master version, the text that is typed is shown in magenta, while it is shown in white in the other versions

 LDA COL                \ Store the current colour on the stack
 PHA

 LDA #RED               \ Switch to colour 2, which is magenta in the trade view
 STA COL

ELIF _C64_VERSION

 LDA #MAG2              \ Switch to magenta in the trade view
 STA COL2

ELIF _APPLE_VERSION

\LDA #MAG2              \ These instructions are commented out in the original
\STA COL                \ source

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Tube

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

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDY #8                 \ Wait for 8/50 of a second (0.16 seconds)
 JSR DELAY

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

ELIF _ELITE_A_6502SP_PARA

 LDA #&8A               \ Send command &8A to the I/O processor:
 JSR tube_write         \
                        \   =write_fe4e(value)
                        \
                        \ which sets the 6522 System VIA interrupt enable
                        \ register IER (SHEILA &4E) to the specified value and
                        \ returns the value in A when done

 LDA #%10000001         \ Send the parameter to the I/O processor:
 JSR tube_write         \
                        \   * value = %10000001
                        \
                        \ to clear bit 1 of IER (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

 JSR tube_read          \ Set A to the response from the I/O processor

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: Group A: The Master version contains its own custom routine for the extended token that asks for a line of text, while the other enhanced versions use the standard OSWORD command. The Master Compact version of that custom routine supports more characters, as it supports ADFS rather than DFS

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

.OSW0L

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A (and X)

 CMP #13                \ If RETURN was pressed, jump to OSW03
 BEQ OSW03

 CMP #27                \ If ESCAPE was pressed, jump to OSW04
 BEQ OSW04

 CMP #127               \ If DELETE was pressed, jump to OSW05
 BEQ OSW05

IF _COMPACT

 PHX                    \ Store X on the stack so we can retrieve it after the
                        \ call to SHIFT

 PHA                    \ Store the number of the key being pressed on the stack

 JSR SHIFT              \ If SHIFT is not being pressed, jump to noshift to skip
 BPL noshift            \ the following

 PLA                    \ SHIFT is being pressed, so fetch the number of the key
                        \ being pressed from the stack

 CMP #'@'               \ If A >= ASCII "@", then we are pressing a letter key,
 BCS P%+4               \ so skip the following instruction

 EOR #%00010000         \ We are pressing SHIFT and a number key, so flip bit 4
                        \ of the key number, which flips the letter between the
                        \ ASCII code of the number being pressed and the ASCII
                        \ code of the number being pressed when SHIFT is being
                        \ held down (so SHIFT-1 will enter !, SHIFT-2 will enter
                        \ ", and so on)

 PHA                    \ Push the updated key number onto the stack

.noshift

 PLA                    \ Retrieve the values of X and A we stored on the stack
 PLX                    \ above

ENDIF

 CPY RLINE+2            \ If Y >= RLINE+2 (the maximum line length from the
 BCS OSW01              \ OSWORD configuration block at RLINE), then jump to
                        \ OSW01 to give an error beep as we have reached the
                        \ character limit

 CMP RLINE+3            \ If the key pressed is less than the character in
 BCC OSW01              \ RLINE+3 (the lowest allowed character from the OSWORD
                        \ configuration block at RLINE), then jump to OSW01
                        \ to give an error beep as the key pressed is out of
                        \ range

 CMP RLINE+4            \ If the key pressed is greater than or equal to the
 BCS OSW01              \ character in RLINE+4 (the highest allowed character
                        \ from the OSWORD configuration block at RLINE), then
                        \ jump to OSW01 to give an error beep as the key
                        \ pressed is out of range

 STA INWK+5,Y           \ Store the key's ASCII code in the Y-th byte of INWK+5

 INY                    \ Increment Y to point to the next free byte in INWK+5

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &07, or BIT &07A9, which does nothing apart
                        \ from affect the flags

.OSW01

 LDA #7                 \ Set A to the beep character, so the next instruction
                        \ makes a system beep

.OSW06

 JSR CHPR               \ Print the character in A (and clear the C flag)

 BCC OSW0L              \ Loop back to OSW0L to fetch another key press (this
                        \ BCC is effectively a JMP as CHPR clears the C flag)

.OSW03

 STA INWK+5,Y           \ Store the return character in the Y-th byte of INWK+5

 LDA #12                \ Print a newline
 JSR CHPR

 EQUB &24               \ Skip the next instruction by turning it into &24 &38,
                        \ or BIT &0038, which does nothing apart from affect the
                        \ flags

.OSW04

 SEC                    \ Set the C flag as ESCAPE was pressed

 PLA                    \ Restore the original colour from the stack and set it
 STA COL                \ as the current colour

 RTS                    \ Return from the subroutine

.OSW05

 TYA                    \ If the length of the line so far in Y is 0, then we
 BEQ OSW01              \ just pressed DELETE on an empty line, so jump to
                        \ OSW01 give an error beep

 DEY                    \ Otherwise we want to delete a character, so decrement
                        \ the length of the line so far in Y

 LDA #127               \ Set A = 127 and jump back to OSW06 to print the
 BNE OSW06              \ character in A (i.e. the DELETE character) and listen
                        \ for the next key press

ELIF _C64_VERSION

 LDY #0                 \ Set Y = 0 to hold the length of the text entered

.OSW0L

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A (and X)

 CMP #13                \ If RETURN was pressed, jump to OSW03
 BEQ OSW03

 CMP #27                \ If ESCAPE was pressed, jump to OSW04
 BEQ OSW04

 CMP #127               \ If DELETE was pressed, jump to OSW05
 BEQ OSW05

 CPY RLINE+2            \ If Y >= RLINE+2 (the maximum line length from the
 BCS OSW01              \ OSWORD configuration block at RLINE), then jump to
                        \ OSW01 to give an error beep as we have reached the
                        \ character limit

 CMP RLINE+3            \ If the key pressed is less than the character in
 BCC OSW01              \ RLINE+3 (the lowest allowed character from the OSWORD
                        \ configuration block at RLINE), then jump to OSW01
                        \ to give an error beep as the key pressed is out of
                        \ range

 CMP RLINE+4            \ If the key pressed is greater than or equal to the
 BCS OSW01              \ character in RLINE+4 (the highest allowed character
                        \ from the OSWORD configuration block at RLINE), then
                        \ jump to OSW01 to give an error beep as the key
                        \ pressed is out of range

 STA INWK+5,Y           \ Store the key's ASCII code in the Y-th byte of INWK+5

 INY                    \ Increment Y to point to the next free byte in INWK+5

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &07, or BIT &07A9, which does nothing apart
                        \ from affect the flags

.OSW01

 LDA #7                 \ Set A to the beep character, so the next instruction
                        \ makes a system beep

.OSW06

 JSR CHPR               \ Print the character in A (and clear the C flag)

 BCC OSW0L              \ Loop back to OSW0L to fetch another key press (this
                        \ BCC is effectively a JMP as CHPR clears the C flag)

.OSW03

 STA INWK+5,Y           \ Store the return character in the Y-th byte of INWK+5

 LDA #&10               \ ???
 STA COL2

 LDA #12                \ Print a newline and return from the subroutine using a
 JMP CHPR               \ tail call

.OSW04

 LDA #&10               \ ???
 STA COL2

 SEC                    \ Set the C flag as ESCAPE was pressed

 RTS                    \ Return from the subroutine

.OSW05

 TYA                    \ If the length of the line so far in Y is 0, then we
 BEQ OSW01              \ just pressed DELETE on an empty line, so jump to
                        \ OSW01 give an error beep

 DEY                    \ Otherwise we want to delete a character, so decrement
                        \ the length of the line so far in Y

 LDA #127               \ Set A = 127 and jump back to OSW06 to print the
 BNE OSW06              \ character in A (i.e. the DELETE character) and listen
                        \ for the next key press

ELIF _APPLE_VERSION

 LDY #0                 \ Set Y = 0 to hold the length of the text entered

.OSW0L

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A (and X)

 CMP #13                \ If RETURN was pressed, jump to OSW03
 BEQ OSW03

 CMP #27                \ If ESCAPE was pressed, jump to OSW04
 BEQ OSW04

 CMP #127               \ If DELETE was pressed, jump to OSW05
 BEQ OSW05

 CPY RLINE+2            \ If Y >= RLINE+2 (the maximum line length from the
 BCS OSW01              \ OSWORD configuration block at RLINE), then jump to
                        \ OSW01 to give an error beep as we have reached the
                        \ character limit

 CMP RLINE+3            \ If the key pressed is less than the character in
 BCC OSW01              \ RLINE+3 (the lowest allowed character from the OSWORD
                        \ configuration block at RLINE), then jump to OSW01
                        \ to give an error beep as the key pressed is out of
                        \ range

 CMP RLINE+4            \ If the key pressed is greater than or equal to the
 BCS OSW01              \ character in RLINE+4 (the highest allowed character
                        \ from the OSWORD configuration block at RLINE), then
                        \ jump to OSW01 to give an error beep as the key
                        \ pressed is out of range

 STA INWK+5,Y           \ Store the key's ASCII code in the Y-th byte of INWK+5

 INY                    \ Increment Y to point to the next free byte in INWK+5

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &07, or BIT &07A9, which does nothing apart
                        \ from affect the flags

.OSW01

 LDA #7                 \ Set A to the beep character, so the next instruction
                        \ makes a system beep

.OSW06

 JSR CHPR               \ Print the character in A (and clear the C flag)

 BCC OSW0L              \ Loop back to OSW0L to fetch another key press (this
                        \ BCC is effectively a JMP as CHPR clears the C flag)

.OSW03

 STA INWK+5,Y           \ Store the return character in the Y-th byte of INWK+5

\LDA #&10               \ These instructions are commented out in the original
\STA COL2               \ source

 LDA #12                \ Print a newline and return from the subroutine using a
 JMP CHPR               \ tail call

.OSW04

\LDA #&10               \ These instructions are commented out in the original
\STA COL2               \ source

 SEC                    \ Set the C flag as ESCAPE was pressed

 RTS                    \ Return from the subroutine

.OSW05

 TYA                    \ If the length of the line so far in Y is 0, then we
 BEQ OSW01              \ just pressed DELETE on an empty line, so jump to
                        \ OSW01 give an error beep

 DEY                    \ Otherwise we want to delete a character, so decrement
                        \ the length of the line so far in Y

 LDA #127               \ Set A = 127 and jump back to OSW06 to print the
 BNE OSW06              \ character in A (i.e. the DELETE character) and listen
                        \ for the next key press

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Tube

 LDA #%00000001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

ELIF _6502SP_VERSION

 LDA #VIAE              \ Send a #VIAE %00000001 command to the I/O processor to
 JSR OSWRCH             \ set 6522 System VIA interrupt enable register IER
 LDA #%00000001         \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
 JSR OSWRCH             \ which comes from the keyboard)

ELIF _ELITE_A_6502SP_PARA

 LDA #&8A               \ Send command &8A to the I/O processor:
 JSR tube_write         \
                        \   =write_fe4e(value)
                        \
                        \ which sets the 6522 System VIA interrupt enable
                        \ register IER (SHEILA &4E) to the specified value and
                        \ returns the value in A when done

 LDA #%00000001         \ Send the parameter to the I/O processor:
 JSR tube_write         \
                        \   * value = %00000001
                        \
                        \ to set bit 1 of IER (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

 JSR tube_read          \ Set A to the response from the I/O processor, so we
                        \ know the register has been set

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group A

 JMP FEED               \ Jump to FEED to print a newline, returning from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

 LDA #' '               \ Print a space
 JSR DASC

                        \ Fall through into MT19 to capitalise the next letter

ENDIF
