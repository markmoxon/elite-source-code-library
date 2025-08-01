\ ******************************************************************************
\
\ APPLE II ELITE GAME DATA SOURCE
\
\ Apple II Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1986
\
\ The code in this file is identical to the source disks released on Ian Bell's
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
\ This source file contains the game data for Apple II Elite, including the game
\ text and ship blueprints.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * DATA.unprot.bin
\
\ after reading in the following files:
\
\   * WORDS.bin
\   * IANTOK.bin
\   * FONT.bin
\
\ ******************************************************************************

 INCLUDE "versions/apple/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _IB_DISK                   = (_VARIANT = 1)
 _SOURCE_DISK_BUILD         = (_VARIANT = 2)
 _SOURCE_DISK_CODE_FILES    = (_VARIANT = 3)
 _SOURCE_DISK_ELT_FILES     = (_VARIANT = 4)
 _4AM_CRACK                 = (_VARIANT = 5)
 _SOURCE_DISK               = (_VARIANT = 2) OR (_VARIANT = 3) OR (_VARIANT = 4)
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

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

IF _IB_DISK OR _4AM_CRACK

 CODE% = &0B00          \ The address where the code will be run

 LOAD% = &0B00          \ The address where the code will be loaded

ELSE

 CODE% = &0B60          \ The address where the code will be run

 LOAD% = &0B60          \ The address where the code will be loaded

ENDIF

 D% = &A300             \ The address where the ship data will be loaded
                        \ (i.e. XX21)

 RE = &23               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

IF _IB_DISK

 EQUB &5B, &79, &55, &82, &56, &88, &5B, &75    \ These bytes appear to be
 EQUB &53, &6F, &4E, &76, &4E, &7E, &54, &6F    \ unused and just contain random
 EQUB &4E, &76, &4E, &75, &53, &7E, &54, &79    \ workspace noise left over from
 EQUB &55, &82, &56, &81, &5B, &88, &5B, &90    \ the BBC Micro assembly process
 EQUB &61, &90, &63, &8C, &61, &90, &63, &90
 EQUB &61, &8C, &61, &60, &45, &5F, &44, &5F
 EQUB &44, &64, &45, &60, &45, &64, &45, &8A
 EQUB &1E, &8A, &18, &86, &1C, &8A, &1E, &6D
 EQUB &66, &69, &6A, &69, &6A, &69, &64, &6D
 EQUB &66, &69, &64, &6C, &6A, &6B, &66, &6F
 EQUB &66, &6B, &66, &20, &45, &51, &55, &57
 EQUB &26, &33, &43, &33, &43, &3A, &45, &51

ENDIF

.WORDS

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"

\ ******************************************************************************
\
\ Save WORDS.bin
\
\ ******************************************************************************

 PRINT "WORDS"
 PRINT "Assembled at ", ~WORDS
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - WORDS)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD%

 PRINT "S.A.WORDS ", ~WORDS, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/apple/3-assembled-output/WORDS.bin", WORDS, P%, LOAD%

\ ******************************************************************************
\
\ ELITE EXTENDED TEXT TOKEN FILE
\
\ ******************************************************************************

.IANTOK

INCLUDE "library/enhanced/main/macro/ejmp.asm"
INCLUDE "library/enhanced/main/macro/echr.asm"
INCLUDE "library/enhanced/main/macro/etok.asm"
INCLUDE "library/enhanced/main/macro/etwo.asm"
INCLUDE "library/enhanced/main/macro/ernd.asm"
INCLUDE "library/enhanced/main/macro/tokn.asm"
INCLUDE "library/enhanced/main/variable/tkn1.asm"
INCLUDE "library/enhanced/main/variable/rupla.asm"
INCLUDE "library/enhanced/main/variable/rugal.asm"
INCLUDE "library/enhanced/main/variable/rutok.asm"

.endian

 EQUB &2E, &54          \ These bytes appear to be unused and just contain
 EQUB &72, &69          \ random workspace noise left over from the BBC Micro
 EQUB &62, &62          \ assembly process
 EQUB &6C

\ ******************************************************************************
\
\ Save IANTOK.bin
\
\ ******************************************************************************

 LOAD_IT% = IANTOK + LOAD% - CODE%

 PRINT "IANTOK"
 PRINT "Assembled at ", ~IANTOK
 PRINT "Ends at ", ~endian
 PRINT "Code size is ", ~(endian - IANTOK)
 PRINT "Execute at ", ~LOAD_IT%
 PRINT "Reload at ", ~LOAD_IT%

 PRINT "S.C.IANTOK ", ~IANTOK, " ", ~endian, " ", ~LOAD_IT%, " ", ~LOAD_IT%
 SAVE "versions/apple/3-assembled-output/IANTOK.bin", IANTOK, endian, LOAD_IT%

\ ******************************************************************************
\
\ ELITE FONT FILE
\
\ ******************************************************************************

.FONT

 INCBIN "versions/apple/1-source-files/fonts/A.FLOWY.bin"

\ ******************************************************************************
\
\ Save DATA.unprot.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.DATA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/apple/3-assembled-output/DATA.unprot.bin", CODE%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

 CODE_SHIPS% = D%

 LOAD_SHIPS% = LOAD% + D% - CODE%

 ORG D%                 \ Set the assembly address to D%

INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/advanced/main/variable/e_per_cent.asm"
INCLUDE "library/master/data/variable/kwl_per_cent.asm"
INCLUDE "library/master/data/variable/kwh_per_cent.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/enhanced/main/variable/ship_boulder.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/enhanced/main/variable/ship_splinter.asm"
INCLUDE "library/enhanced/main/variable/ship_shuttle.asm"
INCLUDE "library/enhanced/main/variable/ship_transporter.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/enhanced/main/variable/ship_boa.asm"
INCLUDE "library/enhanced/main/variable/ship_anaconda.asm"
INCLUDE "library/advanced/main/variable/ship_rock_hermit.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/enhanced/main/variable/ship_krait.asm"
INCLUDE "library/enhanced/main/variable/ship_adder.asm"
INCLUDE "library/enhanced/main/variable/ship_gecko.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_1.asm"
INCLUDE "library/enhanced/main/variable/ship_worm.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_3_p.asm"
INCLUDE "library/enhanced/main/variable/ship_asp_mk_2.asm"

 EQUB &E7, &33          \ These bytes appear to be unused
 EQUB &53, &08

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

 EQUB &08, &08          \ These bytes appear to be unused
 EQUB &03, &FE

\ ******************************************************************************
\
\ Save SHIPS.bin
\
\ ******************************************************************************

 PRINT "SHIPS"
 PRINT "Assembled at ", ~CODE_SHIPS%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_SHIPS%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_SHIPS%

 PRINT "S.SHIPS ", ~CODE_SHIPS%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_SHIPS%
 SAVE "versions/apple/3-assembled-output/SHIPS.bin", CODE_SHIPS%, P%, LOAD%
