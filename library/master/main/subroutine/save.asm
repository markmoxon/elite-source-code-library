\ ******************************************************************************
\
\       Name: SAVE
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save the commander file
\
\ ******************************************************************************

.SAVE

 LDY #NT%               \ We first want to copy the current commander data block
                        \ to location &0E7E so we can do a file save operation,
                        \ so we set a counter in Y to copy the NT% bytes in the
                        \ commander data block

.SAVEL1

 LDA NA%+8,Y            \ Copy the Y-th byte of NA%+8 to the Y-th byte of &0E7E
 STA &0E7E,Y

 DEY                    \ Decrement the loop counter

 BPL SAVEL1             \ Loop back until we have copied all the bytes in the
                        \ commander data block

 LDA #0                 \ The save file is 256 bytes long but only NT% (76) of
                        \ those contain data, so before we save we need to zero
                        \ out the rest of the 256-byte block, so we set A = 0 to
                        \ do this

 LDY #NT%               \ Set an index in Y to point the byte after the end of
                        \ the first NT% bytes in the commander data block

.SAVEL2

 STA &0E7E,Y            \ Zero the Y-th byte of &0E7E

 INY                    \ Increment the loop counter

 BNE SAVEL2             \ Loop back until we have zeroed the rest of the
                        \ 256-byte block

 LDY #0                 \ Now we need to change the save command at SVLI to
                        \ contain the commander name as the filename, so set an
                        \ index in Y so we can copy the commander name from NA%
                        \ into the SVLI command

.SAVEL3

 LDA NA%,Y              \ Fetch the Y-th character of the commander name at NA%

 CMP #13                \ If the character is a carriage return then we have
 BEQ SAVEL4             \ reached the end of the name, so jump to SAVEL4 as we
                        \ have now copied the whole name

IF _SNG47

 STA SVLI+10,Y          \ Store the Y-th character of the commander name in the
                        \ Y-th character of SVLI+10, where SVLI+10 points to the
                        \ JAMESON part of the save command in SVLI:
                        \
                        \   "SAVE :1.E.JAMESON  E7E +100 0 0"

ELIF _COMPACT

 STA SVLI+5,Y           \ ???

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then there may be more characters in the
 BCC SAVEL3             \ name, so loop back to SAVEL3 to fetch the next one

.SAVEL4

 LDA #' '               \ We have copied the name into the SVLI command string,
                        \ but the new name might be shorter then the previous
                        \ one, so we now need to blank out the rest of the name
                        \ with spaces, so we load the space character into A

IF _SNG47

 STA SVLI+10,Y          \ Store the Y-th character of the commander name in the
                        \ Y-th character of SVLI+10, which will be directly
                        \ after the last letter we copied above

ELIF _COMPACT

 STA SVLI+5,Y           \ ???

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then we haven't yet blanked out the whole
 BCC SAVEL4             \ name, so loop back to SAVEL4 to blank the next one
                        \ until the save string is ready for use

IF _SNG47

 JSR SWAPZP             \ Call SWAPZP to store the top part of zero page, as it
                        \ gets corrupted by the MOS during the saving process

ELIF _COMPACT

 JSR &155C              \ ???

ENDIF

 LDX #LO(SVLI)          \ Set (Y X) to point to the OS command at SVLI, which
 LDY #HI(SVLI)          \ contains the DFS command for saving the commander file

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ saves the commander file

 JMP SWAPZP             \ Call SWAPZP to restore the top part of zero page
                        \ and return from the subroutine using a tail call

