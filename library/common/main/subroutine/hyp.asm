\ ******************************************************************************
\
\       Name: hyp
\       Type: Subroutine
\   Category: Flight
\    Summary: Start the hyperspace process
\
\ ------------------------------------------------------------------------------
\
\ Called when "H" or CTRL-H is pressed during flight. Checks the following:
\
\   * We are in space
\
\   * We are not already in a hyperspace countdown
\
\ If CTRL is being held down, we jump to Ghy to engage the galactic hyperdrive,
\ otherwise we check that:
\
\   * The selected system is not the current system
\
\   * We have enough fuel to make the jump
\
\ and if all the pre-jump checks are passed, we print the destination on-screen
\ and start the countdown.
\
IF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Comment
\ Other entry points:
\
\   TTX111              Used to rejoin this routine from the call to TTX110
\
ENDIF
\ ******************************************************************************

.hyp

IF _NES_VERSION

 LDA QQ12               \ ???
 BNE dockEd
 LDA QQ22+1
 BEQ Ghy
 RTS

.subm_9E51

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 LDA QQ12               \ If we are docked (QQ12 = &FF) then jump to hy6 to
 BNE hy6                \ print an error message and return from the subroutine
                        \ using a tail call (as we can't hyperspace when docked)

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA QQ12               \ If we are docked (QQ12 = &FF) then jump to dockEd to
 BNE dockEd             \ print an error message and return from the subroutine
                        \ using a tail call (as we can't hyperspace when docked)

ENDIF

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 BNE zZ+1               \ If it is non-zero, return from the subroutine (as zZ+1
                        \ contains an RTS), as there is already a countdown in
                        \ progress

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 ORA QQ12               \ If we are docked (QQ12 = &FF) or there is already a
 BNE zZ+1               \ countdown in progress, then return from the subroutine
                        \ using a tail call (as zZ+1 contains an RTS), as we
                        \ can't hyperspace when docked, or there is already a
                        \ countdown in progress

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION

 BEQ P%+3               \ If it is zero, skip the next instruction

 RTS                    \ The count is non-zero, so return from the subroutine

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ The count is zero, so send a #SETCOL CYAN command to
 JSR DOCOL              \ the I/O processor to switch to colour 3, which is cyan
                        \ in the space view

ELIF _MASTER_VERSION

 LDA #CYAN              \ The count is zero, so switch to colour 3, which is
 STA COL                \ cyan in the space view

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed

ELIF _MASTER_VERSION

IF _SNG47

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed

ELIF _COMPACT

 JSR CTRLmc             \ Scan the keyboard to see if CTRL is currently pressed

ENDIF

ELIF _ELECTRON_VERSION

 LDX #1                 \ Set X to the internal key number for CTRL

 JSR DKS4               \ Scan the keyboard to see if the key in X (i.e. CTRL)
                        \ is currently pressed

ENDIF

IF NOT(_NES_VERSION)

 BMI Ghy                \ If it is, then the galactic hyperdrive has been
                        \ activated, so jump to Ghy to process it

ELIF _NES_VERSION

 LDA selectedSystemFlag \ If bit 6 of selectedSystemFlag is set, then we can
 ASL A                  \ hyperspace to the currently selected system, so jump
 BMI hyps1              \ to hyps1 to skip the following instruction and keep
                        \ going

 RTS                    \ Bit 6 of selectedSystemFlag is clear, so we can't
                        \ hyperspace to the currently selected system (we may
                        \ not have enough fuel, or it might be the same as the
                        \ current system), so return from the subroutine

.hyps1

ENDIF

IF _DISC_FLIGHT \ Minor

 LDA QQ11               \ If the current view is 0 (i.e. the space view) then
 BNE P%+5               \ jump to TTX110, which calls TT111 to set the current
 JMP TTX110             \ system to the nearest system to (QQ9, QQ10), and jumps
                        \ back into this routine at TTX111 below

ELIF _DISC_DOCKED

 LDA QQ11               \ If the current view is 0 (i.e. the space view) then
 BEQ TTX110             \ jump to TTX110, which calls TT111 to set the current
                        \ system to the nearest system to (QQ9, QQ10), and jumps
                        \ back into this routine at TTX111 below

 AND #%11000000         \ If neither bit 6 nor 7 of the view number is set - so
 BEQ zZ+1               \ this is neither the Short-range or Long-range Chart -
                        \ then return from the subroutine (as zZ+1 contains an
                        \ RTS)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA QQ11               \ If the current view is 0 (i.e. the space view) then
 BEQ TTX110             \ jump to TTX110, which calls TT111 to set the current
                        \ system to the nearest system to (QQ9, QQ10), and jumps
                        \ back into this routine at TTX111 below

 AND #%11000000         \ If either bit 6 or 7 of the view number is set - so
 BNE P%+3               \ this is either the Short-range or Long-range Chart -
                        \ then skip the following instruction

 RTS                    \ This is not a chart view, so return from the
                        \ subroutine

ELIF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 LDA QQ11               \ If the current view is not 0 (i.e. not the space view)
 BNE P%+8               \ then skip the following two instructions

 JSR TT111              \ This is the space view, so select the system closest
                        \ to galactic coordinates (QQ9, QQ10)

 JMP TTX111             \ Skip the following instruction, as we don't want to
                        \ draw the crosshairs in the space view

ENDIF

IF NOT(_NES_VERSION)

 JSR hm                 \ This is a chart view, so call hm to redraw the chart
                        \ crosshairs

ENDIF

IF _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Label

.TTX111

                        \ If we get here then the current view is either the
                        \ space view or a chart

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 LDA QQ8                \ If both bytes of the distance to the selected system
 ORA QQ8+1              \ in QQ8 are zero, return from the subroutine (as zZ+1
 BEQ zZ+1               \ contains an RTS), as the selected system is the
                        \ current system

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA QQ8                \ If either byte of the distance to the selected system
 ORA QQ8+1              \ in QQ8 are zero, skip the next instruction to make a
 BNE P%+3               \ copy of the destination seeds in safehouse

 RTS                    \ The selected system is the same as the current system,
                        \ so return from the subroutine

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Other: Part of the bug fix for the "hyperspace when docking" bug (see below)

 LDX #5                 \ We now want to copy those seeds into safehouse, so we
                        \ so set a counter in X to copy 6 bytes

.sob

 LDA QQ15,X             \ Copy the X-th byte of QQ15 into the X-th byte of
 STA safehouse,X        \ safehouse

 DEX                    \ Decrement the loop counter

 BPL sob                \ Loop back to copy the next byte until we have copied
                        \ all six seed bytes

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Platform

 LDA #7                 \ Move the text cursor to column 7, row 23 (in the
 STA XC                 \ middle of the bottom text row)
 LDA #23
 STA YC

ELIF _DISC_DOCKED OR _MASTER_VERSION

 LDA #7                 \ Move the text cursor to column 7, row 22 (in the
 STA XC                 \ middle of the bottom text row)
 LDA #22
 STA YC

