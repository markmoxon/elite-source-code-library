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

\ MSL  =  1 = Missile

.SHIP1

 EQUB &00               \ Max. canisters on demise = 
 EQUW &0640             \ Targetable area          = 
 EQUB &7A               \ Edges data offset (low)  = &
 EQUB &DA               \ Faces data offset (low)  = &
 EQUB &55               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &0A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &66               \ Number of vertices       = 102 / 6 = 17
 EQUB &18               \ Number of edges          = 24
 EQUW &0000             \ Bounty                   = 
 EQUB &24               \ Number of faces          = 36 / 4 = 9
 EQUB &0E               \ Visibility distance      = 
 EQUB &02               \ Max. energy              = 
 EQUB &2C               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &00, &00, &44, &1F, &10, &32
 EQUB &08, &08, &24, &5F, &21, &54
 EQUB &08, &08, &24, &1F, &32, &74
 EQUB &08, &08, &24, &9F, &30, &76
 EQUB &08, &08, &24, &DF, &10, &65
 EQUB &08, &08, &2C, &3F, &74, &88
 EQUB &08, &08, &2C, &7F, &54, &88
 EQUB &08, &08, &2C, &FF, &65, &88
 EQUB &08, &08, &2C, &BF, &76, &88
 EQUB &0C, &0C, &2C, &28, &74, &88
 EQUB &0C, &0C, &2C, &68, &54, &88
 EQUB &0C, &0C, &2C, &E8, &65, &88
 EQUB &0C, &0C, &2C, &A8, &76, &88
 EQUB &08, &08, &0C, &A8, &76, &77
 EQUB &08, &08, &0C, &E8, &65, &66
 EQUB &08, &08, &0C, &28, &74, &77
 EQUB &08, &08, &0C, &68, &54, &55

 EQUB &1F, &21, &00, &04
 EQUB &1F, &32, &00, &08
 EQUB &1F, &30, &00, &0C
 EQUB &1F, &10, &00, &10
 EQUB &1F, &24, &04, &08
 EQUB &1F, &51, &04, &10
 EQUB &1F, &60, &0C, &10
 EQUB &1F, &73, &08, &0C
 EQUB &1F, &74, &08, &14
 EQUB &1F, &54, &04, &18
 EQUB &1F, &65, &10, &1C
 EQUB &1F, &76, &0C, &20
 EQUB &1F, &86, &1C, &20
 EQUB &1F, &87, &14, &20
 EQUB &1F, &84, &14, &18
 EQUB &1F, &85, &18, &1C
 EQUB &08, &85, &18, &28
 EQUB &08, &87, &14, &24
 EQUB &08, &87, &20, &30
 EQUB &08, &85, &1C, &2C
 EQUB &08, &74, &24, &3C
 EQUB &08, &54, &28, &40
 EQUB &08, &76, &30, &34
 EQUB &08, &65, &2C, &38

 EQUB &9F, &40, &00, &10
 EQUB &5F, &00, &40, &10
 EQUB &1F, &40, &00, &10
 EQUB &1F, &00, &40, &10
 EQUB &1F, &20, &00, &00
 EQUB &5F, &00, &20, &00
 EQUB &9F, &20, &00, &00
 EQUB &1F, &00, &20, &00
 EQUB &3F, &00, &00, &B0

\ SST  =  2 = Coriolis space station

 EQUB &00               \ Max. canisters on demise = 
 EQUW &6400             \ Targetable area          = 
 EQUB &74               \ Edges data offset (low)  = &
 EQUB &E4               \ Faces data offset (low)  = &
 EQUB &59               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &36               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &60               \ Number of vertices       = 96 / 6 = 16
 EQUB &1C               \ Number of edges          = 28
 EQUW &0000             \ Bounty                   = 
 EQUB &38               \ Number of faces          = 56 / 4 = 14
 EQUB &78               \ Visibility distance      = 
 EQUB &F0               \ Max. energy              = 
 EQUB &00               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &00               \ Normals are scaled by    = 2^ = 
 EQUB &06               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &A0, &00, &A0, &1F, &10, &62
 EQUB &00, &A0, &A0, &1F, &20, &83
 EQUB &A0, &00, &A0, &9F, &30, &74
 EQUB &00, &A0, &A0, &5F, &10, &54
 EQUB &A0, &A0, &00, &5F, &51, &A6
 EQUB &A0, &A0, &00, &1F, &62, &B8
 EQUB &A0, &A0, &00, &9F, &73, &C8
 EQUB &A0, &A0, &00, &DF, &54, &97
 EQUB &A0, &00, &A0, &3F, &A6, &DB
 EQUB &00, &A0, &A0, &3F, &B8, &DC
 EQUB &A0, &00, &A0, &BF, &97, &DC
 EQUB &00, &A0, &A0, &7F, &95, &DA
 EQUB &0A, &1E, &A0, &5E, &00, &00
 EQUB &0A, &1E, &A0, &1E, &00, &00
 EQUB &0A, &1E, &A0, &9E, &00, &00
 EQUB &0A, &1E, &A0, &DE, &00, &00

 EQUB &1F, &10, &00, &0C
 EQUB &1F, &20, &00, &04
 EQUB &1F, &30, &04, &08
 EQUB &1F, &40, &08, &0C
 EQUB &1F, &51, &0C, &10
 EQUB &1F, &61, &00, &10
 EQUB &1F, &62, &00, &14
 EQUB &1F, &82, &14, &04
 EQUB &1F, &83, &04, &18
 EQUB &1F, &73, &08, &18
 EQUB &1F, &74, &08, &1C
 EQUB &1F, &54, &0C, &1C
 EQUB &1F, &DA, &20, &2C
 EQUB &1F, &DB, &20, &24
 EQUB &1F, &DC, &24, &28
 EQUB &1F, &D9, &28, &2C
 EQUB &1F, &A5, &10, &2C
 EQUB &1F, &A6, &10, &20
 EQUB &1F, &B6, &14, &20
 EQUB &1F, &B8, &14, &24
 EQUB &1F, &C8, &18, &24
 EQUB &1F, &C7, &18, &28
 EQUB &1F, &97, &1C, &28
 EQUB &1F, &95, &1C, &2C
 EQUB &1E, &00, &30, &34
 EQUB &1E, &00, &34, &38
 EQUB &1E, &00, &38, &3C
 EQUB &1E, &00, &3C, &30

 EQUB &1F, &00, &00, &A0
 EQUB &5F, &6B, &6B, &6B
 EQUB &1F, &6B, &6B, &6B
 EQUB &9F, &6B, &6B, &6B
 EQUB &DF, &6B, &6B, &6B
 EQUB &5F, &00, &A0, &00
 EQUB &1F, &A0, &00, &00
 EQUB &9F, &A0, &00, &00
 EQUB &1F, &00, &A0, &00
 EQUB &FF, &6B, &6B, &6B
 EQUB &7F, &6B, &6B, &6B
 EQUB &3F, &6B, &6B, &6B
 EQUB &BF, &6B, &6B, &6B
 EQUB &3F, &00, &00, &A0

\ ESC  =  3 = Escape pod

 EQUB &20               \ Max. canisters on demise = 
 EQUW &0100             \ Targetable area          = 
 EQUB &2C               \ Edges data offset (low)  = &
 EQUB &44               \ Faces data offset (low)  = &
 EQUB &1D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &16               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &18               \ Number of vertices       = 24 / 6 = 4
 EQUB &06               \ Number of edges          = 6
 EQUW &0000             \ Bounty                   = 
 EQUB &10               \ Number of faces          = 16 / 4 = 4
 EQUB &08               \ Visibility distance      = 
 EQUB &11               \ Max. energy              = 
 EQUB &08               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &04               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &07, &00, &24, &9F, &12, &33
 EQUB &07, &0E, &0C, &FF, &02, &33
 EQUB &07, &0E, &0C, &BF, &01, &33
 EQUB &15, &00, &00, &1F, &01, &22

 EQUB &1F, &23, &00, &04
 EQUB &1F, &03, &04, &08
 EQUB &1F, &01, &08, &0C
 EQUB &1F, &12, &0C, &00
 EQUB &1F, &13, &00, &08
 EQUB &1F, &02, &0C, &04

 EQUB &3F, &34, &00, &7A
 EQUB &1F, &27, &67, &1E
 EQUB &5F, &27, &67, &1E
 EQUB &9F, &70, &00, &00

\ PLT  =  4 = Plate (alloys)

 EQUB &80               \ Max. canisters on demise = 
 EQUW &0064             \ Targetable area          = 
 EQUB &2C               \ Edges data offset (low)  = &
 EQUB &3C               \ Faces data offset (low)  = &
 EQUB &15               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &0A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &18               \ Number of vertices       = 24 / 6 = 4
 EQUB &04               \ Number of edges          = 4
 EQUW &0000             \ Bounty                   = 
 EQUB &04               \ Number of faces          = 4 / 4 = 1
 EQUB &05               \ Visibility distance      = 
 EQUB &10               \ Max. energy              = 
 EQUB &10               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &03               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &0F, &16, &09, &FF, &FF, &FF
 EQUB &0F, &26, &09, &BF, &FF, &FF
 EQUB &13, &20, &0B, &14, &FF, &FF
 EQUB &0A, &2E, &06, &54, &FF, &FF


 EQUB &1F, &FF, &00, &04
 EQUB &10, &FF, &04, &08
 EQUB &14, &FF, &08, &0C
 EQUB &10, &FF, &0C, &00

 EQUB &00, &00, &00, &00

