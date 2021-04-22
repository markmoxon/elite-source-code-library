\ ******************************************************************************
\
\       Name: PL2
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Remove the planet or sun from the screen
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   PL2-1               Contains an RTS
\
\ ******************************************************************************

.PL2

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION

 LDA TYPE               \ Shift bit 0 of the planet/sun's type into the C flag
 LSR A

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Tube

 BCS P%+5               \ If the planet/sun's type has bit 0 clear, then it's
                        \ either 128 or 130, which is a planet; meanwhile, the
                        \ sun has type 129, which has bit 0 set. So if this is
                        \ the sun, skip the following instruction

 JMP WPLS2              \ This is the planet, so jump to WPLS2 to remove it from
                        \ screen, returning from the subroutine using a tail
                        \ call

ELIF _ELECTRON_VERSION

 JMP WPLS2              \ This is the planet, so jump to WPLS2 to remove it from
                        \ screen, returning from the subroutine using a tail
                        \ call

ELIF _6502SP_VERSION

 BCS PL57               \ If the planet/sun's type has bit 0 clear, then it's
                        \ either 128 or 130, which is a planet; meanwhile, the
                        \ sun has type 129, which has bit 0 set. So if this is
                        \ the sun, jump to PL57 to skip the following
                        \ instructions

 JSR LS2FL              \ Call LS2FL to send the ball line heap to the I/O
                        \ processor for drawing on-screen, which redraws the
                        \ planet and this removes it from the screen

 STZ LSP                \ Reset the ball line heap by setting the ball line heap
                        \ pointer to 0

 RTS                    \ Return from the subroutine

.PL57

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION

 JMP WPLS               \ This is the sun, so jump to WPLS to remove it from
                        \ screen, returning from the subroutine using a tail
                        \ call

ENDIF

