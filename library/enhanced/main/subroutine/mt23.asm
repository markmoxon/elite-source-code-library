\ ******************************************************************************
\
\       Name: MT23
\       Type: Subroutine
\   Category: Text
IF NOT(_NES_VERSION)
\    Summary: Move to row 10, switch to white text, and switch to lower case
ELIF _NES_VERSION
\    Summary: Move to row 9, switch to white text, and switch to lower case
ENDIF
\             when printing extended tokens
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.MT23

IF NOT(_NES_VERSION)

 LDA #10                \ Set A = 10, so when we fall through into MT29, the
                        \ text cursor gets moved to row 10

ELIF _NES_VERSION

 LDA #9                 \ Set A = 9, so when we fall through into MT29, the
                        \ text cursor gets moved to row 9

ENDIF

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &06, or BIT &06A9, which does nothing apart
                        \ from affect the flags

                        \ Fall through into MT29 to move to the row in A, switch
                        \ to white text, and switch to lower case

