\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE BIG CODE FILE SOURCE
\
\ 6502 Second Processor Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1985
\
\ The code on this site is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
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
\ This source file produces the following binary files:
\
\   * 3-assembled-output/P.CODE.unprot.bin
\
\ after reading in the following files:
\
\   * 3-assembled-output/ELTA.bin
\   * 3-assembled-output/ELTB.bin
\   * 3-assembled-output/ELTC.bin
\   * 3-assembled-output/ELTD.bin
\   * 3-assembled-output/ELTE.bin
\   * 3-assembled-output/ELTF.bin
\   * 3-assembled-output/ELTG.bin
\   * 3-assembled-output/ELTH.bin
\   * 3-assembled-output/ELTI.bin
\   * 3-assembled-output/ELTJ.bin
\   * 3-assembled-output/SHIPS.bin
\   * 3-assembled-output/WORDS.bin
\
\ ******************************************************************************

INCLUDE "versions/6502sp/1-source-files/main-sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)
_ELITE_A_VERSION        = (_VERSION = 6)
_SOURCE_DISC            = (_RELEASE = 1)
_SNG45                  = (_RELEASE = 2)
_EXECUTIVE              = (_RELEASE = 3)

GUARD &F800             \ Guard against assembling over MOS memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

CODE% = &1000           \ The address where the the main game code file (P.CODE)
                        \ is run in the parasite

LOAD% = &1000           \ The load address of the main game code file, which is
                        \ the same as the load address as it doesn't get moved
                        \ after loading

\ ******************************************************************************
\
\ Load the compiled binaries to create the Big Code File
\
\ ******************************************************************************

ORG CODE%

IF _SNG45
 INCBIN "versions/6502sp/4-original-binaries/sng45/workspaces/BCFS-MOS.bin"
ELIF _EXECUTIVE
 INCBIN "versions/6502sp/4-original-binaries/executive/workspaces/BCFS-MOS.bin"
ELIF _SOURCE_DISC
 INCBIN "versions/6502sp/4-original-binaries/source-disc/workspaces/BCFS-MOS.bin"
ENDIF

.elitea

PRINT "elitea = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTA.bin"

.eliteb

PRINT "eliteb = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTB.bin"

.elitec

PRINT "elitec = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTC.bin"

.elited

PRINT "elited = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTD.bin"

.elitee

PRINT "elitee = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTE.bin"

.elitef

PRINT "elitef = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTF.bin"

.eliteg

PRINT "eliteg = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTG.bin"

.eliteh

PRINT "eliteh = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTH.bin"

.elitei

PRINT "elitei = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTI.bin"

.elitej

PRINT "elitej = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/ELTJ.bin"

F% = P%
PRINT "F% = ", ~F%
PRINT "P% = ", ~P%

.words

PRINT "words = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/WORDS.bin"

.ships

PRINT "ships = ", ~P%
INCBIN "versions/6502sp/3-assembled-output/SHIPS.bin"

IF _SNG45
 INCBIN "versions/6502sp/4-original-binaries/sng45/workspaces/BCFS-SHIPS.bin"
ELIF _EXECUTIVE
 INCBIN "versions/6502sp/4-original-binaries/executive/workspaces/BCFS-SHIPS.bin"
ELIF _SOURCE_DISC
 INCBIN "versions/6502sp/4-original-binaries/source-disc/workspaces/BCFS-SHIPS.bin"
ENDIF

.end

\ ******************************************************************************
\
\ Save 6502sp/3-assembled-output/P.CODE.unprot.bin
\
\ ******************************************************************************

PRINT "P% = ", ~P%
PRINT "S.P.CODE ", ~LOAD%, ~(F% + &0400 + &2200), " ", ~LOAD%, ~LOAD%
SAVE "versions/6502sp/3-assembled-output/P.CODE.unprot.bin", CODE%, (F% + &0400 + &2200), LOAD%
