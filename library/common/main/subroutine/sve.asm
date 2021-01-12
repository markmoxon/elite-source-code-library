\ ******************************************************************************
\
\       Name: SVE
\       Type: Subroutine
\   Category: Save and load
IF _CASSETTE_VERSION OR _DISC_VERSION
\    Summary: Save the commander file
ELIF _6502SP_VERSION
\    Summary: Display the disc access menu and process saving of commander files
ENDIF
\  Deep dive: The competition code
\
IF _6502SP_VERSION
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if we loaded a new file, clear otherwise
\
ENDIF
\ ******************************************************************************

.SVE

IF _CASSETTE_VERSION OR _DISC_VERSION

 JSR GTNME              \ Clear the screen and ask for the commander filename
                        \ to save, storing the name at INWK

ELIF _6502SP_VERSION

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

 TSX                    \ Transfer the stack pointer to X and store it in stack,
 STX stack              \ so we can restore it in the MRBRK routine

 LDA #LO(MEBRK)         \ Set BRKV to point to the MEBRK routine, disabling
 SEI                    \ while we make the change and re-enabling them once we
 STA BRKV               \ are done. MEBRK is the BRKV handler for disc access
 LDA #HI(MEBRK)         \ operations, and replaces the standard BRKV handler in
 STA BRKV+1             \ BRBR while disc access operations are happening
 CLI

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

 JSR GTNMEW             \ If we get here then option 2 (save) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to save (including drive number and directory) into
                        \ INWK

ENDIF

 JSR TRNME              \ Transfer the commander filename from INWK to NA%

IF _CASSETTE_VERSION OR _DISC_VERSION

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

ENDIF

 LSR SVC                \ Halve the save count value in SVC

IF _6502SP_VERSION

 LDA #3                 \ Print extended token 3 ("COMPETITION NUMBER:")
 JSR DETOK

ENDIF

 LDX #NT%               \ We now want to copy the current commander data block
                        \ from location TP to the last saved commander block at
                        \ NA%+8, so set a counter in X to copy the NT% bytes in
                        \ the commander data block
                        \
                        \ We also want to copy the data block to another
                        \ location &0B00, which is normally used for the ship
                        \ lines heap

.SVL1

 LDA TP,X               \ Copy the X-th byte of TP to the X-th byte of &B00
 STA &B00,X             \ and NA%+8
 STA NA%+8,X

 DEX                    \ Decrement the loop counter

 BPL SVL1               \ Loop back until we have copied all NT% bytes

 JSR CHECK              \ Call CHECK to calculate the checksum for the last
                        \ saved commander and return it in A

 STA CHK                \ Store the checksum in CHK, which is at the end of the
                        \ last saved commander block

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

IF _CASSETTE_VERSION OR _DISC_VERSION

 JSR BPRNT              \ Print the competition number stored in K to K+3. The
                        \ values of the C flag and U will affect how this is
                        \ printed, which is odd as they appear to be random (C
                        \ is last set in CHECK and could go either way, and it's
                        \ hard to know when U was last set as it's a temporary
                        \ variable in zero page, so isn't reset by ZERO). I
                        \ wonder if the competition number can ever get printed
                        \ out incorrectly, with a decimal point and the wrong
                        \ number of digits? Other versions of Elite have a CLC
                        \ instruction before the call to BPRNT, presumably to
                        \ fix this issue

 JSR TT67               \ Call TT67 twice to print two newlines
 JSR TT67

ELIF _6502SP_VERSION

 CLC                    \ Clear the C flag so the call to BPRNT does not include
                        \ a decimal point

 JSR BPRNT              \ Print the competition number stored in K to K+3. The
                        \ value of U might affect how this is printed, and as
                        \ it's a temporary variable in zero page that isn't
                        \ reset by ZERO, it might have any value, but as the
                        \ competition code is a 10-digit number, this just means
                        \ it may or may not have an extra space of padding

 JSR TT67               \ Print a newline

ENDIF

 PLA                    \ Restore the checksum from the stack

 STA &B00+NT%           \ Store the checksum in the last byte of the save file
                        \ at &0B00 (the equivalent of CHK in the last saved
                        \ block)

 EOR #&A9               \ Store the checksum EOR &A9 in CHK2, the penultimate
 STA CHK2               \ byte of the last saved commander block

 STA &AFF+NT%           \ Store the checksum EOR &A9 in the penultimate byte of
                        \ the save file at &0B00 (the equivalent of CHK2 in the
                        \ last saved block)

 LDY #&B                \ Set up an OSFILE block at &0C00, containing:
 STY &C0B               \
 INY                    \ Start address for save = &00000B00 in &0C0A to &0C0D
 STY &C0F               \
                        \ End address for save = &00000C00 in &0C0E to &0C11
                        \
                        \ Y is left containing &C which we use below

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

 INC SVN                \ Increment SVN to indicate we are about to start saving

ENDIF

 LDA #0                 \ Call QUS1 with A = 0, Y = &C to save the commander
 JSR QUS1               \ file with the filename we copied to INWK at the start
                        \ of this routine

IF _CASSETTE_VERSION OR _DISC_VERSION

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

ELIF _6502SP_VERSION

IF _SNG45

 JSR DFAULT             \ Call DFAULT to reset the current commander data block
                        \ to the last saved commander

ENDIF

.SVEX

 CLC                    \ Clear the C flag to indicate we didn't just load a new
                        \ commander file

 JMP BRKBK              \ Jump to BRKBK to set BRKV back to the standard BRKV
                        \ handler for the game, and return from the subroutine
                        \ using a tail call

ENDIF

