\ ******************************************************************************
\
\ BBC MASTER ELITE GAME DATA FILE SOURCE
\
\ BBC Master Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1986
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
\   * BDATA.bin
\
\ ******************************************************************************

INCLUDE "versions/master/1-source-files/main-sources/elite-build-options.asm"

CPU 1                   \ Switch to 65SC12 assembly, as this code runs on a
                        \ BBC Master

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)
_ELITE_A_VERSION        = (_VERSION = 6)
_SNG47                  = (_VARIANT = 1)
_COMPACT                = (_VARIANT = 2)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = FALSE
_ELITE_A_DOCKED         = FALSE
_ELITE_A_FLIGHT         = FALSE
_ELITE_A_SHIPS_R        = FALSE
_ELITE_A_SHIPS_S        = FALSE
_ELITE_A_SHIPS_T        = FALSE
_ELITE_A_SHIPS_U        = FALSE
_ELITE_A_SHIPS_V        = FALSE
_ELITE_A_SHIPS_W        = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = FALSE
_ELITE_A_6502SP_PARA    = FALSE

GUARD &C000             \ Guard against assembling over MOS memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

VE = &57                \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

\ ******************************************************************************
\
\ ELITE GAME DATA FILE
\
\ ******************************************************************************

CODE% = &7000
LOAD% = &1300

ORG CODE%

INCLUDE "library/master/data/variable/dashboard_image.asm"

 SKIP 256               \ These bytes appear to be unused, but they get moved to
                        \ &7E00-&7EFF along with the dashboard

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ ******************************************************************************

 SKIP 256               \ These bytes appear to be unused, but they get moved to
                        \ &7F00-&7FFF along with the ship blueprints and text
                        \ tokens

INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/advanced/main/variable/e_per_cent.asm"
INCLUDE "library/master/data/variable/tallyfrac.asm"
INCLUDE "library/master/data/variable/tallyint.asm"
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

 EQUB &45, &4D          \ These bytes appear to be unused
 EQUB &41, &36

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/advanced/main/variable/ship_cougar.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ ******************************************************************************

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG47
  INCBIN "versions/master/4-reference-binaries/sng47/workspaces/DATA-align.bin"
 ELIF _COMPACT
  INCBIN "versions/master/4-reference-binaries/compact/workspaces/DATA-align.bin"
 ENDIF

ELSE

  SKIP 619              \ These bytes appear to be unused

ENDIF

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"
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

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG47

  EQUS " \mutilate"     \ These bytes appear to be unused and are presumably
  EQUS " from here"     \ workspace noise from the build process (this snippet
  EQUS " to F%"         \ looks like an assembly language comment from the
  EQUB 13               \ encryption process, which the authors presumably
  EQUB &0B, &B8         \ liked to call "mutilation")

 ELIF _COMPACT

  EQUS "\red herring"   \ These bytes appear to be unused and are presumably
  EQUB 13               \ workspace noise from the build process (this snippet
  EQUB &0B              \ looks like an assembly language comment from the
  EQUS ","              \ encryption process, which the authors presumably
  EQUB &05              \ liked to call "mutilation", though this could also
  EQUS "\"              \ be a "red herring")
  EQUB 13
  EQUB &0B
  EQUS "T!.G% \mutilate"

 ENDIF

ELSE

 SKIP 29                \ These bytes appear to be unused

ENDIF

\ ******************************************************************************
\
\ Save BDATA.unprot.bin
\
\ ******************************************************************************

PRINT "S.BDATA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/master/3-assembled-output/BDATA.unprot.bin", CODE%, P%, LOAD%
