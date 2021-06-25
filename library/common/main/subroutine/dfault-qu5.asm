\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\       Name: QU5
ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION
\       Name: DFAULT
ENDIF
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset the current commander data block to the last saved commander
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

.QU5

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION

.DFAULT

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

                        \ By the time we get here, the correct commander name
                        \ is at NA% and the correct commander data is at NA%+8.
                        \ Specifically:
                        \
                        \   * If we loaded a commander file, then the name and
                        \     data from that file will be at NA% and NA%+8
                        \
                        \   * If this is a brand new game, then NA% will contain
                        \     the default starting commander name ("JAMESON")
                        \     and NA%+8 will contain the default commander data
                        \
                        \   * If this is not a new game (because they died or
                        \     quit) and we didn't want to load a commander file,
                        \     then NA% will contain the last saved commander
                        \     name, and NA%+8 the last saved commander data. If
                        \     the game has never been saved, this will still be
                        \     the default commander

ENDIF

IF _CASSETTE_VERSION \ Comment

\JSR TTX66              \ This instruction is commented out in the original
                        \ source; it clears the screen and draws a border

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDX #NT%               \ The size of the commander data block is NT% bytes,
                        \ and it starts at NA%+8, so we need to copy the data
                        \ from the "last saved" buffer at NA%+8 to the current
                        \ commander workspace at TP. So we set up a counter in X
                        \ for the NT% bytes that we want to copy

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDX #NT%+8             \ The size of the last saved commander data block is NT%
                        \ bytes, and it is preceded by the 8 bytes of the
                        \ commander name (seven characters plus a carriage
                        \ return). The commander data block at NAME is followed
                        \ by the commander data block, so we need to copy the
                        \ name and data from the "last saved" buffer at NA% to
                        \ the current commander workspace at NAME. So we set up
                        \ a counter in X for the NT% + 8 bytes that we want to
                        \ copy

ENDIF

.QUL1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDA NA%+7,X            \ Copy the X-th byte of NA%+7 to the X-th byte of TP-1,
 STA TP-1,X             \ (the -1 is because X is counting down from NT% to 1)

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA NA%-1,X            \ Copy the X-th byte of NA%-1 to the X-th byte of
 STA NAME-1,X           \ NAME-1 (the -1 is because X is counting down from
                        \ NT% + 8 to 1)

ENDIF

 DEX                    \ Decrement the loop counter

 BNE QUL1               \ Loop back for the next byte of the commander data
                        \ block

 STX QQ11               \ X is 0 by the end of the above loop, so this sets QQ11
                        \ to 0, which means we will be showing a view without a
                        \ boxed title at the top (i.e. we're going to use the
                        \ screen layout of a space view in the following)

                        \ If the commander check below fails, we keep jumping
                        \ back to here to crash the game with an infinite loop

IF _ELITE_A_6502SP_PARA

 JSR update_pod         \ AJD

ENDIF

 JSR CHECK              \ Call the CHECK subroutine to calculate the checksum
                        \ for the current commander block at NA%+8 and put it
                        \ in A

 CMP CHK                \ Test the calculated checksum against CHK

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, then ignore the result
 NOP                    \ of the comparison and fall through into the next part

ELSE

 BNE P%-6               \ If the calculated checksum does not match CHK, then
                        \ loop back to repeat the check - in other words, we
                        \ enter an infinite loop here, as the checksum routine
                        \ will keep returning the same incorrect value

ENDIF

IF _6502SP_VERSION \ Comment

\JSR BELL               \ This instruction is commented out in the original
                        \ source. It would make a standard system beep

ENDIF

IF NOT(_ELITE_A_VERSION)

                        \ The checksum CHK is correct, so now we check whether
                        \ CHK2 = CHK EOR A9, and if this check fails, bit 7 of
                        \ the competition flags at COK gets set, to indicate
                        \ to Acornsoft via the competition code that there has
                        \ been some hacking going on with this competition entry

 EOR #&A9               \ X = checksum EOR &A9
 TAX

 LDA COK                \ Set A to the competition flags in COK

 CPX CHK2               \ If X = CHK2, then skip the next instruction
 BEQ tZ

 ORA #%10000000         \ Set bit 7 of A to indicate this commander file has
                        \ been tampered with

.tZ

ENDIF

IF _CASSETTE_VERSION \ Standard: When you save a commander file, the version details get saved along with the competition flags. The flags get set as follows: the cassette version sets bit 1, the disc version sets bit 2 or 5 depending on the release, the 6502SP version sets bit 2, and the Electron and Master versions set bit 3

 ORA #%00000010         \ Set bit 1 of A to denote that this is the cassette
                        \ version

ELIF _ELECTRON_VERSION

 ORA #%00001000         \ Set bit 3 of A to denote that this is the Electron
                        \ version

ELIF _DISC_DOCKED

IF _STH_DISC

 ORA #%00100000         \ Set bit 5 of A to denote that this is the disc version
                        \ with the refund bug fixed (in versions before the bug
                        \ was fixed, bit 2 is set)

ELIF _IB_DISC

 ORA #%00000100         \ Set bit 2 of A to denote that this is the disc version
                        \ but before the refund bug was fixed (in versions after
                        \ the bug was fixed, bit 5 is set)

ENDIF

ELIF _6502SP_VERSION

 ORA #%00000100         \ Set bit 2 of A to denote that this is the 6502 second
                        \ processor version (which is the same bit as for the
                        \ original disc version, before the refund bug was
                        \ fixed)

ELIF _MASTER_VERSION

 ORA #%00001000         \ Set bit 3 of A to denote that this is the Master
                        \ version

ENDIF

IF NOT(_ELITE_A_VERSION)

 STA COK                \ Store the updated competition flags in COK

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION \ Minor

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_VERSION

 JMP n_load             \ AJD load ship details

ENDIF

