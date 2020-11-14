\ ******************************************************************************
\
\ ELITE GAME SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary files:
\
\   * output/ELTA.bin
\   * output/ELTB.bin
\   * output/ELTC.bin
\   * output/ELTD.bin
\   * output/ELTE.bin
\   * output/ELTF.bin
\   * output/ELTG.bin
\   * output/PYTHON.bin
\   * output/SHIPS.bin
\   * output/WORDS9.bin
\
\ ******************************************************************************

INCLUDE "cassette/sources/elite-header.h.asm"

_REMOVE_COMMANDER_CHECK = TRUE AND _REMOVE_CHECKSUMS
_ENABLE_MAX_COMMANDER   = TRUE AND _REMOVE_CHECKSUMS
_CASSETTE_VERSION       = TRUE AND (_VERSION = 1)
_DISC_VERSION           = TRUE AND (_VERSION = 2)
_6502SP_VERSION         = TRUE AND (_VERSION = 3)

GUARD &6000             \ Screen memory starts here
GUARD &8000             \ Paged ROMS start here

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

NOST = 18               \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

NOSH = 12               \ The maximum number of ships in our local bubble of
                        \ universe (counting from 0, so there are actually 13
                        \ ship slots)

NTY = 13                \ The number of different ship types

COPS = 2                \ Ship type for a Viper
MAM = 3                 \ Ship type for a Mamba
THG = 6                 \ Ship type for a Thargoid
CYL = 7                 \ Ship type for a Cobra Mk III (trader)
SST = 8                 \ Ship type for the space station
MSL = 9                 \ Ship type for a missile
AST = 10                \ Ship type for an asteroid
OIL = 11                \ Ship type for a cargo canister
TGL = 12                \ Ship type for a Thargon
ESC = 13                \ Ship type for an escape pod

POW = 15                \ Pulse laser power

NI% = 36                \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

OSBYTE = &FFF4          \ The address for the OSBYTE routine, which is used
                        \ three times in the main game code

OSWORD = &FFF1          \ The address for the OSWORD routine, which is used
                        \ twice in the main game code

OSFILE = &FFDD          \ The address for the OSFILE routine, which is used
                        \ once in the main game code

SHEILA = &FE00          \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs

VSCAN = 57              \ Defines the split position in the split-screen mode

X = 128                 \ The centre x-coordinate of the 256 x 192 space view

Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

f0 = &20                \ Internal key number for red key f0 (Launch, Front)
f1 = &71                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &72                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &73                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &14                \ Internal key number for red key f4 (Long-range Chart)
f5 = &74                \ Internal key number for red key f5 (Short-range Chart)
f6 = &75                \ Internal key number for red key f6 (Data on System)
f7 = &16                \ Internal key number for red key f7 (Market Price)
f8 = &76                \ Internal key number for red key f8 (Status Mode)
f9 = &77                \ Internal key number for red key f9 (Inventory)

INCLUDE "library/common/main/workspace_zp.asm"
INCLUDE "library/common/main/workspace_xx3.asm"
INCLUDE "library/common/main/workspace_t_per_cent.asm"

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ Produces the binary file WORDS9.bin that gets loaded by elite-loader.asm.
\
\ The recursive token table is loaded at &1100 and is moved down to &0400 as
\ part of elite-loader.asm, so it ends up at &0400 to &07FF.
\
\ ******************************************************************************

CODE_WORDS% = &0400
LOAD_WORDS% = &1100

ORG CODE_WORDS%

INCLUDE "library/common/main/macro_char.asm"
INCLUDE "library/common/main/macro_twok.asm"
INCLUDE "library/common/main/macro_ctrl.asm"
INCLUDE "library/common/main/macro_rtok.asm"
INCLUDE "library/common/main/variable_qq18.asm"

\ ******************************************************************************
\
\ Save output/WORDS9.bin
\
\ ******************************************************************************

PRINT "WORDS9"
PRINT "Assembled at ", ~CODE_WORDS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_WORDS%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_WORDS%

PRINT "S.WORDS9 ",~CODE%," ",~P%," ",~LOAD%," ",~LOAD_WORDS%
SAVE "cassette/output/WORDS9.bin", CODE_WORDS%, P%, LOAD%

