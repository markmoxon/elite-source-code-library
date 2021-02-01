\ ******************************************************************************
\
\ DISC ELITE MISSILE SHIP BLUEPRINT FILE
\
\ Produces the binary file MISSILE.bin that gets loaded by elite-loader3.asm.
\
\ The missile blueprint is loaded at &254B and is moved up to &7F00 as part of
\ elite-loader3.asm.
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

CODE% = &7F00
LOAD% = &244B

ORG CODE%

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"

EQUB &04, &00           \ This is where the VEC variable lives, at &7FFE, and
                        \ these bytes are presumably noise included at the time
                        \ of compilation, as they get overwritten

\ ******************************************************************************
\
\ Save output/WORDS.bin
\
\ ******************************************************************************

PRINT "MISSILE"
PRINT "Assembled at ", ~CODE%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD%

PRINT "S.WORDS ",~CODE%," ",~P%," ",~LOAD%," ",~LOAD%
SAVE "versions/disc/output/MISSILE.bin", CODE%, P%, LOAD%
