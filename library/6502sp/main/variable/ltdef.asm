\ ******************************************************************************
\
\       Name: LTDEF
\       Type: Variable
IF NOT(_NES_VERSION)
\   Category: Demo
ELIF _NES_VERSION
\   Category: Combat demo
ENDIF
\    Summary: Line definitions for characters in the Star Wars scroll text
\  Deep dive: The 6502 Second Processor demo mode
\
\ ------------------------------------------------------------------------------
\
\ Characters in the scroll text are drawn using lines on a 3x6 numbered grid
\ like this:
\
\   0   1   2
\   .   .   .
\   3   4   5
\   .   .   .
\   6   7   8
\   9   A   B
\
\ The low nibble of each byte is the starting point for that line segment, and
\ the high nibble is the end point, so a value of &28, for example, means
\ "draw a line from point 8 to point 2". This table contains definitions for all
\ the characters we can use in the scroll text, as lines on the above grid.
\
\ See the deep dive on "the 6502 Second Processor demo mode" for details.
\
\ ******************************************************************************

.LTDEF

IF NOT(_NES_VERSION)

 EQUB &63, &34, &47, &76, &97   \ Letter definition for ","
 EQUB &35, &00, &00, &00, &00   \ Letter definition for "-"
 EQUB &63, &34, &47, &76, &00   \ Letter definition for "."
 EQUB &61, &00, &00, &00, &00   \ Letter definition for "/"
 EQUB &73, &31, &15, &57, &00   \ Letter definition for "0"
 EQUB &31, &17, &00, &00, &00   \ Letter definition for "1"
 EQUB &02, &25, &53, &36, &68   \ Letter definition for "2"
 EQUB &02, &28, &86, &35, &00   \ Letter definition for "3"
 EQUB &82, &23, &35, &00, &00   \ Letter definition for "4"
 EQUB &20, &03, &35, &58, &86   \ Letter definition for "5"
 EQUB &20, &06, &68, &85, &53   \ Letter definition for "6"
 EQUB &02, &28, &00, &00, &00   \ Letter definition for "7"
 EQUB &60, &02, &28, &86, &35   \ Letter definition for "8"
 EQUB &82, &20, &03, &35, &00   \ Letter definition for "9"
 EQUB &00, &00, &00, &00, &00   \ Letter definition for ":" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for ";" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for "<" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for "=" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for ">" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for "?" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for "@" (blank)
 EQUB &60, &02, &28, &35, &00   \ Letter definition for "A"
 EQUB &60, &02, &28, &86, &35   \ Letter definition for "B"
 EQUB &86, &60, &02, &00, &00   \ Letter definition for "C"
 EQUB &60, &05, &56, &00, &00   \ Letter definition for "D"
 EQUB &86, &60, &02, &35, &00   \ Letter definition for "E"
 EQUB &60, &02, &35, &00, &00   \ Letter definition for "F"
 EQUB &45, &58, &86, &60, &02   \ Letter definition for "G"
 EQUB &60, &28, &35, &00, &00   \ Letter definition for "H"
 EQUB &17, &00, &00, &00, &00   \ Letter definition for "I"
 EQUB &28, &86, &63, &00, &00   \ Letter definition for "J"
 EQUB &60, &23, &83, &00, &00   \ Letter definition for "K"
 EQUB &86, &60, &00, &00, &00   \ Letter definition for "L"
 EQUB &60, &04, &42, &28, &00   \ Letter definition for "M"
 EQUB &60, &08, &82, &00, &00   \ Letter definition for "N"
 EQUB &60, &02, &28, &86, &00   \ Letter definition for "O"
 EQUB &60, &02, &25, &53, &00   \ Letter definition for "P"
 EQUB &60, &02, &28, &86, &48   \ Letter definition for "Q"
 EQUB &60, &02, &25, &53, &48   \ Letter definition for "R"
 EQUB &20, &03, &35, &58, &86   \ Letter definition for "S"
 EQUB &02, &17, &00, &00, &00   \ Letter definition for "T"
 EQUB &28, &86, &60, &00, &00   \ Letter definition for "U"
 EQUB &27, &70, &00, &00, &00   \ Letter definition for "V"
 EQUB &28, &84, &46, &60, &00   \ Letter definition for "W"
 EQUB &26, &08, &00, &00, &00   \ Letter definition for "X"
 EQUB &74, &04, &24, &00, &00   \ Letter definition for "Y"
 EQUB &02, &26, &68, &00, &00   \ Letter definition for "Z"

