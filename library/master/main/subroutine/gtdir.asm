\ ******************************************************************************
\
\       Name: GTDIR
\       Type: Subroutine
\   Category: Save and load
\    Summary: Fetch the name of an ADFS directory on the Master Compact and
\             change to that directory
\
\ ******************************************************************************

IF _COMPACT

.GTDIR

 LDA #2                 \ Print extended token 2 ("{cr}WHICH DRIVE?")
 JSR DETOK

 LDA #19                \ The call to MT26 below uses the OSWORD block at RLINE
 STA RLINE+2            \ to fetch the line, and RLINE+2 defines the maximum
                        \ line length allowed, so this changes the maximum
                        \ length to 19 (as that's the longest directory name
                        \ allowed)

 JSR MT26               \ Call MT26 to fetch a line of text from the keyboard
                        \ to INWK+5, with the text length in Y, so INWK now
                        \ contains the full directory name

 LDA #9                 \ Reset the maximum length in RLINE+2 to the original
 STA RLINE+2            \ value of 9

 TYA                    \ The OSWORD call returns the length of the commander's
                        \ name in Y, so transfer this to A

 BEQ GTDIR-1            \ If A = 0, no name was entered, so jump to DIR-1 to
                        \ return from the subroutine (as GTDIR-1 contains an
                        \ RTS)

                        \ We now copy the entered filename from INWK to DIRI, so
                        \ that it overwrites the filename part of the string,
                        \ i.e. the "12345678901234567890" part of
                        \ "DIR 12345678901234567890"

 LDX #18                \ Set up a counter in X to count from 18 to 0, so that
                        \ we copy the string starting at INWK+5 to DIRI+4
                        \ onwards (i.e. "12345678901234567890")

.DIRL

 LDA INWK+5,X           \ Copy the X-th byte of INWK+5 to the X-th byte of
 STA DIRI+4,X           \ DIRI+4

 DEX                    \ Decrement the loop counter

 BPL DIRL               \ Loop back to DIRL to copy the next character until we
                        \ have copied the whole filename

 JSR NMIRELEASE         \ Release the NMI workspace (&00A0 to &00A7)

 LDX #LO(DIRI)          \ Set (Y X) to point to DIRI ("DIR <name entered>")
 LDY #HI(DIRI)

 JSR OSCLI              \ Call OSCLI to run the OS command in DIRI, which
                        \ changes the disc directory to the name entered

 JMP SWAPZP             \ Call SWAPZP to restore the top part of zero page
                        \ and return from the subroutine using a tail call

ENDIF

