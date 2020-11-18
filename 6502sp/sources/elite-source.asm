\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE GAME SOURCE (PARASITE)
\
\ 6502 Second Processor Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1985
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
\ ******************************************************************************

INCLUDE "6502sp/sources/elite-header.h.asm"

CPU 1

_ENABLE_MAX_COMMANDER   = TRUE AND _REMOVE_CHECKSUMS
_CASSETTE_VERSION       = TRUE AND (_VERSION = 1)
_DISC_VERSION           = TRUE AND (_VERSION = 2)
_6502SP_VERSION         = TRUE AND (_VERSION = 3)

C% = &1000
W% = &9200
L% = C%
Z = 0
SNE = &7C0
ACT = &7E0
NTY = 34
D% = &D000
E% = D%+2*NTY
LS% = D%-1
QQ18 = &400
BRKV = &202

Q% = _ENABLE_MAX_COMMANDER

MSL = 1
SST = 2
ESC = 3
PLT = 4
OIL = 5
AST = 7
SPL = 8
SHU = 9
CYL = 11
ANA = 14
HER = 15
COPS = 16
SH3 = 17
KRA = 19
ADA = 20
WRM = 23
CYL2 = 24
ASP = 25
THG = 29
TGL = 30
CON = 31
LGO = 32
COU = 33
DOD = 34
NOST = 18
NOSH = 20
JL = ESC
JH = SHU+2
PACK = SH3
NI% = 37
POW = 15
B = &30
Armlas = INT(128.5+1.5*POW)
Mlas = 50
NRU% = 0
VE = &57
LL = 30
CYAN = &FF
RED = &F0
YELLOW = &F
GREEN = &AF
WHITE = &FA
MAGENTA = RED
RED2 = &3
GREEN2 = &C
YELLOW2 = &F
BLUE2 = &30
MAG2 = &33
CYAN2 = &3C
WHITE2 = &3F
DUST = WHITE
FF = &FF
OSWRCH = &FFEE
OSBYTE = &FFF4
OSWORD = &FFF1
OSFILE = &FFDD
SCLI = &FFF7
\XX21 = D%
SETXC = &85
SETYC = &86
clyns = &87
DODIALS = &8A
RDPARAMS = &88
DOmsbar = 242
wscn = 243
onescan = 244
DOhfx = &84
DOdot = 245
DOFE21 = &83
VIAE = &8B
DOBULB = &8C
DODKS4 = 246
DOCATF = &8D
SETCOL = &8E
SETVDU19 = &8F
DOsvn = &90
printcode = &92
prilf = &93
X = 128
Y = 96
f0 = &20
f1 = &71
f2 = &72
f3 = &73
f4 = &14
f5 = &74
f6 = &75
f7 = &16
f8 = &76
f9 = &77
VEC = &7FFE

W = 5
W2 = 16
WY = 12
W2Y = 2.5*WY
D = 80

INCLUDE "library/common/main/workspace_zp.asm"
INCLUDE "library/common/main/workspace_xx3.asm"
INCLUDE "library/6502sp/main/workspace_up.asm"
INCLUDE "library/common/main/workspace_wp.asm"
INCLUDE "library/common/main/workspace_k_per_cent.asm"
INCLUDE "library/6502sp/main/workspace_lp.asm"

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

CODE% = &1000
LOAD% = &1000

ORG CODE%

LOAD_A% = LOAD%

INCLUDE "library/6502sp/main/variable_mos.asm"
INCLUDE "library/common/main/workspace_variable_comc-jstk.asm"
INCLUDE "library/6502sp/main/workspace_variable_bstk-s1_per_cent.asm"
INCLUDE "library/common/main/variable_na_per_cent.asm"
INCLUDE "library/common/main/variable_chk2.asm"
INCLUDE "library/common/main/variable_chk.asm"
INCLUDE "library/6502sp/main/subroutine_s_per_cent.asm"
INCLUDE "library/6502sp/main/subroutine_deeor.asm"
INCLUDE "library/6502sp/main/subroutine_doentry.asm"
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
INCLUDE "library/6502sp/main/subroutine_spin.asm"
INCLUDE "library/6502sp/main/subroutine_mt27.asm"
INCLUDE "library/6502sp/main/subroutine_mt28.asm"
INCLUDE "library/6502sp/main/subroutine_detok3.asm"
INCLUDE "library/6502sp/main/subroutine_detok.asm"
INCLUDE "library/6502sp/main/subroutine_detok2.asm"
INCLUDE "library/6502sp/main/subroutine_mt1.asm"
INCLUDE "library/6502sp/main/subroutine_mt2.asm"
INCLUDE "library/6502sp/main/subroutine_mt8.asm"
INCLUDE "library/6502sp/main/subroutine_mt9.asm"
INCLUDE "library/6502sp/main/subroutine_mt13.asm"
INCLUDE "library/6502sp/main/subroutine_mt6.asm"
INCLUDE "library/6502sp/main/subroutine_mt5.asm"
INCLUDE "library/6502sp/main/subroutine_mt14.asm"
INCLUDE "library/6502sp/main/subroutine_mt15.asm"
INCLUDE "library/6502sp/main/subroutine_mt17.asm"
INCLUDE "library/6502sp/main/subroutine_mt18.asm"
INCLUDE "library/6502sp/main/subroutine_mt19.asm"
INCLUDE "library/6502sp/main/subroutine_vowel.asm"
INCLUDE "library/6502sp/main/subroutine_whitetext.asm"
INCLUDE "library/6502sp/main/subroutine_jmtb.asm"
INCLUDE "library/6502sp/main/subroutine_tkn2.asm"
INCLUDE "library/common/main/variable_qq16.asm"
INCLUDE "library/6502sp/main/variable_shpcol.asm"
INCLUDE "library/6502sp/main/variable_scacol.asm"
INCLUDE "library/common/main/workspace_variable_lsx2-lsy2.asm"

\ ******************************************************************************
\
\ Save output/ELTA.bin
\
\ ******************************************************************************

PRINT "ELITE A"
PRINT "Assembled at ", ~S1%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - S1%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_A%

PRINT "S.ELTA ", ~S1%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_A%
SAVE "6502sp/output/ELTA.bin", S1%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ Produces the binary file ELTB.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_B% = P%
LOAD_B% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable_univ.asm"
INCLUDE "library/common/main/variable_twos.asm"
INCLUDE "library/common/main/variable_twos2.asm"
INCLUDE "library/common/main/variable_ctwos.asm"
INCLUDE "library/6502sp/main/subroutine_ll30.asm"
INCLUDE "library/6502sp/main/subroutine_loin.asm"
INCLUDE "library/6502sp/main/variable_lbuf.asm"
INCLUDE "library/6502sp/main/subroutine_flkb.asm"
INCLUDE "library/common/main/subroutine_nlin3.asm"
INCLUDE "library/common/main/subroutine_nlin4.asm"
INCLUDE "library/common/main/subroutine_nlin.asm"
INCLUDE "library/common/main/subroutine_nlin2.asm"
INCLUDE "library/common/main/subroutine_hloin2.asm"
INCLUDE "library/6502sp/main/subroutine_hloin.asm"
INCLUDE "library/6502sp/main/variable_hbuf.asm"
INCLUDE "library/common/main/variable_twfl.asm"
INCLUDE "library/common/main/variable_twfr.asm"
INCLUDE "library/common/main/subroutine_pix1.asm"
INCLUDE "library/common/main/subroutine_pixel2.asm"
INCLUDE "library/6502sp/main/subroutine_pixel.asm"
INCLUDE "library/6502sp/main/subroutine_pixel3.asm"
INCLUDE "library/6502sp/main/variable_pbuf.asm"
INCLUDE "library/common/main/subroutine_bline.asm"
INCLUDE "library/common/main/subroutine_flip.asm"
INCLUDE "library/common/main/subroutine_stars.asm"
INCLUDE "library/common/main/subroutine_stars1.asm"
INCLUDE "library/common/main/subroutine_stars6.asm"
INCLUDE "library/common/main/subroutine_mas1.asm"
INCLUDE "library/common/main/subroutine_mas2.asm"
INCLUDE "library/common/main/subroutine_mas3.asm"
INCLUDE "library/common/main/subroutine_status.asm"
INCLUDE "library/common/main/subroutine_plf2.asm"
INCLUDE "library/common/main/subroutine_mvt3.asm"
INCLUDE "library/common/main/subroutine_mvs5.asm"
INCLUDE "library/common/main/variable_tens.asm"
INCLUDE "library/common/main/subroutine_pr2.asm"
INCLUDE "library/common/main/subroutine_tt11.asm"
INCLUDE "library/common/main/subroutine_bprnt.asm"
INCLUDE "library/6502sp/main/variable_dtw1-dtw8.asm"
INCLUDE "library/6502sp/main/subroutine_feed.asm"
INCLUDE "library/6502sp/main/subroutine_mt16.asm"
INCLUDE "library/6502sp/main/subroutine_tt26.asm"
INCLUDE "library/common/main/subroutine_bell.asm"
INCLUDE "library/6502sp/main/subroutine_chpr.asm"
INCLUDE "library/6502sp/main/variable_printflag.asm"
INCLUDE "library/6502sp/main/subroutine_dials.asm"
INCLUDE "library/common/main/subroutine_escape.asm"
INCLUDE "library/6502sp/main/subroutine_hme2.asm"

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
SAVE "6502sp/output/ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ Produces the binary file ELTC.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_C% = P%
LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/6502sp/main/variable_hatb.asm"
INCLUDE "library/6502sp/main/subroutine_hall.asm"
INCLUDE "library/6502sp/main/variable_hang.asm"
INCLUDE "library/6502sp/main/subroutine_has1.asm"
INCLUDE "library/common/main/subroutine_tactics_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine_tactics_part_7_of_7.asm"
INCLUDE "library/6502sp/main/subroutine_dockit.asm"
INCLUDE "library/6502sp/main/subroutine_vcsu1.asm"
INCLUDE "library/common/main/subroutine_tas1.asm"
INCLUDE "library/6502sp/main/subroutine_tas4.asm"
INCLUDE "library/6502sp/main/subroutine_tas6.asm"
INCLUDE "library/6502sp/main/subroutine_dcs1.asm"
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
INCLUDE "library/common/main/subroutine_mu5.asm"
INCLUDE "library/common/main/subroutine_mult3.asm"
INCLUDE "library/common/main/subroutine_mls2.asm"
INCLUDE "library/common/main/subroutine_mls1.asm"
INCLUDE "library/common/main/subroutine_mu6.asm"
INCLUDE "library/common/main/subroutine_squa.asm"
INCLUDE "library/common/main/subroutine_squa2.asm"
INCLUDE "library/common/main/subroutine_mu1.asm"
INCLUDE "library/common/main/subroutine_mlu1.asm"
INCLUDE "library/common/main/subroutine_mlu2.asm"
INCLUDE "library/common/main/subroutine_multu.asm"
INCLUDE "library/common/main/subroutine_mu11.asm"
INCLUDE "library/common/main/subroutine_fmltu2.asm"
INCLUDE "library/common/main/subroutine_fmltu.asm"
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
INCLUDE "library/6502sp/main/subroutine_dvid4.asm"
INCLUDE "library/common/main/subroutine_dvid3b2.asm"
INCLUDE "library/common/main/subroutine_cntr.asm"
INCLUDE "library/common/main/subroutine_bump2.asm"
INCLUDE "library/common/main/subroutine_redu2.asm"
INCLUDE "library/common/main/subroutine_arctan.asm"
INCLUDE "library/common/main/subroutine_lasli.asm"
INCLUDE "library/6502sp/main/subroutine_pdesc.asm"
INCLUDE "library/6502sp/main/subroutine_brief2.asm"
INCLUDE "library/6502sp/main/subroutine_brp.asm"
INCLUDE "library/6502sp/main/subroutine_brief3.asm"
INCLUDE "library/6502sp/main/subroutine_debrief2.asm"
INCLUDE "library/6502sp/main/subroutine_debrief.asm"
INCLUDE "library/6502sp/main/subroutine_brief.asm"
INCLUDE "library/6502sp/main/subroutine_pause.asm"
INCLUDE "library/6502sp/main/subroutine_mt23.asm"
INCLUDE "library/6502sp/main/subroutine_mt29.asm"
INCLUDE "library/6502sp/main/subroutine_pas1.asm"
INCLUDE "library/6502sp/main/subroutine_pause2.asm"

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
SAVE "6502sp/output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ Produces the binary file ELTD.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_D% = P%
LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/subroutine_tnpr1.asm"
INCLUDE "library/common/main/subroutine_tnpr.asm"
INCLUDE "library/6502sp/main/subroutine_doxc.asm"
INCLUDE "library/6502sp/main/subroutine_doyc.asm"
INCLUDE "library/6502sp/main/subroutine_incyc.asm"
INCLUDE "library/6502sp/main/subroutine_docol.asm"
INCLUDE "library/6502sp/main/subroutine_dovdu19.asm"
INCLUDE "library/6502sp/main/subroutine_trademode.asm"
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
INCLUDE "library/6502sp/main/subroutine_ttx110.asm"
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
INCLUDE "library/6502sp/main/variable_rdli.asm"
INCLUDE "library/common/main/subroutine_eqshp.asm"
INCLUDE "library/common/main/subroutine_dn.asm"
INCLUDE "library/common/main/subroutine_dn2.asm"
INCLUDE "library/common/main/subroutine_eq.asm"
INCLUDE "library/common/main/subroutine_prx.asm"
INCLUDE "library/common/main/subroutine_qv.asm"
INCLUDE "library/common/main/subroutine_hm.asm"
INCLUDE "library/6502sp/main/subroutine_refund.asm"
INCLUDE "library/common/main/variable_prxs.asm"

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
SAVE "6502sp/output/ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
\
\ Produces the binary file ELTE.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_E% = P%
LOAD_E% = LOAD% + P% - CODE%

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
INCLUDE "library/6502sp/main/subroutine_det1.asm"
INCLUDE "library/common/main/subroutine_shd.asm"
INCLUDE "library/common/main/subroutine_dengy.asm"
INCLUDE "library/common/main/subroutine_compas.asm"
INCLUDE "library/common/main/subroutine_sps2.asm"
INCLUDE "library/common/main/subroutine_sps4.asm"
INCLUDE "library/common/main/subroutine_sp1.asm"
INCLUDE "library/common/main/subroutine_sp2.asm"
INCLUDE "library/6502sp/main/subroutine_dot.asm"
INCLUDE "library/common/main/subroutine_oops.asm"
INCLUDE "library/common/main/subroutine_sps3.asm"
INCLUDE "library/common/main/subroutine_ginf.asm"
INCLUDE "library/common/main/subroutine_nwsps.asm"
INCLUDE "library/common/main/subroutine_nwshp.asm"
INCLUDE "library/common/main/subroutine_nws1.asm"
INCLUDE "library/common/main/subroutine_abort.asm"
INCLUDE "library/common/main/subroutine_abort2.asm"
INCLUDE "library/common/main/subroutine_ecblb2.asm"
INCLUDE "library/6502sp/main/subroutine_ecblb.asm"
INCLUDE "library/6502sp/main/subroutine_spblb.asm"
INCLUDE "library/6502sp/main/subroutine_msbar.asm"
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
INCLUDE "library/6502sp/main/subroutine_circle2.asm"
INCLUDE "library/6502sp/main/subroutine_ls2fl.asm"
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
SAVE "6502sp/output/ELTE.bin", CODE_E%, P%, LOAD%

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
INCLUDE "library/6502sp/main/subroutine_there.asm"
INCLUDE "library/common/main/subroutine_reset.asm"
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
INCLUDE "library/common/main/subroutine_tt102.asm"
INCLUDE "library/common/main/subroutine_bad.asm"
INCLUDE "library/common/main/subroutine_farof.asm"
INCLUDE "library/common/main/subroutine_farof2.asm"
INCLUDE "library/common/main/subroutine_mas4.asm"
INCLUDE "library/6502sp/main/variable_brkd.asm"
INCLUDE "library/6502sp/main/subroutine_brbr.asm"
INCLUDE "library/common/main/subroutine_death.asm"
INCLUDE "library/6502sp/main/variable_spasto.asm"
INCLUDE "library/6502sp/main/subroutine_begin.asm"
INCLUDE "library/common/main/subroutine_tt170.asm"
INCLUDE "library/common/main/subroutine_death2.asm"
INCLUDE "library/6502sp/main/subroutine_br1.asm"
INCLUDE "library/common/main/subroutine_bay.asm"
INCLUDE "library/6502sp/main/subroutine_dfault.asm"
INCLUDE "library/common/main/subroutine_title.asm"
INCLUDE "library/common/main/subroutine_check.asm"
INCLUDE "library/common/main/subroutine_trnme.asm"
INCLUDE "library/common/main/subroutine_tr1.asm"
INCLUDE "library/6502sp/main/subroutine_gtnmew.asm"
INCLUDE "library/6502sp/main/subroutine_mt26.asm"
INCLUDE "library/6502sp/main/variable_rline.asm"
INCLUDE "library/common/main/subroutine_zero.asm"
INCLUDE "library/6502sp/main/subroutine_zebc.asm"
INCLUDE "library/common/main/subroutine_zes1.asm"
INCLUDE "library/common/main/subroutine_zes2.asm"
INCLUDE "library/6502sp/main/variable_ctli.asm"
INCLUDE "library/6502sp/main/variable_deli.asm"
INCLUDE "library/6502sp/main/subroutine_cats.asm"
INCLUDE "library/6502sp/main/subroutine_delt.asm"
INCLUDE "library/6502sp/main/variable_stack.asm"
INCLUDE "library/6502sp/main/subroutine_mebrk.asm"
INCLUDE "library/6502sp/main/subroutine_cat.asm"
INCLUDE "library/6502sp/main/subroutine_retry.asm"
INCLUDE "library/common/main/subroutine_sve.asm"
INCLUDE "library/common/main/subroutine_qus1.asm"
INCLUDE "library/6502sp/main/subroutine_gtdrv.asm"
INCLUDE "library/common/main/subroutine_lod.asm"
INCLUDE "library/common/main/subroutine_fx200.asm"
INCLUDE "library/6502sp/main/subroutine_backtonormal.asm"
INCLUDE "library/6502sp/main/subroutine_scli2.asm"
INCLUDE "library/6502sp/main/subroutine_dodosvn.asm"
INCLUDE "library/6502sp/main/subroutine_cldelay.asm"
INCLUDE "library/6502sp/main/subroutine_zektran.asm"
INCLUDE "library/common/main/subroutine_sps1.asm"
INCLUDE "library/common/main/subroutine_tas2.asm"
INCLUDE "library/common/main/subroutine_norm.asm"
INCLUDE "library/6502sp/main/subroutine_rdkey.asm"
INCLUDE "library/common/main/subroutine_warp.asm"
INCLUDE "library/common/main/subroutine_ecmof.asm"
INCLUDE "library/common/main/subroutine_exno3.asm"
INCLUDE "library/common/main/subroutine_beep.asm"
INCLUDE "library/common/main/subroutine_sfrmis.asm"
INCLUDE "library/common/main/subroutine_exno2.asm"
INCLUDE "library/common/main/subroutine_exno.asm"
INCLUDE "library/common/main/subroutine_noise.asm"
INCLUDE "library/common/main/subroutine_no3.asm"
INCLUDE "library/common/main/subroutine_nos1.asm"
INCLUDE "library/common/main/variable_kytb.asm"
INCLUDE "library/common/main/subroutine_ctrl.asm"
INCLUDE "library/6502sp/main/subroutine_dks4.asm"
INCLUDE "library/common/main/subroutine_dks2.asm"
INCLUDE "library/common/main/subroutine_dks3.asm"
INCLUDE "library/common/main/subroutine_dkj1.asm"
INCLUDE "library/common/main/subroutine_u_per_cent.asm"
INCLUDE "library/common/main/subroutine_dokey.asm"
INCLUDE "library/common/main/subroutine_dk4.asm"
INCLUDE "library/common/main/subroutine_tt217.asm"
INCLUDE "library/common/main/subroutine_me1.asm"
INCLUDE "library/common/main/subroutine_mess.asm"
INCLUDE "library/common/main/subroutine_mes9.asm"
INCLUDE "library/common/main/subroutine_ouch.asm"
INCLUDE "library/common/main/subroutine_ou2.asm"
INCLUDE "library/common/main/subroutine_ou3.asm"
INCLUDE "library/common/main/macro_item.asm"
INCLUDE "library/common/main/variable_qq23.asm"
INCLUDE "library/6502sp/main/variable_oscobl.asm"
INCLUDE "library/6502sp/main/variable_scname.asm"
INCLUDE "library/6502sp/main/variable_oscobl2.asm"
INCLUDE "library/common/main/subroutine_tidy.asm"
INCLUDE "library/common/main/subroutine_tis2.asm"
INCLUDE "library/common/main/subroutine_tis3.asm"
INCLUDE "library/common/main/subroutine_dvidt.asm"
INCLUDE "library/6502sp/main/variable_buf.asm"
INCLUDE "library/6502sp/main/variable_ktran.asm"
INCLUDE "library/6502sp/main/variable_trantable.asm"

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
SAVE "6502sp/output/ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ Produces the binary file ELTG.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_G% = P%
LOAD_G% = LOAD% + P% - CODE%

