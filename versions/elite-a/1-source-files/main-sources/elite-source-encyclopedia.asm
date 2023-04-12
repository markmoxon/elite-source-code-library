\ ******************************************************************************
\
\ ELITE-A ENCYCLOPEDIA SOURCE
\
\ Elite-A is an extended version of BBC Micro Elite by Angus Duggan
\
\ The original Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984, and the extra code in Elite-A is copyright Angus Duggan
\
\ The code on this site is identical to Angus Duggan's source discs (it's just
\ been reformatted, and the label names have been changed to be consistent with
\ the sources for the original BBC Micro disc version on which it is based)
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
\   * 1.E.bin
\
\ ******************************************************************************

 INCLUDE "versions/elite-a/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
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
 _ELITE_A_ENCYCLOPEDIA  = TRUE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE
 _RELEASED              = (_VARIANT = 1)
 _SOURCE_DISC           = (_VARIANT = 2)
 _BUG_FIX               = (_VARIANT = 3)

 GUARD &6000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 NOST = 18              \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

 NOSH = 12              \ The maximum number of ships in our local bubble of
                        \ universe

 NTY = 31               \ The number of different ship types

 SST = 2                \ Ship blueprint position for the space station

 NI% = 37               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 X = 128                \ The centre x-coordinate of the 256 x 192 space view
 Y = 96                 \ The centre y-coordinate of the 256 x 192 space view

 f0 = &20               \ Internal key number for red key f0 (Launch, Front)
 f1 = &71               \ Internal key number for red key f1 (Buy Cargo, Rear)
 f2 = &72               \ Internal key number for red key f2 (Sell Cargo, Left)
 f3 = &73               \ Internal key number for red key f3 (Equip Ship, Right)
 f4 = &14               \ Internal key number for red key f4 (Long-range Chart)
 f5 = &74               \ Internal key number for red key f5 (Short-range Chart)
 f6 = &75               \ Internal key number for red key f6 (Data on System)
 f7 = &16               \ Internal key number for red key f7 (Market Price)
 f8 = &76               \ Internal key number for red key f8 (Status Mode)
 f9 = &77               \ Internal key number for red key f9 (Inventory)

 VE = 0                 \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code, which is
                        \ zero in Elite-A as the token table is not obfuscated

 LL = 30                \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

 QQ18 = &0400           \ The address of the text token table, as set in
                        \ elite-loader.asm

 SNE = &07C0            \ The address of the sine lookup table, as set in
                        \ elite-loader.asm

 LS% = &0CFF            \ The start of the descending ship line heap

 IRQ1 = &114B           \ The address of the IRQ1 routine that implements the
                        \ split screen interrupt handler, as set in
                        \ elite-loader.asm

 NA% = &1181            \ The address of the data block for the last saved
                        \ commander, as set in elite-loader.asm

 XX21 = &5600           \ The address of the ship blueprints lookup table, where
                        \ the chosen ship blueprints file is loaded

 VIA = &FE00            \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

 OSWORD = &FFF1         \ The address for the OSWORD routine
 OSBYTE = &FFF4         \ The address for the OSBYTE routine
 OSCLI = &FFF7          \ The address for the OSCLI routine

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/enhanced/main/workspace/up.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/common/main/workspace/wp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ ******************************************************************************

 CODE% = &11E3
 LOAD% = &11E3

 ORG CODE%

 LOAD_A% = LOAD%

INCLUDE "library/disc/docked/workspace/s_per_cent.asm"
INCLUDE "library/disc/flight/subroutine/inbay.asm"
INCLUDE "library/disc/flight/variable/ltli.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/launch.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/escape.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/doentry.asm"
INCLUDE "library/enhanced/main/subroutine/brkbk-cold.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/write_msg3.asm"
INCLUDE "library/enhanced/main/subroutine/mt27.asm"
INCLUDE "library/enhanced/main/subroutine/mt28.asm"
INCLUDE "library/enhanced/main/subroutine/detok.asm"
INCLUDE "library/enhanced/main/subroutine/detok2.asm"
INCLUDE "library/enhanced/main/subroutine/mt1.asm"
INCLUDE "library/enhanced/main/subroutine/mt2.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/column_16.asm"
INCLUDE "library/enhanced/main/subroutine/mt8.asm"
INCLUDE "library/enhanced/main/subroutine/mt9.asm"
INCLUDE "library/enhanced/main/subroutine/mt13.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/clr_vdustat.asm"
INCLUDE "library/enhanced/main/subroutine/mt6.asm"
INCLUDE "library/enhanced/main/subroutine/mt5.asm"
INCLUDE "library/enhanced/main/subroutine/mt14.asm"
INCLUDE "library/enhanced/main/subroutine/mt15.asm"
INCLUDE "library/enhanced/main/subroutine/mt17.asm"
INCLUDE "library/enhanced/main/subroutine/mt18.asm"
INCLUDE "library/enhanced/main/subroutine/mt19.asm"
INCLUDE "library/enhanced/main/subroutine/vowel.asm"
INCLUDE "library/enhanced/main/variable/jmtb.asm"
INCLUDE "library/enhanced/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/common/main/subroutine/mveit_part_1_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_7_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_8_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_9_of_9.asm"
INCLUDE "library/common/main/subroutine/mvs4.asm"
INCLUDE "library/common/main/subroutine/mvs5.asm"
INCLUDE "library/common/main/variable/univ.asm"

