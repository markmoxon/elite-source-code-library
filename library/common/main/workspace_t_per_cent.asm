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

INCLUDE "library/common/main/workspace_variable_tp-svc.asm"
INCLUDE "library/common/main/workspace_variable_sx-sxl.asm"

PRINT "T% workspace from  ", ~T%, " to ", ~P%