IF _MATCH_EXTRACTED_BINARIES
 INCBIN "6502sp/extracted/workspaces/ELTG-align.bin"
ELSE
 ALIGN &100
ENDIF

INCLUDE "library/6502sp/main/variable_log-antilogodd.asm"
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
SAVE "6502sp/output/ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE H FILE
\
\ Produces the binary file ELTH.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_H% = P%
LOAD_H% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/subroutine_catlod.asm"
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
INCLUDE "library/common/main/subroutine_mvs4.asm"
INCLUDE "library/common/main/subroutine_mvt6.asm"
INCLUDE "library/common/main/subroutine_mv40.asm"
INCLUDE "library/6502sp/main/subroutine_checksum.asm"
INCLUDE "library/common/main/subroutine_plut.asm"
INCLUDE "library/common/main/subroutine_look1.asm"
INCLUDE "library/common/main/subroutine_tt66.asm"
INCLUDE "library/common/main/subroutine_ttx66.asm"
INCLUDE "library/common/main/subroutine_delay.asm"
INCLUDE "library/6502sp/main/subroutine_clyns.asm"
INCLUDE "library/6502sp/main/variable_scanpars-scany1.asm"
INCLUDE "library/common/main/subroutine_scan.asm"
INCLUDE "library/6502sp/main/subroutine_wscan.asm"

\ ******************************************************************************
\
\ Save output/ELTH.bin
\
\ ******************************************************************************

PRINT "ELITE H"
PRINT "Assembled at ", ~CODE_H%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_H%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_H%

PRINT "S.ELTH ", ~CODE_H%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_H%
SAVE "6502sp/output/ELTH.bin", CODE_H%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE I FILE
\
\ Produces the binary file ELTI.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_I% = P%
LOAD_I% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/variable_himcnt.asm"
INCLUDE "library/6502sp/main/subroutine_zinf2.asm"
INCLUDE "library/6502sp/main/subroutine_twist.asm"
INCLUDE "library/6502sp/main/subroutine_store.asm"
INCLUDE "library/6502sp/main/subroutine_demon.asm"
INCLUDE "library/6502sp/main/subroutine_slide.asm"
INCLUDE "library/6502sp/main/subroutine_zevb.asm"
INCLUDE "library/6502sp/main/subroutine_gridset.asm"
INCLUDE "library/6502sp/main/subroutine_zzaap.asm"
INCLUDE "library/6502sp/main/variable_ltdef.asm"
INCLUDE "library/6502sp/main/variable_nofx.asm"
INCLUDE "library/6502sp/main/variable_nofy.asm"
INCLUDE "library/6502sp/main/variable_acorn.asm"
INCLUDE "library/6502sp/main/variable_byian.asm"
INCLUDE "library/6502sp/main/variable_true3.asm"

\ ******************************************************************************
\
\ Save output/ELTI.bin
\
\ ******************************************************************************

PRINT "ELITE I"
PRINT "Assembled at ", ~CODE_I%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_I%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_I%

PRINT "S.ELTI ", ~CODE_I%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_H%
SAVE "6502sp/output/ELTI.bin", CODE_I%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE J FILE
\
\ Produces the binary file ELTJ.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_J% = P%
LOAD_J% = LOAD% + P% - CODE%

INCLUDE "library/6502sp/main/macro_tokn.asm"
INCLUDE "library/6502sp/main/macro_char.asm"
INCLUDE "library/6502sp/main/variable_tkn1.asm"
INCLUDE "library/6502sp/main/variable_rupla.asm"
INCLUDE "library/6502sp/main/variable_rugal.asm"
INCLUDE "library/6502sp/main/variable_rutok.asm"
INCLUDE "library/6502sp/main/variable_mtin.asm"
INCLUDE "library/6502sp/main/subroutine_cold.asm"
INCLUDE "library/6502sp/main/variable_f_per_cent.asm"

\ ******************************************************************************
\
\ Save output/ELTJ.bin
\
\ ******************************************************************************

PRINT "ELITE J"
PRINT "Assembled at ", ~CODE_J%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_J%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_J%

PRINT "S.ELTJ ", ~CODE_J%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_J%
SAVE "6502sp/output/ELTJ.bin", CODE_J%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ Produces the binary file SHIPS.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_SHIPS% = &D000
LOAD_SHIPS% = &D000

ORG CODE_SHIPS%

INCLUDE "library/common/main/macro_vertex.asm"
INCLUDE "library/common/main/macro_edge.asm"
INCLUDE "library/common/main/macro_face.asm"
INCLUDE "library/common/main/variable_xx21.asm"

INCLUDE "library/common/main/variable_ship_missile.asm"
INCLUDE "library/common/main/variable_ship_coriolis.asm"
INCLUDE "library/common/main/variable_ship_escape_pod.asm"

\ PLT  =  4 = Plate (alloys)

 EQUB &80               \ Max. canisters on demise = 0
 EQUW 10 * 10           \ Targetable area          = 10 * 10
 EQUB &2C               \ Edges data offset (low)  = &002C
 EQUB &3C               \ Faces data offset (low)  = &003C
 EQUB 21                \ Max. edge count          = (21 - 1) / 4 = 5
 EQUB 0                 \ Gun vertex               = 0
 EQUB 10                \ Explosion count          = 1, as (4 * n) + 6 = 10
 EQUB 24                \ Number of vertices       = 24 / 6 = 4
 EQUB 4                 \ Number of edges          = 4
 EQUW 0                 \ Bounty                   = 0
 EQUB 4                 \ Number of faces          = 4 / 4 = 1
 EQUB 5                 \ Visibility distance      = 5
 EQUB 16                \ Max. energy              = 16
 EQUB 16                \ Max. speed               = 16
 EQUB &00               \ Edges data offset (high) = &002C
 EQUB &00               \ Faces data offset (high) = &003C
 EQUB 3                 \ Normals are scaled by    = 2^3 = 8
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

 EQUB &0F, &16, &09, &FF, &FF, &FF
 EQUB &0F, &26, &09, &BF, &FF, &FF
 EQUB &13, &20, &0B, &14, &FF, &FF
 EQUB &0A, &2E, &06, &54, &FF, &FF

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,    15,    15,         31    \ Edge 0
 EDGE       1,       2,    15,    15,         16    \ Edge 1
 EDGE       2,       3,    15,    15,         20    \ Edge 2
 EDGE       3,       0,    15,    15,         16    \ Edge 3

 EQUB &00, &00, &00, &00