\ ******************************************************************************
\
\ Save ELTA.bin
\
\ ******************************************************************************

 PRINT "ELITE A"
 PRINT "Assembled at ", ~CODE%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_A%

 PRINT "S.F.ELTA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_A%
\SAVE "versions/elite-a/3-assembled-output/F.ELTA.bin", CODE%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ ******************************************************************************

 CODE_B% = P%
 LOAD_B% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/ctwos.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/enhanced/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/original/main/subroutine/px3.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"
INCLUDE "library/common/main/subroutine/bline.asm"
INCLUDE "library/common/main/variable/tens.asm"
INCLUDE "library/common/main/subroutine/pr2.asm"
INCLUDE "library/common/main/subroutine/tt11.asm"
INCLUDE "library/common/main/subroutine/bprnt.asm"
INCLUDE "library/enhanced/main/variable/dtw1.asm"
INCLUDE "library/enhanced/main/variable/dtw2.asm"
INCLUDE "library/enhanced/main/variable/dtw3.asm"
INCLUDE "library/enhanced/main/variable/dtw4.asm"
INCLUDE "library/enhanced/main/variable/dtw5.asm"
INCLUDE "library/enhanced/main/variable/dtw6.asm"
INCLUDE "library/enhanced/main/variable/dtw8.asm"
INCLUDE "library/enhanced/main/subroutine/feed.asm"
INCLUDE "library/enhanced/main/subroutine/mt16.asm"
INCLUDE "library/enhanced/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/enhanced/main/subroutine/hme2.asm"

\ ******************************************************************************
\
\ Save ELTB.bin
\
\ ******************************************************************************

 PRINT "ELITE B"
 PRINT "Assembled at ", ~CODE_B%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_B%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_B%

 PRINT "S.F.ELTB ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_B%
\SAVE "versions/elite-a/3-assembled-output/F.ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ ******************************************************************************

 CODE_C% = P%
 LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
INCLUDE "library/common/main/subroutine/mult1.asm"
INCLUDE "library/common/main/subroutine/mult12.asm"
INCLUDE "library/common/main/subroutine/mad.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/common/main/subroutine/tis1.asm"
INCLUDE "library/enhanced/main/subroutine/pdesc.asm"
INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"
INCLUDE "library/common/main/subroutine/tt66.asm"
INCLUDE "library/common/main/subroutine/ttx66-ttx662.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/original/main/subroutine/lyn.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"

\ ******************************************************************************
\
\ Save ELTC.bin
\
\ ******************************************************************************

 PRINT "ELITE C"
 PRINT "Assembled at ", ~CODE_C%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_C%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_C%

 PRINT "S.F.ELTC ", ~CODE_C%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_C%
\SAVE "versions/elite-a/3-assembled-output/F.ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ ******************************************************************************

 CODE_D% = P%
 LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/tt20.asm"
INCLUDE "library/common/main/subroutine/tt54.asm"
INCLUDE "library/common/main/subroutine/tt146.asm"
INCLUDE "library/common/main/subroutine/tt60.asm"
INCLUDE "library/common/main/subroutine/ttx69.asm"
INCLUDE "library/common/main/subroutine/tt67.asm"
INCLUDE "library/common/main/subroutine/tt70.asm"
INCLUDE "library/common/main/subroutine/spc.asm"
INCLUDE "library/common/main/subroutine/tt25.asm"
INCLUDE "library/common/main/subroutine/tt24.asm"
INCLUDE "library/common/main/subroutine/tt22.asm"
INCLUDE "library/common/main/subroutine/tt15.asm"
INCLUDE "library/common/main/subroutine/tt14.asm"
INCLUDE "library/common/main/subroutine/tt128.asm"
INCLUDE "library/common/main/subroutine/tt16.asm"
INCLUDE "library/common/main/subroutine/tt103.asm"
INCLUDE "library/common/main/subroutine/tt123.asm"
INCLUDE "library/common/main/subroutine/tt105.asm"
INCLUDE "library/common/main/subroutine/tt23.asm"
INCLUDE "library/common/main/subroutine/tt81.asm"
INCLUDE "library/common/main/subroutine/tt111.asm"
INCLUDE "library/common/main/subroutine/pr6.asm"
INCLUDE "library/common/main/subroutine/pr5.asm"
INCLUDE "library/common/main/subroutine/tt162.asm"
INCLUDE "library/elite-a/encyclopedia/variable/func_tab.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/buy_invnt.asm"
INCLUDE "library/common/main/subroutine/gnum.asm"
INCLUDE "library/common/main/subroutine/dn2.asm"
INCLUDE "library/common/main/subroutine/hm.asm"

