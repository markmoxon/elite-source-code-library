\ ******************************************************************************
\
\       Name: SVE
\       Type: Subroutine
\   Category: Save and load
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
\    Summary: Save the commander file
ELIF _6502SP_VERSION
\    Summary: Display the disc access menu and process saving of commander files
ELIF _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION
\    Summary: Display the disk access menu and process saving of commander files
ENDIF
\  Deep dive: Commander save files
\             The competition code
\
IF _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if we loaded a new file, clear otherwise
\
ENDIF
\ ******************************************************************************

.SVE

IF _6502SP_VERSION OR _DISC_DOCKED \ Platform

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

 TSX                    \ Transfer the stack pointer to X and store it in stack,
 STX stack              \ so we can restore it in the MEBRK routine

ELIF _MASTER_VERSION

 TSX                    \ Transfer the stack pointer to X and store it in
 STX stackpt            \ stackpt, so we can restore it in the NEWBRK routine

 JSR TRADEMODE2         \ Set the palette for trading screens and switch the
                        \ current colour to white

ELIF _ELITE_A_VERSION

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

 TSX                    \ Transfer the stack pointer to X and store it in
 STX MEBRK+1            \ MEBRK+1, which modifies the LDX #&FF instruction at
                        \ the start of MEBRK so that it sets X to the value of
                        \ the stack pointer

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Platform

 LDA #LO(MEBRK)         \ Set BRKV to point to the MEBRK routine, which is the
 STA BRKV               \ BRKV handler for disc access operations, and replaces
 LDA #HI(MEBRK)         \ the standard BRKV handler in BRBR while disc access
 STA BRKV+1             \ operations are happening

ELIF _6502SP_VERSION

 LDA #LO(MEBRK)         \ Set BRKV to point to the MEBRK routine, disabling
 SEI                    \ interrupts while we make the change and re-enabling
 STA BRKV               \ them once we are done. MEBRK is the BRKV handler for
 LDA #HI(MEBRK)         \ disc access operations, and replaces the standard BRKV
 STA BRKV+1             \ handler in BRBR while disc access operations are
 CLI                    \ happening

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED \ Enhanced: Group A: The enhanced versions show a disc access menu when the "@" key is pressed, which lets you load and save commanders, catalogue discs and delete files

 LDA #1                 \ Print extended token 1, the disc access menu, which
 JSR DETOK              \ presents these options:
                        \
                        \   1. Load New Commander
                        \   2. Save Commander {commander name}
                        \   3. Catalogue
                        \   4. Delete A File
                        \   5. Exit

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'1'               \ If A < ASCII "1", jump to SVEX to exit as the key
 BCC SVEX               \ press doesn't match a menu option

 CMP #'4'               \ If "4" was pressed, jump to DELT to process option 4
 BEQ DELT               \ (delete a file)

 BCS SVEX               \ If A >= ASCII "4", jump to SVEX to exit as the key
                        \ press is either option 5 (exit), or it doesn't match a
                        \ menu option (as we already checked for "4" above)

 CMP #'2'               \ If A >= ASCII "2" (i.e. save or catalogue), skip to
 BCS SV1                \ SV1

 JSR GTNMEW             \ If we get here then option 1 (load) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to load (including drive number and directory) into
                        \ INWK

 JSR LOD                \ Call LOD to load the commander file

 JSR TRNME              \ Transfer the commander filename from INWK to NA%

 SEC                    \ Set the C flag to indicate we loaded a new commander
 BCS SVEX+1             \ file, and return from the subroutine (as SVEX+1
                        \ contains an RTS)

.SV1

 BNE CAT                \ We get here following the CMP #'2' above, so this
                        \ jumps to CAT if option 2 was not chosen - in other
                        \ words, if option 3 (catalogue) was chosen

