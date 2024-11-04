\ ******************************************************************************
\
\       Name: wW
\       Type: Subroutine
\   Category: Flight
\    Summary: Start a hyperspace countdown
\
\ ------------------------------------------------------------------------------
\
\ Start the hyperspace countdown (for both inter-system hyperspace and the
\ galactic hyperdrive).
\
IF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   wW2                 Start the hyperspace countdown, starting the countdown
\                       from the value in A
\
ENDIF
\ ******************************************************************************

.wW

IF NOT(_NES_VERSION)

 LDA #15                \ The hyperspace countdown starts from 15, so set A to
                        \ 15 so we can set the two hyperspace counters

ELIF _NES_VERSION

 LDA #16                \ The hyperspace countdown starts from 16, so set A to
                        \ 15 so we can set the two hyperspace counters

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Label

.wW2

ENDIF

 STA QQ22+1             \ Set the number in QQ22+1 to A, which is the number
                        \ that's shown on-screen during the hyperspace countdown

IF NOT(_NES_VERSION)

 STA QQ22               \ Set the number in QQ22 to 15, which is the internal
                        \ counter that counts down by 1 each iteration of the
                        \ main game loop, and each time it reaches zero, the
                        \ on-screen counter gets decremented, and QQ22 gets set
                        \ to 5, so setting QQ22 to 15 here makes the first tick
                        \ of the hyperspace counter longer than subsequent ticks

ELIF _NES_VERSION

 LDA #1                 \ Set the number in QQ22 to 11, which is the internal
 STA QQ22               \ counter that counts down by 1 each iteration of the
                        \ main game loop, and each time it reaches zero, the
                        \ on-screen counter gets decremented, and QQ22 gets set
                        \ to 5, so setting QQ22 to 1 here makes the first tick
                        \ of the hyperspace counter shorter than subsequent
                        \ ticks

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Minor

 TAX                    \ Print the 8-bit number in X (i.e. 15) at text location
 JMP ee3                \ (0, 1), padded to 5 digits, so it appears in the top
                        \ left corner of the screen, and return from the
                        \ subroutine using a tail call

ELIF _ELECTRON_VERSION

IF _IB_SUPERIOR

 TAX                    \ Print the 8-bit number in X (i.e. 15) at text location
 JMP ee3                \ (0, 1), padded to 5 digits, so it appears in the top
                        \ left corner of the screen, and return from the
                        \ subroutine using a tail call

ELIF _IB_ACORNSOFT

 TAX                    \ Print the 8-bit number in X (i.e. 15) at text location
 JSR ee3                \ (0, 1), padded to 5 digits, so it appears in the top
                        \ left corner of the screen

 RTS                    \ Return from the subroutine

ENDIF

ELIF _ELITE_A_VERSION

 TAX                    \ Print the 8-bit number in X (i.e. 15) at text location
 BNE ee3                \ (0, 1), padded to 5 digits, so it appears in the top
                        \ left corner of the screen, and return from the
                        \ subroutine using a tail call (the BNE is effectively a
                        \ JMP as A is never zero)

ELIF _NES_VERSION

 JMP UpdateIconBar_b3   \ Update the icon bar to remove the Hyperspace button,
                        \ as we are now commit to our hyperspace jump, and
                        \ return from the subroutine using a tail call

ENDIF

IF _CASSETTE_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment

\.hy5                   \ This instruction and the hy5 label are commented out
\RTS                    \ in the original - they can actually be found at the
                        \ end of the jmp routine below, so perhaps this is where
                        \ they were originally, but the authors realised they
                        \ could save a byte by using a tail call instead of an
                        \ RTS?

ENDIF