INCLUDE "library/common/main/variable_ship_canister.asm"


\         6 = Boulder

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 30 * 30           \ Targetable area          = 30 * 30
 EQUB &3E               \ Edges data offset (low)  = &
 EQUB &7A               \ Faces data offset (low)  = &
 EQUB 49                \ Max. edge count          = (49 - 1) / 4 = 12
 EQUB 0                 \ Gun vertex               = 0
 EQUB 14                \ Explosion count          = 2, as (4 * n) + 6 = 14
 EQUB 42                \ Number of vertices       = 42 / 6 = 7
 EQUB 15                \ Number of edges          = 15
 EQUW 1                 \ Bounty                   = 1
 EQUB 40                \ Number of faces          = 40 / 4 = 10
 EQUB 20                \ Visibility distance      = 20
 EQUB 20                \ Max. energy              = 20
 EQUB 30                \ Max. speed               = 30
 EQUB &00               \ Edges data offset (high) = &00
 EQUB &00               \ Faces data offset (high) = &00
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

 EQUB &12, &25, &0B, &BF, &01, &59
 EQUB &1E, &07, &0C, &1F, &12, &56
 EQUB &1C, &07, &0C, &7F, &23, &67
 EQUB &02, &00, &27, &3F, &34, &78
 EQUB &1C, &22, &1E, &BF, &04, &89
 EQUB &05, &0A, &0D, &5F, &FF, &FF
 EQUB &14, &11, &1E, &3F, &FF, &FF

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     5,     1,         31    \ Edge 1
 EDGE       1,       2,     6,     2,         31    \ Edge 2
 EDGE       2,       3,     7,     3,         31    \ Edge 3
 EDGE       3,       4,     8,     4,         31    \ Edge 4
 EDGE       4,       0,     9,     0,         31    \ Edge 5
 EDGE       0,       5,     1,     0,         31    \ Edge 6
 EDGE       1,       5,     2,     1,         31    \ Edge 7
 EDGE       2,       5,     3,     2,         31    \ Edge 8
 EDGE       3,       5,     4,     3,         31    \ Edge 9
 EDGE       4,       5,     4,     0,         31    \ Edge 10
 EDGE       0,       6,     9,     5,         31    \ Edge 11
 EDGE       1,       6,     6,     5,         31    \ Edge 12
 EDGE       2,       6,     7,     6,         31    \ Edge 13
 EDGE       3,       6,     8,     7,         31    \ Edge 14
 EDGE       4,       6,     9,     8,         31    \ Edge 15

 EQUB &DF, &0F, &03, &08
 EQUB &9F, &07, &0C, &1E
 EQUB &5F, &20, &2F, &18
 EQUB &FF, &03, &27, &07
 EQUB &FF, &05, &04, &01
 EQUB &1F, &31, &54, &08
 EQUB &3F, &70, &15, &15
 EQUB &7F, &4C, &23, &52
 EQUB &3F, &16, &38, &89
 EQUB &3F, &28, &6E, &26

INCLUDE "library/common/main/variable_ship_asteroid.asm"

\ SPL  =  8 = Splinter

 EQUB &B0               \ Max. canisters on demise = 0
 EQUW 16 * 16           \ Targetable area          = 16 * 16
 EQUB &78               \ Edges data offset (low)  = &FD78 = -648 ()
 EQUB &44               \ Faces data offset (low)  = &0044
 EQUB 29                \ Max. edge count          = (29 - 1) / 4 = 7
 EQUB 0                 \ Gun vertex               = 0
 EQUB 22                \ Explosion count          = 4, as (4 * n) + 6 = 22
 EQUB 24                \ Number of vertices       = 24 / 6 = 4
 EQUB 6                 \ Number of edges          = 6
 EQUW 0                 \ Bounty                   = 0
 EQUB 16                \ Number of faces          = 16 / 4 = 4
 EQUB 8                 \ Visibility distance      = 8
 EQUB 20                \ Max. energy              = 20
 EQUB 10                \ Max. speed               = 10
 EQUB &FD               \ Edges data offset (high) = &FD78 = -648 ()
 EQUB &00               \ Faces data offset (high) = &0044
 EQUB 5                 \ Normals are scaled by    = 2^5 = 32
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

 EQUB &18, &19, &10, &DF, &12, &33
 EQUB &00, &0C, &0A, &3F, &02, &33
 EQUB &0B, &06, &02, &5F, &01, &33
 EQUB &0C, &2A, &07, &1F, &01, &22

 EQUB &1F, &23, &00, &04
 EQUB &1F, &03, &04, &08
 EQUB &1F, &01, &08, &0C
 EQUB &1F, &12, &0C, &00

\ SHU  =  9 = Shuttle

 EQUB 15                \ Max. canisters on demise = 15
 EQUW 50 * 50           \ Targetable area          = 50 * 50
 EQUB &86               \ Edges data offset (low)  = &0086
 EQUB &FE               \ Faces data offset (low)  = &00FE
 EQUB 113               \ Max. edge count          = (113 - 1) / 4 = 28
 EQUB 0                 \ Gun vertex               = 0
 EQUB 38                \ Explosion count          = 8, as (4 * n) + 6 = 38
 EQUB 114               \ Number of vertices       = 114 / 6 = 19
 EQUB 30                \ Number of edges          = 30
 EQUW 0                 \ Bounty                   = 0
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 22                \ Visibility distance      = 22
 EQUB 32                \ Max. energy              = 32
 EQUB 8                 \ Max. speed               = 8
 EQUB &00               \ Edges data offset (high) = &0086
 EQUB &00               \ Faces data offset (high) = &00FE
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

 EQUB &00, &11, &17, &5F, &FF, &FF
 EQUB &11, &00, &17, &9F, &FF, &FF
 EQUB &00, &12, &17, &1F, &FF, &FF
 EQUB &12, &00, &17, &1F, &FF, &FF
 EQUB &14, &14, &1B, &FF, &12, &39
 EQUB &14, &14, &1B, &BF, &34, &59
 EQUB &14, &14, &1B, &3F, &56, &79
 EQUB &14, &14, &1B, &7F, &17, &89
 EQUB &05, &00, &1B, &30, &99, &99
 EQUB &00, &02, &1B, &70, &99, &99
 EQUB &05, &00, &1B, &A9, &99, &99
 EQUB &00, &03, &1B, &29, &99, &99
 EQUB &00, &09, &23, &50, &0A, &BC
 EQUB &03, &01, &1F, &47, &FF, &02
 EQUB &04, &0B, &19, &08, &01, &F4
 EQUB &0B, &04, &19, &08, &A1, &3F
 EQUB &03, &01, &1F, &C7, &6B, &23
 EQUB &03, &0B, &19, &88, &F8, &C0
 EQUB &0A, &04, &19, &88, &4F, &18

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     0,         31    \ Edge 
 EDGE       1,       2,    10,     4,         31    \ Edge 
 EDGE       2,       3,    11,     6,         31    \ Edge 
 EDGE       0,       3,    12,     8,         31    \ Edge 
 EDGE       0,       7,     8,     1,         31    \ Edge 
 EDGE       0,       4,     2,     1,         24    \ Edge 
 EDGE       1,       4,     3,     2,         31    \ Edge 
 EDGE       1,       5,     4,     3,         24    \ Edge 
 EDGE       2,       5,     5,     4,         31    \ Edge 
 EDGE       2,       6,     6,     5,         12    \ Edge 
 EDGE       3,       6,     7,     6,         31    \ Edge 
 EDGE       3,       7,     8,     7,         24    \ Edge 
 EDGE       4,       5,     9,     3,         31    \ Edge 
 EDGE       5,       6,     9,     5,         31    \ Edge 
 EDGE       6,       7,     9,     7,         31    \ Edge 
 EDGE       4,       7,     9,     1,         31    \ Edge 
 EDGE       0,      12,    12,     0,         16    \ Edge 
 EDGE       1,      12,    10,     0,         16    \ Edge 
 EDGE       2,      12,    11,    10,         16    \ Edge 
 EDGE       3,      12,    12,    11,         16    \ Edge 
 EDGE       8,       9,     9,     9,         16    \ Edge 
 EDGE       9,      10,     9,     9,          7    \ Edge 
 EDGE      10,      11,     9,     9,          9    \ Edge 
 EDGE       8,      11,     9,     9,          7    \ Edge 
 EDGE      13,      14,    11,    11,          5    \ Edge 
 EDGE      14,      15,    11,    11,          8    \ Edge 
 EDGE      13,      15,    11,    11,          7    \ Edge 
 EDGE      16,      17,    10,    10,          5    \ Edge 
 EDGE      17,      18,    10,    10,          8    \ Edge 
 EDGE      16,      18,    10,    10,          7    \ Edge 

 EQUB &DF, &37, &37, &28
 EQUB &5F, &00, &4A, &04
 EQUB &DF, &33, &33, &17
 EQUB &9F, &4A, &00, &04
 EQUB &9F, &33, &33, &17
 EQUB &1F, &00, &4A, &04
 EQUB &1F, &33, &33, &17
 EQUB &1F, &4A, &00, &04
 EQUB &5F, &33, &33, &17
 EQUB &3F, &00, &00, &6B
 EQUB &9F, &29, &29, &5A
 EQUB &1F, &29, &29, &5A
 EQUB &5F, &37, &37, &28

\        10 = Transporter

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 50 * 50           \ Targetable area          = 50 * 50
 EQUB &F2               \ Edges data offset (low)  = &00F2
 EQUB &AA               \ Faces data offset (low)  = &01AA
 EQUB 149               \ Max. edge count          = (149 - 1) / 4 = 37
 EQUB 48                \ Gun vertex               = 48
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 222               \ Number of vertices       = 222 / 6 = 37
 EQUB 46                \ Number of edges          = 46
 EQUW 0                 \ Bounty                   = 0
 EQUB 56                \ Number of faces          = 56 / 4 = 14
 EQUB 16                \ Visibility distance      = 
 EQUB 32                \ Max. energy              = 32
 EQUB 10                \ Max. speed               = 10
 EQUB &00               \ Edges data offset (high) = &00F2
 EQUB &01               \ Faces data offset (high) = &01AA
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

 EQUB &00, &0A, &1A, &3F, &06, &77
 EQUB &19, &04, &1A, &BF, &01, &77
 EQUB &1C, &03, &1A, &FF, &01, &22
 EQUB &19, &08, &1A, &FF, &02, &33
 EQUB &1A, &08, &1A, &7F, &03, &44
 EQUB &1D, &03, &1A, &7F, &04, &55
 EQUB &1A, &04, &1A, &3F, &05, &66
 EQUB &00, &06, &0C, &13, &FF, &FF
 EQUB &1E, &01, &0C, &DF, &17, &89
 EQUB &21, &08, &0C, &DF, &12, &39
 EQUB &21, &08, &0C, &5F, &34, &5A
 EQUB &1E, &01, &0C, &5F, &56, &AB
 EQUB &0B, &02, &1E, &DF, &89, &CD
 EQUB &0D, &08, &1E, &DF, &39, &DD
 EQUB &0E, &08, &1E, &5F, &3A, &DD
 EQUB &0B, &02, &1E, &5F, &AB, &CD
 EQUB &05, &06, &02, &87, &77, &77
 EQUB &12, &03, &02, &87, &77, &77
 EQUB &05, &07, &07, &A7, &77, &77
 EQUB &12, &04, &07, &A7, &77, &77
 EQUB &0B, &06, &0E, &A7, &77, &77
 EQUB &0B, &05, &07, &A7, &77, &77
 EQUB &05, &07, &0E, &27, &66, &66
 EQUB &12, &04, &0E, &27, &66, &66
 EQUB &0B, &05, &07, &27, &66, &66
 EQUB &05, &06, &03, &27, &66, &66
 EQUB &12, &03, &03, &27, &66, &66
 EQUB &0B, &04, &08, &07, &66, &66
 EQUB &0B, &05, &03, &27, &66, &66
 EQUB &10, &08, &0D, &E6, &33, &33
 EQUB &10, &08, &10, &C6, &33, &33
 EQUB &11, &08, &0D, &66, &33, &33
 EQUB &11, &08, &10, &46, &33, &33
 EQUB &0D, &03, &1A, &E8, &00, &00
 EQUB &0D, &03, &1A, &68, &00, &00
 EQUB &09, &03, &1A, &25, &00, &00
 EQUB &08, &03, &1A, &A5, &00, &00

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     7,     0,         31    \ Edge 
 EDGE       1,       2,     1,     0,         31    \ Edge 
 EDGE       2,       3,     2,     0,         31    \ Edge 
 EDGE       3,       4,     3,     0,         31    \ Edge 
 EDGE       4,       5,     4,     0,         31    \ Edge 
 EDGE       5,       6,     5,     0,         31    \ Edge 
 EDGE       0,       6,     6,     0,         31    \ Edge 
 EDGE       0,       7,     7,     6,         16    \ Edge 
 EDGE       1,       8,     7,     1,         31    \ Edge 
 EDGE       2,       9,     2,     1,         11    \ Edge 
 EDGE       3,       9,     3,     2,         31    \ Edge 
 EDGE       4,      10,     4,     3,         31    \ Edge 
 EDGE       5,      10,     5,     4,         11    \ Edge 
 EDGE       6,      11,     6,     5,         31    \ Edge 
 EDGE       7,       8,     8,     7,         17    \ Edge 
 EDGE       8,       9,     9,     1,         17    \ Edge 
 EDGE      10,      11,    10,     5,         17    \ Edge 
 EDGE       7,      11,    11,     6,         17    \ Edge 
 EDGE       7,      15,    12,    11,         19    \ Edge 
 EDGE       7,      12,    12,     8,         19    \ Edge 
 EDGE       8,      12,     9,     8,         16    \ Edge 
 EDGE       9,      13,     9,     3,         31    \ Edge 
 EDGE      10,      14,    10,     3,         31    \ Edge 
 EDGE      11,      15,    11,    10,         16    \ Edge 
 EDGE      12,      13,    13,     9,         31    \ Edge 
 EDGE      13,      14,    13,     3,         31    \ Edge 
 EDGE      14,      15,    13,    10,         31    \ Edge 
 EDGE      12,      15,    13,    12,         31    \ Edge 
 EDGE      16,      17,     7,     7,          7    \ Edge 
 EDGE      18,      19,     7,     7,          7    \ Edge 
 EDGE      19,      20,     7,     7,          7    \ Edge 
 EDGE      18,      20,     7,     7,          7    \ Edge 
 EDGE      20,      21,     7,     7,          7    \ Edge 
 EDGE      22,      23,     6,     6,          7    \ Edge 
 EDGE      23,      24,     6,     6,          7    \ Edge 
 EDGE      24,      22,     6,     6,          7    \ Edge 
 EDGE      25,      26,     6,     6,          7    \ Edge 
 EDGE      26,      27,     6,     6,          7    \ Edge 
 EDGE      25,      27,     6,     6,          7    \ Edge 
 EDGE      27,      28,     6,     6,          7    \ Edge 
 EDGE      29,      30,     3,     3,          6    \ Edge 
 EDGE      31,      32,     3,     3,          6    \ Edge 
 EDGE      33,      34,     0,     0,          8    \ Edge 
 EDGE      34,      35,     0,     0,          5    \ Edge 
 EDGE      35,      36,     0,     0,          5    \ Edge 
 EDGE      36,      33,     0,     0,          5    \ Edge 

 EQUB &3F, &00, &00, &67
 EQUB &BF, &6F, &30, &07
 EQUB &FF, &69, &3F, &15
 EQUB &5F, &00, &22, &00
 EQUB &7F, &69, &3F, &15
 EQUB &3F, &6F, &30, &07
 EQUB &1F, &08, &20, &03
 EQUB &9F, &08, &20, &03
 EQUB &93, &08, &22, &0B
 EQUB &9F, &4B, &20, &4F
 EQUB &1F, &4B, &20, &4F
 EQUB &13, &08, &22, &0B
 EQUB &1F, &00, &26, &11
 EQUB &1F, &00, &00, &79