ELIF _MASTER_VERSION

 LDA #1                 \ Print extended token 1, the disc access menu, which
 JSR DETOK              \ presents these options:
                        \
                        \   1. Load New Commander
                        \   2. Save Commander {commander name}
                        \   3. Catalogue
                        \   4. Delete A File
                        \   5. Default JAMESON
                        \   6. Exit

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'1'               \ Option 1 was chosen, so jump to loading to load a new
 BEQ loading            \ commander

 CMP #'2'               \ Option 2 was chosen, so jump to SV1 to save the
 BEQ SV1                \ current commander

 CMP #'3'               \ Option 3 was chosen, so jump to feb10 to catalogue a
 BEQ feb10              \ disc

 CMP #'4'               \ If option 4 wasn't chosen, skip the next two
 BNE jan18              \ instructions

 JSR DELT               \ Option 4 was chosen, so call DELT to delete a file

 JMP SVE                \ Jump to SVE to display the disc access menu again and
                        \ return from the subroutine using a tail call

.jan18

 CMP #'5'               \ If option 5 wasn't chosen, skip to feb13 to exit the
 BNE feb13              \ menu

 LDA #224               \ Print extended token 224 ("ARE YOU SURE?")
 JSR DETOK

 JSR YESNO              \ Call YESNO to wait until either "Y" or "N" is pressed

 BCC feb13              \ If "N" was pressed, jump to feb13

 JSR JAMESON            \ Otherwise "Y" was pressed, so call JAMESON to set the
                        \ last saved commander to the default "JAMESON"
                        \ commander

 JMP DFAULT             \ Jump to DFAULT to reset the current commander data
                        \ block to the last saved commander, returning from the
                        \ subroutine using a tail call

.feb13

 CLC                    \ Option 5 was chosen, so clear the C flag to indicate
                        \ that nothing was loaded

 RTS                    \ Return from the subroutine

.feb10

 JSR CATS               \ Call CATS to ask for a drive number (or a directory
                        \ name on the Master Compact) and catalogue that disc
                        \ or directory

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JMP SVE                \ Jump to SVE to display the disc access menu and return
                        \ from the subroutine using a tail call

.loading

 JSR GTNMEW             \ If we get here then option 1 (load) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to load (including drive number and directory) into
                        \ INWK

IF _SNG47

 JSR GTDRV              \ Get an ASCII disc drive number from the keyboard in A,
                        \ setting the C flag if an invalid drive number was
                        \ entered

 BCS jan2186            \ If the C flag is set, then an invalid drive number was
                        \ entered, so return from the subroutine (as DELT-1
                        \ contains an RTS)

 STA lodosc+6           \ Store the ASCII drive number in lodosc+6, which is the
                        \ drive character of the load filename string ":1.E."

ENDIF

 JSR LOD                \ Call LOD to load the commander file

 JSR TRNME              \ Transfer the commander filename from INWK to NA%

 SEC                    \ Set the C flag to indicate we loaded a new commander

.jan2186

 RTS                    \ Return from the subroutine

.SV1

ELIF _C64_VERSION

 LDA #1                 \ Print extended token 1, the disk access menu, which
 JSR DETOK              \ presents these options:
                        \
                        \   1. Load New Commander
                        \   2. Save Commander {commander name}
                        \   3. Change to {other media}
                        \   4. Default JAMESON
                        \   5. Exit

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'1'               \ Option 1 was chosen, so jump to loading to load a new
 BEQ loading            \ commander

 CMP #'2'               \ Option 2 was chosen, so jump to SV1 to save the
 BEQ SV1                \ current commander

 CMP #'3'               \ Option 3 was chosen, so jump to feb10 to change to the
 BEQ feb10              \ other media

 CMP #'4'               \ If option 4 wasn't chosen, jump to feb13 to exit the
 BNE feb13              \ menu

 LDA #224               \ Option 4 was chosen, so print extended token 224
 JSR DETOK              \ ("ARE YOU SURE?")

 JSR YESNO              \ Call YESNO to wait until either "Y" or "N" is pressed

 BCC feb13              \ If "N" was pressed, jump to feb13

 JSR JAMESON            \ Otherwise "Y" was pressed, so call JAMESON to set the
                        \ last saved commander to the default "JAMESON"
                        \ commander

 JMP DFAULT             \ Jump to DFAULT to reset the current commander data
                        \ block to the last saved commander, returning from the
                        \ subroutine using a tail call

.feb13

 CLC                    \ Option 5 was chosen, so clear the C flag to indicate
                        \ that nothing was loaded

 RTS                    \ Return from the subroutine