INCLUDE "library/common/main/workspace_k_per_cent.asm"
INCLUDE "library/common/main/workspace_wp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ Produces the binary file ELTA.bin that gets loaded by elite-bcfs.asm.
\
\ The main game code (ELITE A through G, plus the ship data) is loaded at &1128
\ and is moved down to &0F40 as part of elite-loader.asm.
\
\ ******************************************************************************

CODE% = &0F40
LOAD% = &1128

ORG CODE%

LOAD_A% = LOAD%

INCLUDE "library/cassette/main/workspace_s_per_cent.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_1_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_2_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_3_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_4_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_5_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_6_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_7_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_8_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_9_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_10_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_11_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_12_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_13_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_14_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_15_of_16.asm"
INCLUDE "library/common/main/subroutine_main_flight_loop_part_16_of_16.asm"
INCLUDE "library/common/main/subroutine_mas1.asm"
INCLUDE "library/common/main/subroutine_mas2.asm"
INCLUDE "library/common/main/subroutine_mas3.asm"
INCLUDE "library/common/main/subroutine_mveit_part_1_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_2_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_3_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_4_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_5_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_6_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_7_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_8_of_9.asm"
INCLUDE "library/common/main/subroutine_mveit_part_9_of_9.asm"
INCLUDE "library/common/main/subroutine_mvt1.asm"
INCLUDE "library/common/main/subroutine_mvt3.asm"
INCLUDE "library/common/main/subroutine_mvs4.asm"
INCLUDE "library/common/main/subroutine_mvs5.asm"
INCLUDE "library/common/main/subroutine_mvt6.asm"
INCLUDE "library/common/main/subroutine_mv40.asm"

\ ******************************************************************************
\
\ Save output/ELTA.bin
\
\ ******************************************************************************

PRINT "ELITE A"
PRINT "Assembled at ", ~CODE%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_A%

PRINT "S.ELTA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_A%
SAVE "cassette/output/ELTA.bin", CODE%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ Produces the binary file ELTB.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_B% = P%
LOAD_B% = LOAD% + P% - CODE%
Q% = _ENABLE_MAX_COMMANDER

INCLUDE "library/common/main/variable_na_per_cent.asm"
INCLUDE "library/common/main/variable_chk2.asm"
INCLUDE "library/common/main/variable_chk.asm"
INCLUDE "library/common/main/variable_univ.asm"
INCLUDE "library/common/main/variable_twos.asm"
INCLUDE "library/common/main/variable_twos2.asm"
INCLUDE "library/common/main/variable_ctwos.asm"
INCLUDE "library/cassette/main/subroutine_loin.asm"
INCLUDE "library/common/main/subroutine_nlin3.asm"
INCLUDE "library/common/main/subroutine_nlin4.asm"
INCLUDE "library/common/main/subroutine_nlin.asm"
INCLUDE "library/common/main/subroutine_nlin2.asm"
INCLUDE "library/common/main/subroutine_hloin2.asm"
INCLUDE "library/cassette/main/subroutine_hloin.asm"
INCLUDE "library/common/main/variable_twfl.asm"
INCLUDE "library/common/main/variable_twfr.asm"
INCLUDE "library/cassette/main/subroutine_px3.asm"
INCLUDE "library/common/main/subroutine_pix1.asm"
INCLUDE "library/common/main/subroutine_pixel2.asm"
INCLUDE "library/cassette/main/subroutine_pixel.asm"
INCLUDE "library/common/main/subroutine_bline.asm"
INCLUDE "library/common/main/subroutine_flip.asm"
INCLUDE "library/common/main/subroutine_stars.asm"
INCLUDE "library/common/main/subroutine_stars1.asm"
INCLUDE "library/common/main/subroutine_stars6.asm"
INCLUDE "library/common/main/variable_prxs.asm"
INCLUDE "library/common/main/subroutine_status.asm"
INCLUDE "library/common/main/subroutine_plf2.asm"
INCLUDE "library/common/main/variable_tens.asm"
INCLUDE "library/common/main/subroutine_pr2.asm"
INCLUDE "library/common/main/subroutine_tt11.asm"
INCLUDE "library/common/main/subroutine_bprnt.asm"
INCLUDE "library/common/main/subroutine_bell.asm"
INCLUDE "library/common/main/subroutine_tt26.asm"
INCLUDE "library/common/main/subroutine_dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine_dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine_dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine_dials_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine_pzw.asm"
INCLUDE "library/common/main/subroutine_dilx.asm"
INCLUDE "library/common/main/subroutine_dil2.asm"
INCLUDE "library/cassette/main/variable_tvt1.asm"
INCLUDE "library/common/main/subroutine_irq1.asm"
INCLUDE "library/common/main/subroutine_escape.asm"