INCLUDE "library/common/main/variable_ship_cobra_mk_iii.asm"
INCLUDE "library/common/main/variable_ship_python.asm"


\        13 = Boa

 EQUB &05               \ Max. canisters on demise = 
 EQUW 70 * 70           \ Targetable area          = 70 * 70
 EQUB &62               \ Edges data offset (low)  = &0062
 EQUB &C2               \ Faces data offset (low)  = &00C2
 EQUB 93                \ Max. edge count          = (93 - 1) / 4 = 23
 EQUB 0                 \ Gun vertex               = 0
 EQUB 38                \ Explosion count          = 8, as (4 * n) + 6 = 38
 EQUB 78                \ Number of vertices       = 78 / 6 = 13
 EQUB 24                \ Number of edges          = 24
 EQUW 0                 \ Bounty                   = 0
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 40                \ Visibility distance      = 40
 EQUB 250               \ Max. energy              = 250
 EQUB 24                \ Max. speed               = 24
 EQUB &00               \ Edges data offset (high) = &0062
 EQUB &00               \ Faces data offset (high) = &00C2
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00011100         \ Laser power              = 3
                        \ Missiles                 = 4

 EQUB &00, &00, &5D, &1F, &FF, &FF
 EQUB &00, &28, &57, &38, &02, &33
 EQUB &26, &19, &63, &78, &01, &44
 EQUB &26, &19, &63, &F8, &12, &55
 EQUB &26, &28, &3B, &BF, &23, &69
 EQUB &26, &28, &3B, &3F, &03, &6B
 EQUB &3E, &00, &43, &3F, &04, &8B
 EQUB &18, &41, &4F, &7F, &14, &8A
 EQUB &18, &41, &4F, &FF, &15, &7A
 EQUB &3E, &00, &43, &BF, &25, &79
 EQUB &00, &07, &6B, &36, &02, &AA
 EQUB &0D, &09, &6B, &76, &01, &AA
 EQUB &0D, &09, &6B, &F6, &12, &CC

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       5,    11,     6,         31    \ Edge 
 EDGE       0,       7,    10,     8,         31    \ Edge 
 EDGE       0,       9,     9,     7,         31    \ Edge 
 EDGE       0,       4,     9,     6,         29    \ Edge 
 EDGE       0,       6,    11,     8,         29    \ Edge 
 EDGE       0,       8,    10,     7,         29    \ Edge 
 EDGE       4,       5,     6,     3,         31    \ Edge 
 EDGE       5,       6,    11,     0,         31    \ Edge 
 EDGE       6,       7,     8,     4,         31    \ Edge 
 EDGE       7,       8,    10,     1,         31    \ Edge 
 EDGE       8,       9,     7,     5,         31    \ Edge 
 EDGE       4,       9,     9,     2,         31    \ Edge 
 EDGE       1,       4,     3,     2,         24    \ Edge 
 EDGE       1,       5,     3,     0,         24    \ Edge 
 EDGE       3,       9,     5,     2,         24    \ Edge 
 EDGE       3,       8,     5,     1,         24    \ Edge 
 EDGE       2,       6,     4,     0,         24    \ Edge 
 EDGE       2,       7,     4,     1,         24    \ Edge 
 EDGE       1,      10,     2,     0,         22    \ Edge 
 EDGE       2,      11,     1,     0,         22    \ Edge 
 EDGE       3,      12,     2,     1,         22    \ Edge 
 EDGE      10,      11,    12,     0,         14    \ Edge 
 EDGE      11,      12,    12,     1,         14    \ Edge 
 EDGE      12,      10,    12,     2,         14    \ Edge 

 EQUB &3F, &2B, &25, &3C
 EQUB &7F, &00, &2D, &59
 EQUB &BF, &2B, &25, &3C
 EQUB &1F, &00, &28, &00
 EQUB &7F, &3E, &20, &14
 EQUB &FF, &3E, &20, &14
 EQUB &1F, &00, &17, &06
 EQUB &DF, &17, &0F, &09
 EQUB &5F, &17, &0F, &09
 EQUB &9F, &1A, &0D, &0A
 EQUB &5F, &00, &1F, &0C
 EQUB &1F, &1A, &0D, &0A
 EQUB &2E, &00, &00, &6B

\ ANA  = 14 = Anaconda

 EQUB 7                 \ Max. canisters on demise = 7
 EQUW 100 * 100         \ Targetable area          = 100 * 100
 EQUB &6E               \ Edges data offset (low)  = &006E
 EQUB &D2               \ Faces data offset (low)  = &00D2
 EQUB 93                \ Max. edge count          = (93 - 1) / 4 = 23
 EQUB 48                \ Gun vertex               = 48
 EQUB 46                \ Explosion count          = 10, as (4 * n) + 6 = 46
 EQUB 90                \ Number of vertices       = 90 / 6 = 15
 EQUB 25                \ Number of edges          = 25
 EQUW 0                 \ Bounty                   = 0
 EQUB 48                \ Number of faces          = 48 / 4 = 12
 EQUB 36                \ Visibility distance      = 
 EQUB 252               \ Max. energy              = 252
 EQUB 14                \ Max. speed               = 14
 EQUB &00               \ Edges data offset (high) = &006E
 EQUB &00               \ Faces data offset (high) = &00D2
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00111111         \ Laser power              = 7
                        \ Missiles                 = 7

 EQUB &00, &07, &3A, &3E, &01, &55
 EQUB &2B, &0D, &25, &FE, &01, &22
 EQUB &1A, &2F, &03, &FE, &02, &33
 EQUB &1A, &2F, &03, &7E, &03, &44
 EQUB &2B, &0D, &25, &7E, &04, &55
 EQUB &00, &30, &31, &3E, &15, &66
 EQUB &45, &0F, &0F, &BE, &12, &77
 EQUB &2B, &27, &28, &DF, &23, &88
 EQUB &2B, &27, &28, &5F, &34, &99
 EQUB &45, &0F, &0F, &3E, &45, &AA
 EQUB &2B, &35, &17, &BF, &FF, &FF
 EQUB &45, &01, &20, &DF, &27, &88
 EQUB &00, &00, &FE, &1F, &FF, &FF
 EQUB &45, &01, &20, &5F, &49, &AA
 EQUB &2B, &35, &17, &3F, &FF, &FF

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     1,     0,         30    \ Edge 
 EDGE       1,       2,     2,     0,         30    \ Edge 
 EDGE       2,       3,     3,     0,         30    \ Edge 
 EDGE       3,       4,     4,     0,         30    \ Edge 
 EDGE       0,       4,     5,     0,         30    \ Edge 
 EDGE       0,       5,     5,     1,         29    \ Edge 
 EDGE       1,       6,     2,     1,         29    \ Edge 
 EDGE       2,       7,     3,     2,         29    \ Edge 
 EDGE       3,       8,     4,     3,         29    \ Edge 
 EDGE       4,       9,     5,     4,         29    \ Edge 
 EDGE       5,      10,     6,     1,         30    \ Edge 
 EDGE       6,      10,     7,     1,         30    \ Edge 
 EDGE       6,      11,     7,     2,         30    \ Edge 
 EDGE       7,      11,     8,     2,         30    \ Edge 
 EDGE       7,      12,     8,     3,         31    \ Edge 
 EDGE       8,      12,     9,     3,         31    \ Edge 
 EDGE       8,      13,     9,     4,         30    \ Edge 
 EDGE       9,      13,    10,     4,         30    \ Edge 
 EDGE       9,      14,    10,     5,         30    \ Edge 
 EDGE       5,      14,     6,     5,         30    \ Edge 
 EDGE      10,      14,    11,     6,         30    \ Edge 
 EDGE      10,      12,    11,     7,         31    \ Edge 
 EDGE      11,      12,     8,     7,         31    \ Edge 
 EDGE      12,      13,    10,     9,         31    \ Edge 
 EDGE      12,      14,    11,    10,         31    \ Edge 

 EQUB &7E, &00, &33, &31
 EQUB &BE, &33, &12, &57
 EQUB &FE, &4D, &39, &13
 EQUB &5F, &00, &5A, &10
 EQUB &7E, &4D, &39, &13
 EQUB &3E, &33, &12, &57
 EQUB &3E, &00, &6F, &14
 EQUB &9F, &61, &48, &18
 EQUB &DF, &6C, &44, &22
 EQUB &5F, &6C, &44, &22
 EQUB &1F, &61, &48, &18
 EQUB &1F, &00, &5E, &12

\ HER  = 15 = Rock hermit (asteroid)

 EQUB 7                 \ Max. canisters on demise = 7
 EQUW 80 * 80           \ Targetable area          = 80 * 80
 EQUB &4A               \ Edges data offset (low)  = &004A
 EQUB &9E               \ Faces data offset (low)  = &009E
 EQUB 69                \ Max. edge count          = (69 - 1) / 4 = 17
 EQUB 0                 \ Gun vertex               = 0
 EQUB 50                \ Explosion count          = 11, as (4 * n) + 6 = 50
 EQUB 54                \ Number of vertices       = 54 / 6 = 9
 EQUB 21                \ Number of edges          = 21
 EQUW 0                 \ Bounty                   = 0
 EQUB 56                \ Number of faces          = 56 / 4 = 14
 EQUB 50                \ Visibility distance      = 50
 EQUB 180               \ Max. energy              = 180
 EQUB 30                \ Max. speed               = 30
 EQUB &00               \ Edges data offset (high) = &004A
 EQUB &00               \ Faces data offset (high) = &009E
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00000010         \ Laser power              = 0
                        \ Missiles                 = 2

 EQUB &00, &50, &00, &1F, &FF, &FF
 EQUB &50, &0A, &00, &DF, &FF, &FF
 EQUB &00, &50, &00, &5F, &FF, &FF
 EQUB &46, &28, &00, &5F, &FF, &FF
 EQUB &3C, &32, &00, &1F, &65, &DC
 EQUB &32, &00, &3C, &1F, &FF, &FF
 EQUB &28, &00, &46, &9F, &10, &32
 EQUB &00, &1E, &4B, &3F, &FF, &FF
 EQUB &00, &32, &3C, &7F, &98, &BA

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     7,         31    \ Edge 
 EDGE       0,       4,     6,    13,         31    \ Edge 
 EDGE       3,       4,     5,    12,         31    \ Edge 
 EDGE       2,       3,     4,    11,         31    \ Edge 
 EDGE       1,       2,     3,    10,         31    \ Edge 
 EDGE       1,       6,     2,     3,         31    \ Edge 
 EDGE       2,       6,     1,     3,         31    \ Edge 
 EDGE       2,       5,     1,     4,         31    \ Edge 
 EDGE       5,       6,     0,     1,         31    \ Edge 
 EDGE       0,       5,     0,     6,         31    \ Edge 
 EDGE       3,       5,     4,     5,         31    \ Edge 
 EDGE       0,       6,     0,     2,         31    \ Edge 
 EDGE       4,       5,     5,     6,         31    \ Edge 
 EDGE       1,       8,     8,    10,         31    \ Edge 
 EDGE       1,       7,     7,     8,         31    \ Edge 
 EDGE       0,       7,     7,    13,         31    \ Edge 
 EDGE       4,       7,    12,    13,         31    \ Edge 
 EDGE       3,       7,     9,    12,         31    \ Edge 
 EDGE       3,       8,     9,    11,         31    \ Edge 
 EDGE       2,       8,    10,    11,         31    \ Edge 
 EDGE       7,       8,     8,     9,         31    \ Edge 

 EQUB &1F, &09, &42, &51
 EQUB &5F, &09, &42, &51
 EQUB &9F, &48, &40, &1F
 EQUB &DF, &40, &49, &2F
 EQUB &5F, &2D, &4F, &41
 EQUB &1F, &87, &0F, &23
 EQUB &1F, &26, &4C, &46
 EQUB &BF, &42, &3B, &27
 EQUB &FF, &43, &0F, &50
 EQUB &7F, &42, &0E, &4B
 EQUB &FF, &46, &50, &28
 EQUB &7F, &3A, &66, &33
 EQUB &3F, &51, &09, &43
 EQUB &3F, &2F, &5E, &3F

