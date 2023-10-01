\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 2)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank2.bin
\
\ ******************************************************************************

 _BANK = 2

 INCLUDE "versions/nes/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = FALSE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-common.asm"

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-7.asm"

\ ******************************************************************************
\
\ ELITE BANK 2
\
\ Produces the binary file bank2.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"

\ ******************************************************************************
\
\       Name: TKN1
\       Type: Variable
\   Category: Text
\    Summary: The first extended token table for recursive tokens 0-255 (DETOK)
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.TKN1

 EQUB VE                \ Token 0:      ""

 EJMP 19                \ Token 1:      ""
 ECHR 'Y'
 ETWO 'E', 'S'
 EQUB VE

 EJMP 19                \ Token 2:      ""
 ETWO 'N', 'O'
 EQUB VE

 EJMP 2                 \ Token 3:      ""
 EJMP 19
 ECHR 'I'
 ETWO 'M', 'A'
 ECHR 'G'
 ETWO 'I', 'N'
 ECHR 'E'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'P'
 ETWO 'R', 'E'
 ETWO 'S', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR 'S'
 EQUB VE

 EJMP 19                \ Token 4:      ""
 ETWO 'E', 'N'
 ECHR 'G'
 ECHR 'L'
 ECHR 'I'
 ECHR 'S'
 ECHR 'H'
 EQUB VE

 ETOK 176               \ Token 5:      ""
 ERND 18
 ETOK 202
 ERND 19
 ETOK 177
 EQUB VE

 EJMP 19                \ Token 6:      ""
 ECHR 'L'
 ECHR 'I'
 ETWO 'C', 'E'
 ECHR 'N'
 ETWO 'S', 'E'
 ECHR 'D'
 EJMP 13
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 EQUB VE

 EJMP 19                \ Token 7:      ""
 ECHR 'L'
 ECHR 'I'
 ETWO 'C', 'E'
 ECHR 'N'
 ETWO 'S', 'E'
 ECHR 'D'
 ECHR ' '
 ECHR 'B'
 ECHR 'Y'
 EJMP 26
 ECHR 'N'
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'O'
 EQUB VE

 EJMP 19                \ Token 8:      ""
 ECHR 'N'
 ECHR 'E'
 ECHR 'W'
 EJMP 26
 ECHR 'N'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 ECHR ':'
 ECHR ' '
 EQUB VE

 EJMP 19                \ Token 9:      ""
 ECHR 'I'
 ETWO 'M', 'A'
 ECHR 'G'
 ETWO 'I', 'N'
 ECHR 'E'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'C'
 ECHR 'O'
 ECHR '.'
 EJMP 26
 ECHR 'L'
 ECHR 'T'
 ECHR 'D'
 ECHR '.'
 ECHR ','
 EJMP 26
 ECHR 'J'
 ECHR 'A'
 ECHR 'P'
 ETWO 'A', 'N'
 EQUB VE

 EJMP 23                \ Token 10:     ""
 EJMP 14
 EJMP 13
 EJMP 19
 ECHR 'G'
 ETWO 'R', 'E'
 ETWO 'E', 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 ECHR 'S'
 ETOK 213
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'D'
 EJMP 26
 ECHR 'I'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'G'
 ETOK 208
 ECHR 'M'
 ECHR 'O'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ECHR 'V'
 ETWO 'A', 'L'
 ECHR 'U'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ETWO 'T', 'I'
 ECHR 'M'
 ECHR 'E'
 ETOK 204
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'O', 'U'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ETOK 179
 ETOK 201
 ECHR 'D'
 ECHR 'O'
 ETOK 208
 ECHR 'L'
 ETWO 'I', 'T'
 ECHR 'T'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'J'
 ECHR 'O'
 ECHR 'B'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'U', 'S'
 ETOK 204
 ETOK 147
 ETOK 207
 ECHR ' '
 ETOK 179
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ETOK 202
 ECHR 'A'
 ETOK 210
 ECHR 'M'
 ECHR 'O'
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ECHR ','
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR ','
 ECHR ' '
 ECHR 'E'
 ETWO 'Q', 'U'
 ECHR 'I'
 ECHR 'P'
 ECHR 'P'
 ETOK 196
 ECHR 'W'
 ETWO 'I', 'T'
 ECHR 'H'
 ETOK 208
 ECHR 'T'
 ECHR 'O'
 ECHR 'P'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'C'
 ECHR 'R'
 ETWO 'E', 'T'
 ETOK 210
 ECHR 'S'
 ECHR 'H'
 ECHR 'I'
 ECHR 'E'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ETWO 'G', 'E'
 ECHR 'N'
 ETWO 'E', 'R'
 ETWO 'A', 'T'
 ETWO 'O', 'R'
 ETOK 204
 ECHR 'U'
 ECHR 'N'
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR 'T'
 ECHR 'U'
 ECHR 'N'
 ETWO 'A', 'T'
 ECHR 'E'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR '`'
 ECHR 'S'
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'S', 'T'
 ECHR 'O'
 ETWO 'L', 'E'
 ECHR 'N'
 ETOK 204
 EJMP 22
 EJMP 19
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETOK 195
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 ETOK 207
 ECHR ' '
 ECHR 'Y'
 ETWO 'A', 'R'
 ECHR 'D'
 ECHR ' '
 ETWO 'O', 'N'
 EJMP 26
 ETWO 'X', 'E'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'M'
 ETWO 'O', 'N'
 ETWO 'T', 'H'
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'G'
 ECHR 'O'
 ETOK 178
 EJMP 28
 ETOK 204
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ','
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ETWO 'O', 'U'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'C'
 ECHR 'I'
 ECHR 'D'
 ECHR 'E'
 ETOK 201
 ECHR 'A'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR ','
 ECHR ' '
 ECHR 'I'
 ECHR 'S'
 ETOK 201
 ETWO 'S', 'E'
 ECHR 'E'
 ECHR 'K'
 ETOK 178
 ECHR 'D'
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'O'
 ECHR 'Y'
 ECHR ' '
 ETOK 148
 ETOK 207
 ETOK 204
 ETOK 179
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'A'
 ECHR 'U'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ETOK 196
 ETWO 'T', 'H'
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 EJMP 6
 ERND 26
 EJMP 5
 ECHR 'S'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'G'
 ETWO 'E', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'R'
 ETWO 'O', 'U'
 ECHR 'G'
 ECHR 'H'
 ECHR ' '
 ETOK 147
 ECHR 'N'
 ECHR 'E'
 ECHR 'W'
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ECHR 'I'
 ECHR 'E'
 ECHR 'L'
 ECHR 'D'
 ECHR 'S'
 ETOK 178
 ETWO 'T', 'H'
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ETOK 202
 ECHR 'F'
 ETWO 'I', 'T'
 ECHR 'T'
 ETOK 196
 ECHR 'W'
 ETWO 'I', 'T'
 ECHR 'H'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR ' '
 EJMP 6
 ERND 17
 EJMP 5
 ETOK 177
 EJMP 8
 EJMP 19
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 EJMP 26
 ECHR 'L'
 ECHR 'U'
 ECHR 'C'
 ECHR 'K'
 ECHR ','
 ECHR ' '
 ETOK 154
 ETOK 212
 EJMP 22
 EQUB VE

 EJMP 25                \ Token 11:     ""
 EJMP 9
 EJMP 23
 EJMP 14
 ECHR ' '
 EJMP 26
 ETWO 'A', 'T'
 ECHR 'T'
 ETWO 'E', 'N'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ETOK 213
 ECHR '.'
 EJMP 26
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETOK 196
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'V'
 ECHR 'I'
 ETWO 'C', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'G'
 ECHR 'A'
 ETWO 'I', 'N'
 ETOK 204
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'O', 'U'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ETWO 'S', 'O'
 ECHR ' '
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ETOK 201
 ECHR 'G'
 ECHR 'O'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 EJMP 26
 ETWO 'C', 'E'
 ETWO 'E', 'R'
 ETWO 'D', 'I'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'B'
 ECHR 'R'
 ECHR 'I'
 ECHR 'E'
 ECHR 'F'
 ETWO 'E', 'D'
 ETOK 204
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'S'
 ECHR 'S'
 ECHR 'F'
 ECHR 'U'
 ECHR 'L'
 ECHR ','
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'W'
 ETWO 'A', 'R'
 ECHR 'D'
 ETWO 'E', 'D'
 ETOK 212
 EJMP 24
 EQUB VE

 ECHR '('               \ Token 12:     ""
 EJMP 19
 ECHR 'C'
 ECHR ')'
 ETOK 197
 ECHR ' '
 ECHR '1'
 ECHR '9'
 ECHR '9'
 ECHR '1'
 EQUB VE

 ECHR 'B'               \ Token 13:     ""
 ECHR 'Y'
 ETOK 197
 EQUB VE

 EJMP 21                \ Token 14:     ""
 ETOK 145
 ETOK 200
 EQUB VE

 EJMP 25                \ Token 15:     ""
 EJMP 9
 EJMP 23
 EJMP 14
 EJMP 13
 ECHR ' '
 EJMP 26
 ECHR 'C'
 ETWO 'O', 'N'
 ECHR 'G'
 ECHR 'R'
 ETWO 'A', 'T'
 ECHR 'U'
 ECHR 'L'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 ECHR ' '
 ETOK 154
 ECHR '!'
 EJMP 12
 EJMP 12
 EJMP 19
 ETWO 'T', 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'W'
 ECHR 'A'
 ECHR 'Y'
 ECHR 'S'
 ECHR ' '
 ETWO 'B', 'E'
 ETOK 208
 ECHR 'P'
 ETWO 'L', 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ETWO 'I', 'N'
 ETOK 211
 ETOK 204
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'Y'
 ETWO 'B', 'E'
 ECHR ' '
 ETWO 'S', 'O'
 ETWO 'O', 'N'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'A', 'N'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'I', 'N'
 ECHR 'K'
 ECHR '.'
 ECHR '.'
 ETOK 212
 EJMP 24
 EQUB VE

 ECHR 'F'               \ Token 16:     ""
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR 'D'
 EQUB VE

 ETWO 'N', 'O'          \ Token 17:     ""
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'W'               \ Token 18:     ""
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 EQUB VE

 ECHR 'F'               \ Token 19:     ""
 ECHR 'A'
 ECHR 'M'
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

 ETWO 'N', 'O'          \ Token 20:     ""
 ECHR 'T'
 ETWO 'E', 'D'
 EQUB VE

 ECHR 'V'               \ Token 21:     ""
 ETWO 'E', 'R'
 ECHR 'Y'
 EQUB VE

 ECHR 'M'               \ Token 22:     ""
 ETWO 'I', 'L'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 ECHR 'M'               \ Token 23:     ""
 ECHR 'O'
 ETWO 'S', 'T'
 EQUB VE

 ETWO 'R', 'E'          \ Token 24:     ""
 ECHR 'A'
 ECHR 'S'
 ETWO 'O', 'N'
 ETWO 'A', 'B'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 EQUB VE                \ Token 25:     ""

 ETOK 165               \ Token 26:     ""
 EQUB VE

 ERND 23                \ Token 27:     ""
 EQUB VE

 ECHR 'G'               \ Token 28:     ""
 ETWO 'R', 'E'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'V'               \ Token 29:     ""
 ECHR 'A'
 ETWO 'S', 'T'
 EQUB VE

 ECHR 'P'               \ Token 30:     ""
 ETWO 'I', 'N'
 ECHR 'K'
 EQUB VE

 EJMP 2                 \ Token 31:     ""
 ERND 28
 ECHR ' '
 ERND 27
 EJMP 13
 ECHR ' '
 ETOK 185
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

 ETOK 156               \ Token 32:     ""
 ECHR 'S'
 EQUB VE

 ERND 26                \ Token 33:     ""
 EQUB VE

 ERND 37                \ Token 34:     ""
 ECHR ' '
 ECHR 'F'
 ECHR 'O'
 ETWO 'R', 'E'
 ETWO 'S', 'T'
 ECHR 'S'
 EQUB VE

 ECHR 'O'               \ Token 35:     ""
 ETWO 'C', 'E'
 ETWO 'A', 'N'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 36:     ""
 ECHR 'H'
 ECHR 'Y'
 ECHR 'N'
 ETWO 'E', 'S'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 37:     ""
 ETWO 'I', 'L'
 ECHR 'L'
 ETWO 'I', 'N'
 ETWO 'E', 'S'
 ECHR 'S'
 EQUB VE

 ECHR 'T'               \ Token 38:     ""
 ECHR 'E'
 ECHR 'A'
 ECHR ' '
 ETWO 'C', 'E'
 ETWO 'R', 'E'
 ECHR 'M'
 ETWO 'O', 'N'
 ECHR 'I'
 ETWO 'E', 'S'
 EQUB VE

 ETWO 'L', 'O'          \ Token 39:     ""
 ECHR 'A'
 ETWO 'T', 'H'
 ETOK 195
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ERND 9
 EQUB VE

 ETWO 'L', 'O'          \ Token 40:     ""
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ERND 9
 EQUB VE

 ECHR 'F'               \ Token 41:     ""
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'B'
 ETWO 'L', 'E'
 ECHR 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'T'               \ Token 42:     ""
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR 'I'
 ETWO 'S', 'T'
 ECHR 'S'
 EQUB VE

 ECHR 'P'               \ Token 43:     ""
 ECHR 'O'
 ETWO 'E', 'T'
 ECHR 'R'
 ECHR 'Y'
 EQUB VE

 ETWO 'D', 'I'          \ Token 44:     ""
 ECHR 'S'
 ECHR 'C'
 ECHR 'O'
 ECHR 'S'
 EQUB VE

 ERND 17                \ Token 45:     ""
 EQUB VE

 ECHR 'W'               \ Token 46:     ""
 ETWO 'A', 'L'
 ECHR 'K'
 ETOK 195
 ETOK 158
 EQUB VE

 ECHR 'C'               \ Token 47:     ""
 ECHR 'R'
 ETWO 'A', 'B'
 EQUB VE

 ECHR 'B'               \ Token 48:     ""
 ETWO 'A', 'T'
 EQUB VE

 ETWO 'L', 'O'          \ Token 49:     ""
 ECHR 'B'
 ETWO 'S', 'T'
 EQUB VE

 EJMP 18                \ Token 50:     ""
 EQUB VE

 ETWO 'B', 'E'          \ Token 51:     ""
 ETWO 'S', 'E'
 ECHR 'T'
 EQUB VE

 ECHR 'P'               \ Token 52:     ""
 ETWO 'L', 'A'
 ECHR 'G'
 ECHR 'U'
 ETWO 'E', 'D'
 EQUB VE

 ETWO 'R', 'A'          \ Token 53:     ""
 ECHR 'V'
 ECHR 'A'
 ETWO 'G', 'E'
 ECHR 'D'
 EQUB VE

 ECHR 'C'               \ Token 54:     ""
 ECHR 'U'
 ECHR 'R'
 ETWO 'S', 'E'
 ECHR 'D'
 EQUB VE

 ECHR 'S'               \ Token 55:     ""
 ECHR 'C'
 ETWO 'O', 'U'
 ECHR 'R'
 ETWO 'G', 'E'
 ECHR 'D'
 EQUB VE

 ERND 22                \ Token 56:     ""
 ECHR ' '
 ECHR 'C'
 ECHR 'I'
 ECHR 'V'
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'W'
 ETWO 'A', 'R'
 EQUB VE

 ERND 13                \ Token 57:     ""
 ECHR ' '
 ERND 4
 ECHR ' '
 ERND 5
 ECHR 'S'
 EQUB VE

 ECHR 'A'               \ Token 58:     ""
 ECHR ' '
 ERND 13
 ECHR ' '
 ETWO 'D', 'I'
 ETWO 'S', 'E'
 ECHR 'A'
 ETWO 'S', 'E'
 EQUB VE

 ERND 22                \ Token 59:     ""
 ECHR ' '
 ECHR 'E'
 ETWO 'A', 'R'
 ETWO 'T', 'H'
 ETWO 'Q', 'U'
 ECHR 'A'
 ECHR 'K'
 ETWO 'E', 'S'
 EQUB VE

 ERND 22                \ Token 60:     ""
 ECHR ' '
 ETWO 'S', 'O'
 ECHR 'L'
 ETWO 'A', 'R'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'V'
 ETWO 'I', 'T'
 ECHR 'Y'
 EQUB VE

 ETOK 175               \ Token 61:     ""
 ERND 2
 ECHR ' '
 ERND 3
 EQUB VE

 ETOK 147               \ Token 62:     ""
 EJMP 17
 ECHR ' '
 ERND 4
 ECHR ' '
 ERND 5
 EQUB VE

 ETOK 175               \ Token 63:     ""
 ETOK 193
 ECHR 'S'
 ECHR ' '
 ERND 7
 ECHR ' '
 ERND 8
 EQUB VE

 EJMP 2                 \ Token 64:     ""
 ERND 31
 EJMP 13
 EQUB VE

 ETOK 175               \ Token 65:     ""
 ERND 16
 ECHR ' '
 ERND 17
 EQUB VE

 ECHR 'J'               \ Token 66:     ""
 ECHR 'U'
 ECHR 'I'
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'D'               \ Token 67:     ""
 ECHR 'R'
 ETWO 'I', 'N'
 ECHR 'K'
 EQUB VE

 ECHR 'W'               \ Token 68:     ""
 ETWO 'A', 'T'
 ETWO 'E', 'R'
 EQUB VE

 ECHR 'T'               \ Token 69:     ""
 ECHR 'E'
 ECHR 'A'
 EQUB VE

 EJMP 19                \ Token 70:     ""
 ECHR 'G'
 ETWO 'A', 'R'
 ECHR 'G'
 ETWO 'L', 'E'
 EJMP 26
 ECHR 'B'
 ETWO 'L', 'A'
 ETWO 'S', 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 EJMP 18                \ Token 71:     ""
 EQUB VE

 EJMP 17                \ Token 72:     ""
 ECHR ' '
 ERND 5
 EQUB VE

 ETOK 191               \ Token 73:     ""
 EQUB VE

 ETOK 192               \ Token 74:     ""
 EQUB VE

 ERND 13                \ Token 75:     ""
 ECHR ' '
 EJMP 18
 EQUB VE

 ECHR 'F'               \ Token 76:     ""
 ETWO 'A', 'B'
 ECHR 'U'
 ECHR 'L'
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

 ECHR 'E'               \ Token 77:     ""
 ECHR 'X'
 ECHR 'O'
 ETWO 'T', 'I'
 ECHR 'C'
 EQUB VE

 ECHR 'H'               \ Token 78:     ""
 ECHR 'O'
 ECHR 'O'
 ECHR 'P'
 ECHR 'Y'
 EQUB VE

 ETOK 132               \ Token 79:     ""
 EQUB VE

 ECHR 'E'               \ Token 80:     ""
 ECHR 'X'
 ECHR 'C'
 ETWO 'I', 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ECHR 'C'               \ Token 81:     ""
 ECHR 'U'
 ECHR 'I'
 ECHR 'S'
 ETWO 'I', 'N'
 ECHR 'E'
 EQUB VE

 ECHR 'N'               \ Token 82:     ""
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'F'
 ECHR 'E'
 EQUB VE

 ECHR 'C'               \ Token 83:     ""
 ECHR 'A'
 ECHR 'S'
 ECHR 'I'
 ETWO 'N', 'O'
 ECHR 'S'
 EQUB VE

 ECHR 'C'               \ Token 84:     ""
 ETWO 'I', 'N'
 ECHR 'E'
 ETWO 'M', 'A'
 ECHR 'S'
 EQUB VE

 EJMP 2                 \ Token 85:     ""
 ERND 31
 EJMP 13
 EQUB VE

 EJMP 3                 \ Token 86:     ""
 EQUB VE

 ETOK 147               \ Token 87:     ""
 ETOK 145
 ECHR ' '
 EJMP 3
 EQUB VE

 ETOK 147               \ Token 88:     ""
 ETOK 146
 ECHR ' '
 EJMP 3
 EQUB VE

 ETOK 148               \ Token 89:     ""
 ETOK 145
 EQUB VE

 ETOK 148               \ Token 90:     ""
 ETOK 146
 EQUB VE

 ECHR 'S'               \ Token 91:     ""
 ECHR 'W'
 ETWO 'I', 'N'
 ECHR 'E'
 EQUB VE

 ECHR 'S'               \ Token 92:     ""
 ECHR 'C'
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'D'
 ETWO 'R', 'E'
 ECHR 'L'
 EQUB VE

 ECHR 'B'               \ Token 93:     ""
 ETWO 'L', 'A'
 ECHR 'C'
 ECHR 'K'
 ECHR 'G'
 ECHR 'U'
 ETWO 'A', 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'R'               \ Token 94:     ""
 ECHR 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
 EQUB VE

 ECHR 'W'               \ Token 95:     ""
 ECHR 'R'
 ETWO 'E', 'T'
 ECHR 'C'
 ECHR 'H'
 EQUB VE

 ECHR 'N'               \ Token 96:     ""
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'R', 'E'
 ECHR 'M'
 ETWO 'A', 'R'
 ECHR 'K'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR ' '               \ Token 97:     ""
 ECHR 'B'
 ETWO 'O', 'R'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ECHR ' '               \ Token 98:     ""
 ECHR 'D'
 ECHR 'U'
 ECHR 'L'
 ECHR 'L'
 EQUB VE

 ECHR ' '               \ Token 99:     ""
 ECHR 'T'
 ECHR 'E'
 ETWO 'D', 'I'
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

 ECHR ' '               \ Token 100:    ""
 ETWO 'R', 'E'
 ECHR 'V'
 ECHR 'O'
 ECHR 'L'
 ECHR 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ETOK 145               \ Token 101:    ""
 EQUB VE

 ETOK 146               \ Token 102:    ""
 EQUB VE

 ECHR 'P'               \ Token 103:    ""
 ETWO 'L', 'A'
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'L'               \ Token 104:    ""
 ETWO 'I', 'T'
 ECHR 'T'
 ETWO 'L', 'E'
 ECHR ' '
 ETOK 145
 EQUB VE

 ECHR 'D'               \ Token 105:    ""
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 EQUB VE

 EJMP 19                \ Token 106:    ""
 ECHR 'I'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'A', 'R'
 ETOK 208
 ERND 23
 ECHR ' '
 ETWO 'L', 'O'
 ECHR 'O'
 ECHR 'K'
 ETOK 195
 ETOK 207
 ECHR ' '
 ECHR 'A'
 ECHR 'P'
 ECHR 'P'
 ECHR 'E'
 ETWO 'A', 'R'
 ETOK 196
 ETWO 'A', 'T'
 ETOK 209
 EQUB VE

 EJMP 19                \ Token 107:    ""
 ECHR 'Y'
 ECHR 'E'
 ECHR 'A'
 ECHR 'H'
 ECHR ','
 EJMP 26
 ECHR 'I'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'A', 'R'
 ETOK 208
 ERND 23
 ECHR ' '
 ETOK 207
 ECHR ' '
 ETWO 'L', 'E'
 ECHR 'F'
 ECHR 'T'
 ETOK 209
 ETOK 208
 ECHR ' '
 ECHR 'W'
 ECHR 'H'
 ETWO 'I', 'L'
 ECHR 'E'
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 EQUB VE

 EJMP 19                \ Token 108:    ""
 ECHR 'G'
 ETWO 'E', 'T'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ECHR 'I'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ETOK 209
 EQUB VE

 ETWO 'S', 'O'          \ Token 109:    ""
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ERND 24
 ETOK 210
 ETOK 207
 ECHR ' '
 ECHR 'W'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'A', 'T'
 ETOK 209
 EQUB VE

 ECHR 'T'               \ Token 110:    ""
 ECHR 'R'
 ECHR 'Y'
 ETOK 209
 EQUB VE

 ECHR ' '               \ Token 111:    ""
 ECHR 'C'
 ECHR 'U'
 ECHR 'D'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 ECHR ' '               \ Token 112:    ""
 ECHR 'C'
 ECHR 'U'
 ECHR 'T'
 ECHR 'E'
 EQUB VE

 ECHR ' '               \ Token 113:    ""
 ECHR 'F'
 ECHR 'U'
 ECHR 'R'
 ECHR 'R'
 ECHR 'Y'
 EQUB VE

 ECHR ' '               \ Token 114:    ""
 ECHR 'F'
 ECHR 'R'
 ECHR 'I'
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 ECHR 'W'               \ Token 115:    ""
 ECHR 'A'
 ECHR 'S'
 ECHR 'P'
 EQUB VE

 ECHR 'M'               \ Token 116:    ""
 ECHR 'O'
 ETWO 'T', 'H'
 EQUB VE

 ECHR 'G'               \ Token 117:    ""
 ECHR 'R'
 ECHR 'U'
 ECHR 'B'
 EQUB VE

 ETWO 'A', 'N'          \ Token 118:    ""
 ECHR 'T'
 EQUB VE

 EJMP 18                \ Token 119:    ""
 EQUB VE

 ECHR 'P'               \ Token 120:    ""
 ECHR 'O'
 ETWO 'E', 'T'
 EQUB VE

 ECHR 'H'               \ Token 121:    ""
 ECHR 'O'
 ECHR 'G'
 EQUB VE

 ECHR 'Y'               \ Token 122:    ""
 ECHR 'A'
 ECHR 'K'
 EQUB VE

 ECHR 'S'               \ Token 123:    ""
 ECHR 'N'
 ECHR 'A'
 ETWO 'I', 'L'
 EQUB VE

 ECHR 'S'               \ Token 124:    ""
 ECHR 'L'
 ECHR 'U'
 ECHR 'G'
 EQUB VE

 ECHR 'T'               \ Token 125:    ""
 ECHR 'R'
 ECHR 'O'
 ECHR 'P'
 ECHR 'I'
 ECHR 'C'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'D'               \ Token 126:    ""
 ETWO 'E', 'N'
 ETWO 'S', 'E'
 EQUB VE

 ETWO 'R', 'A'          \ Token 127:    ""
 ETWO 'I', 'N'
 EQUB VE

 ECHR 'I'               \ Token 128:    ""
 ECHR 'M'
 ECHR 'P'
 ETWO 'E', 'N'
 ETWO 'E', 'T'
 ECHR 'R'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'E'               \ Token 129:    ""
 ECHR 'X'
 ECHR 'U'
 ECHR 'B'
 ETWO 'E', 'R'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'F'               \ Token 130:    ""
 ECHR 'U'
 ECHR 'N'
 ECHR 'N'
 ECHR 'Y'
 EQUB VE

 ECHR 'W'               \ Token 131:    ""
 ECHR 'E'
 ECHR 'I'
 ECHR 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'U'               \ Token 132:    ""
 ETWO 'N', 'U'
 ECHR 'S'
 ECHR 'U'
 ETWO 'A', 'L'
 EQUB VE

 ETWO 'S', 'T'          \ Token 133:    ""
 ETWO 'R', 'A'
 ECHR 'N'
 ETWO 'G', 'E'
 EQUB VE

 ECHR 'P'               \ Token 134:    ""
 ECHR 'E'
 ECHR 'C'
 ECHR 'U'
 ECHR 'L'
 ECHR 'I'
 ETWO 'A', 'R'
 EQUB VE

 ECHR 'F'               \ Token 135:    ""
 ETWO 'R', 'E'
 ETWO 'Q', 'U'
 ETWO 'E', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'O'               \ Token 136:    ""
 ECHR 'C'
 ECHR 'C'
 ECHR 'A'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'U'               \ Token 137:    ""
 ECHR 'N'
 ECHR 'P'
 ETWO 'R', 'E'
 ETWO 'D', 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'D'               \ Token 138:    ""
 ETWO 'R', 'E'
 ECHR 'A'
 ECHR 'D'
 ECHR 'F'
 ECHR 'U'
 ECHR 'L'
 EQUB VE

 ETOK 171               \ Token 139:    ""
 EQUB VE

 ERND 1                 \ Token 140:    ""
 ECHR ' '
 ERND 0
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ERND 10
 EQUB VE

 ETOK 140               \ Token 141:    ""
 ETOK 178
 ERND 10
 EQUB VE

 ERND 11                \ Token 142:    ""
 ECHR ' '
 ECHR 'B'
 ECHR 'Y'
 ECHR ' '
 ERND 12
 EQUB VE

 ETOK 140               \ Token 143:    ""
 ECHR ' '
 ECHR 'B'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ETOK 142
 EQUB VE

 ECHR ' '               \ Token 144:    ""
 ECHR 'A'
 ERND 20
 ECHR ' '
 ERND 21
 EQUB VE

 ECHR 'P'               \ Token 145:    ""
 ETWO 'L', 'A'
 ECHR 'N'
 ETWO 'E', 'T'
 EQUB VE

 ECHR 'W'               \ Token 146:    ""
 ETWO 'O', 'R'
 ECHR 'L'
 ECHR 'D'
 EQUB VE

 ETWO 'T', 'H'          \ Token 147:    ""
 ECHR 'E'
 ECHR ' '
 EQUB VE

 ETWO 'T', 'H'          \ Token 148:    ""
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 149:    ""

 EJMP 9                 \ Token 150:    ""
 EJMP 11
 EJMP 1
 EJMP 8
 EQUB VE

 EQUB VE                \ Token 151:    ""

 EQUB VE                \ Token 152:    ""

 ECHR 'I'               \ Token 153:    ""
 ETWO 'A', 'N'
 EQUB VE

 EJMP 19                \ Token 154:    ""
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 EQUB VE

 ERND 13                \ Token 155:    ""
 EQUB VE

 ECHR 'M'               \ Token 156:    ""
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 EQUB VE

 ECHR 'E'               \ Token 157:    ""
 ETWO 'D', 'I'
 ECHR 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'T'               \ Token 158:    ""
 ETWO 'R', 'E'
 ECHR 'E'
 EQUB VE

 ECHR 'S'               \ Token 159:    ""
 ECHR 'P'
 ECHR 'O'
 ECHR 'T'
 ECHR 'T'
 ETWO 'E', 'D'
 EQUB VE

 ERND 29                \ Token 160:    ""
 EQUB VE

 ERND 30                \ Token 161:    ""
 EQUB VE

 ERND 6                 \ Token 162:    ""
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 EQUB VE

 ERND 36                \ Token 163:    ""
 EQUB VE

 ERND 35                \ Token 164:    ""
 EQUB VE

 ETWO 'A', 'N'          \ Token 165:    ""
 ECHR 'C'
 ECHR 'I'
 ETWO 'E', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'E'               \ Token 166:    ""
 ECHR 'X'
 ETWO 'C', 'E'
 ECHR 'P'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'E'               \ Token 167:    ""
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 EQUB VE

 ETWO 'I', 'N'          \ Token 168:    ""
 ECHR 'G'
 ETWO 'R', 'A'
 ETWO 'I', 'N'
 ETWO 'E', 'D'
 EQUB VE

 ERND 23                \ Token 169:    ""
 EQUB VE

 ECHR 'K'               \ Token 170:    ""
 ETWO 'I', 'L'
 ETWO 'L', 'E'
 ECHR 'R'
 EQUB VE

 ECHR 'D'               \ Token 171:    ""
 ECHR 'E'
 ECHR 'A'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 ECHR 'W'               \ Token 172:    ""
 ECHR 'I'
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'D'
 EQUB VE

 ECHR 'L'               \ Token 173:    ""
 ETWO 'E', 'T'
 ECHR 'H'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'V'               \ Token 174:    ""
 ECHR 'I'
 ECHR 'C'
 ECHR 'I'
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

 ETWO 'I', 'T'          \ Token 175:    ""
 ECHR 'S'
 ECHR ' '
 EQUB VE

 EJMP 13                \ Token 176:    ""
 EJMP 14
 EJMP 19
 EQUB VE

 ECHR '.'               \ Token 177:    ""
 EJMP 12
 EJMP 15
 EQUB VE

 ECHR ' '               \ Token 178:    ""
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
 EQUB VE

 ECHR 'Y'               \ Token 179:    ""
 ETWO 'O', 'U'
 EQUB VE

 ECHR 'P'               \ Token 180:    ""
 ETWO 'A', 'R'
 ECHR 'K'
 ETOK 195
 ECHR 'M'
 ETWO 'E', 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'D'               \ Token 181:    ""
 ECHR 'U'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'C'
 ECHR 'L'
 ETWO 'O', 'U'
 ECHR 'D'
 ECHR 'S'
 EQUB VE

 ECHR 'I'               \ Token 182:    ""
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'B'
 ETWO 'E', 'R'
 ECHR 'G'
 ECHR 'S'
 EQUB VE

 ECHR 'R'               \ Token 183:    ""
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETWO 'M', 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

 ECHR 'V'               \ Token 184:    ""
 ECHR 'O'
 ECHR 'L'
 ECHR 'C'
 ECHR 'A'
 ETWO 'N', 'O'
 ETWO 'E', 'S'
 EQUB VE

 ECHR 'P'               \ Token 185:    ""
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'T'               \ Token 186:    ""
 ECHR 'U'
 ECHR 'L'
 ECHR 'I'
 ECHR 'P'
 EQUB VE

 ECHR 'B'               \ Token 187:    ""
 ETWO 'A', 'N'
 ETWO 'A', 'N'
 ECHR 'A'
 EQUB VE

 ECHR 'C'               \ Token 188:    ""
 ETWO 'O', 'R'
 ECHR 'N'
 EQUB VE

 EJMP 18                \ Token 189:    ""
 ECHR 'W'
 ECHR 'E'
 ETWO 'E', 'D'
 EQUB VE

 EJMP 18                \ Token 190:    ""
 EQUB VE

 EJMP 17                \ Token 191:    ""
 ECHR ' '
 EJMP 18
 EQUB VE

 EJMP 17                \ Token 192:    ""
 ECHR ' '
 ERND 13
 EQUB VE

 ETWO 'I', 'N'          \ Token 193:    ""
 ECHR 'H'
 ETWO 'A', 'B'
 ETWO 'I', 'T'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

 ETOK 191               \ Token 194:    ""
 EQUB VE

 ETWO 'I', 'N'          \ Token 195:    ""
 ECHR 'G'
 ECHR ' '
 EQUB VE

 ETWO 'E', 'D'          \ Token 196:    ""
 ECHR ' '
 EQUB VE

 EJMP 26                \ Token 197:    ""
 ECHR 'D'
 ECHR '.'
 EJMP 19
 ECHR 'B'
 ECHR 'R'
 ETWO 'A', 'B'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR '&'
 EJMP 26
 ECHR 'I'
 ECHR '.'
 EJMP 19
 ETWO 'B', 'E'
 ECHR 'L'
 ECHR 'L'
 EQUB VE

 ECHR ' '               \ Token 198:    ""
 ECHR 'L'
 ETWO 'I', 'T'
 ECHR 'T'
 ETWO 'L', 'E'
 EJMP 26
 ECHR 'S'
 ETWO 'Q', 'U'
 ECHR 'E'
 ECHR 'A'
 ECHR 'K'
 ECHR 'Y'
 EQUB VE

 EJMP 25                \ Token 199:    ""
 EJMP 9
 EJMP 29
 EJMP 14
 EJMP 13
 EJMP 19
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ECHR 'Y'
 ECHR ' '
 ETOK 154
 ECHR ' '
 EJMP 4
 ECHR ','
 ECHR ' '
 ETWO 'A', 'L'
 ETWO 'L', 'O'
 ECHR 'W'
 ECHR ' '
 ECHR 'M'
 ECHR 'E'
 ETOK 201
 ETWO 'I', 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'O'
 ECHR 'D'
 ECHR 'U'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'F'
 ECHR '.'
 EJMP 26
 ECHR 'I'
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 EJMP 26
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'M'
 ETWO 'E', 'R'
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ECHR 'T'
 EJMP 26
 ECHR 'P'
 ECHR 'R'
 ETWO 'I', 'N'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 EJMP 26
 ETWO 'T', 'H'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'D'
 EJMP 26
 ECHR 'I'
 EJMP 26
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'F'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETWO 'C', 'E'
 ECHR 'D'
 ETOK 201
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'E'
 ECHR 'A'
 ECHR 'S'
 ECHR 'U'
 ETWO 'R', 'E'
 ECHR 'D'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETOK 204
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 ETWO 'E', 'R'
 ETOK 195
 ETOK 179
 ECHR ','
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 147
 ECHR 'P'
 ETWO 'A', 'L'
 ECHR 'T'
 ECHR 'R'
 ECHR 'Y'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'J'
 ECHR 'U'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR '5'
 ECHR '0'
 ECHR '0'
 ECHR '0'
 EJMP 19
 ECHR 'C'
 EJMP 19
 ECHR 'R'
 ECHR ' '
 ETOK 147
 ECHR 'R'
 ETWO 'A', 'R'
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ETOK 195
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 EJMP 26
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ECHR 'V'
 ETWO 'E', 'R'
 ETWO 'S', 'E'
 ETOK 204
 EJMP 19
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'T'
 ECHR 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR '?'
 EJMP 12
 EJMP 15
 EJMP 1
 EJMP 8
 EQUB VE

 EJMP 26                \ Token 200:    ""
 ECHR 'N'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 ECHR '?'
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 201:    ""
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 202:    ""
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 EQUB VE

 ECHR 'W'               \ Token 203:    ""
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 EJMP 19
 EQUB VE

 ECHR '.'               \ Token 204:    ""
 EJMP 12
 EJMP 12
 ECHR ' '
 EJMP 19
 EQUB VE

 EJMP 19                \ Token 205:    ""
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'D'
 EQUB VE

 EQUB VE                \ Token 206:    ""

 ECHR 'S'               \ Token 207:    ""
 ECHR 'H'
 ECHR 'I'
 ECHR 'P'
 EQUB VE

 ECHR ' '               \ Token 208:    ""
 ECHR 'A'
 ECHR ' '
 EQUB VE

 EJMP 26                \ Token 209:    ""
 ETWO 'E', 'R'
 ECHR 'R'
 ECHR 'I'
 ETWO 'U', 'S'
 EQUB VE

 ECHR ' '               \ Token 210:    ""
 ECHR 'N'
 ECHR 'E'
 ECHR 'W'
 ECHR ' '
 EQUB VE

 EJMP 26                \ Token 211:    ""
 ECHR 'H'
 ETWO 'E', 'R'
 EJMP 26
 ETWO 'M', 'A'
 ECHR 'J'
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR 'Y'
 ECHR '`'
 ECHR 'S'
 EJMP 26
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 EJMP 26
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'Y'
 EQUB VE

 ETOK 177               \ Token 212:    ""
 EJMP 12
 EJMP 8
 EJMP 1
 ECHR ' '
 EJMP 26
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 EJMP 26
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'S'
 EQUB VE

 ECHR ' '               \ Token 213:    ""
 ETOK 154
 ECHR ' '
 EJMP 4
 ECHR ','
 EJMP 26
 ECHR 'I'
 ECHR ' '
 EJMP 13
 ECHR 'A'
 ECHR 'M'
 EJMP 26
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ECHR ' '
 EJMP 27
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ETOK 211
 EQUB VE

 EQUB VE                \ Token 214:    ""

 EJMP 15                \ Token 215:    ""
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 ECHR ' '
 ETOK 145
 EQUB VE

 EJMP 9                 \ Token 216:    ""
 EJMP 8
 EJMP 23
 EJMP 1
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ETOK 195
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 EQUB VE

 EJMP 19                \ Token 217:    ""
 ECHR 'C'
 ECHR 'U'
 ECHR 'R'
 ECHR 'R'
 ECHR 'U'
 ETWO 'T', 'H'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 EJMP 19                \ Token 218:    ""
 ECHR 'F'
 ECHR 'O'
 ECHR 'S'
 ECHR 'D'
 ECHR 'Y'
 ECHR 'K'
 ECHR 'E'
 EJMP 26
 ECHR 'S'
 ECHR 'M'
 ECHR 'Y'
 ETWO 'T', 'H'
 ECHR 'E'
 EQUB VE

 EJMP 19                \ Token 219:    ""
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR 'T'
 ETWO 'E', 'S'
 ETWO 'Q', 'U'
 ECHR 'E'
 EQUB VE

 ETOK 203               \ Token 220:    ""
 EJMP 19
 ETWO 'R', 'E'
 ETWO 'E', 'S'
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'I'               \ Token 221:    ""
 ECHR 'S'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'L'
 ECHR 'I'
 ECHR 'E'
 ETWO 'V', 'E'
 ECHR 'D'
 ETOK 201
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ETOK 196
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ETOK 148
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'Y'
 EQUB VE

 EJMP 25                \ Token 222:    ""
 EJMP 9
 EJMP 29
 EJMP 14
 EJMP 13
 EJMP 19
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ECHR 'Y'
 ECHR ' '
 ETOK 154
 ECHR ' '
 EJMP 4
 ETOK 204
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 EJMP 26
 ECHR 'A'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR 'T'
 EJMP 26
 ECHR 'B'
 ETWO 'L', 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 EJMP 26
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ETWO 'A', 'L'
 EJMP 26
 ETWO 'I', 'N'
 ECHR 'T'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR 'I'
 ETWO 'G', 'E'
 ECHR 'N'
 ETWO 'C', 'E'
 ETOK 204
 EJMP 19
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR ','
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'Y'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'K'
 ECHR 'E'
 ECHR 'E'
 ECHR 'P'
 ETOK 195
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ETWO 'T', 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'N'
 EJMP 26
 ECHR 'D'
 ECHR 'E'
 ECHR 'E'
 ECHR 'P'
 EJMP 26
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'Y'
 ECHR ' '
 ECHR 'Y'
 ECHR 'E'
 ETWO 'A', 'R'
 ECHR 'S'
 ECHR ' '
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR '.'
 EJMP 26
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETOK 147
 ECHR 'S'
 ETWO 'I', 'T'
 ECHR 'U'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ETWO 'G', 'E'
 ECHR 'D'
 ETOK 204
 EJMP 19
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 ECHR 'B'
 ECHR 'O'
 ECHR 'Y'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'A'
 ECHR 'D'
 ECHR 'Y'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETOK 208
 ECHR 'P'
 ETWO 'U', 'S'
 ECHR 'H'
 ECHR ' '
 ECHR 'R'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ETOK 201
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'H'
 ECHR 'O'
 ECHR 'M'
 ECHR 'E'
 EJMP 26
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'O'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'M'
 ECHR 'U'
 ECHR 'R'
 ECHR 'D'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR 'R'
 ECHR 'S'
 ETOK 204
 EJMP 19
 ECHR 'I'
 EJMP 13
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'B'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ETOK 196
 ETOK 147
 ECHR 'D'
 ECHR 'E'
 ECHR 'F'
 ETWO 'E', 'N'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR 'I'
 ECHR 'R'
 EJMP 26
 ECHR 'H'
 ECHR 'I'
 ETWO 'V', 'E'
 EJMP 26
 ETOK 146
 ECHR 'S'
 ETOK 204
 EJMP 24
 EJMP 9
 EJMP 29
 EJMP 19
 ETOK 147
 ETWO 'B', 'E'
 ETWO 'E', 'T'
 ETWO 'L', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR '`'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'G'
 ECHR 'O'
 ECHR 'T'
 ECHR ' '
 ETWO 'S', 'O'
 ECHR 'M'
 ETWO 'E', 'T'
 ECHR 'H'
 ETOK 195
 ECHR 'B'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'N', 'O'
 ECHR 'T'
 ECHR ' '
 ECHR 'W'
 ECHR 'H'
 ETWO 'A', 'T'
 ETOK 204
 EJMP 19
 ECHR 'I'
 ECHR 'F'
 EJMP 26
 ECHR 'I'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR 'M'
 ETWO 'I', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ETOK 201
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'O', 'N'
 EJMP 26
 ETWO 'B', 'I'
 ETWO 'R', 'E'
 ETWO 'R', 'A'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR 'Y'
 ECHR '`'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ECHR ' '
 ETOK 147
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
 EJMP 26
 ECHR 'I'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETOK 196
 ECHR 'A'
 ECHR ' '
 ETOK 207
 ETOK 201
 ETWO 'M', 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ETOK 147
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ETOK 204
 EJMP 19
 ETOK 179
 ECHR '`'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'E'
 ETWO 'L', 'E'
 ECHR 'C'
 ECHR 'T'
 ETWO 'E', 'D'
 ETOK 204
 ETOK 147
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 EJMP 26
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ECHR 'P'
 ECHR 'U'
 ECHR 'L'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'D'
 ETOK 196
 ECHR 'W'
 ETWO 'I', 'T'
 ECHR 'H'
 ETWO 'I', 'N'
 ECHR ' '
 ETOK 148
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
 EJMP 26
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'I'
 ECHR 'D'
 ETOK 204
 ECHR ' '
 ECHR ' '
 ECHR ' '
 EJMP 26
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'L'
 ECHR 'U'
 ECHR 'C'
 ECHR 'K'
 ECHR ' '
 ETOK 154
 ETOK 212
 EJMP 24
 EQUB VE

 EJMP 25                \ Token 223:    ""
 EJMP 9
 EJMP 29
 EJMP 8
 EJMP 14
 EJMP 13
 EJMP 19
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'D'
 ETWO 'O', 'N'
 ECHR 'E'
 ECHR ' '
 ETOK 154
 ETOK 204
 ETOK 179
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'R'
 ETWO 'V', 'E'
 ECHR 'D'
 ECHR ' '
 ETWO 'U', 'S'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ETOK 178
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ETWO 'A', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'M'
 ECHR 'E'
 ECHR 'M'
 ECHR 'B'
 ETWO 'E', 'R'
 ETOK 204
 EJMP 19
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'D'
 ECHR ' '
 ETWO 'N', 'O'
 ECHR 'T'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ECHR 'P'
 ECHR 'E'
 ECHR 'C'
 ECHR 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ETWO 'T', 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ETOK 201
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'A', 'B'
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETOK 179
 ETOK 204
 EJMP 19
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 147
 ECHR 'M'
 ECHR 'O'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'P'
 ETWO 'L', 'E'
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'I'
 ECHR 'S'
 EJMP 26
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'Y'
 ECHR ' '
 EJMP 6
 ERND 23
 EJMP 5
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'Y'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ETOK 212
 EJMP 24
 EQUB VE

 EQUB VE                \ Token 224:    ""

 ECHR 'S'               \ Token 225:    ""
 ECHR 'H'
 ETWO 'R', 'E'
 ECHR 'W'
 EQUB VE

 ETWO 'B', 'E'          \ Token 226:    ""
 ECHR 'A'
 ETWO 'S', 'T'
 EQUB VE

 ECHR 'G'               \ Token 227:    ""
 ETWO 'N', 'U'
 EQUB VE

 ECHR 'S'               \ Token 228:    ""
 ECHR 'N'
 ECHR 'A'
 ECHR 'K'
 ECHR 'E'
 EQUB VE

 ECHR 'D'               \ Token 229:    ""
 ECHR 'O'
 ECHR 'G'
 EQUB VE

 ETWO 'L', 'E'          \ Token 230:    ""
 ECHR 'O'
 ECHR 'P'
 ETWO 'A', 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'C'               \ Token 231:    ""
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'M'               \ Token 232:    ""
 ETWO 'O', 'N'
 ECHR 'K'
 ECHR 'E'
 ECHR 'Y'
 EQUB VE

 ECHR 'G'               \ Token 233:    ""
 ECHR 'O'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'C'               \ Token 234:    ""
 ETWO 'A', 'R'
 ECHR 'P'
 EQUB VE

 ERND 15                \ Token 235:    ""
 ECHR ' '
 ERND 14
 EQUB VE

 EJMP 17                \ Token 236:    ""
 ECHR ' '
 ERND 29
 ECHR ' '
 ERND 32
 EQUB VE

 ETOK 175               \ Token 237:    ""
 ERND 16
 ECHR ' '
 ERND 30
 ECHR ' '
 ERND 32
 EQUB VE

 ERND 33                \ Token 238:    ""
 ECHR ' '
 ERND 34
 EQUB VE

 ERND 15                \ Token 239:    ""
 ECHR ' '
 ERND 14
 EQUB VE

 ECHR 'M'               \ Token 240:    ""
 ECHR 'E'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'C'               \ Token 241:    ""
 ECHR 'U'
 ECHR 'T'
 ECHR 'L'
 ETWO 'E', 'T'
 EQUB VE

 ETWO 'S', 'T'          \ Token 242:    ""
 ECHR 'E'
 ECHR 'A'
 ECHR 'K'
 EQUB VE

 ECHR 'B'               \ Token 243:    ""
 ECHR 'U'
 ECHR 'R'
 ETWO 'G', 'E'
 ECHR 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 244:    ""
 ETWO 'O', 'U'
 ECHR 'P'
 EQUB VE

 ECHR 'I'               \ Token 245:    ""
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'M'               \ Token 246:    ""
 ECHR 'U'
 ECHR 'D'
 EQUB VE

 ECHR 'Z'               \ Token 247:    ""
 ETWO 'E', 'R'
 ECHR 'O'
 ECHR '-'
 EJMP 19
 ECHR 'G'
 EQUB VE

 ECHR 'V'               \ Token 248:    ""
 ECHR 'A'
 ECHR 'C'
 ECHR 'U'
 ECHR 'U'
 ECHR 'M'
 EQUB VE

 EJMP 17                \ Token 249:    ""
 ECHR ' '
 ECHR 'U'
 ECHR 'L'
 ECHR 'T'
 ETWO 'R', 'A'
 EQUB VE

 ECHR 'H'               \ Token 250:    ""
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ECHR 'E'
 ECHR 'Y'
 EQUB VE

 ECHR 'C'               \ Token 251:    ""
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'T'
 EQUB VE

 ECHR 'K'               \ Token 252:    ""
 ETWO 'A', 'R'
 ETWO 'A', 'T'
 ECHR 'E'
 EQUB VE

 ECHR 'P'               \ Token 253:    ""
 ECHR 'O'
 ETWO 'L', 'O'
 EQUB VE

 ECHR 'T'               \ Token 254:    ""
 ETWO 'E', 'N'
 ECHR 'N'
 ECHR 'I'
 ECHR 'S'
 EQUB VE

 EQUB VE                \ Token 255:    ""