\ ******************************************************************************
\
\ Save output/ELTB.bin
\
\ ******************************************************************************

PRINT "ELITE B"
PRINT "Assembled at ", ~CODE_B%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_B%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_B%

PRINT "S.ELTB ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_B%
SAVE "cassette/output/ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ Produces the binary file ELTC.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_C% = P%
LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/common/main/subroutine_tactics_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine_tas1.asm"
INCLUDE "library/common/main/subroutine_hitch.asm"
INCLUDE "library/common/main/subroutine_frs1.asm"
INCLUDE "library/common/main/subroutine_frmis.asm"
INCLUDE "library/common/main/subroutine_angry.asm"
INCLUDE "library/common/main/subroutine_fr1.asm"
INCLUDE "library/common/main/subroutine_sescp.asm"
INCLUDE "library/common/main/subroutine_sfs1.asm"
INCLUDE "library/common/main/subroutine_sfs2.asm"
INCLUDE "library/common/main/subroutine_ll164.asm"
INCLUDE "library/common/main/subroutine_laun.asm"
INCLUDE "library/common/main/subroutine_hfs2.asm"
INCLUDE "library/common/main/subroutine_stars2.asm"
INCLUDE "library/common/main/variable_sne.asm"
INCLUDE "library/common/main/subroutine_mu5.asm"
INCLUDE "library/common/main/subroutine_mult3.asm"
INCLUDE "library/common/main/subroutine_mls2.asm"
INCLUDE "library/common/main/subroutine_mls1.asm"
INCLUDE "library/common/main/subroutine_squa.asm"
INCLUDE "library/common/main/subroutine_squa2.asm"
INCLUDE "library/common/main/subroutine_mu1.asm"
INCLUDE "library/common/main/subroutine_mlu1.asm"
INCLUDE "library/common/main/subroutine_mlu2.asm"
INCLUDE "library/common/main/subroutine_multu.asm"
INCLUDE "library/common/main/subroutine_mu11.asm"
INCLUDE "library/common/main/subroutine_mu6.asm"
INCLUDE "library/common/main/subroutine_fmltu2.asm"
INCLUDE "library/common/main/subroutine_fmltu.asm"
INCLUDE "library/cassette/main/subroutine_unused_duplicate_of_multu.asm"
INCLUDE "library/common/main/subroutine_mltu2.asm"
INCLUDE "library/common/main/subroutine_mut3.asm"
INCLUDE "library/common/main/subroutine_mut2.asm"
INCLUDE "library/common/main/subroutine_mut1.asm"
INCLUDE "library/common/main/subroutine_mult1.asm"
INCLUDE "library/common/main/subroutine_mult12.asm"
INCLUDE "library/common/main/subroutine_tas3.asm"
INCLUDE "library/common/main/subroutine_mad.asm"
INCLUDE "library/common/main/subroutine_add.asm"
INCLUDE "library/common/main/subroutine_tis1.asm"
INCLUDE "library/common/main/subroutine_dv42.asm"
INCLUDE "library/common/main/subroutine_dv41.asm"
INCLUDE "library/common/main/subroutine_dvid4.asm"
INCLUDE "library/common/main/subroutine_dvid3b2.asm"
INCLUDE "library/common/main/subroutine_cntr.asm"
INCLUDE "library/common/main/subroutine_bump2.asm"
INCLUDE "library/common/main/subroutine_redu2.asm"
INCLUDE "library/common/main/subroutine_arctan.asm"
INCLUDE "library/common/main/variable_act.asm"
INCLUDE "library/common/main/subroutine_warp.asm"
INCLUDE "library/common/main/subroutine_lasli.asm"
INCLUDE "library/common/main/subroutine_plut.asm"
INCLUDE "library/common/main/subroutine_look1.asm"
INCLUDE "library/common/main/subroutine_tt66.asm"
INCLUDE "library/common/main/subroutine_ttx66.asm"
INCLUDE "library/common/main/subroutine_delay.asm"
INCLUDE "library/common/main/subroutine_hm.asm"
INCLUDE "library/cassette/main/subroutine_clyns.asm"
INCLUDE "library/cassette/main/subroutine_lyn.asm"
INCLUDE "library/common/main/subroutine_scan.asm"
INCLUDE "library/common/main/subroutine_wscan.asm"

