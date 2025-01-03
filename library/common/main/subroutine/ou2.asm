\ ******************************************************************************
\
\       Name: ou2
\       Type: Subroutine
\   Category: Flight
\    Summary: Display "E.C.M.SYSTEM DESTROYED" as an in-flight message
\
\ ******************************************************************************

.ou2

 LDA #108               \ Set A to recursive token 108 ("E.C.M.SYSTEM")

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 EQUB &2C               \ Fall through into ou3 to print the new message, but
                        \ skip the first instruction by turning it into
                        \ &2C &A9 &6F, or BIT &6FA9, which does nothing apart
                        \ from affect the flags

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 JMP MESS               \ Print recursive token A as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

 BNE ouch1              \ Jump up to ouch1 to print recursive token A as an
                        \ in-flight message, followed by " DESTROYED", and
                        \ return from the subroutine using a tail call (this
                        \ BNE is effectively a JMP as A is never zero)

ENDIF