INCLUDE "library/enhanced/main/variable/rupla.asm"
INCLUDE "library/enhanced/main/variable/rugal.asm"
INCLUDE "library/enhanced/main/variable/rutok.asm"
INCLUDE "library/nes/main/variable/tkn1_de.asm"
INCLUDE "library/nes/main/variable/rupla_de.asm"
INCLUDE "library/nes/main/variable/rugal_de.asm"
INCLUDE "library/nes/main/variable/rutok_de.asm"
INCLUDE "library/nes/main/variable/tkn1_fr.asm"
INCLUDE "library/nes/main/variable/rupla_fr.asm"
INCLUDE "library/nes/main/variable/rugal_fr.asm"
INCLUDE "library/nes/main/variable/rutok_fr.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/nes/main/variable/qq18_de.asm"
INCLUDE "library/nes/main/variable/qq18_fr.asm"
INCLUDE "library/nes/main/variable/rutok_lo.asm"
INCLUDE "library/nes/main/variable/rutok_hi.asm"
INCLUDE "library/enhanced/main/subroutine/detok3.asm"
INCLUDE "library/enhanced/main/subroutine/detok.asm"
INCLUDE "library/enhanced/main/subroutine/detok2.asm"
INCLUDE "library/enhanced/main/variable/jmtb.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"
INCLUDE "library/enhanced/main/subroutine/mt27.asm"
INCLUDE "library/enhanced/main/subroutine/mt28.asm"
INCLUDE "library/enhanced/main/subroutine/mt1.asm"
INCLUDE "library/enhanced/main/subroutine/mt2.asm"
INCLUDE "library/enhanced/main/subroutine/mt8.asm"
INCLUDE "library/enhanced/main/subroutine/mt16.asm"
INCLUDE "library/master/main/subroutine/filepr.asm"
INCLUDE "library/master/main/subroutine/otherfilepr.asm"
INCLUDE "library/enhanced/main/subroutine/mt9.asm"
INCLUDE "library/enhanced/main/subroutine/mt6.asm"
INCLUDE "library/enhanced/main/subroutine/mt5.asm"
INCLUDE "library/enhanced/main/subroutine/mt14.asm"
INCLUDE "library/enhanced/main/subroutine/mt15.asm"
INCLUDE "library/enhanced/main/subroutine/mt17.asm"
INCLUDE "library/enhanced/main/subroutine/mt18.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/enhanced/main/subroutine/mt19.asm"
INCLUDE "library/enhanced/main/subroutine/vowel.asm"
INCLUDE "library/enhanced/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/enhanced/main/subroutine/bris.asm"
INCLUDE "library/enhanced/main/subroutine/pause.asm"
INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/mt13.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"
INCLUDE "library/nes/main/variable/rupla_lo.asm"
INCLUDE "library/nes/main/variable/rupla_hi.asm"
INCLUDE "library/nes/main/variable/rugal_lo.asm"
INCLUDE "library/nes/main/variable/rugal_hi.asm"
INCLUDE "library/nes/main/variable/nru.asm"
INCLUDE "library/enhanced/main/subroutine/pdesc.asm"
INCLUDE "library/common/main/subroutine/tt27.asm"
INCLUDE "library/common/main/subroutine/tt42.asm"
INCLUDE "library/common/main/subroutine/tt41.asm"
INCLUDE "library/common/main/subroutine/qw.asm"
INCLUDE "library/common/main/subroutine/tt45.asm"
INCLUDE "library/common/main/subroutine/tt43.asm"
INCLUDE "library/common/main/subroutine/ex.asm"
INCLUDE "library/enhanced/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"