INCLUDE "library/common/main/variable_ship_viper.asm"
INCLUDE "library/common/main/variable_ship_sidewinder.asm"
INCLUDE "library/common/main/variable_ship_mamba.asm"

\ KRA  = 19 = Krait

 EQUB 1                 \ Max. canisters on demise = 1
 EQUW 60 * 60           \ Targetable area          = 60 * 60
 EQUB &7A               \ Edges data offset (low)  = &007A
 EQUB &CE               \ Faces data offset (low)  = &00CE
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
 EQUB 0                 \ Gun vertex               = 0
 EQUB 18                \ Explosion count          = 3, as (4 * n) + 6 = 18
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 21                \ Number of edges          = 21
 EQUW 100               \ Bounty                   = 100
 EQUB 24                \ Number of faces          = 24 / 4 = 6
 EQUB 20                \ Visibility distance      = 20
 EQUB 80                \ Max. energy              = 80
 EQUB 30                \ Max. speed               = 30
 EQUB &00               \ Edges data offset (high) = &007A
 EQUB &00               \ Faces data offset (high) = &00CE
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

 EQUB &00, &00, &60, &1F, &01, &23
 EQUB &00, &12, &30, &3F, &03, &45
 EQUB &00, &12, &30, &7F, &12, &45
 EQUB &5A, &00, &03, &3F, &01, &44
 EQUB &5A, &00, &03, &BF, &23, &55
 EQUB &5A, &00, &57, &1E, &01, &11
 EQUB &5A, &00, &57, &9E, &23, &33
 EQUB &00, &05, &35, &09, &00, &33
 EQUB &00, &07, &26, &06, &00, &33
 EQUB &12, &07, &13, &89, &33, &33
 EQUB &12, &07, &13, &09, &00, &00
 EQUB &12, &0B, &27, &28, &44, &44
 EQUB &12, &0B, &27, &68, &44, &44
 EQUB &24, &00, &1E, &28, &44, &44
 EQUB &12, &0B, &27, &A8, &55, &55
 EQUB &12, &0B, &27, &E8, &55, &55
 EQUB &24, &00, &1E, &A8, &55, &55

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     3,     0,         31    \ Edge 
 EDGE       0,       2,     2,     1,         31    \ Edge 
 EDGE       0,       3,     1,     0,         31    \ Edge 
 EDGE       0,       4,     3,     2,         31    \ Edge 
 EDGE       1,       4,     5,     3,         31    \ Edge 
 EDGE       4,       2,     5,     2,         31    \ Edge 
 EDGE       2,       3,     4,     1,         31    \ Edge 
 EDGE       3,       1,     4,     0,         31    \ Edge 
 EDGE       3,       5,     1,     0,         30    \ Edge 
 EDGE       4,       6,     3,     2,         30    \ Edge 
 EDGE       1,       2,     5,     4,          8    \ Edge 
 EDGE       7,      10,     0,     0,          9    \ Edge 
 EDGE       8,      10,     0,     0,          6    \ Edge 
 EDGE       7,       9,     3,     3,          9    \ Edge 
 EDGE       8,       9,     3,     3,          6    \ Edge 
 EDGE      11,      13,     4,     4,          8    \ Edge 
 EDGE      13,      12,     4,     4,          8    \ Edge 
 EDGE      12,      11,     4,     4,          7    \ Edge 
 EDGE      14,      15,     5,     5,          7    \ Edge 
 EDGE      15,      16,     5,     5,          8    \ Edge 
 EDGE      16,      14,     5,     5,          8    \ Edge 

 EQUB &1F, &03, &18, &03
 EQUB &5F, &03, &18, &03
 EQUB &DF, &03, &18, &03
 EQUB &9F, &03, &18, &03
 EQUB &3F, &26, &00, &4D
 EQUB &BF, &26, &00, &4D

\ ADA  = 20 = Adder

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 50 * 50           \ Targetable area          = 50 * 50
 EQUB &80               \ Edges data offset (low)  = &0080
 EQUB &F4               \ Faces data offset (low)  = &00F4
 EQUB 101               \ Max. edge count          = (101 - 1) / 4 = 25
 EQUB 0                 \ Gun vertex               = 0
 EQUB 22                \ Explosion count          = 4, as (4 * n) + 6 = 22
 EQUB 108               \ Number of vertices       = 108 / 6 = 18
 EQUB 29                \ Number of edges          = 29
 EQUW 40                \ Bounty                   = 40
 EQUB 60                \ Number of faces          = 60 / 4 = 15
 EQUB 20                \ Visibility distance      = 20
 EQUB 85                \ Max. energy              = 85
 EQUB 24                \ Max. speed               = 24
 EQUB &00               \ Edges data offset (high) = &0080
 EQUB &00               \ Faces data offset (high) = &00F4
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

 EQUB &12, &00, &28, &9F, &01, &BC
 EQUB &12, &00, &28, &1F, &01, &23
 EQUB &1E, &00, &18, &3F, &23, &45
 EQUB &1E, &00, &28, &3F, &45, &66
 EQUB &12, &07, &28, &7F, &56, &7E
 EQUB &12, &07, &28, &FF, &78, &AE
 EQUB &1E, &00, &28, &BF, &89, &AA
 EQUB &1E, &00, &18, &BF, &9A, &BC
 EQUB &12, &07, &28, &BF, &78, &9D
 EQUB &12, &07, &28, &3F, &46, &7D
 EQUB &12, &07, &0D, &9F, &09, &BD
 EQUB &12, &07, &0D, &1F, &02, &4D
 EQUB &12, &07, &0D, &DF, &1A, &CE
 EQUB &12, &07, &0D, &5F, &13, &5E
 EQUB &0B, &03, &1D, &85, &00, &00
 EQUB &0B, &03, &1D, &05, &00, &00
 EQUB &0B, &04, &18, &04, &00, &00
 EQUB &0B, &04, &18, &84, &00, &00

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     1,     0,         31    \ Edge 
 EDGE       1,       2,     3,     2,          7    \ Edge 
 EDGE       2,       3,     5,     4,         31    \ Edge 
 EDGE       3,       4,     6,     5,         31    \ Edge 
 EDGE       4,       5,    14,     7,         31    \ Edge 
 EDGE       5,       6,    10,     8,         31    \ Edge 
 EDGE       6,       7,    10,     9,         31    \ Edge 
 EDGE       7,       0,    12,    11,          7    \ Edge 
 EDGE       3,       9,     6,     4,         31    \ Edge 
 EDGE       9,       8,    13,     7,         31    \ Edge 
 EDGE       8,       6,     9,     8,         31    \ Edge 
 EDGE       0,      10,    11,     0,         31    \ Edge 
 EDGE       7,      10,    11,     9,         31    \ Edge 
 EDGE       1,      11,     2,     0,         31    \ Edge 
 EDGE       2,      11,     4,     2,         31    \ Edge 
 EDGE       0,      12,    12,     1,         31    \ Edge 
 EDGE       7,      12,    12,    10,         31    \ Edge 
 EDGE       1,      13,     3,     1,         31    \ Edge 
 EDGE       2,      13,     5,     3,         31    \ Edge 
 EDGE      10,      11,    13,     0,         31    \ Edge 
 EDGE      12,      13,    14,     1,         31    \ Edge 
 EDGE       8,      10,    13,     9,         31    \ Edge 
 EDGE       9,      11,    13,     4,         31    \ Edge 
 EDGE       5,      12,    14,    10,         31    \ Edge 
 EDGE       4,      13,    14,     5,         31    \ Edge 
 EDGE      14,      15,     0,     0,          5    \ Edge 
 EDGE      15,      16,     0,     0,          3    \ Edge 
 EDGE      16,      17,     0,     0,          4    \ Edge 
 EDGE      17,      14,     0,     0,          3    \ Edge 

 EQUB &1F, &00, &27, &0A
 EQUB &5F, &00, &27, &0A
 EQUB &1F, &45, &32, &0D
 EQUB &5F, &45, &32, &0D
 EQUB &1F, &1E, &34, &00
 EQUB &5F, &1E, &34, &00
 EQUB &3F, &00, &00, &A0
 EQUB &3F, &00, &00, &A0
 EQUB &3F, &00, &00, &A0
 EQUB &9F, &1E, &34, &00
 EQUB &DF, &1E, &34, &00
 EQUB &9F, &45, &32, &0D
 EQUB &DF, &45, &32, &0D
 EQUB &1F, &00, &1C, &00
 EQUB &5F, &00, &1C, &00

\        21 = Gecko

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 99 * 99           \ Targetable area          = 99 * 99
 EQUB &5C               \ Edges data offset (low)  = &005C
 EQUB &A0               \ Faces data offset (low)  = &00A0
 EQUB 69                \ Max. edge count          = (69 - 1) / 4 = 17
 EQUB 0                 \ Gun vertex               = 0
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 72                \ Number of vertices       = 72 / 6 = 12
 EQUB 17                \ Number of edges          = 17
 EQUW &0037             \ Bounty                   = 
 EQUB 36                \ Number of faces          = 36 / 4 = 9
 EQUB 18                \ Visibility distance      = 
 EQUB 70                \ Max. energy              = 
 EQUB 30                \ Max. speed               = 30
 EQUB &00               \ Edges data offset (high) = &005C
 EQUB &00               \ Faces data offset (high) = &00A0
 EQUB 3                 \ Normals are scaled by    = 2^3 = 8
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

 EQUB &0A, &04, &2F, &DF, &03, &45
 EQUB &0A, &04, &2F, &5F, &01, &23
 EQUB &10, &08, &17, &BF, &05, &67
 EQUB &10, &08, &17, &3F, &01, &78
 EQUB &42, &00, &03, &BF, &45, &66
 EQUB &42, &00, &03, &3F, &12, &88
 EQUB &14, &0E, &17, &FF, &34, &67
 EQUB &14, &0E, &17, &7F, &23, &78
 EQUB &08, &06, &21, &D0, &33, &33
 EQUB &08, &06, &21, &51, &33, &33
 EQUB &08, &0D, &10, &F0, &33, &33
 EQUB &08, &0D, &10, &71, &33, &33

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     3,     0,         31    \ Edge 
 EDGE       1,       5,     2,     1,         31    \ Edge 
 EDGE       5,       3,     8,     1,         31    \ Edge 
 EDGE       3,       2,     7,     0,         31    \ Edge 
 EDGE       2,       4,     6,     5,         31    \ Edge 
 EDGE       4,       0,     5,     4,         31    \ Edge 
 EDGE       5,       7,     8,     2,         31    \ Edge 
 EDGE       7,       6,     7,     3,         31    \ Edge 
 EDGE       6,       4,     6,     4,         31    \ Edge 
 EDGE       0,       2,     5,     0,         29    \ Edge 
 EDGE       1,       3,     1,     0,         30    \ Edge 
 EDGE       0,       6,     4,     3,         29    \ Edge 
 EDGE       1,       7,     3,     2,         30    \ Edge 
 EDGE       2,       6,     7,     6,         20    \ Edge 
 EDGE       3,       7,     8,     7,         20    \ Edge 
 EDGE       8,      10,     3,     3,         16    \ Edge 
 EDGE       9,      11,     3,     3,         17    \ Edge 

 EQUB &1F, &00, &1F, &05
 EQUB &1F, &04, &2D, &08
 EQUB &5F, &19, &6C, &13
 EQUB &5F, &00, &54, &0C
 EQUB &DF, &19, &6C, &13
 EQUB &9F, &04, &2D, &08
 EQUB &BF, &58, &10, &D6
 EQUB &3F, &00, &00, &BB
 EQUB &3F, &58, &10, &D6

\        22 = Cobra Mk I

 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 99 * 99           \ Targetable area          = 99 * 99
 EQUB &56               \ Edges data offset (low)  = &0056
 EQUB &9E               \ Faces data offset (low)  = &009E
 EQUB 73                \ Max. edge count          = (73 - 1) / 4 = 18
 EQUB 40                \ Gun vertex               = 40
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 66                \ Number of vertices       = 66 / 6 = 11
 EQUB 18                \ Number of edges          = 18
 EQUW 75                \ Bounty                   = 75
 EQUB 40                \ Number of faces          = 40 / 4 = 10
 EQUB 19                \ Visibility distance      = 19
 EQUB 90                \ Max. energy              = 90
 EQUB 26                \ Max. speed               = 26
 EQUB &00               \ Edges data offset (high) = &0056
 EQUB &00               \ Faces data offset (high) = &009E
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010010         \ Laser power              = 2
                        \ Missiles                 = 2

 EQUB &12, &01, &32, &DF, &01, &23
 EQUB &12, &01, &32, &5F, &01, &45
 EQUB &42, &00, &07, &9F, &23, &88
 EQUB &42, &00, &07, &1F, &45, &99
 EQUB &20, &0C, &26, &BF, &26, &78
 EQUB &20, &0C, &26, &3F, &46, &79
 EQUB &36, &0C, &26, &FF, &13, &78
 EQUB &36, &0C, &26, &7F, &15, &79
 EQUB &00, &0C, &06, &34, &02, &46
 EQUB &00, &01, &32, &42, &01, &11
 EQUB &00, &01, &3C, &5F, &01, &11

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       1,       0,     1,     0,         31    \ Edge 
 EDGE       0,       2,     3,     2,         31    \ Edge 
 EDGE       2,       6,     8,     3,         31    \ Edge 
 EDGE       6,       7,     7,     1,         31    \ Edge 
 EDGE       7,       3,     9,     5,         31    \ Edge 
 EDGE       3,       1,     5,     4,         31    \ Edge 
 EDGE       2,       4,     8,     2,         31    \ Edge 
 EDGE       4,       5,     7,     6,         31    \ Edge 
 EDGE       5,       3,     9,     4,         31    \ Edge 
 EDGE       0,       8,     2,     0,         20    \ Edge 
 EDGE       8,       1,     4,     0,         20    \ Edge 
 EDGE       4,       8,     6,     2,         16    \ Edge 
 EDGE       8,       5,     6,     4,         16    \ Edge 
 EDGE       4,       6,     8,     7,         31    \ Edge 
 EDGE       5,       7,     9,     7,         31    \ Edge 
 EDGE       0,       6,     3,     1,         20    \ Edge 
 EDGE       1,       7,     5,     1,         20    \ Edge 
 EDGE      10,       9,     1,     0,          2    \ Edge 

 EQUB &1F, &00, &29, &0A
 EQUB &5F, &00, &1B, &03
 EQUB &9F, &08, &2E, &08
 EQUB &DF, &0C, &39, &0C
 EQUB &1F, &08, &2E, &08
 EQUB &5F, &0C, &39, &0C
 EQUB &1F, &00, &31, &00
 EQUB &3F, &00, &00, &9A
 EQUB &BF, &79, &6F, &3E
 EQUB &3F, &79, &6F, &3E

