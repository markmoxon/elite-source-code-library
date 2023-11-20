\ ******************************************************************************
\
\       Name: DK4
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for pause, configuration and secondary flight keys
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Scan for pause and configuration keys, and if this is a space view, also scan
\ for secondary flight controls.
\
\ Specifically:
\
\   * Scan for the pause button (COPY) and if it's pressed, pause the game and
\     process any configuration key presses until the game is unpaused (DELETE)
\
\   * If this is a space view, scan for secondary flight keys and update the
\     relevant bytes in the key logger
\
IF _6502SP_VERSION \ Comment
\ Other entry points:
\
\   FREEZE              Rejoin the pause routine after processing a screen save
\
ELIF _DISC_DOCKED
\ Other entry points:
\
\   DK9                 Set the Bitstik configuration option to the value in A
\
ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT
\ Other entry points:
\
\   DK5                 Contains an RTS
\
ENDIF
\ ******************************************************************************

.DK4

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

ELIF _6502SP_VERSION

 LDX KTRAN              \ Fetch the internal key number of the current key
                        \ press from the key logger buffer

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 STX KL                 \ Store X in KL, byte #0 of the key logger

 CPX #&69               \ If COPY is not being pressed, jump to DK2 below,
 BNE DK2                \ otherwise let's process the configuration keys

ELIF _ELECTRON_VERSION

 STX KL                 \ Store X in KL, byte #0 of the key logger

 CPX #&38               \ If COPY is not being pressed, jump to DK2 below,
 BNE DK2                \ otherwise let's process the configuration keys

ELIF _MASTER_VERSION

 LDX KL                 \ Fetch the key pressed from byte #0 of the key logger

 CPX #&8B               \ If COPY is not being pressed, jump to DK2 below,
 BNE DK2                \ otherwise let's process the configuration keys

ENDIF

.FREEZE

                        \ COPY is being pressed, so we enter a loop that
                        \ listens for configuration keys, and we keep looping
                        \ until we detect a DELETE key press. This effectively
                        \ pauses the game when COPY is pressed, and unpauses
                        \ it when DELETE is pressed

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn

ELIF _ELECTRON_VERSION

 JSR DEL8               \ Call DEL8 to wait for 30 delay loops

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

ELIF _MASTER_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ ASCII code of the key pressed in X (or 0 for no key
                        \ press)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 CPX #&51               \ If "S" is not being pressed, skip to DK6
 BNE DK6

 LDA #0                 \ "S" is being pressed, so set DNOIZ to 0 to turn the
 STA DNOIZ              \ sound on

ELIF _MASTER_VERSION

 CPX #'Q'               \ If "Q" is not being pressed, skip to DK6
 BNE DK6

 LDX #&FF               \ "Q" is being pressed, so set DNOIZ to &FF to turn the
 STX DNOIZ              \ sound off

 LDX #&51               \ Set X to &51, which is the internal key for "S" on the
                        \ BBC Micro. This is set to ensure that X has the same
                        \ value at this point as the BBC Micro version of this
                        \ routine would

ENDIF

.DK6

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDY #&40               \ We now want to loop through the keys that toggle
                        \ various settings. These have internal key numbers
                        \ between &40 (CAPS LOCK) and &46 ("K"), so we set up
                        \ the first key number in Y to act as a loop counter.
                        \ See subroutine DKS3 for more details on this

ELIF _MASTER_VERSION

 LDY #0                 \ We now want to loop through the keys that toggle
                        \ various settings, so set a counter in Y to work our
                        \ way through them

ENDIF

.DKL4

 JSR DKS3               \ Call DKS3 to scan for the key given in Y, and toggle
                        \ the relevant setting if it is pressed

 INY                    \ Increment Y to point to the next toggle key

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ 6502SP: The Executive version supports two new configuration keys when paused: "@" toggles infinite jump range, while ":" toggles speech

 CPY #&47               \ The last toggle key is &46 (K), so check whether we
                        \ have just done that one

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 CPY #&47               \ The last toggle key is &46 (K), so check whether we
                        \ have just done that one