\ OIL  =  5 = Cargo canister

 EQUB &00               \ Max. canisters on demise = 
 EQUW &0190             \ Targetable area          = 
 EQUB &50               \ Edges data offset (low)  = &
 EQUB &8C               \ Faces data offset (low)  = &
 EQUB &35               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &12               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &3C               \ Number of vertices       = 60 / 6 = 10
 EQUB &0F               \ Number of edges          = 15
 EQUW &0000             \ Bounty                   = 
 EQUB &1C               \ Number of faces          = 28 / 4 = 7
 EQUB &0C               \ Visibility distance      = 
 EQUB &11               \ Max. energy              = 
 EQUB &0F               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &18, &10, &00, &1F, &10, &55
 EQUB &18, &05, &0F, &1F, &10, &22
 EQUB &18, &0D, &09, &5F, &20, &33
 EQUB &18, &0D, &09, &7F, &30, &44
 EQUB &18, &05, &0F, &3F, &40, &55
 EQUB &18, &10, &00, &9F, &51, &66
 EQUB &18, &05, &0F, &9F, &21, &66
 EQUB &18, &0D, &09, &DF, &32, &66
 EQUB &18, &0D, &09, &FF, &43, &66
 EQUB &18, &05, &0F, &BF, &54, &66

 EQUB &1F, &10, &00, &04
 EQUB &1F, &20, &04, &08
 EQUB &1F, &30, &08, &0C
 EQUB &1F, &40, &0C, &10
 EQUB &1F, &50, &00, &10
 EQUB &1F, &51, &00, &14
 EQUB &1F, &21, &04, &18
 EQUB &1F, &32, &08, &1C
 EQUB &1F, &43, &0C, &20
 EQUB &1F, &54, &10, &24
 EQUB &1F, &61, &14, &18
 EQUB &1F, &62, &18, &1C
 EQUB &1F, &63, &1C, &20
 EQUB &1F, &64, &20, &24
 EQUB &1F, &65, &24, &14

 EQUB &1F, &60, &00, &00
 EQUB &1F, &00, &29, &1E
 EQUB &5F, &00, &12, &30
 EQUB &5F, &00, &33, &00
 EQUB &7F, &00, &12, &30
 EQUB &3F, &00, &29, &1E
 EQUB &9F, &60, &00, &00

\         6 = Boulder

 EQUB &00               \ Max. canisters on demise = 
 EQUW &0384             \ Targetable area          = 30 * 30
 EQUB &3E               \ Edges data offset (low)  = &
 EQUB &7A               \ Faces data offset (low)  = &
 EQUB &31               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &0E               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &2A               \ Number of vertices       = 42 / 6 = 7
 EQUB &0F               \ Number of edges          = 15
 EQUW &0001             \ Bounty                   = 
 EQUB &28               \ Number of faces          = 40 / 4 = 10
 EQUB &14               \ Visibility distance      = 
 EQUB &14               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &12, &25, &0B, &BF, &01, &59
 EQUB &1E, &07, &0C, &1F, &12, &56
 EQUB &1C, &07, &0C, &7F, &23, &67
 EQUB &02, &00, &27, &3F, &34, &78
 EQUB &1C, &22, &1E, &BF, &04, &89
 EQUB &05, &0A, &0D, &5F, &FF, &FF
 EQUB &14, &11, &1E, &3F, &FF, &FF

 EQUB &1F, &15, &00, &04
 EQUB &1F, &26, &04, &08
 EQUB &1F, &37, &08, &0C
 EQUB &1F, &48, &0C, &10
 EQUB &1F, &09, &10, &00
 EQUB &1F, &01, &00, &14
 EQUB &1F, &12, &04, &14
 EQUB &1F, &23, &08, &14
 EQUB &1F, &34, &0C, &14
 EQUB &1F, &04, &10, &14
 EQUB &1F, &59, &00, &18
 EQUB &1F, &56, &04, &18
 EQUB &1F, &67, &08, &18
 EQUB &1F, &78, &0C, &18
 EQUB &1F, &89, &10, &18

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

\ AST  =  7 = Asteroid

 EQUB &00               \ Max. canisters on demise = 
 EQUW &1900             \ Targetable area          = 
 EQUB &4A               \ Edges data offset (low)  = &
 EQUB &9E               \ Faces data offset (low)  = &
 EQUB &45               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &22               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &36               \ Number of vertices       = 54 / 6 = 9
 EQUB &15               \ Number of edges          = 21
 EQUW &0005             \ Bounty                   = 
 EQUB &38               \ Number of faces          = 56 / 4 = 14
 EQUB &32               \ Visibility distance      = 
 EQUB &3C               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &00, &50, &00, &1F, &FF, &FF
 EQUB &50, &0A, &00, &DF, &FF, &FF
 EQUB &00, &50, &00, &5F, &FF, &FF
 EQUB &46, &28, &00, &5F, &FF, &FF
 EQUB &3C, &32, &00, &1F, &65, &DC
 EQUB &32, &00, &3C, &1F, &FF, &FF
 EQUB &28, &00, &46, &9F, &10, &32
 EQUB &00, &1E, &4B, &3F, &FF, &FF
 EQUB &00, &32, &3C, &7F, &98, &BA

 EQUB &1F, &72, &00, &04
 EQUB &1F, &D6, &00, &10
 EQUB &1F, &C5, &0C, &10
 EQUB &1F, &B4, &08, &0C
 EQUB &1F, &A3, &04, &08
 EQUB &1F, &32, &04, &18
 EQUB &1F, &31, &08, &18
 EQUB &1F, &41, &08, &14
 EQUB &1F, &10, &14, &18
 EQUB &1F, &60, &00, &14
 EQUB &1F, &54, &0C, &14
 EQUB &1F, &20, &00, &18
 EQUB &1F, &65, &10, &14
 EQUB &1F, &A8, &04, &20
 EQUB &1F, &87, &04, &1C
 EQUB &1F, &D7, &00, &1C
 EQUB &1F, &DC, &10, &1C
 EQUB &1F, &C9, &0C, &1C
 EQUB &1F, &B9, &0C, &20
 EQUB &1F, &BA, &08, &20
 EQUB &1F, &98, &1C, &20

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

\ SPL  =  8 = Splinter

 EQUB &B0               \ Max. canisters on demise = 
 EQUW &0100             \ Targetable area          = 
 EQUB &78               \ Edges data offset (low)  = &
 EQUB &44               \ Faces data offset (low)  = &
 EQUB &1D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &16               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &18               \ Number of vertices       = 24 / 6 = 4
 EQUB &06               \ Number of edges          = 6
 EQUW &0000             \ Bounty                   = 
 EQUB &10               \ Number of faces          = 16 / 4 = 4
 EQUB &08               \ Visibility distance      = 
 EQUB &14               \ Max. energy              = 
 EQUB &0A               \ Max. speed               = 
 EQUB &FD               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &05               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &18, &19, &10, &DF, &12, &33
 EQUB &00, &0C, &0A, &3F, &02, &33
 EQUB &0B, &06, &02, &5F, &01, &33
 EQUB &0C, &2A, &07, &1F, &01, &22

 EQUB &1F, &23, &00, &04
 EQUB &1F, &03, &04, &08
 EQUB &1F, &01, &08, &0C
 EQUB &1F, &12, &0C, &00

\ SHU  =  9 = Shuttle

 EQUB &0F               \ Max. canisters on demise = 
 EQUW &09C4             \ Targetable area          = 
 EQUB &86               \ Edges data offset (low)  = &
 EQUB &FE               \ Faces data offset (low)  = &
 EQUB &71               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &26               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &72               \ Number of vertices       = 114 / 6 = 19
 EQUB &1E               \ Number of edges          = 30
 EQUW &0000             \ Bounty                   = 
 EQUB &34               \ Number of faces          = 52 / 4 = 13
 EQUB &16               \ Visibility distance      = 
 EQUB &20               \ Max. energy              = 
 EQUB &08               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &02, &00, &04
 EQUB &1F, &4A, &04, &08
 EQUB &1F, &6B, &08, &0C
 EQUB &1F, &8C, &00, &0C
 EQUB &1F, &18, &00, &1C
 EQUB &18, &12, &00, &10
 EQUB &1F, &23, &04, &10
 EQUB &18, &34, &04, &14
 EQUB &1F, &45, &08, &14
 EQUB &0C, &56, &08, &18
 EQUB &1F, &67, &0C, &18
 EQUB &18, &78, &0C, &1C
 EQUB &1F, &39, &10, &14
 EQUB &1F, &59, &14, &18
 EQUB &1F, &79, &18, &1C
 EQUB &1F, &19, &10, &1C
 EQUB &10, &0C, &00, &30
 EQUB &10, &0A, &04, &30
 EQUB &10, &AB, &08, &30
 EQUB &10, &BC, &0C, &30
 EQUB &10, &99, &20, &24
 EQUB &07, &99, &24, &28
 EQUB &09, &99, &28, &2C
 EQUB &07, &99, &20, &2C
 EQUB &05, &BB, &34, &38
 EQUB &08, &BB, &38, &3C
 EQUB &07, &BB, &34, &3C
 EQUB &05, &AA, &40, &44
 EQUB &08, &AA, &44, &48
 EQUB &07, &AA, &40, &48

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

 EQUB &00               \ Max. canisters on demise = 
 EQUW &09C4             \ Targetable area          = 
 EQUB &F2               \ Edges data offset (low)  = &
 EQUB &AA               \ Faces data offset (low)  = &
 EQUB &95               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &30               \ Gun vertex               = 
 EQUB &1A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &DE               \ Number of vertices       = 222 / 6 = 37
 EQUB &2E               \ Number of edges          = 46
 EQUW &0000             \ Bounty                   = 
 EQUB &38               \ Number of faces          = 56 / 4 = 14
 EQUB &10               \ Visibility distance      = 
 EQUB &20               \ Max. energy              = 
 EQUB &0A               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &01               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &07, &00, &04
 EQUB &1F, &01, &04, &08
 EQUB &1F, &02, &08, &0C
 EQUB &1F, &03, &0C, &10
 EQUB &1F, &04, &10, &14
 EQUB &1F, &05, &14, &18
 EQUB &1F, &06, &00, &18
 EQUB &10, &67, &00, &1C
 EQUB &1F, &17, &04, &20
 EQUB &0B, &12, &08, &24
 EQUB &1F, &23, &0C, &24
 EQUB &1F, &34, &10, &28
 EQUB &0B, &45, &14, &28
 EQUB &1F, &56, &18, &2C
 EQUB &11, &78, &1C, &20
 EQUB &11, &19, &20, &24
 EQUB &11, &5A, &28, &2C
 EQUB &11, &6B, &1C, &2C
 EQUB &13, &BC, &1C, &3C
 EQUB &13, &8C, &1C, &30
 EQUB &10, &89, &20, &30
 EQUB &1F, &39, &24, &34
 EQUB &1F, &3A, &28, &38
 EQUB &10, &AB, &2C, &3C
 EQUB &1F, &9D, &30, &34
 EQUB &1F, &3D, &34, &38
 EQUB &1F, &AD, &38, &3C
 EQUB &1F, &CD, &30, &3C
 EQUB &07, &77, &40, &44
 EQUB &07, &77, &48, &4C
 EQUB &07, &77, &4C, &50
 EQUB &07, &77, &48, &50
 EQUB &07, &77, &50, &54
 EQUB &07, &66, &58, &5C
 EQUB &07, &66, &5C, &60
 EQUB &07, &66, &60, &58
 EQUB &07, &66, &64, &68
 EQUB &07, &66, &68, &6C
 EQUB &07, &66, &64, &6C
 EQUB &07, &66, &6C, &70
 EQUB &06, &33, &74, &78
 EQUB &06, &33, &7C, &80
 EQUB &08, &00, &84, &88
 EQUB &05, &00, &88, &8C
 EQUB &05, &00, &8C, &90
 EQUB &05, &00, &90, &84

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

