\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\       Name: GTNME
ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION
\       Name: GTNMEW
ENDIF
\       Type: Subroutine
\   Category: Save and load
\    Summary: Fetch the name of a commander file to save or load
\
\ ------------------------------------------------------------------------------
\
\ Get the commander's name for loading or saving a commander file. The name is
\ stored in the INWK workspace and is terminated by a return character (13).
\
\ If ESCAPE is pressed or a blank name is entered, then the name stored is set
\ to the name from the last saved commander block.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\   INWK                The commander name entered, terminated by a return
\                       character (13)
\
ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION
\   INWK                The full filename, including drive and directory, in
\                       the form ":0.E.JAMESON", for example, terminated by a
\                       return character (13)
\
ENDIF
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   GTNME               Skip the delay at the start of the routine
\
ENDIF
\ ******************************************************************************

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Label

.GTNMEW

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Other: The disc version has a delay in the routine to fetch a commander name, though I'm not sure why

 LDY #8                 \ Wait for 8/50 of a second (0.16 seconds)
 JSR DELAY

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION

\LDY #8                 \ These instructions are commented out in the original
\JSR DELAY              \ source

ENDIF

.GTNME

IF _CASSETTE_VERSION \ Platform

 LDA #1                 \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 1

 LDA #123               \ Print recursive token 123 ("{crlf}COMMANDER'S NAME? ")
 JSR TT27

 JSR DEL8               \ Wait for 8/50 of a second (0.16 seconds)

ELIF _ELECTRON_VERSION

 LDA #1                 \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 1

 LDA #123               \ Print recursive token 123 ("{crlf}COMMANDER'S NAME? ")
 JSR TT27

 JSR DEL8               \ Call DEL8 to wait for 30 delay loops

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDA #15                \ Call OSBYTE with A = 15 (flush all buffers)
 TAX
 JSR OSBYTE

 LDX #LO(RLINE)         \ Set (Y X) to point to the RLINE parameter block
 LDY #HI(RLINE)         \ configuration block below

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDA #0                 \ Call OSWORD with A = 0 to read a line from the current
 JSR OSWORD             \ input stream (i.e. the keyboard)

\LDA #%00000001         \ These instructions are commented out in the original
\STA VIA+&4E            \ source, but they would set 6522 System VIA interrupt
                        \ enable register IER (SHEILA &4E) bit 1 (i.e. disable
                        \ the CA2 interrupt, which comes from the keyboard)

 BCS TR1                \ The C flag will be set if we pressed ESCAPE when
                        \ entering the name, in which case jump to TR1 to copy
                        \ the last saved commander's name from NA% to INWK
                        \ and return from the subroutine there

ELIF _ELECTRON_VERSION

 LDA #0                 \ Set A = 0 for the following OSWORD call

 DEC KEYB               \ Decrement KEYB, so it is now &FF, to indicate that we
                        \ should process all interrupts, including keyboard
                        \ interrupts, so that we can read the keyboard

 JSR OSWORD             \ Call OSWORD with A = 0 to read a line from the current
                        \ input stream (i.e. the keyboard)

 INC KEYB               \ Increment KEYB back to 0 to indicate that we are done
                        \ reading the keyboard, so we can ignore interrupts

 BCS TR1                \ The C flag will be set if we pressed ESCAPE when
                        \ entering the name, in which case jump to TR1 to copy
                        \ the last saved commander's name from NA% to INWK
                        \ and return from the subroutine there

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Platform

 LDX #4                 \ First we want to copy the drive and directory part of
                        \ the commander file from S1% (which equals NA%-5), so
                        \ set a counter in x for 5 bytes, as the string is of
                        \ the form ":0.E."

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDX #4                 \ First we want to copy the drive and directory part of
                        \ the commander file from NA%-5, so set a counter in X
                        \ for 5 bytes, as the string is of the form ":0.E."

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

.GTL3

 LDA NA%-5,X            \ Copy the X-th byte from NA%-5 to INWK
 STA INWK,X

 DEX                    \ Decrement the loop counter

 BPL GTL3               \ Loop back until the whole drive and directory string
                        \ has been copied to INWK to INWK+4

 LDA #7                 \ The call to MT26 below uses the OSWORD block at RLINE
 STA RLINE+2            \ to fetch the line, and RLINE+2 defines the maximum
                        \ line length allowed, so this changes the maximum
                        \ length to 7 (as that's the longest commander name
                        \ allowed)

 LDA #8                 \ Print extended token 8 ("{single cap}COMMANDER'S
 JSR DETOK              \ NAME? ")

 JSR MT26               \ Call MT26 to fetch a line of text from the keyboard
                        \ to INWK+5, with the text length in Y, so INWK now
                        \ contains the full pathname of the file, as in
                        \ ":0.E.JAMESON", for example

 LDA #9                 \ Reset the maximum length in RLINE+2 to the original
 STA RLINE+2            \ value of 9

ENDIF

 TYA                    \ The OSWORD call returns the length of the commander's
                        \ name in Y, so transfer this to A

 BEQ TR1                \ If A = 0, no name was entered, so jump to TR1 to copy
                        \ the last saved commander's name from NA% to INWK
                        \ and return from the subroutine there

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 JMP TT67               \ We have a name, so jump to TT67 to print a newline
                        \ and return from the subroutine using a tail call

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 STY thislong           \ Store the length of the length of the commander's that
                        \ was entered in thislong

 RTS                    \ Return from the subroutine

ENDIF