\ ******************************************************************************
\
\ Save output/ELTC.bin
\
\ ******************************************************************************

PRINT "ELITE C"
PRINT "Assembled at ", ~CODE_C%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_C%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_C%

PRINT "S.ELTC ", ~CODE_C%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_C%
SAVE "cassette/output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ Produces the binary file ELTD.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_D% = P%
LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine_tnpr.asm"
INCLUDE "library/common/main/subroutine_tt20.asm"
INCLUDE "library/common/main/subroutine_tt54.asm"
INCLUDE "library/common/main/subroutine_tt146.asm"
INCLUDE "library/common/main/subroutine_tt60.asm"
INCLUDE "library/common/main/subroutine_ttx69.asm"
INCLUDE "library/common/main/subroutine_tt69.asm"
INCLUDE "library/common/main/subroutine_tt67.asm"
INCLUDE "library/common/main/subroutine_tt70.asm"
INCLUDE "library/common/main/subroutine_spc.asm"
INCLUDE "library/common/main/subroutine_tt25.asm"
INCLUDE "library/common/main/subroutine_tt24.asm"
INCLUDE "library/common/main/subroutine_tt22.asm"
INCLUDE "library/common/main/subroutine_tt15.asm"
INCLUDE "library/common/main/subroutine_tt14.asm"
INCLUDE "library/common/main/subroutine_tt128.asm"
INCLUDE "library/common/main/subroutine_tt219.asm"
INCLUDE "library/common/main/subroutine_gnum.asm"
INCLUDE "library/common/main/subroutine_tt208.asm"
INCLUDE "library/common/main/subroutine_tt210.asm"
INCLUDE "library/common/main/subroutine_tt213.asm"
INCLUDE "library/common/main/subroutine_tt214.asm"
INCLUDE "library/common/main/subroutine_tt16.asm"
INCLUDE "library/common/main/subroutine_tt103.asm"
INCLUDE "library/common/main/subroutine_tt123.asm"
INCLUDE "library/common/main/subroutine_tt105.asm"
INCLUDE "library/common/main/subroutine_tt23.asm"
INCLUDE "library/common/main/subroutine_tt81.asm"
INCLUDE "library/common/main/subroutine_tt111.asm"
INCLUDE "library/common/main/subroutine_hy6.asm"
INCLUDE "library/common/main/subroutine_hyp.asm"
INCLUDE "library/common/main/subroutine_ww.asm"
INCLUDE "library/common/main/subroutine_ghy.asm"
INCLUDE "library/common/main/subroutine_jmp.asm"
INCLUDE "library/common/main/subroutine_ee3.asm"
INCLUDE "library/common/main/subroutine_pr6.asm"
INCLUDE "library/common/main/subroutine_pr5.asm"
INCLUDE "library/common/main/subroutine_tt147.asm"
INCLUDE "library/common/main/subroutine_prq.asm"
INCLUDE "library/common/main/subroutine_tt151.asm"
INCLUDE "library/common/main/subroutine_tt152.asm"
INCLUDE "library/common/main/subroutine_tt162.asm"
INCLUDE "library/common/main/subroutine_tt160.asm"
INCLUDE "library/common/main/subroutine_tt161.asm"
INCLUDE "library/common/main/subroutine_tt16a.asm"
INCLUDE "library/common/main/subroutine_tt163.asm"
INCLUDE "library/common/main/subroutine_tt167.asm"
INCLUDE "library/common/main/subroutine_var.asm"
INCLUDE "library/common/main/subroutine_hyp1.asm"
INCLUDE "library/common/main/subroutine_gvl.asm"
INCLUDE "library/common/main/subroutine_gthg.asm"
INCLUDE "library/common/main/subroutine_mjp.asm"
INCLUDE "library/common/main/subroutine_tt18.asm"
INCLUDE "library/common/main/subroutine_tt110.asm"
INCLUDE "library/common/main/subroutine_tt114.asm"
INCLUDE "library/common/main/subroutine_lcash.asm"
INCLUDE "library/common/main/subroutine_mcash.asm"
INCLUDE "library/common/main/subroutine_gcash.asm"
INCLUDE "library/common/main/subroutine_gc2.asm"
INCLUDE "library/common/main/subroutine_eqshp.asm"
INCLUDE "library/common/main/subroutine_dn.asm"
INCLUDE "library/common/main/subroutine_dn2.asm"
INCLUDE "library/common/main/subroutine_eq.asm"
INCLUDE "library/common/main/subroutine_prx.asm"
INCLUDE "library/common/main/subroutine_qv.asm"

