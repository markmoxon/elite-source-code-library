\ ******************************************************************************
\
\       Name: TTX69
\       Type: Subroutine
\   Category: Text
\    Summary: Print a paragraph break
\
\ ------------------------------------------------------------------------------
\
IF _ELITE_A_ENCYCLOPEDIA
\ Print a paragraph break (a blank line between paragraphs) by moving the cursor
\ down a line, and then printing a newline.
ELIF NOT(_ELITE_A_ENCYCLOPEDIA)
\ Print a paragraph break (a blank line between paragraphs) by moving the cursor
\ down a line, setting Sentence Case, and then printing a newline.
ENDIF
\
\ ******************************************************************************

.TTX69

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 INC YC                 \ Move the text cursor down a line

ELIF _6502SP_VERSION

 JSR INCYC              \ Move the text cursor down a line

ENDIF

IF _ELITE_A_ENCYCLOPEDIA

                        \ Fall through into TT67 to print a newline

ELIF NOT(_ELITE_A_ENCYCLOPEDIA)

                        \ Fall through into TT69 to set Sentence Case and print
                        \ a newline

ENDIF

