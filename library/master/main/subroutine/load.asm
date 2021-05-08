\ ******************************************************************************
\
\       Name: LOAD
\       Type: Subroutine
\   Category: Save and load
\    Summary: Load the commander file
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   INWK+5              The filename, terminated by a carriage return
\
\ ******************************************************************************

.LOAD

 LDY #0                 \ We start by changing the load command at LDLI to
                        \ contain the filename that was just entered by the
                        \ user, so we set an index in Y so we can copy the
                        \ filename from INWK+5 into the LDLI command

.LOADL1

 LDA INWK+5,Y           \ Fetch the Y-th character of the filename

 CMP #13                \ If the character is a carriage return then we have
 BEQ LOADL2             \ reached the end of the filename, so jump to LOADL2 as
                        \ we have now copied the whole filename

IF _SNG47

 STA LDLI+10,Y          \ Store the Y-th character of the filename in the Y-th
                        \ character of LDLI+10, where LDLI+10 points to the
                        \ JAMESON part of the load command in LDLI:
                        \
                        \   "LOAD :1.E.JAMESON  E7E"

ELIF _COMPACT

 STA LDLI+5,Y           \ Store the Y-th character of the filename in the Y-th
                        \ character of LDLI+5, where LDLI+5 points to the
                        \ JAMESON part of the load command in LDLI:
                        \
                        \   "LOAD JAMESON  E7E"

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then there may be more characters in the
 BCC LOADL1             \ name, so loop back to LOADL1 to fetch the next one

 .LOADL2

 LDA #' '               \ We have copied the name into the LDLI command string,
                        \ but the new name might be shorter then the previous
                        \ one, so we now need to blank out the rest of the name
                        \ with spaces, so we load the space character into A

IF _SNG47

 STA LDLI+10,Y          \ Store the Y-th character of the filename in the Y-th
                        \ character of LDLI+10, which will be directly after
                        \ the last letter we copied above

ELIF _COMPACT

 STA LDLI+5,Y           \ Store the Y-th character of the filename in the Y-th
                        \ character of LDLI+5, which will be directly after
                        \ the last letter we copied above

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then we haven't yet blanked out the whole
 BCC LOADL2             \ name, so loop back to LOADL2 to blank the next one
                        \ until the load string is ready for use

IF _SNG47

 JSR SWAPZP             \ Call SWAPZP to store the top part of zero page, as it
                        \ gets corrupted by the MOS during the loading process

ELIF _COMPACT

 JSR NMIRELEASE         \ Release the NMI workspace (&00A0 to &00A7)

ENDIF

 LDX #LO(LDLI)          \ Set (Y X) to point to the OS command at LDLI, which
 LDY #HI(LDLI)          \ contains the DFS command for loading the commander
                        \ file

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ loads the commander file

 JSR SWAPZP             \ Call SWAPZP to restore the top part of zero page

 LDY #NT%               \ We now want to copy the newly loaded commander data
                        \ block to location &0791, so we set a counter in Y to
                        \ copy the NT% bytes in the commander data block

.LOADL3

 LDA &0E7E,Y            \ Copy the Y-th byte of &0E7E to the Y-th byte of &0791
 STA &0791,Y

 DEY                    \ Decrement the loop counter

 BPL LOADL3             \ Loop back until we have copied all the bytes in the
                        \ newly loaded commander data block

 RTS                    \ Return from the subroutine

 RTS                    \ This instruction has no effect as we already returned
                        \ from the subroutine