\ ******************************************************************************
\
\ Save output/ELTD.bin
\
\ ******************************************************************************

PRINT "ELITE D"
PRINT "Assembled at ", ~CODE_D%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_D%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_D%

PRINT "S.ELTD ", ~CODE_D%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_D%
SAVE "cassette/output/ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
\
\ Produces the binary file ELTE.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_E% = P%
LOAD_E% = LOAD% + P% - CODE%

INCLUDE "library/cassette/main/variable_authors_names.asm"
INCLUDE "library/common/main/subroutine_cpl.asm"
INCLUDE "library/common/main/subroutine_cmn.asm"
INCLUDE "library/common/main/subroutine_ypl.asm"
INCLUDE "library/common/main/subroutine_tal.asm"
INCLUDE "library/common/main/subroutine_fwl.asm"
INCLUDE "library/common/main/subroutine_csh.asm"
INCLUDE "library/common/main/subroutine_plf.asm"
INCLUDE "library/common/main/subroutine_tt68.asm"
INCLUDE "library/common/main/subroutine_tt73.asm"
INCLUDE "library/common/main/subroutine_tt27.asm"
INCLUDE "library/common/main/subroutine_tt42.asm"
INCLUDE "library/common/main/subroutine_tt41.asm"
INCLUDE "library/common/main/subroutine_qw.asm"
INCLUDE "library/common/main/subroutine_crlf.asm"
INCLUDE "library/common/main/subroutine_tt45.asm"
INCLUDE "library/common/main/subroutine_tt46.asm"
INCLUDE "library/common/main/subroutine_tt74.asm"
INCLUDE "library/common/main/subroutine_tt43.asm"
INCLUDE "library/common/main/subroutine_ex.asm"
INCLUDE "library/common/main/subroutine_doexp.asm"
INCLUDE "library/common/main/subroutine_sos1.asm"
INCLUDE "library/common/main/subroutine_solar.asm"
INCLUDE "library/common/main/subroutine_nwstars.asm"
INCLUDE "library/common/main/subroutine_nwq.asm"
INCLUDE "library/common/main/subroutine_wpshps.asm"
INCLUDE "library/common/main/subroutine_flflls.asm"
INCLUDE "library/common/main/subroutine_det1.asm"
INCLUDE "library/common/main/subroutine_shd.asm"
INCLUDE "library/common/main/subroutine_dengy.asm"
INCLUDE "library/common/main/subroutine_compas.asm"
INCLUDE "library/common/main/subroutine_sps2.asm"
INCLUDE "library/common/main/subroutine_sps4.asm"
INCLUDE "library/common/main/subroutine_sp1.asm"
INCLUDE "library/common/main/subroutine_sp2.asm"
INCLUDE "library/cassette/main/subroutine_dot.asm"
INCLUDE "library/common/main/subroutine_cpix4.asm"
INCLUDE "library/common/main/subroutine_cpix2.asm"
INCLUDE "library/common/main/subroutine_oops.asm"
INCLUDE "library/common/main/subroutine_sps3.asm"
INCLUDE "library/common/main/subroutine_ginf.asm"
INCLUDE "library/common/main/subroutine_nwsps.asm"
INCLUDE "library/common/main/subroutine_nwshp.asm"
INCLUDE "library/common/main/subroutine_nws1.asm"
INCLUDE "library/common/main/subroutine_abort.asm"
INCLUDE "library/common/main/subroutine_abort2.asm"
INCLUDE "library/common/main/subroutine_ecblb2.asm"
INCLUDE "library/cassette/main/subroutine_ecblb.asm"
INCLUDE "library/cassette/main/subroutine_spblb.asm"
INCLUDE "library/cassette/main/subroutine_bulb.asm"
INCLUDE "library/common/main/variable_ecbt.asm"
INCLUDE "library/common/main/variable_spbt.asm"
INCLUDE "library/common/main/subroutine_msbar.asm"
INCLUDE "library/common/main/subroutine_proj.asm"
INCLUDE "library/common/main/subroutine_pl2.asm"
INCLUDE "library/common/main/subroutine_planet.asm"
INCLUDE "library/common/main/subroutine_pl9_part_1_of_3.asm"
INCLUDE "library/common/main/subroutine_pl9_part_2_of_3.asm"
INCLUDE "library/common/main/subroutine_pl9_part_3_of_3.asm"
INCLUDE "library/common/main/subroutine_pls1.asm"
INCLUDE "library/common/main/subroutine_pls2.asm"
INCLUDE "library/common/main/subroutine_pls22.asm"
INCLUDE "library/common/main/subroutine_sun_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine_sun_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine_sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine_sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine_circle.asm"
INCLUDE "library/common/main/subroutine_circle2.asm"
INCLUDE "library/cassette/main/subroutine_wpls2.asm"
INCLUDE "library/common/main/subroutine_wpls.asm"
INCLUDE "library/common/main/subroutine_edges.asm"
INCLUDE "library/common/main/subroutine_chkon.asm"
INCLUDE "library/common/main/subroutine_pl21.asm"
INCLUDE "library/common/main/subroutine_pls3.asm"
INCLUDE "library/common/main/subroutine_pls4.asm"
INCLUDE "library/common/main/subroutine_pls5.asm"
INCLUDE "library/common/main/subroutine_pls6.asm"
INCLUDE "library/common/main/subroutine_tt17.asm"
INCLUDE "library/common/main/subroutine_ping.asm"