ELIF _EXECUTIVE

 CPY #&49               \ The last toggle key is &48 (:), so check whether we
                        \ have just done that one

ENDIF

ELIF _MASTER_VERSION

 CPY #9                 \ Check to see whether we have reached the last toggle
                        \ key

ELIF _ELITE_A_VERSION

 CPY #&48               \ The last toggle key is &47 (@), so check whether we
                        \ have just done that one

ENDIF

 BNE DKL4               \ If not, loop back to check for the next toggle key

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

.DK55

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 CPX #&10               \ If "Q" is not being pressed, skip to DK7
 BNE DK7

 STX DNOIZ              \ "Q" is being pressed, so set DNOIZ to X, which is
                        \ non-zero (&10), so this will turn the sound off

.DK7

 CPX #&70               \ If ESCAPE is not being pressed, skip over the next
 BNE P%+5               \ instruction

ENDIF

IF _MASTER_VERSION \ Master: The Master version allows you to change the volume of the sound effects using the "<" and ">" keys when the game is paused

 LDA VOL                \ Fetch the current volume setting into A

 CPX #'.'               \ If "." is being pressed (i.e. the ">" key) then jump
 BEQ DOVOL1             \ to DOVOL1 to increase the volume

 CPX #','               \ If "," is not being pressed (i.e. the "<" key) then
 BNE DOVOL4             \ jump to DOVOL4 to skip the following

 DEC A                  \ The volume down key is being pressed, so decrement the
                        \ volume level in A

 EQUB &24               \ Skip the next instruction by turning it into &24 &1A,
                        \ or BIT &001A, which does nothing apart from affect the
                        \ flags

.DOVOL1

 INC A                  \ The volume up key is being pressed, so increment the
                        \ volume level in A

 TAY                    \ Copy the new volume level to Y

 AND #%11111000         \ If any of bits 3-7 are set, skip to DOVOL3 as we have
 BNE DOVOL3             \ either increased the volume past the maximum volume of
                        \ 7, or we have decreased it below 0 to -1, and in
                        \ neither case do we want to change the volume as we are
                        \ already at the maximum or minimum level

 STY VOL                \ Store the new volume level in VOL

.DOVOL3

 PHX                    \ Store X on the stack so we can retrieve it below after
                        \ making a beep

 JSR BEEP               \ Call the BEEP subroutine to make a short, high beep at
                        \ the new volume level

 LDY #10                \ Wait for 10/50 of a second (0.2 seconds)
 JSR DELAY

 PLX                    \ Restore the value of X we stored above

.DOVOL4

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Minor

 JMP DEATH2             \ ESCAPE is being pressed, so jump to DEATH2 to end
                        \ the game

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 JMP BR1                \ ESCAPE is being pressed, so jump to BR1 to end the
                        \ game

ELIF _ELITE_A_ENCYCLOPEDIA

 JMP escape             \ ESCAPE is being pressed, so jump to escape to end
                        \ the game

ENDIF

IF _DISC_VERSION OR _6502SP_VERSION \ Platform

 CPX #&64               \ If "B" is not being pressed, skip to nobit
 BNE nobit

ELIF _MASTER_VERSION

 CPX #'B'               \ If "B" is not being pressed, skip to DOVOL2
 BNE DOVOL2

ENDIF

IF _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Enhanced: The enhanced versions support a new Bitstik configuration option, "B", which toggles the Bitstik when the game is paused

 LDA BSTK               \ Toggle the value of BSTK between 0 and &FF
 EOR #&FF
 STA BSTK

 STA JSTK               \ Configure JSTK to the same value, so when the Bitstik
                        \ is enabled, so is the joystick

 STA JSTE               \ Configure JSTE to the same value, so when the Bitstik
                        \ is enabled, the joystick is configured with reversed
                        \ channels

ENDIF

IF _MASTER_VERSION \ Master: The Master version makes two beeps when the Bitstik is configured, while the disc and 6502SP versions remain totally silent and give no clue as to whether you just turned the Bitstik on or off

 BPL P%+5               \ If we just toggled the Bitstik off (i.e. to 0, which
                        \ is positive), then skip the following two instructions

 JSR BELL               \ We just enabled the Bitstik, so give two standard
 JSR BELL               \ system beeps

