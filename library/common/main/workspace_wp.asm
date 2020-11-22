\ ******************************************************************************
\
\       Name: WP
\       Type: Workspace
IF _CASSETTE_VERSION
\    Address: &0D40 to &0F34
ELIF _6502SP_VERSION
\    Address: &0D00
ENDIF
\   Category: Workspaces
\    Summary: Ship slots, variables
\
\ ******************************************************************************

IF _CASSETTE_VERSION

ORG &0D40

ELIF _6502SP_VERSION

ORG &0D00

ENDIF

.WP

 SKIP 0                 \ The start of the WP workspace

IF _CASSETTE_VERSION

INCLUDE "library/common/main/variable_frin.asm"
INCLUDE "library/common/main/variable_cabtmp.asm"
INCLUDE "library/common/main/variable_many.asm"
INCLUDE "library/common/main/variable_sspr.asm"
INCLUDE "library/common/main/variable_ecmp.asm"
INCLUDE "library/common/main/variable_mj.asm"
INCLUDE "library/common/main/variable_las2.asm"
INCLUDE "library/common/main/variable_msar.asm"
INCLUDE "library/common/main/variable_view.asm"
INCLUDE "library/common/main/variable_lasct.asm"
INCLUDE "library/common/main/variable_gntmp.asm"
INCLUDE "library/common/main/variable_hfx.asm"
INCLUDE "library/common/main/variable_ev.asm"
INCLUDE "library/common/main/variable_dly.asm"
INCLUDE "library/common/main/variable_de.asm"
INCLUDE "library/common/main/variable_lsx.asm"
INCLUDE "library/common/main/variable_lso.asm"
INCLUDE "library/common/main/variable_lsx2.asm"
INCLUDE "library/common/main/variable_lsy2.asm"
INCLUDE "library/common/main/variable_sy.asm"
INCLUDE "library/common/main/variable_syl.asm"
INCLUDE "library/common/main/variable_sz.asm"
INCLUDE "library/common/main/variable_szl.asm"
INCLUDE "library/common/main/variable_xsav2.asm"
INCLUDE "library/common/main/variable_ysav2.asm"
INCLUDE "library/common/main/variable_mch.asm"
INCLUDE "library/common/main/variable_fsh.asm"
INCLUDE "library/common/main/variable_ash.asm"
INCLUDE "library/common/main/variable_energy.asm"
INCLUDE "library/common/main/variable_lasx.asm"
INCLUDE "library/common/main/variable_lasy.asm"
INCLUDE "library/common/main/variable_comx.asm"
INCLUDE "library/common/main/variable_comy.asm"
INCLUDE "library/common/main/variable_qq24.asm"
INCLUDE "library/common/main/variable_qq25.asm"
INCLUDE "library/common/main/variable_qq28.asm"
INCLUDE "library/common/main/variable_qq29.asm"
INCLUDE "library/common/main/variable_gov.asm"
INCLUDE "library/common/main/variable_tek.asm"
INCLUDE "library/common/main/variable_slsp.asm"
INCLUDE "library/common/main/variable_xx24.asm"
INCLUDE "library/common/main/variable_altit.asm"
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

ELIF _6502SP_VERSION

INCLUDE "library/common/main/variable_lsx.asm"
INCLUDE "library/common/main/variable_lso.asm"
INCLUDE "library/common/main/variable_sx.asm"
INCLUDE "library/common/main/variable_sxl.asm"
INCLUDE "library/common/main/variable_sy.asm"
INCLUDE "library/common/main/variable_syl.asm"
INCLUDE "library/common/main/variable_sz.asm"
INCLUDE "library/common/main/variable_szl.asm"
INCLUDE "library/common/main/variable_lasx.asm"
INCLUDE "library/common/main/variable_lasy.asm"
INCLUDE "library/common/main/variable_xx24.asm"
INCLUDE "library/common/main/variable_altit.asm"
INCLUDE "library/common/main/variable_swap.asm"

.XP

 SKIP 1

.YP

 SKIP 1

.YS

 SKIP 1

.BALI

 SKIP 1

.UPO

 SKIP 1

ENDIF

PRINT "WP workspace from  ", ~WP," to ", ~P%

