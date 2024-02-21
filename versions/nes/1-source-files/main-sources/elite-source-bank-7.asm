\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 7)
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
\ https://www.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank7.bin
\
\ ******************************************************************************

\ ******************************************************************************
\
\ ELITE BANK 7
\
\ Produces the binary file bank7.bin.
\
\ ******************************************************************************

 CODE_BANK_7% = &C000
 LOAD_BANK_7% = &C000

 ORG CODE_BANK_7%

INCLUDE "library/nes/main/subroutine/resetmmc1_b7.asm"
INCLUDE "library/nes/main/subroutine/begin.asm"
INCLUDE "library/nes/main/subroutine/resettostartscreen.asm"
INCLUDE "library/nes/main/subroutine/resetvariables.asm"
INCLUDE "library/nes/main/subroutine/setbank0.asm"
INCLUDE "library/nes/main/subroutine/setnonzerobank.asm"
INCLUDE "library/nes/main/subroutine/resetbank.asm"
INCLUDE "library/nes/main/subroutine/setbank.asm"
INCLUDE "library/nes/main/variable/xtitlescreen.asm"
INCLUDE "library/nes/main/variable/xspaceview.asm"

IF _NTSC

 EQUB &20, &20, &20     \ These bytes appear to be unused
 EQUB &20, &10, &00
 EQUB &C4, &ED, &5E
 EQUB &E5, &22, &E5
 EQUB &22, &00, &00
 EQUB &ED, &5E, &E5
 EQUB &22, &09, &68
 EQUB &00, &00, &00
 EQUB &00

ELIF _PAL

 EQUB &FF, &FF, &FF     \ These bytes appear to be unused
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF

ENDIF

INCLUDE "library/advanced/main/variable/log.asm"
INCLUDE "library/advanced/main/variable/logl.asm"
INCLUDE "library/advanced/main/variable/antilog-alogh.asm"
INCLUDE "library/6502sp/main/variable/antilogodd.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"
INCLUDE "library/common/main/variable/xx21.asm"
INCLUDE "library/nes/main/subroutine/sendbarnamestoppu.asm"
INCLUDE "library/nes/main/subroutine/sendbarpatts2toppu.asm"
INCLUDE "library/nes/main/subroutine/sendbarpattstoppu.asm"
INCLUDE "library/nes/main/subroutine/sendbarpattstoppus.asm"
INCLUDE "library/nes/main/subroutine/sendbarnamestoppus.asm"
INCLUDE "library/nes/main/subroutine/considersendtiles.asm"
INCLUDE "library/nes/main/subroutine/sendbufferstoppu-part-1-of-3.asm"
INCLUDE "library/nes/main/subroutine/sendbufferstoppu-part-2-of-3.asm"
INCLUDE "library/nes/main/subroutine/sendbufferstoppu-part-3-of-3.asm"
INCLUDE "library/nes/main/subroutine/sendtilestoppu.asm"
INCLUDE "library/nes/main/subroutine/sendpatternstoppu-part-1-of-6.asm"
INCLUDE "library/nes/main/subroutine/sendpatternstoppu-part-2-of-6.asm"
INCLUDE "library/nes/main/subroutine/sendpatternstoppu-part-3-of-6.asm"
INCLUDE "library/nes/main/subroutine/sendpatternstoppu-part-4-of-6.asm"
INCLUDE "library/nes/main/subroutine/sendpatternstoppu-part-5-of-6.asm"
INCLUDE "library/nes/main/subroutine/sendpatternstoppu-part-6-of-6.asm"
INCLUDE "library/nes/main/subroutine/sendotherbitplane.asm"
INCLUDE "library/nes/main/subroutine/sendnametabletoppu.asm"
INCLUDE "library/nes/main/subroutine/copynamebuffer0to1.asm"
INCLUDE "library/nes/main/subroutine/drawboxtop.asm"
INCLUDE "library/nes/main/subroutine/drawboxedges.asm"
INCLUDE "library/common/main/variable/univ.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/nes/main/subroutine/hideexplosionburst.asm"
INCLUDE "library/nes/main/subroutine/clearscanner.asm"
INCLUDE "library/nes/main/subroutine/hidesprites.asm"

 EQUB &0C, &20, &1F     \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/namebufferhiaddr.asm"