\ CYL  = 11 = Cobra Mk III

 EQUB &03               \ Max. canisters on demise = 
 EQUW &2341             \ Targetable area          = 95 * 95
 EQUB &BC               \ Edges data offset (low)  = &
 EQUB &54               \ Faces data offset (low)  = &
 EQUB &9D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &54               \ Gun vertex               = 
 EQUB &2A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &A8               \ Number of vertices       = 168 / 6 = 28
 EQUB &26               \ Number of edges          = 38
 EQUW &0000             \ Bounty                   = 
 EQUB &34               \ Number of faces          = 52 / 4 = 13
 EQUB &32               \ Visibility distance      = 
 EQUB &96               \ Max. energy              = 
 EQUB &1C               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &01               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &13               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &20, &00, &4C, &1F, &FF, &FF
 EQUB &20, &00, &4C, &9F, &FF, &FF
 EQUB &00, &1A, &18, &1F, &FF, &FF
 EQUB &78, &03, &08, &FF, &73, &AA
 EQUB &78, &03, &08, &7F, &84, &CC
 EQUB &58, &10, &28, &BF, &FF, &FF
 EQUB &58, &10, &28, &3F, &FF, &FF
 EQUB &80, &08, &28, &7F, &98, &CC
 EQUB &80, &08, &28, &FF, &97, &AA
 EQUB &00, &1A, &28, &3F, &65, &99
 EQUB &20, &18, &28, &FF, &A9, &BB
 EQUB &20, &18, &28, &7F, &B9, &CC
 EQUB &24, &08, &28, &B4, &99, &99
 EQUB &08, &0C, &28, &B4, &99, &99
 EQUB &08, &0C, &28, &34, &99, &99
 EQUB &24, &08, &28, &34, &99, &99
 EQUB &24, &0C, &28, &74, &99, &99
 EQUB &08, &10, &28, &74, &99, &99
 EQUB &08, &10, &28, &F4, &99, &99
 EQUB &24, &0C, &28, &F4, &99, &99
 EQUB &00, &00, &4C, &06, &B0, &BB
 EQUB &00, &00, &5A, &1F, &B0, &BB
 EQUB &50, &06, &28, &E8, &99, &99
 EQUB &50, &06, &28, &A8, &99, &99
 EQUB &58, &00, &28, &A6, &99, &99
 EQUB &50, &06, &28, &28, &99, &99
 EQUB &58, &00, &28, &26, &99, &99
 EQUB &50, &06, &28, &68, &99, &99

 EQUB &1F, &B0, &00, &04
 EQUB &1F, &C4, &00, &10
 EQUB &1F, &A3, &04, &0C
 EQUB &1F, &A7, &0C, &20
 EQUB &1F, &C8, &10, &1C
 EQUB &1F, &98, &18, &1C
 EQUB &1F, &96, &18, &24
 EQUB &1F, &95, &14, &24
 EQUB &1F, &97, &14, &20
 EQUB &1F, &51, &08, &14
 EQUB &1F, &62, &08, &18
 EQUB &1F, &73, &0C, &14
 EQUB &1F, &84, &10, &18
 EQUB &1F, &10, &04, &08
 EQUB &1F, &20, &00, &08
 EQUB &1F, &A9, &20, &28
 EQUB &1F, &B9, &28, &2C
 EQUB &1F, &C9, &1C, &2C
 EQUB &1F, &BA, &04, &28
 EQUB &1F, &CB, &00, &2C
 EQUB &1D, &31, &04, &14
 EQUB &1D, &42, &00, &18
 EQUB &06, &B0, &50, &54
 EQUB &14, &99, &30, &34
 EQUB &14, &99, &48, &4C
 EQUB &14, &99, &38, &3C
 EQUB &14, &99, &40, &44
 EQUB &13, &99, &3C, &40
 EQUB &11, &99, &38, &44
 EQUB &13, &99, &34, &48
 EQUB &13, &99, &30, &4C
 EQUB &1E, &65, &08, &24
 EQUB &06, &99, &58, &60
 EQUB &06, &99, &5C, &60
 EQUB &08, &99, &58, &5C
 EQUB &06, &99, &64, &68
 EQUB &06, &99, &68, &6C
 EQUB &08, &99, &64, &6C

 EQUB &1F, &00, &3E, &1F
 EQUB &9F, &12, &37, &10
 EQUB &1F, &12, &37, &10
 EQUB &9F, &10, &34, &0E
 EQUB &1F, &10, &34, &0E
 EQUB &9F, &0E, &2F, &00
 EQUB &1F, &0E, &2F, &00
 EQUB &9F, &3D, &66, &00
 EQUB &1F, &3D, &66, &00
 EQUB &3F, &00, &00, &50
 EQUB &DF, &07, &2A, &09
 EQUB &5F, &00, &1E, &06
 EQUB &5F, &07, &2A, &09

\        12 = Python

 EQUB &05               \ Max. canisters on demise = 
 EQUW &1900             \ Targetable area          = 
 EQUB &56               \ Edges data offset (low)  = &
 EQUB &BE               \ Faces data offset (low)  = &
 EQUB &59               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &2A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &42               \ Number of vertices       = 66 / 6 = 11
 EQUB &1A               \ Number of edges          = 26
 EQUW &0000             \ Bounty                   = 
 EQUB &34               \ Number of faces          = 52 / 4 = 13
 EQUB &28               \ Visibility distance      = 
 EQUB &FA               \ Max. energy              = 
 EQUB &14               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &00               \ Normals are scaled by    = 2^ = 
 EQUB &1B               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &32, &00, &20
 EQUB &1F, &20, &00, &0C
 EQUB &1F, &31, &00, &08
 EQUB &1F, &10, &00, &04
 EQUB &1F, &59, &08, &10
 EQUB &1F, &51, &04, &08
 EQUB &1F, &37, &08, &20
 EQUB &1F, &40, &04, &0C
 EQUB &1F, &62, &0C, &20
 EQUB &1F, &A7, &08, &24
 EQUB &1F, &84, &0C, &10
 EQUB &1F, &B6, &0C, &24
 EQUB &07, &88, &0C, &14
 EQUB &07, &BB, &0C, &28
 EQUB &07, &99, &08, &14
 EQUB &07, &AA, &08, &28
 EQUB &1F, &A9, &08, &1C
 EQUB &1F, &B8, &0C, &18
 EQUB &1F, &C8, &14, &18
 EQUB &1F, &C9, &14, &1C
 EQUB &1F, &AC, &1C, &28
 EQUB &1F, &CB, &18, &28
 EQUB &1F, &98, &10, &14
 EQUB &1F, &BA, &24, &28
 EQUB &1F, &54, &04, &10
 EQUB &1F, &76, &20, &24

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

