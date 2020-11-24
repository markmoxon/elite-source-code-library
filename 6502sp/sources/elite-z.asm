\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE GAME SOURCE (I/O PROCESSOR)
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

_CASSETTE_VERSION       = TRUE AND (_VERSION = 1)
_DISC_VERSION           = TRUE AND (_VERSION = 2)
_6502SP_VERSION         = TRUE AND (_VERSION = 3)

CODE% = &2400
LOAD% = &2400
TABLE = &2300

C% = &2400
L% = C%
D% = &D000

Z = 0
XX15 = &90
X1 = XX15
Y1 = XX15+1
X2 = XX15+2
Y2 = XX15+3
SC = XX15+6
SCH = SC+1
OSTP = SC
FF = &FF
OSWRCH = &FFEE
OSBYTE = &FFF4
OSWORD = &FFF1
OSFILE = &FFDD
SCLI = &FFF7
SHEILA = &FE00
VIA = &FE40
USVIA = VIA
IRQ1V = &204
VSCAN = 57
XX21 = D%
WRCHV = &20E
WORDV = &20C
RDCHV = &210
NVOSWRCH = &FFCB
Tina = &B00
Y = 96
\protlen = 0
PARMAX = 15

\REMparameters expected by RDPARAMS
RED = &F0
WHITE = &FA
WHITE2 = &3F
RED2 = &3
YELLOW2 = &F
MAGNETA2 = &33
CYAN2 = &3C
BLUE2 = &30
GREEN2 = &C
STRIPE = &23

