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

 EQUW INWK+5            \ The address to store the input, so the text entered
                        \ will be stored in INWK+5 as it is typed

 EQUB 9                 \ Maximum line length = 9

 EQUB '!'               \ Allow ASCII characters from "!" through to "{" in
 EQUB '{'               \ the input