\ ******************************************************************************
\
\ Save output/ELTE.bin
\
\ ******************************************************************************

PRINT "ELITE E"
PRINT "Assembled at ", ~CODE_E%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_E%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_E%

PRINT "S.ELTE ", ~CODE_E%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_E%
SAVE "cassette/output/ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
\
\ Produces the binary file ELTF.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_F% = P%
LOAD_F% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine_ks3.asm"
INCLUDE "library/common/main/subroutine_ks1.asm"
INCLUDE "library/common/main/subroutine_ks4.asm"
INCLUDE "library/common/main/subroutine_ks2.asm"
INCLUDE "library/common/main/subroutine_killshp.asm"
INCLUDE "library/common/main/variable_sfx.asm"
INCLUDE "library/common/main/subroutine_reset.asm"
INCLUDE "library/cassette/main/subroutine_res4.asm"
INCLUDE "library/common/main/subroutine_res2.asm"
INCLUDE "library/common/main/subroutine_zinf.asm"
INCLUDE "library/common/main/subroutine_msblob.asm"
INCLUDE "library/common/main/subroutine_me2.asm"
INCLUDE "library/common/main/subroutine_ze.asm"
INCLUDE "library/common/main/subroutine_dornd.asm"
INCLUDE "library/common/main/subroutine_main_game_loop_part_1_of_6.asm"
INCLUDE "library/common/main/subroutine_main_game_loop_part_2_of_6.asm"
INCLUDE "library/common/main/subroutine_main_game_loop_part_3_of_6.asm"
INCLUDE "library/common/main/subroutine_main_game_loop_part_4_of_6.asm"
INCLUDE "library/common/main/subroutine_main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine_main_game_loop_part_6_of_6.asm"
INCLUDE "library/cassette/main/subroutine_tha.asm"
INCLUDE "library/common/main/subroutine_tt102.asm"
INCLUDE "library/common/main/subroutine_bad.asm"
INCLUDE "library/common/main/subroutine_farof.asm"
INCLUDE "library/common/main/subroutine_farof2.asm"
INCLUDE "library/common/main/subroutine_mas4.asm"
INCLUDE "library/common/main/subroutine_death.asm"
INCLUDE "library/common/main/subroutine_death2.asm"
INCLUDE "library/common/main/subroutine_tt170.asm"
INCLUDE "library/cassette/main/subroutine_br1.asm"
INCLUDE "library/common/main/subroutine_bay.asm"
INCLUDE "library/common/main/subroutine_title.asm"
INCLUDE "library/common/main/subroutine_check.asm"
INCLUDE "library/common/main/subroutine_trnme.asm"
INCLUDE "library/common/main/subroutine_tr1.asm"
INCLUDE "library/cassette/main/subroutine_gtnme.asm"
INCLUDE "library/common/main/subroutine_zero.asm"
INCLUDE "library/common/main/subroutine_zes1.asm"
INCLUDE "library/common/main/subroutine_zes2.asm"
INCLUDE "library/common/main/subroutine_sve.asm"
INCLUDE "library/common/main/subroutine_qus1.asm"
INCLUDE "library/common/main/subroutine_lod.asm"
INCLUDE "library/common/main/subroutine_fx200.asm"
INCLUDE "library/common/main/subroutine_sps1.asm"
INCLUDE "library/common/main/subroutine_tas2.asm"
INCLUDE "library/common/main/subroutine_norm.asm"
INCLUDE "library/cassette/main/subroutine_rdkey.asm"
INCLUDE "library/common/main/subroutine_ecmof.asm"
INCLUDE "library/common/main/subroutine_exno3.asm"
INCLUDE "library/common/main/subroutine_sfrmis.asm"
INCLUDE "library/common/main/subroutine_exno2.asm"
INCLUDE "library/common/main/subroutine_exno.asm"
INCLUDE "library/common/main/subroutine_beep.asm"
INCLUDE "library/common/main/subroutine_noise.asm"
INCLUDE "library/common/main/subroutine_no3.asm"
INCLUDE "library/common/main/subroutine_nos1.asm"
INCLUDE "library/common/main/variable_kytb.asm"
INCLUDE "library/cassette/main/subroutine_dks1.asm"
INCLUDE "library/common/main/subroutine_ctrl.asm"
INCLUDE "library/cassette/main/subroutine_dks4.asm"
INCLUDE "library/common/main/subroutine_dks2.asm"
INCLUDE "library/common/main/subroutine_dks3.asm"
INCLUDE "library/common/main/subroutine_dkj1.asm"
INCLUDE "library/common/main/subroutine_u_per_cent.asm"
INCLUDE "library/common/main/subroutine_dokey.asm"
INCLUDE "library/common/main/subroutine_dk4.asm"
INCLUDE "library/common/main/subroutine_tt217.asm"
INCLUDE "library/common/main/subroutine_me1.asm"
INCLUDE "library/common/main/subroutine_ou2.asm"
INCLUDE "library/common/main/subroutine_ou3.asm"
INCLUDE "library/common/main/subroutine_mess.asm"
INCLUDE "library/common/main/subroutine_mes9.asm"
INCLUDE "library/common/main/subroutine_ouch.asm"
INCLUDE "library/common/main/variable_qq16.asm"
INCLUDE "library/common/main/macro_item.asm"
INCLUDE "library/common/main/variable_qq23.asm"
INCLUDE "library/common/main/subroutine_tidy.asm"
INCLUDE "library/common/main/subroutine_tis2.asm"
INCLUDE "library/common/main/subroutine_tis3.asm"
INCLUDE "library/common/main/subroutine_dvidt.asm"

