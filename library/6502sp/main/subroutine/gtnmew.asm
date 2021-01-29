\ ******************************************************************************
\
\       Name: GTNMEW
\       Type: Subroutine
\   Category: Save and load
\    Summary: Fetch the name of a commander file to save or load
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   INWK                The full filename, including drive and directory, in
\                       the form ":0.E.JAMESON", for example
\
\ ******************************************************************************

.GTNMEW

IF _DISC_VERSION

 LDY #8                 \ Wait for 8/50 of a second (0.16 seconds)
 JSR DELAY

ELIF _6502SP_VERSION

\LDY #8                 \ These instructions are commented out in the original
\JSR DELAY              \ source

ENDIF

.GTNME

 LDX #4                 \ First we want to copy the drive and directory part of
                        \ the commander file from S1% (which equals NA%-5), so
                        \ set a counter in x for 5 bytes, as the string is of
                        \ the form ":0.E."

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

 TYA                    \ Copy the length of the entered name into A

 BEQ TR1                \ If A = 0, no name was entered, so jump to TR1 to
                        \ restore the original name from NA% to INWK+5

 RTS                    \ Return from the subroutine

