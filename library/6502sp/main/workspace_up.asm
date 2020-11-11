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

INCLUDE "library/common/main/workspace_variable_kl.asm"
INCLUDE "library/common/main/workspace_variable_frin.asm"
INCLUDE "library/common/main/workspace_variable_many-sspr.asm"

.JUNK

 SKIP 1

.auto

 SKIP 1

INCLUDE "library/common/main/workspace_variable_ecmp-de.asm"
INCLUDE "library/common/main/workspace_variable_jstx-jsty.asm"
INCLUDE "library/common/main/workspace_variable_xsav2-ysav2.asm"

.NAME

 SKIP 8

INCLUDE "library/common/main/workspace_variable_tp-svc.asm"
INCLUDE "library/common/main/workspace_variable_mch-energy.asm"
INCLUDE "library/common/main/workspace_variable_comx-tek.asm"
INCLUDE "library/common/main/workspace_variable_slsp.asm"
INCLUDE "library/common/main/workspace_variable_qq2-nostm.asm"

.BUF

 SKIP 100