\ ******************************************************************************
\
\       Name: LOD
\       Type: Subroutine
\   Category: Save and load
\    Summary: Load a commander file
\
\ ------------------------------------------------------------------------------
\
\ The filename should be stored at INWK, terminated with a carriage return (13).
\
IF _6502SP_VERSION OR _MASTER_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Comment
\ Other entry points:
\
\   LOR                 Set the C flag and return from the subroutine
\
ENDIF
\ ******************************************************************************

.LOD

IF _6502SP_VERSION \ Comment

\LDX #LO(MINI)          \ These instructions are commented out in the original
\LDY #HI(MINI)          \ source, but they would load a commander file called
\JSR OSCLI              \ "E.MINING" and continue below, so presumably this is
\JMP LOL1-2             \ code for loading a test commander file

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDX #2                 \ Enable the ESCAPE key and clear memory if the BREAK
 JSR FX200              \ key is pressed (*FX 200,2)

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

ELIF _6502SP_VERSION

\LDX #2                 \ These instructions are commented out in the original
\JSR FX200              \ source, but they would enable the ESCAPE key and clear
                        \ memory if the BREAK key is pressed (*FX 200,2)

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

ELIF _DISC_DOCKED OR _ELITE_A_VERSION

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

ENDIF

IF _CASSETTE_VERSION  OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDY #&B                \ Set up an OSFILE block at &0C00, containing:
 STY &0C03              \
 INC &0C0B              \ Load address = &00000B00 in &0C02 to &0C05
                        \
                        \ Length of file = &00000100 in &0C0A to &0C0D

ELIF _ELECTRON_VERSION

 LDY #&9                \ Set up an OSFILE block at &0A00, containing:
 STY &0A03              \
 INC &0A0B              \ Load address = &00000900 in &0A02 to &0A05
                        \
                        \ Length of file = &00000100 in &0A0A to &0A0D

ENDIF

IF _CASSETTE_VERSION \ Comment

 INY                    \ Increment Y to &C, which we use next

ELIF _ELECTRON_VERSION

 INY                    \ Increment Y to &A, which we use next

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA #&FF               \ Call QUS1 with A = &FF, Y = &C to load the commander
 JSR QUS1               \ file to address &0B00

ELIF _MASTER_VERSION

 JSR rfile              \ Call rfile to load the commander file to the TAP%
                        \ staging area

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDA &0B00              \ If the first byte of the loaded file has bit 7 set,
 BMI SPS1+1             \ jump to SPS+1, which is the second byte of an LDA #0
                        \ instruction, i.e. a BRK instruction, which will force
                        \ an interrupt to call the address in BRKV, which is set
                        \ to BR1... so this instruction restarts the game from
                        \ the title screen. Valid commander files for the
                        \ cassette version of Elite only have 0 for the first
                        \ byte, as there are no missions in this version, so
                        \ having bit 7 set is invalid anyway

ELIF _ELECTRON_VERSION

 LDA &0900              \ If the first byte of the loaded file has bit 7 set,
 BMI SPS1+1             \ jump to SPS+1, which is the second byte of an LDA #0
                        \ instruction, i.e. a BRK instruction, which will force
                        \ an interrupt to call the address in BRKV, which is set
                        \ to BR1... so this instruction restarts the game from
                        \ the title screen. Valid commander files for the
                        \ cassette version of Elite only have 0 for the first
                        \ byte, as there are no missions in this version, so
                        \ having bit 7 set is invalid anyway

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION

 BCS LOR                \ If the C flag is set then an invalid drive number was
                        \ entered during the call to QUS1 and the file wasn't
                        \ loaded, so jump to LOR to return from the subroutine

 LDA &0B00              \ If the first byte of the loaded file has bit 7 set,
 BMI ELT2F              \ jump to ELT2F, as this is an invalid commander file
                        \
                        \ ELT2F contains a BRK instruction, which will force an
                        \ interrupt to call the address in BRKV, which will
                        \ print out the system error at ELT2F

ELIF _MASTER_VERSION

 LDA TAP%               \ If the first byte of the loaded file has bit 7 set,
 BMI ELT2F              \ jump to ELT2F, as this is an invalid commander file
                        \
                        \ ELT2F contains a BRK instruction, which will force an
                        \ interrupt to call the address in BRKV, which will
                        \ print out the system error at ELT2F

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDX #NT%               \ We have successfully loaded the commander file at
                        \ &0B00, so now we want to copy it to the last saved
                        \ commander data block at NA%+8, so we set up a counter
                        \ in X to copy NT% bytes

ELIF _MASTER_VERSION

 LDY #NT%               \ We have successfully loaded the commander file to the
                        \ TAP% staging area, so now we want to copy it to the
                        \ last saved commander data block at NA%+8, so we set up
                        \ a counter in Y to copy NT% bytes

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

.LOL1

 LDA &0B00,X            \ Copy the X-th byte of &0B00 to the X-th byte of NA%+8
 STA NA%+8,X

 DEX                    \ Decrement the loop counter

 BPL LOL1               \ Loop back until we have copied all NT% bytes

ELIF _ELECTRON_VERSION

.LOL1

 LDA &0900,X            \ Copy the X-th byte of &0900 to the X-th byte of NA%+8
 STA NA%+8,X

 DEX                    \ Decrement the loop counter

 BPL LOL1               \ Loop back until we have copied all NT% bytes

ELIF _MASTER_VERSION

.copyme

 LDA TAP%,Y             \ Copy the Y-th byte of TAP% to the Y-th byte of NA%+8
 STA NA%+8,Y

 DEY                    \ Decrement the loop counter

 BPL copyme             \ Loop back until we have copied all NT% bytes

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDX #3                 \ Fall through into FX200 to disable the ESCAPE key and
                        \ clear memory if the BREAK key is pressed (*FX 200,3)
                        \ and return from the subroutine there

ELIF _6502SP_VERSION OR _DISC_DOCKED

.LOR

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

.ELT2F

 BRK                    \ The error that is printed if we try to load an
 EQUB &49               \ invalid commander file with bit 7 of byte #0 set
 EQUS "Illegal "        \ (&49 is the error number)
 EQUS "ELITE II file"
 BRK

ELIF _MASTER_VERSION

.LOR

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

.ELT2F

 LDA #9                 \ Print extended token 9 ("{cr}{all caps}ILLEGAL ELITE
 JSR DETOK              \ II FILE{sentence case}")

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JMP SVE                \ Jump to SVE to display the disc access menu and return
                        \ from the subroutine using a tail call

.backtonormal

 RTS                    \ Return from the subroutine

.CLDELAY

 RTS                    \ This instruction has no effect as we already returned
                        \ from the subroutine

ELIF _ELITE_A_DOCKED

.LOR

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

.ELT2F

 BRK                    \ The error that is printed if we try to load an
 EQUB &49               \ invalid commander file with bit 7 of byte #0 set
 EQUS "Not ELITE III "  \ (&49 is the error number)
 EQUS "file"
 BRK

ELIF _ELITE_A_6502SP_PARA

.LOR

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

.ELT2F

 BRK                    \ The error that is printed if we try to load an
 EQUB &49               \ invalid commander file with bit 7 of byte #0 set
 EQUS "Bad ELITE III "  \ (&49 is the error number)
 EQUS "file"
 BRK

ENDIF

IF _6502SP_VERSION \ Comment

\.MINI                  \ These instructions are commented out in the original
\EQUS "L.E.MINING B00"  \ source, and form part of the commented section above
\EQUB 13

ENDIF

