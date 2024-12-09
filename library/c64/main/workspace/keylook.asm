\ ******************************************************************************
\
\       Name: KEYLOOK
\       Type: Workspace
\    Address: &8D0C to &8D52
\   Category: Keyboard
\    Summary: The key logger
\
\ ------------------------------------------------------------------------------
\
\ KEYLOOK (also known as KLO) is the Commodore 64 version's key logger. It does
\ the same job as the KL key logger in the BBC Micro versions, but it has a very
\ different structure, with one entry for every possible key press, rather than
\ just one for each flight key.
\
\ Specifically, it has one byte for each key in the Commodore 64 keyboard
\ matrix, and it is laid out in the same order. The keyboard matrix is exposed
\ to our code via port A on the CIA1 interface chip, through the memory-mapped
\ locations &DC00 and &DC01. To read a key, you first set the column to scan by
\ writing to &DC00, and the details of any key that is bring pressed in that
\ column are returned in &DC01 (see the RDKEY routine for details).
\
\ The keyboard matrix layout can be seen at https://sta.c64.org/cbm64kbdlay.html
\
\ The KEYLOOK table mirrors the structure of the keyboard matrix, though it's
\ reversed so that KEYLOOK maps to the keyboard matrix from the bottom corner of
\ the above diagram, working right to left and down to up. (The RDKEY routine
\ is responsible for filling the KEYLOOK table, and it chooses to work through
\ the table in this direction).
\
\ The RDKEY routine scans the keyboard matrix and sets each entry in KEYLOOK
\ according to whether that key is being pressed. The entries that map to the
\ flight keys have labels KY1 through KY7 for the main flight controls, and
\ KY12 to KY20 for the secondary controls, so the main game code can check
\ whether a key is being pressed by simply checking for non-zero values in the
\ relevant KY entries. The order of the KY labels is strange because they are
\ the same labels as in the BBC Micro version, and the order of the keys in
\ the logger is completely different on the Commodore 64 (the labels are ordered
\ from KY1 to KY7 and KY12 to KY20 in the BBC Micro version).
\
\ The index of a key in the KEYLOOK table is referred to as the "internal key
\ number" throughout this documentation, so the "@" key has an internal key
\ number of 18 (or &12), for example, as it is stored at KEYLOOK+18.
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
                        \
                        \ The Commodore 64 version doesn't use this byte, but
                        \ instead it stores the last-pressed key in the KL and
                        \ thi8skey variables

 EQUS "2"               \ RUN/STOP is being pressed (KLO+&1)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "3"               \ "Q" is being pressed (KLO+&2)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky12.asm"
INCLUDE "library/common/main/variable/ky2.asm"

 EQUS "6"               \ "2" is being pressed (KLO+&5)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "7"               \ CTRL is being pressed (KLO+&6)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky13.asm"

 EQUS "9"               \ "1" is being pressed (KLO+&8)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky1.asm"

 EQUS "B"               \ Up arrow is being pressed (KLO+&A)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "C"               \ "=" is being pressed (KLO+&B)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "D"               \ Right SHIFT is being pressed (KLO+&C)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "E"               \ CLR/HOME is being pressed (KLO+&D)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "F"               \ ";" is being pressed (KLO+&E)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "0"               \ "*" is being pressed (KLO+&F)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "1"               \ "£" is being pressed (KLO+&10)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky3.asm"

 EQUS "3"               \ "@" is being pressed (KLO+&12)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "4"               \ ":" is being pressed (KLO+&13)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky4.asm"

 EQUS "6"               \ "-" is being pressed (KLO+&15)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "7"               \ "L" is being pressed (KLO+&16)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/enhanced/main/variable/ky20.asm"

 EQUS "9"               \ "+" is being pressed (KLO+&18)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "A"               \ "N" is being pressed (KLO+&19)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "B"               \ "O" is being pressed (KLO+&1A)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "C"               \ "K" is being pressed (KLO+&1B)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky16.asm"

 EQUS "E"               \ "0" is being pressed (KLO+&1D)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky18.asm"

 EQUS "0"               \ "I" is being pressed (KLO+&1F)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "1"               \ "9" is being pressed (KLO+&20)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "2"               \ "V" is being pressed (KLO+&21)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky15.asm"

 EQUS "4"               \ "H" is being pressed (KLO+&23)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "5"               \ "B" is being pressed (KLO+&24)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "6"               \ "8" is being pressed (KLO+&25)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "7"               \ "G" is being pressed (KLO+&26)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "8"               \ "Y" is being pressed (KLO+&27)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "9"               \ "7" is being pressed (KLO+&28)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky5.asm"
INCLUDE "library/common/main/variable/ky14.asm"

 EQUS "C"               \ "F" is being pressed (KLO+&2B)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky19.asm"

 EQUS "E"               \ "6" is being pressed (KLO+&2D)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "F"               \ "D" is being pressed (KLO+&2E)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "0"               \ "R" is being pressed (KLO+&2F)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "1"               \ "5" is being pressed (KLO+&30)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "2"               \ Left SHIFT is being pressed (KLO+&31)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky17.asm"
INCLUDE "library/common/main/variable/ky6.asm"

 EQUS "5"               \ "Z" is being pressed (KLO+&34)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "6"               \ "4" is being pressed (KLO+&35)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

INCLUDE "library/common/main/variable/ky7.asm"

 EQUS "8"               \ "W" is being pressed (KLO+&37)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "9"               \ "3" is being pressed (KLO+&38)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "A"               \ Cursor up/down is being pressed (KLO+&39)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "B"               \ F5 is being pressed (KLO+&3A)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "C"               \ F3 is being pressed (KLO+&3B)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "D"               \ F1 is being pressed (KLO+&3C)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "E"               \ F7 is being pressed (KLO+&3D)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "F"               \ Cursor left/right is being pressed (KLO+&3E)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "0"               \ RETURN is being pressed (KLO+&3F)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "1"               \ INS/DEL is being pressed (KLO+&40)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

 EQUS "234567"          \ These bytes appear to be unused