\        13 = Boa

 EQUB &05               \ Max. canisters on demise = 
 EQUW &1324             \ Targetable area          = 70 * 70
 EQUB &62               \ Edges data offset (low)  = &
 EQUB &C2               \ Faces data offset (low)  = &
 EQUB &5D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &26               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &4E               \ Number of vertices       = 78 / 6 = 13
 EQUB &18               \ Number of edges          = 24
 EQUW &0000             \ Bounty                   = 
 EQUB &34               \ Number of faces          = 52 / 4 = 13
 EQUB &28               \ Visibility distance      = 
 EQUB &FA               \ Max. energy              = 
 EQUB &18               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &00               \ Normals are scaled by    = 2^ = 
 EQUB &1C               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &6B, &00, &14
 EQUB &1F, &8A, &00, &1C
 EQUB &1F, &79, &00, &24
 EQUB &1D, &69, &00, &10
 EQUB &1D, &8B, &00, &18
 EQUB &1D, &7A, &00, &20
 EQUB &1F, &36, &10, &14
 EQUB &1F, &0B, &14, &18
 EQUB &1F, &48, &18, &1C
 EQUB &1F, &1A, &1C, &20
 EQUB &1F, &57, &20, &24
 EQUB &1F, &29, &10, &24
 EQUB &18, &23, &04, &10
 EQUB &18, &03, &04, &14
 EQUB &18, &25, &0C, &24
 EQUB &18, &15, &0C, &20
 EQUB &18, &04, &08, &18
 EQUB &18, &14, &08, &1C
 EQUB &16, &02, &04, &28
 EQUB &16, &01, &08, &2C
 EQUB &16, &12, &0C, &30
 EQUB &0E, &0C, &28, &2C
 EQUB &0E, &1C, &2C, &30
 EQUB &0E, &2C, &30, &28

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

 EQUB &07               \ Max. canisters on demise = 
 EQUW &2710             \ Targetable area          = 
 EQUB &6E               \ Edges data offset (low)  = &
 EQUB &D2               \ Faces data offset (low)  = &
 EQUB &5D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &30               \ Gun vertex               = 
 EQUB &2E               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &5A               \ Number of vertices       = 90 / 6 = 15
 EQUB &19               \ Number of edges          = 25
 EQUW &0000             \ Bounty                   = 
 EQUB &30               \ Number of faces          = 48 / 4 = 12
 EQUB &24               \ Visibility distance      = 
 EQUB &FC               \ Max. energy              = 
 EQUB &0E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &3F               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1E, &01, &00, &04
 EQUB &1E, &02, &04, &08
 EQUB &1E, &03, &08, &0C
 EQUB &1E, &04, &0C, &10
 EQUB &1E, &05, &00, &10
 EQUB &1D, &15, &00, &14
 EQUB &1D, &12, &04, &18
 EQUB &1D, &23, &08, &1C
 EQUB &1D, &34, &0C, &20
 EQUB &1D, &45, &10, &24
 EQUB &1E, &16, &14, &28
 EQUB &1E, &17, &18, &28
 EQUB &1E, &27, &18, &2C
 EQUB &1E, &28, &1C, &2C
 EQUB &1F, &38, &1C, &30
 EQUB &1F, &39, &20, &30
 EQUB &1E, &49, &20, &34
 EQUB &1E, &4A, &24, &34
 EQUB &1E, &5A, &24, &38
 EQUB &1E, &56, &14, &38
 EQUB &1E, &6B, &28, &38
 EQUB &1F, &7B, &28, &30
 EQUB &1F, &78, &2C, &30
 EQUB &1F, &9A, &30, &34
 EQUB &1F, &AB, &30, &38

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

 EQUB &07               \ Max. canisters on demise = 
 EQUW &1900             \ Targetable area          = 
 EQUB &4A               \ Edges data offset (low)  = &
 EQUB &9E               \ Faces data offset (low)  = &
 EQUB &45               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &32               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &36               \ Number of vertices       = 54 / 6 = 9
 EQUB &15               \ Number of edges          = 21
 EQUW &0000             \ Bounty                   = 
 EQUB &38               \ Number of faces          = 56 / 4 = 14
 EQUB &32               \ Visibility distance      = 
 EQUB &B4               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &02               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &00, &50, &00, &1F, &FF, &FF
 EQUB &50, &0A, &00, &DF, &FF, &FF
 EQUB &00, &50, &00, &5F, &FF, &FF
 EQUB &46, &28, &00, &5F, &FF, &FF
 EQUB &3C, &32, &00, &1F, &65, &DC
 EQUB &32, &00, &3C, &1F, &FF, &FF
 EQUB &28, &00, &46, &9F, &10, &32
 EQUB &00, &1E, &4B, &3F, &FF, &FF
 EQUB &00, &32, &3C, &7F, &98, &BA

 EQUB &1F, &72, &00, &04
 EQUB &1F, &D6, &00, &10
 EQUB &1F, &C5, &0C, &10
 EQUB &1F, &B4, &08, &0C
 EQUB &1F, &A3, &04, &08
 EQUB &1F, &32, &04, &18
 EQUB &1F, &31, &08, &18
 EQUB &1F, &41, &08, &14
 EQUB &1F, &10, &14, &18
 EQUB &1F, &60, &00, &14
 EQUB &1F, &54, &0C, &14
 EQUB &1F, &20, &00, &18
 EQUB &1F, &65, &10, &14
 EQUB &1F, &A8, &04, &20
 EQUB &1F, &87, &04, &1C
 EQUB &1F, &D7, &00, &1C
 EQUB &1F, &DC, &10, &1C
 EQUB &1F, &C9, &0C, &1C
 EQUB &1F, &B9, &0C, &20
 EQUB &1F, &BA, &08, &20
 EQUB &1F, &98, &1C, &20

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

\ COPS = 16 = Viper

 EQUB &00               \ Max. canisters on demise = 
 EQUW &15F9             \ Targetable area          = 
 EQUB &6E               \ Edges data offset (low)  = &
 EQUB &BE               \ Faces data offset (low)  = &
 EQUB &51               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &2A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &5A               \ Number of vertices       = 90 / 6 = 15
 EQUB &14               \ Number of edges          = 20
 EQUW &0000             \ Bounty                   = 
 EQUB &1C               \ Number of faces          = 28 / 4 = 7
 EQUB &17               \ Visibility distance      = 
 EQUB &8C               \ Max. energy              = 
 EQUB &20               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &11               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &00, &00, &48, &1F, &21, &43
 EQUB &00, &10, &18, &1E, &10, &22
 EQUB &00, &10, &18, &5E, &43, &55
 EQUB &30, &00, &18, &3F, &42, &66
 EQUB &30, &00, &18, &BF, &31, &66
 EQUB &18, &10, &18, &7E, &54, &66
 EQUB &18, &10, &18, &FE, &35, &66
 EQUB &18, &10, &18, &3F, &20, &66
 EQUB &18, &10, &18, &BF, &10, &66
 EQUB &20, &00, &18, &B3, &66, &66
 EQUB &20, &00, &18, &33, &66, &66
 EQUB &08, &08, &18, &33, &66, &66
 EQUB &08, &08, &18, &B3, &66, &66
 EQUB &08, &08, &18, &F2, &66, &66
 EQUB &08, &08, &18, &72, &66, &66

 EQUB &1F, &42, &00, &0C
 EQUB &1E, &21, &00, &04
 EQUB &1E, &43, &00, &08
 EQUB &1F, &31, &00, &10
 EQUB &1E, &20, &04, &1C
 EQUB &1E, &10, &04, &20
 EQUB &1E, &54, &08, &14
 EQUB &1E, &53, &08, &18
 EQUB &1F, &60, &1C, &20
 EQUB &1E, &65, &14, &18
 EQUB &1F, &61, &10, &20
 EQUB &1E, &63, &10, &18
 EQUB &1F, &62, &0C, &1C
 EQUB &1E, &46, &0C, &14
 EQUB &13, &66, &24, &30
 EQUB &12, &66, &24, &34
 EQUB &13, &66, &28, &2C
 EQUB &12, &66, &28, &38
 EQUB &10, &66, &2C, &38
 EQUB &10, &66, &30, &34

 EQUB &1F, &00, &20, &00
 EQUB &9F, &16, &21, &0B
 EQUB &1F, &16, &21, &0B
 EQUB &DF, &16, &21, &0B
 EQUB &5F, &16, &21, &0B
 EQUB &5F, &00, &20, &00
 EQUB &3F, &00, &00, &30

\ SH3  = 17 = Sidewinder

 EQUB &00               \ Max. canisters on demise = 
 EQUW &1081             \ Targetable area          = 
 EQUB &50               \ Edges data offset (low)  = &
 EQUB &8C               \ Faces data offset (low)  = &
 EQUB &41               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &1E               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &3C               \ Number of vertices       = 60 / 6 = 10
 EQUB &0F               \ Number of edges          = 15
 EQUW &0032             \ Bounty                   = 
 EQUB &1C               \ Number of faces          = 28 / 4 = 7
 EQUB &14               \ Visibility distance      = 
 EQUB &46               \ Max. energy              = 
 EQUB &25               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &10               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &20, &00, &24, &9F, &10, &54
 EQUB &20, &00, &24, &1F, &20, &65
 EQUB &40, &00, &1C, &3F, &32, &66
 EQUB &40, &00, &1C, &BF, &31, &44
 EQUB &00, &10, &1C, &3F, &10, &32
 EQUB &00, &10, &1C, &7F, &43, &65
 EQUB &0C, &06, &1C, &AF, &33, &33
 EQUB &0C, &06, &1C, &2F, &33, &33
 EQUB &0C, &06, &1C, &6C, &33, &33
 EQUB &0C, &06, &1C, &EC, &33, &33

 EQUB &1F, &50, &00, &04
 EQUB &1F, &62, &04, &08
 EQUB &1F, &20, &04, &10
 EQUB &1F, &10, &00, &10
 EQUB &1F, &41, &00, &0C
 EQUB &1F, &31, &0C, &10
 EQUB &1F, &32, &08, &10
 EQUB &1F, &43, &0C, &14
 EQUB &1F, &63, &08, &14
 EQUB &1F, &65, &04, &14
 EQUB &1F, &54, &00, &14
 EQUB &0F, &33, &18, &1C
 EQUB &0C, &33, &1C, &20
 EQUB &0C, &33, &18, &24
 EQUB &0C, &33, &20, &24

 EQUB &1F, &00, &20, &08
 EQUB &9F, &0C, &2F, &06
 EQUB &1F, &0C, &2F, &06
 EQUB &3F, &00, &00, &70
 EQUB &DF, &0C, &2F, &06
 EQUB &5F, &00, &20, &08
 EQUB &5F, &0C, &2F, &06

