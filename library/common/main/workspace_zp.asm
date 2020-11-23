\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0000 to &00B0
\   Category: Workspaces
\    Summary: Lots of important variables are stored in the zero page workspace
\             as it is quicker and more space-efficient to access memory here
\  Deep dive: The Elite memory map
\
\ ******************************************************************************

ORG &0000

.ZP

 SKIP 0                 \ The start of the zero page workspace

INCLUDE "library/common/main/variable_rand.asm"

IF _CASSETTE_VERSION

INCLUDE "library/cassette/main/variable_trtb_per_cent.asm"

ENDIF

INCLUDE "library/common/main/variable_t1.asm"
INCLUDE "library/common/main/variable_sc.asm"
INCLUDE "library/common/main/variable_sch.asm"
INCLUDE "library/common/main/variable_xx16.asm"
INCLUDE "library/common/main/variable_p.asm"

IF _6502SP_VERSION

INCLUDE "library/6502sp/main/variable_needkey.asm"

ENDIF

INCLUDE "library/common/main/variable_xx0.asm"
INCLUDE "library/common/main/variable_inf.asm"
INCLUDE "library/common/main/variable_v.asm"
INCLUDE "library/common/main/variable_xx.asm"
INCLUDE "library/common/main/variable_yy.asm"
INCLUDE "library/common/main/variable_sunx.asm"
INCLUDE "library/common/main/variable_beta.asm"
INCLUDE "library/common/main/variable_bet1.asm"
INCLUDE "library/common/main/variable_xc.asm"
INCLUDE "library/common/main/variable_yc.asm"
INCLUDE "library/common/main/variable_qq22.asm"
INCLUDE "library/common/main/variable_ecma.asm"

IF _6502SP_VERSION

INCLUDE "library/common/main/variable_alp1.asm"
INCLUDE "library/common/main/variable_alp2.asm"

ENDIF

INCLUDE "library/common/main/variable_xx15.asm"
INCLUDE "library/common/main/variable_x1.asm"
INCLUDE "library/common/main/variable_y1.asm"
INCLUDE "library/common/main/variable_x2.asm"
INCLUDE "library/common/main/variable_y2.asm"
INCLUDE "library/common/main/variable_xx12.asm"
INCLUDE "library/common/main/variable_k.asm"

IF _CASSETTE_VERSION

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

ENDIF

INCLUDE "library/common/main/variable_las.asm"
INCLUDE "library/common/main/variable_mstg.asm"
INCLUDE "library/common/main/variable_xx1.asm"
INCLUDE "library/common/main/variable_inwk.asm"
INCLUDE "library/common/main/variable_xx19.asm"

IF _6502SP_VERSION

INCLUDE "library/6502sp/main/variable_newb.asm"

ENDIF

INCLUDE "library/common/main/variable_lsp.asm"
INCLUDE "library/common/main/variable_qq15.asm"
INCLUDE "library/common/main/variable_k5.asm"
INCLUDE "library/common/main/variable_xx18.asm"
INCLUDE "library/common/main/variable_qq17.asm"

INCLUDE "library/common/main/variable_qq19.asm"
INCLUDE "library/common/main/variable_k6.asm"

IF _CASSETTE_VERSION

INCLUDE "library/common/main/variable_alp1.asm"
INCLUDE "library/common/main/variable_alp2.asm"

ENDIF

INCLUDE "library/common/main/variable_bet2.asm"
INCLUDE "library/common/main/variable_delta.asm"
INCLUDE "library/common/main/variable_delt4.asm"
INCLUDE "library/common/main/variable_u.asm"
INCLUDE "library/common/main/variable_q.asm"
INCLUDE "library/common/main/variable_r.asm"
INCLUDE "library/common/main/variable_s.asm"
INCLUDE "library/common/main/variable_xsav.asm"
INCLUDE "library/common/main/variable_ysav.asm"
INCLUDE "library/common/main/variable_xx17.asm"
INCLUDE "library/common/main/variable_qq11.asm"
INCLUDE "library/common/main/variable_zz.asm"
INCLUDE "library/common/main/variable_xx13.asm"
INCLUDE "library/common/main/variable_mcnt.asm"
INCLUDE "library/common/main/variable_dl.asm"
INCLUDE "library/common/main/variable_type.asm"

IF _CASSETTE_VERSION

INCLUDE "library/common/main/variable_jstx.asm"
INCLUDE "library/common/main/variable_jsty.asm"

ENDIF

INCLUDE "library/common/main/variable_alpha.asm"

IF _6502SP_VERSION

INCLUDE "library/6502sp/main/variable_pbup.asm"
INCLUDE "library/6502sp/main/variable_hbup.asm"
INCLUDE "library/6502sp/main/variable_lbup.asm"

ENDIF

INCLUDE "library/common/main/variable_qq12.asm"
INCLUDE "library/common/main/variable_tgt.asm"

IF _CASSETTE_VERSION

INCLUDE "library/common/main/variable_swap.asm"

ENDIF

INCLUDE "library/common/main/variable_col.asm"
INCLUDE "library/common/main/variable_flag.asm"
INCLUDE "library/common/main/variable_cnt.asm"
INCLUDE "library/common/main/variable_cnt2.asm"
INCLUDE "library/common/main/variable_stp.asm"
INCLUDE "library/common/main/variable_xx4.asm"
INCLUDE "library/common/main/variable_xx20.asm"
INCLUDE "library/common/main/variable_xx14.asm"
INCLUDE "library/common/main/variable_rat.asm"
INCLUDE "library/common/main/variable_rat2.asm"
INCLUDE "library/common/main/variable_k2.asm"

IF _6502SP_VERSION

INCLUDE "library/6502sp/main/variable_widget.asm"
INCLUDE "library/6502sp/main/variable_safehouse.asm"
INCLUDE "library/6502sp/main/variable_messxc.asm"

ENDIF

ORG &D1

INCLUDE "library/common/main/variable_t.asm"
INCLUDE "library/common/main/variable_k3.asm"
INCLUDE "library/common/main/variable_xx2.asm"
INCLUDE "library/common/main/variable_k4.asm"

PRINT "Zero page variables from ", ~ZP, " to ", ~P%

