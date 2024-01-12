\ ******************************************************************************
\
\       Name: DELT
\       Type: Subroutine
\   Category: Save and load
\    Summary: Catalogue a disc, ask for a filename to delete, and delete the
\             file
\
\ ------------------------------------------------------------------------------
\
\ This routine asks for a disc drive number, and if it is a valid number (0-3)
\ it displays a catalogue of the disc in that drive. It then asks for a filename
\ to delete, updates the OS command at DELI so that when that command is run, it
\ deletes the correct file, and then it does the deletion.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DELT-1              Contains an RTS
\
\ ******************************************************************************

.DELT

 JSR CATS               \ Call CATS to ask for a drive number (or a directory
                        \ name on the Master Compact) and catalogue that disc
                        \ or directory

 BCS SVE                \ If the C flag is set then an invalid drive number was
                        \ entered as part of the catalogue process, so jump to
                        \ SVE to display the disc access menu

IF _DISC_DOCKED \ Platform

 LDA CTLI+1             \ The call to CATS above put the drive number into
 STA DELI+4             \ CTLI+1, so copy the drive number into DELI+4 so that
                        \ the drive number in the "DE.:0.E.1234567" string
                        \ gets updated (i.e. the number after the colon)

ELIF _6502SP_VERSION

 LDA CTLI+1             \ The call to CATS above put the drive number into
 STA DELI+7             \ CTLI+1, so copy the drive number into DELI+7 so that
                        \ the drive number in the "DELETE:0.E.1234567" string
                        \ gets updated (i.e. the number after the colon)

ELIF _MASTER_VERSION

IF _SNG47

 LDA CTLI+4             \ The call to CATS above put the drive number into
 STA DELI+8             \ CTLI+4, so copy the drive number into DELI+8 so that
                        \ the drive number in the "DELETE :1.1234567" string
                        \ gets updated (i.e. the number after the colon)

ENDIF

ELIF _ELITE_A_VERSION

 LDA CTLI+2             \ The call to CATS above put the drive number into
 STA DELI+5             \ CTLI+2, so copy the drive number into DELI+5 so that
                        \ the drive number in the "DEL.:0.E.1234567" string
                        \ gets updated (i.e. the number after the colon)

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: When deleting a file via the disc menu, the disc and 6502SP versions ask for the "FILE TO DELETE?", while the Master version asks for the "COMMANDER'S NAME?"

 LDA #9                 \ Print extended token 9 ("{clear bottom of screen}FILE
 JSR DETOK              \ TO DELETE?")

ELIF _MASTER_VERSION

 LDA #8                 \ Print extended token 8 ("{single cap}COMMANDER'S
 JSR DETOK              \ NAME? ")

ENDIF

 JSR MT26               \ Call MT26 to fetch a line of text from the keyboard
                        \ to INWK+5, with the text length in Y

 TYA                    \ If no text was entered (Y = 0) then jump to SVE to
 BEQ SVE                \ display the disc access menu

IF _DISC_DOCKED \ Comment

                        \ We now copy the entered filename from INWK to DELI, so
                        \ that it overwrites the filename part of the string,
                        \ i.e. the "E.1234567" part of "DE.:0.E.1234567"

 LDX #9                 \ Set up a counter in X to count from 9 to 1, so that we
                        \ copy the string starting at INWK+4+1 (i.e. INWK+5) to
                        \ DELI+5+1 (i.e. DELI+6 onwards, or "E.1234567")

ELIF _6502SP_VERSION

                        \ We now copy the entered filename from INWK to DELI, so
                        \ that it overwrites the filename part of the string,
                        \ i.e. the "E.1234567" part of "DELETE:0.E.1234567"

 LDX #9                 \ Set up a counter in X to count from 9 to 1, so that we
                        \ copy the string starting at INWK+4+1 (i.e. INWK+5) to
                        \ DELI+8+1 (i.e. DELI+9 onwards, or "E.1234567")

ELIF _MASTER_VERSION

