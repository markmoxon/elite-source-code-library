\ ******************************************************************************
\
\       Name: QUS1
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save or load the commander file
\
\ ------------------------------------------------------------------------------
\
\ The filename should be stored at INWK, terminated with a carriage return (13),
\ and the routine should be called with Y set to &C.
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
IF _CASSETTE_VERSION
\   Y                   Points to the page number containing the OSFILE block,
\                       which must be &C because that's where the pointer to the
\                       filename in INWK is stored below (by the STX &C00
\                       instruction)
\
ENDIF
\ ******************************************************************************

.QUS1

IF _6502SP_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ call to GTDRV

 JSR GTDRV

 STA INWK+1
 PLA
 BCS QUR
 PHA
 LDA #&FF
 JSR DODOSVN

 PLA                    \ Restore A from the stack

ENDIF

 LDX #INWK              \ Store a pointer to INWK at the start of the block at
 STX &0C00              \ &0C00, storing #INWK in the low byte because INWK is
                        \ in zero page

IF _CASSETTE_VERSION

 LDX #0                 \ Set X to 0 so (Y X) = &0C00

 JMP OSFILE             \ Jump to OSFILE to do the file operation specified in
                        \ &0C00, returning from the subroutine using a tail
                        \ call

ELIF _6502SP_VERSION

 LDX #0                 \ Set (Y X) = &0C00
 LDY #&C

 JSR OSFILE             \ Call OSFILE to do the file operation specified in
                        \ &0C00

 JSR CLDELAY
 LDA #0
 JSR DODOSVN
 CLC

.QUR

 RTS

ENDIF

