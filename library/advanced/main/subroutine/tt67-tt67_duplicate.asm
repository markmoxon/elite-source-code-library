\ ******************************************************************************
\
IF _6502SP_VERSION \ Comment
\       Name: TT67
ELIF _MASTER_VERSION
\       Name: TT67_DUPLICATE
ENDIF
\       Type: Subroutine
\   Category: Text
\    Summary: Print a newline
\
\ ******************************************************************************

IF _6502SP_VERSION \ Label

.TT67

ELIF _MASTER_VERSION

.TT67_DUPLICATE

ENDIF

 LDA #12                \ Set A to a carriage return character

                        \ Fall through into TT26 to print the newline

