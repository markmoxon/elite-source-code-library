\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 3)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
\
\ The code in this file has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\ This source file contains the game code for ROM bank 3 of NES Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank3.bin
\
\ ******************************************************************************

\ ******************************************************************************
\
\ ELITE BANK 3
\
\ Produces the binary file bank1.bin.
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1_b3.asm"
INCLUDE "library/nes/main/subroutine/interrupts_b3.asm"
INCLUDE "library/nes/main/variable/version_number_b3.asm"
INCLUDE "library/nes/main/variable/copyright-and-version-message.asm"
INCLUDE "library/nes/main/variable/iconbarimage0.asm"
INCLUDE "library/nes/main/variable/iconbarimage1.asm"
INCLUDE "library/nes/main/variable/iconbarimage2.asm"
INCLUDE "library/nes/main/variable/iconbarimage3.asm"
INCLUDE "library/nes/main/variable/iconbarimage4.asm"
INCLUDE "library/nes/main/variable/barnames0.asm"
INCLUDE "library/nes/main/variable/barnames1.asm"
INCLUDE "library/nes/main/variable/barnames2.asm"
INCLUDE "library/nes/main/variable/barnames3.asm"
INCLUDE "library/nes/main/variable/barnames4.asm"
INCLUDE "library/nes/main/variable/dashnames.asm"
INCLUDE "library/nes/main/variable/dashimage.asm"
INCLUDE "library/nes/main/variable/cobraimage.asm"
INCLUDE "library/nes/main/variable/inventoryicon.asm"
INCLUDE "library/nes/main/variable/smalllogoimage.asm"
INCLUDE "library/nes/main/variable/logoballimage.asm"
INCLUDE "library/nes/main/subroutine/drawdashnames.asm"
INCLUDE "library/nes/main/subroutine/resetscanner.asm"
INCLUDE "library/nes/main/subroutine/sendviewtoppu.asm"
INCLUDE "library/nes/main/subroutine/sendfontimagetoppu.asm"
INCLUDE "library/nes/main/subroutine/senddashimagetoppu.asm"
INCLUDE "library/nes/main/subroutine/sendbitplanetoppu.asm"
INCLUDE "library/nes/main/subroutine/senddatanowtoppu.asm"
INCLUDE "library/nes/main/subroutine/setupviewinnmi.asm"
INCLUDE "library/nes/main/variable/paletteforview.asm"
INCLUDE "library/nes/main/variable/boxedgeimages.asm"
INCLUDE "library/nes/main/subroutine/resetscreen.asm"
INCLUDE "library/nes/main/subroutine/seticonbarrow.asm"
INCLUDE "library/nes/main/subroutine/showiconbar.asm"
INCLUDE "library/nes/main/subroutine/updateiconbar.asm"
INCLUDE "library/nes/main/subroutine/setupsprite0.asm"
INCLUDE "library/nes/main/subroutine/blankallbuttons.asm"
INCLUDE "library/nes/main/subroutine/blankbuttons6to11.asm"
INCLUDE "library/nes/main/subroutine/blankbuttons8to11.asm"
INCLUDE "library/nes/main/subroutine/drawiconbar.asm"
INCLUDE "library/nes/main/subroutine/hideiconbar.asm"
INCLUDE "library/nes/main/subroutine/setupiconbarpause.asm"
INCLUDE "library/nes/main/subroutine/seticonbarbuttonss.asm"
INCLUDE "library/nes/main/subroutine/setupiconbar.asm"
INCLUDE "library/nes/main/subroutine/setupiconbarflight.asm"
INCLUDE "library/nes/main/subroutine/setupiconbardocked.asm"
INCLUDE "library/nes/main/subroutine/seticonbarbuttons.asm"
INCLUDE "library/nes/main/subroutine/setupiconbarcharts.asm"
INCLUDE "library/nes/main/subroutine/drawblankbutton2x2.asm"
INCLUDE "library/nes/main/subroutine/drawblankbutton3x2.asm"
INCLUDE "library/nes/main/subroutine/draw6optiontiles.asm"
INCLUDE "library/nes/main/subroutine/draw4optiontiles.asm"
INCLUDE "library/nes/main/subroutine/draw2optiontiles.asm"
INCLUDE "library/nes/main/subroutine/setlinepatterns.asm"
INCLUDE "library/nes/main/subroutine/loadnormalfont.asm"
INCLUDE "library/nes/main/subroutine/loadhighfont.asm"
INCLUDE "library/nes/main/subroutine/drawsystemimage.asm"
INCLUDE "library/nes/main/subroutine/drawimageframe.asm"
INCLUDE "library/nes/main/subroutine/drawrowoftiles.asm"
INCLUDE "library/nes/main/subroutine/getnameaddress.asm"
INCLUDE "library/nes/main/subroutine/drawsmallbox.asm"
INCLUDE "library/nes/main/subroutine/drawbackground.asm"
INCLUDE "library/nes/main/subroutine/clearscreen.asm"
INCLUDE "library/nes/main/variable/viewpalettes.asm"
INCLUDE "library/nes/main/variable/fadecolours.asm"
INCLUDE "library/nes/main/subroutine/getviewpalettes.asm"
INCLUDE "library/nes/main/subroutine/fadecolourstwice.asm"
INCLUDE "library/nes/main/subroutine/fadecolours.asm"
INCLUDE "library/nes/main/subroutine/setpalettecolours.asm"
INCLUDE "library/nes/main/subroutine/fadetoblack.asm"
INCLUDE "library/nes/main/subroutine/fadetocolour.asm"
INCLUDE "library/nes/main/variable/systempalettes.asm"
INCLUDE "library/nes/main/variable/viewattrcount.asm"
INCLUDE "library/nes/main/variable/viewattroffset.asm"
INCLUDE "library/nes/main/variable/viewattributes0.asm"
INCLUDE "library/nes/main/variable/viewattributes1.asm"
INCLUDE "library/nes/main/variable/viewattributes2.asm"
INCLUDE "library/nes/main/variable/viewattributes3.asm"
INCLUDE "library/nes/main/variable/viewattributes4.asm"
INCLUDE "library/nes/main/variable/viewattributes5.asm"
INCLUDE "library/nes/main/variable/viewattributes6.asm"
INCLUDE "library/nes/main/variable/viewattributes7.asm"
INCLUDE "library/nes/main/variable/viewattributes8.asm"
INCLUDE "library/nes/main/variable/viewattributes9.asm"
INCLUDE "library/nes/main/variable/viewattributes10.asm"
INCLUDE "library/nes/main/variable/viewattributes11.asm"
INCLUDE "library/nes/main/variable/viewattributes12.asm"
INCLUDE "library/nes/main/variable/viewattributes13.asm"
INCLUDE "library/nes/main/variable/viewattributes14.asm"
INCLUDE "library/nes/main/variable/viewattributes15.asm"
INCLUDE "library/nes/main/variable/viewattributes16.asm"
INCLUDE "library/nes/main/variable/viewattributes17.asm"
INCLUDE "library/nes/main/variable/viewattributes18.asm"
INCLUDE "library/nes/main/variable/viewattributes19.asm"
INCLUDE "library/nes/main/variable/viewattributes20.asm"
INCLUDE "library/nes/main/variable/viewattributes21.asm"
INCLUDE "library/nes/main/variable/viewattributes22.asm"
INCLUDE "library/nes/main/variable/viewattributes23.asm"
INCLUDE "library/nes/main/variable/viewattributes_en.asm"
INCLUDE "library/nes/main/variable/viewattributes_de.asm"
INCLUDE "library/nes/main/variable/viewattributes_fr.asm"
INCLUDE "library/nes/main/variable/viewattributeslo.asm"
INCLUDE "library/nes/main/variable/viewattributeshi.asm"
INCLUDE "library/nes/main/subroutine/setviewattrs.asm"
INCLUDE "library/nes/main/subroutine/hidesightsprites.asm"
INCLUDE "library/nes/main/subroutine/sight.asm"
INCLUDE "library/nes/main/variable/vectors_b3.asm"

\ ******************************************************************************
\
\ Save bank3.bin
\
\ ******************************************************************************

 PRINT "S.bank3.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank3.bin", CODE%, P%, LOAD%