ENDIF

IF _6502SP_VERSION OR _DISC_VERSION \ Label

.nobit

ELIF _MASTER_VERSION

.DOVOL2

ENDIF

IF _6502SP_VERSION \ 6502SP: The 6502SP version lets you take screenshots, by pressing "D" when the game is paused

 CPX #&32               \ If "D" is being pressed, jump to savscr to save a
 BEQ savscr             \ screenshot

ENDIF

IF _MASTER_VERSION \ Platform

 CPX #'S'               \ If "S" is not being pressed, jump to DK7
 BNE DK7

 LDA #0                 \ "S" is being pressed, so set DNOIZ to 0 to turn the
 STA DNOIZ              \ sound on

.DK7

 CPX #&1B               \ If ESCAPE is not being pressed, skip over the next
 BNE P%+5               \ instruction

 JMP DEATH2             \ ESCAPE is being pressed, so jump to DEATH2 to end
                        \ the game

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 CPX #&59               \ If DELETE is not being pressed, we are still paused,
 BNE FREEZE             \ so loop back up to keep listening for configuration
                        \ keys, otherwise fall through into the rest of the
                        \ key detection code, which unpauses the game

ELIF _MASTER_VERSION

 CPX #&7F               \ If DELETE is not being pressed, we are still paused,
 BNE FREEZE             \ so loop back up to keep listening for configuration
                        \ keys, otherwise fall through into the rest of the
                        \ key detection code, which unpauses the game

ENDIF

.DK2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Minor

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE DK5                \ view), return from the subroutine (as DK5 contains
                        \ an RTS)

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE out                \ view), return from the subroutine (as out contains
                        \ an RTS)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: The key logger scans for an additional secondary flight key, "P", which disables the docking computer

 LDY #15                \ This is a space view, so now we want to check for all
                        \ the secondary flight keys. The internal key numbers
                        \ are in the keyboard table KYTB from KYTB+8 to
                        \ KYTB+15, and their key logger locations are from KL+8
                        \ to KL+15. So set a decreasing counter in Y for the
                        \ index, starting at 15, so we can loop through them

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION

 LDY #16                \ This is a space view, so now we want to check for all
                        \ the secondary flight keys. The internal key numbers
                        \ are in the keyboard table KYTB from KYTB+8 to
                        \ KYTB+16, and their key logger locations are from KL+8
                        \ to KL+16. So set a decreasing counter in Y for the
                        \ index, starting at 16, so we can loop through them

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION \ Platform

 LDA #&FF               \ Set A to &FF so we can store this in the keyboard
                        \ logger for keys that are being pressed

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

.DKL1

 LDX KYTB,Y             \ Get the internal key number of the Y-th flight key
                        \ the KYTB keyboard table

 CPX KL                 \ We stored the key that's being pressed in KL above,
                        \ so check to see if the Y-th flight key is being
                        \ pressed

 BNE DK1                \ If it is not being pressed, skip to DK1 below

 STA KL,Y               \ The Y-th flight key is being pressed, so set that
                        \ key's location in the key logger to &FF

.DK1

 DEY                    \ Decrement the loop counter

 CPY #7                 \ Have we just done the last key?

 BNE DKL1               \ If not, loop back to process the next key

ELIF _ELITE_A_FLIGHT

.DKL1

 JSR DKS1               \ Call DKS1 to see if the KYTB key at offset Y is being
                        \ pressed, and set the key logger accordingly

 DEY                    \ Decrement the loop counter

 CPY #7                 \ Have we just done the last key?

 BNE DKL1               \ If not, loop back to process the next key

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT \ Label

.DK5

ENDIF

 RTS                    \ Return from the subroutine

IF _DISC_DOCKED \ Platform

.DK9

 STA BSTK               \ DK9 is called from DOKEY using a BEQ, so we know A is
                        \ 0, so this disables the Bitstik and switched to
                        \ keyboard or joystick

 BEQ DK4                \ Jump back to DK4 in DOKEY (this BEQ is effectively a
                        \ JMP as A is always zero)

ENDIF