\ WRM  = 23 = Worm

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 99 * 99           \ Targetable area          = 99 * 99
 EQUB &50               \ Edges data offset (low)  = &0050
 EQUB &90               \ Faces data offset (low)  = &0090
 EQUB 77                \ Max. edge count          = (77 - 1) / 4 = 19
 EQUB 0                 \ Gun vertex               = 0
 EQUB 18                \ Explosion count          = 3, as (4 * n) + 6 = 18
 EQUB 60                \ Number of vertices       = 60 / 6 = 10
 EQUB 16                \ Number of edges          = 16
 EQUW 0                 \ Bounty                   = 0
 EQUB 32                \ Number of faces          = 32 / 4 = 8
 EQUB 19                \ Visibility distance      = 19
 EQUB 30                \ Max. energy              = 30
 EQUB 23                \ Max. speed               = 23
 EQUB &00               \ Edges data offset (high) = &0050
 EQUB &00               \ Faces data offset (high) = &0090
 EQUB 3                 \ Normals are scaled by    = 2^3 = 8
 EQUB %00001000         \ Laser power              = 1
                        \ Missiles                 = 0

 EQUB &0A, &0A, &23, &5F, &02, &77
 EQUB &0A, &0A, &23, &DF, &03, &77
 EQUB &05, &06, &0F, &1F, &01, &24
 EQUB &05, &06, &0F, &9F, &01, &35
 EQUB &0F, &0A, &19, &5F, &24, &77
 EQUB &0F, &0A, &19, &DF, &35, &77
 EQUB &1A, &0A, &19, &7F, &46, &77
 EQUB &1A, &0A, &19, &FF, &56, &77
 EQUB &08, &0E, &19, &3F, &14, &66
 EQUB &08, &0E, &19, &BF, &15, &66

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     7,     0,         31    \ Edge 
 EDGE       1,       5,     7,     3,         31    \ Edge 
 EDGE       5,       7,     7,     5,         31    \ Edge 
 EDGE       7,       6,     7,     6,         31    \ Edge 
 EDGE       6,       4,     7,     4,         31    \ Edge 
 EDGE       4,       0,     7,     2,         31    \ Edge 
 EDGE       0,       2,     2,     0,         31    \ Edge 
 EDGE       1,       3,     3,     0,         31    \ Edge 
 EDGE       4,       2,     4,     2,         31    \ Edge 
 EDGE       5,       3,     5,     3,         31    \ Edge 
 EDGE       2,       8,     4,     1,         31    \ Edge 
 EDGE       8,       6,     6,     4,         31    \ Edge 
 EDGE       3,       9,     5,     1,         31    \ Edge 
 EDGE       9,       7,     6,     5,         31    \ Edge 
 EDGE       2,       3,     1,     0,         31    \ Edge 
 EDGE       8,       9,     6,     1,         31    \ Edge 


 EQUB &1F, &00, &58, &46
 EQUB &1F, &00, &45, &0E
 EQUB &1F, &46, &42, &23
 EQUB &9F, &46, &42, &23
 EQUB &1F, &40, &31, &0E
 EQUB &9F, &40, &31, &0E
 EQUB &3F, &00, &00, &C8
 EQUB &5F, &00, &50, &00

INCLUDE "library/6502sp/main/variable_ship_cobra_mk_iii_pirate.asm"

\ ASP  = 25 = Asp Mk II

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 60 * 60           \ Targetable area          = 60 * 60
 EQUB &86               \ Edges data offset (low)  = &0086
 EQUB &F6               \ Faces data offset (low)  = &00F6
 EQUB 105               \ Max. edge count          = (105 - 1) / 4 = 26
 EQUB 32                \ Gun vertex               = 32
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 114               \ Number of vertices       = 114 / 6 = 19
 EQUB 28                \ Number of edges          = 28
 EQUW 200               \ Bounty                   = 200
 EQUB 48                \ Number of faces          = 48 / 4 = 12
 EQUB 40                \ Visibility distance      = 40
 EQUB 150               \ Max. energy              = 150
 EQUB 40                \ Max. speed               = 40
 EQUB &00               \ Edges data offset (high) = &0086
 EQUB &00               \ Faces data offset (high) = &00F6
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00101001         \ Laser power              = 5
                        \ Missiles                 = 1

 EQUB &00, &12, &00, &56, &01, &22
 EQUB &00, &09, &2D, &7F, &12, &BB
 EQUB &2B, &00, &2D, &3F, &16, &BB
 EQUB &45, &03, &00, &5F, &16, &79
 EQUB &2B, &0E, &1C, &5F, &01, &77
 EQUB &2B, &00, &2D, &BF, &25, &BB
 EQUB &45, &03, &00, &DF, &25, &8A
 EQUB &2B, &0E, &1C, &DF, &02, &88
 EQUB &1A, &07, &49, &5F, &04, &79
 EQUB &1A, &07, &49, &DF, &04, &8A
 EQUB &2B, &0E, &1C, &1F, &34, &69
 EQUB &2B, &0E, &1C, &9F, &34, &5A
 EQUB &00, &09, &2D, &3F, &35, &6B
 EQUB &11, &00, &2D, &AA, &BB, &BB
 EQUB &11, &00, &2D, &29, &BB, &BB
 EQUB &00, &04, &2D, &6A, &BB, &BB
 EQUB &00, &04, &2D, &28, &BB, &BB
 EQUB &00, &07, &49, &4A, &04, &04
 EQUB &00, &07, &53, &4A, &04, &04

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     1,         22    \ Edge 
 EDGE       0,       4,     1,     0,         22    \ Edge 
 EDGE       0,       7,     2,     0,         22    \ Edge 
 EDGE       1,       2,    11,     1,         31    \ Edge 
 EDGE       2,       3,     6,     1,         31    \ Edge 
 EDGE       3,       8,     9,     7,         16    \ Edge 
 EDGE       8,       9,     4,     0,         31    \ Edge 
 EDGE       6,       9,    10,     8,         16    \ Edge 
 EDGE       5,       6,     5,     2,         31    \ Edge 
 EDGE       1,       5,    11,     2,         31    \ Edge 
 EDGE       3,       4,     7,     1,         31    \ Edge 
 EDGE       4,       8,     7,     0,         31    \ Edge 
 EDGE       6,       7,     8,     2,         31    \ Edge 
 EDGE       7,       9,     8,     0,         31    \ Edge 
 EDGE       2,      12,    11,     6,         31    \ Edge 
 EDGE       5,      12,    11,     5,         31    \ Edge 
 EDGE      10,      12,     6,     3,         22    \ Edge 
 EDGE      11,      12,     5,     3,         22    \ Edge 
 EDGE      10,      11,     4,     3,         22    \ Edge 
 EDGE       6,      11,    10,     5,         31    \ Edge 
 EDGE       9,      11,    10,     4,         31    \ Edge 
 EDGE       3,      10,     9,     6,         31    \ Edge 
 EDGE       8,      10,     9,     4,         31    \ Edge 
 EDGE      13,      15,    11,    11,         10    \ Edge 
 EDGE      15,      14,    11,    11,          9    \ Edge 
 EDGE      14,      16,    11,    11,          8    \ Edge 
 EDGE      16,      13,    11,    11,          8    \ Edge 
 EDGE      18,      17,     4,     0,         10    \ Edge 

 EQUB &5F, &00, &23, &05
 EQUB &7F, &08, &26, &07
 EQUB &FF, &08, &26, &07
 EQUB &36, &00, &18, &01
 EQUB &1F, &00, &2B, &13
 EQUB &BF, &06, &1C, &02
 EQUB &3F, &06, &1C, &02
 EQUB &5F, &3B, &40, &1F
 EQUB &DF, &3B, &40, &1F
 EQUB &1F, &50, &2E, &32
 EQUB &9F, &50, &2E, &32
 EQUB &3F, &00, &00, &5A

\ ?

 EQUB &38, &E5, &2C, &C5

\        26 = Python (pirate)

 EQUB 2                 \ Max. canisters on demise = 2
 EQUW 80 * 80           \ Targetable area          = 80 * 80
 EQUB &56               \ Edges data offset (low)  = &0056
 EQUB &BE               \ Faces data offset (low)  = &00BE
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 66                \ Number of vertices       = 66 / 6 = 11
 EQUB 26                \ Number of edges          = 26
 EQUW 200               \ Bounty                   = 200
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 40                \ Visibility distance      = 40
 EQUB 250               \ Max. energy              = 250
 EQUB &14               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &0056
 EQUB &00               \ Faces data offset (high) = &00BE
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00011011         \ Laser power              = 3
                        \ Missiles                 = 3

 EQUB &00, &00, &E0, &1F, &10, &32
 EQUB &00, &30, &30, &1F, &10, &54
 EQUB &60, &00, &10, &3F, &FF, &FF
 EQUB &60, &00, &10, &BF, &FF, &FF
 EQUB &00, &30, &20, &3F, &54, &98
 EQUB &00, &18, &70, &3F, &89, &CC
 EQUB &30, &00, &70, &BF, &B8, &CC
 EQUB &30, &00, &70, &3F, &A9, &CC
 EQUB &00, &30, &30, &5F, &32, &76
 EQUB &00, &30, &20, &7F, &76, &BA
 EQUB &00, &18, &70, &7F, &BA, &CC

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       8,     2,     3,         31    \ Edge 
 EDGE       0,       3,     0,     2,         31    \ Edge 
 EDGE       0,       2,     1,     3,         31    \ Edge 
 EDGE       0,       1,     0,     1,         31    \ Edge 
 EDGE       2,       4,     9,     5,         31    \ Edge 
 EDGE       1,       2,     1,     5,         31    \ Edge 
 EDGE       2,       8,     7,     3,         31    \ Edge 
 EDGE       1,       3,     0,     4,         31    \ Edge 
 EDGE       3,       8,     2,     6,         31    \ Edge 
 EDGE       2,       9,     7,    10,         31    \ Edge 
 EDGE       3,       4,     4,     8,         31    \ Edge 
 EDGE       3,       9,     6,    11,         31    \ Edge 
 EDGE       3,       5,     8,     8,          7    \ Edge 
 EDGE       3,      10,    11,    11,          7    \ Edge 
 EDGE       2,       5,     9,     9,          7    \ Edge 
 EDGE       2,      10,    10,    10,          7    \ Edge 
 EDGE       2,       7,     9,    10,         31    \ Edge 
 EDGE       3,       6,     8,    11,         31    \ Edge 
 EDGE       5,       6,     8,    12,         31    \ Edge 
 EDGE       5,       7,     9,    12,         31    \ Edge 
 EDGE       7,      10,    12,    10,         31    \ Edge 
 EDGE       6,      10,    11,    12,         31    \ Edge 
 EDGE       4,       5,     8,     9,         31    \ Edge 
 EDGE       9,      10,    10,    11,         31    \ Edge 
 EDGE       1,       4,     4,     5,         31    \ Edge 
 EDGE       8,       9,     6,     7,         31    \ Edge 

 EQUB &9F, &1B, &28, &0B
 EQUB &1F, &1B, &28, &0B
 EQUB &DF, &1B, &28, &0B
 EQUB &5F, &1B, &28, &0B
 EQUB &9F, &13, &26, &00
 EQUB &1F, &13, &26, &00
 EQUB &DF, &13, &26, &00
 EQUB &5F, &13, &26, &00
 EQUB &BF, &19, &25, &0B
 EQUB &3F, &19, &25, &0B
 EQUB &7F, &19, &25, &0B
 EQUB &FF, &19, &25, &0B
 EQUB &3F, &00, &00, &70