\ ******************************************************************************
\
\       Name: CHPR (Part 1 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor by poking into screen memory
\
\ ------------------------------------------------------------------------------
\
\ Print a character at the text cursor (XC, YC), do a beep, print a newline,
\ or delete left (backspace).
\
\ If the relevant font is already loaded into the pattern buffers, then this is
\ used as the tile pattern for the character, otherwise the pattern for the
\ character being printed is extracted from the fontImage table and into the
\ pattern buffer.
\
\ For fontStyle = 3, the pattern is always extracted from the fontImage table,
\ as it has different colour text (colour 3) than the normal font. This is used
\ when printing characters into 2x2 attribute blocks where printing the normal
\ font would result in the wrong colour text being shown.
\
\ Arguments:
\
\   A                   The character to be printed. Can be one of the
\                       following:
\
\                         * 7 (beep)
\
\                         * 10-13 (line feeds and carriage returns)
\
\                         * 32-95 (ASCII capital letters, numbers and
\                           punctuation)
\
\                         * 127 (delete the character to the left of the text
\                           cursor and move the cursor to the left)
\
\   XC                  Contains the text column to print at (the x-coordinate)
\
\   YC                  Contains the line number to print on (the y-coordinate)
\
\   fontStyle           Determines the font style:
\
\                         * 1 = normal font
\                        
\                         * 2 = highlight font
\                        
\                         * 3 = green text on a black background (colour 3 on
\                               background colour 0)
\
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.chpr1

 JMP chpr17             \ Jump to chpr17 to restore the registers and return
                        \ from the subroutine

.chpr2

 LDA #2                 \ Move the text cursor to row 2
 STA YC

 LDA K3                 \ Set A to the character to be printed

 JMP chpr4              \ Jump to chpr4 to print the character in A

.chpr3

 JMP chpr17             \ Jump to chpr17 to restore the registers and return
                        \ from the subroutine

 LDA #12                \ This instruction is never called, but it would set A
                        \ to a carriage return character and fall through into
                        \ CHPR to print the newline

.CHPR

 STA K3                 \ Store the A register in K3 so we can retrieve it below
                        \ (so K3 contains the number of the character to print)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3                 \ Store the A, X and Y registers, so we can restore
 STY YSAV2              \ them at the end (so they don't get changed by this
 STX XSAV2              \ routine)

 LDY QQ17               \ Load the QQ17 flag, which contains the text printing
                        \ flags

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ chpr3              \ chpr17 (via the JMP in chpr3) to restore the registers
                        \ and return from the subroutine using a tail call

.chpr4

 CMP #7                 \ If this is a beep character (A = 7), jump to chpr1,
 BEQ chpr1              \ which will emit the beep, restore the registers and
                        \ return from the subroutine

 CMP #32                \ If this is an ASCII character (A >= 32), jump to chpr6
 BCS chpr6              \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #10                \ If this is control code 10 (line feed) then jump to
 BEQ chpr5              \ chpr5, which will move down a line, restore the
                        \ registers and return from the subroutine

 LDX #1                 \ If we get here, then this is control code 11-13, of
 STX XC                 \ which only 13 is used. This code prints a newline,
                        \ which we can achieve by moving the text cursor
                        \ to the start of the line (carriage return) and down
                        \ one line (line feed). These two lines do the first
                        \ bit by setting XC = 1, and we then fall through into
                        \ the line feed routine that's used by control code 10

.chpr5

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ chpr3              \ to chpr17 (via the JMP in chpr3) to restore the
                        \ registers and return from the subroutine using a tail
                        \ call

 INC YC                 \ Increment the text cursor y-coordinate to move it
                        \ down one row

 BNE chpr3              \ Jump to chpr17 via chpr3 to restore the registers and
                        \ return from the subroutine using a tail call (this BNE
                        \ is effectively a JMP as Y will never be zero)

.chpr6

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95

 LDX XC                 \ If the text cursor is on a column of 30 or less, then
 CPX #31                \ we have space to print the character on the current
 BCC chpr7              \ row, so jump to chpr7 to skip the following

 LDX #1                 \ The text cursor has moved off the right end of the
 STX XC                 \ current line, so move the cursor back to column 1 and
 INC YC                 \ down to the next row

.chpr7

 LDX YC                 \ If the text cursor is on row 26 or less, then the
 CPX #27                \ cursor is on-screen, so jump to chpr8 to skip the
 BCC chpr8              \ following instruction

 JMP chpr2              \ The cursor is off the bottom of the screen, so jump to
                        \ chpr2 to move the cursor up to row 2 before printing
                        \ the character

.chpr8

 CMP #127               \ If the character to print is not ASCII 127, then jump
 BNE chpr9              \ to chpr9 to skip the following instruction

 JMP chpr21             \ Jump to chpr21 to delete the character to the left of
                        \ the text cursor

\ ******************************************************************************
\
\       Name: CHPR (Part 2 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Jump to the right part of the routine depending on whether the
\             font pattern we need is already loaded
\
\ ******************************************************************************

.chpr9

 INC XC                 \ Once we print the character, we want to move the text
                        \ cursor to the right, so we do this by incrementing
                        \ XC. Note that this doesn't have anything to do
                        \ with the actual printing below, we're just updating
                        \ the cursor so it's in the right position following
                        \ the print

                        \ Before printing, we need to work out whether the font
                        \ we need is already loaded into the pattern buffers,
                        \ which will depend on the view type

 LDA QQ11               \ If bits 4 and 5 of the view type are clear, then no
 AND #%00110000         \ fonts are loaded, so jump to chpr11 to print the
 BEQ chpr11             \ character by copying the relevant font pattern into
                        \ the pattern buffers

                        \ If we get here then we know that at least one of bits
                        \ 4 and 5 is set in QQ11, which means the normal font is
                        \ loaded

 LDY fontStyle          \ If fontStyle = 1, then we want to print text using the
 CPY #1                 \ normal font, so jump to chpr10 to use the normal font
 BEQ chpr10             \ in the pattern buffers, as we know the normal font is
                        \ loaded

                        \ If we get here we know that fontStyle is 2 or 3

 AND #%00100000         \ If bit 5 of the view type in QQ11 is clear, then the
 BEQ chpr11             \ highlight font is not loaded, so jump to chpr11 to
                        \ print the character by copying the relevant font
                        \ pattern into the pattern buffers

                        \ If we get here then bit 5 of the view type in QQ11
                        \ is set, so we know that both the normal and highlight
                        \ fonts are loaded
                        \
                        \ We also know that fontStyle = 2 or 3

 CPY #2                 \ If fontStyle = 3, then we want to print the character
 BNE chpr11             \ in green text on a black background (so we can't use
                        \ the normal font as that's in colour 1 on black and we
                        \ need to print in colour 3 on black), so jump to chpr11
                        \ to print the character by copying the relevant font
                        \ pattern into the pattern buffers

                        \ If we get here then fontStyle = 2, so we want to print
                        \ text using the highlight font and we know it is
                        \ loaded, so we can go ahead and use the loaded font for
                        \ our character

 LDA K3                 \ Set A to the character to be printed

 CLC                    \ Set A = A + 95
 ADC #95                \
                        \ The highlight font is loaded into pattern 161, which
                        \ is 95 more than the normal font at pattern 66, so this
                        \ points A to the correct character number in the
                        \ highlight font

 JMP chpr22             \ Jump to chpr22 to print the character using a font
                        \ that has already been loaded

.chpr10

                        \ If we get here then fontStyle = 1 and the highlight
                        \ font is loaded, so we can use that for our character

 LDA K3                 \ Set A to the character to be printed

 JMP chpr22             \ Jump to chpr22 to print the character using a font
                        \ that has already been loaded

\ ******************************************************************************
\
\       Name: CHPR (Part 3 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Draw a character into the pattern buffers to show the character
\             on-screen
\
\ ******************************************************************************

.chpr11

                        \ If we get here then at least one of these is true:
                        \
                        \   * No font is loaded
                        \
                        \   * fontStyle = 2 (so we want to print highlighted
                        \     text) but the highlight font is not loaded
                        \
                        \   * fontStyle = 3 (so we want to print text in colour
                        \     3 on background colour 0)
                        \
                        \ In all cases, we need to draw the pattern for the
                        \ character directly into the relevant pattern buffer,
                        \ as it isn't already available in a loaded font

 LDA K3                 \ If the character to print in K3 is not a space, jump
 CMP #' '               \ to chpr12 to skip the following instruction
 BNE chpr12

 JMP chpr17             \ We are printing a space, so jump to chpr17 to return
                        \ from the subroutine

.chpr12

 TAY                    \ Set Y to the character to print
                        \
                        \ Let's call the character number chr

                        \ We now want to calculate the address of the pattern
                        \ data for this character in the fontImage table, which
                        \ contains the font images in ASCII order, starting from
                        \ the space character (which maps to ASCII 32)
                        \
                        \ There are eight bytes in each character's pattern, so
                        \ the address we are after is therefore:
                        \
                        \   fontImage + (chr - 32) * 8
                        \
                        \ This calculation is optimised below to take advantage
                        \ of the fact that LO(fontImage) = &E8 = 29 * 8, so:
                        \
                        \   fontImage + (chr - 32) * 8
                        \ = HI(fontImage) * 256 + LO(fontImage) + (chr - 32) * 8
                        \ = HI(fontImage) * 256 + (29 * 8) + (chr - 32) * 8
                        \ = HI(fontImage) * 256 + (29 + chr - 32) * 8
                        \ = HI(fontImage) * 256 + (chr - 3) * 8
                        \
                        \ So that is what we calculate below

 CLC                    \ Set A = A - 3
 ADC #&FD               \       = chr - 3
                        \
                        \ This could also be done using SEC and SBC #3

 LDX #0                 \ Set P(2 1) = A * 8
 STX P+2                \            = (chr - 3) * 8
 ASL A                  \            = chr * 8 - 24
 ROL P+2
 ASL A
 ROL P+2
 ASL A
 ROL P+2
 ADC #0
 STA P+1

 LDA P+2                \ Set P(2 1) = P(2 1) + HI(fontImage) * 256
 ADC #HI(fontImage)     \            = HI(fontImage) * 256 + (chr - 3) * 8
 STA P+2                \
                        \
                        \ So P(2 1) is the address of the pattern data for the
                        \ character that we want to print

 LDA #0                 \ Set SC+1 = 0 (though this is never used as SC+1 is
 STA SC+1               \ overwritten again before it is used)

 LDA YC                 \ If the text cursor is not on row 0, jump to chpr13 to
 BNE chpr13             \ skip the following instruction

 JMP chpr31             \ The text cursor is on row 0, so jump to chpr31 to set
                        \ SC(1 0) to the correct address in the nametable buffer
                        \ and return to chpr15 below to draw the character

.chpr13

 LDA QQ11               \ If this is not the space view (i.e. QQ11 is non-zero)
 BNE chpr14             \ then jump to chpr14 to skip the following instruction

 JMP chpr28             \ This is the space view with no fonts loaded, so jump
                        \ to chpr28 to draw the character on-screen, merging the
                        \ text with whatever is already there

.chpr14

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDY XC                 \ Set Y to the column of the text cursor - 1
 DEY

 LDA (SC),Y             \ This has no effect, as chpr15 is the next label and
 BEQ chpr15             \ neither A nor the status flags are read before being
                        \ overwritten, but it checks whether the nametable entry
                        \ for the character we want to draw is empty (and then
                        \ does nothing if it is)

.chpr15

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ chpr17             \ to use for drawing characters, so jump to chpr17 to
                        \ return from the subroutine without printing anything

 CMP #255               \ If firstFreeTile = 255 then we have run out of tiles
 BEQ chpr17             \ to use for drawing characters, so jump to chpr17 to
                        \ return from the subroutine without printing anything

 STA (SC),Y             \ Otherwise firstFreeTile contains the number of the
 STA (SC2),Y            \ next available tile for drawing, so allocate this
                        \ tile to cover the character that we want to draw by
                        \ setting the nametable entry in both buffers to the
                        \ tile number we just fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ tile for drawing, so it can be added to the nametable
                        \ the next time we need to draw into a tile

 LDY fontStyle          \ If fontStyle = 1, jump to chpr18
 DEY
 BEQ chpr18

 DEY                    \ If fontStyle = 3, jump to chpr16
 BNE chpr16

 JMP chpr19             \ Otherwise fontStyle = 2, so jump to chpr19

.chpr16

                        \ If we get here then fontStyle = 3 and we need to
                        \ copy the pattern data for this character from the
                        \ address in P(2 1) into both pattern buffers 0 and 1

 TAY                    \ Set Y to the character to print

 LDX #HI(pattBuffer0)/8 \ Set SC2(1 0) = (pattBuffer0/8 A) * 8
 STX SC2+1              \              = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC2+1              \ So SC2(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC2+1              \ pattern data), which means SC2(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC2+1              \ we are drawing in pattern buffer 0
 STA SC2

 TYA                    \ Set A back to the character to print

 LDX #HI(pattBuffer1)/8 \ Set SC(1 0) = (pattBuffer1/8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing in pattern buffer 1
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer addresses
                        \ in SC(1 0) and SC2(1 0)

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY                    

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY                    

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY                    

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY                    

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY                    

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY                    

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY                    

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC2),Y            \ byte of the pattern buffers in SC(1 0) and SC2(1 0)
 STA (SC),Y           

.chpr17

 LDY YSAV2              \ We're done printing, so restore the values of the
 LDX XSAV2              \ X and Y registers that we saved above

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3                 \ Restore the value of the A register that we saved
                        \ above

 CLC                    \ Clear the C flag, so everything is back to how it was

 RTS                    \ Return from the subroutine

.chpr18

                        \ If we get here then fontStyle = 1 and we need to
                        \ copy the pattern data for this character from the
                        \ address in P(2 1) into pattern buffer 0

 LDX #HI(pattBuffer0)/8 \ Set SC(1 0) = (pattBuffer0/8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing in pattern buffer 0
 STA SC


 JMP chpr20             \ Jump to chpr20 to draw the pattern we need for our
                        \ text character into the pattern buffer

.chpr19

                        \ If we get here then fontStyle = 2 and we need to
                        \ copy the pattern data for this character from the
                        \ address in P(2 1) into pattern buffer 1

 LDX #HI(pattBuffer1)/8 \ Set SC(1 0) = (pattBuffer1/8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing in pattern buffer 1
 STA SC

.chpr20

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0)

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0)

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