.feb10

 LDA DISK               \ Toggle the value of DISK between 0 and &FF to swap the
 EOR #&FF               \ current media between tape and disk
 STA DISK

 JMP SVE                \ Jump to SVE to display the disk access menu and return
                        \ from the subroutine using a tail call

.loading

 JSR GTNMEW             \ If we get here then option 1 (load) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to load (including drive number and directory) into
                        \ INWK

 JSR LOD                \ Call LOD to load the commander file

 JSR TRNME              \ Transfer the commander filename from INWK to NA%

 SEC                    \ Set the C flag to indicate we loaded a new commander

.jan2186

 RTS                    \ Return from the subroutine

.SV1

ELIF _APPLE_VERSION

 LDA #1                 \ Print extended token 1, the disk access menu, which
 JSR DETOK              \ presents these options:
                        \
                        \   1. Load New Commander
                        \   2. Save Commander {commander name}
                        \   3. Default JAMESON
                        \   4. Exit

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'1'               \ Option 1 was chosen, so jump to loading to load a new
 BEQ loading            \ commander

 CMP #'2'               \ Option 2 was chosen, so jump to SV1 to save the
 BEQ SV1                \ current commander

 CMP #'3'               \ If option 3 wasn't chosen, jump to feb13 to exit the
\BEQ feb10              \ menu
\CMP #'4'               \
 BNE feb13              \ The instructions in the middle are commented out in
                        \ the original source

 LDA #224               \ Option 3 was chosen, so print extended token 224
 JSR DETOK              \ ("ARE YOU SURE?")

 JSR YESNO              \ Call YESNO to wait until either "Y" or "N" is pressed

 BCC feb13              \ If "N" was pressed, jump to feb13

 JSR JAMESON            \ Otherwise "Y" was pressed, so call JAMESON to set the
                        \ last saved commander to the default "JAMESON"
                        \ commander

 JMP DFAULT             \ Jump to DFAULT to reset the current commander data
                        \ block to the last saved commander, returning from the
                        \ subroutine using a tail call

.feb13

 CLC                    \ Option 5 was chosen, so clear the C flag to indicate
                        \ that nothing was loaded

 RTS                    \ Return from the subroutine

\.feb10                 \ These instructions are commented out in the original
\                       \ source
\LDA DISK
\EOR #&FF
\STA DISK
\
\JMP SVE

.loading

 JSR GTNMEW             \ If we get here then option 1 (load) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to load (including drive number and directory) into
                        \ INWK

 JSR LOD                \ Call LOD to load the commander file

 JSR TRNME              \ Transfer the commander filename from INWK to NA%

 SEC                    \ Set the C flag to indicate we loaded a new commander

 RTS                    \ Return from the subroutine

.SV1

ELIF _ELITE_A_VERSION

 LDA #1                 \ Print extended token 1, the disc access menu, which
 JSR DETOK              \ presents these options:
                        \
                        \   1. Load New Commander
                        \   2. Save Commander {commander name}
                        \   3. Catalogue
                        \   4. Delete A File
                        \   5. Exit

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'1'               \ If A < ASCII "1", jump to SVEX to exit as the key
 BCC SVEX               \ press doesn't match a menu option

 CMP #'4'               \ If "4" was pressed, jump to DELT to process option 4
 BEQ DELT               \ (delete a file)

 BCS SVEX               \ If A >= ASCII "4", jump to SVEX to exit as the key
                        \ press is either option 5 (exit), or it doesn't match a
                        \ menu option (as we already checked for "4" above)

 CMP #'2'               \ If A >= ASCII "2" (i.e. save or catalogue), skip to
 BCS SV1                \ SV1

                        \ If we get here then option 1 (load) was chosen

 LDA #0                 \ If save_lock = &FF, then there are unsaved changes, so
 JSR confirm            \ ask for confirmation before proceeding with the load,
 BNE SVEX               \ jumping to SVEX to exit if confirmation is not given

 JSR GTNMEW             \ Call GTNMEW to fetch the name of the commander file
                        \ to load (including drive number and directory) into
                        \ INWK

 JSR LOD                \ Call LOD to load the commander file

 JSR TRNME              \ Transfer the commander filename from INWK to NA%

 SEC                    \ Set the C flag to indicate we loaded a new commander
 BCS SVEX+1             \ file, and return from the subroutine (as SVEX+1
                        \ contains an RTS)