\        27 = Fer-de-lance

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 40 * 40           \ Targetable area          = 40 * 40
 EQUB &86               \ Edges data offset (low)  = &0086
 EQUB &F2               \ Faces data offset (low)  = &00F2
 EQUB 109               \ Max. edge count          = (109 - 1) / 4 = 27
 EQUB 0                 \ Gun vertex               = 0
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 114               \ Number of vertices       = 114 / 6 = 19
 EQUB 27                \ Number of edges          = 27
 EQUW 0                 \ Bounty                   = 0
 EQUB 40                \ Number of faces          = 40 / 4 = 10
 EQUB 40                \ Visibility distance      = 40
 EQUB 160               \ Max. energy              = 160
 EQUB 30                \ Max. speed               = 30
 EQUB &00               \ Edges data offset (high) = &0086
 EQUB &00               \ Faces data offset (high) = &00F2
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00010010         \ Laser power              = 2
                        \ Missiles                 = 2

 EQUB &00, &0E, &6C, &5F, &01, &59
 EQUB &28, &0E, &04, &FF, &12, &99
 EQUB &0C, &0E, &34, &FF, &23, &99
 EQUB &0C, &0E, &34, &7F, &34, &99
 EQUB &28, &0E, &04, &7F, &45, &99
 EQUB &28, &0E, &04, &BC, &01, &26
 EQUB &0C, &02, &34, &BC, &23, &67
 EQUB &0C, &02, &34, &3C, &34, &78
 EQUB &28, &0E, &04, &3C, &04, &58
 EQUB &00, &12, &14, &2F, &06, &78
 EQUB &03, &0B, &61, &CB, &00, &00
 EQUB &1A, &08, &12, &89, &00, &00
 EQUB &10, &0E, &04, &AB, &00, &00
 EQUB &03, &0B, &61, &4B, &00, &00
 EQUB &1A, &08, &12, &09, &00, &00
 EQUB &10, &0E, &04, &2B, &00, &00
 EQUB &00, &0E, &14, &6C, &99, &99
 EQUB &0E, &0E, &2C, &CC, &99, &99
 EQUB &0E, &0E, &2C, &4C, &99, &99

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     9,     1,         31    \ Edge 
 EDGE       1,       2,     9,     2,         31    \ Edge 
 EDGE       2,       3,     9,     3,         31    \ Edge 
 EDGE       3,       4,     9,     4,         31    \ Edge 
 EDGE       0,       4,     9,     5,         31    \ Edge 
 EDGE       0,       5,     1,     0,         28    \ Edge 
 EDGE       5,       6,     6,     2,         28    \ Edge 
 EDGE       6,       7,     7,     3,         28    \ Edge 
 EDGE       7,       8,     8,     4,         28    \ Edge 
 EDGE       0,       8,     5,     0,         28    \ Edge 
 EDGE       5,       9,     6,     0,         15    \ Edge 
 EDGE       6,       9,     7,     6,         11    \ Edge 
 EDGE       7,       9,     8,     7,         11    \ Edge 
 EDGE       8,       9,     8,     0,         15    \ Edge 
 EDGE       1,       5,     2,     1,         14    \ Edge 
 EDGE       2,       6,     3,     2,         14    \ Edge 
 EDGE       3,       7,     4,     3,         14    \ Edge 
 EDGE       4,       8,     5,     4,         14    \ Edge 
 EDGE      10,      11,     0,     0,          8    \ Edge 
 EDGE      11,      12,     0,     0,          9    \ Edge 
 EDGE      10,      12,     0,     0,         11    \ Edge 
 EDGE      13,      14,     0,     0,          8    \ Edge 
 EDGE      14,      15,     0,     0,          9    \ Edge 
 EDGE      13,      15,     0,     0,         11    \ Edge 
 EDGE      16,      17,     9,     9,         12    \ Edge 
 EDGE      16,      18,     9,     9,         12    \ Edge 
 EDGE      17,      18,     9,     9,          8    \ Edge 

 EQUB &1C, &00, &18, &06
 EQUB &9F, &44, &00, &18
 EQUB &BF, &3F, &00, &25
 EQUB &3F, &00, &00, &68
 EQUB &3F, &3F, &00, &25
 EQUB &1F, &44, &00, &18
 EQUB &BC, &0C, &2E, &13
 EQUB &3C, &00, &2D, &16
 EQUB &3C, &0C, &2E, &13
 EQUB &5F, &00, &1C, &00

\        28 = Moray

 EQUB 1                 \ Max. canisters on demise = 1
 EQUW 30 * 30           \ Targetable area          = 30 * 30
 EQUB &68               \ Edges data offset (low)  = &0068
 EQUB &B4               \ Faces data offset (low)  = &00B4
 EQUB 73                \ Max. edge count          = (73 - 1) / 4 = 18
 EQUB 0                 \ Gun vertex               = 0
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 84                \ Number of vertices       = 84 / 6 = 14
 EQUB 19                \ Number of edges          = 19
 EQUW 50                \ Bounty                   = 50
 EQUB 36                \ Number of faces          = 36 / 4 = 9
 EQUB 40                \ Visibility distance      = 40
 EQUB 100               \ Max. energy              = 100
 EQUB 25                \ Max. speed               = 25
 EQUB &00               \ Edges data offset (high) = &0068
 EQUB &00               \ Faces data offset (high) = &00B4
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

 EQUB &0F, &00, &41, &1F, &02, &78
 EQUB &0F, &00, &41, &9F, &01, &67
 EQUB &00, &12, &28, &31, &FF, &FF
 EQUB &3C, &00, &00, &9F, &13, &66
 EQUB &3C, &00, &00, &1F, &25, &88
 EQUB &1E, &1B, &0A, &78, &45, &78
 EQUB &1E, &1B, &0A, &F8, &34, &67
 EQUB &09, &04, &19, &E7, &44, &44
 EQUB &09, &04, &19, &67, &44, &44
 EQUB &00, &12, &10, &67, &44, &44
 EQUB &0D, &03, &31, &05, &00, &00
 EQUB &06, &00, &41, &05, &00, &00
 EQUB &0D, &03, &31, &85, &00, &00
 EQUB &06, &00, &41, &85, &00, &00

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     7,     0,         31    \ Edge 
 EDGE       1,       3,     6,     1,         31    \ Edge 
 EDGE       3,       6,     6,     3,         24    \ Edge 
 EDGE       5,       6,     7,     4,         24    \ Edge 
 EDGE       4,       5,     8,     5,         24    \ Edge 
 EDGE       0,       4,     8,     2,         31    \ Edge 
 EDGE       1,       6,     7,     6,         15    \ Edge 
 EDGE       0,       5,     8,     7,         15    \ Edge 
 EDGE       0,       2,     2,     0,         15    \ Edge 
 EDGE       1,       2,     1,     0,         15    \ Edge 
 EDGE       2,       3,     3,     1,         17    \ Edge 
 EDGE       2,       4,     5,     2,         17    \ Edge 
 EDGE       2,       5,     5,     4,         13    \ Edge 
 EDGE       2,       6,     4,     3,         13    \ Edge 
 EDGE       7,       8,     4,     4,          5    \ Edge 
 EDGE       7,       9,     4,     4,          7    \ Edge 
 EDGE       8,       9,     4,     4,          7    \ Edge 
 EDGE      10,      11,     0,     0,          5    \ Edge 
 EDGE      12,      13,     0,     0,          5    \ Edge 


 EQUB &1F, &00, &2B, &07
 EQUB &9F, &0A, &31, &07
 EQUB &1F, &0A, &31, &07
 EQUB &F8, &3B, &1C, &65
 EQUB &78, &00, &34, &4E
 EQUB &78, &3B, &1C, &65
 EQUB &DF, &48, &63, &32
 EQUB &5F, &00, &53, &1E
 EQUB &5F, &48, &63, &32

INCLUDE "library/common/main/variable_ship_thargoid.asm"
INCLUDE "library/common/main/variable_ship_thargon.asm"

\ CON  = 31 = Constrictor

 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 65 * 65           \ Targetable area          = 65 * 65
 EQUB &7A               \ Edges data offset (low)  = &007A
 EQUB &DA               \ Faces data offset (low)  = &00DA
 EQUB 81                \ Max. edge count          = (81 - 1) / 4 = 20
 EQUB 0                 \ Gun vertex               = 0
 EQUB 46                \ Explosion count          = 10, as (4 * n) + 6 = 46
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 24                \ Number of edges          = 24
 EQUW 0                 \ Bounty                   = 0
 EQUB 40                \ Number of faces          = 40 / 4 = 10
 EQUB 45                \ Visibility distance      = 45
 EQUB 252               \ Max. energy              = 252
 EQUB 36                \ Max. speed               = 36
 EQUB &00               \ Edges data offset (high) = &007A
 EQUB &00               \ Faces data offset (high) = &00DA
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00110100         \ Laser power              = 6
                        \ Missiles                 = 4

 EQUB &14, &07, &50, &5F, &02, &99
 EQUB &14, &07, &50, &DF, &01, &99
 EQUB &36, &07, &28, &DF, &14, &99
 EQUB &36, &07, &28, &FF, &45, &89
 EQUB &14, &0D, &28, &BF, &56, &88
 EQUB &14, &0D, &28, &3F, &67, &88
 EQUB &36, &07, &28, &7F, &37, &89
 EQUB &36, &07, &28, &5F, &23, &99
 EQUB &14, &0D, &05, &1F, &FF, &FF
 EQUB &14, &0D, &05, &9F, &FF, &FF
 EQUB &14, &07, &3E, &52, &99, &99
 EQUB &14, &07, &3E, &D2, &99, &99
 EQUB &19, &07, &19, &72, &99, &99
 EQUB &19, &07, &19, &F2, &99, &99
 EQUB &0F, &07, &0F, &6A, &99, &99
 EQUB &0F, &07, &0F, &EA, &99, &99
 EQUB &00, &07, &00, &40, &9F, &01

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     9,     0,         31    \ Edge 
 EDGE       1,       2,     9,     1,         31    \ Edge 
 EDGE       1,       9,     1,     0,         31    \ Edge 
 EDGE       0,       8,     2,     0,         31    \ Edge 
 EDGE       0,       7,     9,     2,         31    \ Edge 
 EDGE       7,       8,     3,     2,         31    \ Edge 
 EDGE       2,       9,     4,     1,         31    \ Edge 
 EDGE       2,       3,     9,     4,         31    \ Edge 
 EDGE       6,       7,     9,     3,         31    \ Edge 
 EDGE       6,       8,     7,     3,         31    \ Edge 
 EDGE       5,       8,     7,     6,         31    \ Edge 
 EDGE       4,       9,     6,     5,         31    \ Edge 
 EDGE       3,       9,     5,     4,         31    \ Edge 
 EDGE       3,       4,     8,     5,         31    \ Edge 
 EDGE       4,       5,     8,     6,         31    \ Edge 
 EDGE       5,       6,     8,     7,         31    \ Edge 
 EDGE       3,       6,     9,     8,         31    \ Edge 
 EDGE       8,       9,     6,     0,         31    \ Edge 
 EDGE      10,      12,     9,     9,         18    \ Edge 
 EDGE      12,      14,     9,     9,          5    \ Edge 
 EDGE      14,      10,     9,     9,         10    \ Edge 
 EDGE      11,      15,     9,     9,         10    \ Edge 
 EDGE      13,      15,     9,     9,          5    \ Edge 
 EDGE      11,      13,     9,     9,         18    \ Edge 

 EQUB &1F, &00, &37, &0F
 EQUB &9F, &18, &4B, &14
 EQUB &1F, &18, &4B, &14
 EQUB &1F, &2C, &4B, &00
 EQUB &9F, &2C, &4B, &00
 EQUB &9F, &2C, &4B, &00
 EQUB &1F, &00, &35, &00
 EQUB &1F, &2C, &4B, &00
 EQUB &3F, &00, &00, &A0
 EQUB &5F, &00, &1B, &00