\        18 = Mamba

 EQUB &01               \ Max. canisters on demise = 
 EQUW &1324             \ Targetable area          = 70 * 70
 EQUB &AA               \ Edges data offset (low)  = &
 EQUB &1A               \ Faces data offset (low)  = &
 EQUB &61               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &22               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &96               \ Number of vertices       = 150 / 6 = 25
 EQUB &1C               \ Number of edges          = 28
 EQUW &0096             \ Bounty                   = 
 EQUB &14               \ Number of faces          = 20 / 4 = 5
 EQUB &19               \ Visibility distance      = 
 EQUB &5A               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &01               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &12               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &00, &00, &40, &1F, &10, &32
 EQUB &40, &08, &20, &FF, &20, &44
 EQUB &20, &08, &20, &BE, &21, &44
 EQUB &20, &08, &20, &3E, &31, &44
 EQUB &40, &08, &20, &7F, &30, &44
 EQUB &04, &04, &10, &8E, &11, &11
 EQUB &04, &04, &10, &0E, &11, &11
 EQUB &08, &03, &1C, &0D, &11, &11
 EQUB &08, &03, &1C, &8D, &11, &11
 EQUB &14, &04, &10, &D4, &00, &00
 EQUB &14, &04, &10, &54, &00, &00
 EQUB &18, &07, &14, &F4, &00, &00
 EQUB &10, &07, &14, &F0, &00, &00
 EQUB &10, &07, &14, &70, &00, &00
 EQUB &18, &07, &14, &74, &00, &00
 EQUB &08, &04, &20, &AD, &44, &44
 EQUB &08, &04, &20, &2D, &44, &44
 EQUB &08, &04, &20, &6E, &44, &44
 EQUB &08, &04, &20, &EE, &44, &44
 EQUB &20, &04, &20, &A7, &44, &44
 EQUB &20, &04, &20, &27, &44, &44
 EQUB &24, &04, &20, &67, &44, &44
 EQUB &24, &04, &20, &E7, &44, &44
 EQUB &26, &00, &20, &A5, &44, &44
 EQUB &26, &00, &20, &25, &44, &44

 EQUB &1F, &20, &00, &04
 EQUB &1F, &30, &00, &10
 EQUB &1F, &40, &04, &10
 EQUB &1E, &42, &04, &08
 EQUB &1E, &41, &08, &0C
 EQUB &1E, &43, &0C, &10
 EQUB &0E, &11, &14, &18
 EQUB &0C, &11, &18, &1C
 EQUB &0D, &11, &1C, &20
 EQUB &0C, &11, &14, &20
 EQUB &14, &00, &24, &2C
 EQUB &10, &00, &24, &30
 EQUB &10, &00, &28, &34
 EQUB &14, &00, &28, &38
 EQUB &0E, &00, &34, &38
 EQUB &0E, &00, &2C, &30
 EQUB &0D, &44, &3C, &40
 EQUB &0E, &44, &44, &48
 EQUB &0C, &44, &3C, &48
 EQUB &0C, &44, &40, &44
 EQUB &07, &44, &50, &54
 EQUB &05, &44, &50, &60
 EQUB &05, &44, &54, &60
 EQUB &07, &44, &4C, &58
 EQUB &05, &44, &4C, &5C
 EQUB &05, &44, &58, &5C
 EQUB &1E, &21, &00, &08
 EQUB &1E, &31, &00, &0C

 EQUB &5E, &00, &18, &02
 EQUB &1E, &00, &18, &02
 EQUB &9E, &20, &40, &10
 EQUB &1E, &20, &40, &10
 EQUB &3E, &00, &00, &7F

\ KRA  = 19 = Krait

 EQUB &01               \ Max. canisters on demise = 
 EQUW &0E10             \ Targetable area          = 
 EQUB &7A               \ Edges data offset (low)  = &
 EQUB &CE               \ Faces data offset (low)  = &
 EQUB &59               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &12               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &66               \ Number of vertices       = 102 / 6 = 17
 EQUB &15               \ Number of edges          = 21
 EQUW &0064             \ Bounty                   = 
 EQUB &18               \ Number of faces          = 24 / 4 = 6
 EQUB &14               \ Visibility distance      = 
 EQUB &50               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &10               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &03, &00, &04
 EQUB &1F, &12, &00, &08
 EQUB &1F, &01, &00, &0C
 EQUB &1F, &23, &00, &10
 EQUB &1F, &35, &04, &10
 EQUB &1F, &25, &10, &08
 EQUB &1F, &14, &08, &0C
 EQUB &1F, &04, &0C, &04
 EQUB &1E, &01, &0C, &14
 EQUB &1E, &23, &10, &18
 EQUB &08, &45, &04, &08
 EQUB &09, &00, &1C, &28
 EQUB &06, &00, &20, &28
 EQUB &09, &33, &1C, &24
 EQUB &06, &33, &20, &24
 EQUB &08, &44, &2C, &34
 EQUB &08, &44, &34, &30
 EQUB &07, &44, &30, &2C
 EQUB &07, &55, &38, &3C
 EQUB &08, &55, &3C, &40
 EQUB &08, &55, &40, &38

 EQUB &1F, &03, &18, &03
 EQUB &5F, &03, &18, &03
 EQUB &DF, &03, &18, &03
 EQUB &9F, &03, &18, &03
 EQUB &3F, &26, &00, &4D
 EQUB &BF, &26, &00, &4D

\ ADA  = 20 = Adder

 EQUB &00               \ Max. canisters on demise = 
 EQUW &09C4             \ Targetable area          = 50 * 50
 EQUB &80               \ Edges data offset (low)  = &
 EQUB &F4               \ Faces data offset (low)  = &
 EQUB &65               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &16               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &6C               \ Number of vertices       = 108 / 6 = 18
 EQUB &1D               \ Number of edges          = 29
 EQUW &0028             \ Bounty                   = 
 EQUB &3C               \ Number of faces          = 60 / 4 = 15
 EQUB &14               \ Visibility distance      = 
 EQUB &55               \ Max. energy              = 
 EQUB &18               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &10               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &01, &00, &04
 EQUB &07, &23, &04, &08
 EQUB &1F, &45, &08, &0C
 EQUB &1F, &56, &0C, &10
 EQUB &1F, &7E, &10, &14
 EQUB &1F, &8A, &14, &18
 EQUB &1F, &9A, &18, &1C
 EQUB &07, &BC, &1C, &00
 EQUB &1F, &46, &0C, &24
 EQUB &1F, &7D, &24, &20
 EQUB &1F, &89, &20, &18
 EQUB &1F, &0B, &00, &28
 EQUB &1F, &9B, &1C, &28
 EQUB &1F, &02, &04, &2C
 EQUB &1F, &24, &08, &2C
 EQUB &1F, &1C, &00, &30
 EQUB &1F, &AC, &1C, &30
 EQUB &1F, &13, &04, &34
 EQUB &1F, &35, &08, &34
 EQUB &1F, &0D, &28, &2C
 EQUB &1F, &1E, &30, &34
 EQUB &1F, &9D, &20, &28
 EQUB &1F, &4D, &24, &2C
 EQUB &1F, &AE, &14, &30
 EQUB &1F, &5E, &10, &34
 EQUB &05, &00, &38, &3C
 EQUB &03, &00, &3C, &40
 EQUB &04, &00, &40, &44
 EQUB &03, &00, &44, &38

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

 EQUB &00               \ Max. canisters on demise = 
 EQUW &2649             \ Targetable area          = 99 * 99
 EQUB &5C               \ Edges data offset (low)  = &
 EQUB &A0               \ Faces data offset (low)  = &
 EQUB &45               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &1A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &48               \ Number of vertices       = 72 / 6 = 12
 EQUB &11               \ Number of edges          = 17
 EQUW &0037             \ Bounty                   = 
 EQUB &24               \ Number of faces          = 36 / 4 = 9
 EQUB &12               \ Visibility distance      = 
 EQUB &46               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &03               \ Normals are scaled by    = 2^ = 
 EQUB &10               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &03, &00, &04
 EQUB &1F, &12, &04, &14
 EQUB &1F, &18, &14, &0C
 EQUB &1F, &07, &0C, &08
 EQUB &1F, &56, &08, &10
 EQUB &1F, &45, &10, &00
 EQUB &1F, &28, &14, &1C
 EQUB &1F, &37, &1C, &18
 EQUB &1F, &46, &18, &10
 EQUB &1D, &05, &00, &08
 EQUB &1E, &01, &04, &0C
 EQUB &1D, &34, &00, &18
 EQUB &1E, &23, &04, &1C
 EQUB &14, &67, &08, &18
 EQUB &14, &78, &0C, &1C
 EQUB &10, &33, &20, &28
 EQUB &11, &33, &24, &2C

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

 EQUB &03               \ Max. canisters on demise = 
 EQUW &2649             \ Targetable area          = 
 EQUB &56               \ Edges data offset (low)  = &
 EQUB &9E               \ Faces data offset (low)  = &
 EQUB &49               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &28               \ Gun vertex               = 
 EQUB &1A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &42               \ Number of vertices       = 66 / 6 = 11
 EQUB &12               \ Number of edges          = 18
 EQUW &004B             \ Bounty                   = 
 EQUB &28               \ Number of faces          = 40 / 4 = 10
 EQUB &13               \ Visibility distance      = 
 EQUB &5A               \ Max. energy              = 
 EQUB &1A               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &12               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &01, &04, &00
 EQUB &1F, &23, &00, &08
 EQUB &1F, &38, &08, &18
 EQUB &1F, &17, &18, &1C
 EQUB &1F, &59, &1C, &0C
 EQUB &1F, &45, &0C, &04
 EQUB &1F, &28, &08, &10
 EQUB &1F, &67, &10, &14
 EQUB &1F, &49, &14, &0C
 EQUB &14, &02, &00, &20
 EQUB &14, &04, &20, &04
 EQUB &10, &26, &10, &20
 EQUB &10, &46, &20, &14
 EQUB &1F, &78, &10, &18
 EQUB &1F, &79, &14, &1C
 EQUB &14, &13, &00, &18
 EQUB &14, &15, &04, &1C
 EQUB &02, &01, &28, &24

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

 EQUB &00               \ Max. canisters on demise = 
 EQUW &2649             \ Targetable area          = 99 * 99
 EQUB &50               \ Edges data offset (low)  = &
 EQUB &90               \ Faces data offset (low)  = &
 EQUB &4D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &12               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &3C               \ Number of vertices       = 60 / 6 = 10
 EQUB &10               \ Number of edges          = 16
 EQUW &0000             \ Bounty                   = 
 EQUB &20               \ Number of faces          = 32 / 4 = 8
 EQUB &13               \ Visibility distance      = 
 EQUB &1E               \ Max. energy              = 
 EQUB &17               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &03               \ Normals are scaled by    = 2^ = 
 EQUB &08               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &07, &00, &04
 EQUB &1F, &37, &04, &14
 EQUB &1F, &57, &14, &1C
 EQUB &1F, &67, &1C, &18
 EQUB &1F, &47, &18, &10
 EQUB &1F, &27, &10, &00
 EQUB &1F, &02, &00, &08
 EQUB &1F, &03, &04, &0C
 EQUB &1F, &24, &10, &08
 EQUB &1F, &35, &14, &0C
 EQUB &1F, &14, &08, &20
 EQUB &1F, &46, &20, &18
 EQUB &1F, &15, &0C, &24
 EQUB &1F, &56, &24, &1C
 EQUB &1F, &01, &08, &0C
 EQUB &1F, &16, &20, &24

 EQUB &1F, &00, &58, &46
 EQUB &1F, &00, &45, &0E
 EQUB &1F, &46, &42, &23
 EQUB &9F, &46, &42, &23
 EQUB &1F, &40, &31, &0E
 EQUB &9F, &40, &31, &0E
 EQUB &3F, &00, &00, &C8
 EQUB &5F, &00, &50, &00

