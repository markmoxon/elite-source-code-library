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
ENDIF
\ ******************************************************************************

.DK4

IF _CASSETTE_VERSION OR _DISC_VERSION \ Tube

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

ELIF _6502SP_VERSION

 LDX KTRAN              \ Fetch the internal key number of the current key
                        \ press from the key logger buffer

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 STX KL                 \ Store X in KL, byte #0 of the key logger

 CPX #&69               \ If COPY is not being pressed, jump to DK2 below,
 BNE DK2                \ otherwise let's process the configuration keys

ELIF _MASTER_VERSION

 LDX KL                 \ ???
 CPX #&8B
 BNE DK2

ENDIF

.FREEZE

                        \ COPY is being pressed, so we enter a loop that
                        \ listens for configuration keys, and we keep looping
                        \ until we detect a DELETE key press. This effectively
                        \ pauses the game when COPY is pressed, and unpauses
                        \ it when DELETE is pressed

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

 CPX #&51               \ If S is not being pressed, skip to DK6
 BNE DK6

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 LDA #0                 \ S is being pressed, so set DNOIZ to 0 to turn the
 STA DNOIZ              \ sound on

ELIF _MASTER_VERSION

 LDX #&FF               \ ???
 STX L2C55
 LDX #&51

ENDIF

.DK6

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 LDY #&40               \ We now want to loop through the keys that toggle
                        \ various settings. These have internal key numbers
                        \ between &40 (CAPS LOCK) and &46 ("K"), so we set up
                        \ the first key number in Y to act as a loop counter.
                        \ See subroutine DKS3 for more details on this

ELIF _MASTER_VERSION

 LDY #0                 \ ???

ENDIF

.DKL4

 JSR DKS3               \ Call DKS3 to scan for the key given in Y, and toggle
                        \ the relevant setting if it is pressed

 INY                    \ Increment Y to point to the next toggle key

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 CPY #&47               \ The last toggle key is &46 (K), so check whether we
                        \ have just done that one

ELIF _MASTER_VERSION

 CPY #&09               \ ???

ENDIF

 BNE DKL4               \ If not, loop back to check for the next toggle key

IF _CASSETTE_VERSION OR _DISC_VERSION \ Label

.DK55

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 CPX #&10               \ If "Q" is not being pressed, skip to DK7
 BNE DK7

 STX DNOIZ              \ "Q" is being pressed, so set DNOIZ to X, which is
                        \ non-zero (&10), so this will turn the sound off

.DK7

 CPX #&70               \ If ESCAPE is not being pressed, skip over the next
 BNE P%+5               \ instruction

ELIF _MASTER_VERSION

 LDA L2C61              \ ???
 CPX #&2E
 BEQ L6D70

 CPX #&2C
 BNE L6D83

 DEC A
 EQUB &24

.L6D70

 INC A
 TAY
 AND #&F8
 BNE L6D79

 STY L2C61

.L6D79

 PHX
 JSR BEEP

 LDY #&0A
 JSR DELAY

 PLX

.L6D83

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Minor

 JMP DEATH2             \ ESCAPE is being pressed, so jump to DEATH2 to end
                        \ the game

ELIF _DISC_DOCKED

 JMP BR1                \ ESCAPE is being pressed, so jump to BR1 to end the
                        \ game

ENDIF

IF _DISC_VERSION OR _6502SP_VERSION

 CPX #&64               \ If "B" is not being pressed, skip to DK7
 BNE nobit

ELIF _MASTER_VERSION

 CPX #&42               \ ???
 BNE nobit

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

IF _MASTER_VERSION

 BPL L6D9A              \ ???

 JSR BELL

.L6D9A

 JSR BELL

ENDIF

IF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Label

.nobit

ENDIF

IF _6502SP_VERSION \ Advanced: The 6502SP lets you take screenshots, by pressing "D" when the game is paused

 CPX #&32               \ If "D" is being pressed, jump to savscr to save a
 BEQ savscr             \ screenshot

ENDIF

IF _MASTER_VERSION

 CPX #&53               \ ???
 BNE DK7

 LDA #&00
 STA L2C55

.DK7

 CPX #&1B
 BNE L6DAD

 JMP DEATH2

.L6DAD

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 CPX #&59               \ If DELETE is not being pressed, we are still paused,
 BNE FREEZE             \ so loop back up to keep listening for configuration
                        \ keys, otherwise fall through into the rest of the
                        \ key detection code, which unpauses the game

ELIF _MASTER_VERSION

 CPX #&7F               \ ???
 BNE FREEZE

ENDIF

.DK2

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Minor

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE DK5                \ view), return from the subroutine (as DK5 contains
                        \ an RTS)

ELIF _6502SP_VERSION OR _DISC_DOCKED

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE out                \ view), return from the subroutine (as out contains
                        \ an RTS)

ENDIF

IF _CASSETTE_VERSION \ Enhanced: The key logger scans for an additional secondary flight key, "P", which disables the docking computer

 LDY #15                \ This is a space view, so now we want to check for all
                        \ the secondary flight keys. The internal key numbers
                        \ are in the keyboard table KYTB from KYTB+8 to
                        \ KYTB+15, and their key logger locations are from KL+8
                        \ to KL+15. So set a decreasing counter in Y for the
                        \ index, starting at 15, so we can loop through them

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDY #16                \ This is a space view, so now we want to check for all
                        \ the secondary flight keys. The internal key numbers
                        \ are in the keyboard table KYTB from KYTB+8 to
                        \ KYTB+16, and their key logger locations are from KL+8
                        \ to KL+16. So set a decreasing counter in Y for the
                        \ index, starting at 16, so we can loop through them

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 LDA #&FF               \ Set A to &FF so we can store this in the keyboard
                        \ logger for keys that are being pressed

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

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

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Label

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

