\ ******************************************************************************
\
\ DISC ELITE RECURSIVE TEXT TOKEN FILE
\
\ Produces the binary file WORDS.bin that gets loaded by elite-loader3.asm.
\
\ The recursive token table is loaded at &254B and is moved down to &0400 as
\ part of elite-loader3.asm. The table binary also includes the sine and arctan
\ tables, so the three parts end up as follows:
\
\   * Recursive token table:    QQ18 = &0400 to &07C0
\   * Sine lookup table:        SNE  = &07C0 to &07DF
\   * Arctan lookup table:      ACT  = &07E0 to &07FF
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_DISC_DOCKED            = TRUE
_DISC_FLIGHT            = FALSE
_IB_DISC                = (_RELEASE = 1)
_STH_DISC               = (_RELEASE = 2)

CODE_WORDS% = &0400
LOAD_WORDS% = &254B

ORG CODE_WORDS%

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/ctrl.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"

\ ******************************************************************************
\
\ Save output/WORDS.bin
\
\ ******************************************************************************

PRINT "WORDS"
PRINT "Assembled at ", ~CODE_WORDS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_WORDS%)
PRINT "Execute at ", ~LOAD_WORDS%
PRINT "Reload at ", ~LOAD_WORDS%

PRINT "S.WORDS ",~CODE_WORDS%," ",~P%," ",~LOAD_WORDS%," ",~LOAD_WORDS%
SAVE "versions/disc/output/WORDS.bin", CODE_WORDS%, P%, LOAD_WORDS%