IF _SNG47

                        \ We now copy the entered filename from INWK to DELI, so
                        \ that it overwrites the filename part of the string,
                        \ i.e. the "E.1234567" part of "DELETE :1.1234567"

 LDX #9                 \ Set up a counter in X to count from 9 to 1, so that we
                        \ copy the string starting at INWK+4+1 (i.e. INWK+5) to
                        \ DELI+9+1 (i.e. DELI+10 onwards, or "1.1234567")
                        \
                        \ Note that this is a bug - X should be set to 8, as a
                        \ value of 9 overwrites the first character of the
                        \ "SAVE" command in savosc
                        \
                        \ This means that if you delete a file, it breaks the
                        \ save command, so you can't save a commander file if
                        \ you have previously deleted a file

ELIF _COMPACT

                        \ We now copy the entered filename from INWK to DELI, so
                        \ that it overwrites the filename part of the string,
                        \ i.e. the "1234567890" part of "DELETE 1234567890"

 LDX #8                 \ Set up a counter in X to count from 8 to 0, so that we
                        \ copy the string starting at INWK+5+0 (i.e. INWK+5) to
                        \ DELI+7+0 (i.e. DELI+7 onwards, or "1234567890")

ENDIF

ELIF _ELITE_A_VERSION

                        \ We now copy the entered filename from INWK to DELI, so
                        \ that it overwrites the filename part of the string,
                        \ i.e. the "E.1234567" part of "DEL.:0.E.1234567"

 LDX #9                 \ Set up a counter in X to count from 9 to 1, so that we
                        \ copy the string starting at INWK+4+1 (i.e. INWK+5) to
                        \ DELI+5+1 (i.e. DELI+6 onwards, or "E.1234567")

ENDIF

.DELL1

IF _DISC_DOCKED \ Platform

 LDA INWK+4,X           \ Copy the X-th byte of INWK+4 to the X-th byte of
 STA DELI+5,X           \ DELI+5

 DEX                    \ Decrement the loop counter

 BNE DELL1              \ Loop back to DELL1 to copy the next character until we
                        \ have copied the whole filename

ELIF _6502SP_VERSION

 LDA INWK+4,X           \ Copy the X-th byte of INWK+4 to the X-th byte of
 STA DELI+8,X           \ DELI+8

 DEX                    \ Decrement the loop counter

 BNE DELL1              \ Loop back to DELL1 to copy the next character until we
                        \ have copied the whole filename

ELIF _MASTER_VERSION

IF _SNG47

 LDA INWK+4,X           \ Copy the X-th byte of INWK+4 to the X-th byte of
 STA DELI+9,X           \ DELI+9

 DEX                    \ Decrement the loop counter

 BNE DELL1              \ Loop back to DELL1 to copy the next character until we
                        \ have copied the whole filename

 JSR getzp              \ Call getzp to store the top part of zero page in the
                        \ the buffer at &3000, as it gets corrupted by the MOS
                        \ during disc access

ELIF _COMPACT

 LDA INWK+5,X           \ Copy the X-th byte of INWK+5 to the X-th byte of
 STA DELI+7,X           \ DELI+7

 DEX                    \ Decrement the loop counter

 BPL DELL1              \ Loop back to DELL1 to copy the next character until we
                        \ have copied the whole filename

 JSR NMIRELEASE         \ Release the NMI workspace (&00A0 to &00A7) so the MOS
                        \ can use it, and store the top part of zero page in the
                        \ the buffer at &3000, as it gets corrupted by the MOS
                        \ during disc access

ENDIF

ELIF _ELITE_A_VERSION

 LDA INWK+4,X           \ Copy the X-th byte of INWK+4 to the X-th byte of
 STA DELI+6,X           \ DELI+6

 DEX                    \ Decrement the loop counter

 BNE DELL1              \ Loop back to DELL1 to copy the next character until we
                        \ have copied the whole filename

ENDIF

 LDX #LO(DELI)          \ Set (Y X) to point to the OS command at DELI, which
 LDY #HI(DELI)          \ contains the DFS command for deleting this file

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION \ Platform

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ catalogues the disc

ELIF _6502SP_VERSION

 JSR SCLI2              \ Call SCLI2 to execute the OS command at (Y X), which
                        \ deletes the file, setting the SVN flag while it's
                        \ running to indicate disc access is in progress

ENDIF

IF _MASTER_VERSION \ Platform

 JSR getzp              \ Call getzp to restore the top part of zero page from
                        \ the buffer at &3000

ENDIF

 JMP SVE                \ Jump to SVE to display the disc access menu and return
                        \ from the subroutine using a tail call

