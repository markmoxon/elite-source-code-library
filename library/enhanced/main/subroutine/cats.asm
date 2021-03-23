\ ******************************************************************************
\
\       Name: CATS
\       Type: Subroutine
\   Category: Save and load
\    Summary: Ask for a disc drive number and print a catalogue of that drive
\
\ ------------------------------------------------------------------------------
\
\ This routine asks for a disc drive number, and if it is a valid number (0-3)
\ it displays a catalogue of the disc in that drive. It also updates the OS
\ command at CTLI so that when that command is run, it catalogues the correct
\ drive.
\
\ Returns:
\
\   C flag              Clear if a valid drive number was entered (0-3), set
\                       otherwise
\
\ ******************************************************************************

.CATS

 JSR GTDRV              \ Get an ASCII disc drive drive number from the keyboard
                        \ in A, setting the C flag if an invalid drive number
                        \ was entered

 BCS DELT-1             \ If the C flag is set, then an invalid drive number was
                        \ entered, so return from the subroutine (as DELT-1
                        \ contains an RTS)

IF _DISC_DOCKED OR _6502SP_VERSION

 STA CTLI+1             \ Store the drive number in the second byte of the
                        \ command string at CTLI, so it overwrites the "0" in
                        \ ".0" with the drive number to catalogue

ELIF _MASTER_VERSION

 STA CTLI+4             \ Store the drive number in the fifth byte of the
                        \ command string at CTLI, so it overwrites the "1" in
                        \ "CAT 1" with the drive number to catalogue

ENDIF

 STA DTW7               \ Store the drive number in DTW7, so printing extended
                        \ token 4 will show the correct drive number (as token 4
                        \ contains the {drive number} jump code, which calls
                        \ MT16 to print the character in DTW7)

IF _DISC_DOCKED OR _6502SP_VERSION \ Minor

 LDA #4                 \ Print extended token 4, which clears the screen and
 JSR DETOK              \ prints the boxed-out title "DRIVE {drive number}
                        \ CATALOGUE"

ELIF _MASTER_VERSION

 LDA #3                 \ Print extended token 3, which clears the screen and
 JSR DETOK              \ prints the boxed-out title "DRIVE {drive number}
                        \ CATALOGUE"

ENDIF

IF _DISC_DOCKED OR _MASTER_VERSION \ Tube

 LDA #1                 \ Set the CATF flag to 1, so that the TT26 routine will
 STA CATF               \ print out the disc catalogue correctly

ELIF _6502SP_VERSION

 LDA #DOCATF            \ Send a #DOCATF 1 command to the I/O processor to set
 JSR OSWRCH             \ the CATF flag to 1, so that the TT26 routine on the
 LDA #1                 \ I/O processor prints out the disc catalogue correctly
 JSR OSWRCH

ENDIF

 STA XC                 \ Move the text cursor to column 1

IF _MASTER_VERSION

 JSR LOADZP \ ???

ENDIF

 LDX #LO(CTLI)          \ Set (Y X) to point to the OS command at CTLI, which
 LDY #HI(CTLI)          \ contains a dot and the drive number, which is the
                        \ DFS command for cataloguing that drive (*. being short
                        \ for *CAT)

IF _DISC_DOCKED OR _MASTER_VERSION \ Platform

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ catalogues the disc

ELIF _6502SP_VERSION

 JSR SCLI2              \ Call SCLI2 to execute the OS command at (Y X), which
                        \ catalogues the disc, setting the SVN flag while it's
                        \ running to indicate disc access is in progress

ENDIF

IF _MASTER_VERSION

 JSR LOADZP             \ ???

ENDIF

IF _DISC_DOCKED \ Tube

 DEC CATF               \ Decrement the CATF flag back to 0, so the TT26 routine
                        \ reverts to standard formatting

ELIF _6502SP_VERSION

 LDA #DOCATF            \ Send a #DOCATF 0 command to the I/O processor to set
 JSR OSWRCH             \ the CATF flag to 0, so that TT26 returns to normal
 LDA #0                 \ printing
 JSR OSWRCH

ELIF _MASTER_VERSION

 STZ CATF               \ Set the CATF flag to 0, so the TT26 routine reverts to
                        \ standard formatting

ENDIF

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

