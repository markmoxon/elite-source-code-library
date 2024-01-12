\ ******************************************************************************
\
\       Name: rfile
\       Type: Subroutine
\   Category: Save and load
\    Summary: Load the commander file
\
\ ------------------------------------------------------------------------------
\
\ This routine loads a commander file into the commbuf file buffer at &0E7E, and
\ then copies it to the TAP% staging area (though the latter is not used in this
\ version, as it's left over from the Commodore 64 version).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   INWK+5              The filename, terminated by a carriage return
\
\ ******************************************************************************

.rfile

 LDY #0                 \ We start by changing the load command at lodosc to
                        \ contain the filename that was just entered by the
                        \ user, so we set an index in Y so we can copy the
                        \ filename from INWK+5 into the lodosc command

.rfileL3

 LDA INWK+5,Y           \ Fetch the Y-th character of the filename

 CMP #13                \ If the character is a carriage return then we have
 BEQ rfileL4            \ reached the end of the filename, so jump to rfileL4 as
                        \ we have now copied the whole filename

IF _SNG47

 STA lodosc+10,Y        \ Store the Y-th character of the filename in the Y-th
                        \ character of lodosc+10, where lodosc+10 points to the
                        \ JAMESON part of the load command in lodosc:
                        \
                        \   "LOAD :1.E.JAMESON  E7E"

ELIF _COMPACT

 STA lodosc+5,Y         \ Store the Y-th character of the filename in the Y-th
                        \ character of lodosc+5, where lodosc+5 points to the
                        \ JAMESON part of the load command in lodosc:
                        \
                        \   "LOAD JAMESON  E7E"

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then there may be more characters in the
 BCC rfileL3            \ name, so loop back to rfileL3 to fetch the next one

.rfileL4

 LDA #' '               \ We have copied the name into the lodosc command
                        \ string, but the new name might be shorter than the
                        \ previous one, so we now need to blank out the rest of
                        \ the name with spaces, so we load the space character
                        \ into A

.rfileL5

IF _SNG47

 STA lodosc+10,Y        \ Store the Y-th character of the filename in the Y-th
                        \ character of lodosc+10, which will be directly after
                        \ the last letter we copied above

ELIF _COMPACT

 STA lodosc+5,Y         \ Store the Y-th character of the filename in the Y-th
                        \ character of lodosc+5, which will be directly after
                        \ the last letter we copied above

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then we haven't yet blanked out the whole
 BCC rfileL4            \ name, so loop back to rfileL4 to blank the next one
                        \ until the load string is ready for use

IF _SNG47

 JSR getzp              \ Call getzp to store the top part of zero page in the
                        \ the buffer at &3000, as it gets corrupted by the MOS
                        \ during disc access

ELIF _COMPACT

 JSR NMIRELEASE         \ Release the NMI workspace (&00A0 to &00A7) so the MOS
                        \ can use it, and store the top part of zero page in the
                        \ the buffer at &3000, as it gets corrupted by the MOS
                        \ during disc access

ENDIF

 LDX #LO(lodosc)        \ Set (Y X) to point to the OS command at lodosc, which
 LDY #HI(lodosc)        \ contains the DFS command for loading the commander
                        \ file

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ loads the commander file

 JSR getzp              \ Call getzp to restore the top part of zero page from
                        \ the buffer at &3000

                        \ We now copy the newly loaded commander data block to
                        \ the TAP% staging area, though this has no effect as we
                        \ then ignore the result (this code is left over from
                        \ the Commodore 64 version)

 LDY #NT%               \ Set a counter in Y to copy the NT% bytes in the
                        \ commander data block

.rfileL1

 LDA commbuf,Y          \ Copy the Y-th byte of the commbuf file buffer to the
 STA TAP%,Y             \ Y-th byte of the TAP% staging area

 DEY                    \ Decrement the loop counter

 BPL rfileL1            \ Loop back until we have copied all the bytes in the
                        \ newly loaded commander data block

 RTS                    \ Return from the subroutine

 RTS                    \ This instruction has no effect as we already returned
                        \ from the subroutine

