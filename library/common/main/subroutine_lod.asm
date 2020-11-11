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
\ ******************************************************************************

.LOD

IF _CASSETTE_VERSION

 LDX #2                 \ Enable the Escape key and clear memory if the Break
 JSR FX200              \ key is pressed (*FX 200,2)

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

ELIF _6502SP_VERSION

\LDX#(MINI MOD256)
\LDY#(MINI DIV256)
\JSRSCLI
\JMPLOL1-2
\LDX#2
\JSRFX200

 JSR ZEBC

ENDIF

 LDY #&B                \ Set up an OSFILE block at &0C00, containing:
 STY &0C03              \
 INC &0C0B              \ Load address = &00000B00 in &0C02 to &0C05
                        \
                        \ Length of file = &00000100 in &0C0A to &0C0D

IF _CASSETTE_VERSION

 INY                    \ Increment Y to containing &C which we use next

ENDIF

 LDA #&FF               \ Call QUS1 with A = &FF, Y = &C to load the commander
 JSR QUS1               \ file at address &0B00

IF _CASSETTE_VERSION

 LDA &B00               \ If the first byte of the loaded file has bit 7 set,
 BMI SPS1+1             \ jump to SPS+1, which is the second byte of an LDA #0
                        \ instruction, i.e. a BRK instruction, which will force
                        \ an interrupt to call the address in BRKV, which is set
                        \ to BR1... so this instruction restarts the game from
                        \ the title screen. Valid commander files for the
                        \ cassette version of Elite only have 0 for the first
                        \ byte, while the disc version can have 0, 1, 2, &A or
                        \ &E, so having bit 7 set is invalid anyway


ELIF _6502SP_VERSION

 BCS LOR
 LDA &B00
 BMI ELT2F

ENDIF

 LDX #NT%               \ We have successfully loaded the commander file at
                        \ &0B00, so now we want to copy it to the last saved
                        \ commander data block at NA%+8, so we set up a counter
                        \ in X to copy NT% bytes

.LOL1

 LDA &B00,X             \ Copy the X-th byte of &0B00 to the X-th byte of NA%+8
 STA NA%+8,X

 DEX                    \ Decrement the loop counter

 BPL LOL1               \ Loop back until we have copied all NT% bytes

IF _CASSETTE_VERSION

 LDX #3                 \ Fall through into FX200 to disable the Escape key and
                        \ clear memory if the Break key is pressed (*FX 200,3)
                        \ and return from the subroutine there

ELIF _6502SP_VERSION

.^LOR

 SEC
 RTS

.ELT2F

 BRK
 EQUS "IIllegal ELITE II file"
 BRK
\.MINI \EQUS("L.E.MINING B00")\EQUB13

ENDIF