\ ******************************************************************************
\
\ Save ELTD.bin
\
\ ******************************************************************************

 PRINT "ELITE D"
 PRINT "Assembled at ", ~CODE_D%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_D%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_D%

 PRINT "S.F.ELTD ", ~CODE_D%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_D%
\SAVE "versions/elite-a/3-assembled-output/F.ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
\
\ ******************************************************************************

 CODE_E% = P%
 LOAD_E% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/cpl.asm"
INCLUDE "library/common/main/subroutine/cmn.asm"
INCLUDE "library/common/main/subroutine/ypl.asm"
INCLUDE "library/common/main/subroutine/tal.asm"
INCLUDE "library/common/main/subroutine/fwl.asm"
INCLUDE "library/common/main/subroutine/csh.asm"
INCLUDE "library/common/main/subroutine/plf.asm"
INCLUDE "library/common/main/subroutine/tt68.asm"
INCLUDE "library/common/main/subroutine/tt73.asm"
INCLUDE "library/common/main/subroutine/tt27.asm"
INCLUDE "library/common/main/subroutine/tt42.asm"
INCLUDE "library/common/main/subroutine/tt41.asm"
INCLUDE "library/common/main/subroutine/qw.asm"
INCLUDE "library/common/main/subroutine/crlf.asm"
INCLUDE "library/common/main/subroutine/tt45.asm"
INCLUDE "library/common/main/subroutine/tt46.asm"
INCLUDE "library/common/main/subroutine/tt74.asm"
INCLUDE "library/common/main/subroutine/tt43.asm"
INCLUDE "library/common/main/subroutine/ex.asm"
INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/flflls.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/sun_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"
INCLUDE "library/common/main/subroutine/edges.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/tt17.asm"
INCLUDE "library/common/main/subroutine/ping.asm"

\ ******************************************************************************
\
\ Save ELTE.bin
\
\ ******************************************************************************

 PRINT "ELITE E"
 PRINT "Assembled at ", ~CODE_E%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_E%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_E%

 PRINT "S.F.ELTE ", ~CODE_E%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_E%
\SAVE "versions/elite-a/3-assembled-output/F.ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
\
\ ******************************************************************************

 CODE_F% = P%
 LOAD_F% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/sfx.asm"
INCLUDE "library/common/main/subroutine/res2.asm"
INCLUDE "library/common/main/subroutine/zinf.asm"
INCLUDE "library/common/main/subroutine/me2.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_2_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"
INCLUDE "library/common/main/subroutine/tt102.asm"
INCLUDE "library/enhanced/main/variable/brkd.asm"
INCLUDE "library/common/main/subroutine/br1_part_1_of_2.asm"
INCLUDE "library/enhanced/main/subroutine/brbr-newbrk.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/common/main/variable/rline.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/common/main/subroutine/rdkey.asm"
INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/noise.asm"
INCLUDE "library/common/main/subroutine/no3.asm"
INCLUDE "library/common/main/subroutine/nos1.asm"
INCLUDE "library/common/main/subroutine/ctrl.asm"
INCLUDE "library/common/main/subroutine/dks4-dks5.asm"
INCLUDE "library/common/main/subroutine/dks2.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dokey.asm"
INCLUDE "library/common/main/subroutine/dk4.asm"
INCLUDE "library/common/main/subroutine/tt217.asm"
INCLUDE "library/common/main/subroutine/me1.asm"
INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"

\ ******************************************************************************
\
\ Save ELTF.bin
\
\ ******************************************************************************

 PRINT "ELITE F"
 PRINT "Assembled at ", ~CODE_F%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_F%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_F%

 PRINT "S.F.ELTF ", ~CODE_F%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_F%
\SAVE "versions/elite-a/3-assembled-output/F.ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ ******************************************************************************

 CODE_G% = P%
 LOAD_G% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/shppt.asm"