.SV1

 BNE CAT                \ We get here following the CMP #'2' above, so this
                        \ jumps to CAT if option 2 was not chosen - in other
                        \ words, if option 3 (catalogue) was chosen

                        \ If we get here then option 2 (save) was chosen

 LDA #&FF               \ If save_lock = 0, then there are no unsaved changes,
 JSR confirm            \ so ask for confirmation before proceeding with the
 BNE SVEX               \ save, jumping to SVEX to exit if confirmation is not
                        \ given

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Enhanced: See group A

 JSR GTNMEW             \ If we get here then option 2 (save) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to save (including drive number and directory) into
                        \ INWK

ELIF _CASSETTE_VERSION OR _ELECTRON_VERSION

 JSR GTNME              \ Clear the screen and ask for the commander filename
                        \ to save, storing the name at INWK

ELIF _ELITE_A_VERSION

 JSR GTNMEW             \ Call GTNMEW to fetch the name of the commander file
                        \ to save (including drive number and directory) into
                        \ INWK

ENDIF

 JSR TRNME              \ Transfer the commander filename from INWK to NA%

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

ENDIF

IF NOT(_ELITE_A_VERSION)

 LSR SVC                \ Halve the save count value in SVC

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED \ Enhanced: In the disc and 6502SP versions, the competition number is labelled as such when saving. In the cassette version, it is just displayed as a standalone number, without any clues as to what it is, while the Master doesn't show the number at all

 LDA #3                 \ Print extended token 3 ("COMPETITION NUMBER:")
 JSR DETOK

ELIF _MASTER_VERSION

 LDA #4                 \ Print extended token 4, which is blank (this was where
 JSR DETOK              \ the competition number was printed in older versions,
                        \ but the competition was long gone by the time of the
                        \ BBC Master version

ELIF _C64_VERSION OR _APPLE_VERSION

 LDA #4                 \ Print extended token 4 ("COMPETITION NUMBER:")
 JSR DETOK

ENDIF

 LDX #NT%               \ We now want to copy the current commander data block
                        \ from location TP to the last saved commander block at
                        \ NA%+8, so set a counter in X to copy the NT% bytes in
                        \ the commander data block
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
                        \
                        \ We also want to copy the data block to another
                        \ location &0B00, which is normally used for the ship
                        \ lines heap
ENDIF

.SVL1

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA TP,X               \ Copy the X-th byte of TP to the X-th byte of &0B00
 STA &0B00,X            \ and NA%+8
 STA NA%+8,X

ELIF _ELECTRON_VERSION

 LDA TP,X               \ Copy the X-th byte of TP to the X-th byte of &0900
 STA &0900,X            \ and NA%+8
 STA NA%+8,X

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA TP,X               \ Copy the X-th byte of TP to the X-th byte of NA%+8
\STA &0B00,X            \
 STA NA%+8,X            \ The STA is commented out in the original source

ENDIF

 DEX                    \ Decrement the loop counter

 BPL SVL1               \ Loop back until we have copied all the bytes in the
                        \ commander data block

IF _MASTER_VERSION \ Comment

\JSR CHECK2             \ These instructions are commented out in the original
\                       \ source
\STA CHK3

ELIF _C64_VERSION OR _APPLE_VERSION

 JSR CHECK2             \ Call CHECK2 to calculate the third checksum for the
                        \ last saved commander and return it in A

 STA CHK3               \ Store the checksum in CHK3, which is at the end of the
                        \ last saved commander block

ENDIF

 JSR CHECK              \ Call CHECK to calculate the checksum for the last
                        \ saved commander and return it in A

 STA CHK                \ Store the checksum in CHK, which is at the end of the
                        \ last saved commander block