INCLUDE "library/nes/main/variable/pattbufferhiaddr.asm"
INCLUDE "library/nes/main/subroutine/irq.asm"
INCLUDE "library/nes/main/subroutine/nmi.asm"
INCLUDE "library/nes/main/subroutine/updatenmitimer.asm"
INCLUDE "library/nes/main/subroutine/sendpalettesprites.asm"
INCLUDE "library/nes/main/subroutine/setpaletteforview.asm"
INCLUDE "library/nes/main/subroutine/sendpalettestoppu.asm"
INCLUDE "library/nes/main/subroutine/sendscreentoppu.asm"
INCLUDE "library/nes/main/subroutine/setppuregisters.asm"
INCLUDE "library/nes/main/subroutine/setpputablesto0.asm"
INCLUDE "library/nes/main/subroutine/clearbuffers.asm"
INCLUDE "library/nes/main/subroutine/readcontrollers.asm"
INCLUDE "library/nes/main/subroutine/scanbuttons.asm"
INCLUDE "library/nes/main/subroutine/waitfornextnmi.asm"
INCLUDE "library/nes/main/subroutine/waitfor2nmis.asm"
INCLUDE "library/nes/main/subroutine/waitfornmi.asm"
INCLUDE "library/nes/main/subroutine/waitforiconbarppu.asm"
INCLUDE "library/nes/main/subroutine/cleardrawingplane-part-1-of-3.asm"
INCLUDE "library/nes/main/subroutine/cleardrawingplane-part-2-of-3.asm"
INCLUDE "library/nes/main/subroutine/cleardrawingplane-part-3-of-3.asm"
INCLUDE "library/nes/main/variable/flagsforclearing.asm"
INCLUDE "library/nes/main/subroutine/clearplanebuffers-part-1-of-2.asm"
INCLUDE "library/nes/main/subroutine/clearplanebuffers-part-2-of-2.asm"
INCLUDE "library/nes/main/subroutine/fillmemory.asm"
INCLUDE "library/nes/main/subroutine/fillmemory32bytes.asm"
INCLUDE "library/nes/main/subroutine/clearmemory.asm"
INCLUDE "library/nes/main/subroutine/waitforpputofinish.asm"
INCLUDE "library/nes/main/subroutine/flipdrawingplane.asm"
INCLUDE "library/nes/main/subroutine/setdrawingbitplane.asm"
INCLUDE "library/nes/main/subroutine/setpatternbuffer.asm"
INCLUDE "library/nes/main/subroutine/copysmallblock.asm"
INCLUDE "library/nes/main/subroutine/copylargeblock.asm"
INCLUDE "library/nes/main/subroutine/waitfor3xvblank.asm"
INCLUDE "library/nes/main/subroutine/waitforvblank.asm"
INCLUDE "library/nes/main/subroutine/makesoundsatvblank.asm"
INCLUDE "library/nes/main/subroutine/drawmessageinnmi.asm"
INCLUDE "library/nes/main/subroutine/drawshipinbitplane.asm"
INCLUDE "library/nes/main/subroutine/drawbitplaneinnmi.asm"
INCLUDE "library/nes/main/subroutine/setdrawplaneflags.asm"
INCLUDE "library/nes/main/subroutine/sendinventorytoppu.asm"
INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/nes/main/variable/ylookuplo.asm"
INCLUDE "library/nes/main/variable/ylookuphi.asm"
INCLUDE "library/nes/main/subroutine/getrownameaddress.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/nes/main/subroutine/drawsunrowofblocks.asm"
INCLUDE "library/nes/main/subroutine/hloin-part-1-of-5.asm"
INCLUDE "library/nes/main/subroutine/hloin-part-2-of-5.asm"
INCLUDE "library/nes/main/subroutine/hloin-part-3-of-5.asm"
INCLUDE "library/nes/main/subroutine/hloin-part-4-of-5.asm"
INCLUDE "library/nes/main/subroutine/hloin-part-5-of-5.asm"
INCLUDE "library/nes/main/subroutine/drawverticalline-part-1-of-3.asm"
INCLUDE "library/nes/main/subroutine/drawverticalline-part-2-of-3.asm"
INCLUDE "library/nes/main/subroutine/drawverticalline-part-3-of-3.asm"
INCLUDE "library/nes/main/subroutine/pixel.asm"
INCLUDE "library/nes/main/subroutine/drawdash.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/nes/main/subroutine/msbar.asm"
INCLUDE "library/nes/main/variable/missilenames.asm"
INCLUDE "library/nes/main/variable/autoplaykeys1_en.asm"
INCLUDE "library/nes/main/variable/autoplaykeys1_de.asm"
INCLUDE "library/nes/main/variable/autoplaykeys1_fr.asm"
INCLUDE "library/nes/main/variable/autoplaykeys2.asm"
INCLUDE "library/nes/main/subroutine/autoplaydemo.asm"
INCLUDE "library/nes/main/subroutine/hideiconbarpointer.asm"
INCLUDE "library/nes/main/subroutine/seticonbarpointer.asm"
INCLUDE "library/nes/main/subroutine/moveiconbarpointer.asm"
INCLUDE "library/nes/main/subroutine/setcontrollerpast.asm"
INCLUDE "library/nes/main/subroutine/updatejoystick.asm"
INCLUDE "library/nes/main/subroutine/increasejoystick.asm"
INCLUDE "library/nes/main/subroutine/decreasejoystick.asm"
INCLUDE "library/nes/main/variable/iconbarbuttons.asm"
INCLUDE "library/nes/main/subroutine/hidestardust.asm"
INCLUDE "library/nes/main/subroutine/hidemoresprites.asm"
INCLUDE "library/nes/main/subroutine/setscreenforupdate.asm"
INCLUDE "library/nes/main/subroutine/fadeandhidesprites.asm"
INCLUDE "library/nes/main/subroutine/hidemostsprites.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/exno3.asm"
INCLUDE "library/nes/main/subroutine/flushsoundchannels.asm"
INCLUDE "library/nes/main/subroutine/flushsq2andnoise.asm"
INCLUDE "library/nes/main/subroutine/flushspecificsound.asm"
INCLUDE "library/nes/main/subroutine/flushsoundchannel.asm"
INCLUDE "library/master/main/subroutine/boop.asm"
INCLUDE "library/nes/main/subroutine/makescoopsound.asm"
INCLUDE "library/nes/main/subroutine/makehypersound.asm"
INCLUDE "library/nes/main/subroutine/noise.asm"
INCLUDE "library/nes/main/subroutine/starteffect_b7.asm"
INCLUDE "library/nes/main/variable/soundchannel.asm"
INCLUDE "library/nes/main/variable/soundpriority.asm"
INCLUDE "library/nes/main/subroutine/setupppuforiconbar.asm"
INCLUDE "library/nes/main/subroutine/getshipblueprint.asm"
INCLUDE "library/nes/main/subroutine/resetbanka.asm"
INCLUDE "library/nes/main/subroutine/getdefaultnewb.asm"
INCLUDE "library/nes/main/subroutine/increasetally.asm"
INCLUDE "library/nes/main/subroutine/resetbankp.asm"
INCLUDE "library/nes/main/subroutine/checkpausebutton.asm"
INCLUDE "library/nes/main/subroutine/checkforpause_b0.asm"
INCLUDE "library/nes/main/subroutine/drawinventoryicon.asm"
INCLUDE "library/nes/main/subroutine/makesounds_b6.asm"
INCLUDE "library/nes/main/subroutine/choosemusic_b6.asm"
INCLUDE "library/nes/main/subroutine/starteffect_b6.asm"
INCLUDE "library/nes/main/subroutine/resetmusicafternmi.asm"
INCLUDE "library/nes/main/subroutine/resetmusic.asm"
INCLUDE "library/nes/main/subroutine/stopsounds_b6.asm"
INCLUDE "library/nes/main/subroutine/setdemoautoplay_b5.asm"
INCLUDE "library/nes/main/subroutine/drawsmalllogo_b4.asm"
INCLUDE "library/nes/main/subroutine/drawbiglogo_b4.asm"
INCLUDE "library/nes/main/subroutine/fadetoblack_b3.asm"
INCLUDE "library/nes/main/subroutine/checksaveslots_b6.asm"
INCLUDE "library/nes/main/subroutine/ll9_b1.asm"
INCLUDE "library/nes/main/subroutine/sight_b3.asm"
INCLUDE "library/nes/main/subroutine/tidy_b1.asm"
INCLUDE "library/nes/main/subroutine/chooselanguage_b6.asm"
INCLUDE "library/nes/main/subroutine/playdemo_b0.asm"
INCLUDE "library/nes/main/subroutine/stars_b1.asm"
INCLUDE "library/nes/main/subroutine/circle2_b1.asm"
INCLUDE "library/nes/main/subroutine/sun_b1.asm"
INCLUDE "library/nes/main/subroutine/drawbackground_b3.asm"
INCLUDE "library/nes/main/subroutine/drawsystemimage_b3.asm"
INCLUDE "library/nes/main/subroutine/drawimagenames_b4.asm"
INCLUDE "library/nes/main/subroutine/drawcmdrimage_b6.asm"
INCLUDE "library/nes/main/subroutine/drawspriteimage_b6.asm"
INCLUDE "library/nes/main/subroutine/getheadshottype_b4.asm"
INCLUDE "library/nes/main/subroutine/drawequipment_b6.asm"
INCLUDE "library/nes/main/subroutine/death2_b0.asm"
INCLUDE "library/nes/main/subroutine/startgame_b0.asm"
INCLUDE "library/nes/main/subroutine/setviewattrs_b3.asm"
INCLUDE "library/nes/main/subroutine/fadetocolour_b3.asm"
INCLUDE "library/nes/main/subroutine/drawsmallbox_b3.asm"
INCLUDE "library/nes/main/subroutine/drawimageframe_b3.asm"
INCLUDE "library/nes/main/subroutine/drawlaunchbox_b6.asm"
INCLUDE "library/nes/main/subroutine/setlinepatterns_b3.asm"
INCLUDE "library/nes/main/subroutine/tt24_b6.asm"
INCLUDE "library/nes/main/subroutine/cleardashedge_b6.asm"
INCLUDE "library/nes/main/subroutine/loadnormalfont_b3.asm"
INCLUDE "library/nes/main/subroutine/loadhighfont_b3.asm"
INCLUDE "library/nes/main/subroutine/pas1_b0.asm"
INCLUDE "library/nes/main/subroutine/getsystemimage_b5.asm"
INCLUDE "library/nes/main/subroutine/getsystemback_b5.asm"
INCLUDE "library/nes/main/subroutine/getcmdrimage_b4.asm"
INCLUDE "library/nes/main/subroutine/getheadshot_b4.asm"
INCLUDE "library/nes/main/subroutine/dials_b6.asm"
INCLUDE "library/nes/main/subroutine/inputname_b6.asm"
INCLUDE "library/nes/main/subroutine/changetoview_b0.asm"
INCLUDE "library/nes/main/subroutine/ll164_b6.asm"
INCLUDE "library/nes/main/subroutine/drawlightning_b6.asm"
INCLUDE "library/nes/main/subroutine/pausegame_b6.asm"
INCLUDE "library/nes/main/subroutine/setkeylogger_b6.asm"
INCLUDE "library/nes/main/subroutine/changecmdrname_b6.asm"
INCLUDE "library/nes/main/subroutine/resetcommander_b6.asm"
INCLUDE "library/nes/main/subroutine/jameson_b6.asm"
INCLUDE "library/nes/main/subroutine/showscrolltext_b6.asm"
INCLUDE "library/nes/main/subroutine/beep_b7.asm"
INCLUDE "library/nes/main/subroutine/detok_b2.asm"
INCLUDE "library/nes/main/subroutine/dts_b2.asm"
INCLUDE "library/nes/main/subroutine/pdesc_b2.asm"
INCLUDE "library/nes/main/subroutine/setupiconbar_b3.asm"
INCLUDE "library/nes/main/subroutine/showiconbar_b3.asm"
INCLUDE "library/nes/main/subroutine/drawdashnames_b3.asm"
INCLUDE "library/nes/main/subroutine/resetscanner_b3.asm"
INCLUDE "library/nes/main/subroutine/resetscreen_b3.asm"
INCLUDE "library/nes/main/subroutine/updatescreen.asm"
INCLUDE "library/nes/main/subroutine/sendviewtoppu_b3.asm"
INCLUDE "library/nes/main/subroutine/setupfullviewinnmi.asm"
INCLUDE "library/nes/main/subroutine/setupviewinnmi_b3.asm"
INCLUDE "library/nes/main/subroutine/sendbitplanetoppu_b3.asm"
INCLUDE "library/nes/main/subroutine/updateiconbar_b3.asm"
INCLUDE "library/nes/main/subroutine/drawscreeninnmi_b0.asm"
INCLUDE "library/nes/main/subroutine/sve_b6.asm"
INCLUDE "library/nes/main/subroutine/mvs5_b0.asm"
INCLUDE "library/nes/main/subroutine/hall_b1.asm"
INCLUDE "library/nes/main/subroutine/chpr_b2.asm"
INCLUDE "library/nes/main/subroutine/dasc_b2.asm"
INCLUDE "library/nes/main/subroutine/tt27_b2.asm"
INCLUDE "library/nes/main/subroutine/ex_b2.asm"
INCLUDE "library/nes/main/subroutine/printctrlcode_b0.asm"
INCLUDE "library/nes/main/subroutine/setupafterload_b0.asm"
INCLUDE "library/nes/main/subroutine/hideship_b1.asm"
INCLUDE "library/nes/main/subroutine/hidefromscanner_b1.asm"
INCLUDE "library/nes/main/subroutine/tt66_b0.asm"
INCLUDE "library/nes/main/subroutine/clip_b1.asm"
INCLUDE "library/nes/main/subroutine/clearscreen_b3.asm"
INCLUDE "library/nes/main/subroutine/scan_b1.asm"
INCLUDE "library/nes/main/subroutine/updateviewwithfade.asm"
INCLUDE "library/nes/main/subroutine/updateview_b0.asm"
INCLUDE "library/nes/main/subroutine/updatehangarview.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/nes/main/variable/alertcolours.asm"
INCLUDE "library/nes/main/subroutine/getstatuscondition.asm"
INCLUDE "library/nes/main/subroutine/setupdemouniverse.asm"
INCLUDE "library/nes/main/subroutine/fixrandomnumbers.asm"
INCLUDE "library/nes/main/subroutine/resetoptions.asm"
INCLUDE "library/nes/main/subroutine/drawtitlescreen.asm"
INCLUDE "library/nes/main/variable/titleshiptype.asm"
INCLUDE "library/nes/main/variable/titleshipdist.asm"
INCLUDE "library/common/main/subroutine/ze.asm"
INCLUDE "library/nes/main/subroutine/updatesavecount.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/nes/main/subroutine/setdrawingplaneto0.asm"
INCLUDE "library/nes/main/subroutine/resetbuffers.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"
INCLUDE "library/common/main/subroutine/proj.asm"
INCLUDE "library/common/main/subroutine/pls6.asm"
INCLUDE "library/nes/main/subroutine/unpacktoram.asm"
INCLUDE "library/nes/main/subroutine/unpacktoppu.asm"
INCLUDE "library/nes/main/subroutine/farof2.asm"
INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mult3.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"
INCLUDE "library/common/main/subroutine/mls1.asm"
INCLUDE "library/common/main/subroutine/mu6.asm"
INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
INCLUDE "library/common/main/subroutine/mltu2.asm"
INCLUDE "library/common/main/subroutine/mut3.asm"
INCLUDE "library/common/main/subroutine/mut2.asm"
INCLUDE "library/common/main/subroutine/mut1.asm"
INCLUDE "library/common/main/subroutine/mult1.asm"
INCLUDE "library/common/main/subroutine/mult12.asm"
INCLUDE "library/common/main/subroutine/tas3.asm"
INCLUDE "library/common/main/subroutine/mad.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/common/main/subroutine/tis1.asm"
INCLUDE "library/common/main/subroutine/dv42.asm"
INCLUDE "library/common/main/subroutine/dv41.asm"
INCLUDE "library/advanced/main/subroutine/dvid4.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/nes/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/ll5.asm"
INCLUDE "library/common/main/subroutine/ll28.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/nes/main/subroutine/setupmmc1.asm"

