\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 6)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
\
\ The sound player in this bank was written by David Whittaker
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
\   * bank6.bin
\
\ ******************************************************************************

 _BANK = 6

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
\ ELITE BANK 1
\
\ Produces the binary file bank1.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"
INCLUDE "library/nes/main/subroutine/choosemusics.asm"
INCLUDE "library/nes/main/subroutine/makesoundss.asm"
INCLUDE "library/nes/main/subroutine/stopsoundss.asm"
INCLUDE "library/nes/main/subroutine/enablesounds.asm"
INCLUDE "library/nes/main/subroutine/starteffectonsq1s.asm"
INCLUDE "library/nes/main/subroutine/starteffectonsq2s.asm"
INCLUDE "library/nes/main/subroutine/starteffectonnoises.asm"
INCLUDE "library/nes/main/subroutine/choosemusic.asm"
INCLUDE "library/nes/main/subroutine/enablesound.asm"
INCLUDE "library/nes/main/subroutine/stopsounds.asm"
INCLUDE "library/nes/main/subroutine/makesounds.asm"
INCLUDE "library/nes/main/subroutine/makemusic.asm"
INCLUDE "library/nes/main/subroutine/makemusiconsq1.asm"
INCLUDE "library/nes/main/subroutine/applyenvelopesq1.asm"
INCLUDE "library/nes/main/subroutine/makemusiconsq2.asm"
INCLUDE "library/nes/main/subroutine/applyenvelopesq2.asm"
INCLUDE "library/nes/main/subroutine/makemusicontri.asm"
INCLUDE "library/nes/main/subroutine/applyenvelopetri.asm"
INCLUDE "library/nes/main/subroutine/makemusiconnoise.asm"
INCLUDE "library/nes/main/subroutine/applyenvelopenoise.asm"
INCLUDE "library/nes/main/variable/notefrequency.asm"
INCLUDE "library/nes/main/subroutine/starteffectonsq1.asm"
INCLUDE "library/nes/main/subroutine/starteffect.asm"
INCLUDE "library/nes/main/subroutine/starteffectonsq2.asm"
INCLUDE "library/nes/main/subroutine/starteffectonnoise.asm"
INCLUDE "library/nes/main/subroutine/makesound.asm"
INCLUDE "library/nes/main/subroutine/makesoundonsq1.asm"
INCLUDE "library/nes/main/subroutine/makesoundonsq2.asm"
INCLUDE "library/nes/main/subroutine/makesoundonnoise.asm"
INCLUDE "library/nes/main/subroutine/updatevibratoseeds.asm"
INCLUDE "library/nes/main/variable/sounddata.asm"
INCLUDE "library/nes/main/variable/soundvolume.asm"
INCLUDE "library/nes/main/variable/volumeenvelope.asm"
INCLUDE "library/nes/main/variable/pitchenvelope.asm"
INCLUDE "library/nes/main/variable/tunedata.asm"
INCLUDE "library/nes/main/subroutine/drawglasses.asm"
INCLUDE "library/nes/main/subroutine/drawrightearring.asm"
INCLUDE "library/nes/main/subroutine/drawleftearring.asm"
INCLUDE "library/nes/main/subroutine/drawmedallion.asm"
INCLUDE "library/nes/main/subroutine/drawcmdrimage.asm"
INCLUDE "library/nes/main/subroutine/drawspriteimage.asm"
INCLUDE "library/nes/main/subroutine/pausegame.asm"
INCLUDE "library/nes/main/subroutine/dilx.asm"
INCLUDE "library/nes/main/subroutine/dials.asm"
INCLUDE "library/nes/main/variable/conditionattrs.asm"
INCLUDE "library/nes/main/variable/conditionpatts.asm"
INCLUDE "library/nes/main/subroutine/msbar_b6.asm"
INCLUDE "library/nes/main/variable/missilenames_b6.asm"
INCLUDE "library/nes/main/subroutine/setequipmentsprite.asm"
INCLUDE "library/nes/main/subroutine/setlasersprite.asm"
INCLUDE "library/nes/main/subroutine/getlaserpattern.asm"
INCLUDE "library/nes/main/variable/equipsprites.asm"
INCLUDE "library/nes/main/subroutine/drawequipment.asm"
INCLUDE "library/nes/main/subroutine/showscrolltext.asm"
INCLUDE "library/nes/main/subroutine/drawscrollinnmi.asm"
INCLUDE "library/6502sp/main/subroutine/gridset.asm"
INCLUDE "library/6502sp/main/subroutine/grs1.asm"
INCLUDE "library/nes/main/subroutine/calculategridlines.asm"
INCLUDE "library/nes/main/subroutine/getscrolldivisions.asm"
INCLUDE "library/nes/main/subroutine/drawscrolltext.asm"
INCLUDE "library/nes/main/subroutine/drawscrollframes.asm"
INCLUDE "library/nes/main/subroutine/scrolltextupscreen.asm"
INCLUDE "library/nes/main/subroutine/projectscrolltext.asm"
INCLUDE "library/nes/main/subroutine/drawscrollframe.asm"
INCLUDE "library/6502sp/main/variable/ltdef.asm"
INCLUDE "library/6502sp/main/variable/nofx.asm"
INCLUDE "library/6502sp/main/variable/nofy.asm"
INCLUDE "library/nes/main/variable/scrolltext1lo.asm"
INCLUDE "library/nes/main/variable/scrolltext1hi.asm"
INCLUDE "library/nes/main/variable/scrolltext2lo.asm"
INCLUDE "library/nes/main/variable/scrolltext2hi.asm"
INCLUDE "library/nes/main/variable/creditstext1lo.asm"
INCLUDE "library/nes/main/variable/creditstext1hi.asm"
INCLUDE "library/nes/main/variable/creditstext2lo.asm"
INCLUDE "library/nes/main/variable/creditstext2hi.asm"
INCLUDE "library/nes/main/variable/creditstext3lo.asm"
INCLUDE "library/nes/main/variable/creditstext3hi.asm"
INCLUDE "library/nes/main/variable/scrolltext1_en.asm"
INCLUDE "library/nes/main/variable/scrolltext2_en.asm"
INCLUDE "library/nes/main/variable/scrolltext1_fr.asm"
INCLUDE "library/nes/main/variable/scrolltext2_fr.asm"
INCLUDE "library/nes/main/variable/scrolltext1_de.asm"
INCLUDE "library/nes/main/variable/scrolltext2_de.asm"
INCLUDE "library/nes/main/variable/creditstext1.asm"
INCLUDE "library/nes/main/variable/creditstext2.asm"
INCLUDE "library/nes/main/variable/creditstext3.asm"
INCLUDE "library/nes/main/variable/saveheader1_en.asm"
INCLUDE "library/nes/main/variable/saveheader2_en.asm"
INCLUDE "library/nes/main/variable/saveheader1_de.asm"
INCLUDE "library/nes/main/variable/saveheader2_de.asm"
INCLUDE "library/nes/main/variable/saveheader1_fr.asm"
INCLUDE "library/nes/main/variable/saveheader2_fr.asm"
INCLUDE "library/nes/main/variable/xsaveheader.asm"
INCLUDE "library/nes/main/variable/saveheader1lo.asm"
INCLUDE "library/nes/main/variable/saveheader1hi.asm"
INCLUDE "library/nes/main/variable/saveheader2lo.asm"
INCLUDE "library/nes/main/variable/saveheader2hi.asm"
INCLUDE "library/nes/main/variable/savebracketpatts.asm"
INCLUDE "library/nes/main/subroutine/printsaveheader.asm"
INCLUDE "library/nes/main/subroutine/sve.asm"
INCLUDE "library/nes/main/subroutine/moveinleftcolumn.asm"
INCLUDE "library/nes/main/subroutine/checksaveloadbar.asm"
INCLUDE "library/nes/main/subroutine/waitfornodirection.asm"
INCLUDE "library/nes/main/subroutine/movetoleftcolumn.asm"
INCLUDE "library/nes/main/subroutine/moveinrightcolumn.asm"
INCLUDE "library/nes/main/subroutine/moveinmiddlecolumn.asm"
INCLUDE "library/nes/main/subroutine/drawsaveslotmark.asm"
INCLUDE "library/nes/main/subroutine/printsavename.asm"
INCLUDE "library/nes/main/subroutine/printcommandername.asm"
INCLUDE "library/nes/main/subroutine/highlightsavename.asm"
INCLUDE "library/nes/main/subroutine/updatesavescreen.asm"
INCLUDE "library/nes/main/subroutine/printnameinmiddle.asm"
INCLUDE "library/nes/main/subroutine/clearnameinmiddle.asm"
INCLUDE "library/nes/main/variable/galaxyseeds.asm"
INCLUDE "library/nes/main/variable/saveslotaddr1.asm"
INCLUDE "library/nes/main/variable/saveslotaddr2.asm"
INCLUDE "library/nes/main/variable/saveslotaddr3.asm"
INCLUDE "library/nes/main/subroutine/resetsavebuffer.asm"
INCLUDE "library/nes/main/subroutine/copycommandertobuf.asm"
INCLUDE "library/nes/main/subroutine/resetsaveslots.asm"
INCLUDE "library/nes/main/subroutine/getsaveaddresses.asm"
INCLUDE "library/nes/main/subroutine/saveloadcommander.asm"
INCLUDE "library/nes/main/subroutine/checksaveslots.asm"
INCLUDE "library/nes/main/variable/na2%.asm"
INCLUDE "library/nes/main/subroutine/resetcommander.asm"
INCLUDE "library/nes/main/subroutine/jameson.asm"
INCLUDE "library/nes/main/subroutine/drawlightning.asm"
INCLUDE "library/nes/main/subroutine/ll164.asm"
INCLUDE "library/nes/main/variable/hyperspacecolour.asm"
INCLUDE "library/nes/main/subroutine/drawlaunchbox.asm"
INCLUDE "library/nes/main/subroutine/inputname.asm"
INCLUDE "library/nes/main/subroutine/changeletter.asm"
INCLUDE "library/nes/main/subroutine/changecmdrname.asm"
INCLUDE "library/nes/main/variable/cheatcmdrname.asm"
INCLUDE "library/nes/main/subroutine/setkeylogger.asm"
INCLUDE "library/nes/main/subroutine/chooselanguage.asm"
INCLUDE "library/nes/main/subroutine/setchosenlanguage.asm"
INCLUDE "library/nes/main/subroutine/setlanguage.asm"
INCLUDE "library/nes/main/variable/xlanguage.asm"
INCLUDE "library/nes/main/variable/ylanguage.asm"
INCLUDE "library/nes/main/variable/characterendlang.asm"
INCLUDE "library/nes/main/variable/decimalpointlang.asm"
INCLUDE "library/nes/main/variable/languagelength.asm"
INCLUDE "library/nes/main/variable/tokenslo.asm"
INCLUDE "library/nes/main/variable/tokenshi.asm"
INCLUDE "library/nes/main/variable/extendedtokenslo.asm"
INCLUDE "library/nes/main/variable/extendedtokenshi.asm"
INCLUDE "library/nes/main/variable/languageindexes.asm"
INCLUDE "library/nes/main/variable/languagenumbers.asm"
INCLUDE "library/common/main/subroutine/tt24.asm"
INCLUDE "library/nes/main/subroutine/cleardashedge.asm"
INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank6.bin
\
\ ******************************************************************************

 PRINT "S.bank6.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank6.bin", CODE%, P%, LOAD%
