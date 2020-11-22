\ ******************************************************************************
\
\       Name: T%
\       Type: Workspace
\    Address: &0300 to &035F
\   Category: Workspaces
\    Summary: Current commander data and stardust data blocks
\
\ ------------------------------------------------------------------------------
\
\ Contains the current commander data (NT% bytes at location TP), and the
\ stardust data blocks (NOST bytes at location SX)
\
\ ******************************************************************************

ORG &0300

.T%

 SKIP 0                 \ The start of the T% workspace

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
INCLUDE "library/common/main/variable_sx.asm"
INCLUDE "library/common/main/variable_sxl.asm"

PRINT "T% workspace from  ", ~T%, " to ", ~P%