\ LGO  = 32 = 

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 99 * 99           \ Targetable area          = 99 * 99
 EQUB &10               \ Edges data offset (low)  = &0110
 EQUB &A4               \ Faces data offset (low)  = &01A4
 EQUB 153               \ Max. edge count          = (153 - 1) / 4 = 38
 EQUB 0                 \ Gun vertex               = 0
 EQUB 54                \ Explosion count          = 12, as (4 * n) + 6 = 54
 EQUB 252               \ Number of vertices       = 252 / 6 = 42
 EQUB 37                \ Number of edges          = 37
 EQUW 0                 \ Bounty                   = 0
 EQUB 20                \ Number of faces          = 20 / 4 = 5
 EQUB 99                \ Visibility distance      = 99
 EQUB 252               \ Max. energy              = 252
 EQUB 36                \ Max. speed               = 36
 EQUB &01               \ Edges data offset (high) = &0110
 EQUB &01               \ Faces data offset (high) = &01A4
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

 EQUB &00, &09, &37, &5F, &00, &00
 EQUB &0A, &09, &1E, &DF, &00, &00
 EQUB &19, &09, &5D, &DF, &00, &00
 EQUB &96, &09, &B4, &DF, &00, &00
 EQUB &5A, &09, &0A, &DF, &00, &00
 EQUB &8C, &09, &0A, &DF, &00, &00
 EQUB &00, &09, &5F, &7F, &00, &00
 EQUB &8C, &09, &0A, &5F, &00, &00
 EQUB &5A, &09, &0A, &5F, &00, &00
 EQUB &96, &09, &B4, &5F, &00, &00
 EQUB &19, &09, &5D, &5F, &00, &00
 EQUB &0A, &09, &1E, &5F, &00, &00
 EQUB &55, &09, &1E, &FF, &02, &33
 EQUB &55, &09, &1E, &7F, &02, &44
 EQUB &46, &0B, &05, &9F, &01, &33
 EQUB &46, &0B, &19, &BF, &02, &33
 EQUB &46, &0B, &19, &3F, &02, &44
 EQUB &46, &0B, &05, &1F, &01, &44
 EQUB &00, &09, &05, &5F, &00, &00
 EQUB &00, &09, &05, &5F, &00, &00
 EQUB &00, &09, &05, &5F, &00, &00
 EQUB &1C, &0B, &02, &BF, &00, &00
 EQUB &31, &0B, &02, &BF, &00, &00
 EQUB &31, &0B, &0A, &BF, &00, &00
 EQUB &31, &0B, &11, &BF, &00, &00
 EQUB &1C, &0B, &11, &BF, &00, &00
 EQUB &1C, &0B, &0A, &BF, &00, &00
 EQUB &18, &0B, &02, &BF, &00, &00
 EQUB &18, &0B, &11, &BF, &00, &00
 EQUB &03, &0B, &11, &BF, &00, &00
 EQUB &00, &0B, &02, &3F, &00, &00
 EQUB &00, &0B, &11, &3F, &00, &00
 EQUB &04, &0B, &02, &3F, &00, &00
 EQUB &19, &0B, &02, &3F, &00, &00
 EQUB &0E, &0B, &02, &3F, &00, &00
 EQUB &0E, &0B, &11, &3F, &00, &00
 EQUB &31, &0B, &02, &3F, &00, &00
 EQUB &1C, &0B, &02, &3F, &00, &00
 EQUB &1C, &0B, &0A, &3F, &00, &00
 EQUB &1C, &0B, &11, &3F, &00, &00
 EQUB &31, &0B, &11, &3F, &00, &00
 EQUB &31, &0B, &0A, &3F, &00, &00

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     0,     0,         31    \ Edge 
 EDGE       1,       2,     0,     0,         31    \ Edge 
 EDGE       2,       3,     0,     0,         31    \ Edge 
 EDGE       3,       4,     0,     0,         31    \ Edge 
 EDGE       4,       5,     0,     0,         31    \ Edge 
 EDGE       5,       6,     0,     0,         31    \ Edge 
 EDGE       6,       7,     0,     0,         31    \ Edge 
 EDGE       7,       8,     0,     0,         31    \ Edge 
 EDGE       8,       9,     0,     0,         31    \ Edge 
 EDGE       9,      10,     0,     0,         31    \ Edge 
 EDGE      10,      11,     0,     0,         31    \ Edge 
 EDGE      11,       0,     0,     0,         31    \ Edge 
 EDGE      14,      15,     3,     0,         30    \ Edge 
 EDGE      15,      16,     1,     0,         30    \ Edge 
 EDGE      16,      17,     4,     0,         30    \ Edge 
 EDGE      17,      14,     1,     0,         30    \ Edge 
 EDGE       4,      12,     3,     0,         30    \ Edge 
 EDGE      12,      13,     2,     2,         30    \ Edge 
 EDGE      13,       8,     4,     0,         30    \ Edge 
 EDGE       8,       4,     1,     1,         30    \ Edge 
 EDGE       4,      14,     3,     1,         30    \ Edge 
 EDGE      12,      15,     3,     1,         30    \ Edge 
 EDGE      13,      16,     4,     2,         30    \ Edge 
 EDGE       8,      17,     4,     1,         30    \ Edge 
 EDGE      21,      22,     0,     0,         30    \ Edge 
 EDGE      22,      24,     0,     0,         30    \ Edge 
 EDGE      24,      25,     0,     0,         30    \ Edge 
 EDGE      23,      26,     0,     0,         30    \ Edge 
 EDGE      27,      28,     0,     0,         30    \ Edge 
 EDGE      28,      29,     0,     0,         30    \ Edge 
 EDGE      30,      31,     0,     0,         30    \ Edge 
 EDGE      32,      33,     0,     0,         30    \ Edge 
 EDGE      34,      35,     0,     0,         30    \ Edge 
 EDGE      36,      37,     0,     0,         30    \ Edge 
 EDGE      37,      39,     0,     0,         30    \ Edge 
 EDGE      39,      40,     0,     0,         30    \ Edge 
 EDGE      41,      38,     0,     0,         30    \ Edge 

 EQUB &1F, &00, &17, &00
 EQUB &1F, &00, &04, &0F
 EQUB &3F, &00, &0D, &34
 EQUB &9F, &51, &51, &00
 EQUB &1F, &51, &51, &00

\ COU  = 33 = Cougar

 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 70 * 70           \ Targetable area          = 70 * 70
 EQUB &86               \ Edges data offset (low)  = &0086
 EQUB &EA               \ Faces data offset (low)  = &00EA
 EQUB 105               \ Max. edge count          = (105 - 1) / 4 = 26
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 114               \ Number of vertices       = 114 / 6 = 19
 EQUB 25                \ Number of edges          = 25
 EQUW 0                 \ Bounty                   = 0
 EQUB 24                \ Number of faces          = 24 / 4 = 6
 EQUB 34                \ Visibility distance      = 34
 EQUB 252               \ Max. energy              = 252
 EQUB 40                \ Max. speed               = 40
 EQUB &00               \ Edges data offset (high) = &0086
 EQUB &00               \ Faces data offset (high) = &00EA
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00110100         \ Laser power              = 6
                        \ Missiles                 = 4

 EQUB &00, &05, &43, &1F, &02, &44
 EQUB &14, &00, &28, &9F, &01, &22
 EQUB &28, &00, &28, &BF, &01, &55
 EQUB &00, &0E, &28, &3E, &04, &55
 EQUB &00, &0E, &28, &7E, &12, &35
 EQUB &14, &00, &28, &1F, &23, &44
 EQUB &28, &00, &28, &3F, &34, &55
 EQUB &24, &00, &38, &9F, &01, &11
 EQUB &3C, &00, &14, &BF, &01, &11
 EQUB &24, &00, &38, &1F, &34, &44
 EQUB &3C, &00, &14, &3F, &34, &44
 EQUB &00, &07, &23, &12, &00, &44
 EQUB &00, &08, &19, &14, &00, &44
 EQUB &0C, &02, &2D, &94, &00, &00
 EQUB &0C, &02, &2D, &14, &44, &44
 EQUB &0A, &06, &28, &B4, &55, &55
 EQUB &0A, &06, &28, &F4, &55, &55
 EQUB &0A, &06, &28, &74, &55, &55
 EQUB &0A, &06, &28, &34, &55, &55

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     0,         31    \ Edge 
 EDGE       1,       7,     1,     0,         31    \ Edge 
 EDGE       7,       8,     1,     0,         31    \ Edge 
 EDGE       8,       2,     1,     0,         31    \ Edge 
 EDGE       2,       3,     5,     0,         30    \ Edge 
 EDGE       3,       6,     5,     4,         30    \ Edge 
 EDGE       2,       4,     5,     1,         30    \ Edge 
 EDGE       4,       6,     5,     3,         30    \ Edge 
 EDGE       6,      10,     4,     3,         31    \ Edge 
 EDGE      10,       9,     4,     3,         31    \ Edge 
 EDGE       9,       5,     4,     3,         31    \ Edge 
 EDGE       5,       0,     4,     2,         31    \ Edge 
 EDGE       0,       3,     4,     0,         27    \ Edge 
 EDGE       1,       4,     2,     1,         27    \ Edge 
 EDGE       5,       4,     3,     2,         27    \ Edge 
 EDGE       1,       2,     1,     0,         26    \ Edge 
 EDGE       5,       6,     4,     3,         26    \ Edge 
 EDGE      12,      13,     0,     0,         20    \ Edge 
 EDGE      13,      11,     0,     0,         18    \ Edge 
 EDGE      11,      14,     4,     4,         18    \ Edge 
 EDGE      14,      12,     4,     4,         20    \ Edge 
 EDGE      15,      16,     5,     5,         18    \ Edge 
 EDGE      16,      18,     5,     5,         20    \ Edge 
 EDGE      18,      17,     5,     5,         18    \ Edge 
 EDGE      17,      15,     5,     5,         20    \ Edge 

 EQUB &9F, &10, &2E, &04
 EQUB &DF, &10, &2E, &04
 EQUB &5F, &00, &1B, &05
 EQUB &5F, &10, &2E, &04
 EQUB &1F, &10, &2E, &04
 EQUB &3E, &00, &00, &A0

\ DOD  = 34 = Dodecahedron space station

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 180 * 180         \ Targetable area          = 180 * 180
 EQUB &A4               \ Edges data offset (low)  = &00A4
 EQUB &2C               \ Faces data offset (low)  = &012C
 EQUB 101               \ Max. edge count          = (101 - 1) / 4 = 25
 EQUB 0                 \ Gun vertex               = 0
 EQUB 54                \ Explosion count          = 12, as (4 * n) + 6 = 54
 EQUB 144               \ Number of vertices       = 144 / 6 = 24
 EQUB 34                \ Number of edges          = 34
 EQUW 0                 \ Bounty                   = 0
 EQUB 48                \ Number of faces          = 48 / 4 = 12
 EQUB 125               \ Visibility distance      = 125
 EQUB 240               \ Max. energy              = 240
 EQUB 0                 \ Max. speed               = 0
 EQUB &00               \ Edges data offset (high) = &00A4
 EQUB &01               \ Faces data offset (high) = &012C
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

 EQUB &00, &96, &C4, &1F, &01, &55
 EQUB &8F, &2E, &C4, &1F, &01, &22
 EQUB &58, &79, &C4, &5F, &02, &33
 EQUB &58, &79, &C4, &DF, &03, &44
 EQUB &8F, &2E, &C4, &9F, &04, &55
 EQUB &00, &F3, &2E, &1F, &15, &66
 EQUB &E7, &4B, &2E, &1F, &12, &77
 EQUB &8F, &C4, &2E, &5F, &23, &88
 EQUB &8F, &C4, &2E, &DF, &34, &99
 EQUB &E7, &4B, &2E, &9F, &45, &AA
 EQUB &8F, &C4, &2E, &3F, &16, &77
 EQUB &E7, &4B, &2E, &7F, &27, &88
 EQUB &00, &F3, &2E, &7F, &38, &99
 EQUB &E7, &4B, &2E, &FF, &49, &AA
 EQUB &8F, &C4, &2E, &BF, &56, &AA
 EQUB &58, &79, &C4, &3F, &67, &BB
 EQUB &8F, &2E, &C4, &7F, &78, &BB
 EQUB &00, &96, &C4, &7F, &89, &BB
 EQUB &8F, &2E, &C4, &FF, &9A, &BB
 EQUB &58, &79, &C4, &BF, &6A, &BB
 EQUB &10, &20, &C4, &9E, &00, &00
 EQUB &10, &20, &C4, &DE, &00, &00
 EQUB &10, &20, &C4, &17, &00, &00
 EQUB &10, &20, &C4, &57, &00, &00

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     1,     0,         31    \ Edge 
 EDGE       1,       2,     2,     0,         31    \ Edge 
 EDGE       2,       3,     3,     0,         31    \ Edge 
 EDGE       3,       4,     4,     0,         31    \ Edge 
 EDGE       4,       0,     5,     0,         31    \ Edge 
 EDGE       5,      10,     6,     1,         31    \ Edge 
 EDGE      10,       6,     7,     1,         31    \ Edge 
 EDGE       6,      11,     7,     2,         31    \ Edge 
 EDGE      11,       7,     8,     2,         31    \ Edge 
 EDGE       7,      12,     8,     3,         31    \ Edge 
 EDGE      12,       8,     9,     3,         31    \ Edge 
 EDGE       8,      13,     9,     4,         31    \ Edge 
 EDGE      13,       9,    10,     4,         31    \ Edge 
 EDGE       9,      14,    10,     5,         31    \ Edge 
 EDGE      14,       5,     6,     5,         31    \ Edge 
 EDGE      15,      16,    11,     7,         31    \ Edge 
 EDGE      16,      17,    11,     8,         31    \ Edge 
 EDGE      17,      18,    11,     9,         31    \ Edge 
 EDGE      18,      19,    11,    10,         31    \ Edge 
 EDGE      19,      15,    11,     6,         31    \ Edge 
 EDGE       0,       5,     5,     1,         31    \ Edge 
 EDGE       1,       6,     2,     1,         31    \ Edge 
 EDGE       2,       7,     3,     2,         31    \ Edge 
 EDGE       3,       8,     4,     3,         31    \ Edge 
 EDGE       4,       9,     5,     4,         31    \ Edge 
 EDGE      10,      15,     7,     6,         31    \ Edge 
 EDGE      11,      16,     8,     7,         31    \ Edge 
 EDGE      12,      17,     9,     8,         31    \ Edge 
 EDGE      13,      18,    10,     9,         31    \ Edge 
 EDGE      14,      19,    10,     6,         31    \ Edge 
 EDGE      20,      21,     0,     0,         30    \ Edge 
 EDGE      21,      23,     0,     0,         20    \ Edge 
 EDGE      23,      22,     0,     0,         23    \ Edge 
 EDGE      22,      20,     0,     0,         20    \ Edge 

 EQUB &1F, &00, &00, &C4
 EQUB &1F, &67, &8E, &58
 EQUB &5F, &A9, &37, &59
 EQUB &5F, &00, &B0, &58
 EQUB &DF, &A9, &37, &59
 EQUB &9F, &67, &8E, &58
 EQUB &3F, &00, &B0, &58
 EQUB &3F, &A9, &37, &59
 EQUB &7F, &67, &8E, &58
 EQUB &FF, &67, &8E, &58
 EQUB &BF, &A9, &37, &59
 EQUB &3F, &00, &00, &C4

\ ?

 EQUB &A9, &80, &14, &2B
 EQUB &20, &FD, &B8, &90
 EQUB &01, &60

\ ******************************************************************************
\
\ Save output/SHIPS.bin
\
\ ******************************************************************************

PRINT "SHIPS"
PRINT "Assembled at ", ~CODE_SHIPS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_SHIPS%)
PRINT "Execute at ", ~LOAD_SHIPS%
PRINT "Reload at ", ~LOAD_SHIPS%

PRINT "S.SHIPS ", ~CODE_SHIPS%, " ", ~P%, " ", ~LOAD_SHIPS%, " ", ~LOAD_SHIPS%
SAVE "6502sp/output/SHIPS.bin", CODE_SHIPS%, P%, LOAD_SHIPS%

\ ******************************************************************************
\
\ Show free space
\
\ ******************************************************************************

PRINT "ELITE game code ", ~(K%-F%), " bytes free"
PRINT "F% = ", ~F%
PRINT "Ends at ", ~P%
