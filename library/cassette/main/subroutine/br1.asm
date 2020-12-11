\ ******************************************************************************
\
\       Name: BR1
\       Type: Subroutine
\   Category: Start and end
\    Summary: Restart the game
\
\ ------------------------------------------------------------------------------
\
\ BRKV is set to point to BR1 by elite-loader.asm.
\
\ ******************************************************************************

.BR1

 LDX #3                 \ Set XC = 3 (set text cursor to column 3)
 STX XC

 JSR FX200              \ Disable the ESCAPE key and clear memory if the BREAK
                        \ key is pressed (*FX 200, 3)

 LDX #CYL               \ Call the TITLE subroutine to show the rotating ship
 LDA #128               \ and load prompt. The arguments sent to TITLE are:
 JSR TITLE              \
                        \   X = type of ship to show, #CYL is a Cobra Mk III
                        \
                        \   A = text token to show below the rotating ship, 128
                        \       is "  LOAD NEW COMMANDER (Y/N)?{crlf}{crlf}"
                        \
                        \ The TITLE subroutine returns with the internal number
                        \ of the key pressed in A (see p.142 of the Advanced
                        \ User Guide for a list of internal key number)

 CMP #&44               \ Did we press "Y"? If not, jump to QU5, otherwise
 BNE QU5                \ continue on to load a new commander

\BR1                    \ These instructions are commented out in the original
\LDX #3                 \ source. This block starts with the same *FX call as
\STX XC                 \ above, then clears the screen, calls a routine to
\JSR FX200              \ flush the keyboard buffer (FLKB) that isn't present
\LDA #1                 \ in the cassette version but is in other versions,
\JSR TT66               \ and then it displays "LOAD NEW COMMANDER (Y/N)?" and
\JSR FLKB               \ lists the current cargo, before falling straight into
\LDA #14                \ the load routine below, whether or not we have
\JSR TT214              \ pressed "Y". This may be a bit of testing code, as the
\BCC QU5                \ first line is a commented label, BR1, which is where
                        \ BRKV points, so when this is uncommented, pressing
                        \ the BREAK key should jump straight to the load screen

 JSR GTNME              \ We want to load a new commander, so we need to get
                        \ the commander name to load

 JSR LOD                \ We then call the LOD subroutine to load the commander
                        \ file to address NA%+8, which is where we store the
                        \ commander save file

 JSR TRNME              \ Once loaded, we copy the commander name to NA%

 JSR TTX66              \ And we clear the top part of the screen and draw a
                        \ white border

.QU5

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

\JSR TTX66              \ This instruction is commented out in the original
                        \ source; it clears the screen and draws a border

 LDX #NT%               \ The size of the commander data block is NT% bytes,
                        \ and it starts at NA%+8, so we need to copy the data
                        \ from the "last saved" buffer at NA%+8 to the current
                        \ commander workspace at TP. So we set up a counter in X
                        \ for the NT% bytes that we want to copy

.QUL1

 LDA NA%+7,X            \ Copy the X-th byte of NA%+7 to the X-th byte of TP-1,
 STA TP-1,X             \ (the -1 is because X is counting down from NT% to 1)

 DEX                    \ Decrement the loop counter

 BNE QUL1               \ Loop back for the next byte of the commander data
                        \ block

 STX QQ11               \ X is 0 by the end of the above loop, so this sets QQ11
                        \ to 0, which means we will be showing a view without a
                        \ boxed title at the top (i.e. we're going to use the
                        \ screen layout of a space view in the following)

                        \ If the commander check below fails, we keep jumping
                        \ back to here to crash the game with an infinite loop

 JSR CHECK              \ Call the CHECK subroutine to calculate the checksum
                        \ for the current commander block at NA%+8 and put it
                        \ in A

 CMP CHK                \ Test the calculated checksum against CHK

IF _REMOVE_COMMANDER_CHECK

 NOP                    \ If we have disabled the commander check, then ignore
 NOP                    \ the checksum and fall through into the next part

ELSE

 BNE P%-6               \ If commander check is enabled and the calculated
                        \ checksum does not match CHK, then loop back to repeat
                        \ the check - in other words, we enter an infinite loop
                        \ here, as the checksum routine will keep returning the
                        \ same incorrect value

ENDIF

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

 ORA #2                 \ Set bit 1 of A to denote this is the cassette version

 STA COK                \ Store the updated competition flags in COK

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted

 LDA #147               \ Call the TITLE subroutine to show the rotating ship
 LDX #3                 \ and fire/space prompt. The arguments sent to TITLE
 JSR TITLE              \ are:
                        \
                        \   X = type of ship to show, #3 is a Mamba
                        \
                        \   A = text token to show below the rotating ship, 147
                        \       is "PRESS FIRE OR SPACE,COMMANDER.{crlf}{crlf}"

 JSR ping               \ Set the target system coordinates (QQ9, QQ10) to the
                        \ current system coordinates (QQ0, QQ1) we just loaded

 JSR hyp1               \ Arrive in the system closest to (QQ9, QQ10) and then
                        \ and then fall through into the docking bay routine
                        \ below