ELIF _6502SP_VERSION

 LDA #7                 \ Move the text cursor to column 7, row 23 (in the
 JSR DOXC               \ middle of the bottom text row)
 LDA #23
 JSR DOYC

ENDIF

IF NOT(_ELITE_A_FLIGHT OR _NES_VERSION)

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

ELIF _ELITE_A_FLIGHT

 JSR vdu_00             \ Call vdu_00 to switch to ALL CAPS

ENDIF

IF NOT(_NES_VERSION)

 LDA #189               \ Print recursive token 29 ("HYPERSPACE ")
 JSR TT27

ENDIF

IF _6502SP_VERSION \ 6502SP: If infinite jump range is enabled in the Executive version, you can jump to anywhere in the entire galaxy

IF _EXECUTIVE

 BIT JUMP               \ If infinite jump range is configured, then jump down
 BMI goTT147+3          \ to IJUMP so we do the jump whatever the distance

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 LDA QQ8+1              \ If the high byte of the distance to the selected
 BNE TT147              \ system in QQ8 is > 0, then it is definitely too far to
                        \ jump (as our maximum range is 7.0 light years, or a
                        \ value of 70 in QQ8(1 0)), so jump to TT147 to print
                        \ "RANGE?" and return from the subroutine using a tail
                        \ call

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA QQ8+1              \ If the high byte of the distance to the selected
 BNE goTT147            \ system in QQ8 is > 0, then it is definitely too far to
                        \ jump (as our maximum range is 7.0 light years, or a
                        \ value of 70 in QQ8(1 0)), so jump to TT147 via goTT147
                        \ to print "RANGE?" and return from the subroutine using
                        \ a tail call

ENDIF

IF NOT(_NES_VERSION)

 LDA QQ14               \ Fetch our current fuel level from Q114 into A

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 CMP QQ8                \ If our fuel reserves are less than the distance to the
 BCC TT147              \ selected system, then we don't have enough fuel for
                        \ this jump, so jump to TT147 to print "RANGE?" and
                        \ return from the subroutine using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CMP QQ8                \ If our fuel reserves are greater than or equal to the
 BCS P%+5               \ distance to the selected system, then we have enough
                        \ fuel for this jump, so skip the following instruction
                        \ to start the hyperspace countdown

.goTT147

 JMP TT147              \ We don't have enough fuel to reach the destination, so
                        \ jump to TT147 to print "RANGE?" and return from the
                        \ subroutine using a tail call

ENDIF

IF NOT(_NES_VERSION)

 LDA #'-'               \ Print a hyphen
 JSR TT27

 JSR cpl                \ Call cpl to print the name of the selected system

                        \ Fall through into wW to start the hyperspace countdown

ENDIF

