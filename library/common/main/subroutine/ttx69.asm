\ ******************************************************************************
\
\       Name: TTX69
\       Type: Subroutine
\   Category: Text
\    Summary: Print a paragraph break
\
\ ------------------------------------------------------------------------------
\
IF NOT(_ELITE_A_ENCYCLOPEDIA)
\ Print a paragraph break (a blank line between paragraphs) by moving the cursor
\ down a line, setting Sentence Case, and then printing a newline.
ELIF _ELITE_A_ENCYCLOPEDIA
\ Print a paragraph break (a blank line between paragraphs) by moving the cursor
\ down a line, and then printing a newline.
ENDIF
\
\ ******************************************************************************

.TTX69

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 INC YC                 \ Move the text cursor down a line

ELIF _6502SP_VERSION

 JSR INCYC              \ Move the text cursor down a line

ELIF _C64_VERSION

 JSR INCYC              \ Move the text cursor down a line

\JSR INCYC              \ This instruction is commented out in the original
\                       \ source

ELIF _APPLE_VERSION

 INC YC                 \ Move the text cursor down a line

\JSR INCYC              \ This instruction is commented out in the original
\                       \ source

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)

                        \ Fall through into TT69 to set Sentence Case and print
                        \ a newline

ELIF _ELITE_A_ENCYCLOPEDIA

                        \ Fall through into TT67 to print a newline

ENDIF

