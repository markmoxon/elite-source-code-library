\ ******************************************************************************
\
\ BBC MICRO CASSETTE ELITE BIG CODE FILE SOURCE
\
\ BBC Micro cassette Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1984
\
\ The code in this file is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file contains code to produce the Big Code File for BBC Micro
\ cassette Elite. The Big Code File comprises the game code and the ship
\ blueprints.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary files:
\
\   * ELTcode.unprot.bin
\   * ELThead.bin
\
\ after reading in the following files:
\
\   * ELTA.bin
\   * ELTB.bin
\   * ELTC.bin
\   * ELTD.bin
\   * ELTE.bin
\   * ELTF.bin
\   * ELTG.bin
\   * SHIPS.bin
\
\ ******************************************************************************

 INCLUDE "versions/cassette/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _SOURCE_DISC           = (_VARIANT = 1)
 _TEXT_SOURCES          = (_VARIANT = 2)
 _STH_CASSETTE          = (_VARIANT = 3)

 GUARD &8000            \ Guard against assembling over MOS memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &0F40          \ CODE% is set to the location that the main game code
                        \ gets moved to after it is loaded

 LOAD% = &1128          \ LOAD% points to the start of the actual game code,
                        \ after the &28 bytes of header code that are inserted
                        \ below

INCLUDE "library/cassette/bcfs/workspace/zp.asm"

\ ******************************************************************************
\
\ Load the compiled binaries to create the Big Code File
\
\ ******************************************************************************

 ORG &1100              \ The load address of the main game code file ("ELTcode"
                        \ for loading from disc, "ELITEcode" for loading from
                        \ tape)

INCLUDE "library/cassette/bcfs/subroutine/lbl.asm"

.elitea

 PRINT "elitea = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/ELTA.bin"

.eliteb

 PRINT "eliteb = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/ELTB.bin"

.elitec

 PRINT "elitec = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/ELTC.bin"

.elited

 PRINT "elited = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/ELTD.bin"

.elitee

 PRINT "elitee = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/ELTE.bin"

.elitef

 PRINT "elitef = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/ELTF.bin"

.eliteg

 PRINT "eliteg = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/ELTG.bin"

.checksum0

 PRINT "checksum0 = ", ~P%

IF _SOURCE_DISC OR _TEXT_SOURCES

 SKIP 1                 \ We skip this byte so we can insert the checksum later
                        \ in elite-checksum.py

ELIF _STH_CASSETTE

 EQUB &20               \ We skip this byte so we can insert the checksum later
                        \ in elite-checksum.py; it contains workspace noise in
                        \ the Stairway to Hell variant

ENDIF

.ships

 PRINT "ships = ", ~P%
 INCBIN "versions/cassette/3-assembled-output/SHIPS.bin"

.end

\ ******************************************************************************
\
\ Save ELTcode.unprot.bin and ELThead.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.ELTcode 1100 ", ~(LOAD% + &6000 - CODE%), " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/cassette/3-assembled-output/ELTcode.unprot.bin", &1100, (LOAD% + &6000 - CODE%), LOAD%
 SAVE "versions/cassette/3-assembled-output/ELThead.bin", &1100, elitea, &1100
