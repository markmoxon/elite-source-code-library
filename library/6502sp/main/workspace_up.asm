\ ******************************************************************************
\
\       Name: UP
\       Type: Workspace
\    Address: &0800
\   Category: Workspaces
\
\ ******************************************************************************

ORG &0800

.UP

 SKIP 0

\.QQ16 \Repeated below

 SKIP 65

INCLUDE "library/common/main/variable_kl.asm"
INCLUDE "library/common/main/variable_ky1.asm"
INCLUDE "library/common/main/variable_ky2.asm"
INCLUDE "library/common/main/variable_ky3.asm"
INCLUDE "library/common/main/variable_ky4.asm"
INCLUDE "library/common/main/variable_ky5.asm"
INCLUDE "library/common/main/variable_ky6.asm"
INCLUDE "library/common/main/variable_ky7.asm"
INCLUDE "library/common/main/variable_ky12.asm"
INCLUDE "library/common/main/variable_ky13.asm"
INCLUDE "library/common/main/variable_ky14.asm"
INCLUDE "library/common/main/variable_ky15.asm"
INCLUDE "library/common/main/variable_ky16.asm"
INCLUDE "library/common/main/variable_ky17.asm"
INCLUDE "library/common/main/variable_ky18.asm"
INCLUDE "library/common/main/variable_ky19.asm"
INCLUDE "library/6502sp/main/variable_ky20.asm"
INCLUDE "library/common/main/variable_frin.asm"
INCLUDE "library/common/main/variable_many.asm"
INCLUDE "library/common/main/variable_sspr.asm"

.JUNK

 SKIP 1

.auto

 SKIP 1

INCLUDE "library/common/main/variable_ecmp.asm"
INCLUDE "library/common/main/variable_mj.asm"
INCLUDE "library/common/main/variable_cabtmp.asm"
INCLUDE "library/common/main/variable_las2.asm"
INCLUDE "library/common/main/variable_msar.asm"
INCLUDE "library/common/main/variable_view.asm"
INCLUDE "library/common/main/variable_lasct.asm"
INCLUDE "library/common/main/variable_gntmp.asm"
INCLUDE "library/common/main/variable_hfx.asm"
INCLUDE "library/common/main/variable_ev.asm"
INCLUDE "library/common/main/variable_dly.asm"
INCLUDE "library/common/main/variable_de.asm"
INCLUDE "library/common/main/variable_jstx.asm"
INCLUDE "library/common/main/variable_jsty.asm"
INCLUDE "library/common/main/variable_xsav2.asm"
INCLUDE "library/common/main/variable_ysav2.asm"

.NAME

 SKIP 8

INCLUDE "library/common/main/variable_tp.asm"
INCLUDE "library/common/main/variable_qq0.asm"
INCLUDE "library/common/main/variable_qq1.asm"
INCLUDE "library/common/main/variable_qq21.asm"
INCLUDE "library/common/main/variable_cash.asm"
INCLUDE "library/common/main/variable_qq14.asm"
INCLUDE "library/common/main/variable_cok.asm"
INCLUDE "library/common/main/variable_gcnt.asm"
INCLUDE "library/common/main/variable_laser.asm"

 SKIP 2                 \ These bytes are unused (they were originally used for
                        \ up/down lasers, but they were dropped)

INCLUDE "library/common/main/variable_crgo.asm"
INCLUDE "library/common/main/variable_qq20.asm"
INCLUDE "library/common/main/variable_ecm.asm"
INCLUDE "library/common/main/variable_bst.asm"
INCLUDE "library/common/main/variable_bomb.asm"
INCLUDE "library/common/main/variable_engy.asm"
INCLUDE "library/common/main/variable_dkcmp.asm"
INCLUDE "library/common/main/variable_ghyp.asm"
INCLUDE "library/common/main/variable_escp.asm"

 SKIP 4                 \ These bytes are unused

INCLUDE "library/common/main/variable_nomsl.asm"
INCLUDE "library/common/main/variable_fist.asm"
INCLUDE "library/common/main/variable_avl.asm"
INCLUDE "library/common/main/variable_qq26.asm"
INCLUDE "library/common/main/variable_tally.asm"
INCLUDE "library/common/main/variable_svc.asm"
INCLUDE "library/common/main/variable_mch.asm"
INCLUDE "library/common/main/variable_fsh.asm"
INCLUDE "library/common/main/variable_ash.asm"
INCLUDE "library/common/main/variable_energy.asm"
INCLUDE "library/common/main/variable_comx.asm"
INCLUDE "library/common/main/variable_comy.asm"
INCLUDE "library/common/main/variable_qq24.asm"
INCLUDE "library/common/main/variable_qq25.asm"
INCLUDE "library/common/main/variable_qq28.asm"
INCLUDE "library/common/main/variable_qq29.asm"
INCLUDE "library/common/main/variable_gov.asm"
INCLUDE "library/common/main/variable_tek.asm"
INCLUDE "library/common/main/variable_slsp.asm"
INCLUDE "library/common/main/variable_qq2.asm"
INCLUDE "library/common/main/variable_qq3.asm"
INCLUDE "library/common/main/variable_qq4.asm"
INCLUDE "library/common/main/variable_qq5.asm"
INCLUDE "library/common/main/variable_qq6.asm"
INCLUDE "library/common/main/variable_qq7.asm"
INCLUDE "library/common/main/variable_qq8.asm"
INCLUDE "library/common/main/variable_qq9.asm"
INCLUDE "library/common/main/variable_qq10.asm"
INCLUDE "library/common/main/variable_nostm.asm"

.BUF

 SKIP 100