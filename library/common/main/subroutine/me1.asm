\ ******************************************************************************
\
\       Name: me1
\       Type: Subroutine
\   Category: Text
\    Summary: Erase an old in-flight message and display a new one
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
\   X                   Must be set to 0
\
\ ******************************************************************************

.me1

 STX DLY                \ Set the message delay in DLY to 0, so any new
                        \ in-flight messages will be shown instantly

 PHA                    \ Store the new message token we want to print

 LDA MCH                \ Set A to the token number of the message that is
 JSR mes9               \ currently on-screen, and call mes9 to print it (which
                        \ will remove it from the screen, as printing is done
                        \ using EOR logic)

 PLA                    \ Restore the new message token

IF _CASSETTE_VERSION OR _DISC_VERSION

 EQUB &2C               \ Fall through into me1 to print the new message, but
                        \ skip the first instruction by turning it into
                        \ &2C &A9 &6C, or BIT &6CA9, which does nothing apart
                        \ from affect the flags

ENDIF

