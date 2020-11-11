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

INCLUDE "library/common/main/workspace_variable_frin.asm"
INCLUDE "library/common/main/workspace_variable_cabtmp.asm"
INCLUDE "library/common/main/workspace_variable_many-sspr.asm"
INCLUDE "library/common/main/workspace_variable_ecmp-de.asm"
INCLUDE "library/common/main/workspace_variable_lsx-lso.asm"
INCLUDE "library/common/main/workspace_variable_lsx2-lsy2.asm"
INCLUDE "library/common/main/workspace_variable_sy-sxl.asm"
INCLUDE "library/common/main/workspace_variable_xsav2-ysav2.asm"
INCLUDE "library/common/main/workspace_variable_mch-energy.asm"
INCLUDE "library/common/main/workspace_variable_lasx-lasy.asm"
INCLUDE "library/common/main/workspace_variable_comx-tek.asm"
INCLUDE "library/common/main/workspace_variable_slsp.asm"
INCLUDE "library/common/main/workspace_variable_xx24-altit.asm"
INCLUDE "library/common/main/workspace_variable_qq2-nostm.asm"

ELIF _6502SP_VERSION

INCLUDE "library/common/main/workspace_variable_lsx-lso.asm"
INCLUDE "library/common/main/workspace_variable_sx-sxl.asm"
INCLUDE "library/common/main/workspace_variable_sy-sxl.asm"
INCLUDE "library/common/main/workspace_variable_lasx-lasy.asm"
INCLUDE "library/common/main/workspace_variable_xx24-altit.asm"
INCLUDE "library/common/main/workspace_variable_swap.asm"

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

