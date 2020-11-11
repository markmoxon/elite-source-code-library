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
\ ******************************************************************************

.hyp

IF _CASSETTE_VERSION

 LDA QQ12               \ If we are docked (QQ12 = &FF) then jump to hy6 to
 BNE hy6                \ print an error message and return from the subroutine
                        \ using a tail call (as we can't hyperspace when docked)

ELIF _6502SP_VERSION

 LDA QQ12               \ If we are docked (QQ12 = &FF) then jump to dockEd to
 BNE dockEd             \ print an error message and return from the subroutine
                        \ using a tail call (as we can't hyperspace when docked)

ENDIF

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

IF _CASSETTE_VERSION

 BNE zZ+1               \ If it is non-zero, return from the subroutine (as zZ+1
                        \ contains an RTS), as there is already a countdown in
                        \ progress

ELIF _6502SP_VERSION

 BEQ P%+3
 RTS
 LDA #CYAN
 JSR DOCOL

ENDIF

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed

 BMI Ghy                \ If it is, then the galactic hyperdrive has been
                        \ activated, so jump to Ghy to process it

IF _CASSETTE_VERSION

 JSR hm                 \ Set the system closest to galactic coordinates (QQ9,
                        \ QQ10) as the selected system

 LDA QQ8                \ If both bytes of the distance to the selected system
 ORA QQ8+1              \ in QQ8 are zero, return from the subroutine (as zZ+1
 BEQ zZ+1               \ contains an RTS), as the selected system is the
                        \ current system

 LDA #7                 \ Move the text cursor to column 7, row 23 (in the
 STA XC                 \ middle of the bottom text row)
 LDA #23
 STA YC

ELIF _6502SP_VERSION

 LDA QQ11
 BEQ TTX110
 AND #192
 BNE P%+3
 RTS \< = Ian = >
 JSR hm

.^TTX111

 LDA QQ8
 ORA QQ8+1
 BNE P%+3
 RTS
 LDX #5

.sob

 LDA QQ15,X
 STA safehouse,X
 DEX
 BPL sob

 LDA #7                 \ Move the text cursor to column 7, row 23 (in the
 JSR DOXC               \ middle of the bottom text row)
 LDA #23
 JSR DOYC

ENDIF

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

 LDA #189               \ Print recursive token 29 ("HYPERSPACE ")
 JSR TT27

IF _CASSETTE_VERSION

 LDA QQ8+1              \ If the high byte of the distance to the selected
 BNE TT147              \ system in QQ8 is > 0, then it is definitely too far to
                        \ jump (as our maximum range is 7.0 light years, or a
                        \ value of 70 in QQ8(1 0), so jump to TT147 to print
                        \ "RANGE?" and return from the subroutine using a tail
                        \ call

 LDA QQ14               \ Fetch our current fuel level from Q114 into A

 CMP QQ8                \ If our fuel reserves are less than the distance to the
 BCC TT147              \ selected system, then we don't have enough fuel for
                        \ this jump, so jump to TT147 to print "RANGE?" and
                        \ return from the subroutine using a tail call

ELIF _6502SP_VERSION

 LDA QQ8+1
 BNE goTT147

 LDA QQ14
 CMP QQ8
 BCS P%+5

.goTT147

 JMP TT147

ENDIF

 LDA #'-'               \ Print a hyphen
 JSR TT27

 JSR cpl                \ Call cpl to print the name of the selected system

                        \ Fall through into wW to start the hyperspace
                        \ countdown