\ ******************************************************************************
\
\       Name: CHPR (Part 4 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Process the delete character
\
\ ******************************************************************************

.chpr21

                        \ If we get here then we are printing ASCII 127, which
                        \ is the delete character

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDY XC                 \ Set Y to the text column of the text cursor, which
                        \ points to the character we want to delete (as we are
                        \ printing a delete character there)

 DEC XC                 \ Decrement XC to move the text cursor left by one
                        \ place, as we are deleting a character

 LDA #0                 \ Zero the Y-th nametable entry in nametable buffer 0
 STA (SC),Y             \ for the Y-th character on row YC, which deletes the
                        \ character that was there

 STA (SC2),Y            \ Zero the Y-th nametable entry in nametable buffer 1
                        \ for the Y-th character on row YC, which deletes the
                        \ character that was there

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

\ ******************************************************************************
\
\       Name: CHPR (Part 5 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print the character using a font that has already been loaded
\
\ ******************************************************************************

.chpr22

                        \ If we get here then one of these is true:
                        \
                        \   * The normal and highlight fonts are loaded
                        \     fontStyle = 2
                        \     A = character number + 95
                        \
                        \   * The normal font is loaded
                        \     fontStyle = 1
                        \     A = character number

 PHA                    \ Store A on the stack to we can retrieve it after the
                        \ call to GetRowNameAddress

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 PLA                    \ Retrieve the character number we stored on the stack
                        \ above

 CMP #' '               \ If we are printing a space, jump to chpr25
 BEQ chpr25

.chpr23

 CLC                    \ Convert the ASCII number in A to the pattern number in
 ADC asciiToPattern     \ the PPU of the corresponding character image, by
                        \ adding asciiToPattern (which gets set when the view
                        \ is set up)

.chpr24

 LDY XC                 \ Set Y to the column of the text cursor - 1
 DEY

 STA (SC),Y             \ Set the Y-th nametable entry in nametable buffer 0
                        \ for the Y-th character on row YC, to the tile pattern
                        \ number for our character from the loaded font

 STA (SC2),Y            \ Set the Y-th nametable entry in nametable buffer 1
                        \ for the Y-th character on row YC, to the tile pattern
                        \ number for our character from the loaded font

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr25

                        \ If we get here then we are printing a space

 LDY QQ11               \ If the view type in QQ11 is &9D (Long-range Chart with
 CPY #&9D               \ the normal font loaded), jump to chpr26 to use pattern
 BEQ chpr26             \ 0 as the space character

 CPY #&DF               \ If the view type in QQ11 is not &DF (Start screen with
 BNE chpr23             \ the normal font loaded), jump to chpr23 to convert
                        \ the ASCII number in A to the pattern number

.chpr26

 LDA #0                 \ This is either view &9D (Long-range Chart) or &DF
                        \ (Start screen), and in both these views the normal
                        \ font is loaded directly into the PPU at a different
                        \ pattern number to the other views, so we set A = 0 to
                        \ use as the space character, as that is always a blank
                        \ tile

 BEQ chpr24             \ Jump up to chpr24 to draw the character (this BEQ is
                        \ effectively a JMP as A is always zero)

\ ******************************************************************************
\
\       Name: CHPR (Part 6 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character in the space view when the relevant font is not
\             loaded, merging the text with whatever is already on-screen
\
\ ******************************************************************************

.chpr27

                        \ We jump here from below when the tile we are drawing
                        \ into is not empty

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0), using OR logic to merge the character with
                        \ the existing contents of the tile

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr28

                        \ If we get here then this is the space view with no
                        \ font loaded, and we have set up P(2 1) to point to the
                        \ pattern data for the character we want to draw

 LDA #0                 \ Set SC+1 = 0 to act as the high byte of SC(1 0) in the
 STA SC+1               \ calculation below

 LDA YC                 \ Set A to the current text cursor row

 BNE chpr29             \ If the cursor is in row 0, set A = 255 so the value
 LDA #255               \ of A + 1 is 0 in the calculation below

.chpr29

 CLC                    \ Set (SC+1 A) = (A + 1) * 16
 ADC #1
 ASL A
 ASL A
 ASL A
 ASL A
 ROL SC+1

 SEC                    \ Set SC(1 0) = (nameBufferHi 0) + (SC+1 A) * 2 + 1
 ROL A                  \             = (nameBufferHi 0) + (A + 1) * 32 + 1
 STA SC                 \
 LDA SC+1               \ So SC(1 0) points to the entry in the nametable buffer
 ROL A                  \ for the start of the row below the text cursor, plus 1
 ADC nameBufferHi
 STA SC+1

 LDY XC                 \ Set Y to the column of the text cursor, minus one
 DEY

                        \ So SC(1 0) + Y now points to the nametable entry of
                        \ the tile where we want to draw our character

 LDA (SC),Y             \ If the nametable entry for the tile is not empty, then
 BNE chpr27             \ jump up to chpr27 to draw our character into the
                        \ existing pattern for this tile

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ chpr30             \ to use for drawing characters, so jump to chpr17 via
                        \ chpr30 to return from the subroutine without printing
                        \ anything

 STA (SC),Y             \ Otherwise firstFreeTile contains the number of the
                        \ next available tile for drawing, so allocate this
                        \ tile to cover the character that we want to draw by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ tile for drawing, so it can be added to the nametable
                        \ the next time we need to draw into a tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0)

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0)


.chpr30

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr31

                        \ If we get here then this is the space view and the
                        \ text cursor is on row 0

 LDA #33                \ Set SC(1 0) to the address of tile 33 in the nametable
 STA SC                 \ buffer, which is the first tile on row 1
 LDA nameBufferHi
 STA SC+1

 LDY XC                 \ Set Y to the column of the text cursor - 1
 DEY

 JMP chpr15             \ Jump up to chpr15 to continue drawing the character

INCLUDE "library/nes/main/variable/lowercase.asm"
INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank2.bin
\
\ ******************************************************************************

 PRINT "S.bank2.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank2.bin", CODE%, P%, LOAD%