IF NOT(_ELITE_A_VERSION)

 PHA                    \ Store the checksum on the stack

 ORA #%10000000         \ Set K = checksum with bit 7 set
 STA K

 EOR COK                \ Set K+2 = K EOR COK (the competition flags)
 STA K+2

 EOR CASH+2             \ Set K+1 = K+2 EOR CASH+2 (the third cash byte)
 STA K+1

 EOR #&5A               \ Set K+3 = K+1 EOR &5A EOR TALLY+1 (the high byte of
 EOR TALLY+1            \ the kill tally)
 STA K+3

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Other: This is a bug fix in the enhanced versions to stop the competition code being printed with a decimal point, which can sometimes happen in the cassette and Electron versions

 CLC                    \ Clear the C flag so the call to BPRNT does not include
                        \ a decimal point

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Master: The Master version doesn't show the competition number when saving, as the competition closed some time before the Master came on the scene

 JSR BPRNT              \ Print the competition number stored in K to K+3. The
                        \ value of U might affect how this is printed, and as
                        \ it's a temporary variable in zero page that isn't
                        \ reset by ZERO, it might have any value, but as the
                        \ competition code is a 10-digit number, this just means
                        \ it may or may not have an extra space of padding

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 JSR TT67               \ Call TT67 twice to print two newlines
 JSR TT67

ELIF _6502SP_VERSION OR _DISC_DOCKED

 JSR TT67               \ Print a newline

ENDIF

IF NOT(_ELITE_A_VERSION)

 PLA                    \ Restore the checksum from the stack

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 STA &0B00+NT%          \ Store the checksum in the last byte of the save file
                        \ at &0B00 (the equivalent of CHK in the last saved
                        \ block)

ELIF _ELECTRON_VERSION

 STA &0900+NT%          \ Store the checksum in the last byte of the save file
                        \ at &0900 (the equivalent of CHK in the last saved
                        \ block)

ELIF _C64_VERSION

\STA &0B00+NT%          \ This instruction is commented out in the original
                        \ source

ENDIF

 EOR #&A9               \ Store the checksum EOR &A9 in CHK2, the penultimate
 STA CHK2               \ byte of the last saved commander block

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 STA &0AFF+NT%          \ Store the checksum EOR &A9 in the penultimate byte of
                        \ the save file at &0B00 (the equivalent of CHK2 in the
                        \ last saved block)

 LDY #&B                \ Set up an OSFILE block at &0C00, containing:
 STY &0C0B              \
 INY                    \ Start address for save = &00000B00 in &0C0A to &0C0D
 STY &0C0F              \
                        \ End address for save = &00000C00 in &0C0E to &0C11
                        \
                        \ Y is left containing &C which we use below

ELIF _ELECTRON_VERSION

 STA &08FF+NT%          \ Store the checksum EOR &A9 in the penultimate byte of
                        \ the save file at &0900 (the equivalent of CHK2 in the
                        \ last saved block)

 LDY #&9                \ Set up an OSFILE block at &0A00, containing:
 STY &0A0B              \
 INY                    \ Start address for save = &00000900 in &0A0A to &0A0D
 STY &0A0F              \
                        \ End address for save = &00000A00 in &0A0E to &0A11
                        \
                        \ Y is left containing &A which we use below

ELIF _C64_VERSION

\STA &AFF+NT%           \ This instruction is commented out in the original
                        \ source

ELIF _APPLE_VERSION

 JSR COPYNAME           \ Copy the last saved commander's name from INWK+5 to
                        \ comnam and pad out the rest of comnam with spaces, so
                        \ we can use it as the filename to write in wfile

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

 INC SVN                \ Increment SVN to indicate we are about to start saving

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA #0                 \ Call QUS1 with A = 0, Y = &C to save the commander
 JSR QUS1               \ file with the filename we copied to INWK at the start
                        \ of this routine

ELIF _ELECTRON_VERSION

 LDA #0                 \ Call QUS1 with A = 0, Y = &A to save the commander
 JSR QUS1               \ file with the filename we copied to INWK at the start
                        \ of this routine

ELIF _MASTER_VERSION

                        \ We now copy the current commander data block into the
                        \ TAP% staging area, though this has no effect as we
                        \ then ignore the result (this code is left over from
                        \ the Apple II version)

 LDY #NT%               \ Set a counter in X to copy the NT% bytes in the
                        \ commander data block

