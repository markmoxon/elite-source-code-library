\ ******************************************************************************
\
\       Name: RLINE
\       Type: Variable
\   Category: Text
\    Summary: The OSWORD configuration block used to fetch a line of text from
\             the keyboard
\
IF _C64_VERSION OR _APPLE_VERSION
\ ------------------------------------------------------------------------------
\
\ This block is left over from the BBC Micro version of Elite and is not used in
\ this version.
\
ENDIF
\ ******************************************************************************

.RLINE

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: The enhanced versions allow the "{" character in commander names, which is not allowed in the cassette or Electron versions

 EQUW INWK              \ The address to store the input, so the commander's
                        \ name will be stored in INWK as it is typed

 EQUB 7                 \ Maximum line length = 7, as that's the maximum size
                        \ for a commander's name

 EQUB '!'               \ Allow ASCII characters from "!" through to "z" in
 EQUB 'z'               \ the name

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 EQUW INWK+5            \ The address to store the input, so the text entered
                        \ will be stored in INWK+5 as it is typed

 EQUB 9                 \ Maximum line length = 9, as that's the maximum size
                        \ for a commander's name including a directory name

 EQUB '!'               \ Allow ASCII characters from "!" through to "{" in
 EQUB '{'               \ the input

ENDIF

