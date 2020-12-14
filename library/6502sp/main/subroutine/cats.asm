\ ******************************************************************************
\
\       Name: CATS
\       Type: Subroutine
\   Category: Save and load
\    Summary: Catalogue a disc by sending a #DOCATF command to the I/O processor
\
\ ******************************************************************************

.CATS

 JSR GTDRV              \ Get an ASCII disc drive drive number from the keyboard
                        \ in A, setting the C flag if an invalid drive number
                        \ was entered

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

 LDA #4                 \ Print extended token 4, which clears the screen and
 JSR DETOK              \ prints the boxed-out title "DRIVE {drive number}
                        \ CATALOGUE"

 LDA #DOCATF            \ Send a #DOCATF 1 command to the I/O processor to set
 JSR OSWRCH             \ the CATF flag to 1, so that the TT26 routine on the
 LDA #1                 \ I/O processor prints out the disc catalogue correctly
 JSR OSWRCH

 STA XC                 \ Move the text cursor to column 1

 LDX #LO(CTLI)          \ Set (Y X) to point to the OS command at CTLI, which
 LDY #HI(CTLI)          \ contains a dot and the drive number, which is the
                        \ DFS command for cataloguing that drive (*. being short
                        \ for *CAT)

 JSR SCLI2              \ Call SCLI2 to execute the OS command at (Y X), which
                        \ catalogues the disc, setting the SVN flag while it's
                        \ running to indicate disc access is in progress

 LDA #DOCATF            \ Send a #DOCATF 0 command to the I/O processor to set
 JSR OSWRCH             \ the CATF flag to 0, so that TT26 returns to normal
 LDA #0                 \ printing
 JSR OSWRCH

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

