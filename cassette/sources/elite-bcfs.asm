\ ******************************************************************************
\
\ ELITE BIG CODE FILE SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology used in this commentary is explained at the start of the
\ elite-loader.asm file
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary files:
\
\   * output/ELTcode.unprot.bin
\   * output/ELThead.bin
\
\ after reading in the following files:
\
\   * output/ELTA.bin
\   * output/ELTB.bin
\   * output/ELTC.bin
\   * output/ELTD.bin
\   * output/ELTE.bin
\   * output/ELTF.bin
\   * output/ELTG.bin
\   * output/SHIPS.bin
\
\ ******************************************************************************

INCLUDE "cassette/sources/elite-header.h.asm"

_CASSETTE_VERSION       = TRUE AND (_VERSION = 1)
_DISC_VERSION           = TRUE AND (_VERSION = 2)
_6502SP_VERSION         = TRUE AND (_VERSION = 3)

CODE% = &0F40           \ CODE% is set to the location that the main game code
                        \ gets moved to after it is loaded

LOAD% = &1128           \ LOAD% points to the start of the actual game code,
                        \ after the &28 bytes of header code that are inserted
                        \ below

D% = &563A              \ D% is set to the size of the main game code

ZP = &70                \ ZP is a zero page variable used in the checksum
                        \ routine at LBL

ORG &1100               \ The load address of the main game code file ("ELTcode"
                        \ for loading from disc, "ELITEcode" for loading from
                        \ tape)

INCLUDE "library/cassette/bcfs/subroutine_lbl.asm"

\ ******************************************************************************
\
\ Load the compiled binaries to create the Big Code File
\
\ ******************************************************************************

.elitea

PRINT "elitea = ", ~P%
INCBIN "cassette/output/ELTA.bin"

.eliteb

PRINT "eliteb = ", ~P%
INCBIN "cassette/output/ELTB.bin"

.elitec

PRINT "elitec = ", ~P%
INCBIN "cassette/output/ELTC.bin"

.elited

PRINT "elited = ", ~P%
INCBIN "cassette/output/ELTD.bin"

.elitee

PRINT "elitee = ", ~P%
INCBIN "cassette/output/ELTE.bin"

.elitef

PRINT "elitef = ", ~P%
INCBIN "cassette/output/ELTF.bin"

.eliteg

PRINT "eliteg = ", ~P%
INCBIN "cassette/output/ELTG.bin"

.checksum0

PRINT "checksum0 = ", ~P%

 SKIP 1                 \ We skip this byte so we can insert the checksum later
                        \ in elite-checksum.py

.ships

PRINT "ships = ", ~P%
INCBIN "cassette/output/SHIPS.bin"

.end

\ ******************************************************************************
\
\ Save output/ELTcode.unprot.bin and output/ELThead.bin
\
\ ******************************************************************************

PRINT "P% = ", ~P%
PRINT "S.ELTcode 1100 ", ~(LOAD% + &6000 - CODE%), " ", ~LOAD%, ~LOAD%
SAVE "cassette/output/ELTcode.unprot.bin", &1100, (LOAD% + &6000 - CODE%), LOAD%
SAVE "cassette/output/ELThead.bin", &1100, elitea, &1100