\ CYL2 = 24 = Cobra Mk III (pirate)

 EQUB &01               \ Max. canisters on demise = 
 EQUW &2341             \ Targetable area          = 95 * 95
 EQUB &BC               \ Edges data offset (low)  = &
 EQUB &54               \ Faces data offset (low)  = &
 EQUB &9D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &54               \ Gun vertex               = 
 EQUB &2A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &A8               \ Number of vertices       = 168 / 6 = 28
 EQUB &26               \ Number of edges          = 38
 EQUW &00AF             \ Bounty                   = 
 EQUB &34               \ Number of faces          = 52 / 4 = 13
 EQUB &32               \ Visibility distance      = 
 EQUB &96               \ Max. energy              = 
 EQUB &1C               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &01               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &12               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &20, &00, &4C, &1F, &FF, &FF
 EQUB &20, &00, &4C, &9F, &FF, &FF
 EQUB &00, &1A, &18, &1F, &FF, &FF
 EQUB &78, &03, &08, &FF, &73, &AA
 EQUB &78, &03, &08, &7F, &84, &CC
 EQUB &58, &10, &28, &BF, &FF, &FF
 EQUB &58, &10, &28, &3F, &FF, &FF
 EQUB &80, &08, &28, &7F, &98, &CC
 EQUB &80, &08, &28, &FF, &97, &AA
 EQUB &00, &1A, &28, &3F, &65, &99
 EQUB &20, &18, &28, &FF, &A9, &BB
 EQUB &20, &18, &28, &7F, &B9, &CC
 EQUB &24, &08, &28, &B4, &99, &99
 EQUB &08, &0C, &28, &B4, &99, &99
 EQUB &08, &0C, &28, &34, &99, &99
 EQUB &24, &08, &28, &34, &99, &99
 EQUB &24, &0C, &28, &74, &99, &99
 EQUB &08, &10, &28, &74, &99, &99
 EQUB &08, &10, &28, &F4, &99, &99
 EQUB &24, &0C, &28, &F4, &99, &99
 EQUB &00, &00, &4C, &06, &B0, &BB
 EQUB &00, &00, &5A, &1F, &B0, &BB
 EQUB &50, &06, &28, &E8, &99, &99
 EQUB &50, &06, &28, &A8, &99, &99
 EQUB &58, &00, &28, &A6, &99, &99
 EQUB &50, &06, &28, &28, &99, &99
 EQUB &58, &00, &28, &26, &99, &99
 EQUB &50, &06, &28, &68, &99, &99

 EQUB &1F, &B0, &00, &04
 EQUB &1F, &C4, &00, &10
 EQUB &1F, &A3, &04, &0C
 EQUB &1F, &A7, &0C, &20
 EQUB &1F, &C8, &10, &1C
 EQUB &1F, &98, &18, &1C
 EQUB &1F, &96, &18, &24
 EQUB &1F, &95, &14, &24
 EQUB &1F, &97, &14, &20
 EQUB &1F, &51, &08, &14
 EQUB &1F, &62, &08, &18
 EQUB &1F, &73, &0C, &14
 EQUB &1F, &84, &10, &18
 EQUB &1F, &10, &04, &08
 EQUB &1F, &20, &00, &08
 EQUB &1F, &A9, &20, &28
 EQUB &1F, &B9, &28, &2C
 EQUB &1F, &C9, &1C, &2C
 EQUB &1F, &BA, &04, &28
 EQUB &1F, &CB, &00, &2C
 EQUB &1D, &31, &04, &14
 EQUB &1D, &42, &00, &18
 EQUB &06, &B0, &50, &54
 EQUB &14, &99, &30, &34
 EQUB &14, &99, &48, &4C
 EQUB &14, &99, &38, &3C
 EQUB &14, &99, &40, &44
 EQUB &13, &99, &3C, &40
 EQUB &11, &99, &38, &44
 EQUB &13, &99, &34, &48
 EQUB &13, &99, &30, &4C
 EQUB &1E, &65, &08, &24
 EQUB &06, &99, &58, &60
 EQUB &06, &99, &5C, &60
 EQUB &08, &99, &58, &5C
 EQUB &06, &99, &64, &68
 EQUB &06, &99, &68, &6C
 EQUB &08, &99, &64, &6C

 EQUB &1F, &00, &3E, &1F
 EQUB &9F, &12, &37, &10
 EQUB &1F, &12, &37, &10
 EQUB &9F, &10, &34, &0E
 EQUB &1F, &10, &34, &0E
 EQUB &9F, &0E, &2F, &00
 EQUB &1F, &0E, &2F, &00
 EQUB &9F, &3D, &66, &00
 EQUB &1F, &3D, &66, &00
 EQUB &3F, &00, &00, &50
 EQUB &DF, &07, &2A, &09
 EQUB &5F, &00, &1E, &06
 EQUB &5F, &07, &2A, &09

