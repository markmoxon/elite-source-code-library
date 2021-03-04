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

ENDIF

IF _CASSETTE_VERSION \ Enhanced: The cassette version uses control code 13 for printing newlines, while the other versions use control code 12

 LDA #13                \ Load a newline character into A

ELIF _DISC_VERSION OR _6502SP_VERSION

 LDA #12                \ Load a newline character into A

ENDIF

 JMP TT27               \ Print the text token in A and return from the
                        \ subroutine using a tail call

