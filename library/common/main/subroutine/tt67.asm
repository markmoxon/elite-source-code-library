\ ******************************************************************************
\
\       Name: TT67
\       Type: Subroutine
\   Category: Text
\    Summary: Print a newline
\
\ ******************************************************************************

.TT67

IF _6502SP_VERSION \ Tube

 INC YC                 \ Move the text cursor counter in YC down a line

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

\INC YC                 \ This instruction is commented out in the original
                        \ source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: The cassette version uses control code 13 for printing newlines, while the other versions use control code 12

 LDA #13                \ Load a newline character into A

ELIF _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA #12                \ Load a newline character into A

ENDIF

IF NOT(_NES_VERSION)

 JMP TT27               \ Print the text token in A and return from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

 JMP TT27_b2            \ Print the text token in A and return from the
                        \ subroutine using a tail call

ENDIF

