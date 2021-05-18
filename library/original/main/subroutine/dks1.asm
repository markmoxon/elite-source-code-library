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
\ ******************************************************************************

.DKS1

 LDX KYTB,Y             \ Get the internal key number from the Y-th byte of the
                        \ KYTB table above

 JSR DKS4               \ Call DKS4, which will set A and X to a negative value
                        \ if the key is being pressed

 BPL DKS2-1             \ The key is not being pressed, so return from the
                        \ subroutine (as DKS2-1 contains an RTS)

IF _CASSETTE_VERSION \ Minor

 LDX #&FF               \ Store &FF in the Y-th byte of the key logger at KL
 STX KL,Y

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 LDA #&FF               \ Store &FF in the Y-th byte of the key logger at KL
 STA KL,Y

ENDIF

 RTS                    \ Return from the subroutine

