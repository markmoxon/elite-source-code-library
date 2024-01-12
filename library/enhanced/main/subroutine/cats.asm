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
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Clear if a valid drive number was entered (0-3), set
\                       otherwise
\
\ ******************************************************************************

.CATS

IF _DISC_DOCKED OR _6502SP_VERSION \ Master: The Master Compact only has one disc drive, and it uses ADFS rather than DFS, so instead of asking for a drive number, it asks for a directory name

 JSR GTDRV              \ Get an ASCII disc drive number from the keyboard in A,
                        \ setting the C flag if an invalid drive number was
                        \ entered

 BCS DELT-1             \ If the C flag is set, then an invalid drive number was
                        \ entered, so return from the subroutine (as DELT-1
                        \ contains an RTS)

 STA CTLI+1             \ Store the drive number in the second byte of the
                        \ command string at CTLI, so it overwrites the "0" in
                        \ ".0" with the drive number to catalogue

 STA DTW7               \ Store the drive number in DTW7, so printing extended
                        \ token 4 will show the correct drive number (as token 4
                        \ contains the {drive number} jump code, which calls
                        \ MT16 to print the character in DTW7)

ELIF _MASTER_VERSION

IF _SNG47

 JSR GTDRV              \ Get an ASCII disc drive number from the keyboard in A,
                        \ setting the C flag if an invalid drive number was
                        \ entered

 BCS DELT-1             \ If the C flag is set, then an invalid drive number was
                        \ entered, so return from the subroutine (as DELT-1
                        \ contains an RTS)

 STA CTLI+4             \ Store the drive number in the fifth byte of the
                        \ command string at CTLI, so it overwrites the "1" in
                        \ "CAT 1" with the drive number to catalogue

 STA DTW7               \ Store the drive number in DTW7, so printing extended
                        \ token 4 will show the correct drive number (as token 4
                        \ contains the {drive number} jump code, which calls
                        \ MT16 to print the character in DTW7)

ELIF _COMPACT

 JSR GTDIR              \ Get a directory name from the keyboard and change to
                        \ that directory

ENDIF

ELIF _ELITE_A_VERSION

 JSR GTDRV              \ Get an ASCII disc drive number from the keyboard in A,
                        \ setting the C flag if an invalid drive number was
                        \ entered

 BCS DELT-1             \ If the C flag is set, then an invalid drive number was
                        \ entered, so return from the subroutine (as DELT-1
                        \ contains an RTS)

 STA CTLI+2             \ Store the drive number in the third byte of the
                        \ command string at CTLI, so it overwrites the "0" in
                        \ ".0" with the drive number to catalogue

 STA DTW7               \ Store the drive number in DTW7, so printing extended
                        \ token 4 will show the correct drive number (as token 4
                        \ contains the {drive number} jump code, which calls
                        \ MT16 to print the character in DTW7)

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Minor

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

ELIF _ELITE_A_DOCKED

 LDA #1                 \ Set &0355 to 1. This location in the MOS VDU workspace
 STA &0355              \ contains the current screen mode, but I'm not entirely
                        \ sure why we need to set it to 1 (the disc catalogue
                        \ seems to work fine if we omit the STA instruction)
                        \
                        \ The sixth character of the commander name at NAME+5 is
                        \ stored at address &0355, and the overwrite is reversed
                        \ below, after the disc has been catalogued, to avoid
                        \ corrupting the current commander name

 STA CATF               \ Set the CATF flag to 1, so that the TT26 routine will
                        \ print out the disc catalogue correctly

ELIF _ELITE_A_6502SP_PARA

 LDA #&8E               \ Send command &8E to the I/O processor:
 JSR tube_write         \
                        \   write_xyc(x, y, char)
                        \
                        \ which will draw the text character in char at column x
                        \ and row y, though in this case we're sending a null
                        \ character (char = 0), so this doesn't print anything
                        \ but just moves the text cursor in the I/O processor
                        \ to column XC and row YC

 LDA XC                 \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * x = XC

 LDA YC                 \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * y = YC

 LDA #0                 \ Send the third parameter to the I/O processor:
 JSR tube_write         \
                        \   * char = 0

ENDIF

 STA XC                 \ Move the text cursor to column 1

IF _MASTER_VERSION \ Master: As the Master Compact uses ADFS, this release has to claim and release the NMI workspace when accessing the disc, in order to prevent ADFS from corrupting that part of zero page. It does this by calling the NMICLAIM and NMIRELEASE routines at the appropriate time

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

ENDIF

 LDX #LO(CTLI)          \ Set (Y X) to point to the OS command at CTLI, which
 LDY #HI(CTLI)          \ contains a dot and the drive number, which is the
                        \ DFS command for cataloguing that drive (*. being short
                        \ for *CAT)

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION \ Platform

 JSR OSCLI              \ Call OSCLI to execute the OS command at (Y X), which
                        \ catalogues the disc

ELIF _6502SP_VERSION

 JSR SCLI2              \ Call SCLI2 to execute the OS command at (Y X), which
                        \ catalogues the disc, setting the SVN flag while it's
                        \ running to indicate disc access is in progress

ENDIF

IF _MASTER_VERSION \ Platform

 JSR getzp              \ Call getzp to restore the top part of zero page from
                        \ the buffer at &3000

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

ELIF _ELITE_A_DOCKED

 DEC CATF               \ Decrement the CATF flag back to 0, so the TT26 routine
                        \ reverts to standard formatting

 LDA NA%+5              \ Revert byte #6 of the commander name at NAME+5 to the
 STA NAME+5             \ correct character from the name at NA%, reversing the
                        \ change we did above

ENDIF

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

