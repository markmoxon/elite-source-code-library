\ ******************************************************************************
\
\       Name: RLINE
\       Type: Variable
\   Category: Text
\    Summary: The OSWORD configuration block used to fetch a line of text from
\             the keyboard
\
\ ******************************************************************************

.RLINE

IF _CASSETTE_VERSION \ Enhanced: The enhanced versions allow the "{" character in commander names

 EQUW INWK              \ The address to store the input, so the commander's
                        \ name will be stored in INWK as it is typed

 EQUB 7                 \ Maximum line length = 7, as that's the maximum size
                        \ for a commander's name

 EQUB '!'               \ Allow ASCII characters from "!" through to "z" in
 EQUB 'z'               \ the name


ELIF _6502SP_VERSION OR _DISC_VERSION

 EQUW INWK+5            \ The address to store the input, so the text entered
                        \ will be stored in INWK+5 as it is typed

 EQUB 9                 \ Maximum line length = 9, as that's the maximum size
                        \ for a commander's name including a directory name

 EQUB '!'               \ Allow ASCII characters from "!" through to "{" in
 EQUB '{'               \ the input

ENDIF

