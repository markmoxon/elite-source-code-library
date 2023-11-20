\ ******************************************************************************
\
\       Name: DKS1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for a flight key
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard for the flight key given in register Y, where Y is the
\ offset into the KYTB table above (so we can scan for Space by setting Y to
\ 2, for example). If the key is pressed, set the corresponding byte in the
\ key logger at KL to &FF.
\
\ Arguments:
\
\   Y                   The offset into the KYTB table above of the key that we
\                       want to scan on the keyboard
\
IF _ELITE_A_VERSION
\ Other entry points:
\
\   b_pressed           Store &FF in the Y-th byte of the key logger at KL, to
\                       indicate that key is being pressed
\
\   b_quit              Contains an RTS
\
ENDIF
\ ******************************************************************************

.DKS1

IF _ELITE_A_VERSION

 LDA BSTK               \ If BTSK is negative, then the Delta 14B joystick is
 BMI b_14               \ configured, so jump to b_14 to check the Delta 14B
                        \ joystick buttons

ENDIF

 LDX KYTB,Y             \ Get the internal key number from the Y-th byte of the
                        \ KYTB table above

 JSR DKS4               \ Call DKS4, which will set A and X to a negative value
                        \ if the key is being pressed

IF NOT(_ELITE_A_VERSION)

 BPL DKS2-1             \ The key is not being pressed, so return from the
                        \ subroutine (as DKS2-1 contains an RTS)

ELIF _ELITE_A_VERSION

 BPL b_quit             \ The key is not being pressed, so return from the
                        \ subroutine (as b_quit contains an RTS)

.b_pressed

ENDIF

IF _CASSETTE_VERSION \ Minor

 LDX #&FF               \ Store &FF in the Y-th byte of the key logger at KL
 STX KL,Y

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 LDA #&FF               \ Store &FF in the Y-th byte of the key logger at KL
 STA KL,Y

ENDIF

IF _ELITE_A_VERSION

.b_quit

ENDIF

 RTS                    \ Return from the subroutine

