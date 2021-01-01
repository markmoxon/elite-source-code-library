\ ******************************************************************************
\
\       Name: LTDEF
\       Type: Variable
\   Category: Demo
\    Summary: Letter definitions for the Star Wars scroll text
\
\ ------------------------------------------------------------------------------
\
\ Letters in the scroll text are drawn on a 3x6 grid like this:
\
\   .   .   .
\   .   .   .
\   .   .   .
\   .   .   .
\   .   .   .
\   .   .   .
\
\ The spacing is configured like this:
\
\   0           .   .   .
\   0.5 * WY    .   .   .
\   1.0 * WY    .   .   .
\   1.5 * WY    .   .   .
\   2.0 * WY    .   .   .
\   2.5 * WY    .   .   .
\
\               4   8   12
\
\ so the vertical spacing is controlled by configuration variable WY. The
\ x-coordinate of point n is given by the n-th entry in NOFX, while the
\ y-coordinate is given by the n-th entry in NOFY.
\
\ When drawing letters, only 12 of the 18 points can be used. They are numbered
\ as follows:
\
\   0   1   2
\   .   .   .
\   3   4   5
\   .   .   .
\   6   7   8
\   9   A   B
\
\ The LTDEF table contains definitions for all the letters and some punctuation
\ characters. Each definition consists of 5 bytes, with each byte describing one
\ line in the character's shape (bytes with value 0 are ignored, so each
\ character consists of up to five lines).
\
\ The bottom nibble of each byte is the starting point for that line segment,
\ and the top nibble is the end point, so a value of &28, for example, means
\ "draw a line from point 8 to point 2").
\
\ Let's look at a few examples to make this clearer.
\
\ The definition in LTDEF for "A" is:
\
\   &60, &02, &28, &35, &00
\
\ This translates to the following:
\
\   &60 = line from point 0 to point 6
\   &02 = line from point 2 to point 0
\   &28 = line from point 8 to point 2
\   &35 = line from point 5 to point 3
\   &00 = ignore
\
\ which looks like this on the grid:
\
\   +-------+
\   |   .   |
\   +-------+
\   |   .   |
\   |   .   |
\   .   .   .
\
\ The definition in LTDEF for "S" is:
\
\   &20, &03, &35, &58, &86
\
\ This translates to the following:
\
\   &20 = line from point 0 to point 2
\   &03 = line from point 3 to point 0
\   &35 = line from point 5 to point 3
\   &58 = line from point 8 to point 5
\   &86 = line from point 6 to point 8
\
\ which looks like this on the grid:
\
\   +-------+
\   |   .   .
\   +-------+
\   .   .   |
\   +-------+
\   .   .   .
\
\ The definition in LTDEF for "," is:
\
\   &63, &34, &47, &76, &97
\
\ This translates to the following:
\
\   &63 = line from point 3 to point 6
\   &34 = line from point 4 to point 3
\   &47 = line from point 7 to point 4
\   &76 = line from point 6 to point 7
\   &97 = line from point 7 to point 9
\
\ which looks like this on the grid:
\
\   .   .   .
\   .   .   .
\   +---+   .
\   |   |   .
\   +---/   .
\   ..-´    .
\
\ ******************************************************************************

.LTDEF

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

