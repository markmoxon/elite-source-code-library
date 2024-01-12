\ ******************************************************************************
\
\       Name: wfile
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save the commander file
\
\ ------------------------------------------------------------------------------
\
\ This routine copies a commander file into the commbuf file buffer at &0E7E,
\ and then saves it.
\
\ ******************************************************************************

.wfile

 LDY #NT%               \ We first want to copy the current commander data block
                        \ to the commbuf file buffer so we can do a file save
                        \ operation, so we set a counter in Y to copy the NT%
                        \ bytes in the commander data block

.wfileL1

 LDA NA%+8,Y            \ Copy the Y-th byte of NA%+8 to the Y-th byte of the
 STA commbuf,Y          \ commbuf file buffer

 DEY                    \ Decrement the loop counter

 BPL wfileL1            \ Loop back until we have copied all the bytes in the
                        \ commander data block

 LDA #0                 \ The save file is 256 bytes long but only NT% (76) of
                        \ those contain data, so before we save we need to zero
                        \ out the rest of the 256-byte block, so we set A = 0 to
                        \ do this

 LDY #NT%               \ Set an index in Y to point the byte after the end of
                        \ the first NT% bytes in the commander data block

.wfileL2

 STA commbuf,Y          \ Zero the Y-th byte of the commbuf file buffer

 INY                    \ Increment the loop counter

 BNE wfileL2            \ Loop back until we have zeroed the rest of the
                        \ 256-byte block

 LDY #0                 \ Now we need to change the save command at savosc to
                        \ contain the commander name as the filename, so set an
                        \ index in Y so we can copy the commander name from NA%
                        \ into the savosc command

.wfileL3

 LDA NA%,Y              \ Fetch the Y-th character of the commander name at NA%

 CMP #13                \ If the character is a carriage return then we have
 BEQ wfileL4            \ reached the end of the name, so jump to wfileL4 as we
                        \ have now copied the whole name

IF _SNG47

 STA savosc+10,Y        \ Store the Y-th character of the commander name in the
                        \ Y-th character of savosc+10, where savosc+10 points to
                        \ the JAMESON part of the save command in savosc:
                        \
                        \   "SAVE :1.E.JAMESON  E7E +100 0 0"

ELIF _COMPACT

 STA savosc+5,Y         \ Store the Y-th character of the commander name in the
                        \ Y-th character of savosc+5, where savosc+5 points to
                        \ the JAMESON part of the save command in savosc:
                        \
                        \   "SAVE JAMESON  E7E +100 0 0"

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then there may be more characters in the
 BCC wfileL3            \ name, so loop back to wfileL3 to fetch the next one

.wfileL4

 LDA #' '               \ We have copied the name into the savosc command
                        \ string, but the new name might be shorter than the
                        \ previous one, so we now need to blank out the rest
                        \ of the name with spaces, so we load the space
                        \ character into A

.wfileL5

IF _SNG47

 STA savosc+10,Y        \ Store the Y-th character of the commander name in the
                        \ Y-th character of savosc+10, which will be directly
                        \ after the last letter we copied above

ELIF _COMPACT

 STA savosc+5,Y         \ Store the Y-th character of the commander name in the
                        \ Y-th character of savosc+5, which will be directly
                        \ after the last letter we copied above

ENDIF

 INY                    \ Increment the loop counter

 CPY #7                 \ If Y < 7 then we haven't yet blanked out the whole
 BCC wfileL4            \ name, so loop back to wfileL4 to blank the next one
                        \ until the save string is ready for use

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

 LDX #LO(savosc)        \ Set (Y X) to point to the OS command at savosc, which
 LDY #HI(savosc)        \ contains the DFS command for saving the commander file

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ saves the commander file

 JMP getzp              \ Call getzp to restore the top part of zero page from
                        \ the buffer at &3000 and return from the subroutine
                        \ using a tail call

