\ ******************************************************************************
\
\       Name: QUS1
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save or load the commander file
\
\ ------------------------------------------------------------------------------
\
\ The filename should be stored at INWK, terminated with a carriage return (13).
IF _CASSETTE_VERSION OR _DISC_VERSION
\ The routine should be called with Y set to &C.
ELIF _6502SP_VERSION
\ The routine asks for a drive number and updates the filename accordingly
\ before performing the load or save.
ENDIF
\
\ Arguments:
\
\   A                   File operation to be performed. Can be one of the
\                       following:
\
\                         * 0 (save file)
\
\                         * &FF (load file)
\
IF _CASSETTE_VERSION OR _DISC_VERSION
\   Y                   Points to the page number containing the OSFILE block,
\                       which must be &C because that's where the pointer to the
\                       filename in INWK is stored below (by the STX &C00
\                       instruction)
\
ELIF _6502SP_VERSION
\ Returns:
\
\   C flag              Set if an invalid drive number was entered
\
ENDIF
\ ******************************************************************************

.QUS1

IF _6502SP_VERSION OR _DISC_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ call to GTDRV

 JSR GTDRV              \ Get an ASCII disc drive drive number from the keyboard
                        \ in A, setting the C flag if an invalid drive number
                        \ was entered

 STA INWK+1             \ Store the ASCII drive number in INWK+1, which is the
                        \ drive character of the filename string ":0.E."

 PLA                    \ Restore A from the stack

 BCS QUR                \ If the C flag is set, then an invalid drive number was
                        \ entered, so jump to QUR to return from the subroutine

ENDIF

IF _6502SP_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ call to DODOSVN

 LDA #255               \ Set the SVN flag to 255 to indicate that disc access
 JSR DODOSVN            \ is in progress

 PLA                    \ Restore A from the stack

ENDIF

 LDX #INWK              \ Store a pointer to INWK at the start of the block at
 STX &0C00              \ &0C00, storing #INWK in the low byte because INWK is
                        \ in zero page

IF _CASSETTE_VERSION

 LDX #0                 \ Set X to 0 so (Y X) = &0C00

 JMP OSFILE             \ Jump to OSFILE to do the file operation specified in
                        \ &0C00 (i.e. save or load a file depending on the value
                        \ of A), returning from the subroutine using a tail call

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDX #0                 \ Set (Y X) = &0C00
 LDY #&C

 JSR OSFILE             \ Call OSFILE to do the file operation specified in
                        \ &0C00 (i.e. save or load a file depending on the value
                        \ of A)

ENDIF

IF _6502SP_VERSION

 JSR CLDELAY            \ Pause for 1280 empty loops

 LDA #0                 \ Set the SVN flag to 0 indicate that disc access has
 JSR DODOSVN            \ finished

ENDIF

IF _6502SP_VERSION OR _DISC_VERSION

 CLC                    \ Clear the C flag

.QUR

 RTS                    \ Return from the subroutine

ENDIF