\ ******************************************************************************
\
\ Save output/ELTF.bin
\
\ ******************************************************************************

PRINT "ELITE F"
PRINT "Assembled at ", ~CODE_F%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_F%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_F%

PRINT "S.ELTF ", ~CODE_F%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_F%
SAVE "cassette/output/ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ Produces the binary file ELTG.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_G% = P%
LOAD_G% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine_shppt.asm"
INCLUDE "library/common/main/subroutine_ll5.asm"
INCLUDE "library/common/main/subroutine_ll28.asm"
INCLUDE "library/common/main/subroutine_ll38.asm"
INCLUDE "library/common/main/subroutine_ll51.asm"
INCLUDE "library/common/main/subroutine_ll9_part_1_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_2_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_3_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_4_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_5_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_6_of_11.asm"
INCLUDE "library/common/main/subroutine_ll61.asm"
INCLUDE "library/common/main/subroutine_ll62.asm"
INCLUDE "library/common/main/subroutine_ll9_part_7_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_8_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_9_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_10_of_11.asm"
INCLUDE "library/common/main/subroutine_ll9_part_11_of_11.asm"
INCLUDE "library/common/main/subroutine_ll118.asm"
INCLUDE "library/common/main/subroutine_ll120.asm"
INCLUDE "library/common/main/subroutine_ll123.asm"
INCLUDE "library/common/main/subroutine_ll129.asm"
INCLUDE "library/common/main/subroutine_ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine_ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine_ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine_ll145_part_4_of_4.asm"

