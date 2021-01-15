\ ******************************************************************************
\
\       Name: TT67
\       Type: Subroutine
\   Category: Text
\    Summary: Print a newline
\
\ ******************************************************************************

.TT67

IF _CASSETTE_VERSION

 LDA #13                \ Load a newline character into A

ELIF _DISC_VERSION

 LDA #12                \ Load a newline character into A

ELIF _6502SP_VERSION

 INC YC                 \ Move the text cursor counter in YC down a line

 LDA #12                \ Load a newline character into A

ENDIF

 JMP TT27               \ Print the text token in A and return from the
                        \ subroutine using a tail call