INCLUDE "library/6502sp/io/workspace_zp.asm"
INCLUDE "library/6502sp/io/workspace_font_per_cent.asm"
INCLUDE "library/6502sp/io/variable_log.asm"
INCLUDE "library/6502sp/io/variable_logl.asm"
INCLUDE "library/6502sp/io/variable_antilog.asm"
INCLUDE "library/6502sp/io/variable_antilogodd.asm"
INCLUDE "library/6502sp/io/variable_ylookup.asm"
INCLUDE "library/6502sp/io/variable_tvt3.asm"
INCLUDE "library/6502sp/io/variable_xc.asm"
INCLUDE "library/6502sp/io/variable_yc.asm"
INCLUDE "library/6502sp/io/variable_k3.asm"
INCLUDE "library/common/main/variable_u.asm"
INCLUDE "library/6502sp/io/variable_lintab.asm"
INCLUDE "library/6502sp/io/variable_linmax.asm"
INCLUDE "library/common/main/variable_ysav.asm"
INCLUDE "library/common/main/variable_svn.asm"
INCLUDE "library/6502sp/io/variable_parano.asm"
INCLUDE "library/common/main/variable_dl.asm"
INCLUDE "library/common/main/variable_vec.asm"
INCLUDE "library/common/main/variable_hfx.asm"
INCLUDE "library/6502sp/io/variable_catf.asm"
INCLUDE "library/common/main/variable_k.asm"
INCLUDE "library/6502sp/io/variable_params.asm"
INCLUDE "library/common/main/variable_energy.asm"
INCLUDE "library/common/main/variable_alp1.asm"
INCLUDE "library/6502sp/io/variable_alp2.asm"
INCLUDE "library/common/main/variable_beta.asm"
INCLUDE "library/common/main/variable_bet1.asm"
INCLUDE "library/common/main/variable_delta.asm"
INCLUDE "library/common/main/variable_altit.asm"
INCLUDE "library/common/main/variable_mcnt.asm"
INCLUDE "library/common/main/variable_fsh.asm"
INCLUDE "library/common/main/variable_ash.asm"
INCLUDE "library/common/main/variable_qq14.asm"
INCLUDE "library/common/main/variable_gntmp.asm"
INCLUDE "library/common/main/variable_cabtmp.asm"
INCLUDE "library/common/main/variable_flh.asm"
INCLUDE "library/common/main/variable_escp.asm"
INCLUDE "library/6502sp/io/variable_jmptab.asm"
INCLUDE "library/6502sp/io/subroutine_startup.asm"
INCLUDE "library/6502sp/io/subroutine_putback.asm"
INCLUDE "library/6502sp/io/subroutine_usoswrch.asm"
INCLUDE "library/common/main/subroutine_det1.asm"
INCLUDE "library/6502sp/io/subroutine_dofe21.asm"
INCLUDE "library/6502sp/io/subroutine_dohfx.asm"
INCLUDE "library/6502sp/io/subroutine_doviae.asm"
INCLUDE "library/6502sp/io/subroutine_docatf.asm"
INCLUDE "library/6502sp/io/subroutine_docol.asm"
INCLUDE "library/6502sp/io/subroutine_dosvn.asm"
INCLUDE "library/6502sp/io/subroutine_dobrk.asm"
INCLUDE "library/6502sp/io/subroutine_printer.asm"
INCLUDE "library/6502sp/io/subroutine_poswrch.asm"
INCLUDE "library/6502sp/io/subroutine_tosend.asm"
INCLUDE "library/6502sp/io/subroutine_prilf.asm"
INCLUDE "library/6502sp/io/subroutine_dobulb.asm"
INCLUDE "library/6502sp/io/subroutine_ecblb.asm"
INCLUDE "library/common/main/variable_spbt.asm"
INCLUDE "library/common/main/variable_ecbt.asm"
INCLUDE "library/6502sp/io/subroutine_dot.asm"
INCLUDE "library/common/main/subroutine_cpix4.asm"
INCLUDE "library/common/main/subroutine_cpix2.asm"
INCLUDE "library/6502sp/io/subroutine_sc48.asm"
INCLUDE "library/6502sp/io/subroutine_beginlin.asm"
INCLUDE "library/6502sp/io/subroutine_addbyt.asm"
INCLUDE "library/6502sp/io/variable_twos.asm"
INCLUDE "library/6502sp/io/variable_twos2.asm"
INCLUDE "library/6502sp/io/variable_ctwos.asm"
INCLUDE "library/6502sp/io/subroutine_hloin2.asm"
INCLUDE "library/6502sp/io/subroutine_loin.asm"
INCLUDE "library/6502sp/io/subroutine_hloin.asm"
INCLUDE "library/6502sp/io/variable_twfl.asm"
INCLUDE "library/6502sp/io/variable_twfr.asm"
INCLUDE "library/6502sp/io/variable_orange.asm"
INCLUDE "library/6502sp/io/subroutine_pixel.asm"
INCLUDE "library/6502sp/io/variable_pxcl.asm"
INCLUDE "library/6502sp/io/subroutine_newosrdch.asm"
INCLUDE "library/common/main/subroutine_add.asm"
INCLUDE "library/6502sp/io/subroutine_hanger.asm"
INCLUDE "library/common/main/subroutine_dvid4.asm"
INCLUDE "library/6502sp/io/subroutine_adparams.asm"
INCLUDE "library/6502sp/io/subroutine_rdparams.asm"
INCLUDE "library/6502sp/io/macro_dks4.asm"
INCLUDE "library/6502sp/io/variable_kytb.asm"
INCLUDE "library/6502sp/io/subroutine_keyboard.asm"
INCLUDE "library/6502sp/io/variable_oswvecs.asm"
INCLUDE "library/6502sp/io/subroutine_nwoswd.asm"
INCLUDE "library/6502sp/io/subroutine_notours.asm"
INCLUDE "library/common/main/subroutine_msbar.asm"
INCLUDE "library/common/main/subroutine_wscan.asm"
INCLUDE "library/6502sp/io/subroutine_dodks4.asm"
INCLUDE "library/6502sp/io/subroutine_cls.asm"
INCLUDE "library/6502sp/io/subroutine_tt67.asm"
INCLUDE "library/common/main/subroutine_tt26.asm"
INCLUDE "library/6502sp/io/subroutine_ttx66.asm"
INCLUDE "library/common/main/subroutine_zes1.asm"
INCLUDE "library/common/main/subroutine_zes2.asm"
INCLUDE "library/6502sp/io/subroutine_setxc.asm"
INCLUDE "library/6502sp/io/subroutine_setyc.asm"
INCLUDE "library/6502sp/io/subroutine_someprot.asm"
INCLUDE "library/6502sp/io/subroutine_clyns.asm"
INCLUDE "library/common/main/subroutine_dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine_dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine_dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine_dials_part_4_of_4.asm"
INCLUDE "library/6502sp/io/subroutine_pzw2.asm"
INCLUDE "library/common/main/subroutine_pzw.asm"
INCLUDE "library/common/main/subroutine_dilx.asm"
INCLUDE "library/common/main/subroutine_dil2.asm"
INCLUDE "library/6502sp/io/variable_tvt1.asm"
INCLUDE "library/6502sp/io/subroutine_do65c02.asm"
INCLUDE "library/common/main/subroutine_irq1.asm"
INCLUDE "library/6502sp/io/subroutine_setvdu19.asm"

\ ******************************************************************************
\
\ Save output/I.CODE.bin
\
\ ******************************************************************************

PRINT "I.CODE"
PRINT "Assembled at ", ~CODE%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD%
PRINT "protlen = ", ~protlen

PRINT "S.I.CODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "6502sp/output/I.CODE.bin", CODE%, P%, LOAD%