INCLUDE "library/common/main/subroutine/ll5.asm"
INCLUDE "library/common/main/subroutine/ll28.asm"
INCLUDE "library/common/main/subroutine/ll38.asm"
INCLUDE "library/common/main/subroutine/ll51.asm"
INCLUDE "library/common/main/subroutine/ll9_part_1_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_2_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_3_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_4_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_5_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_6_of_12.asm"
INCLUDE "library/common/main/subroutine/ll61.asm"
INCLUDE "library/common/main/subroutine/ll62.asm"
INCLUDE "library/common/main/subroutine/ll9_part_7_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_8_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_9_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_10_of_12.asm"
INCLUDE "library/common/main/subroutine/ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/ll9_part_11_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_12_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"

\ ******************************************************************************
\
\ Save ELTG.bin
\
\ ******************************************************************************

 PRINT "ELITE G"
 PRINT "Assembled at ", ~CODE_G%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_G%)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD_G%

 PRINT "S.F.ELTG ", ~CODE_G%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_G%
\SAVE "versions/elite-a/3-assembled-output/F.ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE H FILE
\
\ ******************************************************************************

 CODE_H% = P%
 LOAD_H% = LOAD% + P% - CODE%

INCLUDE "library/elite-a/encyclopedia/subroutine/info_menu.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/ships_ag.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/controls.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/equip_data.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/trading.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/write_card.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ship_load.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ship_file.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ship_posn.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ship_dist.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/menu.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_title.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_titlex.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_offset.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_entry.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_query.asm"
INCLUDE "library/enhanced/main/macro/ejmp.asm"
INCLUDE "library/enhanced/main/macro/echr.asm"
INCLUDE "library/enhanced/main/macro/etok.asm"
INCLUDE "library/enhanced/main/macro/etwo.asm"
INCLUDE "library/enhanced/main/macro/ernd.asm"
INCLUDE "library/enhanced/main/macro/tokn.asm"
INCLUDE "library/enhanced/main/variable/tkn1.asm"
INCLUDE "library/elite-a/encyclopedia/variable/msg_3.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ship_centre.asm"
INCLUDE "library/elite-a/encyclopedia/variable/card_pattern.asm"
INCLUDE "library/elite-a/encyclopedia/variable/card_addr.asm"
INCLUDE "library/elite-a/encyclopedia/macro/ctok.asm"
INCLUDE "library/elite-a/encyclopedia/variable/adder.asm"
INCLUDE "library/elite-a/encyclopedia/variable/anaconda.asm"
INCLUDE "library/elite-a/encyclopedia/variable/asp_2.asm"
INCLUDE "library/elite-a/encyclopedia/variable/boa.asm"
INCLUDE "library/elite-a/encyclopedia/variable/bushmaster.asm"
INCLUDE "library/elite-a/encyclopedia/variable/chameleon.asm"
INCLUDE "library/elite-a/encyclopedia/variable/cobra_1.asm"
INCLUDE "library/elite-a/encyclopedia/variable/cobra_3.asm"
INCLUDE "library/elite-a/encyclopedia/variable/coriolis.asm"
INCLUDE "library/elite-a/encyclopedia/variable/dodecagon.asm"
INCLUDE "library/elite-a/encyclopedia/variable/escape_pod.asm"
INCLUDE "library/elite-a/encyclopedia/variable/fer_de_lance.asm"
INCLUDE "library/elite-a/encyclopedia/variable/gecko.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ghavial.asm"
INCLUDE "library/elite-a/encyclopedia/variable/iguana.asm"
INCLUDE "library/elite-a/encyclopedia/variable/krait.asm"
INCLUDE "library/elite-a/encyclopedia/variable/mamba.asm"
INCLUDE "library/elite-a/encyclopedia/variable/monitor.asm"
INCLUDE "library/elite-a/encyclopedia/variable/moray.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ophidian.asm"
INCLUDE "library/elite-a/encyclopedia/variable/python.asm"
INCLUDE "library/elite-a/encyclopedia/variable/shuttle.asm"
INCLUDE "library/elite-a/encyclopedia/variable/sidewinder.asm"
INCLUDE "library/elite-a/encyclopedia/variable/thargoid.asm"
INCLUDE "library/elite-a/encyclopedia/variable/thargon.asm"
INCLUDE "library/elite-a/encyclopedia/variable/transporter.asm"
INCLUDE "library/elite-a/encyclopedia/variable/viper.asm"
INCLUDE "library/elite-a/encyclopedia/variable/worm.asm"

\ ******************************************************************************
\
\ Save 1.E.bin
\
\ ******************************************************************************

 PRINT "S.1.E ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/elite-a/3-assembled-output/1.E.bin", CODE%, P%, LOAD%