\ ASP  = 25 = Asp Mk II

 EQUB &00               \ Max. canisters on demise = 
 EQUW &0E10             \ Targetable area          = 
 EQUB &86               \ Edges data offset (low)  = &
 EQUB &F6               \ Faces data offset (low)  = &
 EQUB &69               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &20               \ Gun vertex               = 
 EQUB &1A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &72               \ Number of vertices       = 114 / 6 = 19
 EQUB &1C               \ Number of edges          = 28
 EQUW &00C8             \ Bounty                   = 
 EQUB &30               \ Number of faces          = 48 / 4 = 12
 EQUB &28               \ Visibility distance      = 
 EQUB &96               \ Max. energy              = 
 EQUB &28               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &29               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &16, &12, &00, &04
 EQUB &16, &01, &00, &10
 EQUB &16, &02, &00, &1C
 EQUB &1F, &1B, &04, &08
 EQUB &1F, &16, &08, &0C
 EQUB &10, &79, &0C, &20
 EQUB &1F, &04, &20, &24
 EQUB &10, &8A, &18, &24
 EQUB &1F, &25, &14, &18
 EQUB &1F, &2B, &04, &14
 EQUB &1F, &17, &0C, &10
 EQUB &1F, &07, &10, &20
 EQUB &1F, &28, &18, &1C
 EQUB &1F, &08, &1C, &24
 EQUB &1F, &6B, &08, &30
 EQUB &1F, &5B, &14, &30
 EQUB &16, &36, &28, &30
 EQUB &16, &35, &2C, &30
 EQUB &16, &34, &28, &2C
 EQUB &1F, &5A, &18, &2C
 EQUB &1F, &4A, &24, &2C
 EQUB &1F, &69, &0C, &28
 EQUB &1F, &49, &20, &28
 EQUB &0A, &BB, &34, &3C
 EQUB &09, &BB, &3C, &38
 EQUB &08, &BB, &38, &40
 EQUB &08, &BB, &40, &34
 EQUB &0A, &04, &48, &44

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

 EQUB &02               \ Max. canisters on demise = 
 EQUW &1900             \ Targetable area          = 80 * 80
 EQUB &56               \ Edges data offset (low)  = &
 EQUB &BE               \ Faces data offset (low)  = &
 EQUB &59               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &2A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &42               \ Number of vertices       = 66 / 6 = 11
 EQUB &1A               \ Number of edges          = 26
 EQUW &00C8             \ Bounty                   = 
 EQUB &34               \ Number of faces          = 52 / 4 = 13
 EQUB &28               \ Visibility distance      = 
 EQUB &FA               \ Max. energy              = 
 EQUB &14               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &00               \ Normals are scaled by    = 2^ = 
 EQUB &1B               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &32, &00, &20
 EQUB &1F, &20, &00, &0C
 EQUB &1F, &31, &00, &08
 EQUB &1F, &10, &00, &04
 EQUB &1F, &59, &08, &10
 EQUB &1F, &51, &04, &08
 EQUB &1F, &37, &08, &20
 EQUB &1F, &40, &04, &0C
 EQUB &1F, &62, &0C, &20
 EQUB &1F, &A7, &08, &24
 EQUB &1F, &84, &0C, &10
 EQUB &1F, &B6, &0C, &24
 EQUB &07, &88, &0C, &14
 EQUB &07, &BB, &0C, &28
 EQUB &07, &99, &08, &14
 EQUB &07, &AA, &08, &28
 EQUB &1F, &A9, &08, &1C
 EQUB &1F, &B8, &0C, &18
 EQUB &1F, &C8, &14, &18
 EQUB &1F, &C9, &14, &1C
 EQUB &1F, &AC, &1C, &28
 EQUB &1F, &CB, &18, &28
 EQUB &1F, &98, &10, &14
 EQUB &1F, &BA, &24, &28
 EQUB &1F, &54, &04, &10
 EQUB &1F, &76, &20, &24

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

 EQUB &00               \ Max. canisters on demise = 
 EQUW &0640             \ Targetable area          = 40 * 40
 EQUB &86               \ Edges data offset (low)  = &
 EQUB &F2               \ Faces data offset (low)  = &
 EQUB &6D               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &1A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &72               \ Number of vertices       = 114 / 6 = 19
 EQUB &1B               \ Number of edges          = 27
 EQUW &0000             \ Bounty                   = 
 EQUB &28               \ Number of faces          = 40 / 4 = 10
 EQUB &28               \ Visibility distance      = 
 EQUB &A0               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &12               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &19, &00, &04
 EQUB &1F, &29, &04, &08
 EQUB &1F, &39, &08, &0C
 EQUB &1F, &49, &0C, &10
 EQUB &1F, &59, &00, &10
 EQUB &1C, &01, &00, &14
 EQUB &1C, &26, &14, &18
 EQUB &1C, &37, &18, &1C
 EQUB &1C, &48, &1C, &20
 EQUB &1C, &05, &00, &20
 EQUB &0F, &06, &14, &24
 EQUB &0B, &67, &18, &24
 EQUB &0B, &78, &1C, &24
 EQUB &0F, &08, &20, &24
 EQUB &0E, &12, &04, &14
 EQUB &0E, &23, &08, &18
 EQUB &0E, &34, &0C, &1C
 EQUB &0E, &45, &10, &20
 EQUB &08, &00, &28, &2C
 EQUB &09, &00, &2C, &30
 EQUB &0B, &00, &28, &30
 EQUB &08, &00, &34, &38
 EQUB &09, &00, &38, &3C
 EQUB &0B, &00, &34, &3C
 EQUB &0C, &99, &40, &44
 EQUB &0C, &99, &40, &48
 EQUB &08, &99, &44, &48

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

 EQUB &01               \ Max. canisters on demise = 
 EQUW &0384             \ Targetable area          = 30 * 30
 EQUB &68               \ Edges data offset (low)  = &
 EQUB &B4               \ Faces data offset (low)  = &
 EQUB &49               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &1A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &54               \ Number of vertices       = 84 / 6 = 14
 EQUB &13               \ Number of edges          = 19
 EQUW &0032             \ Bounty                   = 
 EQUB &24               \ Number of faces          = 36 / 4 = 9
 EQUB &28               \ Visibility distance      = 
 EQUB &64               \ Max. energy              = 
 EQUB &19               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &10               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &07, &00, &04
 EQUB &1F, &16, &04, &0C
 EQUB &18, &36, &0C, &18
 EQUB &18, &47, &14, &18
 EQUB &18, &58, &10, &14
 EQUB &1F, &28, &00, &10
 EQUB &0F, &67, &04, &18
 EQUB &0F, &78, &00, &14
 EQUB &0F, &02, &00, &08
 EQUB &0F, &01, &04, &08
 EQUB &11, &13, &08, &0C
 EQUB &11, &25, &08, &10
 EQUB &0D, &45, &08, &14
 EQUB &0D, &34, &08, &18
 EQUB &05, &44, &1C, &20
 EQUB &07, &44, &1C, &24
 EQUB &07, &44, &20, &24
 EQUB &05, &00, &28, &2C
 EQUB &05, &00, &30, &34

 EQUB &1F, &00, &2B, &07
 EQUB &9F, &0A, &31, &07
 EQUB &1F, &0A, &31, &07
 EQUB &F8, &3B, &1C, &65
 EQUB &78, &00, &34, &4E
 EQUB &78, &3B, &1C, &65
 EQUB &DF, &48, &63, &32
 EQUB &5F, &00, &53, &1E
 EQUB &5F, &48, &63, &32

\ THG  = 29 = Thargoid

 EQUB &00               \ Max. canisters on demise = 
 EQUW &2649             \ Targetable area          = 99 * 99
 EQUB &8C               \ Edges data offset (low)  = &
 EQUB &F4               \ Faces data offset (low)  = &
 EQUB &69               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &3C               \ Gun vertex               = 
 EQUB &26               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &78               \ Number of vertices       = 120 / 6 = 20
 EQUB &1A               \ Number of edges          = 26
 EQUW &01F4             \ Bounty                   = 
 EQUB &28               \ Number of faces          = 40 / 4 = 10
 EQUB &37               \ Visibility distance      = 
 EQUB &F0               \ Max. energy              = 
 EQUB &27               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &16               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &20, &30, &30, &5F, &40, &88
 EQUB &20, &44, &00, &5F, &10, &44
 EQUB &20, &30, &30, &7F, &21, &44
 EQUB &20, &00, &44, &3F, &32, &44
 EQUB &20, &30, &30, &3F, &43, &55
 EQUB &20, &44, &00, &1F, &54, &66
 EQUB &20, &30, &30, &1F, &64, &77
 EQUB &20, &00, &44, &1F, &74, &88
 EQUB &18, &74, &74, &DF, &80, &99
 EQUB &18, &A4, &00, &DF, &10, &99
 EQUB &18, &74, &74, &FF, &21, &99
 EQUB &18, &00, &A4, &BF, &32, &99
 EQUB &18, &74, &74, &BF, &53, &99
 EQUB &18, &A4, &00, &9F, &65, &99
 EQUB &18, &74, &74, &9F, &76, &99
 EQUB &18, &00, &A4, &9F, &87, &99
 EQUB &18, &40, &50, &9E, &99, &99
 EQUB &18, &40, &50, &BE, &99, &99
 EQUB &18, &40, &50, &FE, &99, &99
 EQUB &18, &40, &50, &DE, &99, &99

 EQUB &1F, &84, &00, &1C
 EQUB &1F, &40, &00, &04
 EQUB &1F, &41, &04, &08
 EQUB &1F, &42, &08, &0C
 EQUB &1F, &43, &0C, &10
 EQUB &1F, &54, &10, &14
 EQUB &1F, &64, &14, &18
 EQUB &1F, &74, &18, &1C
 EQUB &1F, &80, &00, &20
 EQUB &1F, &10, &04, &24
 EQUB &1F, &21, &08, &28
 EQUB &1F, &32, &0C, &2C
 EQUB &1F, &53, &10, &30
 EQUB &1F, &65, &14, &34
 EQUB &1F, &76, &18, &38
 EQUB &1F, &87, &1C, &3C
 EQUB &1F, &98, &20, &3C
 EQUB &1F, &90, &20, &24
 EQUB &1F, &91, &24, &28
 EQUB &1F, &92, &28, &2C
 EQUB &1F, &93, &2C, &30
 EQUB &1F, &95, &30, &34
 EQUB &1F, &96, &34, &38
 EQUB &1F, &97, &38, &3C
 EQUB &1E, &99, &40, &44
 EQUB &1E, &99, &48, &4C

 EQUB &5F, &67, &3C, &19
 EQUB &7F, &67, &3C, &19
 EQUB &7F, &67, &19, &3C
 EQUB &3F, &67, &19, &3C
 EQUB &1F, &40, &00, &00
 EQUB &3F, &67, &3C, &19
 EQUB &1F, &67, &3C, &19
 EQUB &1F, &67, &19, &3C
 EQUB &5F, &67, &19, &3C
 EQUB &9F, &30, &00, &00

\ TGL  = 30 = Thargon

 EQUB &F0               \ Max. canisters on demise = 
 EQUW &0640             \ Targetable area          = 40 * 40
 EQUB &E6               \ Edges data offset (low)  = &
 EQUB &50               \ Faces data offset (low)  = &
 EQUB &45               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &12               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &3C               \ Number of vertices       = 60 / 6 = 10
 EQUB &0F               \ Number of edges          = 15
 EQUW &0032             \ Bounty                   = 
 EQUB &1C               \ Number of faces          = 28 / 4 = 7
 EQUB &14               \ Visibility distance      = 
 EQUB &14               \ Max. energy              = 
 EQUB &1E               \ Max. speed               = 
 EQUB &E7               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &10               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &09, &00, &28, &9F, &01, &55
 EQUB &09, &26, &0C, &DF, &01, &22
 EQUB &09, &18, &20, &FF, &02, &33
 EQUB &09, &18, &20, &BF, &03, &44
 EQUB &09, &26, &0C, &9F, &04, &55
 EQUB &09, &00, &08, &3F, &15, &66
 EQUB &09, &0A, &0F, &7F, &12, &66
 EQUB &09, &06, &1A, &7F, &23, &66
 EQUB &09, &06, &1A, &3F, &34, &66
 EQUB &09, &0A, &0F, &3F, &45, &66

 EQUB &9F, &24, &00, &00
 EQUB &5F, &14, &05, &07
 EQUB &7F, &2E, &2A, &0E
 EQUB &3F, &24, &00, &68
 EQUB &3F, &2E, &2A, &0E
 EQUB &1F, &14, &05, &07
 EQUB &1F, &24, &00, &00