\ ******************************************************************************
\
\ Save output/ELTG.bin
\
\ ******************************************************************************

PRINT "ELITE G"
PRINT "Assembled at ", ~CODE_G%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_G%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_G%

PRINT "S.ELTG ", ~CODE_G%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_G%
SAVE "cassette/output/ELTG.bin", CODE_G%, P%, LOAD%

INCLUDE "library/cassette/main/variable_checksum0.asm"

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_SHIPS% = P%
LOAD_SHIPS% = LOAD% + P% - CODE%

INCLUDE "library/common/main/macro_vertex.asm"
INCLUDE "library/common/main/macro_edge.asm"
INCLUDE "library/common/main/macro_face.asm"
INCLUDE "library/common/main/variable_xx21.asm"
INCLUDE "library/common/main/variable_ship1.asm"
INCLUDE "library/common/main/variable_ship2.asm"
INCLUDE "library/common/main/variable_ship3.asm"
INCLUDE "library/common/main/variable_ship5.asm"
INCLUDE "library/common/main/variable_ship6.asm"
INCLUDE "library/common/main/variable_ship8.asm"
INCLUDE "library/common/main/variable_ship9.asm"
INCLUDE "library/common/main/variable_ship10.asm"
INCLUDE "library/common/main/variable_ship11.asm"
INCLUDE "library/common/main/variable_ship12.asm"
INCLUDE "library/common/main/variable_ship13.asm"

\ ******************************************************************************
\
\ Save output/SHIPS.bin
\
\ ******************************************************************************

PRINT "SHIPS"
PRINT "Assembled at ", ~CODE_SHIPS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_SHIPS%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_SHIPS%

PRINT "S.SHIPS ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_SHIPS%
SAVE "cassette/output/SHIPS.bin", CODE_SHIPS%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE PYTHON SHIP BLUEPRINT FILE
\
\ Produces the binary file PYTHON.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CLEAR 0, &7F00

CODE_PYTHON% = &7F00
LOAD_PYTHON% = &1B00

ORG CODE_PYTHON%

INCLUDE "library/common/main/variable_ship4.asm"
INCLUDE "library/common/main/variable_svn.asm"
INCLUDE "library/common/main/variable_vec.asm"

\ ******************************************************************************
\
\ Save output/PYTHON.bin
\
\ ******************************************************************************

PRINT "PYTHON"
PRINT "Assembled at ", ~CODE_PYTHON%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_PYTHON%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_PYTHON%

PRINT "S.PYTHON ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_PYTHON%
SAVE "cassette/output/PYTHON.bin", CODE_PYTHON%, P%, LOAD%

\ ******************************************************************************
\
\ Show free space
\
\ ******************************************************************************

PRINT "ELITE game code ", ~(&6000-P%), " bytes free"
PRINT "Ends at ", ~P%
