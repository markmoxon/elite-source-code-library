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
NTY = 34
D% = &D000
E% = D%+2*NTY
LS% = D%-1
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

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ Produces the binary file WORDS.bin that gets loaded by elite-loader.asm.
\
\ The recursive token table is loaded at &81B0 and is moved down to &0400 as
\ part of elite-loader2.asm. The table binary also includes the sine and arctan
\ tables, so the three parts end up as follows:
\
\   * Recursive token table:    QQ18 = &0400 to &07C0
\   * Sine lookup table:        SNE  = &07C0 to &07DF
\   * Arctan lookup table:      ACT  = &07E0 to &07FF
\
\ ******************************************************************************

CODE_WORDS% = &0400
LOAD_WORDS% = &81B0

ORG CODE_WORDS%

INCLUDE "library/common/main/macro_char.asm"
INCLUDE "library/common/main/macro_twok.asm"
INCLUDE "library/common/main/macro_ctrl.asm"
INCLUDE "library/common/main/macro_rtok.asm"
INCLUDE "library/common/main/variable_qq18.asm"
INCLUDE "library/common/main/variable_sne.asm"
INCLUDE "library/common/main/variable_act.asm"

\ ******************************************************************************
\
\ Save output/WORDS9.bin
\
\ ******************************************************************************

PRINT "WORDS"
PRINT "Assembled at ", ~CODE_WORDS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_WORDS%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_WORDS%

PRINT "S.WORDS ",~CODE%," ",~P%," ",~LOAD%," ",~LOAD_WORDS%
SAVE "6502sp/output/WORDS.bin", CODE_WORDS%, P%, LOAD%

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
INCLUDE "library/common/main/variable_comc.asm"
INCLUDE "library/common/main/variable_dnoiz.asm"
INCLUDE "library/common/main/variable_damp.asm"
INCLUDE "library/common/main/variable_djd.asm"
INCLUDE "library/common/main/variable_patg.asm"
INCLUDE "library/common/main/variable_flh.asm"
INCLUDE "library/common/main/variable_jstgy.asm"
INCLUDE "library/common/main/variable_jste.asm"
INCLUDE "library/common/main/variable_jstk.asm"
INCLUDE "library/6502sp/main/variable_bstk.asm"
INCLUDE "library/6502sp/main/variable_catf.asm"
INCLUDE "library/6502sp/main/variable_zip.asm"
INCLUDE "library/6502sp/main/variable_s1_per_cent.asm"
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
INCLUDE "library/6502sp/main/variable_tkn2.asm"
INCLUDE "library/common/main/variable_qq16.asm"
INCLUDE "library/6502sp/main/variable_shpcol.asm"
INCLUDE "library/6502sp/main/variable_scacol.asm"
INCLUDE "library/common/main/variable_lsx2.asm"
INCLUDE "library/common/main/variable_lsy2.asm"

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
INCLUDE "library/6502sp/main/variable_pixbl.asm"
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
INCLUDE "library/6502sp/main/variable_dtw1.asm"
INCLUDE "library/6502sp/main/variable_dtw2.asm"
INCLUDE "library/6502sp/main/variable_dtw3.asm"
INCLUDE "library/6502sp/main/variable_dtw4.asm"
INCLUDE "library/6502sp/main/variable_dtw5.asm"
INCLUDE "library/6502sp/main/variable_dtw6.asm"
INCLUDE "library/6502sp/main/variable_dtw8.asm"
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
INCLUDE "library/common/main/subroutine_hy6-docked.asm"
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
INCLUDE "library/common/main/subroutine_circle2-circle3.asm"
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
INCLUDE "library/6502sp/main/subroutine_savscr.asm"
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

INCLUDE "library/6502sp/main/variable_log.asm"
INCLUDE "library/6502sp/main/variable_logl.asm"
INCLUDE "library/6502sp/main/variable_antilog.asm"
INCLUDE "library/6502sp/main/variable_antilogodd.asm"
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
INCLUDE "library/6502sp/main/variable_scanpars.asm"
INCLUDE "library/6502sp/main/variable_scanflg.asm"
INCLUDE "library/6502sp/main/variable_scanlen.asm"
INCLUDE "library/6502sp/main/variable_scancol.asm"
INCLUDE "library/6502sp/main/variable_scanx1.asm"
INCLUDE "library/6502sp/main/variable_scany1.asm"
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

INCLUDE "library/6502sp/main/macro_ejmp.asm"
INCLUDE "library/6502sp/main/macro_echr.asm"
INCLUDE "library/6502sp/main/macro_etok.asm"
INCLUDE "library/6502sp/main/macro_etwo.asm"
INCLUDE "library/6502sp/main/macro_ernd.asm"
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
INCLUDE "library/6502sp/main/variable_ship_plate.asm"
INCLUDE "library/common/main/variable_ship_canister.asm"
INCLUDE "library/6502sp/main/variable_ship_boulder.asm"
INCLUDE "library/common/main/variable_ship_asteroid.asm"
INCLUDE "library/6502sp/main/variable_ship_splinter.asm"
INCLUDE "library/6502sp/main/variable_ship_shuttle.asm"
INCLUDE "library/6502sp/main/variable_ship_transporter.asm"
INCLUDE "library/common/main/variable_ship_cobra_mk_iii.asm"
INCLUDE "library/common/main/variable_ship_python.asm"
INCLUDE "library/6502sp/main/variable_ship_boa.asm"
INCLUDE "library/6502sp/main/variable_ship_anaconda.asm"
INCLUDE "library/6502sp/main/variable_ship_rock_hermit.asm"
INCLUDE "library/common/main/variable_ship_viper.asm"
INCLUDE "library/common/main/variable_ship_sidewinder.asm"
INCLUDE "library/common/main/variable_ship_mamba.asm"
INCLUDE "library/6502sp/main/variable_ship_krait.asm"
INCLUDE "library/6502sp/main/variable_ship_adder.asm"
INCLUDE "library/6502sp/main/variable_ship_gecko.asm"
INCLUDE "library/6502sp/main/variable_ship_cobra_mk_i.asm"
INCLUDE "library/6502sp/main/variable_ship_worm.asm"
INCLUDE "library/6502sp/main/variable_ship_cobra_mk_iii_pirate.asm"
INCLUDE "library/6502sp/main/variable_ship_asp_mk_ii.asm"

 EQUB &38, &E5          \ This data appears to be unused
 EQUB &2C, &C5

INCLUDE "library/6502sp/main/variable_ship_python_pirate.asm"
INCLUDE "library/6502sp/main/variable_ship_fer_de_lance.asm"
INCLUDE "library/6502sp/main/variable_ship_moray.asm"
INCLUDE "library/common/main/variable_ship_thargoid.asm"
INCLUDE "library/common/main/variable_ship_thargon.asm"
INCLUDE "library/6502sp/main/variable_ship_constrictor.asm"
INCLUDE "library/6502sp/main/variable_ship_logo.asm"
INCLUDE "library/6502sp/main/variable_ship_cougar.asm"
INCLUDE "library/6502sp/main/variable_ship_dodo.asm"

 EQUB &A9, &80          \ This data appears to be unused
 EQUB &14, &2B
 EQUB &20, &FD
 EQUB &B8, &90
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
