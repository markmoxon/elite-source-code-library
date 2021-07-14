\ ******************************************************************************
\
\       Name: column_16
\       Type: Subroutine
\   Category: Text
\    Summary: Tab to column 16 and start a new word when printing extended
\             tokens
\
\ ******************************************************************************

.column_16

 LDA #16                \ Set X to 16 so when we fall through into MT8 we move
                        \ the text cursor to column 16 instead of 6

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &06, or BIT &06A9, which does nothing apart
                        \ from affect the flags

                        \ Fall through into MT8 to move the text cursor to
                        \ column 16 and start a new word

