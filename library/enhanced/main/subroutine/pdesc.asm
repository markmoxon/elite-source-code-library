\ ******************************************************************************
\
\       Name: PDESC
\       Type: Subroutine
\   Category: Universe
\    Summary: Print the system's extended description or a mission 1 directive
\  Deep dive: Extended system descriptions
\             Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This prints a specific system's extended description. This is called the "pink
\ volcanoes string" in a comment in the original source, and the "goat soup"
\ recipe by Ian Bell on his website (where he also refers to the species string
\ as the "pink felines" string).
\
\ For some special systems, when you are docked at them, the procedurally
\ generated extended description is overridden and a text token from the RUTOK
\ table is shown instead. If mission 1 is in progress, then a number of systems
\ along the route of that mission's story will show custom mission-related
\ directives in place of that system's normal "goat soup" phrase.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF NOT(_NES_VERSION)
\   ZZ                  The system number (0-255)
ELIF _NES_VERSION
\   systemNumber        The system number (0-255)
ENDIF
\
IF _ELITE_A_ENCYCLOPEDIA
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   PD1                 Print the standard "goat soup" description without
\                       checking for overrides
\
ENDIF
\ ******************************************************************************

.PDESC

IF NOT(_ELITE_A_ENCYCLOPEDIA)

 LDA QQ8                \ If either byte in QQ18(1 0) is non-zero, meaning that
 ORA QQ8+1              \ the distance from the current system to the selected
 BNE PD1                \ is non-zero, jump to PD1 to show the standard "goat
                        \ soup" description

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 LDA QQ12               \ If QQ12 does not have bit 7 set, which means we are
 BPL PD1                \ not docked, jump to PD1 to show the standard "goat
                        \ soup" description

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)

                        \ If we get here, then the current system is the same as
                        \ the selected system and we are docked, so now to check
                        \ whether there is a special override token for this
                        \ system

 LDY #NRU%              \ Set Y as a loop counter as we work our way through the
                        \ system numbers in RUPLA, starting at NRU% (which is
                        \ the number of entries in RUPLA, 26) and working our
                        \ way down to 1

.PDL1

 LDA RUPLA-1,Y          \ Fetch the Y-th byte from RUPLA-1 into A (we use
                        \ RUPLA-1 because Y is looping from 26 to 1)

 CMP ZZ                 \ If A doesn't match the system whose description we
 BNE PD2                \ are printing (in ZZ), jump to PD2 to keep looping
                        \ through the system numbers in RUPLA

                        \ If we get here we have found a match for this system
                        \ number in RUPLA

 LDA RUGAL-1,Y          \ Fetch the Y-th byte from RUGAL-1 into A

 AND #%01111111         \ Extract bits 0-6 of A

 CMP GCNT               \ If the result does not equal the current galaxy
 BNE PD2                \ number, jump to PD2 to keep looping through the system
                        \ numbers in RUPLA

 LDA RUGAL-1,Y          \ Fetch the Y-th byte from RUGAL-1 into A, once again

 BMI PD3                \ If bit 7 is set, jump to PD3 to print the extended
                        \ token in A from the second table in RUTOK

ELIF _NES_VERSION

 LDX languageIndex      \ Set X to the index of the chosen language

 LDA ruplaLo,X          \ Set SC(1 0) to the address of the RUPLA table for the
 STA SC                 \ chosen language, minus 1 (i.e. RUPLA-1, RUPLA_DE-1
 LDA ruplaHi,X          \ or RUPLA_FR-1)
 STA SC+1

 LDA rugalLo,X          \ Set SC2(1 0) to the address of the RUGAL table for the
 STA SC2                \ chosen language, minus 1 (i.e. RUGAL-1, RUGAL_DE-1
 LDA rugalHi,X          \ or RUGAL_FR-1)
 STA SC2+1

 LDY NRU,X              \ Set Y as a loop counter as we work our way through the
                        \ system numbers in RUPLA, starting at the value of NRU
                        \ for the chosen language (which is the number of
                        \ entries in RUPLA) and working our way down to 1

.PDL1

 LDA (SC),Y             \ Fetch the Y-th byte from RUPLA-1 into A (we use
                        \ RUPLA-1 because Y is looping from NRU to 1)

 CMP systemNumber       \ If A doesn't match the system whose description we
 BNE PD2                \ are printing (in systemNumber), jump to PD2 to keep
                        \ looping through the system numbers in RUPLA

                        \ If we get here we have found a match for this system
                        \ number in RUPLA

 LDA (SC2),Y            \ Fetch the Y-th byte from RUGAL-1 into A

 AND #%01111111         \ Extract bits 0-6 of A

 CMP GCNT               \ If the result does not equal the current galaxy
 BNE PD2                \ number, jump to PD2 to keep looping through the system
                        \ numbers in RUPLA

 LDA (SC2),Y            \ Fetch the Y-th byte from RUGAL-1 into A, once again

 BMI PD3                \ If bit 7 is set, jump to PD3 to print the extended
                        \ token in A from the second table in RUTOK

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)

 LDA TP                 \ Fetch bit 0 of TP into the C flag, and skip to PD1 if
 LSR A                  \ it is clear (i.e. if mission 1 is not in progress) to
 BCC PD1                \ print the "goat soup" extended description

                        \ If we get here then mission 1 is in progress, so we
                        \ print out the corresponding token from RUTOK

 JSR MT14               \ Call MT14 to switch to justified text

 LDA #1                 \ Set A = 1 so that extended token 1 (an empty string)
                        \ gets printed below instead of token 176, followed by
                        \ the Y-th token in RUTOK

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &B0, or BIT &B0A9, which does nothing apart
                        \ from affect the flags

.PD3

 LDA #176               \ Print extended token 176 ("{lower case}{justify}
 JSR DETOK2             \ {single cap}")

 TYA                    \ Print the extended token in Y from the second table
 JSR DETOK3             \ in RUTOK

 LDA #177               \ Set A = 177 so when we jump to PD4 in the next
                        \ instruction, we print token 177 (".{cr}{left align}")

 BNE PD4                \ Jump to PD4 to print the extended token in A and
                        \ return from the subroutine using a tail call

.PD2

 DEY                    \ Decrement the byte counter in Y

 BNE PDL1               \ Loop back to check the next byte in RUPLA until we
                        \ either find a match for the system in ZZ, or we fall
                        \ through into the "goat soup" extended description
                        \ routine

ENDIF

.PD1

                        \ We now print the "goat soup" extended description

 LDX #3                 \ We now want to seed the random number generator with
                        \ the s1 and s2 16-bit seeds from the current system, so
                        \ we get the same extended description for each system
                        \ every time we call PDESC, so set a counter in X for
                        \ copying 4 bytes

.PDL1x                  \ This label is a duplicate of the label above
                        \
                        \ In the original source this label is PDL1, but
                        \ because BeebAsm doesn't allow us to redefine labels,
                        \ I have renamed it to PDL1x

 LDA QQ15+2,X           \ Copy QQ15+2 to QQ15+5 (s1 and s2) to RAND to RAND+3
 STA RAND,X

 DEX                    \ Decrement the loop counter

 BPL PDL1x              \ Loop back to PDL1x until we have copied all

 LDA #5                 \ Set A = 5, so we print extended token 5 in the next
                        \ instruction ("{lower case}{justify}{single cap}[86-90]
                        \ IS [140-144].{cr}{left align}"

.PD4

 JMP DETOK              \ Print the extended token given in A, and return from
                        \ the subroutine using a tail call

