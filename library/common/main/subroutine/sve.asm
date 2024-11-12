\ ******************************************************************************
\
\       Name: SVE
\       Type: Subroutine
\   Category: Save and load
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
\    Summary: Save the commander file
ELIF _6502SP_VERSION OR _C64_VERSION
\    Summary: Display the disc access menu and process saving of commander files
ELIF _APPLE_VERSION OR _MASTER_VERSION
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

 LDA DISK               \ ???
 EOR #&FF
 STA DISK

 JMP SVE                \ Jump to SVE to display the disc access menu and return
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
\LDA DISK               \ source
\EOR #&FF
\STA DISK
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
\STA CHK3               \ source

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

 JSR COPYNAME           \ ???

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

 INC SVN                \ Increment SVN to indicate we are about to start saving

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA #0                 \ Call QUS1 with A = 0, Y = &C to save the commander
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

 JSR KERNALSETUP        \ ???
 LDA #((NA%+8)MOD 256)
 STA &FD \ SC
 LDA #((NA%+8)DIV 256)
 STA &FE \ SC+1
 LDA #&FD \ SC
 LDX #((CHK+1)MOD 256)
 LDY #((CHK+1)DIV 256)
 JSR KERNALSVE
 PHP
 SEI
 BIT CIA+&D
 LDA #1
 STA CIA+&D \ disable timer
 LDX #0
 STX RASTCT
 INX
 STX VIC+&1A \enable Raster int
 LDA VIC+&11
 AND #&7F
 STA VIC+&11
 LDA #40
 STA VIC+&12 \set first Raster int
 LDA #4
 JSR SETL1
 CLI
 JSR SWAPPZERO
 PLP
 CLI
 BCS saveerror

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

 JSR wfile              \ ???
 BCS diskerror

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

 JMP tapeerror          \ ???

ELIF _APPLE_VERSION

                        \ Fall through into diskerror to show the disk error

ENDIF