\ CON  = 31 = Constrictor

 EQUB &03               \ Max. canisters on demise = 
 EQUW &1081             \ Targetable area          = 65 * 65
 EQUB &7A               \ Edges data offset (low)  = &
 EQUB &DA               \ Faces data offset (low)  = &
 EQUB &51               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &2E               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &66               \ Number of vertices       = 102 / 6 = 17
 EQUB &18               \ Number of edges          = 24
 EQUW &0000             \ Bounty                   = 
 EQUB &28               \ Number of faces          = 40 / 4 = 10
 EQUB &2D               \ Visibility distance      = 
 EQUB &FC               \ Max. energy              = 
 EQUB &24               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &34               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &09, &00, &04
 EQUB &1F, &19, &04, &08
 EQUB &1F, &01, &04, &24
 EQUB &1F, &02, &00, &20
 EQUB &1F, &29, &00, &1C
 EQUB &1F, &23, &1C, &20
 EQUB &1F, &14, &08, &24
 EQUB &1F, &49, &08, &0C
 EQUB &1F, &39, &18, &1C
 EQUB &1F, &37, &18, &20
 EQUB &1F, &67, &14, &20
 EQUB &1F, &56, &10, &24
 EQUB &1F, &45, &0C, &24
 EQUB &1F, &58, &0C, &10
 EQUB &1F, &68, &10, &14
 EQUB &1F, &78, &14, &18
 EQUB &1F, &89, &0C, &18
 EQUB &1F, &06, &20, &24
 EQUB &12, &99, &28, &30
 EQUB &05, &99, &30, &38
 EQUB &0A, &99, &38, &28
 EQUB &0A, &99, &2C, &3C
 EQUB &05, &99, &34, &3C
 EQUB &12, &99, &2C, &34

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

 EQUB &00               \ Max. canisters on demise = 
 EQUW &2649             \ Targetable area          = 99 * 99
 EQUB &10               \ Edges data offset (low)  = &
 EQUB &A4               \ Faces data offset (low)  = &
 EQUB &99               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &36               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &FC               \ Number of vertices       = 252 / 6 = 42
 EQUB &25               \ Number of edges          = 37
 EQUW &0000             \ Bounty                   = 
 EQUB &14               \ Number of faces          = 20 / 4 = 5
 EQUB &63               \ Visibility distance      = 
 EQUB &FC               \ Max. energy              = 
 EQUB &24               \ Max. speed               = 
 EQUB &01               \ Edges data offset (high) = &
 EQUB &01               \ Faces data offset (high) = &
 EQUB &01               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &00, &00, &04
 EQUB &1F, &00, &04, &08
 EQUB &1F, &00, &08, &0C
 EQUB &1F, &00, &0C, &10
 EQUB &1F, &00, &10, &14
 EQUB &1F, &00, &14, &18
 EQUB &1F, &00, &18, &1C
 EQUB &1F, &00, &1C, &20
 EQUB &1F, &00, &20, &24
 EQUB &1F, &00, &24, &28
 EQUB &1F, &00, &28, &2C
 EQUB &1F, &00, &2C, &00
 EQUB &1E, &03, &38, &3C
 EQUB &1E, &01, &3C, &40
 EQUB &1E, &04, &40, &44
 EQUB &1E, &01, &44, &38
 EQUB &1E, &03, &10, &30
 EQUB &1E, &22, &30, &34
 EQUB &1E, &04, &34, &20
 EQUB &1E, &11, &20, &10
 EQUB &1E, &13, &10, &38
 EQUB &1E, &13, &30, &3C
 EQUB &1E, &24, &34, &40
 EQUB &1E, &14, &20, &44
 EQUB &1E, &00, &54, &58
 EQUB &1E, &00, &58, &60
 EQUB &1E, &00, &60, &64
 EQUB &1E, &00, &5C, &68
 EQUB &1E, &00, &6C, &70
 EQUB &1E, &00, &70, &74
 EQUB &1E, &00, &78, &7C
 EQUB &1E, &00, &80, &84
 EQUB &1E, &00, &88, &8C
 EQUB &1E, &00, &90, &94
 EQUB &1E, &00, &94, &9C
 EQUB &1E, &00, &9C, &A0
 EQUB &1E, &00, &A4, &98

 EQUB &1F, &00, &17, &00
 EQUB &1F, &00, &04, &0F
 EQUB &3F, &00, &0D, &34
 EQUB &9F, &51, &51, &00
 EQUB &1F, &51, &51, &00

\ COU  = 33 = Cougar

 EQUB &03               \ Max. canisters on demise = 
 EQUW &1324             \ Targetable area          = 70 * 70
 EQUB &86               \ Edges data offset (low)  = &
 EQUB &EA               \ Faces data offset (low)  = &
 EQUB &69               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &2A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &72               \ Number of vertices       = 114 / 6 = 19
 EQUB &19               \ Number of edges          = 25
 EQUW &0000             \ Bounty                   = 
 EQUB &18               \ Number of faces          = 24 / 4 = 6
 EQUB &22               \ Visibility distance      = 
 EQUB &FC               \ Max. energy              = 
 EQUB &28               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &02               \ Normals are scaled by    = 2^ = 
 EQUB &34               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &02, &00, &04
 EQUB &1F, &01, &04, &1C
 EQUB &1F, &01, &1C, &20
 EQUB &1F, &01, &20, &08
 EQUB &1E, &05, &08, &0C
 EQUB &1E, &45, &0C, &18
 EQUB &1E, &15, &08, &10
 EQUB &1E, &35, &10, &18
 EQUB &1F, &34, &18, &28
 EQUB &1F, &34, &28, &24
 EQUB &1F, &34, &24, &14
 EQUB &1F, &24, &14, &00
 EQUB &1B, &04, &00, &0C
 EQUB &1B, &12, &04, &10
 EQUB &1B, &23, &14, &10
 EQUB &1A, &01, &04, &08
 EQUB &1A, &34, &14, &18
 EQUB &14, &00, &30, &34
 EQUB &12, &00, &34, &2C
 EQUB &12, &44, &2C, &38
 EQUB &14, &44, &38, &30
 EQUB &12, &55, &3C, &40
 EQUB &14, &55, &40, &48
 EQUB &12, &55, &48, &44
 EQUB &14, &55, &44, &3C

 EQUB &9F, &10, &2E, &04
 EQUB &DF, &10, &2E, &04
 EQUB &5F, &00, &1B, &05
 EQUB &5F, &10, &2E, &04
 EQUB &1F, &10, &2E, &04
 EQUB &3E, &00, &00, &A0

\ DOD  = 34 = Dodecahedron space station

 EQUB &00               \ Max. canisters on demise = 
 EQUW &7E90             \ Targetable area          = 180 * 180
 EQUB &A4               \ Edges data offset (low)  = &
 EQUB &2C               \ Faces data offset (low)  = &
 EQUB &65               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &36               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &90               \ Number of vertices       = 144 / 6 = 24
 EQUB &22               \ Number of edges          = 34
 EQUW &0000             \ Bounty                   = 
 EQUB &30               \ Number of faces          = 48 / 4 = 12
 EQUB &7D               \ Visibility distance      = 
 EQUB &F0               \ Max. energy              = 
 EQUB &00               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &01               \ Faces data offset (high) = &
 EQUB &00               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

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

 EQUB &1F, &01, &00, &04
 EQUB &1F, &02, &04, &08
 EQUB &1F, &03, &08, &0C
 EQUB &1F, &04, &0C, &10
 EQUB &1F, &05, &10, &00
 EQUB &1F, &16, &14, &28
 EQUB &1F, &17, &28, &18
 EQUB &1F, &27, &18, &2C
 EQUB &1F, &28, &2C, &1C
 EQUB &1F, &38, &1C, &30
 EQUB &1F, &39, &30, &20
 EQUB &1F, &49, &20, &34
 EQUB &1F, &4A, &34, &24
 EQUB &1F, &5A, &24, &38
 EQUB &1F, &56, &38, &14
 EQUB &1F, &7B, &3C, &40
 EQUB &1F, &8B, &40, &44
 EQUB &1F, &9B, &44, &48
 EQUB &1F, &AB, &48, &4C
 EQUB &1F, &6B, &4C, &3C
 EQUB &1F, &15, &00, &14
 EQUB &1F, &12, &04, &18
 EQUB &1F, &23, &08, &1C
 EQUB &1F, &34, &0C, &20
 EQUB &1F, &45, &10, &24
 EQUB &1F, &67, &28, &3C
 EQUB &1F, &78, &2C, &40
 EQUB &1F, &89, &30, &44
 EQUB &1F, &9A, &34, &48
 EQUB &1F, &6A, &38, &4C
 EQUB &1E, &00, &50, &54
 EQUB &14, &00, &54, &5C
 EQUB &17, &00, &5C, &58
 EQUB &14, &00, &58, &50

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
