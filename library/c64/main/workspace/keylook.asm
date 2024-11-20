\ ******************************************************************************
\
\       Name: KEYLOOK
\       Type: Workspace
\   Category: Keyboard
\    Summary: The key logger
\
\ ------------------------------------------------------------------------------
\
\ In the BBC Micro versions of Elite, the key logger is separate from the lookup
\ tables that are used to convert internal key numbers into flight controls. In
\ the Commodore 64 version, the key logger is merged with the lookup table into
\ the KEYLOOK table.
\
\ The KEYLOOK table has one byte for each key in the Commodore 64 keyboard
\ matrix, and it is laid out in the same order. The keyboard matrix is exposed
\ to our code via port A on the CIA 1 interface chip, through the memory-mapped
\ locations &DC00 and &DC01. To read a key, you first set the column to scan by
\ writing to &DC00, and the details of any key that is bring pressed in that
\ column are returned in &DC01 (see the RDKEY routine for details).
\
\ The keyboard matrix layout can be seen at https://sta.c64.org/cbm64kbdlay.html
\
\ The KEYLOOK table mirrors the structure of the keyboard matrix, though it's
\ reversed so that KEYLOOK reads the keyboard matrix from the bottom corner of
\ the above diagram, working right to left and down to up.
\
\ The RDKEY routine scans the keyboard matrix and sets each entry in KEYLOOK
\ according to whether that key is being pressed. The entries that map to the
\ flight keys have labels KY1 through KY7 for the main flight controls, and
\ KY12 to KY20 for the secondary controls, so the main game code can check
\ whether a key is being pressed by simply checking for non-zero values in the
\ relevant KY entries.
\
\ The index of a key in the KEYLOOK table is referred to as the "internal key
\ number" throughout this documentation.
\
\ Note that the initial content of the KEYLOOK table is a simple repeated string
\ of "123456789ABCDEF0", as this was used in the original source code to create
\ the table during assembly. These initial values have no meaning.
\
\ ******************************************************************************

.KEYLOOK

 SKIP 0                 \ KEYLOOK and KLO share the same address

.KLO

 EQUS "1"               \ The key logger in the BBC Micro version has a spare
                        \ byte at the start for storing the last key press, so
                        \ we also include a spare byte here so the KLO logger
                        \ in the Commodore 64 version behaves in a similar way
                        \ to the KL key logger in the BBC Micro

 EQUS "2"               \ RUN/STOP

 EQUS "3"               \ Q

INCLUDE "library/common/main/variable/ky12.asm"
INCLUDE "library/common/main/variable/ky2.asm"

 EQUS "6"               \ 2

 EQUS "7"               \ CTRL

INCLUDE "library/common/main/variable/ky13.asm"

 EQUS "9"               \ 1

INCLUDE "library/common/main/variable/ky1.asm"

 EQUS "B"               \ Up arrow

 EQUS "C"               \ =

 EQUS "D"               \ Right SHIFT

 EQUS "E"               \ CLR/HOME

 EQUS "F"               \ ;

 EQUS "0"               \ *

 EQUS "1"               \ £

INCLUDE "library/common/main/variable/ky3.asm"

 EQUS "3"               \ @

 EQUS "4"               \ :

INCLUDE "library/common/main/variable/ky4.asm"

 EQUS "6"               \ -

 EQUS "7"               \ L

INCLUDE "library/enhanced/main/variable/ky20.asm"

 EQUS "9"               \ +

 EQUS "A"               \ N

 EQUS "B"               \ O

 EQUS "C"               \ K

INCLUDE "library/common/main/variable/ky16.asm"

 EQUS "E"               \ 0

INCLUDE "library/common/main/variable/ky18.asm"

 EQUS "0"               \ I

 EQUS "1"               \ 9

 EQUS "2"               \ V

INCLUDE "library/common/main/variable/ky15.asm"

 EQUS "4"               \ H

 EQUS "5"               \ B

 EQUS "6"               \ 8

 EQUS "7"               \ G

 EQUS "8"               \ Y

 EQUS "9"               \ 7

INCLUDE "library/common/main/variable/ky5.asm"
INCLUDE "library/common/main/variable/ky14.asm"

 EQUS "C"               \ F

INCLUDE "library/common/main/variable/ky19.asm"

 EQUS "E"               \ 6

 EQUS "F"               \ D

 EQUS "0"               \ R

 EQUS "1"               \ 5

 EQUS "2"               \ Left SHIFT

INCLUDE "library/common/main/variable/ky17.asm"
INCLUDE "library/common/main/variable/ky6.asm"

 EQUS "5"               \ Z

 EQUS "6"               \ 4

INCLUDE "library/common/main/variable/ky7.asm"

 EQUS "8"               \ W

 EQUS "9"               \ 3

 EQUS "A"               \ Cursor up/down

 EQUS "B"               \ F5

 EQUS "C"               \ F3

 EQUS "D"               \ F1

 EQUS "E"               \ F7

 EQUS "F"               \ Cursor left/right

 EQUS "0"               \ RETURN

 EQUS "1"               \ INS/DEL

 EQUS "234567"          \ These bytes appear to be unused