ELIF _NES_VERSION

 EQUB &00, &00, &00, &00, &00   \ Letter definition for " " (blank)
 EQUB &14, &25, &12, &45, &78   \ Letter definition for "!"
 EQUB &24, &00, &00, &00, &00   \ Letter definition for """ ("'")
 EQUB &02, &17, &68, &00, &00   \ Letter definition for "#" (serif "I")
 EQUB &35, &36, &47, &58, &00   \ Letter definition for "$" ("m")
 EQUB &47, &11, &00, &00, &00   \ Letter definition for "%" ("i")
 EQUB &17, &35, &00, &00, &00   \ Letter definition for "&" ("+")
 EQUB &36, &47, &34, &00, &00   \ Letter definition for "'" ("n")
 EQUB &12, &13, &37, &78, &00   \ Letter definition for "("
 EQUB &01, &15, &57, &67, &00   \ Letter definition for ")"
 EQUB &17, &35, &08, &26, &00   \ Letter definition for "*"
 EQUB &17, &35, &00, &00, &00   \ Letter definition for "+"
 EQUB &36, &34, &47, &67, &79   \ Letter definition for ","
 EQUB &35, &00, &00, &00, &00   \ Letter definition for "-"
 EQUB &36, &34, &47, &67, &00   \ Letter definition for "."
 EQUB &16, &00, &00, &00, &00   \ Letter definition for "/"
 EQUB &37, &13, &15, &57, &00   \ Letter definition for "0"
 EQUB &13, &17, &00, &00, &00   \ Letter definition for "1"
 EQUB &02, &25, &35, &36, &68   \ Letter definition for "2"
 EQUB &02, &28, &68, &35, &00   \ Letter definition for "3"
 EQUB &28, &23, &35, &00, &00   \ Letter definition for "4"
 EQUB &02, &03, &35, &58, &68   \ Letter definition for "5"
 EQUB &02, &06, &68, &58, &35   \ Letter definition for "6"
 EQUB &02, &28, &00, &00, &00   \ Letter definition for "7"
 EQUB &06, &02, &28, &68, &35   \ Letter definition for "8"
 EQUB &28, &02, &03, &35, &00   \ Letter definition for "9"
 EQUB &13, &34, &46, &00, &00   \ Letter definition for ":" ("s")
 EQUB &01, &06, &34, &67, &00   \ Letter definition for ";" (slim "E")
 EQUB &13, &37, &00, &00, &00   \ Letter definition for "<"
 EQUB &45, &78, &00, &00, &00   \ Letter definition for "="
 EQUB &00, &00, &00, &00, &00   \ Letter definition for ">" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for "?" (blank)
 EQUB &00, &00, &00, &00, &00   \ Letter definition for "@" (blank)
 EQUB &06, &02, &28, &35, &00   \ Letter definition for "A"
 EQUB &06, &02, &28, &68, &35   \ Letter definition for "B"
 EQUB &68, &06, &02, &00, &00   \ Letter definition for "C"
 EQUB &06, &05, &56, &00, &00   \ Letter definition for "D"
 EQUB &68, &06, &02, &35, &00   \ Letter definition for "E"
 EQUB &06, &02, &35, &00, &00   \ Letter definition for "F"
 EQUB &45, &58, &68, &60, &02   \ Letter definition for "G"
 EQUB &06, &28, &35, &00, &00   \ Letter definition for "H"
 EQUB &17, &00, &00, &00, &00   \ Letter definition for "I"
 EQUB &28, &68, &36, &00, &00   \ Letter definition for "J"
 EQUB &06, &23, &38, &00, &00   \ Letter definition for "K"
 EQUB &68, &06, &00, &00, &00   \ Letter definition for "L"
 EQUB &06, &04, &24, &28, &00   \ Letter definition for "M"
 EQUB &06, &08, &28, &00, &00   \ Letter definition for "N"
 EQUB &06, &02, &28, &68, &00   \ Letter definition for "O"
 EQUB &06, &02, &25, &35, &00   \ Letter definition for "P"
 EQUB &06, &02, &28, &68, &48   \ Letter definition for "Q"
 EQUB &06, &02, &25, &35, &48   \ Letter definition for "R"
 EQUB &02, &03, &35, &58, &68   \ Letter definition for "S"
 EQUB &02, &17, &00, &00, &00   \ Letter definition for "T"
 EQUB &28, &68, &06, &00, &00   \ Letter definition for "U"
 EQUB &27, &07, &00, &00, &00   \ Letter definition for "V"
 EQUB &28, &48, &46, &06, &00   \ Letter definition for "W"
 EQUB &26, &08, &00, &00, &00   \ Letter definition for "X"
 EQUB &47, &04, &24, &00, &00   \ Letter definition for "Y"
 EQUB &02, &26, &68, &00, &00   \ Letter definition for "Z"

ENDIF