IF _NTSC

 EQUB &F5, &F5, &F5     \ These bytes appear to be unused
 EQUB &F5, &F6, &F6
 EQUB &F6, &F6, &F7
 EQUB &F7, &F7, &F7
 EQUB &F7, &F8, &F8
 EQUB &F8, &F8, &F9
 EQUB &F9, &F9, &F9
 EQUB &F9, &FA, &FA
 EQUB &FA, &FA, &FA
 EQUB &FB, &FB, &FB
 EQUB &FB, &FB, &FC
 EQUB &FC, &FC, &FC
 EQUB &FC, &FD, &FD
 EQUB &FD, &FD, &FD
 EQUB &FD, &FE, &FE
 EQUB &FE, &FE, &FE
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF

ELIF _PAL

 EQUB &FF, &FF, &FF     \ These bytes appear to be unused
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF, &FF, &FF
 EQUB &FF

ENDIF

INCLUDE "library/nes/main/variable/lineimage.asm"
INCLUDE "library/nes/main/variable/fontimage.asm"

IF _NTSC

 EQUB &00, &8D, &06     \ These bytes appear to be unused
 EQUB &20, &A9, &4C
 EQUB &00, &C0, &45
 EQUB &4C, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &00, &00, &00
 EQUB &00, &38, &04
 EQUB &01, &07, &9C
 EQUB &2A

ELIF _PAL

 EQUB &FF, &FF, &FF     \ These bytes appear to be unused
 EQUB &FF, &FF, &4C
 EQUB &00, &C0, &45
 EQUB &4C, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &00, &00, &00
 EQUB &00, &38, &04
 EQUB &01, &07, &9C
 EQUB &2A

ENDIF

INCLUDE "library/nes/main/variable/vectors_b7.asm"

\ ******************************************************************************
\
\ Save bank7.bin
\
\ ******************************************************************************

 PRINT "S.bank7.bin ", ~CODE_BANK_7%, " ", ~P%, " ", ~LOAD_BANK_7%, " ", ~LOAD_BANK_7%
 SAVE "versions/nes/3-assembled-output/bank7.bin", CODE_BANK_7%, P%, LOAD_BANK_7%