.copyme2

 LDA NA%+8,Y            \ Copy the X-th byte of NA% to the X-th byte of TAP%
 STA TAP%,Y

 DEY                    \ Decrement the loop counter

 BPL copyme2            \ Loop back until we have copied all the bytes in the
                        \ commander data block

IF _SNG47

 JSR GTDRV              \ Get an ASCII disc drive number from the keyboard in A,
                        \ setting the C flag if an invalid drive number was
                        \ entered

 BCS SVEX9              \ If the C flag is set, then an invalid drive number was
                        \ entered, so skip the next two instructions

 STA savosc+6           \ Store the ASCII drive number in savosc+6, which is the
                        \ drive character of the save filename string ":1.E."

ENDIF

 JSR wfile              \ Call wfile to save the commander file

.SVEX9

 JSR DFAULT             \ Call DFAULT to reset the current commander data
                        \ block to the last saved commander

.SVEX

 CLC                    \ Clear the C flag to indicate that no new commander
                        \ file was loaded

 RTS                    \ Return from the subroutine

ELIF _C64_VERSION

\LDA #0                 \ These instructions are commented out in the original
\JSR QUS1               \ source

 JSR KERNALSETUP        \ Set up memory so we can use the Kernal functions,
                        \ which includes swapping the contents of zero page with
                        \ the page at &CE00 (so the Kernal functions get a zero
                        \ page that works for them, and any changes they make do
                        \ not corrupt the game's zero page variables)
                        \
                        \ This also enables interrupts that are generated by
                        \ timer A underflow

 LDA #LO(NA%+8)         \ Set &FD(1 0) = NA%+8
 STA &FD                \
 LDA #HI(NA%+8)         \ This sets the address at zero page location &FD and
 STA &FE                \ &FD+1 to NA%+8, which is the address of the commander
                        \ data that we want to save

 LDA #&FD               \ Call the Kernal's SAVE function to save the commander
 LDX #LO(CHK+1)         \ file as follows:
 LDY #HI(CHK+1)         \
 JSR KERNALSVE          \   * A = address in zero page of the start address of
                        \         the memory block to save, so this makes SAVE
                        \         save the data from NA%+8 onwards
                        \
                        \   * (Y X) = address of the end of the block of memory
                        \             to save + 1, so this makes SAVE save the
                        \             data from NA%+8 to CHK (inclusive)

 PHP                    \ If something goes wrong with the save then the C flag
                        \ will be set, so save this on the stack so we can check
                        \ it below

 SEI                    \ Disable interrupts while we configure the CIA and
                        \ VIC-II

 BIT CIA+&D             \ Reading from register &D of CIA1 will acknowledge any
                        \ interrupts and clear them, so this line acknowledges
                        \ any pending interrupts that might be waiting to be
                        \ processed (using a BIT reads the location without
                        \ changing any CPU registers - it only affects the
                        \ flags, which we can simply ignore)

 LDA #%00000001         \ Set CIA1 register &0D to enable and disable interrupts
 STA CIA+&D             \ as follows:
                        \
                        \   * Bit 0 set = configure interrupts generated by
                        \                 timer A underflow
                        \
                        \   * Bits 1-4 clear = do not change configuration of
                        \                      other interrupts
                        \
                        \   * Bit 7 clear = disable interrupts whose
                        \                   corresponding bits are set
                        \
                        \ So this disables interrupts that are generated by
                        \ timer A underflow, while leaving other interrupts as
                        \ they are

 LDX #0                 \ Set the raster count to 0 to initialise the raster
 STX RASTCT             \ effects in the COMIRQ handler (such as the split
                        \ screen)

 INX                    \ Set bit 0 of VIC register &1A and clear bits 1-3 to
 STX VIC+&1A            \ configure the following interrupts:
                        \
                        \   * Bit 0 = enable raster interrupt
                        \
                        \   * Bit 1 = disable sprite-background collision
                        \             interrupt
                        \
                        \   * Bit 2 = disable sprite-sprite collision interrupt
                        \
                        \   * Bit 3 = disable light pen interrupt

 LDA VIC+&11            \ Clear bit 7 of VIC register &11, to clear the top bit
 AND #%01111111         \ of the raster line that generates the interrupt (as
 STA VIC+&11            \ the line number is a 9-bit value, with bits 0-7 in VIC
                        \ register &12)

 LDA #40                \ Set VIC register &11 to 40, so along with bit 7 of VIC
 STA VIC+&12            \ register &10, this sets the raster interrupt to be
                        \ generated when the raster reaches line 40

 LDA #%100              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ "Commodore 64 Programmer's Reference Guide", published
                        \ by Commodore
 CLI                    \ Enable interrupts again

 JSR SWAPPZERO          \ The call to KERNALSETUP above swapped the contents of
                        \ zero page with the page at &CE00, to ensure the Kernal
                        \ routines ran with their copy of zero page rather than
                        \ the game's zero page
                        \
                        \ We are done using the Kernal functions, so now we swap
                        \ them back so the Kernal's zero page is moved to &CE00
                        \ again, ready for next time, and the game's zero page
                        \ variables are once again set up, ready for the game
                        \ code to use

 PLP                    \ Retrieve the processor flags that we stashed after the
                        \ call to KERNALSVE above

 CLI                    \ Enable interrupts to make sure the PHP doesn't disable
                        \ interrupts (which it could feasibly do by restoring a
                        \ set I flag)

 BCS saveerror          \ If KERNALSVE returns with the C flag set then this
                        \ indicates that a save error occurred, so jump to
                        \ tapeerror via saveerror to print either "TAPE ERROR"
                        \ or "DISK ERROR"

 JSR DFAULT             \ Call DFAULT to reset the current commander data block
                        \ to the last saved commander

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

ELIF _APPLE_VERSION

                        \ We now copy the current commander data block into the
                        \ TAP% staging area

 LDY #NT%               \ Set a counter in X to copy the NT% bytes in the
                        \ commander data block

.copyme2

 LDA NA%+8,Y            \ Copy the X-th byte of NA% to the X-th byte of TAP%
 STA TAP%,Y

 DEY                    \ Decrement the loop counter

 BPL copyme2            \ Loop back until we have copied all the bytes in the
                        \ commander data block

 JSR wfile              \ Write the commander file in the buffer at comfil
                        \ (which contains the TAP% buffer) to a DOS disk

 BCS diskerror          \ If the C flag is set then there was a disk error, so
                        \ jump to diskerror to print the disk error (whose
                        \ number is now in A), make a beep and wait for a key
                        \ press

 JSR DFAULT             \ Call DFAULT to reset the current commander data block
                        \ to the last saved commander

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDX #0                 \ Set X = 0 for storing in SVN below

\STX VIA+&4E            \ This instruction is commented out in the original
                        \ source. It would affect the 6522 System VIA interrupt
                        \ enable register IER (SHEILA &4E) if any of bits 0-6
                        \ of X were set, but they aren't, so this instruction
                        \ would have no effect anyway

\DEX                    \ This instruction is commented out in the original
                        \ source. It would end up setting SVN to &FF, which
                        \ affects the logic in the IRQ1 handler

 STX SVN                \ Set SVN to 0 to indicate we are done saving

 JMP BAY                \ Go to the docking bay (i.e. show Status Mode)

ELIF _ELECTRON_VERSION

 JMP BAY                \ Go to the docking bay (i.e. show Status Mode)

ELIF _6502SP_VERSION

IF _SNG45

 JSR DFAULT             \ Call DFAULT to reset the current commander data block
                        \ to the last saved commander

ENDIF

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

.SVEX

 CLC                    \ Clear the C flag to indicate we didn't just load a new
                        \ commander file

 JMP BRKBK              \ Jump to BRKBK to set BRKV back to the standard BRKV
                        \ handler for the game, and return from the subroutine
                        \ using a tail call

ELIF _C64_VERSION OR _APPLE_VERSION

.SVEX

 CLC                    \ Clear the C flag to indicate we didn't just load a new
                        \ commander file

 RTS                    \ Return from the subroutine

ENDIF

IF _C64_VERSION

.saveerror

 JMP tapeerror          \ Jump to tapeerror to print either "TAPE ERROR" or
                        \ "DISK ERROR" (this JMP enables us to use a branch
                        \ instruction to jump to tapeerror)

ENDIF

